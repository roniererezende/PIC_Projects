/* ===================================================================================================
        
        MMIWR v.01 MMI_WR.h
        
        Serial Interface with PCF8574
        LCD 16x2 with backkight
        Auxiliary LED
        4 buttons
        
        Compiler: MikroC Pro For PIC v.7.1.0
        MCU: PIC16F628A
        Clk: 4 MHZ Crystal
        
        Author: Roniere Rezende
        Date: 2024, July

   =================================================================================================== */
   
   #ifndef MMI_WR_H
   #define MMI_WR_H
   
   
// ======================================================
// --- Hardware Mapping ---
#define CLK     (1 << 0)
#define DAT     (1 << 1)
#define LAT          (1 << 2)
#define BT1          (1 << 4)
#define BT2          (1 << 5)
#define BT3          (1 << 6)
#define BT4          (1 << 7)
#define PORTMCU PORTB

// ======================================================
// --- MACROS ---
#define __ms(t) delay_ms(t)
#define __us(t) delay_us(t)

// ======================================================
// --- CONSTANTS ---
#define LD  (1 << 0)
#define BL  (1 << 1)
#define RS  (1 << 2)
#define EN  (1 << 3)
   
// ======================================================
// --- FUNCTIONS ---
void slcd_write(unsigned char chr);                              // Writes characters in current position in the LCD
void slcd_write_string(unsigned char str[], char row, char col); // Writes string in current position in the LCD
void slcd_wr_po(unsigned char chr,                               // Writes characters on LCD...
                char row, char col);                             // ...in specified line and row
void slcd_cmd(unsigned char cmd);                                // Sends commands to the LCD
void slcd_number(unsigned long num,                              // Converts a positive integer to print on LCD...
                 char row, char col);                            // ...in specified line and row
void slcd_init(void);                                            // Initializes LCD in 4 bits mode
void slcd_clear(void);                                           // Clears LCD
void shift_reg(unsigned char byte_val);                          // Controls shift register
void send_nibble(unsigned char nib,                              // Sents each byte bibble sep
                          char rsel,                             // Logic state of register select
                          char bli,                              // Logic state of backlight
                          char led);                             // Logic state of LED
void sled_on(void);
void sled_off(void);
void sbacklight_on(void);
void sbacklight_off(void);
void slcd_opt(char disp, char cursor, char blink); // Set ON (1) | OFF (0) for: display, cursor, and blink
char keyboard(volatile unsigned char *port);
   
   
   
   
   
   
   
   #endif // MMI_WR_H   
// =====================================================================================================
// --- End of Program --- 