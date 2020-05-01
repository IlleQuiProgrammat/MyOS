#include <stdlib.h>
#include <stdio.h>

void panic(const char* message) {
#if defined(__is_libk)
	// TODO: Add proper kernel panic.
	printf("kernel: panic: %s", message);
#else
	// TODO: Abnormally terminate the process as if by SIGABRT.
	printf("Error: %s\n", message);
#endif
	while (1) { }
	__builtin_unreachable();
}