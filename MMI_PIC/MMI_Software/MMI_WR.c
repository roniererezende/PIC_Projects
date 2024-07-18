/* ===================================================================================================
        
        MMIWR v.01 MMI_WR.c
        
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
   
// ======================================================
// --- LIBRARIES ---
#include "MMI_WR.h"

// ======================================================
// --- GLOBAL VARIABLES ---
char sled = 0,                                                        // keeps the current state of LED
     sbli = 0;                                                        // keeps the current state of backlight
   
// ======================================================
// --- FUNCTIONS ---

// ======================================================
// --- slcd_write ---
// Writes characters in current position in the LCD
// Parameters:
//                          char -> 
void slcd_write(unsigned char chr)          
{
    send_nibble(chr, 1, sbli, sled);
    chr <<= 4;
    send_nibble(chr, 1, sbli, sled);
}// slcd_write        

// ======================================================
// --- slcd_write ---
// Writes string in current position in the LCD
void slcd_write_string(unsigned char str[], char row, char col)
{
    char index = 0;

    if(!row)                   // line 0
    {
        slcd_cmd(0x80 | col);  // sends commant to positione in correct column
    }
    else
    {
        slcd_cmd(0xC0 | col);   // sends commant to positione in correct column
    }
    while(str[index] != '\0')
    {
          slcd_write(str[index]);
          index++;
    }
} // slcd_write_string

// ======================================================
// --- slcd_wr_po ---
// Writes characters on LCD, according to specified line and row
void slcd_wr_po(unsigned char chr, char row, char col)
{
    if(!row)                   // line 0
    {
        slcd_cmd(0x80 | col);  // sends commant to positione in correct column
        slcd_write(chr);
    }   // end if
    else                       // else, it's line 1
    {
        slcd_cmd(0xC0 | col);   // sends commant to positione in correct column
        slcd_write(chr);
    }   // end else
}// end slcd_wr_po

// ======================================================
// --- slcd_cmd ---
// Sends commands to the LCD
// Parameters:
//                          char -> 
void slcd_cmd(unsigned char cmd)                   
{
    send_nibble(cmd, 0, sbli, sled);
    cmd <<= 4;
    send_nibble(cmd, 0, sbli, sled);
}// end slcd_cmd

// ======================================================
// --- slcd_number ---
// Converts a positive integer to print on LCD characters on LCD, according to specified line and row
void slcd_number(unsigned long num, char row, char col)
{
    char dem, mil, cen, dez, uni;    // Variables for calculation of each digit
    short no_zero = 0;               // Variables for cleaning of zeros to the left
    
    dem = (char)(num / 10000);
    mil = (char)(num % 10000 / 1000);
    cen = (char)(num % 1000 / 100);
    dez = (char)(num % 100 / 10);
    uni = (char)(num % 10);
    
    if(!dem && !no_zero)
        slcd_wr_po(' ', row, col);
    else
    {
        slcd_wr_po(dem + 0x30, row, col);
        no_zero = 1;
    }

    if(!mil && !no_zero)
        slcd_write(' ');
    else
    {
        slcd_write(mil + 0x30);
        no_zero = 1;
    }

    if(!cen && !no_zero)
        slcd_write(' ');
    else
    {
        slcd_write(cen + 0x30);
        no_zero = 1;
    }

    if(!dez && !no_zero)
        slcd_write(' ');
    else
    {
        slcd_write(dez + 0x30);
        no_zero = 1;
    }
    slcd_write(uni + 0x30);
}// end slcd_number
// ======================================================
// --- slcd_init ---
// Initializes LCD in 4 bits mode
void slcd_init(void)                                        
{
    __ms(48);                // Stabilization time recommended (datasheet)
    send_nibble(0x30,0,0,0); // Initialization protocol
    __ms(5);                                 // Time above of suggested (datasheet)
    send_nibble(0x30,0,0,0); // Initialization protocol
    __us(150);               // Time above of suggested (datasheet)
    send_nibble(0x30,0,0,0); // Initialization protocol
    send_nibble(0x20,0,0,0); // 4 bits mode LCD
        
    slcd_cmd(0x28);          // 5x8 dots by character, two lines
    slcd_opt(1, 0, 0);       // Turn on LCD, turn off cursor, turn off blink)
    slcd_cmd(0x01);          // Clears LCD
    slcd_cmd(0x06);          // Address increment mode for right
    slcd_clear();
}// slcd_init

// ======================================================
// --- slcd_clear ---
// Clears LCD
void slcd_clear(void)                       
{
    slcd_cmd(0x02);                          // Returns to home
    slcd_cmd(0x01);                          // Clears LCD
}// end slcd_clear

// ======================================================
// --- shift_reg ---
// Controls shift register
// Parameters:
//                          byte_val -> 
void shift_reg(unsigned char byte_val)         
{
    register int i;                                        // Iteractions variable
        
    for(i = 7; i >= 0; i--)
    {
        (byte_val >> i) & 0x01 ?
            (PORTMCU |=  DAT):
            (PORTMCU &= ~DAT);
                        
        __us(100);
        PORTMCU |=  CLK;
        __ms(1);
        PORTMCU &= ~CLK;
        __us(100);
    } // end for
        
    PORTMCU &= ~DAT;
    PORTMCU |=  LAT;
    __ms(1);
    PORTMCU &= ~LAT;
}// end shift_reg

// ======================================================
// --- send_nibble ---
// Parameters:
//                           nib  -> Sents each byte bibble sep
//                           rsel -> Logic state of register select
//            bli  -> Logic state of backlight
//            led  -> Logic state of LED 
void send_nibble(unsigned char nib, char rsel, char bli, char led)    
{
    static unsigned char sbyte = 0x00;
        
    sbyte = (nib & (1 << 7))|
            (nib & (1 << 6))|
            (nib & (1 << 5))|
            (nib & (1 << 4));
                         
    rsel ? (sbyte |= RS) : (sbyte &= ~RS);
    bli  ? (sbyte |= BL) : (sbyte &= ~BL);
    led  ? (sbyte |= LD) : (sbyte &= ~LD);
        
    shift_reg(sbyte | EN);
    __us(100);
    shift_reg(sbyte &~ EN);
    __us(100);
} // end send_nibble 

// ======================================================
// --- slcd_opt ---
// Set ON (1) | OFF (0) for: display, cursor, and blink
void slcd_opt(char disp, char cursor, char blink)
{
    static char opt = 0x08;   //

    disp   ? (opt |= (1 << 2)) : (opt &= ~(1 << 2));
    cursor ? (opt |= (1 << 1)) : (opt &= ~(1 << 1));
    blink  ? (opt |= (1 << 0)) : (opt &= ~(1 << 0));
        
    slcd_cmd(opt);
        
}// end slcd_opt

// ======================================================
// --- sled_on ---
// Turns on LED
void sled_on(void)
{
    sled = 1;
    slcd_cmd(0x06);
} // end sled_on

// ======================================================
// --- sled_off ---
// Turns off LED
void sled_off(void)
{
    sled = 0;
    slcd_cmd(0x06);
}// end sled_off

// ======================================================
// --- sbacklight_on ---
// Turns on backlight
void sbacklight_on(void)
{
     sbli = 1;
     slcd_cmd(0x06);
}// end sbacklight_on

// ======================================================
// --- sbacklight_off ---
// Turns off backlight
void sbacklight_off(void)
{
     sbli = 0;
     slcd_cmd(0x06);
} // end sbacklight_off

// ======================================================
// --- keyboard ---
// Keyboard reading, return pressed key
char keyboard(volatile unsigned char *port)
{
    static unsigned char flags = 0x00;      // Button Actuated Indicator
    // --- Button 1 ---
    if(!(*port & BT1))                      // Did button 1 press
        flags |= (1 << 1);                  // Yes, set bit 1 flag

    if((*port & BT1) && (flags & (1 << 1))) // button 1 released and flag 1 set
    {                                       // Yes
        flags &= ~(1 << 1);                 // cleans flag 1
        __ms(50);                           // anti-bouncing
        return 1;                           // return 1, indicating button 1 pressed
    }
    // End button 1

    // --- Button 2 ---
    if(!(*port & BT2))                      // Did button 2 press
        flags |= (1 << 2);                  // Yes, set bit 2 flag

    if((*port & BT1) && (flags & (1 << 2))) // button 2 released and flag 2 set
    {                                       // Yes
        flags &= ~(1 << 2);                 // cleans flag 2
        __ms(50);                           // anti-bouncing
        return 2;                           // return 2, indicating button 2 pressed
    }
    // End button 2
    
    // --- Button 3 ---
    if(!(*port & BT3))                      // Did button 3 press
        flags |= (1 << 3);                  // Yes, set bit 3 flag
        
    if((*port & BT3) && (flags & (1 << 3))) // button 1 released and flag 3 set
    {                                       // Yes
        flags &= ~(1 << 3);                 // cleans flag 3
        __ms(50);                           // anti-bouncing
        return 3;                           // return 3, indicating button 3 pressed
    }
    // End button 3
    
    // --- Button 4 ---
    if(!(*port & BT4))                      // Did button 4 press
        flags |= (1 << 4);                  // Yes, set bit 4 flag

    if((*port & BT4) && (flags & (1 << 4))) // button 1 released and flag 4 set
    {                                       // Yes
        flags &= ~(1 << 4);                 // cleans flag 4
        __ms(50);                           // anti-bouncing
        return 4;                           // return 4, indicating button 1 pressed
    }
    // End button 4
    return 0;
} // end keyboard