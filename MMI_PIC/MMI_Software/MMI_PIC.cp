#line 1 "E:/Users/Roniere Resende/Documents/Meus Documentos/Estudo de Tecnologias/PIC Microcontrollers/Projects/MMI_PIC/MMI_Software/MMI_PIC.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdbool.h"



 typedef char _Bool;
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed char int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 1 "e:/users/roniere resende/documents/meus documentos/estudo de tecnologias/pic microcontrollers/projects/mmi_pic/mmi_software/mmi_wr.h"
#line 48 "e:/users/roniere resende/documents/meus documentos/estudo de tecnologias/pic microcontrollers/projects/mmi_pic/mmi_software/mmi_wr.h"
void slcd_write(unsigned char chr);
void slcd_write_string(unsigned char str[], char row, char col);
void slcd_wr_po(unsigned char chr,
 char row, char col);
void slcd_cmd(unsigned char cmd);
void slcd_number(unsigned long num,
 char row, char col);
void slcd_init(void);
void slcd_clear(void);
void shift_reg(unsigned char byte_val);
void send_nibble(unsigned char nib,
 char rsel,
 char bli,
 char led);
void sled_on(void);
void sled_off(void);
void sbacklight_on(void);
void sbacklight_off(void);
void slcd_opt(char disp, char cursor, char blink);
char keyboard(volatile unsigned char *port);
#line 30 "E:/Users/Roniere Resende/Documents/Meus Documentos/Estudo de Tecnologias/PIC Microcontrollers/Projects/MMI_PIC/MMI_Software/MMI_PIC.c"
void select(volatile unsigned char *port,
 char *test_opt);
void number_test(void);
void keyboard_test(void);
void test_buttons(void);



void main(void)
{
 char tests = 0;
 uint16_t counter = 0;

 CMCON = 0x07;
 TRISB = 0xF8;

 slcd_init();

 delay_ms(100);
 slcd_opt(1,0,0);

 sled_on();
 sbacklight_on();

 sled_off();
 sbacklight_off();

 slcd_write_string("PIC", 0, 0);
 slcd_write_string("Develop", 1, 0);
 slcd_write_string("Counter:", 0, 5);

 while( 1 )
 {
 slcd_number(counter, 1, 11);
 counter++;
 if(counter >=  1000 )
 {
 counter = 0;
 }
  delay_ms(100) ;

 test_buttons();
 }
}






void select(volatile unsigned char *port, char *test_opt)
{
 if(*port &  (1 << 4) )
 {
 slcd_wr_po('K', 1, 4);
 slcd_write('B');
 slcd_write(':');
 *test_opt = 0;
 }
 else
 {
 slcd_wr_po('N', 1, 4);
 slcd_write(':');
 *test_opt = 1;
 }

 (*port &  (1 << 5) ) ? sled_off() : sled_on();
 (*port &  (1 << 6) ) ? sbacklight_off() : sbacklight_on();

}


void number_test(void)
{
 static unsigned val = 0;

 slcd_number(val++, 1, 6);
 delay_ms(100);
}



void keyboard_test(void)
{
 static char kb = 0;

 kb = keyboard(&PORTB);

 switch(kb)
 {
 case 1:
 slcd_wr_po('1', 1, 10);
 break;

 case 2:
 slcd_wr_po('2', 1, 10);
 break;

 case 3:
 slcd_wr_po('3', 1, 10);
 break;

 case 4:
 slcd_wr_po('4', 1, 10);
 break;
 }
}



void test_buttons(void)
{
 static char kb = 0;

 kb = keyboard(&PORTB);

 switch(kb)
 {
 case 1:
 sled_on();
 sbacklight_on();
 break;

 case 2:
 sled_on();
 sbacklight_off();
 break;

 case 3:
 sled_off();
 sbacklight_on();
 break;

 case 4:
 sled_off();
 sbacklight_off();
 break;
 }
}
