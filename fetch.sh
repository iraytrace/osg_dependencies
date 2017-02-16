#!/bin/sh

if [ ! -d giflib ] ; then
    git clone https://git.code.sf.net/p/giflib/code giflib
fi

if [ ! -d libpng ] ; then
    git clone https://git.code.sf.net/p/libpng/code libpng
fi

if [ ! -d curl ] ; then
    git clone https://github.com/curl/curl.git curl
fi

if [ ! -d glut ] ; then
    git clone https://github.com/markkilgard/glut.git glut
fi

if [ ! -d libtiff ] ; then
    git clone https://github.com/vadz/libtiff.git libtiff
fi

if [ ! -d minizip ] ; then
    git clone https://github.com/nmoinvaz/minizip.git minizip
fi

if [ ! -d jpeg-9b ] ; then
    curl -L -k -O http://www.ijg.org/files/jpegsrc.v9b.tar.gz
    tar xaf jpegsrc.v9b.tar.gz
fi

if [ ! -d zlib-1.2.11 ] ; then
    if [ ! -f zlib-1.2.11.tar.gz ] ; then
	echo fetching zlib
	curl -L -k -O http://www.zlib.net/zlib-1.2.11.tar.gz
    fi
    echo unpacking zlib
    tar xaf zlib-1.2.11.tar.gz
fi

if [ ! -d proj4 ] ; then
    git clone https://github.com/OSGeo/proj.4.git proj4
fi

if [ ! -d gdal ] ; then
    if [ ! -f gdal213.zip ] ; then
	echo fetching gdal
	curl -L -k -O http://download.osgeo.org/gdal/2.1.3/gdal213.zip
    fi
    echo unpacking gdal
    unzip -qq gdal213.zip
    mv gdal-2.1.3 gdal
fi

if [ X${BIN_COIN} == X ]  ; then
    if [ ! -d simage-1.7.0 ] ; then
	if [ ! -f simage-1.7.0.tar.gz ] ; then
	    echo fetching simage
	    curl -L -k -O https://bitbucket.org/Coin3D/coin/downloads/simage-1.7.0.tar.gz
	fi
	echo unpacking simage
	tar xaf simage-1.7.0.tar.gz
    fi

    if [ ! -d Coin-3.1.3 ] ; then
	echo No Coin
	if [ ! -f Coin-3.1.3.tar.gz ] ; then
	    echo fetching Coin
	    curl -L -k -O https://bitbucket.org/Coin3D/coin/downloads/Coin-3.1.3.tar.gz
	fi
	echo unpacking Coin
	tar xaf Coin-3.1.3.tar.gz
    fi
else
    curl -L -k -O https://bitbucket.org/Coin3D/coin/downloads/Coin-3.1.3-bin-msvc9-amd64.zip
    mkdir binCoin
    pushd binCoin
    echo unpacking binCoin
    unzip -qq Coin-3.1.3-bin-msvc9-amd64.zip
    popd
fi

if [ ! -d OpenSceneGraph-3.4.0 ] ; then
    if [ ! -f OpenSceneGraph-3.4.0.zip ] ; then
	curl -L -k -O  http://trac.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.4.0.zip
    fi
    unzip -qq OpenSceneGraph-3.4.0.zip
fi
