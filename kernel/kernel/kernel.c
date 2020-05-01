#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <kernel/tty.h>

// size_t strlen(const char* str) {
// 	size_t len = 0;
// 	while (str[len])
// 		len++;
// 	return len;
// }

void kernel_main(void) {
	/* Initialize terminal interface */
	terminal_initialize();
    terminal_setcolour(get_vga_colour(VGA_COLOUR_CYAN, VGA_COLOUR_BLACK));

    for(int i = 0; i < VGA_HEIGHT; i++) {
        terminal_writestring("testsdfaklsjdfal;skdjfa;lsdkfja;lsdkfja;lsdkjfasldkfja;sldkfjas;ldkfjasl;dkjfal;skdjfa;lsdkjfal;sdkjfa;lsdkfja;lskdfja;sldkfja;sldkjfa;lsdkfj");
    };
}