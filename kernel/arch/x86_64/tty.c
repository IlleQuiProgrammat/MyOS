#include <stdint.h>
#include <stddef.h>

#include <kernel/tty.h>
#include <string.h>

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_colour;
uint16_t* terminal_buffer;

// Clears terminal
void terminal_initialize(void) {
	terminal_row = 0;
	terminal_column = 0;
	terminal_colour = get_vga_colour(VGA_COLOUR_LIGHT_GREY, VGA_COLOUR_BLACK);
	terminal_buffer = VGA_MEMORY;

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