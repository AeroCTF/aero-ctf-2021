
_main:

	MOVLW       51
	MOVWF       FARG_Susart_Init_Brg_reg+0 
	CALL        _Susart_Init+0, 0
	MOVLW       103
	MOVWF       FARG_Susart_Write_Loop_send+0 
	MOVLW       114
	MOVWF       FARG_Susart_Write_Loop_recieve+0 
	CALL        _Susart_Write_Loop+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main0
	CALL        _Start_Bootload+0, 0
	GOTO        L_main1
L_main0:
	CALL        _Start_Program+0, 0
L_main1:
L_end_main:
	GOTO        $+0
; end of _main
