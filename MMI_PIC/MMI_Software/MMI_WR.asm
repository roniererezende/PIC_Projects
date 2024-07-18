
_slcd_write:

;MMI_WR.c,36 :: 		void slcd_write(unsigned char chr)
;MMI_WR.c,38 :: 		send_nibble(chr, 1, sbli, sled);
	MOVF       FARG_slcd_write_chr+0, 0
	MOVWF      FARG_send_nibble_nib+0
	MOVLW      1
	MOVWF      FARG_send_nibble_rsel+0
	MOVF       _sbli+0, 0
	MOVWF      FARG_send_nibble_bli+0
	MOVF       _sled+0, 0
	MOVWF      FARG_send_nibble_led+0
	CALL       _send_nibble+0
;MMI_WR.c,39 :: 		chr <<= 4;
	MOVF       FARG_slcd_write_chr+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      FARG_slcd_write_chr+0
;MMI_WR.c,40 :: 		send_nibble(chr, 1, sbli, sled);
	MOVF       R0+0, 0
	MOVWF      FARG_send_nibble_nib+0
	MOVLW      1
	MOVWF      FARG_send_nibble_rsel+0
	MOVF       _sbli+0, 0
	MOVWF      FARG_send_nibble_bli+0
	MOVF       _sled+0, 0
	MOVWF      FARG_send_nibble_led+0
	CALL       _send_nibble+0
;MMI_WR.c,41 :: 		}// slcd_write
L_end_slcd_write:
	RETURN
; end of _slcd_write

_slcd_write_string:

;MMI_WR.c,46 :: 		void slcd_write_string(unsigned char str[], char row, char col)
;MMI_WR.c,48 :: 		char index = 0;
	CLRF       slcd_write_string_index_L0+0
;MMI_WR.c,50 :: 		if(!row)                   // line 0
	MOVF       FARG_slcd_write_string_row+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_write_string0
;MMI_WR.c,52 :: 		slcd_cmd(0x80 | col);  // sends commant to positione in correct column
	MOVLW      128
	IORWF      FARG_slcd_write_string_col+0, 0
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,53 :: 		}
	GOTO       L_slcd_write_string1
L_slcd_write_string0:
;MMI_WR.c,56 :: 		slcd_cmd(0xC0 | col);   // sends commant to positione in correct column
	MOVLW      192
	IORWF      FARG_slcd_write_string_col+0, 0
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,57 :: 		}
L_slcd_write_string1:
;MMI_WR.c,58 :: 		while(str[index] != '\0')
L_slcd_write_string2:
	MOVF       slcd_write_string_index_L0+0, 0
	ADDWF      FARG_slcd_write_string_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_slcd_write_string3
;MMI_WR.c,60 :: 		slcd_write(str[index]);
	MOVF       slcd_write_string_index_L0+0, 0
	ADDWF      FARG_slcd_write_string_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_WR.c,61 :: 		index++;
	INCF       slcd_write_string_index_L0+0, 1
;MMI_WR.c,62 :: 		}
	GOTO       L_slcd_write_string2
L_slcd_write_string3:
;MMI_WR.c,63 :: 		} // slcd_write_string
L_end_slcd_write_string:
	RETURN
; end of _slcd_write_string

_slcd_wr_po:

;MMI_WR.c,68 :: 		void slcd_wr_po(unsigned char chr, char row, char col)
;MMI_WR.c,70 :: 		if(!row)                   // line 0
	MOVF       FARG_slcd_wr_po_row+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_wr_po4
;MMI_WR.c,72 :: 		slcd_cmd(0x80 | col);  // sends commant to positione in correct column
	MOVLW      128
	IORWF      FARG_slcd_wr_po_col+0, 0
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,73 :: 		slcd_write(chr);
	MOVF       FARG_slcd_wr_po_chr+0, 0
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_WR.c,74 :: 		}   // end if
	GOTO       L_slcd_wr_po5
L_slcd_wr_po4:
;MMI_WR.c,77 :: 		slcd_cmd(0xC0 | col);   // sends commant to positione in correct column
	MOVLW      192
	IORWF      FARG_slcd_wr_po_col+0, 0
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,78 :: 		slcd_write(chr);
	MOVF       FARG_slcd_wr_po_chr+0, 0
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_WR.c,79 :: 		}   // end else
L_slcd_wr_po5:
;MMI_WR.c,80 :: 		}// end slcd_wr_po
L_end_slcd_wr_po:
	RETURN
; end of _slcd_wr_po

_slcd_cmd:

;MMI_WR.c,87 :: 		void slcd_cmd(unsigned char cmd)
;MMI_WR.c,89 :: 		send_nibble(cmd, 0, sbli, sled);
	MOVF       FARG_slcd_cmd_cmd+0, 0
	MOVWF      FARG_send_nibble_nib+0
	CLRF       FARG_send_nibble_rsel+0
	MOVF       _sbli+0, 0
	MOVWF      FARG_send_nibble_bli+0
	MOVF       _sled+0, 0
	MOVWF      FARG_send_nibble_led+0
	CALL       _send_nibble+0
;MMI_WR.c,90 :: 		cmd <<= 4;
	MOVF       FARG_slcd_cmd_cmd+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      FARG_slcd_cmd_cmd+0
;MMI_WR.c,91 :: 		send_nibble(cmd, 0, sbli, sled);
	MOVF       R0+0, 0
	MOVWF      FARG_send_nibble_nib+0
	CLRF       FARG_send_nibble_rsel+0
	MOVF       _sbli+0, 0
	MOVWF      FARG_send_nibble_bli+0
	MOVF       _sled+0, 0
	MOVWF      FARG_send_nibble_led+0
	CALL       _send_nibble+0
;MMI_WR.c,92 :: 		}// end slcd_cmd
L_end_slcd_cmd:
	RETURN
; end of _slcd_cmd

_slcd_number:

;MMI_WR.c,97 :: 		void slcd_number(unsigned long num, char row, char col)
;MMI_WR.c,100 :: 		short no_zero = 0;               // Variables for cleaning of zeros to the left
	CLRF       slcd_number_no_zero_L0+0
;MMI_WR.c,102 :: 		dem = (char)(num / 10000);
	MOVLW      16
	MOVWF      R4+0
	MOVLW      39
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_slcd_number_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_slcd_number_num+1, 0
	MOVWF      R0+1
	MOVF       FARG_slcd_number_num+2, 0
	MOVWF      R0+2
	MOVF       FARG_slcd_number_num+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__slcd_number+0
	MOVF       R0+1, 0
	MOVWF      FLOC__slcd_number+1
	MOVF       R0+2, 0
	MOVWF      FLOC__slcd_number+2
	MOVF       R0+3, 0
	MOVWF      FLOC__slcd_number+3
	MOVF       FLOC__slcd_number+0, 0
	MOVWF      slcd_number_dem_L0+0
;MMI_WR.c,103 :: 		mil = (char)(num % 10000 / 1000);
	MOVLW      16
	MOVWF      R4+0
	MOVLW      39
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_slcd_number_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_slcd_number_num+1, 0
	MOVWF      R0+1
	MOVF       FARG_slcd_number_num+2, 0
	MOVWF      R0+2
	MOVF       FARG_slcd_number_num+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      slcd_number_mil_L0+0
;MMI_WR.c,104 :: 		cen = (char)(num % 1000 / 100);
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_slcd_number_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_slcd_number_num+1, 0
	MOVWF      R0+1
	MOVF       FARG_slcd_number_num+2, 0
	MOVWF      R0+2
	MOVF       FARG_slcd_number_num+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      slcd_number_cen_L0+0
;MMI_WR.c,105 :: 		dez = (char)(num % 100 / 10);
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_slcd_number_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_slcd_number_num+1, 0
	MOVWF      R0+1
	MOVF       FARG_slcd_number_num+2, 0
	MOVWF      R0+2
	MOVF       FARG_slcd_number_num+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      slcd_number_dez_L0+0
;MMI_WR.c,106 :: 		uni = (char)(num % 10);
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_slcd_number_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_slcd_number_num+1, 0
	MOVWF      R0+1
	MOVF       FARG_slcd_number_num+2, 0
	MOVWF      R0+2
	MOVF       FARG_slcd_number_num+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      slcd_number_uni_L0+0
;MMI_WR.c,108 :: 		if(!dem && !no_zero)
	MOVF       FLOC__slcd_number+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_number8
	MOVF       slcd_number_no_zero_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_number8
L__slcd_number71:
;MMI_WR.c,109 :: 		slcd_wr_po(' ', row, col);
	MOVLW      32
	MOVWF      FARG_slcd_wr_po_chr+0
	MOVF       FARG_slcd_number_row+0, 0
	MOVWF      FARG_slcd_wr_po_row+0
	MOVF       FARG_slcd_number_col+0, 0
	MOVWF      FARG_slcd_wr_po_col+0
	CALL       _slcd_wr_po+0
	GOTO       L_slcd_number9
L_slcd_number8:
;MMI_WR.c,112 :: 		slcd_wr_po(dem + 0x30, row, col);
	MOVLW      48
	ADDWF      slcd_number_dem_L0+0, 0
	MOVWF      FARG_slcd_wr_po_chr+0
	MOVF       FARG_slcd_number_row+0, 0
	MOVWF      FARG_slcd_wr_po_row+0
	MOVF       FARG_slcd_number_col+0, 0
	MOVWF      FARG_slcd_wr_po_col+0
	CALL       _slcd_wr_po+0
;MMI_WR.c,113 :: 		no_zero = 1;
	MOVLW      1
	MOVWF      slcd_number_no_zero_L0+0
;MMI_WR.c,114 :: 		}
L_slcd_number9:
;MMI_WR.c,116 :: 		if(!mil && !no_zero)
	MOVF       slcd_number_mil_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_number12
	MOVF       slcd_number_no_zero_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_number12
L__slcd_number70:
;MMI_WR.c,117 :: 		slcd_write(' ');
	MOVLW      32
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
	GOTO       L_slcd_number13
L_slcd_number12:
;MMI_WR.c,120 :: 		slcd_write(mil + 0x30);
	MOVLW      48
	ADDWF      slcd_number_mil_L0+0, 0
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_WR.c,121 :: 		no_zero = 1;
	MOVLW      1
	MOVWF      slcd_number_no_zero_L0+0
;MMI_WR.c,122 :: 		}
L_slcd_number13:
;MMI_WR.c,124 :: 		if(!cen && !no_zero)
	MOVF       slcd_number_cen_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_number16
	MOVF       slcd_number_no_zero_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_number16
L__slcd_number69:
;MMI_WR.c,125 :: 		slcd_write(' ');
	MOVLW      32
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
	GOTO       L_slcd_number17
L_slcd_number16:
;MMI_WR.c,128 :: 		slcd_write(cen + 0x30);
	MOVLW      48
	ADDWF      slcd_number_cen_L0+0, 0
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_WR.c,129 :: 		no_zero = 1;
	MOVLW      1
	MOVWF      slcd_number_no_zero_L0+0
;MMI_WR.c,130 :: 		}
L_slcd_number17:
;MMI_WR.c,132 :: 		if(!dez && !no_zero)
	MOVF       slcd_number_dez_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_number20
	MOVF       slcd_number_no_zero_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_slcd_number20
L__slcd_number68:
;MMI_WR.c,133 :: 		slcd_write(' ');
	MOVLW      32
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
	GOTO       L_slcd_number21
L_slcd_number20:
;MMI_WR.c,136 :: 		slcd_write(dez + 0x30);
	MOVLW      48
	ADDWF      slcd_number_dez_L0+0, 0
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_WR.c,137 :: 		no_zero = 1;
	MOVLW      1
	MOVWF      slcd_number_no_zero_L0+0
;MMI_WR.c,138 :: 		}
L_slcd_number21:
;MMI_WR.c,139 :: 		slcd_write(uni + 0x30);
	MOVLW      48
	ADDWF      slcd_number_uni_L0+0, 0
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_WR.c,140 :: 		}// end slcd_number
L_end_slcd_number:
	RETURN
; end of _slcd_number

_slcd_init:

;MMI_WR.c,144 :: 		void slcd_init(void)
;MMI_WR.c,146 :: 		__ms(48);                // Stabilization time recommended (datasheet)
	MOVLW      63
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_slcd_init22:
	DECFSZ     R13+0, 1
	GOTO       L_slcd_init22
	DECFSZ     R12+0, 1
	GOTO       L_slcd_init22
;MMI_WR.c,147 :: 		send_nibble(0x30,0,0,0); // Initialization protocol
	MOVLW      48
	MOVWF      FARG_send_nibble_nib+0
	CLRF       FARG_send_nibble_rsel+0
	CLRF       FARG_send_nibble_bli+0
	CLRF       FARG_send_nibble_led+0
	CALL       _send_nibble+0
;MMI_WR.c,148 :: 		__ms(5);                                 // Time above of suggested (datasheet)
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_slcd_init23:
	DECFSZ     R13+0, 1
	GOTO       L_slcd_init23
	DECFSZ     R12+0, 1
	GOTO       L_slcd_init23
;MMI_WR.c,149 :: 		send_nibble(0x30,0,0,0); // Initialization protocol
	MOVLW      48
	MOVWF      FARG_send_nibble_nib+0
	CLRF       FARG_send_nibble_rsel+0
	CLRF       FARG_send_nibble_bli+0
	CLRF       FARG_send_nibble_led+0
	CALL       _send_nibble+0
;MMI_WR.c,150 :: 		__us(150);               // Time above of suggested (datasheet)
	MOVLW      49
	MOVWF      R13+0
L_slcd_init24:
	DECFSZ     R13+0, 1
	GOTO       L_slcd_init24
	NOP
	NOP
;MMI_WR.c,151 :: 		send_nibble(0x30,0,0,0); // Initialization protocol
	MOVLW      48
	MOVWF      FARG_send_nibble_nib+0
	CLRF       FARG_send_nibble_rsel+0
	CLRF       FARG_send_nibble_bli+0
	CLRF       FARG_send_nibble_led+0
	CALL       _send_nibble+0
;MMI_WR.c,152 :: 		send_nibble(0x20,0,0,0); // 4 bits mode LCD
	MOVLW      32
	MOVWF      FARG_send_nibble_nib+0
	CLRF       FARG_send_nibble_rsel+0
	CLRF       FARG_send_nibble_bli+0
	CLRF       FARG_send_nibble_led+0
	CALL       _send_nibble+0
;MMI_WR.c,154 :: 		slcd_cmd(0x28);          // 5x8 dots by character, two lines
	MOVLW      40
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,155 :: 		slcd_opt(1, 0, 0);       // Turn on LCD, turn off cursor, turn off blink)
	MOVLW      1
	MOVWF      FARG_slcd_opt_disp+0
	CLRF       FARG_slcd_opt_cursor+0
	CLRF       FARG_slcd_opt_blink+0
	CALL       _slcd_opt+0
;MMI_WR.c,156 :: 		slcd_cmd(0x01);          // Clears LCD
	MOVLW      1
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,157 :: 		slcd_cmd(0x06);          // Address increment mode for right
	MOVLW      6
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,158 :: 		slcd_clear();
	CALL       _slcd_clear+0
;MMI_WR.c,159 :: 		}// slcd_init
L_end_slcd_init:
	RETURN
; end of _slcd_init

_slcd_clear:

;MMI_WR.c,164 :: 		void slcd_clear(void)
;MMI_WR.c,166 :: 		slcd_cmd(0x02);                          // Returns to home
	MOVLW      2
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,167 :: 		slcd_cmd(0x01);                          // Clears LCD
	MOVLW      1
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,168 :: 		}// end slcd_clear
L_end_slcd_clear:
	RETURN
; end of _slcd_clear

_shift_reg:

;MMI_WR.c,175 :: 		void shift_reg(unsigned char byte_val)
;MMI_WR.c,179 :: 		for(i = 7; i >= 0; i--)
	MOVLW      7
	MOVWF      R3+0
	MOVLW      0
	MOVWF      R3+1
L_shift_reg25:
	MOVLW      128
	XORWF      R3+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__shift_reg84
	MOVLW      0
	SUBWF      R3+0, 0
L__shift_reg84:
	BTFSS      STATUS+0, 0
	GOTO       L_shift_reg26
;MMI_WR.c,181 :: 		(byte_val >> i) & 0x01 ?
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       FARG_shift_reg_byte_val+0, 0
	MOVWF      R1+0
	MOVF       R0+0, 0
L__shift_reg85:
	BTFSC      STATUS+0, 2
	GOTO       L__shift_reg86
	RRF        R1+0, 1
	BCF        R1+0, 7
	ADDLW      255
	GOTO       L__shift_reg85
L__shift_reg86:
	BTFSS      R1+0, 0
	GOTO       L_shift_reg28
;MMI_WR.c,182 :: 		(PORTMCU |=  DAT):
	BSF        PORTB+0, 1
	MOVF       PORTB+0, 0
	MOVWF      R2+0
	GOTO       L_shift_reg29
L_shift_reg28:
;MMI_WR.c,183 :: 		(PORTMCU &= ~DAT);
	BCF        PORTB+0, 1
	MOVF       PORTB+0, 0
	MOVWF      R2+0
L_shift_reg29:
;MMI_WR.c,185 :: 		__us(100);
	MOVLW      33
	MOVWF      R13+0
L_shift_reg30:
	DECFSZ     R13+0, 1
	GOTO       L_shift_reg30
;MMI_WR.c,186 :: 		PORTMCU |=  CLK;
	BSF        PORTB+0, 0
;MMI_WR.c,187 :: 		__ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_shift_reg31:
	DECFSZ     R13+0, 1
	GOTO       L_shift_reg31
	DECFSZ     R12+0, 1
	GOTO       L_shift_reg31
;MMI_WR.c,188 :: 		PORTMCU &= ~CLK;
	BCF        PORTB+0, 0
;MMI_WR.c,189 :: 		__us(100);
	MOVLW      33
	MOVWF      R13+0
L_shift_reg32:
	DECFSZ     R13+0, 1
	GOTO       L_shift_reg32
;MMI_WR.c,179 :: 		for(i = 7; i >= 0; i--)
	MOVLW      1
	SUBWF      R3+0, 1
	BTFSS      STATUS+0, 0
	DECF       R3+1, 1
;MMI_WR.c,190 :: 		} // end for
	GOTO       L_shift_reg25
L_shift_reg26:
;MMI_WR.c,192 :: 		PORTMCU &= ~DAT;
	BCF        PORTB+0, 1
;MMI_WR.c,193 :: 		PORTMCU |=  LAT;
	BSF        PORTB+0, 2
;MMI_WR.c,194 :: 		__ms(1);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_shift_reg33:
	DECFSZ     R13+0, 1
	GOTO       L_shift_reg33
	DECFSZ     R12+0, 1
	GOTO       L_shift_reg33
;MMI_WR.c,195 :: 		PORTMCU &= ~LAT;
	BCF        PORTB+0, 2
;MMI_WR.c,196 :: 		}// end shift_reg
L_end_shift_reg:
	RETURN
; end of _shift_reg

_send_nibble:

;MMI_WR.c,205 :: 		void send_nibble(unsigned char nib, char rsel, char bli, char led)
;MMI_WR.c,209 :: 		sbyte = (nib & (1 << 7))|
	MOVLW      128
	ANDWF      FARG_send_nibble_nib+0, 0
	MOVWF      send_nibble_sbyte_L0+0
;MMI_WR.c,210 :: 		(nib & (1 << 6))|
	MOVLW      64
	ANDWF      FARG_send_nibble_nib+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      send_nibble_sbyte_L0+0, 1
;MMI_WR.c,211 :: 		(nib & (1 << 5))|
	MOVLW      32
	ANDWF      FARG_send_nibble_nib+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      send_nibble_sbyte_L0+0, 1
;MMI_WR.c,212 :: 		(nib & (1 << 4));
	MOVLW      16
	ANDWF      FARG_send_nibble_nib+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      send_nibble_sbyte_L0+0, 1
;MMI_WR.c,214 :: 		rsel ? (sbyte |= RS) : (sbyte &= ~RS);
	MOVF       FARG_send_nibble_rsel+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_send_nibble34
	BSF        send_nibble_sbyte_L0+0, 2
	GOTO       L_send_nibble35
L_send_nibble34:
	BCF        send_nibble_sbyte_L0+0, 2
L_send_nibble35:
;MMI_WR.c,215 :: 		bli  ? (sbyte |= BL) : (sbyte &= ~BL);
	MOVF       FARG_send_nibble_bli+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_send_nibble36
	BSF        send_nibble_sbyte_L0+0, 1
	GOTO       L_send_nibble37
L_send_nibble36:
	BCF        send_nibble_sbyte_L0+0, 1
L_send_nibble37:
;MMI_WR.c,216 :: 		led  ? (sbyte |= LD) : (sbyte &= ~LD);
	MOVF       FARG_send_nibble_led+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_send_nibble38
	BSF        send_nibble_sbyte_L0+0, 0
	GOTO       L_send_nibble39
L_send_nibble38:
	BCF        send_nibble_sbyte_L0+0, 0
L_send_nibble39:
;MMI_WR.c,218 :: 		shift_reg(sbyte | EN);
	MOVLW      8
	IORWF      send_nibble_sbyte_L0+0, 0
	MOVWF      FARG_shift_reg_byte_val+0
	CALL       _shift_reg+0
;MMI_WR.c,219 :: 		__us(100);
	MOVLW      33
	MOVWF      R13+0
L_send_nibble40:
	DECFSZ     R13+0, 1
	GOTO       L_send_nibble40
;MMI_WR.c,220 :: 		shift_reg(sbyte &~ EN);
	MOVLW      247
	ANDWF      send_nibble_sbyte_L0+0, 0
	MOVWF      FARG_shift_reg_byte_val+0
	CALL       _shift_reg+0
;MMI_WR.c,221 :: 		__us(100);
	MOVLW      33
	MOVWF      R13+0
L_send_nibble41:
	DECFSZ     R13+0, 1
	GOTO       L_send_nibble41
;MMI_WR.c,222 :: 		} // end send_nibble
L_end_send_nibble:
	RETURN
; end of _send_nibble

_slcd_opt:

;MMI_WR.c,227 :: 		void slcd_opt(char disp, char cursor, char blink)
;MMI_WR.c,231 :: 		disp   ? (opt |= (1 << 2)) : (opt &= ~(1 << 2));
	MOVF       FARG_slcd_opt_disp+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_slcd_opt42
	BSF        slcd_opt_opt_L0+0, 2
	GOTO       L_slcd_opt43
L_slcd_opt42:
	BCF        slcd_opt_opt_L0+0, 2
L_slcd_opt43:
;MMI_WR.c,232 :: 		cursor ? (opt |= (1 << 1)) : (opt &= ~(1 << 1));
	MOVF       FARG_slcd_opt_cursor+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_slcd_opt44
	BSF        slcd_opt_opt_L0+0, 1
	GOTO       L_slcd_opt45
L_slcd_opt44:
	BCF        slcd_opt_opt_L0+0, 1
L_slcd_opt45:
;MMI_WR.c,233 :: 		blink  ? (opt |= (1 << 0)) : (opt &= ~(1 << 0));
	MOVF       FARG_slcd_opt_blink+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_slcd_opt46
	BSF        slcd_opt_opt_L0+0, 0
	GOTO       L_slcd_opt47
L_slcd_opt46:
	BCF        slcd_opt_opt_L0+0, 0
L_slcd_opt47:
;MMI_WR.c,235 :: 		slcd_cmd(opt);
	MOVF       slcd_opt_opt_L0+0, 0
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,237 :: 		}// end slcd_opt
L_end_slcd_opt:
	RETURN
; end of _slcd_opt

_sled_on:

;MMI_WR.c,242 :: 		void sled_on(void)
;MMI_WR.c,244 :: 		sled = 1;
	MOVLW      1
	MOVWF      _sled+0
;MMI_WR.c,245 :: 		slcd_cmd(0x06);
	MOVLW      6
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,246 :: 		} // end sled_on
L_end_sled_on:
	RETURN
; end of _sled_on

_sled_off:

;MMI_WR.c,251 :: 		void sled_off(void)
;MMI_WR.c,253 :: 		sled = 0;
	CLRF       _sled+0
;MMI_WR.c,254 :: 		slcd_cmd(0x06);
	MOVLW      6
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,255 :: 		}// end sled_off
L_end_sled_off:
	RETURN
; end of _sled_off

_sbacklight_on:

;MMI_WR.c,260 :: 		void sbacklight_on(void)
;MMI_WR.c,262 :: 		sbli = 1;
	MOVLW      1
	MOVWF      _sbli+0
;MMI_WR.c,263 :: 		slcd_cmd(0x06);
	MOVLW      6
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,264 :: 		}// end sbacklight_on
L_end_sbacklight_on:
	RETURN
; end of _sbacklight_on

_sbacklight_off:

;MMI_WR.c,269 :: 		void sbacklight_off(void)
;MMI_WR.c,271 :: 		sbli = 0;
	CLRF       _sbli+0
;MMI_WR.c,272 :: 		slcd_cmd(0x06);
	MOVLW      6
	MOVWF      FARG_slcd_cmd_cmd+0
	CALL       _slcd_cmd+0
;MMI_WR.c,273 :: 		} // end sbacklight_off
L_end_sbacklight_off:
	RETURN
; end of _sbacklight_off

_keyboard:

;MMI_WR.c,278 :: 		char keyboard(volatile unsigned char *port)
;MMI_WR.c,282 :: 		if(!(*port & BT1))                      // Did button 1 press
	MOVF       FARG_keyboard_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSC      R2+0, 4
	GOTO       L_keyboard48
;MMI_WR.c,283 :: 		flags |= (1 << 1);                  // Yes, set bit 1 flag
	BSF        keyboard_flags_L0+0, 1
L_keyboard48:
;MMI_WR.c,285 :: 		if((*port & BT1) && (flags & (1 << 1))) // button 1 released and flag 1 set
	MOVF       FARG_keyboard_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSS      R2+0, 4
	GOTO       L_keyboard51
	BTFSS      keyboard_flags_L0+0, 1
	GOTO       L_keyboard51
L__keyboard75:
;MMI_WR.c,287 :: 		flags &= ~(1 << 1);                 // cleans flag 1
	BCF        keyboard_flags_L0+0, 1
;MMI_WR.c,288 :: 		__ms(50);                           // anti-bouncing
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_keyboard52:
	DECFSZ     R13+0, 1
	GOTO       L_keyboard52
	DECFSZ     R12+0, 1
	GOTO       L_keyboard52
	NOP
;MMI_WR.c,289 :: 		return 1;                           // return 1, indicating button 1 pressed
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_keyboard
;MMI_WR.c,290 :: 		}
L_keyboard51:
;MMI_WR.c,294 :: 		if(!(*port & BT2))                      // Did button 2 press
	MOVF       FARG_keyboard_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSC      R2+0, 5
	GOTO       L_keyboard53
;MMI_WR.c,295 :: 		flags |= (1 << 2);                  // Yes, set bit 2 flag
	BSF        keyboard_flags_L0+0, 2
L_keyboard53:
;MMI_WR.c,297 :: 		if((*port & BT1) && (flags & (1 << 2))) // button 2 released and flag 2 set
	MOVF       FARG_keyboard_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSS      R2+0, 4
	GOTO       L_keyboard56
	BTFSS      keyboard_flags_L0+0, 2
	GOTO       L_keyboard56
L__keyboard74:
;MMI_WR.c,299 :: 		flags &= ~(1 << 2);                 // cleans flag 2
	BCF        keyboard_flags_L0+0, 2
;MMI_WR.c,300 :: 		__ms(50);                           // anti-bouncing
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_keyboard57:
	DECFSZ     R13+0, 1
	GOTO       L_keyboard57
	DECFSZ     R12+0, 1
	GOTO       L_keyboard57
	NOP
;MMI_WR.c,301 :: 		return 2;                           // return 2, indicating button 2 pressed
	MOVLW      2
	MOVWF      R0+0
	GOTO       L_end_keyboard
;MMI_WR.c,302 :: 		}
L_keyboard56:
;MMI_WR.c,306 :: 		if(!(*port & BT3))                      // Did button 3 press
	MOVF       FARG_keyboard_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSC      R2+0, 6
	GOTO       L_keyboard58
;MMI_WR.c,307 :: 		flags |= (1 << 3);                  // Yes, set bit 3 flag
	BSF        keyboard_flags_L0+0, 3
L_keyboard58:
;MMI_WR.c,309 :: 		if((*port & BT3) && (flags & (1 << 3))) // button 1 released and flag 3 set
	MOVF       FARG_keyboard_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSS      R2+0, 6
	GOTO       L_keyboard61
	BTFSS      keyboard_flags_L0+0, 3
	GOTO       L_keyboard61
L__keyboard73:
;MMI_WR.c,311 :: 		flags &= ~(1 << 3);                 // cleans flag 3
	BCF        keyboard_flags_L0+0, 3
;MMI_WR.c,312 :: 		__ms(50);                           // anti-bouncing
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_keyboard62:
	DECFSZ     R13+0, 1
	GOTO       L_keyboard62
	DECFSZ     R12+0, 1
	GOTO       L_keyboard62
	NOP
;MMI_WR.c,313 :: 		return 3;                           // return 3, indicating button 3 pressed
	MOVLW      3
	MOVWF      R0+0
	GOTO       L_end_keyboard
;MMI_WR.c,314 :: 		}
L_keyboard61:
;MMI_WR.c,318 :: 		if(!(*port & BT4))                      // Did button 4 press
	MOVF       FARG_keyboard_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSC      R2+0, 7
	GOTO       L_keyboard63
;MMI_WR.c,319 :: 		flags |= (1 << 4);                  // Yes, set bit 4 flag
	BSF        keyboard_flags_L0+0, 4
L_keyboard63:
;MMI_WR.c,321 :: 		if((*port & BT4) && (flags & (1 << 4))) // button 1 released and flag 4 set
	MOVF       FARG_keyboard_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSS      R2+0, 7
	GOTO       L_keyboard66
	BTFSS      keyboard_flags_L0+0, 4
	GOTO       L_keyboard66
L__keyboard72:
;MMI_WR.c,323 :: 		flags &= ~(1 << 4);                 // cleans flag 4
	BCF        keyboard_flags_L0+0, 4
;MMI_WR.c,324 :: 		__ms(50);                           // anti-bouncing
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_keyboard67:
	DECFSZ     R13+0, 1
	GOTO       L_keyboard67
	DECFSZ     R12+0, 1
	GOTO       L_keyboard67
	NOP
;MMI_WR.c,325 :: 		return 4;                           // return 4, indicating button 1 pressed
	MOVLW      4
	MOVWF      R0+0
	GOTO       L_end_keyboard
;MMI_WR.c,326 :: 		}
L_keyboard66:
;MMI_WR.c,328 :: 		return 0;
	CLRF       R0+0
;MMI_WR.c,329 :: 		} // end keyboard
L_end_keyboard:
	RETURN
; end of _keyboard
