CC = x86_64-elf-gcc
AS = x86_64-elf-as
LD = x86_64-elf-ld 
AR = x86_64-elf-ar

PROJDIRS = stdio stdlib string include arch/x86_64

SRCFILES := $(shell find $(PROJDIRS) -type f -name "*.c")
HDRFILES := $(shell find $(PROJDIRS) -type f -name "*.h")

OBJFILES := $(patsubst %.c,%.o,$(SRCFILES))
DEPFILES := $(patsubst %.c,%.d,$(SRCFILES))


CFLAGS ?= -O2 -g
CWARNINGS ?= -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
             -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
             -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
             -Wconversion -Wstrict-prototypes

CFLAGS := $(CFLAGS) -ffreestanding -mcmodel=kernel $(CWARNINGS) -D__is_libk -I../sysroot/usr/include

LDFLAGS ?=
LDFLAGS := $(LDFLAGS)

.PHONY: all clean dist check testdrivers todolist

all: libk.a

libk.a: $(OBJFILES)
	$(AR) r libk.a $?

clean:
	-@$(RM) $(wildcard $(OBJFILES) $(DEPFILES) $(TSTFILES) libk.a libk.tgz)

dist:
	@tar czf libk.tgz $(ALLFILES)

-include $(DEPFILES) $(TSTDEPFILES)

todolist:
	-@for file in $(ALLFILES:Makefile=); do fgrep -H -e TODO -e FIXME $$file; done; true

%.o: %.c Makefile
	@$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

THISDIR := $(shell basename `pwd`)
TODAY := $(shell date +%Y-%m-%d)
BACKUPDIR := projectBackups/$(TODAY)
 
backup: clean
	@tar cf - ../$(THISDIR) | 7za a -si ../$(BACKUPDIR)/$(THISDIR).$(TODAY)_`date +%H%M`.tar.7z

move_sysroot:
	@cp ./libk.a ../sysroot/usr/lib/libk.a