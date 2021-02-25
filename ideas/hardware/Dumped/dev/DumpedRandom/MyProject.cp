#line 1 "C:/Users/anon/Documents/MikroC/DumpedRandom/MyProject.c"
void foo(){
 UART1_Init(9600);
 while(1){
 UART1_Write('A');
 Delay_ms(100);
 }
}

sbit LCD_RS at RE2_bit;
sbit LCD_EN at RE1_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D3 at RD3_bit;
sbit LCD_D2 at RD2_bit;
sbit LCD_D1 at RD1_bit;
sbit LCD_D0 at RD0_bit;

sbit LCD_RS_Direction at TRISE2_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D3_Direction at TRISD3_bit;
sbit LCD_D2_Direction at TRISD2_bit;
sbit LCD_D1_Direction at TRISD1_bit;
sbit LCD_D0_Direction at TRISD0_bit;

unsigned int temp_res;
char s_temp_res[16];
char randchar[10];
unsigned int r = 0;
int i = 0;


struct seed_t{unsigned long int x,y,z,w;};
struct seed_t xs_seed;

unsigned long int XorShift128()
{
 unsigned long int t = xs_seed.x^(xs_seed.x<<11);
 xs_seed.x = xs_seed.y;
 xs_seed.y = xs_seed.z;
 xs_seed.z = xs_seed.w;
 xs_seed.w = (xs_seed.w^(xs_seed.w>>19)) ^ (t^(t>>8));
 return xs_seed.w;
}

unsigned short P2_sreg;

unsigned short P2_Read_Random()
{
 P2_sreg =
 (((((P2_sreg & 0x80) >> 7) ^
 ((P2_sreg & 0x20) >> 5)) ^
 (((P2_sreg & 0x10) >> 4) ^
 ((P2_sreg & 0x08) >> 3))) ^ 1) |
 (P2_sreg << 1);
 return P2_sreg;
}




unsigned long int lfsr32, lfsr31;

unsigned long int shift_lfsr(unsigned long int *lfsr, unsigned long int polynomial_mask){
 unsigned long int feedback;
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

unsigned long int get_random(){
 shift_lfsr(&lfsr32,  0xB4BCD35C );
 return (shift_lfsr(&lfsr32,  0xB4BCD35C )^shift_lfsr(&lfsr31,  0x7A5BC2E3 ))&0xffff;
}

char enc_flag[21] = {0x1d,0x39,0x71,0x1,0x82,0xfb, 0xcc, 0x1, 0xec, 0x86, 0x40, 0xf6, 0x53, 0x34, 0x5b, 0xa5,0xc4, 0x4, 0x79,0x43, 0};

void decode_flag_1(){
 srand(0x1337);
 rand();
 xs_seed.x = rand();
 xs_seed.y = rand();
 xs_seed.z = rand();
 xs_seed.w = rand();
 for(i = 0; i <  20 ; i++){
 int r = rand();
 }
 for(i = 0; i <  20 ; i++){
 int r = XorShift128();
 }
 P2_sreg = XorShift128() & 0xff;
 P2_Read_Random();
 P2_Read_Random();
 for( i = 0; i <  20 ; i++){
 int r = P2_Read_Random();
 }
 init_lfsrs();
 lfsr32 ^= XorShift128();
 lfsr31 ^= XorShift128();
 for( i = 0; i <  20 ; i++){
 int r = get_random();
 enc_flag[i] ^= r & 0xff;
 }
}

void decode_flag_2(){
 srand(0x1337);
 rand();
 xs_seed.x = rand();
 xs_seed.y = rand();
 xs_seed.z = rand();
 xs_seed.w = rand();
 for(i = 0; i <  20 ; i++){
 int r = rand();
 }
 for(i = 0; i <  20 ; i++){
 int r = XorShift128();
 }
 P2_sreg = XorShift128() & 0xff;
 P2_Read_Random();
 P2_Read_Random();
 for(i = 0; i <  20 ; i++){
 int r = P2_Read_Random();
 enc_flag[i] ^= r & 0xff;
 }
}

void decode_flag_3(){
 srand(0x1337);
 rand();
 xs_seed.x = rand();
 xs_seed.y = rand();
 xs_seed.z = rand();
 xs_seed.w = rand();
 for(i = 0; i <  20 ; i++){
 int r = rand();
 }
 for(i = 0; i <  20 ; i++){
 int r = XorShift128();
 enc_flag[i] ^= r & 0xff;
 }
}
void decode_flag_4(){
 srand(0x1337);
 rand();
 xs_seed.x = rand();
 xs_seed.y = rand();
 xs_seed.z = rand();
 xs_seed.w = rand();
 for(i = 0; i <  20 ; i++){
 int r = rand();
 enc_flag[i] ^= r >> 8;
 }
}

void decodeFlag(){
 decode_flag_1();
 decode_flag_2();
 decode_flag_3();
 decode_flag_4();
}

void main(){
 srand(0x1337);
 IntToStr(rand(), randchar);
 Lcd_Init();
 Lcd_Out(1, 5, "Aero");
 Lcd_Out(2, 1, "{Y0u_c4N_dmp_1t}");
 Lcd_Out(4, 1, randchar);


 TRISC2_bit=0;
 RC2_bit=1;


 TRISB3_bit=1;


 ADC_Init();
 for(i; i < 50; i++)
 {
 temp_res = ADC_Read(2);
 IntToStr(temp_res/2, s_temp_res);
 Lcd_Out(3, 1, s_temp_res);
 Delay_ms(10);
 }
 TRISC5_bit=0;
 RC5_bit=1;
 while(1){
 temp_res = ADC_Read(2);
 IntToStr(temp_res/2, s_temp_res);
 Lcd_Out(3, 1, s_temp_res);
 Delay_ms(10);
 if(!RB3_bit){
 decodeFlag();
 Delay_ms(1000);
 Lcd_Out(4, -3, enc_flag+4);
 }
 }
 RC5_bit=0;
 }
