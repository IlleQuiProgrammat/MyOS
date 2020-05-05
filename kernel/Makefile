CC = x86_64-elf-gcc
AS = x86_64-elf-as
LD = x86_64-elf-ld
AR = x86_64-elf-ar

PROJDIRS = kernel include arch/x86_64

ASMFILES := $(shell find $(PROJDIRS) -type f -name "*.S")
SRCFILES := $(shell find $(PROJDIRS) -type f -name "*.c")
HDRFILES := $(shell find $(PROJDIRS) -type f -name "*.h")

ASMOBJFILES := $(patsubst %.S,%.o,$(ASMFILES))
OBJFILES := $(patsubst %.c,%.o,$(SRCFILES))
DEPFILES := $(patsubst %.c,%.d,$(SRCFILES))


CFLAGS ?= -O2 -g
CWARNINGS ?= -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
			-Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
			-Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
			-Wconversion -Wstrict-prototypes

CFLAGS := $(CFLAGS) -ffreestanding -mcmodel=kernel $(CWARNINGS) -I../sysroot/usr/include -L../sysroot/usr/lib -llibk

ASFLAGS ?=
ASFLAGS :=

LDFLAGS ?=
LDFLAGS := $(LDFLAGS)

.PHONY: all clean dist check testdrivers todolist

all: lightrod.kernel

lightrod.kernel: $(OBJFILES) $(ASMOBJFILES)
	ld -T ./arch/x86_64/linker.ld $? -o lightrod.kernel -lk -L../sysroot/usr/lib/

clean:
	-@$(RM) $(wildcard $(OBJFILES) $(DEPFILES) $(TSTFILES) libk.a libk.tgz)

dist:
	@tar czf libk.tgz $(ALLFILES)

-include $(DEPFILES)

todolist:
	-@for file in $(ALLFILES:Makefile=); do fgrep -H -e TODO -e FIXME $$file; done; true

%.o: %.c Makefile
	@$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

%.o: %.S
	@$(AS) $< -o $@

THISDIR := $(shell basename `pwd`)
TODAY := $(shell date +%Y-%m-%d)
BACKUPDIR := projectBackups/$(TODAY)

backup: clean
	@tar cf - ../$(THISDIR) | 7za a -si ../$(BACKUPDIR)/$(THISDIR).$(TODAY)_`date +%H%M`.tar.7z

move_sysroot:
	@cp ./lightrod.kernel ../sysroot/boot/lightrod.kernel