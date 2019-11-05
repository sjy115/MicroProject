#include p18f87k22.inc
    

#define	RST	0
#define MOSI	4
#define MISO	5
#define SCK	6
#define CS	7

#define pixclk		0x81
#define	hsync_nondisp   26
#define hsync_start     32
#define hsync_pw        96
#define hsync_finetune  0
#define vsync_nondisp   32
#define vsync_start     23
#define vsync_pw        2
#define _voffset        0

    
#define	_width		800
#define	_height		480  

acs0    udata_acs   ; reserve data space in access ram
input_cmd	res 1
input_data	res 1
LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
  

code
  
PLLinit
    
    movlw   RA8875_PLLC1
    movwf   input_cmd
    movlw   RA8875_PLLC1_PLLDIV1
    addlw   .11
    movwf   input_data
    call    SPI_writeREG
    movlw   .1
    call    LCD_delay_ms
   
    movlw   RA8875_PLLC2
    movwf   input_cmd
    movlw   RA8875_PLLC2_PLLDIV4
    movwf   input_data
    call    SPI_writeREG
    movlw   .1
    call    LCD_delay_ms
    
    movlw   RA8875_SYSR
    movwf   input_cmd
    movlw   RA8875_SYSR_16BPP | RA8875_SYSR_MCU8
    movwf   input_data
    call    SPI_writeREG

    movlw   RA8875_PCSR
    movwf   input_cmd
    movlw   pixclk

    movwf   input_data
    call    SPI_writeREG
    movlw   .1
    call    LCD_delay_ms

  ; Horizontal settings registers ;
  movlw   RA8875_HDWR
  movwf   input_cmd
  movlw     (_width / 8) - 1);                          // H width: (HDWR + 1) * 8 = 480
  movlw   RA8875_HNDFTR
  movwf   input_cmd
  movlw     RA8875_HNDFTR_DE_HIGH + hsync_finetune);
  movlw   RA8875_HNDR
  movwf   input_cmd
  movlw     (hsync_nondisp - hsync_finetune - 2)/8);    // H non-display: HNDR * 8 + HNDFTR + 2 = 10
  movlw   RA8875_HSTR
  movwf   input_cmd
  movlw     hsync_start/8 - 1);                         // Hsync start: (HSTR + 1)*8
  movlw   RA8875_HPWR
  movwf   input_cmd
  movlw     RA8875_HPWR_LOW + (hsync_pw/8 - 1));        // HSync pulse width = (HPWR+1) * 8

  ; Vertical settings registers ;
  movlw   RA8875_VDHR0
  movwf   input_cmd
  movlw     (uint16_t)(_height - 1 + _voffset) & 0xFF);
  movlw   RA8875_VDHR1
  movwf   input_cmd
  movlw     (uint16_t)(_height - 1 + _voffset) >> 8);
  movlw   RA8875_VNDR0
  movwf   input_cmd
  movlw     vsync_nondisp-1);                          // V non-display period = VNDR + 1
  movlw   RA8875_VNDR1
  movwf   input_cmd
  movlw     vsync_nondisp >> 8);
  movlw   RA8875_VSTR0
  movwf   input_cmd
  movlw     vsync_start-1);                            // Vsync start position = VSTR + 1
  movlw   RA8875_VSTR1
  movwf   input_cmd
  movlw     vsync_start >> 8);
  movlw   RA8875_VPWR
  movwf   input_cmd
  movlw     RA8875_VPWR_LOW + vsync_pw - 1);            // Vsync pulse width = VPWR + 1

  ; Set active window X ;
  movlw   RA8875_HSAW0
  movwf   input_cmd
  movlw     0);                                        // horizontal start point
  movlw   RA8875_HSAW1
  movwf   input_cmd
  movlw     0);
  movlw   RA8875_HEAW0
  movwf   input_cmd
  movlw     (uint16_t)(_width - 1) & 0xFF);            // horizontal end point
  movlw   RA8875_HEAW1
  movwf   input_cmd
  movlw     (uint16_t)(_width - 1) >> 8);

  ; Set active window Y ;
  movlw   RA8875_VSAW0
  movwf   input_cmd
  movlw     0 + _voffset);                              // vertical start point
  movlw   RA8875_VSAW1
  movwf   input_cmd
  movlw     0 + _voffset);
  movlw   RA8875_VEAW0
  movwf   input_cmd
  movlw     (uint16_t)(_height - 1 + _voffset) & 0xFF); // vertical end point
  movlw   RA8875_VEAW1
  movwf   input_cmd
  movlw     (uint16_t)(_height - 1 + _voffset) >> 8);

  ; ToDo: Setup touch panel? ;

  ; Clear the entire window ;
  movlw   RA8875_MCLR
  movwf   input_cmd
  movlw     RA8875_MCLR_START | RA8875_MCLR_FULL);
  delay(500);