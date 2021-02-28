
_lcd_wr:

	MOVF        FARG_lcd_wr_val+0, 0 
	MOVWF       PORTD+0 
L_end_lcd_wr:
	RETURN      0
; end of _lcd_wr

_lcd_cmd:

	BSF         RE1_bit+0, BitPos(RE1_bit+0) 
	MOVF        FARG_lcd_cmd_val+0, 0 
	MOVWF       FARG_lcd_wr_val+0 
	CALL        _lcd_wr+0, 0
	BCF         RE2_bit+0, BitPos(RE2_bit+0) 
	MOVLW       3
	MOVWF       FARG_atraso_ms_valor+0 
	MOVLW       0
	MOVWF       FARG_atraso_ms_valor+1 
	CALL        _atraso_ms+0, 0
	BCF         RE1_bit+0, BitPos(RE1_bit+0) 
	MOVLW       3
	MOVWF       FARG_atraso_ms_valor+0 
	MOVLW       0
	MOVWF       FARG_atraso_ms_valor+1 
	CALL        _atraso_ms+0, 0
	BSF         RE1_bit+0, BitPos(RE1_bit+0) 
L_end_lcd_cmd:
	RETURN      0
; end of _lcd_cmd

_lcd_dat:

	BSF         RE1_bit+0, BitPos(RE1_bit+0) 
	MOVF        FARG_lcd_dat_val+0, 0 
	MOVWF       FARG_lcd_wr_val+0 
	CALL        _lcd_wr+0, 0
	BSF         RE2_bit+0, BitPos(RE2_bit+0) 
	MOVLW       3
	MOVWF       FARG_atraso_ms_valor+0 
	MOVLW       0
	MOVWF       FARG_atraso_ms_valor+1 
	CALL        _atraso_ms+0, 0
	BCF         RE1_bit+0, BitPos(RE1_bit+0) 
	MOVLW       3
	MOVWF       FARG_atraso_ms_valor+0 
	MOVLW       0
	MOVWF       FARG_atraso_ms_valor+1 
	CALL        _atraso_ms+0, 0
	BSF         RE1_bit+0, BitPos(RE1_bit+0) 
L_end_lcd_dat:
	RETURN      0
; end of _lcd_dat

_lcd_init:

	BCF         RE1_bit+0, BitPos(RE1_bit+0) 
	BCF         RE2_bit+0, BitPos(RE2_bit+0) 
	MOVLW       20
	MOVWF       FARG_atraso_ms_valor+0 
	MOVLW       0
	MOVWF       FARG_atraso_ms_valor+1 
	CALL        _atraso_ms+0, 0
	BSF         RE1_bit+0, BitPos(RE1_bit+0) 
	MOVLW       56
	MOVWF       FARG_lcd_cmd_val+0 
	CALL        _lcd_cmd+0, 0
	MOVLW       5
	MOVWF       FARG_atraso_ms_valor+0 
	MOVLW       0
	MOVWF       FARG_atraso_ms_valor+1 
	CALL        _atraso_ms+0, 0
	MOVLW       56
	MOVWF       FARG_lcd_cmd_val+0 
	CALL        _lcd_cmd+0, 0
	MOVLW       1
	MOVWF       FARG_atraso_ms_valor+0 
	MOVLW       0
	MOVWF       FARG_atraso_ms_valor+1 
	CALL        _atraso_ms+0, 0
	MOVLW       56
	MOVWF       FARG_lcd_cmd_val+0 
	CALL        _lcd_cmd+0, 0
	MOVLW       8
	MOVWF       FARG_lcd_cmd_val+0 
	CALL        _lcd_cmd+0, 0
	MOVLW       15
	MOVWF       FARG_lcd_cmd_val+0 
	CALL        _lcd_cmd+0, 0
	MOVLW       1
	MOVWF       FARG_lcd_cmd_val+0 
	CALL        _lcd_cmd+0, 0
	MOVLW       56
	MOVWF       FARG_lcd_cmd_val+0 
	CALL        _lcd_cmd+0, 0
	MOVLW       128
	MOVWF       FARG_lcd_cmd_val+0 
	CALL        _lcd_cmd+0, 0
L_end_lcd_init:
	RETURN      0
; end of _lcd_init

_lcd_str:

	CLRF        lcd_str_i_L0+0 
L_lcd_str0:
	MOVF        lcd_str_i_L0+0, 0 
	ADDWF       FARG_lcd_str_str+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_str_str+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_str1
	MOVF        lcd_str_i_L0+0, 0 
	ADDWF       FARG_lcd_str_str+0, 0 
	MOVWF       FSR0L+0 
	MOVLW       0
	ADDWFC      FARG_lcd_str_str+1, 0 
	MOVWF       FSR0L+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_lcd_dat_val+0 
	CALL        _lcd_dat+0, 0
	INCF        lcd_str_i_L0+0, 1 
	GOTO        L_lcd_str0
L_lcd_str1:
L_end_lcd_str:
	RETURN      0
; end of _lcd_str
