#ifndef _GDT_H_
#define _GDT_H_

#include <stdint.h>

typedef struct SegmentDescriptor_t {
    uint16_t limit_lo;
    uint16_t base_lo;
    uint8_t base_hi;
    uint8_t type;
    uint8_t flags_limit_hi;
    uint8_t base_vhi;
}__attribute__((packed)) SegmentDescriptor;

struct SegmentDescriptor* GetSegmentDescriptor(uint32_t base, uint32_t limit, uint8_t type);
void SetSegmentDescriptor(SegmentDescriptor* segment, uint32_t base, uint32_t limit, uint8_t type);

uint32_t GetBaseFromSegment(SegmentDescriptor* segment);
uint32_t GetLimitFromSegment(SegmentDescriptor* segment);
uint8_t GetTypeFromSegment(SegmentDescriptor* segment);

typedef struct GlobalDescriptorTable_t {
    SegmentDescriptor nullSegmentSelector;
    SegmentDescriptor unusedSegmentSelector;
    SegmentDescriptor codeSegmentSelector;
    SegmentDescriptor dataSegmentSelector;
}__attribute__((packed)) GlobalDescriptorTable;

void InitialiseGDT(GlobalDescriptorTable* gdt);

#endif