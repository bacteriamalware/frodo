//Edited for ARM M4

#ifndef __RANDOM_H__
#define __RANDOM_H__

#include <stdint.h>

// Initialize the RNG
void initRNG(void);
// Get 32 uniform random bits from Hardware
uint32_t getRandom(void);
// Generate random bytes and output the result to random_array
int randombytes(unsigned char* random_array, unsigned long long nbytes);


#endif
