
_foo:

	MOVLW       51
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
	CLRF        _i+0 
	CLRF        _i+1 
L_foo0:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       16
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__foo5
	MOVLW       0
	SUBWF       _i+0, 0 
L__foo5:
	BTFSC       STATUS+0, 0 
	GOTO        L_foo1
	MOVF        _ptr+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        _ptr+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        _ptr+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_UART1_Write_data_+0
	CALL        _UART1_Write+0, 0
	MOVLW       1
	ADDWF       _ptr+0, 1 
	MOVLW       0
	ADDWFC      _ptr+1, 1 
	ADDWFC      _ptr+2, 1 
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_foo3:
	DECFSZ      R13, 1, 1
	BRA         L_foo3
	DECFSZ      R12, 1, 1
	BRA         L_foo3
	DECFSZ      R11, 1, 1
	BRA         L_foo3
	NOP
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_foo0
L_foo1:
L_end_foo:
	RETURN      0
; end of _foo

_main:

	GOTO        8448
	CALL        8448, 0
L_end_main:
	GOTO        $+0
; end of _main
