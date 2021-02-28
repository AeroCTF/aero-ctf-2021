/*

main.c, printing test vectors of reference implementation of the Kalyna block cipher (DSTU 7624:2014), all block and key length variants

Authors: Ruslan Kiianchuk, Ruslan Mordvinov, Roman Oliynykov

*/

#include <stdio.h>
#include <memory.h>

#include "kalyna.h"
#include "transformations.h"

void print (int data_size, uint64_t data []);

int main(int argc, char** argv) {
   
	int i;

	uint64_t ct44_d[4] = {0xA920ACAE6C357C71ULL, 0x31F744286944C89CULL, 0x149210EE4C8D7680ULL, 0xE7678B832188DF32ULL};
	uint64_t pt44_d[4];
    /*		[0x00000000]	0x408b2d5d32bbcac3	unsigned __int64
		[0x00000001]	0x408b2d5d6bc9b592	unsigned __int64
		[0x00000002]	0x408b2d5d3b7753fc	unsigned __int64
		[0x00000003]	0x408b2d5dccdea846	unsigned __int64
*/
    uint64_t key44_d[4] = {0x408b2d5d32bbcac3ULL, 0x408b2d5d6bc9b592ULL, 0x408b2d5d3b7753fcULL, 0x408b2d5dccdea846ULL};

	kalyna_t* ctx44_d = KalynaInit(256, 256);
	
	// kalyna 44 dec
	KalynaKeyExpand(key44_d, ctx44_d);

    printf("\n=============\n");
    printf("Kalyna (%lu, %lu)\n", ctx44_d->nb * 64, ctx44_d->nk * 64);
   
	printf("\n--- DECIPHERING ---\n");
    printf("Key:\n");
    print(ctx44_d->nk, key44_d);

	printf("Ciphertext:\n");
    print(ctx44_d->nb, ct44_d);

	KalynaDecipher(ct44_d, ctx44_d, pt44_d);
    printf("Plaintext:\n");
    print(ctx44_d->nb, pt44_d);

	KalynaDelete(ctx44_d);

    return 0;
}


void print (int data_size, uint64_t data [])
{
	int i;
	uint8_t * tmp = (uint8_t *) data; 
	for (i = 0; i < data_size * 8; i ++)
	{
		if (! (i % 16)) printf ("    ");
		printf ("%02X", (unsigned int) tmp [i]);
		if (!((i + 1) % 16)) printf ("\n");
	};
	printf ("\n");
};
