cd ./cross-compiler/binutils

mkdir build-binutils
cd build-binutils

../binutils-2.34/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install