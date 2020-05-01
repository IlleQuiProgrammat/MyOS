#include <string.h>
#include <stdint.h>

void* memset(void* buffer, int value, size_t size) {
	uint8_t* buf = buffer;
    // TODO: use REP STOS
	for (size_t i = 0; i < size; i++)
		buf[i] = (unsigned char) value;
	return buffer;
}
