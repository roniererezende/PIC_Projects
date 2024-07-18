/* ===================================================================================================
        
        MMIWR v.01 MMI_PIC.c
        
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
// --- Libraries ---
#include <stdbool.h>
#include <stdint.h>
#include "MMI_WR.h"

// ======================================================
// --- Defines ---
#define COUNTER_LIMIT 1000

// ======================================================
// --- Functions Prototypes ---
void select(volatile unsigned char *port,      // Tests writing a integer number on LCD
                              char *test_opt);
void number_test(void);                        // Tests writing a integer number on LCD
void keyboard_test(void);                      // keyboard test, print the pressed keyboard number
void test_buttons(void);

// ======================================================
// --- Main Function ---
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
        
    while(true)
    {
        slcd_number(counter, 1, 11);
        counter++;
        if(counter >= COUNTER_LIMIT)
        {
            counter = 0;
        }
        __ms(100);
        
        test_buttons();
    } // end while
}// End main

// ======================================================
// --- FUNCTIONS ---

// --- number_test ---
// Tests writing a integer number on LCD
void select(volatile unsigned char *port, char *test_opt)
{
    if(*port & BT1)
    {
        slcd_wr_po('K', 1, 4);
        slcd_write('B');
        slcd_write(':');
        *test_opt = 0;
    } // end if
    else
    {
        slcd_wr_po('N', 1, 4);
        slcd_write(':');
        *test_opt = 1;
    } // end else
    
    (*port & BT2) ? sled_off()       : sled_on();
    (*port & BT3) ? sbacklight_off() : sbacklight_on();
    
} // end select
// --- number_test ---
// Tests writing a integer number on LCD
void number_test(void)
{
    static unsigned val = 0;         // started value
    
    slcd_number(val++, 1, 6);
    delay_ms(100);
} // end number_test
// ======================================================
// --- Keyboards_test ---
// keyboard test, print the pressed keyboard number
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
     } // end switch
}// end keyboard_test

// --- test_buttons ---
// buttons tester, activate and deactivate LED and backlight according to the pressed button
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
    }// end switch
}// end test_buttons