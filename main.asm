    #include p18f87k22.inc

    global Delay_ms, SPI_writeREG, SPI_writeCMD, SPI_writeDATA
    extern LCD_PLLinit, LCD_Initialisation,LCD_PLLinit,LCD_Initialisation,LCD_DisplayOn,LCD_GPIOX,LCD_PWM1config,LCD_FillScreen,LCD_PWM1out, input_cmd, input_data

#define	RST		0
#define	MOSI		4
#define	MISO		5
#define	SCK		6
#define CS		7


;Command/Data pins for SPI
#define RA8875_DATAWRITE        0x00 
#define RA8875_DATAREAD         0x40 
#define RA8875_CMDWRITE         0x80
#define RA8875_CMDREAD          0xC0

acs0    udata_acs   ; reserve data space in access ram
;input_cmd	res 1
;input_data	res 1
Delay_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
Delay_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
Delay_cnt_ms  res 1   ; reserve 1 byte for ms counter
  
main    code	0
    
LCD_begin
    clrf    LATD
    bsf	    LATD, CS
    bsf	    LATD, MOSI
    bsf	    LATD, SCK
    
    clrf    TRISD
    bsf	    TRISD, MISO
    
    bcf	    LATD, RST
    movlw   .100
    call    Delay_ms
    bsf	    LATD, RST
    movlw   .100
    call    Delay_ms
    
    call    SPI_MasterInit

    
    call    LCD_PLLinit
    call    LCD_Initialisation
    call    LCD_DisplayOn
    call    LCD_GPIOX ;// Enable TFT - display enable tied to GPIOX
    call    LCD_PWM1config; // PWM output for backlight
    call    LCD_PWM1out;
    
    ;// With hardware accelleration this is instant
    call    LCD_FillScreen
    
    goto    $
SPI_writeREG
    call    SPI_writeCMD
    call    SPI_writeDATA
    return

    
SPI_writeCMD
    bcf	    LATD, CS
    movlw   RA8875_CMDWRITE
    call    SPI_MasterTransmit
    movf    input_cmd, W
    call    SPI_MasterTransmit
    bsf	    LATD, CS
    return
    
SPI_writeDATA
    bcf	    LATD, CS
    movlw   RA8875_DATAWRITE
    call    SPI_MasterTransmit
    movf    input_data, W
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

Delay_ms		    ; Delay given in ms in W
	movwf	Delay_cnt_ms
lp2	movlw	.250	    ; 1 ms Delay
	call	Delay_x4us	
	decfsz	Delay_cnt_ms
	bra	lp2
	return

Delay_x4us		    ; Delay given in chunks of 4 microsecond in W
	movwf	Delay_cnt_l   ; now need to multiply by 16
	swapf   Delay_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	Delay_cnt_l,W ; move low nibble to W
	movwf	Delay_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	Delay_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	Delay
	return

Delay			; Delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lp1	decf 	Delay_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	Delay_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	lp1		; carry, then loop again
	return			; carry reset so return
	
    end