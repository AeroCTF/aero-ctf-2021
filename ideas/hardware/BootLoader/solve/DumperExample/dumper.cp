#line 1 "C:/Users/anon/Documents/MikroC/DumperExample/dumper.c"
#pragma orgall 0x2000
#line 3 "C:/Users/anon/Documents/MikroC/DumperExample/dumper.c"
code char *ptr = 0;
int i = 0;

void foo() org 0x2100{
 UART1_Init(9600);
 for(i = 0; i < 0x1000; i++){
 UART1_Write(*ptr);
 ptr += 1;
 Delay_ms(100);
 }
}

void main() org 0x2000{
 asm{
 GOTO 0x2100;
 }
 foo();
}
