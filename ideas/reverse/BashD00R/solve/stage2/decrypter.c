#include <unistd.h> 
#include <stdio.h>  
#include <stdlib.h> 
#include <string.h> 
#include "serpent.h"
#include <fcntl.h> 
#include <sys/stat.h> 
#include <sys/types.h>

int sendVerdict(int);
int checkPassword(char*);
unsigned char* decrypt_string(int value);
void decryptstr(unsigned char* ptr, int size);

int main(int argc, char* argv[], char* envp[])
{
    unsigned const char* key_string  = decrypt_string(8);
    unsigned char * encrypted_string1  = malloc(16);
    unsigned char * encrypted_string2  = malloc(16);

    unsigned char * out1  = malloc(16);
    unsigned char * out2  = malloc(16);
    
    memcpy(encrypted_string1, "\x92\x01\xab\x88\xf3\xaa\x01\x96\x35\x67\xe0\xb4\x1b\x59\x27\x21", 16);
    memcpy(encrypted_string2, "\x26\x72\x6c\xdc\x2f\x4e\x2c\x58\x9d\x7a\x0c\x11\x62\x88\x0b\xc0", 16);

    serpent_decrypt_bitslice(encrypted_string1, key_string, out1, 16);
    serpent_decrypt_bitslice(encrypted_string2, key_string, out2, 16);

    printf("password = %s%s\n", out1, out2);

    free(encrypted_string1);
    free(encrypted_string2);
    return 0;
};

void decryptstr(unsigned char* ptr, int size)
{
  int state = 24;
  for (int i = 0; i < size; i++)
  {
    ptr[i] ^= state;
    state = ((state + 13) * 4)%243;
  }
};

unsigned char* decrypt_string(int value)
{
  unsigned char* targetStr = malloc(4096);
  memset(targetStr, 0, 4096);

  switch (value)
  {
    case 1:
      {
        memcpy(targetStr, "\x37\xe4\xec\xa9\x10\x35\xef\xdb\x3f\xeb\xad\x25\xed\xd3\x57\xb5\x28", 17);
        decryptstr(targetStr, 17);
        break;
      }
    case 2:
    {
      memcpy(targetStr, "\x37\xe4\xec\xa9\x10\x35\xef\xdb\x3f\xeb\xad\x3b\xfc\xdf", 14);
      decryptstr(targetStr, 14);
      break;
    }
    case 3:
    {
      memcpy(targetStr, "\x37\xfc\xf1\xab\x16\x35\xfd\xd0\x3c\xe3\xad\x78\xe9\xc0\x4c\xa6\x32\xc1\x6a", 19);
      decryptstr(targetStr, 19);
      break;
    }
    case 4:
    {
      memcpy(targetStr, "\x5f\xda\xd6\x9c\x39\x4d\xc9\xec\x18\xc7\xc4", 11);
      decryptstr(targetStr, 11);
      break;
    }
    case 5:
    {
      memcpy(targetStr, "\x37\xe0\xf3\xb6\x5c\x6e\xf1\xce\x7e\xb9\xe0\x62\xfc\xd6\x45\xf2\x3a\x9c\x6b\x42\x39\x5a\x97", 23);
      decryptstr(targetStr, 23);
      break;
    }
    case 6:
    {
        memcpy(targetStr, "\x37\xe4\xec\xa9\x10\x35\xef\xdb\x3f\xeb\xad\x30\xfd\x9d\x10\xf1\x68\x9e\x38", 19);
        decryptstr(targetStr, 19);
        break;
    }
    case 7:
    {
        memcpy(targetStr, "\x37\xe0\xf3\xb6\x5c\x6e\xf1\xce\x7e\xeb\xe7\x63\xad\xd0\x40\xf0\x3a", 17);
        decryptstr(targetStr, 17);
        break;
    }
    case 8:
    {
        memcpy(targetStr, "\x5c\xfc\xaf\x8f\x6\x57\xab\xed\x5\xba\xfa\x31\xc3\xe2\x1b\xb1", 16);
        decryptstr(targetStr, 16);
        break;
    }
    default:
      return NULL;
  }
  return targetStr;
};