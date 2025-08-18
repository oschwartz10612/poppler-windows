POPPLER_VERSION=25.07.0
POPPLER_DATA_URL="https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz"
BUILD="0"

set -e
set -o pipefail

mkdir "poppler-$POPPLER_VERSION"
cd "poppler-$POPPLER_VERSION" || exit

cp -a "$PKGS_PATH_DIR"/poppler-$POPPLER_VERSION*/Library/ .
cp "$PKGS_PATH_DIR"/libfreetype6*/Library/bin/freetype.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/libzlib*/Library/bin/zlib.dll ./Library/bin/
cp -a "$PKGS_PATH_DIR"/zstd*/Library/bin/. ./Library/bin/
cp "$PKGS_PATH_DIR"/libtiff*/Library/bin/tiff.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/libtiff*/Library/bin/libtiff.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/libssh2*/Library/bin/libssh2.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/libpng*/Library/bin/libpng16.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/libcurl*/Library/bin/libcurl.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/openssl*/Library/bin/libcrypto-3-x64.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/openjpeg*/Library/bin/openjp2.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/libjpeg-turbo*/Library/bin/jpeg8.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/liblzma*/Library/bin/liblzma.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/cairo*/Library/bin/cairo.dll ./Library/bin/
# cp "$PKGS_PATH_DIR"/libdeflate*/Library/bin/libdeflate.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/libdeflate*/Library/bin/deflate.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/lerc*/Library/bin/Lerc.dll ./Library/bin/
# cp "$PKGS_PATH_DIR"/jbig*/Library/bin/jbig.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/lcms2*/Library/bin/lcms2.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/fontconfig*/Library/bin/fontconfig-1.dll ./Library/bin/
# cp "$PKGS_PATH_DIR"/expat*/Library/bin/libexpat.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/expat*/Library/bin/expat.dll ./Library/bin/
cp "$PKGS_PATH_DIR"/expat*/Library/bin/expat.dll ./Library/bin/libexpat.dll
cp -a "$PKGS_PATH_DIR"/libiconv*/Library/bin/. ./Library/bin/
cp "$PKGS_PATH_DIR"/pixman*/Library/bin/*.dll ./Library/bin/

rm -rf "$PKGS_PATH_DIR"

mkdir -p share/poppler
cd share || exit
curl $POPPLER_DATA_URL --output poppler-data.tar.gz
tar xvzf poppler-data.tar.gz -C poppler --strip-components 1
rm poppler-data.tar.gz

echo "POPPLER_VERSION=$POPPLER_VERSION" >> "$GITHUB_ENV"
echo "BUILD=$BUILD" >> "$GITHUB_ENV"
