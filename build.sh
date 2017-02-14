#!/bin/sh

if [ ! -d install ] ; then
    mkdir install
fi
INSTALL_DIR=`pwd`/install
# Pick up the local cmake
export PATH=$PATH:/c/Program\ Files/CMake/bin

# pick up cmd.exe 
export PATH=$PATH:/c/Windows/System32


build_package() {
    echo ---------------- $1 ---------------- 
    if [ ! -d $1/cmake_build ] ; then 
	echo mkdir $1/cmake_build
	mkdir $1/cmake_build
    fi
    pushd $1/cmake_build

    shift

    cmake -G "Visual Studio 12 2013 Win64" -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} $* ..
    cmake --build . --config Release > build_r.log
    cmake --build . --config Release --target install > install_r.log
    cmake --build . --config Debug > build_d.log
    cmake --build . --config Debug --target install> install_d.log

    popd
}

build_package zlib-1.2.11 
if [ ! -f ${INSTALL_DIR}/lib/zlib.lib ] ; then
    echo "zlib build failed"
    exit 1
fi


build_package libpng \
	      -DZLIB_INCLUDE_DIR=${INSTALL_DIR}/include \
	      -DZLIB_LIBRARY_DEBUG=${INSTALL_DIR}/lib/zlibd.lib \
	      -DZLIB_LIBRARY_RELEASE=${INSTALL_DIR}/lib/zlib.lib
if [ ! -f ${INSTALL_DIR}/lib/libpng16.lib ] ; then
    echo libpng build failed
    exit 1
fi


cmd "/c jpeg.bat"
if [ ! -f ${INSTALL_DIR}/lib/libjpeg.lib ] ; then
    echo jpeg build failed
    exit 1
fi
    
build_package libtiff \
	      -DZLIB_INCLUDE_DIR=${INSTALL_DIR}/include \
	      -DZLIB_LIBRARY_DEBUG=${INSTALL_DIR}/lib/zlibd.lib \
	      -DZLIB_LIBRARY_RELEASE=${INSTALL_DIR}/lib/zlib.lib \
	      -DJPEG_INCLUDE_DIR=${INSTALL_DIR}/include \
	      -DJPEG_LIBRARY=${INSTALL_DIR}/lib/libjpeg.lib
if [ ! -f ${INSTALL_DIR}/lib/tiff.lib ] ; then
    echo tiff build failed
    exit 1
    
fi
#glut 
#giflib 
build_package minizip \
	      -DZLIB_INCLUDE_DIR=${INSTALL_DIR}/include \
	      -DZLIB_LIBRARY_DEBUG=${INSTALL_DIR}/lib/zlibd.lib \
	      -DZLIB_LIBRARY_RELEASE=${INSTALL_DIR}/lib/zlib.lib

if [ ! -f ${INSTALL_DIR}/lib/minizip.lib ] ; then
    echo minizip build failed
    exit 1
fi

build_package curl \
	      -DZLIB_INCLUDE_DIR=${INSTALL_DIR}/include \
	      -DZLIB_LIBRARY_DEBUG=${INSTALL_DIR}/lib/zlibd.lib \
	      -DZLIB_LIBRARY_RELEASE=${INSTALL_DIR}/lib/zlib.lib

if [ ! -f ${INSTALL_DIR}/lib/libcurl_imp.lib ] ; then
    echo curl build failed
    exit 1
fi
		  

build_package proj4
if [ ! -f ${INSTALL_DIR}/lib/proj4.lib ] ; then
    echo proj4 build failed
    exit 1
fi


cmd "/c gdal.bat"
if [ ! -f ${INSTALL_DIR}/lib/gdal_i.lib ] ; then
    echo gdal build failed
    exit 1
fi

# ------ simage -----
if [ -d simage-1.7.0/build/msvc12 ] ; then
    rm -rf simage-1.7.0/build/msvc12
fi
tar xaf simage_vs2013.tar
cmd "/c simage.bat"
if [ ! -f ${INSTALL_DIR}/lib/simage1.lib ] ; then
    echo simage build failed
    exit 1
fi


# ------ coin -----
if [ ! -f Coin-3.1.3/build/msvc9/include/Inventor/system/inttypes.h.orig ] ; then
    echo patching Coin
    patch -b Coin-3.1.3/build/msvc9/include/Inventor/system/inttypes.h < coin.patch
    patch -b Coin-3.1.3/build/misc/build-docs.bat < coin_build-docs.patch
    tar xaf coin_buildUpgrade.tbz
fi
cmd "/c coin.bat"
if [ ! -f ${INSTALL_DIR}/lib/coin3.lib ] ; then
    echo coin3 build failed
    exit 1
fi

echo ---------------- $1 ---------------- 
if [ ! -d OpenSceneGraph-3.4.0/cmake_build ] ; then 
    echo mkdir OpenSceneGraph-3.4.0/cmake_build
    mkdir OpenSceneGraph-3.4.0/cmake_build
fi
pushd OpenSceneGraph-3.4.0/cmake_build

cmake -G "Visual Studio 12 2013 Win64" \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
      \
      -DZLIB_INCLUDE_DIR=${INSTALL_DIR}/include \
      -DZLIB_LIBRARY_DEBUG=${INSTALL_DIR}/lib/zlibd.lib \
      -DZLIB_LIBRARY_RELEASE=${INSTALL_DIR}/lib/zlib.lib \
      \
      -DTIFF_INCLUDE_DIR=${INSTALL_DIR}/include \
      -DTIFF_LIBRARY_DEBUG=${INSTALL_DIR}/lib/tiffd.lib \
      -DTIFF_LIBRARY_RELEASE=${INSTALL_DIR}/lib/tiff.lib \
      \
      -DCURL_INCLUDE_DIR=${INSTALL_DIR}/include \
      -DCURL_LIBRARY=${INSTALL_DIR}/lib/libcurl_imp.lib \
      \
      -DGDAL_INCLUDE_DIR=${INSTALL_DIR}/include \
      -DGDAL_LIBRARY=${INSTALL_DIR}/lib/gdal_i.lib \
      \
      -DINVENTOR_INCLUDE_DIR=${INSTALL_DIR}/include \
      -DINVENTOR_LIBRARY_DEBUG=${INSTALL_DIR}/lib/coin3d.lib \
      -DINVENTOR_LIBRARY_RELEASE=${INSTALL_DIR}/lib/coin3.lib \
      \
      -DJPEG_INCLUDE_DIR=${INSTALL_DIR}/include \
      -DJPEG_LIBRARY=${INSTALL_DIR}/lib/libjpeg.lib \
      \
      -DPNG_PNG_INCLUDE_DIR=${INSTALL_DIR}/include \
      -DPNG_LIBRARY_DEBUG=${INSTALL_DIR}/lib/libpng16d.lib \
      -DPNG_LIBRARY_RELEASE=${INSTALL_DIR}/lib/libpng16.lib \
      ..

# For some reason we get bogus libraries inserted into the project file
for f in `find . -name \*.vcxproj -print` ; do
    echo patching $f
    sed -e 's/;optimized.lib//g' -e 's/;debug.lib//g' < $f > foo
    mv foo $f
done


cmake --build . --config Release > build_r.log
cmake --build . --config Release --target install > install_r.log
cmake --build . --config Debug > build_d.log
cmake --build . --config Debug --target install> install_d.log

popd


if [ ! -f ${INSTALL_DIR}/lib/osg.lib ] ; then
    echo osg build failed
    exit 1
fi

if [ ! -f ${INSTALL_DIR}/lib/osgd.lib ] ; then
    echo osg debug build failed
    exit 1
fi
    
