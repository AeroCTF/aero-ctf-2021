#line 1 "C:/Users/anon/Documents/MikroC/MikroElektronika_RS-232_Bootloader/P18/032K/boot18_32K.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 15 "C:/Users/anon/Documents/MikroC/MikroElektronika_RS-232_Bootloader/P18/032K/boot18_32K.c"
static char block[64];

void Susart_Init(unsigned short brg_reg) org 32468 {
 unsigned short i;

 RCSTA = 0x90;
 TXSTA = 0x26;
 TRISC.B7 = 1;
 TRISC.B6 = 0;

 while (PIR1.RCIF)
 i = RCREG;

 SPBRG = brg_reg;
}


void Susart_Write(unsigned short data_) org 32420 {

 while (!TXSTA.TRMT)
 ;
 TXREG = data_;
}

unsigned short Susart_Data_Ready() org 32452 {
 return (PIR1.RCIF);
}

unsigned short Susart_Read() org 32392 {
 unsigned short rslt;
 rslt = RCREG;
 PIR1.RCIF = 0;
 if (RCSTA.OERR) {
 RCSTA.CREN = 0;
 RCSTA.CREN = 1;
 }
 return rslt;
}





void Start_Program() org 0x7FC0 {
}

void Flash_Write_Sector(long address, char *sdata) org 32212 {
 unsigned short saveintcon, i, j;

 saveintcon = INTCON;


 TBLPTRL =  ((char *)&address)[0] ;
 TBLPTRH =  ((char *)&address)[1] ;
 TBLPTRU =  ((char *)&address)[2] ;

 EECON1.EEPGD = 1;
 EECON1.CFGS = 0;
 EECON1.WREN = 1;
 EECON1.FREE = 1;
 INTCON.GIE = 0;
 EECON2 = 0x55;
 EECON2 = 0xAA;
 EECON1.WR = 1;
 INTCON.GIE = 1;
 asm TBLRD*- ;

 FSR0L =  ((char *)&sdata)[0] ;
 FSR0H =  ((char *)&sdata)[1] ;
 j = 0;
 while (j < _FLASH_ERASE/_FLASH_WRITE_LATCH) {
 i = 0;
 while (i < _FLASH_WRITE_LATCH) {
 TABLAT = POSTINC0;
 asm {
 TBLWT+*
 }
 i++;
 }
 EECON1.EEPGD = 1;
 EECON1.CFGS = 0;
 EECON1.WREN = 1;
 INTCON.GIE = 0;
 EECON2 = 0x55;
 EECON2 = 0xAA;
 EECON1.WR = 1;
 j++;
 }
 INTCON.GIE = 1;
 EECON1.WREN = 0;

 INTCON = saveintcon;
}

unsigned short Susart_Write_Loop(char send, char receive) org 32156 {
 unsigned short rslt = 0;

 LBL_BOOT18_32_01:
 ___Boot_Delay32k();
 Susart_Write(send);
 ___Boot_Delay32k();

 rslt++;
 if (rslt == 255u)
 return 0;
 if (Susart_Read() == receive)
 return 1;
 goto LBL_BOOT18_32_01;
}





void Write_Begin() org 32336 {

 Flash_Write_Sector(0x7FC0, block);

 block[0] = 0xC4;
 block[1] = 0xEF;
 block[2] = 0x3C;
 block[3] = 0xF0;
}


void Start_Bootload() org 31504 {
 unsigned short i = 0, xx, yy;
 unsigned short cc = 0;
 long j = 0;

 while (1) {
 if (i == 64u) {

 if (!j)
 Write_Begin();
 Flash_Write_Sector(j, block);

 i = 0;
 j += 0x40;
 }


 Susart_Write('c');

 while (!Susart_Data_Ready()) ;
 cc = Susart_Read();
 if(cc == 0x52){
 Start_Program();
 }

 Susart_Write('y');
 while (!Susart_Data_Ready()) ;

 yy = Susart_Read();


 Susart_Write('x');
 while (!Susart_Data_Ready()) ;

 xx = Susart_Read();


 block[i++] = yy;
 block[i++] = xx;
 }
}
