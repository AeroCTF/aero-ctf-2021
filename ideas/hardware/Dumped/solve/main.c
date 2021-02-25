#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <mem.h>

static unsigned long int next = 0x1337;

int m_rand()
{
  unsigned int out;
  next = next * 1103515245 + 12345;
  next = (next / 65536) % 32768;
  return (unsigned int)next;
}

struct seed_t{unsigned int x,y,z,w;};
struct seed_t xs_seed;

unsigned int XorShift128()
{
  unsigned int t = xs_seed.x^(xs_seed.x<<11);
  xs_seed.x = xs_seed.y;
  xs_seed.y = xs_seed.z;
  xs_seed.z = xs_seed.w;
  xs_seed.w = (xs_seed.w^(xs_seed.w>>19)) ^ (t^(t>>8));
  return xs_seed.w;
}

uint8_t P2_sreg;

uint8_t P2_Read_Random()
{
  P2_sreg =
    (((((P2_sreg & 0x80) >> 7) ^
       ((P2_sreg & 0x20) >> 5)) ^
      (((P2_sreg & 0x10) >> 4) ^
       ((P2_sreg & 0x08) >> 3))) ^ 1) |
        (P2_sreg << 1);
  return P2_sreg;
}

#define POLY_MASK_32 0xB4BCD35C
#define POLY_MASK_31 0x7A5BC2E3

unsigned int lfsr32, lfsr31;

unsigned int shift_lfsr(unsigned int *lfsr, unsigned int polynomial_mask){
    unsigned int feedback;
    feedback = *lfsr & 1;
    *lfsr >>= 1;
    if (feedback == 1){
        *lfsr ^= polynomial_mask;
    }
    return *lfsr;
}

void init_lfsrs(){
    lfsr32 = 0xABCDE;
    lfsr31 = 0x23456789;
}

unsigned int get_random(){
    shift_lfsr(&lfsr32, POLY_MASK_32);
    return (shift_lfsr(&lfsr32, POLY_MASK_32)^shift_lfsr(&lfsr31, POLY_MASK_31))&0xffff;
}
#define FLAGLEN 20
char flag[21] = {'A', 'e', 'r', 'o', '{', 'n', '0', 't', '_', '3', 'N', '0', 'u', 'G', 'h', '_', 'R', 'N', 'D', '}', 0};
char enc_flag[21] = {0x1d,0x39,0x71,0x1,0x82,0xfb, 0xcc, 0x1, 0xec, 0x86, 0x40, 0xf6, 0x53, 0x34, 0x5b, 0xa5,0xc4, 0x4, 0x79,0x43, 0};

void decode_flag_1(){
    next = 0x1337;
    m_rand();
    xs_seed.x = m_rand();
    xs_seed.y = m_rand();
    xs_seed.z = m_rand();
    xs_seed.w = m_rand();
    for(int i = 0; i < FLAGLEN; i++){
        int r = m_rand();
    }
    for( int i = 0; i < FLAGLEN; i++){
        int r = XorShift128();
    }
    P2_sreg = XorShift128() & 0xff;
    P2_Read_Random();
    P2_Read_Random();
    for( int i = 0; i < FLAGLEN; i++){
        int r = P2_Read_Random();
    }
    init_lfsrs();
    lfsr32 ^= XorShift128();
    lfsr31 ^= XorShift128();
    for( int i = 0; i < FLAGLEN; i++){
        int r = get_random();
        enc_flag[i] ^= r & 0xff;
        printf("%x:%x ",r&0xff, enc_flag[i]&0xff);
    }
}

void decode_flag_2(){
    next = 0x1337;
    m_rand();
    xs_seed.x = m_rand();
    xs_seed.y = m_rand();
    xs_seed.z = m_rand();
    xs_seed.w = m_rand();
    for(int i = 0; i < FLAGLEN; i++){
        int r = m_rand();
    }
    for( int i = 0; i < FLAGLEN; i++){
        int r = XorShift128();
    }
    P2_sreg = XorShift128() & 0xff;
    P2_Read_Random();
    P2_Read_Random();
    for( int i = 0; i < FLAGLEN; i++){
        int r = P2_Read_Random();
        enc_flag[i] ^= r & 0xff;
        printf("%x:%x ",r&0xff, enc_flag[i]&0xff);
    }
}

void decode_flag_3(){
    next = 0x1337;
    m_rand();
    xs_seed.x = m_rand();
    xs_seed.y = m_rand();
    xs_seed.z = m_rand();
    xs_seed.w = m_rand();
    for(int i = 0; i < FLAGLEN; i++){
        int r = m_rand();
    }
    for( int i = 0; i < FLAGLEN; i++){
        int r = XorShift128();
        enc_flag[i] ^= r & 0xff;
        printf("%x:%x ",r&0xff, enc_flag[i]&0xff);
    }
}
void decode_flag_4(){
    next = 0x1337;
    m_rand();
    xs_seed.x = m_rand();
    xs_seed.y = m_rand();
    xs_seed.z = m_rand();
    xs_seed.w = m_rand();
    for(int i = 0; i < FLAGLEN; i++){
        int r = m_rand();
        enc_flag[i] ^= r >> 8;
        printf("%x:%x ",r>>8, enc_flag[i]);
    }
}

int main () {
    m_rand();
    xs_seed.x = m_rand();
    xs_seed.y = m_rand();
    xs_seed.z = m_rand();
    xs_seed.w = m_rand();
    printf("\nstage_1: ");
    for(int i = 0; i < FLAGLEN; i++){
        int r = m_rand();
        printf("%x:%x ",r>>8, flag[i]);
        flag[i] ^= r >> 8;
        //printf("%x\n", flag[i]);
    }
    printf("\nstage_2: ");
    for( int i = 0; i < FLAGLEN; i++){
        int r = XorShift128();
        printf("%x:%x ",r&0xff, flag[i]);
        flag[i] ^= r & 0xff;
        //printf("%x\n", flag[i]);
    }
    P2_sreg = XorShift128() & 0xff;
    P2_Read_Random();
    P2_Read_Random();
    printf("\nstage_3: ");
    for( int i = 0; i < FLAGLEN; i++){
        int r = P2_Read_Random();
        printf("%x:%x ",r&0xff, flag[i]);
        flag[i] ^= r & 0xff;
        //printf("%x", flag[i]);
    }
    init_lfsrs();
    lfsr32 ^= XorShift128();
    lfsr31 ^= XorShift128();
    printf("\nstage_4: ");
    for( int i = 0; i < FLAGLEN; i++){
        int r = get_random();
        printf("%x:%x ",r&0xff, flag[i]);
        flag[i] ^= r & 0xff;
    }
    printf("\nDecode_1\n");
    decode_flag_1();
    printf("\nDecode_2\n");
    decode_flag_2();
    printf("\nDecode_3\n");
    decode_flag_3();
    printf("\nDecode_4\n");
    decode_flag_4();
    printf("FLAG: %s\n", enc_flag);
    return 0;
}
