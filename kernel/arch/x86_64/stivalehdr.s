/* Special stivale header values

struct stivale_header {
    uint64_t stack;   // This is the stack address which will be in RSP
                      // when the kernel is loaded.

    uint16_t flags;   // Flags
                      // bit 0   0 = text mode,   1 = graphics mode
                      // All other bits undefined.

    uint16_t framebuffer_width;   // These 3 values are parsed if a graphics mode
    uint16_t framebuffer_height;  // is requested. If all values are set to 0
    uint16_t framebuffer_bpp;     // then the bootloader will pick the best possible
                                  // video mode automatically (recommended).
} __attribute__((packed));

*/

.set STACK_TOP 0xeffff0

.section .stivalehdr
.align 4
stivale_header:
    .stack: .quad 0xeffff0
    .videomode: dw 0     # VGA
    .fbwidth: dw 0       # Default
    .fbheight: dw 0      # Default
    .fbbpp: dw 0         # Default

.section .text
.global _start
.type _start, @function
_start:
	mov STACK_TOP, %rsp
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
