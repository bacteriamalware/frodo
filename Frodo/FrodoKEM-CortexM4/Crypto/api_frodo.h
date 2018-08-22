#ifndef _API_Frodo_H_
#define _API_Frodo_H_

#define USE_FRODO_640
//#define USE_FRODO_976

//#define USE_AES128_FOR_A
#define USE_CSHAKE_FOR_A

#ifdef USE_FRODO_640

	int crypto_kem_keypair_Frodo640(unsigned char *pk, unsigned char *sk);
	int crypto_kem_enc_Frodo640(unsigned char *ct, unsigned char *ss, const unsigned char *pk);
	int crypto_kem_dec_Frodo640(unsigned char *ss, const unsigned char *ct, const unsigned char *sk);

	#define CRYPTO_SECRETKEYBYTES  19872     // sizeof(s) + CRYPTO_PUBLICKEYBYTES + 2*PARAMS_N*PARAMS_NBAR
	#define CRYPTO_PUBLICKEYBYTES   9616     // sizeof(seed_A) + (PARAMS_LOGQ*PARAMS_N*PARAMS_NBAR)/8
	#define CRYPTO_BYTES              16
	#define CRYPTO_CIPHERTEXTBYTES  9736     // (PARAMS_LOGQ*PARAMS_N*PARAMS_NBAR)/8 + (PARAMS_LOGQ*PARAMS_NBAR*PARAMS_NBAR)/8 + CRYPTO_BYTES

	// Algorithm name
	#define CRYPTO_ALGNAME "FrodoKEM-640"

	// Parameters for "FrodoKEM-640"
	#define PARAMS_N 640
	#define PARAMS_NBAR 8
	#define PARAMS_LOGQ 15
	#define PARAMS_Q (1 << PARAMS_LOGQ)
	#define PARAMS_EXTRACTED_BITS 2
	#define PARAMS_STRIPE_STEP 8
	#define PARAMS_PARALLEL 4
	#define BYTES_SEED_A 16
	#define BYTES_MU (PARAMS_EXTRACTED_BITS*PARAMS_NBAR*PARAMS_NBAR)/8
	#define AES_BlOCKS (PARAMS_N*16)/128

	// Selecting cSHAKE XOF function for the KEM and noise sampling
	#define cshake    cshake128_simple

	#define crypto_kem_keypair            crypto_kem_keypair_Frodo640
	#define crypto_kem_enc                crypto_kem_enc_Frodo640
	#define crypto_kem_dec                crypto_kem_dec_Frodo640

#endif //USE_FRODO_640


#ifdef USE_FRODO_976

	int crypto_kem_keypair_Frodo976(unsigned char *pk, unsigned char *sk);
	int crypto_kem_enc_Frodo976(unsigned char *ct, unsigned char *ss, const unsigned char *pk);
	int crypto_kem_dec_Frodo976(unsigned char *ss, const unsigned char *ct, const unsigned char *sk);

	#define CRYPTO_SECRETKEYBYTES  31272     // sizeof(s) + CRYPTO_PUBLICKEYBYTES + 2*PARAMS_N*PARAMS_NBAR
	#define CRYPTO_PUBLICKEYBYTES  15632     // sizeof(seed_A) + (PARAMS_LOGQ*PARAMS_N*PARAMS_NBAR)/8
	#define CRYPTO_BYTES              24
	#define CRYPTO_CIPHERTEXTBYTES 15768     // (PARAMS_LOGQ*PARAMS_N*PARAMS_NBAR)/8 + (PARAMS_LOGQ*PARAMS_NBAR*PARAMS_NBAR)/8 + CRYPTO_BYTES

	// Algorithm name
	#define CRYPTO_ALGNAME "FrodoKEM-976"

	// Parameters for "FrodoKEM-976"
	#define PARAMS_N 976
	#define PARAMS_NBAR 8
	#define PARAMS_LOGQ 16
	#define PARAMS_Q (1 << PARAMS_LOGQ)
	#define PARAMS_EXTRACTED_BITS 3
	#define PARAMS_STRIPE_STEP 8
	#define PARAMS_PARALLEL 4
	#define BYTES_SEED_A 16
	#define BYTES_MU (PARAMS_EXTRACTED_BITS*PARAMS_NBAR*PARAMS_NBAR)/8
	#define AES_BlOCKS (PARAMS_N*16)/128

	// Selecting cSHAKE XOF function for the KEM and noise sampling
	#define cshake    cshake256_simple

	#define crypto_kem_keypair            crypto_kem_keypair_Frodo976
	#define crypto_kem_enc                crypto_kem_enc_Frodo976
	#define crypto_kem_dec                crypto_kem_dec_Frodo976

#endif //USE_FRODO_976


#endif
