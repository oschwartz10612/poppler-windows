POPPLER_VERSION=20.12.1

mkdir "poppler-$POPPLER_VERSION"
cd "poppler-$POPPLER_VERSION"

cp -a $PKGS_PATH_DIR/poppler-$POPPLER_VERSION*/Library/. .
cp $PKGS_PATH_DIR/freetype*/Library/bin/freetype.dll ./bin/
cp $PKGS_PATH_DIR/zlib*/Library/bin/zlib.dll ./bin/
cp -a $PKGS_PATH_DIR/zstd*/Library/bin/. ./bin/
cp $PKGS_PATH_DIR/libtiff*/Library/bin/tiff.dll ./bin/
cp $PKGS_PATH_DIR/libtiff*/Library/bin/libtiff.dll ./bin/
cp $PKGS_PATH_DIR/libssh2*/Library/bin/libssh2.dll ./bin/
cp $PKGS_PATH_DIR/libpng*/Library/bin/libpng16.dll ./bin/
cp $PKGS_PATH_DIR/libcurl*/Library/bin/libcurl.dll ./bin/
cp $PKGS_PATH_DIR/openssl*/Library/bin/libcrypto-1_1-x64.dll ./bin/
cp $PKGS_PATH_DIR/openjpeg*/Library/bin/openjp2.dll ./bin/
cp $PKGS_PATH_DIR/xz*/Library/bin/liblzma.dll ./bin/
cp $PKGS_PATH_DIR/cairo*/Library/bin/cairo.dll ./bin/

cd ./share/
mkdir poppler
cp -a $HOME/poppler-data*/. ./

echo "POPPLER_VERSION=$POPPLER_VERSION" >> $GITHUB_ENV


