#ifndef _IDT_H_
#define _IDT_H_

typedef struct InterruptDescriptor_t {
    uint16_t offsset_lo;
    uint16_t selector;
}__attribute__((packed)) InterruptDescriptor;

typedef struct InterruptDescriptorTable {

}

#endif