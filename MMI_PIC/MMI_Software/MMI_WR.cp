#line 1 "E:/Users/Roniere Resende/Documents/Meus Documentos/Estudo de Tecnologias/PIC Microcontrollers/Projects/MMI_PIC/MMI_Software/MMI_WR.c"
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
#line 25 "E:/Users/Roniere Resende/Documents/Meus Documentos/Estudo de Tecnologias/PIC Microcontrollers/Projects/MMI_PIC/MMI_Software/MMI_WR.c"
char sled = 0,
 sbli = 0;









void slcd_write(unsigned char chr)
{
 send_nibble(chr, 1, sbli, sled);
 chr <<= 4;
 send_nibble(chr, 1, sbli, sled);
}




void slcd_write_string(unsigned char str[], char row, char col)
{
 char index = 0;

 if(!row)
 {
 slcd_cmd(0x80 | col);
 }
 else
 {
 slcd_cmd(0xC0 | col);
 }
 while(str[index] != '\0')
 {
 slcd_write(str[index]);
 index++;
 }
}




void slcd_wr_po(unsigned char chr, char row, char col)
{
 if(!row)
 {
 slcd_cmd(0x80 | col);
 slcd_write(chr);
 }
 else
 {
 slcd_cmd(0xC0 | col);
 slcd_write(chr);
 }
}






void slcd_cmd(unsigned char cmd)
{
 send_nibble(cmd, 0, sbli, sled);
 cmd <<= 4;
 send_nibble(cmd, 0, sbli, sled);
}




void slcd_number(unsigned long num, char row, char col)
{
 char dem, mil, cen, dez, uni;
 short no_zero = 0;

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
}



void slcd_init(void)
{
  delay_ms(48) ;
 send_nibble(0x30,0,0,0);
  delay_ms(5) ;
 send_nibble(0x30,0,0,0);
  delay_us(150) ;
 send_nibble(0x30,0,0,0);
 send_nibble(0x20,0,0,0);

 slcd_cmd(0x28);
 slcd_opt(1, 0, 0);
 slcd_cmd(0x01);
 slcd_cmd(0x06);
 slcd_clear();
}




void slcd_clear(void)
{
 slcd_cmd(0x02);
 slcd_cmd(0x01);
}






void shift_reg(unsigned char byte_val)
{
 register int i;

 for(i = 7; i >= 0; i--)
 {
 (byte_val >> i) & 0x01 ?
 ( PORTB  |=  (1 << 1) ):
 ( PORTB  &= ~ (1 << 1) );

  delay_us(100) ;
  PORTB  |=  (1 << 0) ;
  delay_ms(1) ;
  PORTB  &= ~ (1 << 0) ;
  delay_us(100) ;
 }

  PORTB  &= ~ (1 << 1) ;
  PORTB  |=  (1 << 2) ;
  delay_ms(1) ;
  PORTB  &= ~ (1 << 2) ;
}








void send_nibble(unsigned char nib, char rsel, char bli, char led)
{
 static unsigned char sbyte = 0x00;

 sbyte = (nib & (1 << 7))|
 (nib & (1 << 6))|
 (nib & (1 << 5))|
 (nib & (1 << 4));

 rsel ? (sbyte |=  (1 << 2) ) : (sbyte &= ~ (1 << 2) );
 bli ? (sbyte |=  (1 << 1) ) : (sbyte &= ~ (1 << 1) );
 led ? (sbyte |=  (1 << 0) ) : (sbyte &= ~ (1 << 0) );

 shift_reg(sbyte |  (1 << 3) );
  delay_us(100) ;
 shift_reg(sbyte &~  (1 << 3) );
  delay_us(100) ;
}




void slcd_opt(char disp, char cursor, char blink)
{
 static char opt = 0x08;

 disp ? (opt |= (1 << 2)) : (opt &= ~(1 << 2));
 cursor ? (opt |= (1 << 1)) : (opt &= ~(1 << 1));
 blink ? (opt |= (1 << 0)) : (opt &= ~(1 << 0));

 slcd_cmd(opt);

}




void sled_on(void)
{
 sled = 1;
 slcd_cmd(0x06);
}




void sled_off(void)
{
 sled = 0;
 slcd_cmd(0x06);
}




void sbacklight_on(void)
{
 sbli = 1;
 slcd_cmd(0x06);
}




void sbacklight_off(void)
{
 sbli = 0;
 slcd_cmd(0x06);
}




char keyboard(volatile unsigned char *port)
{
 static unsigned char flags = 0x00;

 if(!(*port &  (1 << 4) ))
 flags |= (1 << 1);

 if((*port &  (1 << 4) ) && (flags & (1 << 1)))
 {
 flags &= ~(1 << 1);
  delay_ms(50) ;
 return 1;
 }



 if(!(*port &  (1 << 5) ))
 flags |= (1 << 2);

 if((*port &  (1 << 4) ) && (flags & (1 << 2)))
 {
 flags &= ~(1 << 2);
  delay_ms(50) ;
 return 2;
 }



 if(!(*port &  (1 << 6) ))
 flags |= (1 << 3);

 if((*port &  (1 << 6) ) && (flags & (1 << 3)))
 {
 flags &= ~(1 << 3);
  delay_ms(50) ;
 return 3;
 }



 if(!(*port &  (1 << 7) ))
 flags |= (1 << 4);

 if((*port &  (1 << 7) ) && (flags & (1 << 4)))
 {
 flags &= ~(1 << 4);
  delay_ms(50) ;
 return 4;
 }

 return 0;
}
