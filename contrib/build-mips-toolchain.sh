#!/bin/bash -ev
# -e => exit on error
# -v => verbose output
 
# Mips Cross Compiler
 
# Base directory
mkdir -p mips
# src directory
mkdir -p mips/src
# build directory
mkdir -p mips/build
# original archives
mkdir -p mips/orig
 
# Set the destination
export MYMIPS=/opt/mips-gcc/
 
# Versions
GMPVERSION="6.1.0"
PPLVERSION="0.12.1"
BINUTILSVERSION="2.26"
MPFRVERSION="3.1.4"
MPCVERSION="1.0.3"
ISLVERSION="0.16.1"
CLOOGVERSION="0.18.4"
GCCVERSION="5.3.0"
NEWLIBVERSION="2.2.0"
GDBVERSION="7.11"
 
 
########################################
# Binutils
########################################
 
# Get the archives
cd mips/orig 
if [ ! -e "binutils-${BINUTILSVERSION}.tar.bz2" ] ; then
  wget http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILSVERSION}.tar.bz2
fi
 
# Unpack to source directory
cd ../src
if [ ! -d "binutils-${BINUTILSVERSION}" ] ; then
tar -xvjf ../orig/binutils-${BINUTILSVERSION}.tar.bz2
fi 
 
cd ../build
mkdir -p binutils
cd binutils
if [ ! -e "config.status" ] ; then
../../src/binutils-${BINUTILSVERSION}/configure --target=mipsel-none-elf \
--prefix=$MYMIPS
fi
 
if [ ! -e "${MYMIPS}/bin/mipsel-none-elf-ld" ] ; then
make -j4
make install
fi
cd ../../..
 
########################################
# GMP
########################################
 
# Get the archives
cd mips/orig 
if [ ! -e "gmp-${GMPVERSION}.tar.bz2" ] ; then
  wget ftp://ftp.halifax.rwth-aachen.de/gnu/gmp/gmp-${GMPVERSION}.tar.bz2
fi
 
# Unpack to source directory
cd ../src
if [ ! -d "gmp-${GMPVERSION}" ] ; then
tar -xjvf ../orig/gmp-${GMPVERSION}.tar.bz2
fi 
 
# Build
cd ../build
mkdir -p gmp
cd gmp
if [ ! -e "config.status" ] ; then	
../../src/gmp-${GMPVERSION}/configure --prefix=$MYMIPS --enable-cxx
fi
if [ ! -e "${MYMIPS}/lib/libgmp.a" ] ; then
make -j4
make install
fi
cd ../../..
 
 
########################################
# PPL
########################################
 
# Get the archives
#cd mips/orig 
#if [ ! -e "ppl-${PPLVERSION}.tar.bz2" ] ; then
#  wget ftp://ftp.cs.unipr.it/pub/ppl/releases/${PPLVERSION}/ppl-${PPLVERSION}.tar.bz2
#fi
 
# Unpack to source directory
#cd ../src
#if [ ! -d "ppl-${PPLVERSION}" ] ; then
#tar -xjvf ../orig/ppl-${PPLVERSION}.tar.bz2
#fi 
 
#cd ../build
#mkdir -p ppl
#cd ppl
#if [ ! -e "config.status" ] ; then
#../../src/ppl-${PPLVERSION}/configure --prefix=$MYMIPS --with-gmp=$MYMIPS --with-sysroot=$MYMIPS
#fi
#if [ ! -e "${MYMIPS}/lib/libppl.a" ] ; then
#make 
#make install
#fi
#cd ../../..
 
 
######################################
# MPFR library
#######################################
 
# Get the archives
cd mips/orig 
if [ ! -e "mpfr-${MPFRVERSION}.tar.bz2" ] ; then
  wget ftp://ftp.halifax.rwth-aachen.de/gnu/mpfr/mpfr-${MPFRVERSION}.tar.bz2
fi
 
# Unpack to source directory
cd ../src
if [ ! -d "mpfr-${MPFRVERSION}" ] ; then
tar -xvjf ../orig/mpfr-${MPFRVERSION}.tar.bz2
fi
 
cd ../build
mkdir -p mpfr
cd mpfr
if [ ! -e "config.status" ] ; then
../../src/mpfr-${MPFRVERSION}/configure --prefix=$MYMIPS --with-gmp=$MYMIPS 
fi
 
if [ ! -e "${MYMIPS}/lib/libmpfr.a" ] ; then
make -j4
make install
fi
cd ../../.. 
 
######################################
# MPC library
#######################################
 
# Get the archives
cd mips/orig 
if [ ! -e "mpc-${MPCVERSION}.tar.gz" ] ; then
  wget ftp://ftp.halifax.rwth-aachen.de/gnu/mpc/mpc-${MPCVERSION}.tar.gz
fi
 
# Unpack to source directory
cd ../src
if [ ! -d "mpc-${MPCVERSION}" ] ; then
tar -xvzf ../orig/mpc-${MPCVERSION}.tar.gz
fi
 
cd ../build
mkdir -p mpc
cd mpc
if [ ! -e "config.status" ] ; then
../../src/mpc-${MPCVERSION}/configure --prefix=$MYMIPS --with-gmp=$MYMIPS --with-mpfr=$MYMIPS
fi
 
if [ ! -e "${MYMIPS}/lib/libmpc.a" ] ; then
make -j4
make install
fi
cd ../../.. 
 
 
 
##############
# ISL
##############
 
# Get the archives
cd mips/orig 
if [ ! -e "isl-${ISLVERSION}.tar.bz2" ] ; then
  wget  ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-${ISLVERSION}.tar.bz2
fi
 
 
# Unpack to source directory
cd ../src
if [ ! -d "isl-${ISLVERSION}" ] ; then
tar -xvjf ../orig/isl-${ISLVERSION}.tar.bz2
fi
 
cd ../build
mkdir -p isl
cd isl
if [ ! -e "config.status" ] ; then
../../src/isl-${ISLVERSION}/configure --prefix=$MYMIPS --with-gmp-prefix=$MYMIPS 
fi
 
if [ ! -e "${MYMIPS}/lib/libisl.a" ] ; then
make -j4
make install
fi
cd ../../.. 
 
##############
# CLOOG
##############
 
# Get the archives
cd mips/orig 
if [ ! -e "cloog-${CLOOGVERSION}.tar.gz" ] ; then
  wget http://www.bastoul.net/cloog/pages/download/cloog-${CLOOGVERSION}.tar.gz
fi
 
 
# Unpack to source directory
cd ../src
if [ ! -d "cloog-${CLOOGVERSION}" ] ; then
tar -xvzf ../orig/cloog-${CLOOGVERSION}.tar.gz
fi
 
cd ../build
mkdir -p cloog
cd cloog
if [ ! -e "config.status" ] ; then
../../src/cloog-${CLOOGVERSION}/configure --prefix=$MYMIPS --with-gmp-prefix=$MYMIPS --with-isl=system --with-isl-prefix=$MYMIPS
fi
 
if [ ! -e "${MYMIPS}/lib/libcloog-isl.a" ] ; then
make -j4
make install
fi
cd ../../.. 
 
 
########################################
# newlib
########################################
 
# Get the archives
cd mips/orig
 
if [ ! -e "newlib-${NEWLIBVERSION}.tar.gz" ] ; then
  wget ftp://sourceware.org/pub/newlib/newlib-${NEWLIBVERSION}.tar.gz
fi
 
# Unpack to source directory
cd ../src
if [ ! -d "newlib-${NEWLIBVERSION}" ] ; then
tar -xvzf ../orig/newlib-${NEWLIBVERSION}.tar.gz
fi 
 
cd ../..
 
########################################
# gcc first stage
########################################
 
# Get the archives
cd mips/orig 
if [ ! -e "gcc-${GCCVERSION}.tar.bz2" ] ; then
  wget ftp://ftp.halifax.rwth-aachen.de/gnu/gcc/gcc-${GCCVERSION}/gcc-${GCCVERSION}.tar.bz2
fi
 
# Unpack to source directory
cd ../src
if [ ! -d "gcc-${GCCVERSION}" ] ; then
tar -xvjf ../orig/gcc-${GCCVERSION}.tar.bz2
fi 
 
cd ../build
mkdir -p gcc-stage1
cd gcc-stage1
if [ ! -e "config.status" ] ; then
LDFLAGS="-Wl,-rpath,$MYMIPS/lib" \
../../src/gcc-${GCCVERSION}/configure --target=mipsel-none-elf \
--prefix=$MYMIPS \
--with-gmp=$MYMIPS \
--with-mpfr=$MYMIPS \
--with-mpc=$MYMIPS \
--with-isl=$MYMIPS \
--with-newlib --without-headers \
--disable-shared --disable-threads --disable-libssp \
--disable-libgomp --disable-libmudflap \
--enable-languages="c"  
fi
 
if [ ! -e "${MYMIPS}/bin/mipsel-none-elf-gcc" ] ; then
make all-gcc -j4
make install-gcc
fi
cd ../../..
 
########################################
# newlib
########################################
 
# Build
cd mips/build
mkdir -p newlib
cd newlib
if [ ! -e "config.status" ] ; then
../../src/newlib-${NEWLIBVERSION}/configure --prefix=$MYMIPS --target=mipsel-none-elf 
fi
 
if [ ! -e "${MYMIPS}/mipsel-none-elf/lib/libc.a" ] ; then
make -j4
make install
fi
cd ../../.. 
 
########################################
# gcc second stage
########################################
 
cd mips/build
mkdir -p gcc-stage2
cd gcc-stage2
if [ ! -e "config.status" ] ; then
LDFLAGS="-Wl,-rpath,$MYMIPS/lib" \
../../src/gcc-${GCCVERSION}/configure --target=mipsel-none-elf \
--prefix=$MYMIPS \
--with-gmp=$MYMIPS \
--with-mpfr=$MYMIPS \
--with-mpc=$MYMIPS \
--with-isl=$MYMIPS \
--with-newlib  \
--disable-shared --disable-threads --disable-libssp \
--disable-libgomp --disable-libmudflap \
--enable-languages="c,c++"  
fi
 
if [ ! -e "${MYMIPS}/bin/mipsel-none-elf-g++" ] ; then
make all -j4
make install
fi
cd ../../..
 
 
########################################
# GDB
########################################
 
# Get the archives
cd mips/orig 
if [ ! -e "gdb-${GDBVERSION}.tar.bz2" ] ; then
  wget ftp://ftp.halifax.rwth-aachen.de/gnu/gdb/gdb-${GDBVERSION}.tar.gz
fi
 
# Unpack to source directory
cd ../src
if [ ! -d "gdb-${GDBVERSION}" ] ; then
tar -xvzf ../orig/gdb-${GDBVERSION}.tar.gz
fi 
 
cd ../build
mkdir -p gdb
cd gdb
if [ ! -e "config.status" ] ; then
../../src/gdb-${GDBVERSION}/configure --target=mipsel-none-elf  \
--enable-sim-trace \
--enable-sim-stdio \
--prefix=$MYMIPS 
fi
 
if [ ! -e "${MYMIPS}/bin/mipsel-none-elf-gdb" ] ; then
make -j4
make install
fi
cd ../../..
