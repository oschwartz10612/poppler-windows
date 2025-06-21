import pandas as pd
import fitz  # PyMuPDF
import pytesseract
from pdf2image import convert_from_path
import google.generativeai as genai

genai.configure(api_key="YOUR_GEMINI_API_KEY")  # Replace with your key

def extract_text(pdf_path):
    doc = fitz.open(pdf_path)
    text = "".join(page.get_text() for page in doc)
    if not text.strip():
        images = convert_from_path(pdf_path, 300)
        text = pytesseract.image_to_string(images[0])
    return text

def get_structured_json(text):
    model = genai.GenerativeModel("gemini-1.5-pro")
    prompt = f"Extract invoice_number, date, total_amount as JSON from this:\n{text}"
    response = model.generate_content(
        contents=[prompt],
        config={'response_mime_type': 'application/json'}
    )
    return response.parsed if response.parsed else {}

def save_to_excel(data):
    df = pd.DataFrame([data])
    df.to_excel("Extracted_Invoice.xlsx", index=False)
    print("✅ Saved to Extracted_Invoice.xlsx")

# === Run It ===
text = extract_text("invoice.pdf")
json_data = get_structured_json(text)
save_to_excel(json_data)
