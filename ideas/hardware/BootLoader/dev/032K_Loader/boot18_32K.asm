
_Susart_Init:

	MOVLW       144
	MOVWF       RCSTA+0 
	MOVLW       38
	MOVWF       TXSTA+0 
	BSF         TRISC+0, 7 
	BCF         TRISC+0, 6 
L_Susart_Init0:
	BTFSS       PIR1+0, 5 
	GOTO        L_Susart_Init1
	MOVF        RCREG+0, 0 
	MOVWF       Susart_Init_i_L0+0 
	GOTO        L_Susart_Init0
L_Susart_Init1:
	MOVF        FARG_Susart_Init_brg_reg+0, 0 
	MOVWF       SPBRG+0 
L_end_Susart_Init:
	RETURN      0
; end of _Susart_Init

_Susart_Write:

L_Susart_Write2:
	BTFSC       TXSTA+0, 1 
	GOTO        L_Susart_Write3
	GOTO        L_Susart_Write2
L_Susart_Write3:
	MOVF        FARG_Susart_Write_data_+0, 0 
	MOVWF       TXREG+0 
L_end_Susart_Write:
	RETURN      0
; end of _Susart_Write

_Susart_Data_Ready:

	MOVLW       0
	BTFSC       PIR1+0, 5 
	MOVLW       1
	MOVWF       R0 
L_end_Susart_Data_Ready:
	RETURN      0
; end of _Susart_Data_Ready

_Susart_Read:

	MOVF        RCREG+0, 0 
	MOVWF       Susart_Read_rslt_L0+0 
	BCF         PIR1+0, 5 
	BTFSS       RCSTA+0, 1 
	GOTO        L_Susart_Read4
	BCF         RCSTA+0, 4 
	BSF         RCSTA+0, 4 
L_Susart_Read4:
	MOVF        Susart_Read_rslt_L0+0, 0 
	MOVWF       R0 
L_end_Susart_Read:
	RETURN      0
; end of _Susart_Read

_Start_Program:

L_end_Start_Program:
	RETURN      0
; end of _Start_Program

_Flash_Write_Sector:

	MOVF        INTCON+0, 0 
	MOVWF       Flash_Write_Sector_saveintcon_L0+0 
	MOVF        FARG_Flash_Write_Sector_address+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_Flash_Write_Sector_address+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_Flash_Write_Sector_address+2, 0 
	MOVWF       TBLPTRU+0 
	BSF         EECON1+0, 7 
	BCF         EECON1+0, 6 
	BSF         EECON1+0, 2 
	BSF         EECON1+0, 4 
	BCF         INTCON+0, 7 
	MOVLW       85
	MOVWF       EECON2+0 
	MOVLW       170
	MOVWF       EECON2+0 
	BSF         EECON1+0, 1 
	BSF         INTCON+0, 7 
	TBLRD*-
	MOVF        FARG_Flash_Write_Sector_sdata+0, 0 
	MOVWF       FSR0L+0 
	MOVF        FARG_Flash_Write_Sector_sdata+1, 0 
	MOVWF       FSR0H+0 
	CLRF        Flash_Write_Sector_j_L0+0 
L_Flash_Write_Sector5:
	MOVLW       2
	SUBWF       Flash_Write_Sector_j_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Flash_Write_Sector6
	CLRF        Flash_Write_Sector_i_L0+0 
L_Flash_Write_Sector7:
	MOVLW       32
	SUBWF       Flash_Write_Sector_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Flash_Write_Sector8
	MOVF        POSTINC0+0, 0 
	MOVWF       TABLAT+0 
	TBLWT+*
	INCF        Flash_Write_Sector_i_L0+0, 1 
	GOTO        L_Flash_Write_Sector7
L_Flash_Write_Sector8:
	BSF         EECON1+0, 7 
	BCF         EECON1+0, 6 
	BSF         EECON1+0, 2 
	BCF         INTCON+0, 7 
	MOVLW       85
	MOVWF       EECON2+0 
	MOVLW       170
	MOVWF       EECON2+0 
	BSF         EECON1+0, 1 
	INCF        Flash_Write_Sector_j_L0+0, 1 
	GOTO        L_Flash_Write_Sector5
L_Flash_Write_Sector6:
	BSF         INTCON+0, 7 
	BCF         EECON1+0, 2 
	MOVF        Flash_Write_Sector_saveintcon_L0+0, 0 
	MOVWF       INTCON+0 
L_end_Flash_Write_Sector:
	RETURN      0
; end of _Flash_Write_Sector

_Susart_Write_Loop:

	CLRF        Susart_Write_Loop_rslt_L0+0 
___Susart_Write_Loop_LBL_BOOT18_32_01:
	CALL        32072, 0
	MOVF        FARG_Susart_Write_Loop_send+0, 0 
	MOVWF       FARG_Susart_Write_data_+0 
	CALL        32420, 0
	CALL        32072, 0
	INCF        Susart_Write_Loop_rslt_L0+0, 1 
	MOVF        Susart_Write_Loop_rslt_L0+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_Susart_Write_Loop9
	CLRF        R0 
	GOTO        L_end_Susart_Write_Loop
L_Susart_Write_Loop9:
	CALL        32392, 0
	MOVF        R0, 0 
	XORWF       FARG_Susart_Write_Loop_receive+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Susart_Write_Loop10
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Susart_Write_Loop
L_Susart_Write_Loop10:
	GOTO        ___Susart_Write_Loop_LBL_BOOT18_32_01
L_end_Susart_Write_Loop:
	RETURN      0
; end of _Susart_Write_Loop

_Write_Begin:

	MOVLW       192
	MOVWF       FARG_Flash_Write_Sector_address+0 
	MOVLW       127
	MOVWF       FARG_Flash_Write_Sector_address+1 
	MOVLW       0
	MOVWF       FARG_Flash_Write_Sector_address+2 
	MOVWF       FARG_Flash_Write_Sector_address+3 
	MOVLW       boot18_32K_block+0
	MOVWF       FARG_Flash_Write_Sector_sdata+0 
	MOVLW       hi_addr(boot18_32K_block+0)
	MOVWF       FARG_Flash_Write_Sector_sdata+1 
	CALL        32212, 0
	MOVLW       196
	MOVWF       boot18_32K_block+0 
	MOVLW       239
	MOVWF       boot18_32K_block+1 
	MOVLW       60
	MOVWF       boot18_32K_block+2 
	MOVLW       240
	MOVWF       boot18_32K_block+3 
L_end_Write_Begin:
	RETURN      0
; end of _Write_Begin

_Start_Bootload:

	CLRF        Start_Bootload_i_L0+0 
	CLRF        Start_Bootload_cc_L0+0 
	CLRF        Start_Bootload_j_L0+0 
	CLRF        Start_Bootload_j_L0+1 
	CLRF        Start_Bootload_j_L0+2 
	CLRF        Start_Bootload_j_L0+3 
L_Start_Bootload11:
	MOVF        Start_Bootload_i_L0+0, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload13
	MOVF        Start_Bootload_j_L0+0, 0 
	IORWF       Start_Bootload_j_L0+1, 0 
	IORWF       Start_Bootload_j_L0+2, 0 
	IORWF       Start_Bootload_j_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload14
	CALL        32336, 0
L_Start_Bootload14:
	MOVF        Start_Bootload_j_L0+0, 0 
	MOVWF       FARG_Flash_Write_Sector_address+0 
	MOVF        Start_Bootload_j_L0+1, 0 
	MOVWF       FARG_Flash_Write_Sector_address+1 
	MOVF        Start_Bootload_j_L0+2, 0 
	MOVWF       FARG_Flash_Write_Sector_address+2 
	MOVF        Start_Bootload_j_L0+3, 0 
	MOVWF       FARG_Flash_Write_Sector_address+3 
	MOVLW       boot18_32K_block+0
	MOVWF       FARG_Flash_Write_Sector_sdata+0 
	MOVLW       hi_addr(boot18_32K_block+0)
	MOVWF       FARG_Flash_Write_Sector_sdata+1 
	CALL        32212, 0
	CLRF        Start_Bootload_i_L0+0 
	MOVLW       64
	ADDWF       Start_Bootload_j_L0+0, 1 
	MOVLW       0
	ADDWFC      Start_Bootload_j_L0+1, 1 
	ADDWFC      Start_Bootload_j_L0+2, 1 
	ADDWFC      Start_Bootload_j_L0+3, 1 
L_Start_Bootload13:
	MOVLW       99
	MOVWF       FARG_Susart_Write_data_+0 
	CALL        32420, 0
L_Start_Bootload15:
	CALL        32452, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload16
	GOTO        L_Start_Bootload15
L_Start_Bootload16:
	CALL        32392, 0
	MOVF        R0, 0 
	MOVWF       Start_Bootload_cc_L0+0 
	MOVF        Start_Bootload_cc_L0+0, 0 
	XORLW       82
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload17
	CALL        32704, 0
L_Start_Bootload17:
	MOVLW       121
	MOVWF       FARG_Susart_Write_data_+0 
	CALL        32420, 0
L_Start_Bootload18:
	CALL        32452, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload19
	GOTO        L_Start_Bootload18
L_Start_Bootload19:
	CALL        32392, 0
	MOVF        R0, 0 
	MOVWF       Start_Bootload_yy_L0+0 
	MOVLW       120
	MOVWF       FARG_Susart_Write_data_+0 
	CALL        32420, 0
L_Start_Bootload20:
	CALL        32452, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Start_Bootload21
	GOTO        L_Start_Bootload20
L_Start_Bootload21:
	CALL        32392, 0
	MOVF        R0, 0 
	MOVWF       Start_Bootload_xx_L0+0 
	MOVLW       boot18_32K_block+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(boot18_32K_block+0)
	MOVWF       FSR1L+1 
	MOVF        Start_Bootload_i_L0+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	MOVF        Start_Bootload_yy_L0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        Start_Bootload_i_L0+0, 1 
	MOVLW       boot18_32K_block+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(boot18_32K_block+0)
	MOVWF       FSR1L+1 
	MOVF        Start_Bootload_i_L0+0, 0 
	ADDWF       FSR1L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1L+1, 1 
	MOVF        Start_Bootload_xx_L0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        Start_Bootload_i_L0+0, 1 
	GOTO        L_Start_Bootload11
L_end_Start_Bootload:
	RETURN      0
; end of _Start_Bootload
