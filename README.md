# PIC32MX Open-Source Toolchain
The idea of this repo is to provide a quickstart for programming a pic32mx 
Microcontroller without using MPLABX or the XC32 compiler.

This has been done before by other people, I just searched the web and put
code from different sources together.

XC32 is just a islightly patched version of gcc. So we can just use gcc.
Programming and debugging can be done with openocd.

## Sources
* https://github.com/BrunoBasseto/GCC4PIC32
* http://www.hs-augsburg.de/~beckmanf/dokuwiki/doku.php?id=mips_cross_compiler

## Hardware
I did test this with a PIC32MX210F016B. The the demo (main.c) blinks two LEDs
which are connected to RB0 and RB1.
As JTAG-Interface I used a "Altera USB-Blaster" (clone). But virtually any
device supported by openocd should do.

## Usage Instructions
1. Build a mips-gcc toolchain using the ```contrib/build-mips-toolchain.sh``` script
2. Edit the Makefile: adjust the openocd config and paths
3. ```make flash```
4. enjoy blinking LEDs

## TODO
* Fix vector tables in mx2/interrupt.h
* Build an open source library for pic32 devices, similar to libopencm3
* write better/generic Makefile

