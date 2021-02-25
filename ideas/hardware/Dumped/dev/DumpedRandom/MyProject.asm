
_foo:

	MOVLW       51
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
L_foo0:
	MOVLW       65
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_foo2:
	DECFSZ      R13, 1, 1
	BRA         L_foo2
	DECFSZ      R12, 1, 1
	BRA         L_foo2
	DECFSZ      R11, 1, 1
	BRA         L_foo2
	NOP
	GOTO        L_foo0
L_end_foo:
	RETURN      0
; end of _foo

_XorShift128:

	MOVLW       11
	MOVWF       R4 
	MOVF        _xs_seed+0, 0 
	MOVWF       R0 
	MOVF        _xs_seed+1, 0 
	MOVWF       R1 
	MOVF        _xs_seed+2, 0 
	MOVWF       R2 
	MOVF        _xs_seed+3, 0 
	MOVWF       R3 
	MOVF        R4, 0 
L__XorShift12845:
	BZ          L__XorShift12846
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	ADDLW       255
	GOTO        L__XorShift12845
L__XorShift12846:
	MOVF        R0, 0 
	XORWF       _xs_seed+0, 0 
	MOVWF       XorShift128_t_L0+0 
	MOVF        R1, 0 
	XORWF       _xs_seed+1, 0 
	MOVWF       XorShift128_t_L0+1 
	MOVF        R2, 0 
	XORWF       _xs_seed+2, 0 
	MOVWF       XorShift128_t_L0+2 
	MOVF        R3, 0 
	XORWF       _xs_seed+3, 0 
	MOVWF       XorShift128_t_L0+3 
	MOVF        _xs_seed+4, 0 
	MOVWF       _xs_seed+0 
	MOVF        _xs_seed+5, 0 
	MOVWF       _xs_seed+1 
	MOVF        _xs_seed+6, 0 
	MOVWF       _xs_seed+2 
	MOVF        _xs_seed+7, 0 
	MOVWF       _xs_seed+3 
	MOVF        _xs_seed+8, 0 
	MOVWF       _xs_seed+4 
	MOVF        _xs_seed+9, 0 
	MOVWF       _xs_seed+5 
	MOVF        _xs_seed+10, 0 
	MOVWF       _xs_seed+6 
	MOVF        _xs_seed+11, 0 
	MOVWF       _xs_seed+7 
	MOVF        _xs_seed+12, 0 
	MOVWF       _xs_seed+8 
	MOVF        _xs_seed+13, 0 
	MOVWF       _xs_seed+9 
	MOVF        _xs_seed+14, 0 
	MOVWF       _xs_seed+10 
	MOVF        _xs_seed+15, 0 
	MOVWF       _xs_seed+11 
	MOVLW       19
	MOVWF       R4 
	MOVF        _xs_seed+12, 0 
	MOVWF       R0 
	MOVF        _xs_seed+13, 0 
	MOVWF       R1 
	MOVF        _xs_seed+14, 0 
	MOVWF       R2 
	MOVF        _xs_seed+15, 0 
	MOVWF       R3 
	MOVF        R4, 0 
L__XorShift12847:
	BZ          L__XorShift12848
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R3, 7 
	ADDLW       255
	GOTO        L__XorShift12847
L__XorShift12848:
	MOVF        R0, 0 
	XORWF       _xs_seed+12, 0 
	MOVWF       R5 
	MOVF        R1, 0 
	XORWF       _xs_seed+13, 0 
	MOVWF       R6 
	MOVF        R2, 0 
	XORWF       _xs_seed+14, 0 
	MOVWF       R7 
	MOVF        R3, 0 
	XORWF       _xs_seed+15, 0 
	MOVWF       R8 
	MOVF        XorShift128_t_L0+1, 0 
	MOVWF       R0 
	MOVF        XorShift128_t_L0+2, 0 
	MOVWF       R1 
	MOVF        XorShift128_t_L0+3, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVF        XorShift128_t_L0+0, 0 
	XORWF       R0, 1 
	MOVF        XorShift128_t_L0+1, 0 
	XORWF       R1, 1 
	MOVF        XorShift128_t_L0+2, 0 
	XORWF       R2, 1 
	MOVF        XorShift128_t_L0+3, 0 
	XORWF       R3, 1 
	MOVF        R5, 0 
	XORWF       R0, 1 
	MOVF        R6, 0 
	XORWF       R1, 1 
	MOVF        R7, 0 
	XORWF       R2, 1 
	MOVF        R8, 0 
	XORWF       R3, 1 
	MOVF        R0, 0 
	MOVWF       _xs_seed+12 
	MOVF        R1, 0 
	MOVWF       _xs_seed+13 
	MOVF        R2, 0 
	MOVWF       _xs_seed+14 
	MOVF        R3, 0 
	MOVWF       _xs_seed+15 
	MOVF        _xs_seed+12, 0 
	MOVWF       R0 
	MOVF        _xs_seed+13, 0 
	MOVWF       R1 
	MOVF        _xs_seed+14, 0 
	MOVWF       R2 
	MOVF        _xs_seed+15, 0 
	MOVWF       R3 
L_end_XorShift128:
	RETURN      0
; end of _XorShift128

_P2_Read_Random:

	MOVLW       128
	ANDWF       _P2_sreg+0, 0 
	MOVWF       R1 
	MOVLW       7
	MOVWF       R0 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVF        R0, 0 
L__P2_Read_Random50:
	BZ          L__P2_Read_Random51
	RRCF        R3, 1 
	BCF         R3, 7 
	ADDLW       255
	GOTO        L__P2_Read_Random50
L__P2_Read_Random51:
	MOVLW       32
	ANDWF       _P2_sreg+0, 0 
	MOVWF       R2 
	MOVLW       5
	MOVWF       R1 
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R1, 0 
L__P2_Read_Random52:
	BZ          L__P2_Read_Random53
	RRCF        R0, 1 
	BCF         R0, 7 
	ADDLW       255
	GOTO        L__P2_Read_Random52
L__P2_Read_Random53:
	MOVF        R0, 0 
	XORWF       R3, 0 
	MOVWF       R4 
	MOVLW       16
	ANDWF       _P2_sreg+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	BCF         R3, 7 
	MOVLW       8
	ANDWF       _P2_sreg+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        R3, 0 
	XORWF       R0, 1 
	MOVF        R4, 0 
	XORWF       R0, 1 
	MOVLW       1
	XORWF       R0, 0 
	MOVWF       R2 
	MOVF        _P2_sreg+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	IORWF       R2, 0 
	MOVWF       _P2_sreg+0 
	MOVF        _P2_sreg+0, 0 
	MOVWF       R0 
L_end_P2_Read_Random:
	RETURN      0
; end of _P2_Read_Random

_shift_lfsr:

	MOVFF       FARG_shift_lfsr_lfsr+0, FSR0L+0
	MOVFF       FARG_shift_lfsr_lfsr+1, FSR0H+0
	MOVLW       1
	ANDWF       POSTINC0+0, 0 
	MOVWF       shift_lfsr_feedback_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       shift_lfsr_feedback_L0+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       shift_lfsr_feedback_L0+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       shift_lfsr_feedback_L0+3 
	MOVLW       0
	ANDWF       shift_lfsr_feedback_L0+1, 1 
	ANDWF       shift_lfsr_feedback_L0+2, 1 
	ANDWF       shift_lfsr_feedback_L0+3, 1 
	MOVFF       FARG_shift_lfsr_lfsr+0, FSR0L+0
	MOVFF       FARG_shift_lfsr_lfsr+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        POSTINC0+0, 0 
	MOVWF       R7 
	MOVF        POSTINC0+0, 0 
	MOVWF       R8 
	MOVF        R5, 0 
	MOVWF       R0 
	MOVF        R6, 0 
	MOVWF       R1 
	MOVF        R7, 0 
	MOVWF       R2 
	MOVF        R8, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R3, 7 
	MOVFF       FARG_shift_lfsr_lfsr+0, FSR1L+0
	MOVFF       FARG_shift_lfsr_lfsr+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       R0 
	XORWF       shift_lfsr_feedback_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__shift_lfsr55
	MOVF        R0, 0 
	XORWF       shift_lfsr_feedback_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__shift_lfsr55
	MOVF        R0, 0 
	XORWF       shift_lfsr_feedback_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__shift_lfsr55
	MOVF        shift_lfsr_feedback_L0+0, 0 
	XORLW       1
L__shift_lfsr55:
	BTFSS       STATUS+0, 2 
	GOTO        L_shift_lfsr3
	MOVFF       FARG_shift_lfsr_lfsr+0, FSR0L+0
	MOVFF       FARG_shift_lfsr_lfsr+1, FSR0H+0
	MOVFF       FARG_shift_lfsr_lfsr+0, FSR1L+0
	MOVFF       FARG_shift_lfsr_lfsr+1, FSR1H+0
	MOVF        FARG_shift_lfsr_polynomial_mask+0, 0 
	XORWF       POSTINC1+0, 1 
	MOVF        FARG_shift_lfsr_polynomial_mask+1, 0 
	XORWF       POSTINC1+0, 1 
	MOVF        FARG_shift_lfsr_polynomial_mask+2, 0 
	XORWF       POSTINC1+0, 1 
	MOVF        FARG_shift_lfsr_polynomial_mask+3, 0 
	XORWF       POSTINC1+0, 1 
L_shift_lfsr3:
	MOVFF       FARG_shift_lfsr_lfsr+0, FSR0L+0
	MOVFF       FARG_shift_lfsr_lfsr+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
L_end_shift_lfsr:
	RETURN      0
; end of _shift_lfsr

_init_lfsrs:

	MOVLW       222
	MOVWF       _lfsr32+0 
	MOVLW       188
	MOVWF       _lfsr32+1 
	MOVLW       10
	MOVWF       _lfsr32+2 
	MOVLW       0
	MOVWF       _lfsr32+3 
	MOVLW       137
	MOVWF       _lfsr31+0 
	MOVLW       103
	MOVWF       _lfsr31+1 
	MOVLW       69
	MOVWF       _lfsr31+2 
	MOVLW       35
	MOVWF       _lfsr31+3 
L_end_init_lfsrs:
	RETURN      0
; end of _init_lfsrs

_get_random:

	MOVLW       _lfsr32+0
	MOVWF       FARG_shift_lfsr_lfsr+0 
	MOVLW       hi_addr(_lfsr32+0)
	MOVWF       FARG_shift_lfsr_lfsr+1 
	MOVLW       92
	MOVWF       FARG_shift_lfsr_polynomial_mask+0 
	MOVLW       211
	MOVWF       FARG_shift_lfsr_polynomial_mask+1 
	MOVLW       188
	MOVWF       FARG_shift_lfsr_polynomial_mask+2 
	MOVLW       180
	MOVWF       FARG_shift_lfsr_polynomial_mask+3 
	CALL        _shift_lfsr+0, 0
	MOVLW       _lfsr32+0
	MOVWF       FARG_shift_lfsr_lfsr+0 
	MOVLW       hi_addr(_lfsr32+0)
	MOVWF       FARG_shift_lfsr_lfsr+1 
	MOVLW       92
	MOVWF       FARG_shift_lfsr_polynomial_mask+0 
	MOVLW       211
	MOVWF       FARG_shift_lfsr_polynomial_mask+1 
	MOVLW       188
	MOVWF       FARG_shift_lfsr_polynomial_mask+2 
	MOVLW       180
	MOVWF       FARG_shift_lfsr_polynomial_mask+3 
	CALL        _shift_lfsr+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__get_random+0 
	MOVF        R1, 0 
	MOVWF       FLOC__get_random+1 
	MOVF        R2, 0 
	MOVWF       FLOC__get_random+2 
	MOVF        R3, 0 
	MOVWF       FLOC__get_random+3 
	MOVLW       _lfsr31+0
	MOVWF       FARG_shift_lfsr_lfsr+0 
	MOVLW       hi_addr(_lfsr31+0)
	MOVWF       FARG_shift_lfsr_lfsr+1 
	MOVLW       227
	MOVWF       FARG_shift_lfsr_polynomial_mask+0 
	MOVLW       194
	MOVWF       FARG_shift_lfsr_polynomial_mask+1 
	MOVLW       91
	MOVWF       FARG_shift_lfsr_polynomial_mask+2 
	MOVLW       122
	MOVWF       FARG_shift_lfsr_polynomial_mask+3 
	CALL        _shift_lfsr+0, 0
	MOVF        FLOC__get_random+0, 0 
	XORWF       R0, 1 
	MOVF        FLOC__get_random+1, 0 
	XORWF       R1, 1 
	MOVF        FLOC__get_random+2, 0 
	XORWF       R2, 1 
	MOVF        FLOC__get_random+3, 0 
	XORWF       R3, 1 
	MOVLW       255
	ANDWF       R0, 1 
	MOVLW       255
	ANDWF       R1, 1 
	MOVLW       0
	ANDWF       R2, 1 
	ANDWF       R3, 1 
L_end_get_random:
	RETURN      0
; end of _get_random

_decode_flag_1:

	MOVLW       55
	MOVWF       FARG_srand_x+0 
	MOVLW       19
	MOVWF       FARG_srand_x+1 
	CALL        _srand+0, 0
	CALL        _rand+0, 0
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+0 
	MOVF        R1, 0 
	MOVWF       _xs_seed+1 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+2 
	MOVWF       _xs_seed+3 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+4 
	MOVF        R1, 0 
	MOVWF       _xs_seed+5 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+6 
	MOVWF       _xs_seed+7 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+8 
	MOVF        R1, 0 
	MOVWF       _xs_seed+9 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+10 
	MOVWF       _xs_seed+11 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+12 
	MOVF        R1, 0 
	MOVWF       _xs_seed+13 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+14 
	MOVWF       _xs_seed+15 
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_14:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_159
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_159:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_15
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_1_r_L1+0 
	MOVF        R1, 0 
	MOVWF       decode_flag_1_r_L1+1 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_14
L_decode_flag_15:
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_17:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_160
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_160:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_18
	CALL        _XorShift128+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_1_r_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       decode_flag_1_r_L1_L1+1 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_17
L_decode_flag_18:
	CALL        _XorShift128+0, 0
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       _P2_sreg+0 
	CALL        _P2_Read_Random+0, 0
	CALL        _P2_Read_Random+0, 0
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_110:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_161
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_161:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_111
	CALL        _P2_Read_Random+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_1_r_L1_L1_L1+0 
	MOVLW       0
	MOVWF       decode_flag_1_r_L1_L1_L1+1 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_110
L_decode_flag_111:
	CALL        _init_lfsrs+0, 0
	CALL        _XorShift128+0, 0
	MOVF        R0, 0 
	XORWF       _lfsr32+0, 1 
	MOVF        R1, 0 
	XORWF       _lfsr32+1, 1 
	MOVF        R2, 0 
	XORWF       _lfsr32+2, 1 
	MOVF        R3, 0 
	XORWF       _lfsr32+3, 1 
	CALL        _XorShift128+0, 0
	MOVF        R0, 0 
	XORWF       _lfsr31+0, 1 
	MOVF        R1, 0 
	XORWF       _lfsr31+1, 1 
	MOVF        R2, 0 
	XORWF       _lfsr31+2, 1 
	MOVF        R3, 0 
	XORWF       _lfsr31+3, 1 
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_113:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_162
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_162:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_114
	CALL        _get_random+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_1_r_L1_L1_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       decode_flag_1_r_L1_L1_L1_L1+1 
	MOVLW       _enc_flag+0
	ADDWF       _i+0, 0 
	MOVWF       R1 
	MOVLW       hi_addr(_enc_flag+0)
	ADDWFC      _i+1, 0 
	MOVWF       R2 
	MOVLW       255
	ANDWF       decode_flag_1_r_L1_L1_L1_L1+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR0L+0
	MOVFF       R2, FSR0H+0
	MOVF        POSTINC0+0, 0 
	XORWF       R0, 1 
	MOVFF       R1, FSR1L+0
	MOVFF       R2, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_113
L_decode_flag_114:
L_end_decode_flag_1:
	RETURN      0
; end of _decode_flag_1

_decode_flag_2:

	MOVLW       55
	MOVWF       FARG_srand_x+0 
	MOVLW       19
	MOVWF       FARG_srand_x+1 
	CALL        _srand+0, 0
	CALL        _rand+0, 0
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+0 
	MOVF        R1, 0 
	MOVWF       _xs_seed+1 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+2 
	MOVWF       _xs_seed+3 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+4 
	MOVF        R1, 0 
	MOVWF       _xs_seed+5 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+6 
	MOVWF       _xs_seed+7 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+8 
	MOVF        R1, 0 
	MOVWF       _xs_seed+9 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+10 
	MOVWF       _xs_seed+11 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+12 
	MOVF        R1, 0 
	MOVWF       _xs_seed+13 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+14 
	MOVWF       _xs_seed+15 
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_216:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_264
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_264:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_217
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_2_r_L1+0 
	MOVF        R1, 0 
	MOVWF       decode_flag_2_r_L1+1 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_216
L_decode_flag_217:
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_219:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_265
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_265:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_220
	CALL        _XorShift128+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_2_r_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       decode_flag_2_r_L1_L1+1 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_219
L_decode_flag_220:
	CALL        _XorShift128+0, 0
	MOVLW       255
	ANDWF       R0, 0 
	MOVWF       _P2_sreg+0 
	CALL        _P2_Read_Random+0, 0
	CALL        _P2_Read_Random+0, 0
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_222:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_266
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_266:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_223
	CALL        _P2_Read_Random+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_2_r_L1_L1_L1+0 
	MOVLW       0
	MOVWF       decode_flag_2_r_L1_L1_L1+1 
	MOVLW       _enc_flag+0
	ADDWF       _i+0, 0 
	MOVWF       R1 
	MOVLW       hi_addr(_enc_flag+0)
	ADDWFC      _i+1, 0 
	MOVWF       R2 
	MOVLW       255
	ANDWF       decode_flag_2_r_L1_L1_L1+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR0L+0
	MOVFF       R2, FSR0H+0
	MOVF        POSTINC0+0, 0 
	XORWF       R0, 1 
	MOVFF       R1, FSR1L+0
	MOVFF       R2, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_222
L_decode_flag_223:
L_end_decode_flag_2:
	RETURN      0
; end of _decode_flag_2

_decode_flag_3:

	MOVLW       55
	MOVWF       FARG_srand_x+0 
	MOVLW       19
	MOVWF       FARG_srand_x+1 
	CALL        _srand+0, 0
	CALL        _rand+0, 0
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+0 
	MOVF        R1, 0 
	MOVWF       _xs_seed+1 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+2 
	MOVWF       _xs_seed+3 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+4 
	MOVF        R1, 0 
	MOVWF       _xs_seed+5 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+6 
	MOVWF       _xs_seed+7 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+8 
	MOVF        R1, 0 
	MOVWF       _xs_seed+9 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+10 
	MOVWF       _xs_seed+11 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+12 
	MOVF        R1, 0 
	MOVWF       _xs_seed+13 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+14 
	MOVWF       _xs_seed+15 
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_325:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_368
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_368:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_326
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_3_r_L1+0 
	MOVF        R1, 0 
	MOVWF       decode_flag_3_r_L1+1 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_325
L_decode_flag_326:
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_328:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_369
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_369:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_329
	CALL        _XorShift128+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_3_r_L1_L1+0 
	MOVF        R1, 0 
	MOVWF       decode_flag_3_r_L1_L1+1 
	MOVLW       _enc_flag+0
	ADDWF       _i+0, 0 
	MOVWF       R1 
	MOVLW       hi_addr(_enc_flag+0)
	ADDWFC      _i+1, 0 
	MOVWF       R2 
	MOVLW       255
	ANDWF       decode_flag_3_r_L1_L1+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR0L+0
	MOVFF       R2, FSR0H+0
	MOVF        POSTINC0+0, 0 
	XORWF       R0, 1 
	MOVFF       R1, FSR1L+0
	MOVFF       R2, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_328
L_decode_flag_329:
L_end_decode_flag_3:
	RETURN      0
; end of _decode_flag_3

_decode_flag_4:

	MOVLW       55
	MOVWF       FARG_srand_x+0 
	MOVLW       19
	MOVWF       FARG_srand_x+1 
	CALL        _srand+0, 0
	CALL        _rand+0, 0
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+0 
	MOVF        R1, 0 
	MOVWF       _xs_seed+1 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+2 
	MOVWF       _xs_seed+3 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+4 
	MOVF        R1, 0 
	MOVWF       _xs_seed+5 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+6 
	MOVWF       _xs_seed+7 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+8 
	MOVF        R1, 0 
	MOVWF       _xs_seed+9 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+10 
	MOVWF       _xs_seed+11 
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       _xs_seed+12 
	MOVF        R1, 0 
	MOVWF       _xs_seed+13 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       _xs_seed+14 
	MOVWF       _xs_seed+15 
	CLRF        _i+0 
	CLRF        _i+1 
L_decode_flag_431:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__decode_flag_471
	MOVLW       20
	SUBWF       _i+0, 0 
L__decode_flag_471:
	BTFSC       STATUS+0, 0 
	GOTO        L_decode_flag_432
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       decode_flag_4_r_L1+0 
	MOVF        R1, 0 
	MOVWF       decode_flag_4_r_L1+1 
	MOVLW       _enc_flag+0
	ADDWF       _i+0, 0 
	MOVWF       R3 
	MOVLW       hi_addr(_enc_flag+0)
	ADDWFC      _i+1, 0 
	MOVWF       R4 
	MOVF        decode_flag_4_r_L1+1, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       decode_flag_4_r_L1+1, 7 
	MOVLW       255
	MOVWF       R1 
	MOVFF       R3, FSR0L+0
	MOVFF       R4, FSR0H+0
	MOVF        POSTINC0+0, 0 
	XORWF       R0, 0 
	MOVWF       R0 
	MOVFF       R3, FSR1L+0
	MOVFF       R4, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_decode_flag_431
L_decode_flag_432:
L_end_decode_flag_4:
	RETURN      0
; end of _decode_flag_4

_decodeFlag:

	CALL        _decode_flag_1+0, 0
	CALL        _decode_flag_2+0, 0
	CALL        _decode_flag_3+0, 0
	CALL        _decode_flag_4+0, 0
L_end_decodeFlag:
	RETURN      0
; end of _decodeFlag

_main:

	MOVLW       55
	MOVWF       FARG_srand_x+0 
	MOVLW       19
	MOVWF       FARG_srand_x+1 
	CALL        _srand+0, 0
	CALL        _rand+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _randchar+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_randchar+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
	CALL        _Lcd_Init+0, 0
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       65
	MOVWF       ?lstr1_MyProject+0 
	MOVLW       101
	MOVWF       ?lstr1_MyProject+1 
	MOVLW       114
	MOVWF       ?lstr1_MyProject+2 
	MOVLW       111
	MOVWF       ?lstr1_MyProject+3 
	CLRF        ?lstr1_MyProject+4 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?ICS?lstr2_MyProject+0
	MOVWF       TBLPTRL+0 
	MOVLW       hi_addr(?ICS?lstr2_MyProject+0)
	MOVWF       TBLPTRL+1 
	MOVLW       higher_addr(?ICS?lstr2_MyProject+0)
	MOVWF       TBLPTRL+2 
	MOVLW       ?lstr2_MyProject+0
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(?lstr2_MyProject+0)
	MOVWF       FSR1L+1 
	MOVLW       17
	MOVWF       R0 
	MOVLW       1
	MOVWF       R1 
	CALL        ___CC2DW+0, 0
	MOVLW       ?lstr2_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _randchar+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_randchar+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
	BSF         RC2_bit+0, BitPos(RC2_bit+0) 
	BSF         TRISB3_bit+0, BitPos(TRISB3_bit+0) 
	CALL        _ADC_Init+0, 0
L_main34:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main74
	MOVLW       50
	SUBWF       _i+0, 0 
L__main74:
	BTFSC       STATUS+0, 0 
	GOTO        L_main35
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_res+0 
	MOVF        R1, 0 
	MOVWF       _temp_res+1 
	MOVLW       2
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_res+0, 0 
	MOVWF       R0 
	MOVF        _temp_res+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _s_temp_res+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_s_temp_res+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _s_temp_res+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_s_temp_res+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main37:
	DECFSZ      R13, 1, 1
	BRA         L_main37
	DECFSZ      R12, 1, 1
	BRA         L_main37
	NOP
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_main34
L_main35:
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
	BSF         RC5_bit+0, BitPos(RC5_bit+0) 
L_main38:
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_res+0 
	MOVF        R1, 0 
	MOVWF       _temp_res+1 
	MOVLW       2
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_res+0, 0 
	MOVWF       R0 
	MOVF        _temp_res+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _s_temp_res+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_s_temp_res+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _s_temp_res+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_s_temp_res+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main40:
	DECFSZ      R13, 1, 1
	BRA         L_main40
	DECFSZ      R12, 1, 1
	BRA         L_main40
	NOP
	BTFSC       RB3_bit+0, BitPos(RB3_bit+0) 
	GOTO        L_main41
	CALL        _decodeFlag+0, 0
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main42:
	DECFSZ      R13, 1, 1
	BRA         L_main42
	DECFSZ      R12, 1, 1
	BRA         L_main42
	DECFSZ      R11, 1, 1
	BRA         L_main42
	NOP
	NOP
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       253
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _enc_flag+4
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_enc_flag+4)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_main41:
	GOTO        L_main38
L_end_main:
	GOTO        $+0
; end of _main
