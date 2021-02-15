#line 1 "C:/Users/anon/Documents/MikroC/MikroElektronika_RS-232_Bootloader/P18/032K/Boot_Loader.c"
#line 41 "C:/Users/anon/Documents/MikroC/MikroElektronika_RS-232_Bootloader/P18/032K/Boot_Loader.c"
void Susart_Init(char Brg_reg);
void Susart_Write(char data_);
void Start_Bootload();
void Start_Program();
char Susart_Write_Loop(char send, char recieve);


void main() org 31112 {









 Susart_Init(51);
 if (Susart_Write_Loop('g','r')) {
 Start_Bootload();
 }
 else {
 Start_Program();
 }

}
