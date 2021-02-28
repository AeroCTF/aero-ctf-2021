/*
 * Project name:
     Boot_Test (using mikroC Bootloader on PIC18's)
 * Copyright:
     (c) Mikroelektronika, 2008.
 * Revision History:
     20051120:
       - initial release
 * Description:
     This is a serial port Bootloader implementation. All required bootloader
     routines are placed in the boot18_32K file, the only thing that is
     user-configurable is the baudrate of the UART communication, which is set
     in the main() through appropriate call to Susart_Init(brg_reg). The
     USART module is being initialized like this:
       - TXSTA.BRGH = 1 (High-speed mode);
       - SPBRG = brg_reg;
     You can use the appropriate formulas and tables from the target MCU's
     datasheet to establish the desired baudrate.
     Once started in PIC, the bootloader waits for a while (approx. 5 seconds)
     to establish UART communication with the MikroBootloader application on the
     PC. If it fails to do so, the bootloader starts the programme already
     loaded in the MCU (initially it is just a NOP). If the communication is
     established, the bootloader receives the hex file from the PC and places it
     where requred (the MikroBootloader application reads out the hex file and
     takes care of the location where hex is to be placed). When hex download
     has finished, the user is notified by the MikroBootloader to reset the MCU,
     and MCU enters the described bootload sequence again.
 * Test configuration:
     MCU:             PIC18F4520
                      http://ww1.microchip.com/downloads/en/DeviceDoc/39631E.pdf
     Oscillator:      HS, 8.00000 MHz
     Ext. Modules:    None.
     SW:              mikroC PRO for PIC
                      http://www.mikroe.com/mikroc/pic/
 * NOTES:
     - It's recommended not to alter the start address of the main().
       Otherwise, less space in ROM will be available for the application being bootloaded.
     - RX and TX UART switches should be turned On (board specific).
 */

void Susart_Init(char Brg_reg);
void Susart_Write(char data_);
void Start_Bootload();
void Start_Program();
char Susart_Write_Loop(char send, char recieve);

//-------------- Boootloader main for 32K PIC18's
void main() org 31112 {  // 1
    // 16Mhz --> 103           look for asynchronous high speed table
    //  8Mhz -->  51
    //  4Mhz -->  25
    //            |
    //            |
    //            |
    //           \ /
    //            |

    Susart_Init(51);                    // Init USART at 9600
    if (Susart_Write_Loop('g','r')) {   // Send 'g' for ~5 sec, if 'r'
      Start_Bootload();                 //   received start bootload
    }
    else {
      Start_Program();                  //   else start program
    }

}