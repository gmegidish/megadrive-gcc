#!/bin/bash

# as per http://gendev.spritesmind.net/forum/viewtopic.php?p=12798
# (mirrored in doc/instrucitons.txt)

DGCC=4.5.2

GMP=5.0.1
MPFR=2.4.2
MPC=0.8.2
BINUTILS=2.21.1
NEWLIB=1.19.0

function Download
{
	echo -n "  * $1"
	wget -c -q $1
	echo " ☑"
}

function Unpack
{
	echo -n "  * $1"
	tar xf $1
	echo " ☑"
}

set -e

echo "Making output directories"
if [ ! -d /opt/toolchains ]; then
	sudo mkdir /opt/toolchains
fi
sudo chmod 777 /opt/toolchains

if [ ! -d /opt/toolchains/gen/ldscripts ]; then
	mkdir /opt/toolchains/gen/ldscripts
fi

if [ ! -d build ]; then
	mkdir build
fi

cd build

echo "Downloading gcc"
Download http://ftp.gnu.org/gnu/gcc/gcc-$DGCC/gcc-core-$DGCC.tar.bz2
Download http://ftp.gnu.org/gnu/gcc/gcc-$DGCC/gcc-g++-$DGCC.tar.bz2

echo ""
echo "Downloading dependencies"
Download http://www.multiprecision.org/mpc/download/mpc-$MPC.tar.gz
Download ftp://ftp.gmplib.org/pub/gmp-5.0.1/gmp-$GMP.tar.bz2
Download http://www.mpfr.org/mpfr-2.4.2/mpfr-$MPFR.tar.bz2 

Download http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS.tar.bz2
Download ftp://sources.redhat.com/pub/newlib/newlib-$NEWLIB.tar.gz

echo ""
echo "Unpacking"
Unpack gcc-core-$DGCC.tar.bz2
Unpack gcc-g++-$DGCC.tar.bz2
Unpack mpc-$MPC.tar.gz
Unpack gmp-$GMP.tar.bz2
Unpack mpfr-$MPFR.tar.bz2
Unpack binutils-$BINUTILS.tar.bz2
Unpack newlib-$NEWLIB.tar.gz

echo ""
echo "Moving and renaming"
mv mpfr-$MPFR gcc-$DGCC/mpfr
mv mpc-$MPC gcc-$DGCC/mpc
mv gmp-$GMP gcc-$DGCC/gmp

echo ""
echo "Copying ldscripts and makefiles"
cp ../ldscripts/* .

echo ""
echo "Building"
date > build.log
make -f makefile-gen >> build.log

echo ""
echo "Installing megadrive ldscripts"
cp *.ld /opt/toolchains/gen/ldscripts
