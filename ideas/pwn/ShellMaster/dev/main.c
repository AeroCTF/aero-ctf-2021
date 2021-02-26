#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <ctype.h>
#include <stdint.h>

#define MAX_SHELLCODES 2
#define MAX_SHELLCODE_SIZE 6

const char* menu = "======= Shellcode Database =======\n" \
"1. Save shellcode\n" \
"2. View shellcode\n" \
"3. Delete shellcode\n" \
"4. Run shellcode\n" \
"5. Exit\n" \
"> ";

uint32_t limit = 0;
void* addr;
char* shellcodes[MAX_SHELLCODES];

void setup(void);
int read_int(void);

int add_shellcode(void);
int view_shellcode(void);
int delete_shellcode(void);
int run_shellcode(void);

int main()
{
    setup();

    while (1)
    {
        printf(menu);
        int option = read_int();

        if (option > 5 || option < 1)
        {
            puts("{-} Incorrect option!");
            return 0;
        }

        switch (option)
        {
        case 1:
            add_shellcode();
            break;
        case 2:
            view_shellcode();
            break;
        case 3:
            delete_shellcode();
            break;
        case 4:
            run_shellcode();
            break;

        case 5:
        default:
            puts("Bye!");
            return 0;
            break;
        }
    }
    return 0;
};

int add_shellcode(void)
{
    printf("{?} Enter shellcode: ");
    char* newShellcode = (char*) malloc(MAX_SHELLCODE_SIZE);
    memset(newShellcode, 0x0, MAX_SHELLCODE_SIZE);
    
    int nbytes = read(0, newShellcode, MAX_SHELLCODE_SIZE);

    if (newShellcode[nbytes - 1] == '\n')
    {
        newShellcode[nbytes - 1] = '\0';
        nbytes -= 1;
    }

    for (int i = 0; i < nbytes; i++)
    {   
        if (!isalpha(newShellcode[i]))
        {
            if(!isdigit(newShellcode[i]))
            {
                puts("{-} Invalid shellcode!");
                free(newShellcode);
                return 1;
            }
        }
    }
    
    int added = 0;
    for (int i = 0; i < MAX_SHELLCODES; i++)
    {
        if (shellcodes[i] == NULL)
        {
            shellcodes[i] = newShellcode;
            added = 1;
            break;
        }
    }

    if (!added)
    {
        puts("{-} No free space!");
        free(newShellcode);
        return 1;
    }

    return 0;
};

int view_shellcode(void)
{
    uint32_t idx;
    printf("{?} Enter idx: ");
    idx = read_int();

    if (idx < 0 || idx > MAX_SHELLCODES)
    {
        puts("{-} Incorrect idx!");
        return 1;
    }

    if (shellcodes[idx] == NULL)
    {
        puts("{-} No such shellcode!");
        return 1;
    }

    printf("Shellcode: %s\n", shellcodes[idx]);
};

int delete_shellcode(void)
{
    uint32_t idx;
    printf("{?} Enter idx: ");
    idx = read_int();

    if (idx < 0 || idx > MAX_SHELLCODES)
    {
        puts("{-} Incorrect idx!");
        return 1;
    }

    if (shellcodes[idx] == NULL)
    {
        puts("{-} No such shellcode!");
        return 1;
    }

    free(shellcodes[idx]);
    shellcodes[idx] = NULL;
};

int run_shellcode(void)
{
    if (limit == 2)
    {
        puts("{-} You have no more attempts!");
        return 1;
    }
    else{
        limit++;
    }

    uint32_t idx;
    printf("{?} Enter idx: ");
    idx = read_int();

    if (idx < 0 || idx > MAX_SHELLCODES)
    {
        puts("{-} Incorrect idx!");
        return 1;
    }

    if (shellcodes[idx] == NULL)
    {
        puts("{-} No such shellcode!");
        return 1;
    }

    int32_t arg;
    printf("{?} Enter shellcode argument: ");
    scanf("%ul", &arg);

    memset(addr, 0, MAX_SHELLCODE_SIZE);
    memcpy(addr, shellcodes[idx], MAX_SHELLCODE_SIZE);
    *(uint8_t*)(addr + MAX_SHELLCODE_SIZE) = 0x90;
    *(uint8_t*)(addr + MAX_SHELLCODE_SIZE + 1) = 0xc3;
    int (*p)(int) = addr;
    int64_t retcode = p(arg);

    printf("{!} Shellcode return code = %lld\n", retcode);
};

void setup(void)
{
    addr = mmap(0, MAX_SHELLCODES * MAX_SHELLCODE_SIZE, 
        PROT_EXEC | PROT_READ | PROT_WRITE, 
        MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

    setvbuf(stdin, 0, 2, 0);
    setvbuf(stdout, 0, 2, 0);
    setvbuf(stderr, 0, 2, 0);
    //alarm(60);
};

int read_int(void)
{
    char tmp[8];
    int nbytes = read(0, tmp, 8);

    if (tmp[nbytes - 1] == '\n')
    {
        tmp[nbytes - 1] = '\0';
    }

    return atoi(tmp);
}