POPPLER_VERSION=26.07.0
POPPLER_DATA_URL="https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz"
BUILD="0"

set -e
set -o pipefail

mkdir "poppler-$POPPLER_VERSION"
cd "poppler-$POPPLER_VERSION" || exit

cp -a "$PKGS_PATH_DIR"/poppler-$POPPLER_VERSION*/Library/ .

# Bundle DLLs from the resolved environment instead of maintaining a brittle
# list of transitive packages. GitHub's Windows bash needs a POSIX path.
CONDA_PREFIX_DIR="$(cygpath --unix "$CONDA_PREFIX")"
cp "$CONDA_PREFIX_DIR"/Library/bin/*.dll ./Library/bin/

rm -rf "$PKGS_PATH_DIR"

mkdir -p share/poppler
cd share || exit
curl $POPPLER_DATA_URL --output poppler-data.tar.gz
tar xvzf poppler-data.tar.gz -C poppler --strip-components 1
rm poppler-data.tar.gz

echo "POPPLER_VERSION=$POPPLER_VERSION" >> "$GITHUB_ENV"
echo "BUILD=$BUILD" >> "$GITHUB_ENV"
