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

.section stivalehdr
.align 4
stivale_header:
.quad 0xeffff0
.word 0
.word 0
.word 0
.word 0