#!/bin/bash

cp $BUILD_PREFIX/lib/libgmp.so $BUILD_PREFIX/$BUILD/sysroot/usr/lib/
cp $PREFIX/lib/libgmp.so $BUILD_PREFIX/$HOST/sysroot/usr/lib/

#to fix problems with zlib
export C_INCLUDE_PATH=$C_INCLUDE_PATH:${PREFIX}/include
ls ${PREFIX}/include
echo "---------------------"
ls ${BUILD_PREFIX}/include
echo "-------"
ls ${BUILD_PREFIX}/lib
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:${PREFIX}/include
export LIBRARY_PATH=$LIBRARY_PATH:${PREFIX}/lib
ls ${PREFIX}/lib 
echo "-------------------------"
export LD_LIBRARY_PATH="${PREFIX}/lib"

export LDFLAGS="-L${PREFIX}/lib"
export CPPFLAGS="-I${PREFIX}/include"


#./prepare --yes
#./configure --prefix=$PREFIX
mkdir build
cd build
#cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DCMAKE_BUILD_TYPE=Release -DSWIPL_PACKAGES_ODBC=OFF -DSWIPL_PACKAGES_JAVA=OFF  ..
#cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DCMAKE_BUILD_TYPE=Release ..
cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DCMAKE_BUILD_TYPE=Release -DUSE_GMP=OFF -DSWIPL_PACKAGES_ODBC=OFF -DSWIPL_PACKAGES_JAVA=OFF -DSWIPL_PACKAGES_X=OFF -DINSTALL_DOCUMENTATION=OFF ..
#cmake --prefix=$PREFIX $BUILD_PREFIX
make VERBOSE=1 -j${CPU_COUNT}
make install -j${CPU_COUNT}
#curdir=${PWD}
#for package in packages/*; do
#    echo "Package: $package"
#    cd $curdir/$package && ./configure --prefix=$PREFIX && make && (make install || true)
#done

