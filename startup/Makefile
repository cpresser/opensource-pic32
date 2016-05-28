CC = mipsel-none-elf-gcc
AR = mipsel-none-elf-ar
PROGRAM = mx2crt.o
ARCH = -EL -march=m4k
OBJECTS = init.o sfr.o
CFLAGS = -I. -g3 -O0 

all: $(PROGRAM)

$(PROGRAM): $(OBJECTS)
	$(AR) -r $(PROGRAM) $(OBJECTS)
   
.s.o:
	$(CC) $(ARCH) -I. -c $< -o $@
   
clean:
	rm -f $(OBJECTS) $(PROGRAM)
