    #include p18f87k22.inc
    

#define	RST	0
#define MOSI	4
#define MISO	5
#define SCK	6
#define CS	7

;Command/Data pins for SPI
#define RA8875_DATAWRITE        0x00 
#define RA8875_DATAREAD         0x40 
#define RA8875_CMDWRITE         0x80
#define RA8875_CMDREAD          0xC0

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
    
LCD_begin
    clrf    LATD
    clrf    TRISD
    bsf	    TRISD, MISO
    bsf	    LATD, CS
    bcf	    LATD, RST
    movlw   .100
    call    LCD_delay_ms
    bsf	    LATD, RST
    movlw   .100
    call    LCD_delay_ms
    
    call    SPI_MasterInit
    
    
    movlw   0x91
    movwf   input_cmd
    call    SPI_writeCMD
    
    movlw   0x0A
    movwf   input_data
    call    SPI_writeDATA
    
    movlw   0x92
    movwf   input_cmd
    call    SPI_writeCMD
    
  writeData(x0 >> 8);

  /* Set Y */
  writeCommand(0x93);
  writeData(y0);
  writeCommand(0x94);
  writeData(y0 >> 8);

  /* Set X1 */
  writeCommand(0x95);
  writeData(x1);
  writeCommand(0x96);
  writeData((x1) >> 8);

  /* Set Y1 */
  writeCommand(0x97);
  writeData(y1);
  writeCommand(0x98);
  writeData((y1) >> 8);

  /* Set Color */
  writeCommand(0x63);
  writeData((color & 0xf800) >> 11);
  writeCommand(0x64);
  writeData((color & 0x07e0) >> 5);
  writeCommand(0x65);
  writeData((color & 0x001f));

  /* Draw! */
  writeCommand(RA8875_DCR);
  writeData(0x80);
  
    goto    $
SPI_writeREG
    call    SPI_writeCMD
    call    SPI_writeDATA
    return
    
SPI_writeCMD
    bcf	    LATD, CS
    movlw   RA8875_CMDWRITE
    call    SPI_MasterTransmit
    movlw   input_cmd
    call    SPI_MasterTransmit
    bsf	    LATD, CS
    return
    
SPI_writeDATA
    bcf	    LATD, CS
    movlw   RA8875_DATAWRITE
    call    SPI_MasterTransmit
    movlw   input_data
    call    SPI_MasterTransmit
    bsf	    LATD, CS    
    return
    
SPI_MasterInit ; Set Clock edge to negative
    bcf SSP2STAT, CKE
    ; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
    movlw (1<<SSPEN)|(1<<CKP)|(0x02)
    movwf SSP2CON1
    return
    
SPI_MasterTransmit ; Start transmission of data (held in W)
    movwf SSP2BUF
    
Wait_Transmit ; Wait for transmission to complete
    btfss PIR2, SSP2IF
    bra Wait_Transmit
    bcf PIR2, SSP2IF ; clear interrupt flag
    return

LCD_delay_ms		    ; delay given in ms in W
	movwf	LCD_cnt_ms
lcdlp2	movlw	.250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms
	bra	lcdlp2
	return

LCD_delay_x4us		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l   ; now need to multiply by 16
	swapf   LCD_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l,W ; move low nibble to W
	movwf	LCD_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1	decf 	LCD_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return
	
    end