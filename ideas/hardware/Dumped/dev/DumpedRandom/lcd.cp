#line 1 "C:/Users/anon/Documents/MikroC/DumpedRandom/lcd.c"
#line 1 "c:/users/anon/documents/mikroc/dumpedrandom/lcd.h"
#line 42 "c:/users/anon/documents/mikroc/dumpedrandom/lcd.h"
void lcd_init(void);
void lcd_cmd(unsigned char val);
void lcd_dat(unsigned char val);
void lcd_str(char* str);
#line 1 "c:/users/anon/documents/mikroc/dumpedrandom/atraso.h"
#line 26 "c:/users/anon/documents/mikroc/dumpedrandom/atraso.h"
void atraso_ms(unsigned int valor);
#line 29 "C:/Users/anon/Documents/MikroC/DumpedRandom/lcd.c"
void lcd_wr(unsigned char val)
{
  PORTD =val;
}

void lcd_cmd(unsigned char val)
{
  RE1_bit =1;
 lcd_wr(val);
  RE2_bit =0;
 atraso_ms(3);
  RE1_bit =0;
 atraso_ms(3);
  RE1_bit =1;
}

void lcd_dat(unsigned char val)
{
  RE1_bit =1;
 lcd_wr(val);
  RE2_bit =1;
 atraso_ms(3);
  RE1_bit =0;
 atraso_ms(3);
  RE1_bit =1;
}

void lcd_init(void)
{
  RE1_bit =0;
  RE2_bit =0;
 atraso_ms(20);
  RE1_bit =1;

 lcd_cmd( 0x38 );
 atraso_ms(5);
 lcd_cmd( 0x38 );
 atraso_ms(1);
 lcd_cmd( 0x38 );
 lcd_cmd( 0x08 );
 lcd_cmd( 0x0F );
 lcd_cmd( 0x01 );
 lcd_cmd( 0x38 );
 lcd_cmd( 0x80 );
}

void lcd_str(char* str)
{
 unsigned char i=0;

 while(str[i] != 0 )
 {
 lcd_dat(str[i]);
 i++;
 }
}
