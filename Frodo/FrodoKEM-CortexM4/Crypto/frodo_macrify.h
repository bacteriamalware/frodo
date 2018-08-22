/********************************************************************************************
* FrodoKEM: Learning with Errors Key Encapsulation
*
* Abstract: header for internal functions
*********************************************************************************************/
//Edited for ARM M4

#ifndef _FRODO_MACRIFY_H_
#define _FRODO_MACRIFY_H_

#include <stddef.h>
#include <stdint.h>

void frodo_pack(unsigned char *out, const size_t outlen, const uint16_t *in, const size_t inlen, const unsigned char lsb);
void frodo_unpack(uint16_t *out, const size_t outlen, const unsigned char *in, const size_t inlen, const unsigned char lsb);
void frodo_sample_n(uint16_t *s, const size_t n, const uint8_t *seed, const size_t s_seed, const uint16_t ctr);
void clear_words(void* mem, unsigned int nwords);
int constant_compare(const uint8_t *x,const uint8_t *y, int length);

int frodo_mul_add_as_plus_e(uint16_t *b, const uint16_t *s, const uint8_t *seed_A);
int frodo_mul_add_sa_plus_e(uint16_t *b, const uint16_t *s, const uint8_t *seed_A);
void frodo_mul_add_sb_plus_e(uint16_t *out, const uint16_t *b, const uint16_t *s, const uint16_t *e);
void frodo_mul_bs(uint16_t *out, const uint16_t *b, const uint16_t *s);

void frodo_add(uint16_t *out, const uint16_t *a, const uint16_t *b);
void frodo_sub(uint16_t *out, const uint16_t *a, const uint16_t *b);
void frodo_key_encode(uint16_t *out, const uint16_t *in);
void frodo_key_decode(uint16_t *out, const uint16_t *in);

//assembly functions
extern void mul_row(uint16_t *row_A, const uint16_t *S, uint16_t *row_B, uint32_t row_length);
extern void mul_8columns(const uint16_t *S, uint16_t *columns_trans_A, uint16_t *col_B, uint32_t row_length);
extern uint16_t big2little16(uint16_t x);
extern void AES_128_keyschedule(const uint8_t *, uint8_t *);
extern void AES_128_encrypt(const uint8_t *, const uint8_t *, uint8_t *);

#endif
