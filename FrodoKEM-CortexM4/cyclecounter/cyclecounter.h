
#ifndef cyclecounter_h
#define cyclecounter_h

#include <stdint.h>

void rst_en_cyccnt(void);
uint32_t read_cycnt(void);

#endif //cyclecounter_h
