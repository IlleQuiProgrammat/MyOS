#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <kernel/tty.h>
#include <stdio.h>
#include <stdlib.h>

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

    printf("Welcome to lightrod:\n");
	abort();
}