
_main:

;MMI_PIC.c,38 :: 		void main(void)
;MMI_PIC.c,40 :: 		char tests = 0;
;MMI_PIC.c,41 :: 		uint16_t counter = 0;
	MOVLW      0
	MOVWF      main_counter_L0+0
	MOVLW      0
	MOVWF      main_counter_L0+1
;MMI_PIC.c,43 :: 		CMCON = 0x07;
	MOVLW      7
	MOVWF      CMCON+0
;MMI_PIC.c,44 :: 		TRISB = 0xF8;
	MOVLW      248
	MOVWF      TRISB+0
;MMI_PIC.c,46 :: 		slcd_init();
	CALL       _slcd_init+0
;MMI_PIC.c,48 :: 		delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	NOP
	NOP
;MMI_PIC.c,49 :: 		slcd_opt(1,0,0);
	MOVLW      1
	MOVWF      FARG_slcd_opt_disp+0
	CLRF       FARG_slcd_opt_cursor+0
	CLRF       FARG_slcd_opt_blink+0
	CALL       _slcd_opt+0
;MMI_PIC.c,51 :: 		sled_on();
	CALL       _sled_on+0
;MMI_PIC.c,52 :: 		sbacklight_on();
	CALL       _sbacklight_on+0
;MMI_PIC.c,54 :: 		sled_off();
	CALL       _sled_off+0
;MMI_PIC.c,55 :: 		sbacklight_off();
	CALL       _sbacklight_off+0
;MMI_PIC.c,57 :: 		slcd_write_string("PIC", 0, 0);
	MOVLW      ?lstr1_MMI_PIC+0
	MOVWF      FARG_slcd_write_string_str+0
	CLRF       FARG_slcd_write_string_row+0
	CLRF       FARG_slcd_write_string_col+0
	CALL       _slcd_write_string+0
;MMI_PIC.c,58 :: 		slcd_write_string("Develop", 1, 0);
	MOVLW      ?lstr2_MMI_PIC+0
	MOVWF      FARG_slcd_write_string_str+0
	MOVLW      1
	MOVWF      FARG_slcd_write_string_row+0
	CLRF       FARG_slcd_write_string_col+0
	CALL       _slcd_write_string+0
;MMI_PIC.c,59 :: 		slcd_write_string("Counter:", 0, 5);
	MOVLW      ?lstr3_MMI_PIC+0
	MOVWF      FARG_slcd_write_string_str+0
	CLRF       FARG_slcd_write_string_row+0
	MOVLW      5
	MOVWF      FARG_slcd_write_string_col+0
	CALL       _slcd_write_string+0
;MMI_PIC.c,61 :: 		while(true)
L_main1:
;MMI_PIC.c,63 :: 		slcd_number(counter, 1, 11);
	MOVF       main_counter_L0+0, 0
	MOVWF      FARG_slcd_number_num+0
	MOVF       main_counter_L0+1, 0
	MOVWF      FARG_slcd_number_num+1
	CLRF       FARG_slcd_number_num+2
	CLRF       FARG_slcd_number_num+3
	MOVLW      1
	MOVWF      FARG_slcd_number_row+0
	MOVLW      11
	MOVWF      FARG_slcd_number_col+0
	CALL       _slcd_number+0
;MMI_PIC.c,64 :: 		counter++;
	INCF       main_counter_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_counter_L0+1, 1
;MMI_PIC.c,65 :: 		if(counter >= COUNTER_LIMIT)
	MOVLW      3
	SUBWF      main_counter_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main25
	MOVLW      232
	SUBWF      main_counter_L0+0, 0
L__main25:
	BTFSS      STATUS+0, 0
	GOTO       L_main3
;MMI_PIC.c,67 :: 		counter = 0;
	CLRF       main_counter_L0+0
	CLRF       main_counter_L0+1
;MMI_PIC.c,68 :: 		}
L_main3:
;MMI_PIC.c,69 :: 		__ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	NOP
	NOP
;MMI_PIC.c,71 :: 		test_buttons();
	CALL       _test_buttons+0
;MMI_PIC.c,72 :: 		} // end while
	GOTO       L_main1
;MMI_PIC.c,73 :: 		}// End main
L_end_main:
	GOTO       $+0
; end of _main

_select:

;MMI_PIC.c,80 :: 		void select(volatile unsigned char *port, char *test_opt)
;MMI_PIC.c,82 :: 		if(*port & BT1)
	MOVF       FARG_select_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSS      R2+0, 4
	GOTO       L_select5
;MMI_PIC.c,84 :: 		slcd_wr_po('K', 1, 4);
	MOVLW      75
	MOVWF      FARG_slcd_wr_po_chr+0
	MOVLW      1
	MOVWF      FARG_slcd_wr_po_row+0
	MOVLW      4
	MOVWF      FARG_slcd_wr_po_col+0
	CALL       _slcd_wr_po+0
;MMI_PIC.c,85 :: 		slcd_write('B');
	MOVLW      66
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_PIC.c,86 :: 		slcd_write(':');
	MOVLW      58
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_PIC.c,87 :: 		*test_opt = 0;
	MOVF       FARG_select_test_opt+0, 0
	MOVWF      FSR
	CLRF       INDF+0
;MMI_PIC.c,88 :: 		} // end if
	GOTO       L_select6
L_select5:
;MMI_PIC.c,91 :: 		slcd_wr_po('N', 1, 4);
	MOVLW      78
	MOVWF      FARG_slcd_wr_po_chr+0
	MOVLW      1
	MOVWF      FARG_slcd_wr_po_row+0
	MOVLW      4
	MOVWF      FARG_slcd_wr_po_col+0
	CALL       _slcd_wr_po+0
;MMI_PIC.c,92 :: 		slcd_write(':');
	MOVLW      58
	MOVWF      FARG_slcd_write_chr+0
	CALL       _slcd_write+0
;MMI_PIC.c,93 :: 		*test_opt = 1;
	MOVF       FARG_select_test_opt+0, 0
	MOVWF      FSR
	MOVLW      1
	MOVWF      INDF+0
;MMI_PIC.c,94 :: 		} // end else
L_select6:
;MMI_PIC.c,96 :: 		(*port & BT2) ? sled_off()       : sled_on();
	MOVF       FARG_select_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSS      R2+0, 5
	GOTO       L_select7
	CALL       _sled_off+0
	GOTO       L_select8
L_select7:
	CALL       _sled_on+0
L_select8:
;MMI_PIC.c,97 :: 		(*port & BT3) ? sbacklight_off() : sbacklight_on();
	MOVF       FARG_select_port+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R2+0
	BTFSS      R2+0, 6
	GOTO       L_select9
	CALL       _sbacklight_off+0
	GOTO       L_select10
L_select9:
	CALL       _sbacklight_on+0
L_select10:
;MMI_PIC.c,99 :: 		} // end select
L_end_select:
	RETURN
; end of _select

_number_test:

;MMI_PIC.c,102 :: 		void number_test(void)
;MMI_PIC.c,106 :: 		slcd_number(val++, 1, 6);
	MOVF       number_test_val_L0+0, 0
	MOVWF      FARG_slcd_number_num+0
	MOVF       number_test_val_L0+1, 0
	MOVWF      FARG_slcd_number_num+1
	CLRF       FARG_slcd_number_num+2
	CLRF       FARG_slcd_number_num+3
	MOVLW      1
	MOVWF      FARG_slcd_number_row+0
	MOVLW      6
	MOVWF      FARG_slcd_number_col+0
	CALL       _slcd_number+0
	INCF       number_test_val_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       number_test_val_L0+1, 1
;MMI_PIC.c,107 :: 		delay_ms(100);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_number_test11:
	DECFSZ     R13+0, 1
	GOTO       L_number_test11
	DECFSZ     R12+0, 1
	GOTO       L_number_test11
	NOP
	NOP
;MMI_PIC.c,108 :: 		} // end number_test
L_end_number_test:
	RETURN
; end of _number_test

_keyboard_test:

;MMI_PIC.c,112 :: 		void keyboard_test(void)
;MMI_PIC.c,116 :: 		kb = keyboard(&PORTB);
	MOVLW      PORTB+0
	MOVWF      FARG_keyboard_port+0
	CALL       _keyboard+0
	MOVF       R0+0, 0
	MOVWF      keyboard_test_kb_L0+0
;MMI_PIC.c,118 :: 		switch(kb)
	GOTO       L_keyboard_test12
;MMI_PIC.c,120 :: 		case 1:
L_keyboard_test14:
;MMI_PIC.c,121 :: 		slcd_wr_po('1', 1, 10);
	MOVLW      49
	MOVWF      FARG_slcd_wr_po_chr+0
	MOVLW      1
	MOVWF      FARG_slcd_wr_po_row+0
	MOVLW      10
	MOVWF      FARG_slcd_wr_po_col+0
	CALL       _slcd_wr_po+0
;MMI_PIC.c,122 :: 		break;
	GOTO       L_keyboard_test13
;MMI_PIC.c,124 :: 		case 2:
L_keyboard_test15:
;MMI_PIC.c,125 :: 		slcd_wr_po('2', 1, 10);
	MOVLW      50
	MOVWF      FARG_slcd_wr_po_chr+0
	MOVLW      1
	MOVWF      FARG_slcd_wr_po_row+0
	MOVLW      10
	MOVWF      FARG_slcd_wr_po_col+0
	CALL       _slcd_wr_po+0
;MMI_PIC.c,126 :: 		break;
	GOTO       L_keyboard_test13
;MMI_PIC.c,128 :: 		case 3:
L_keyboard_test16:
;MMI_PIC.c,129 :: 		slcd_wr_po('3', 1, 10);
	MOVLW      51
	MOVWF      FARG_slcd_wr_po_chr+0
	MOVLW      1
	MOVWF      FARG_slcd_wr_po_row+0
	MOVLW      10
	MOVWF      FARG_slcd_wr_po_col+0
	CALL       _slcd_wr_po+0
;MMI_PIC.c,130 :: 		break;
	GOTO       L_keyboard_test13
;MMI_PIC.c,132 :: 		case 4:
L_keyboard_test17:
;MMI_PIC.c,133 :: 		slcd_wr_po('4', 1, 10);
	MOVLW      52
	MOVWF      FARG_slcd_wr_po_chr+0
	MOVLW      1
	MOVWF      FARG_slcd_wr_po_row+0
	MOVLW      10
	MOVWF      FARG_slcd_wr_po_col+0
	CALL       _slcd_wr_po+0
;MMI_PIC.c,134 :: 		break;
	GOTO       L_keyboard_test13
;MMI_PIC.c,135 :: 		} // end switch
L_keyboard_test12:
	MOVF       keyboard_test_kb_L0+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_keyboard_test14
	MOVF       keyboard_test_kb_L0+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_keyboard_test15
	MOVF       keyboard_test_kb_L0+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_keyboard_test16
	MOVF       keyboard_test_kb_L0+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_keyboard_test17
L_keyboard_test13:
;MMI_PIC.c,136 :: 		}// end keyboard_test
L_end_keyboard_test:
	RETURN
; end of _keyboard_test

_test_buttons:

;MMI_PIC.c,140 :: 		void test_buttons(void)
;MMI_PIC.c,144 :: 		kb = keyboard(&PORTB);
	MOVLW      PORTB+0
	MOVWF      FARG_keyboard_port+0
	CALL       _keyboard+0
	MOVF       R0+0, 0
	MOVWF      test_buttons_kb_L0+0
;MMI_PIC.c,146 :: 		switch(kb)
	GOTO       L_test_buttons18
;MMI_PIC.c,148 :: 		case 1:
L_test_buttons20:
;MMI_PIC.c,149 :: 		sled_on();
	CALL       _sled_on+0
;MMI_PIC.c,150 :: 		sbacklight_on();
	CALL       _sbacklight_on+0
;MMI_PIC.c,151 :: 		break;
	GOTO       L_test_buttons19
;MMI_PIC.c,153 :: 		case 2:
L_test_buttons21:
;MMI_PIC.c,154 :: 		sled_on();
	CALL       _sled_on+0
;MMI_PIC.c,155 :: 		sbacklight_off();
	CALL       _sbacklight_off+0
;MMI_PIC.c,156 :: 		break;
	GOTO       L_test_buttons19
;MMI_PIC.c,158 :: 		case 3:
L_test_buttons22:
;MMI_PIC.c,159 :: 		sled_off();
	CALL       _sled_off+0
;MMI_PIC.c,160 :: 		sbacklight_on();
	CALL       _sbacklight_on+0
;MMI_PIC.c,161 :: 		break;
	GOTO       L_test_buttons19
;MMI_PIC.c,163 :: 		case 4:
L_test_buttons23:
;MMI_PIC.c,164 :: 		sled_off();
	CALL       _sled_off+0
;MMI_PIC.c,165 :: 		sbacklight_off();
	CALL       _sbacklight_off+0
;MMI_PIC.c,166 :: 		break;
	GOTO       L_test_buttons19
;MMI_PIC.c,167 :: 		}// end switch
L_test_buttons18:
	MOVF       test_buttons_kb_L0+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_test_buttons20
	MOVF       test_buttons_kb_L0+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_test_buttons21
	MOVF       test_buttons_kb_L0+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_test_buttons22
	MOVF       test_buttons_kb_L0+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_test_buttons23
L_test_buttons19:
;MMI_PIC.c,168 :: 		}// end test_buttons
L_end_test_buttons:
	RETURN
; end of _test_buttons
