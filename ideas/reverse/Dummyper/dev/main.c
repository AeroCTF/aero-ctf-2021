#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#include "aes.h"

#define HEAP_SIZE 8*1024*1024

char myHeap[HEAP_SIZE];
size_t idx;
FILE* rnd;

void* alloc(size_t);
static int encryptFlag(char* in);
void do_stuff(void);
void encrypt_enc_code_part(void);
void dumpBinary(void);

void* alloc(size_t size)
{
    void* ptr = &myHeap[idx];
    memset(ptr, 0xcc, size);
    idx += size;
    return ptr;
};

static int encryptFlag(char* in)
{   
    for (int i = 0; i < 64; i++)
    {
        int size = rand() % 0x7ff;
        //printf("size = %d\n", size);
        char* chunk = alloc(size);
        fread(chunk, size, 1, rnd);
    }
    
    uint8_t* key = alloc(32);
    
    for (int i = 0; i < 64; i++)
    {
        int size = rand() % 0x7ff;
        //printf("size = %d\n", size);
        char* chunk = alloc(size);
        fread(chunk, size, 1, rnd);
    }

    uint8_t* iv = alloc(16);

    for (int i = 0; i < 64; i++)
    {
        int size = rand() % 0x7ff;
        //printf("size = %d\n", size);
        char* chunk = alloc(size);
        fread(chunk, size, 1, rnd);
    }

    fread(key, 1, 32, rnd);
    fread(iv, 1, 16, rnd);

    struct AES_ctx* ctx = alloc(sizeof(struct AES_ctx));

    for (int i = 0; i < 64; i++)
    {
        int size = rand() % 0x7ff;
        //printf("size = %d\n", size);
        char* chunk = alloc(size);
        fread(chunk, size, 1, rnd);
    }

    AES_init_ctx(ctx, key);
    AES_ctx_set_iv(ctx, iv);
    AES_CBC_encrypt_buffer(ctx, in, 128);
};

void do_stuff(void)
{
    rnd = fopen("/dev/urandom", "r");
    srand(time(NULL));

    FILE* fp = fopen("./flag.txt", "r");
    char* buf = (char*) alloc(128);
    fread(buf, 128, 1, fp);
    fclose(fp);
    encryptFlag(buf);
};

void encrypt_enc_code_part(void)
{
    int page_size = getpagesize();
    void* addr = (void*)&alloc;
    addr -= (unsigned long)addr % page_size;

    int code = mprotect((void*)addr, page_size, PROT_READ|PROT_WRITE|PROT_EXEC);
    char* key = alloc(32);
    fread(key, 32, 1, rnd);

    for (int i = 0; i < 64; i++)
    {
        int size = rand() % 0x7ff;
        //printf("size = %d\n", size);
        char* chunk = alloc(size);
        fread(chunk, size, 1, rnd);
    }


    uint8_t* ptr = (uint8_t*) &alloc;

    for (int i = 0; i < 896; i++)
    {
        ptr[i] ^= key[i % 32];
    }
};

void dumpBinary(void)
{
    FILE* fp = fopen("/proc/self/maps", "r");

    long long int startAddr = 0;
    long long int endAddr = 0;
    // 555555554000
    char tmp[13];
    fread(tmp, 12, 1, fp);
    tmp[12] = '\0';
    startAddr = strtoll(tmp, NULL, 16);
    char* buf = NULL;
    size_t size;

    while(1)
    {
        getline(&buf, &size, fp);
        if (strstr(buf, "[heap]"))
        {
            break;
        }
    }

    //puts(buf);
    char* ptr = strchr(buf, '-');
    if (ptr != NULL)
    {
        ptr++;
        char tmp[13];
        strncpy(tmp, ptr, 12);
        tmp[13] = '\0';
        endAddr = strtoll(tmp, NULL, 16);
    }

    //printf("start = %08llx, end = %08llx, size = %08llx\n", startAddr, endAddr, endAddr-startAddr);
    size_t dumpSize = endAddr - startAddr;

    FILE* fp1 = fopen("/proc/self/mem", "r");

    if (fp1 == NULL)
    {
        puts("NULL!");
        exit(1);
    }

    fseek(fp1, startAddr, SEEK_SET);
    
    char* dump = (char*) malloc(dumpSize);
    fread(dump, dumpSize, 1, fp1);
    fclose(fp1);

    FILE* fp2 = fopen("dump", "w");
    fwrite(dump, dumpSize, 1, fp2);
    fclose(fp2);
}

int main()
{
    do_stuff();
    encrypt_enc_code_part();
    dumpBinary();

    return 0;
}