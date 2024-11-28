# Detect the operating system
ifeq ($(OS),Windows_NT)
	CC=i386-diet gcc
	XCC=i686-w64-mingw32-gcc
	XLD=i686-w64-mingw32-ld
	XAR=i686-w64-mingw32-ar
	XNM=i686-w64-mingw32-nm
	XRANLIB=i686-w64-mingw32-ranlib
	XDLLTOOL=i686-w64-mingw32-dlltool
	XOBJDUMP=i686-w64-mingw32-objdump
	XSTRIP=i686-w64-mingw32-strip
	XAS=i686-w64-mingw32-as
	XDLLTOOL=i686-w64-mingw32-dlltool
	XDLLWRAP=i686-w64-mingw32-dllwrap
	LC_ALL=C
	SED=sed
else
	CC=clang
	CXX=clang++
	SED=sed
endif

FLAGS = -Wall -Wno-pointer-sign

ifeq ($(OS),Windows_NT)
CFLAGS = -m32 -O2 $(FLAGS)
LFLAGS = -m32 -s
XCFLAGS = -DMINGW $(FLAGS)
XLFLAGS = -s
else
CFLAGS = -O2 $(FLAGS)
endif

INC = rigol_vendor_bin.h
ifeq ($(OS),Windows_NT)
PROGS = rigol_vendor_bin.exe
else
PROGS = rigol_vendor_bin
endif

all: $(PROGS)

RIGOL_OBJ = rigol_vendor_bin.o aes.o xxtea.o crc32.o strings.o
RIGOL_XOBJ = rigol_vendor_bin.obj aes.obj xxtea.obj crc32.obj strings.obj

%.obj: %.c $(INC)
	$(XCC) $(XCFLAGS) -c $< -o $@

%.o: %.c $(INC)
	$(CC) $(CFLAGS) -c $< -o $@

rigol_vendor_bin: $(RIGOL_OBJ)
	$(CC) $(LFLAGS) -o $@ $^

rigol_vendor_bin.exe: $(RIGOL_XOBJ)
	$(XCC) $(XLFLAGS) -o $@ $^

clean:
	rm -f *~ *.o *.obj *.dec *.enc $(PROGS)
