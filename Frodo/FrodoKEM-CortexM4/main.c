#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "stm32f4xx.h"
#include "system_stm32f4xx.h"
#include "cyclecounter.h"
#include "random.h"
#include "api_frodo.h"

static int kem_test(int iterations)
{
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    uint8_t ss_encap[CRYPTO_BYTES], ss_decap[CRYPTO_BYTES];
    uint8_t ct[CRYPTO_CIPHERTEXTBYTES];

    printf("Testing (KEM), tests for %i iterations\n ", iterations);

    uint32_t cyc_keypair = 0;
    uint32_t cyc_enc = 0;
    uint32_t cyc_dec = 0;
    for (int i = 0; i < iterations; i++)
    {
    	rst_en_cyccnt();
    	crypto_kem_keypair(pk, sk);
    	cyc_keypair = read_cycnt();

    	rst_en_cyccnt();
    	crypto_kem_enc(ct, ss_encap, pk);
        cyc_enc = read_cycnt();

        rst_en_cyccnt();
        crypto_kem_dec(ss_decap, ct, sk);
        cyc_dec = read_cycnt();

        if (memcmp(ss_encap, ss_decap, CRYPTO_BYTES) != 0)
        {
            printf("ERROR! ");
            printf("KEM FAILED \n");
            printf("CYCLES Keypair: %u, Enc: %u, Dec: %u \n ", cyc_keypair, cyc_enc, cyc_dec);
            return 0;
        }
        else
        {
        	printf("CYCLES Keypair: %u, Enc: %u, Dec: %u \n ", cyc_keypair, cyc_enc, cyc_dec);
		}
    }

    printf("Tests PASSED. All session keys matched.\n");
    printf(" \n\n");

    return 1;
}

int main(void)
{
	SystemInit();
	initRNG();
	//FLASH->ACR &= ~((1 << 9) | (1 << 10)); //deactivate Cache

	kem_test(3);

	while(1)
	{
	}
}


