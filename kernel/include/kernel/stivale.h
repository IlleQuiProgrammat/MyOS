#ifndef _STIVALE_H_
#define _STIVALE_H_

#include <stdint.h>

typedef struct stivale_struct {
    uint64_t cmdline;               // Pointer to a null-terminated cmdline
    uint64_t memory_map_addr;       // Pointer to the memory map (entries described below)
    uint64_t memory_map_entries;    // Count of memory map entries
    uint64_t framebuffer_addr;      // Address of the framebuffer and related info
    uint16_t framebuffer_pitch;
    uint16_t framebuffer_width;
    uint16_t framebuffer_height;
    uint16_t framebuffer_bpp;
    uint64_t rsdp;                  // Pointer to the ACPI RSDP structure
    uint64_t module_count;          // Count of modules that stivale loaded according to config
    uint64_t modules;               // Pointer to the first entry in the linked list of modules (described below)
    uint64_t epoch;                 // UNIX epoch at boot, read from system RTC
} __attribute__((packed)) stivale_struct;

typedef struct stivale_mmap_entry {
    uint64_t base;      // Base of the memory section
    uint64_t length;    // Length of the section
    uint32_t type;      // Type (described below)
    uint32_t unused;
} __attribute__((packed)) stivale_mmap_entry;

typedef struct stivale_module {
    uint64_t begin;         // Address where the module is loaded
    uint64_t end;           // End address of the module
    char     string[128];   // String passed to the module (by config file)
    uint64_t next;          // Pointer to the next module (if any), check module_count
                            // in the stivale_struct
} __attribute__((packed)) stivale_module;

#endif