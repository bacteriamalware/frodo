/********************************************************************************************
* Hardware-based random number generation function
*
*
*********************************************************************************************/ 
//Edited for ARM M4

#include "random.h"
#include <stdlib.h>
#include <stdint.h>
#include "stm32f4xx.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_rng.h"

int randombytes(unsigned char* random_array, unsigned long long nbytes)
{ // Generation of "nbytes" of random values
    uint32_t random4bytes = 0;

	for(unsigned long long i=0; i<nbytes; i++)
    {
    	if(i%4==0)
    	{
    		random4bytes = getRandom();//get four new random bytes
    	}
    	random_array[i]= random4bytes & 0xFF; //take lowest byte
    	random4bytes = random4bytes >> 8; //next byte
    }

    return 0;
}

void initRNG(void)
{
	// Clock Enable
	RCC_AHB2PeriphClockCmd(RCC_AHB2Periph_RNG, ENABLE);
	// RNG enable
	RNG_Cmd(ENABLE);
}

uint32_t getRandom(void)
 {
	 uint32_t rng_wert=0;
	 while(RNG_GetFlagStatus(RNG_FLAG_DRDY)== RESET);
	 rng_wert = RNG_GetRandomNumber();
	 return rng_wert;
 }
