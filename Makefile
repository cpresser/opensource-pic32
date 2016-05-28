PROGRAM = main
OBJECTS = coretimer.o main.o
LIBS = c

OPENOCD_INTERFACE = interface/altera-usb-blaster.cfg
OPENOCD_TARGET = scripts/pic32mx210F016.cfg
OPENOCD_OPTS = -d0

#
# List search directories for headers and for libraries
#
INCLUDE_DIRS = include

#
# Name the startup code and linker script to be used.
#
LDSCRIPT = scripts/mx2.ld
STARTUP = startup/mx2crt.o

#
# Toolchain options
#
CC = mipsel-none-elf-gcc
OBJCPY = mipsel-none-elf-objcopy
ARCH = -EL -march=m4k
CFLAGS += -g3 -O0 -I $(INCLUDE_DIRS)
LDFLAGS += $(STARTUP) -nostartfiles
LDLIBS = $(LIBS2) $(patsubst %,-L%,$(LIB_DIRS)) $(patsubst %,-l%,$(LIBS))

ELFFILE = $(PROGRAM).elf
HEXFILE = $(PROGRAM).hex
BINFILE = $(PROGRAM).bin
MAPFILE = $(PROGRAM).map

.phony: all
.phony: clean
.phony: $(STARTUP)

all: $(ELFFILE)

%.o: %.c
	$(CC) $(ARCH) $(CFLAGS) $(CDIRS) -c $<

$(STARTUP):
	make -C startup

$(ELFFILE): $(OBJECTS) $(STARTUP)
	$(CC) $(ARCH) $(CFLAGS) -T$(LDSCRIPT) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -Wl,-Map,$(MAPFILE) -o$(ELFFILE)

$(HEXFILE): $(ELFFILE)
	$(OBJCPY) -O ihex $(ELFFILE) $(HEXFILE)

$(BINFILE): $(ELFFILE)
	$(OBJCPY) -I ihex --output-target=binary $(HEXFILE) $(BINFILE)
   
flash: $(ELFFILE)
	sudo openocd $(OPENOCD_OPTS) -f $(OPENOCD_INTERFACE) -f $(OPENOCD_TARGET) -c "program $(ELFFILE)"
	sudo openocd $(OPENOCD_OPTS) -f $(OPENOCD_INTERFACE) -f $(OPENOCD_TARGET) -c "init" -c "reset run" -c "exit"; true

debug: $(ELFFILE)
	sudo openocd $(OPENOCD_OPTS) -f $(OPENOCD_INTERFACE) -f $(OPENOCD_TARGET) -c "program $(ELFFILE)"
	sudo openocd $(OPENOCD_OPTS) -f $(OPENOCD_INTERFACE) -f $(OPENOCD_TARGET) -c "init" -c "reset halt"; true
#
# Target to remove all generated files.
#
clean:
	make -C startup clean
	rm -f $(OBJECTS) $(BINFILE) $(ELFFILE) $(HEXFILE) $(MAPFILE)
