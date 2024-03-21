#!/usr/bin/env bash

#
# Legacy Make to override issues with glibc-2.31 and make >= 4.4
#

ver=4.3
arc=make-${ver}.tar.gz
url=https://ftp.gnu.org/gnu/make/${arc}

#collect build directory if not defined
if [ "$BUILDDIR" = "" ]; then
	#select temp directory
	echo "Build directory is empty, using temp directory!"
	BUILDDIR=$(dirname "$(mktemp tmp.XXXXXXXXXX -ut)")
fi


SCRIPTDIR=$(cd $(dirname $0);pwd)

echo "Downloading and Setting up build directories"
#setup paths
DOWNLOADDIR=$BUILDDIR/build_toolchains
INSTALLDIR=$BUILDDIR/host-tools
#SYSROOTDIR=$BUILDDIR/cross-pi-gcc-$GCC_VERSION-$FOLDER_VERSION/$TARGET/libc

#make dirs
mkdir -p "$DOWNLOADDIR"
mkdir -p "$INSTALLDIR"

cd "$DOWNLOADDIR" || exit

if [ ! -d "make-${ver}" ]; then
    if [ ! -f "${arc}" ]; then
		wget -q --no-check-certificate $url
	fi
	tar xf ${arc}
	cd make-"$ver" || exit
	mkdir -p build
	cd "$DOWNLOADDIR" || exit
fi

build_make()
{
    echo "Building Make ${ver} Binaries..."

    cd "$DOWNLOADDIR"/make-$ver/build || exit
    if [ -n "$(ls -A "$DOWNLOADDIR"/make-$ver/build)" ]; then rm -rf "$DOWNLOADDIR"/make-$ver/build/*; fi

    ../configure --prefix=${INSTALLDIR}
    make -j$(nproc)
    make install
}

build_make

