#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#pragma region VGA

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
 
size_t terminal_row;
size_t terminal_column;
uint8_t terminal_colour;
uint16_t* terminal_buffer;

// Colour constants
enum vga_colour {
	VGA_COLOUR_BLACK = 0,
	VGA_COLOUR_BLUE = 1,
	VGA_COLOUR_GREEN = 2,
	VGA_COLOUR_CYAN = 3,
	VGA_COLOUR_RED = 4,
	VGA_COLOUR_MAGENTA = 5,
	VGA_COLOUR_BROWN = 6,
	VGA_COLOUR_LIGHT_GREY = 7,
	VGA_COLOUR_DARK_GREY = 8,
	VGA_COLOUR_LIGHT_BLUE = 9,
	VGA_COLOUR_LIGHT_GREEN = 10,
	VGA_COLOUR_LIGHT_CYAN = 11,
	VGA_COLOUR_LIGHT_RED = 12,
	VGA_COLOUR_LIGHT_MAGENTA = 13,
	VGA_COLOUR_LIGHT_BROWN = 14,
	VGA_COLOUR_WHITE = 15,
};
 
static inline uint8_t get_vga_colour(enum vga_colour foreground, enum vga_colour background) {
	return foreground | background << 4;
}
 
static inline uint16_t get_vga_char(unsigned char character, uint8_t colour) {
	return (uint16_t) character | (uint16_t) colour << 8;
}

#pragma endregion VGA

size_t strlen(const char* str) {
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

// Clears terminal
void terminal_initialize(void) {
	terminal_row = 0;
	terminal_column = 0;
	terminal_colour = get_vga_colour(VGA_COLOUR_LIGHT_GREY, VGA_COLOUR_BLACK);
	terminal_buffer = (uint16_t*) 0xB8000;

	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = get_vga_char(' ', terminal_colour);
		}
	}
}

void terminal_setcolour(uint8_t colour) {
	terminal_colour = colour;
}

void terminal_putentryat(char c, uint8_t colour, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = get_vga_char(c, colour);
}

void terminal_scroll(int numberOfLines) {
    for (int i = 0; i < VGA_HEIGHT - numberOfLines; i++) {
        for (int c = 0; c < VGA_WIDTH; c++) {
            terminal_buffer[i * VGA_WIDTH + c] = terminal_buffer[(i + numberOfLines) * VGA_WIDTH + c];
        }
    }

    for (int i = VGA_HEIGHT - numberOfLines; i < VGA_HEIGHT; i++) {
        for (int c = 0; c < VGA_WIDTH; c++) {
            terminal_putentryat(' ', terminal_colour, c, i);
        }
    }

}

void terminal_putchar(char c) {
    if (terminal_row == VGA_HEIGHT) {
        terminal_scroll(1);
        terminal_row--;
    }
	terminal_putentryat(c, terminal_colour, terminal_column, terminal_row);
	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		terminal_row++;
	}
}

void terminal_write(const char* data, size_t size) {
	for (size_t i = 0; i < size; i++) {
        if (data[i] == '\n') {
            if (++terminal_row == VGA_HEIGHT) {
                terminal_scroll(1);
                terminal_row--;
            }
            terminal_column = 0;
        } else {
		    terminal_putchar(data[i]);
        }
    }
}

void terminal_writestring(const char* data) {
	terminal_write(data, strlen(data));
}

void kernel_main(void) {
	/* Initialize terminal interface */
	terminal_initialize();
    terminal_setcolour(get_vga_colour(VGA_COLOUR_CYAN, VGA_COLOUR_BLACK));

    for(int i = 0; i < VGA_HEIGHT; i++) {
        terminal_writestring("testsdfaklsjdfal;skdjfa;lsdkfja;lsdkfja;lsdkjfasldkfja;sldkfjas;ldkfjasl;dkjfal;skdjfa;lsdkjfal;sdkjfa;lsdkfja;lskdfja;sldkfja;sldkjfa;lsdkfj");
    };
}