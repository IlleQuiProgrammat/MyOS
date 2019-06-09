%define MAGIC 0x1badb002
%define FLAGS (1<<0 | 1<<1)
%define CHECKSUM -(MAGIC + FLAGS)

section .multiboot
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

section .text
extern kernelMain
extern callConstructors
global loader

loader:
    mov esp, kernel_stack
    call callConstructors
    push eax
    push ebx 
    call kernelMain
    cli
    hlt
    jmp $

section .bss
resb 0x20000
kernel_stack: