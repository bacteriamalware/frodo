/********************************************************************************************
* FrodoKEM: Learning with Errors Key Encapsulation
*
* Abstract: matrix arithmetic functions used by the KEM
*********************************************************************************************/
//Edited for ARM M4

#include "sha3_asm/fips202.h"
#include "api_frodo.h"
#include "frodo_macrify.h"
#include <string.h>
#include <stdio.h>

int frodo_mul_add_as_plus_e(uint16_t *out, const uint16_t *s, const uint8_t *seed_A)
{ // Generate-and-multiply: generate matrix A (N x N) row-wise, multiply by s on the right.
  // Inputs: s, out=e (N x N_BAR)
  // Output: out = A*s + e (N x N_BAR)
	#if defined(USE_AES128_FOR_A)     				// using AES128 to generate matrix A on-the-fly, one row at a time
    uint16_t a_row[PARAMS_N] = {0};
	int c_A, r_A;

    uint8_t aes_roundkey[11*16]= {};
	memcpy(aes_roundkey, seed_A, 16);
	AES_128_keyschedule(seed_A, aes_roundkey+16); 	//Compute Roundkeys

    uint16_t x_row[PARAMS_N] = {0};

    for (r_A = 0; r_A < PARAMS_N; r_A++)
    {
    	for (c_A = 0; c_A < PARAMS_N; c_A += PARAMS_STRIPE_STEP)
		{
			x_row[c_A] = r_A;
			x_row[c_A +1] = c_A;
		}

    	for (int b=0; b<AES_BlOCKS; b++)
		{
			AES_128_encrypt(aes_roundkey, ((uint8_t*) x_row)+(16*b), ((uint8_t*) a_row)+(16*b));
		}

		mul_row(a_row, s, out+r_A*PARAMS_NBAR, (uint32_t) PARAMS_N); //Assembly
    }

	#elif defined USE_CSHAKE_FOR_A    				// using CSHAKE128 to generate matrix A on-the-fly, one row at a time
    uint16_t a_row[PARAMS_N] = {0};
    int r_A;

    for (r_A = 0; r_A < PARAMS_N; r_A++)
    {
    	cshake128_simple((unsigned char*)(a_row), (unsigned long long)(2*PARAMS_N), (uint16_t)(256+r_A), seed_A, (unsigned long long)BYTES_SEED_A);
    	mul_row(a_row, s, out+r_A*PARAMS_NBAR, (uint32_t) PARAMS_N); //Assembly
    }
	#endif

    return 1;
}

int frodo_mul_add_sa_plus_e(uint16_t *out, const uint16_t *s, const uint8_t *seed_A)
{ // Generate-and-multiply: generate matrix A (N x N) column-wise, multiply by s' on the left.
  // Inputs: s', out=e' (N_BAR x N)
  // Output: out = s'*A + e' (N_BAR x N)
	#if defined USE_AES128_FOR_A					// using AES128 to generate matrix A on-the-fly, 8 (=PARAMS_STRIPE_STEP) columns at a time

    int c_A, r_A;

	uint8_t aes_roundkey[11*16]= {};

	memcpy(aes_roundkey, seed_A, 16);
	AES_128_keyschedule(seed_A, aes_roundkey+16);

	for(c_A=0; c_A<PARAMS_N; c_A+=PARAMS_STRIPE_STEP)
	{
	    uint16_t a_cols[PARAMS_N*PARAMS_STRIPE_STEP]  = {0};

		memset(a_cols, 0, PARAMS_STRIPE_STEP*PARAMS_N);
		for (r_A = 0; r_A < PARAMS_N; r_A++)
		{
			a_cols[r_A*PARAMS_STRIPE_STEP+0] = r_A;
			a_cols[r_A*PARAMS_STRIPE_STEP+1] = c_A;
		}

		for(r_A = 0; r_A < PARAMS_N; r_A++)
		{
			AES_128_encrypt(aes_roundkey, ((uint8_t*) a_cols)+(r_A*16), ((uint8_t*) a_cols)+(r_A*16));
		}

		mul_8columns(s, a_cols, out+c_A, PARAMS_N);	//Assembly
	}

	#elif defined USE_CSHAKE_FOR_A				// using CSHAKE128 to generate matrix A on-the-fly, 4 rows at a time
												// (with CSHAKE, matrix A can only be generated row by row, column by column would be more efficient here)

    int i, j, kk, k;
	uint16_t a_cols[4*PARAMS_N]  = {0}; //

	for (kk = 0; kk < PARAMS_N; kk+=4)	//
	{
		cshake128_simple((unsigned char*)(a_cols + 0*PARAMS_N), (unsigned long long)(2*PARAMS_N), (uint16_t)(256+kk+0), seed_A, (unsigned long long)BYTES_SEED_A);
		cshake128_simple((unsigned char*)(a_cols + 1*PARAMS_N), (unsigned long long)(2*PARAMS_N), (uint16_t)(256+kk+1), seed_A, (unsigned long long)BYTES_SEED_A);
		cshake128_simple((unsigned char*)(a_cols + 2*PARAMS_N), (unsigned long long)(2*PARAMS_N), (uint16_t)(256+kk+2), seed_A, (unsigned long long)BYTES_SEED_A);
		cshake128_simple((unsigned char*)(a_cols + 3*PARAMS_N), (unsigned long long)(2*PARAMS_N), (uint16_t)(256+kk+3), seed_A, (unsigned long long)BYTES_SEED_A);

		for (i = 0; i < PARAMS_NBAR; i++)
		{
			uint16_t sum[PARAMS_N] = {0};
			for (j = 0; j < 4; j++)	//
			{
				uint16_t sp = s[i*PARAMS_N + kk + j];
				for (k = 0; k < PARAMS_N; k++)
				{
					sum[k] += sp * a_cols[(j)*PARAMS_N + k];
				}
			}
			for(k = 0; k < PARAMS_N; k++)
			{
				out[i*PARAMS_N + k] += sum[k];
			}
		}
	}
	#endif

    return 1;
}

void frodo_mul_bs(uint16_t *out, const uint16_t *b, const uint16_t *s) 
{ // Multiply by s on the right
  // Inputs: b (N_BAR x N), s (N x N_BAR)
  // Output: out = b*s (N_BAR x N_BAR)
    int i, j, k;

    for (i = 0; i < PARAMS_NBAR; i++)
    {
        for (j = 0; j < PARAMS_NBAR; j++)
        {
            out[i*PARAMS_NBAR + j] = 0;
            for (k = 0; k < PARAMS_N; k++)
            {
                out[i*PARAMS_NBAR + j] += b[i*PARAMS_N + k] * s[k*PARAMS_NBAR + j];
            }
            out[i*PARAMS_NBAR + j] = (uint32_t)(out[i*PARAMS_NBAR + j]) & ((1<<PARAMS_LOGQ)-1);
        }
    }
}


void frodo_mul_add_sb_plus_e(uint16_t *out, const uint16_t *b, const uint16_t *s, const uint16_t *e) 
{ // Multiply by s on the left
  // Inputs: b (N x N_BAR), s (N_BAR x N), e (N_BAR x N_BAR)
  // Output: out = s*b + e (N_BAR x N_BAR)
    int i, j, k;

    for (k = 0; k < PARAMS_NBAR; k++)
    {
        for (i = 0; i < PARAMS_NBAR; i++)
        {
            out[k*PARAMS_NBAR + i] = e[k*PARAMS_NBAR + i];
            for (j = 0; j < PARAMS_N; j++)
            {
                out[k*PARAMS_NBAR + i] += s[k*PARAMS_N + j] * b[j*PARAMS_NBAR + i];
            }
            out[k*PARAMS_NBAR + i] = (uint32_t)(out[k*PARAMS_NBAR + i]) & ((1<<PARAMS_LOGQ)-1);
        }
    }
}


void frodo_add(uint16_t *out, const uint16_t *a, const uint16_t *b) 
{ // Add a and b
  // Inputs: a, b (N_BAR x N_BAR)
  // Output: c = a + b

    for (int i = 0; i < (PARAMS_NBAR*PARAMS_NBAR); i++)
    {
        out[i] = (a[i] + b[i]) & ((1<<PARAMS_LOGQ)-1);
    }
}


void frodo_sub(uint16_t *out, const uint16_t *a, const uint16_t *b) 
{ // Subtract a and b
  // Inputs: a, b (N_BAR x N_BAR)
  // Output: c = a - b

    for (int i = 0; i < (PARAMS_NBAR*PARAMS_NBAR); i++)
    {
        out[i] = (a[i] - b[i]) & ((1<<PARAMS_LOGQ)-1);
    }
}


void frodo_key_encode(uint16_t *out, const uint16_t *in) 
{ // Encoding
    unsigned int i, j, npieces_word = 8;
    unsigned int nwords = (PARAMS_NBAR*PARAMS_NBAR)/8;
    uint64_t temp, mask = ((uint64_t)1 << PARAMS_EXTRACTED_BITS) - 1;
    uint16_t* pos = out;

    for (i = 0; i < nwords; i++) {
        temp = 0;
        for(j = 0; j < PARAMS_EXTRACTED_BITS; j++) 
            temp |= ((uint64_t)((uint8_t*)in)[i*PARAMS_EXTRACTED_BITS + j]) << (8*j);
        for (j = 0; j < npieces_word; j++) { 
            *pos = (uint16_t)((temp & mask) << (PARAMS_LOGQ - PARAMS_EXTRACTED_BITS));  
            temp >>= PARAMS_EXTRACTED_BITS;
            pos++;
        }
    }
}


void frodo_key_decode(uint16_t *out, const uint16_t *in)
{ // Decoding
    unsigned int i, j, index = 0, npieces_word = 8;
    unsigned int nwords = (PARAMS_NBAR * PARAMS_NBAR) / 8;
    uint16_t temp, maskex=((uint16_t)1 << PARAMS_EXTRACTED_BITS) -1, maskq =((uint16_t)1 << PARAMS_LOGQ) -1;
    uint8_t  *pos = (uint8_t*)out;
    uint64_t templong;

    for (i = 0; i < nwords; i++)
    {
        templong = 0;
        for (j = 0; j < npieces_word; j++)
        {  // temp = floor(in*2^{-11}+0.5)
            temp = ((in[index] & maskq) + (1 << (PARAMS_LOGQ - PARAMS_EXTRACTED_BITS - 1))) >> (PARAMS_LOGQ - PARAMS_EXTRACTED_BITS);
            templong |= ((uint64_t)(temp & maskex)) << (PARAMS_EXTRACTED_BITS * j);
            index++;
        }
        for(j = 0; j < PARAMS_EXTRACTED_BITS; j++)
        	pos[i*PARAMS_EXTRACTED_BITS + j] = (templong >> (8*j)) & 0xFF;
    }
}
