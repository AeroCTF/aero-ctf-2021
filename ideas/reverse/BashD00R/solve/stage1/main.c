#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

uint64_t rtea_decrypt(uint32_t a, uint32_t b, uint32_t* key)
{
    uint32_t c, kw = 4;

    for (long long int r=kw*4+31;r!=-1;r--) b-=a+((a<<6)^(a>>8))+key[r%kw]+r,r--,a-=b+((b<<6)^(b>>8))+key[r%kw]+r;

    for (int i = 0; i < 4; i++)
    {
        char* ptr = (char*) &a;
        printf("%c", ptr[i]);
    }
    
    for (int i = 0; i < 4; i++)
    {
        char* ptr = (char*) &b;
        printf("%c", ptr[i]);
    }

    return 0x0;
};

// eY3HmR6knwflbc1nsq0ILP9KZYQ8DTn
// eY3HmR6knwflbc1nsq0ILP9KZYQ8DTn
int main()
{
    uint32_t* keys = (uint32_t*) malloc(4 * sizeof(uint32_t));
    keys[0] = 0x51281f74;
    keys[1] = 0x983dcae3;
    keys[2] = 0x9bca2e8f;
    keys[3] = 0x8939fab3;

    uint64_t enc[8] = {0xe9b554bc, 0xbf7a0351, 0x200a845b, 0x757aff88,
    0x392848a3, 0x4339a3ee, 0x21f8e1c6, 0x64355c7c};

    for (int i = 0; i < 8; i+=2)
    {
        rtea_decrypt(enc[i], enc[i+1], keys);
    }

    return 0;
}