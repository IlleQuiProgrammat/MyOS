/* Declare constants for the multiboot header. */
.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* this is the Multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'magic number' lets bootloader find the header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum of above, to prove we are multiboot */

/* Special multiboot header values */
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM
 
/* it is up to the kernel to provide a stack. 
 - Creates a symbol at the bottom of it, allocates 16384 bytes, and finally creates a symbol at the top.
 - The stack grows downwards on x86. The stack is in its own section so it can be marked nobits
 - The stack on x86 must be 16-byte aligned according to the System V ABI.
*/
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

.section .text
.global _start
.type _start, @function
_start:
	movl $stack_top, %esp
	# Call the global constructors
	call _init

	call kernel_main

	call _fini
 
	cli					/* Clear interrupt table */
1:	hlt					/* Halt interrupt should freeze computer */
	jmp 1b				/* If it doesn't, create an infinite loop */
 
/*
Set the size of the _start symbol to the current location '.' minus its start.
This is useful when debugging or when you implement call tracing.
*/
.size _start, . - _start
