#include "stm32f4xx.h"
#include "system_stm32f4xx.h"
#include "cyclecounter.h"

volatile uint32_t *DWT_CYCCNT = (uint32_t *)0xE0001004;
volatile uint32_t *DWT_CONTROL = (uint32_t *)0xE0001000;
volatile uint32_t *SCB_DEMCR = (uint32_t *)0xE000EDFC;

void rst_en_cyccnt(void)
{
	*SCB_DEMCR = *SCB_DEMCR | 0x01000000;
	*DWT_CYCCNT = 0; // reset the counter
	*DWT_CONTROL = *DWT_CONTROL | 1 ; // enable the counter
}

uint32_t read_cycnt(void)
{
	return *DWT_CYCCNT;
}
