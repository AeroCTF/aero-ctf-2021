
_atraso_ms:

	CLRF        atraso_ms_i_L0+0 
	CLRF        atraso_ms_i_L0+1 
L_atraso_ms0:
	MOVF        FARG_atraso_ms_valor+1, 0 
	SUBWF       atraso_ms_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__atraso_ms7
	MOVF        FARG_atraso_ms_valor+0, 0 
	SUBWF       atraso_ms_i_L0+0, 0 
L__atraso_ms7:
	BTFSC       STATUS+0, 0 
	GOTO        L_atraso_ms1
	CLRF        atraso_ms_j_L0+0 
L_atraso_ms3:
	MOVLW       200
	SUBWF       atraso_ms_j_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_atraso_ms4
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	INCF        atraso_ms_j_L0+0, 1 
	GOTO        L_atraso_ms3
L_atraso_ms4:
	INFSNZ      atraso_ms_i_L0+0, 1 
	INCF        atraso_ms_i_L0+1, 1 
	GOTO        L_atraso_ms0
L_atraso_ms1:
L_end_atraso_ms:
	RETURN      0
; end of _atraso_ms
