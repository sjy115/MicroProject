    #include p18f87k22.inc
    
    global Keypad_Setup, Keypad_getKey, Keypad_fail_flag
    extern LCD_delay_ms

acs0    udata_acs   ; reserve data space in access ram
row_select	res 1
Keypad_fail_flag res 1
	

	
Keypad  code
	
Keypad_Setup
	banksel	PADCFG1
	bsf	PADCFG1,REPU,BANKED
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	bra	Keypad_reset
	
table	db  "C", "D", "E", "F", "B", "9", "6", "3", "0", "8", "5", "2", "A", "7", "4", "1"
	
Keypad_reset
	movlw upper(table) ; address of data in PM
	movwf TBLPTRU ; load upper bits to TBLPTRU
	movlw high(table) ; address of data in PM
	movwf TBLPTRH ; load high byte to TBLPTRH
	movlw low(table) ; address of data in PM
	movwf TBLPTRL ; load low byte to TBLPTRL
	movlw	0x0
	movwf	row_select
	return

Keypad_getKey
get_row
	clrf	LATE
	movlw	0x0F
	movwf	TRISE
	movlw	.100
	call	LCD_delay_ms
row0
	movlw	b'1110'
	cpfseq	PORTE
	bra	row1
	movlw	.1
	movwf	row_select
	bra	get_column
row1	movlw	b'1101'
	cpfseq	PORTE
	bra	row2
	movlw	.2
	movwf	row_select
	bra	get_column
row2	movlw	b'1011'
	cpfseq	PORTE
	bra	row3
	movlw	.3
	movwf	row_select
	bra	get_column
row3	movlw	b'0111'
	cpfseq	PORTE
	bra	key_fail
	movlw	.4
	movwf	row_select
	bra	get_column
get_column
	clrf	LATE
	movlw	0xF0
	movwf	TRISE
	movlw	.100
	call	LCD_delay_ms
column0	movlw	b'11100000'
	cpfseq	PORTE
	bra	column1
	movlw	.0
	addwf	row_select
	bra	decoder
column1	movlw	b'11010000'
	cpfseq	PORTE
	bra	column2
	movlw	.4
	addwf	row_select
	bra	decoder
column2	movlw	b'10110000'
	cpfseq	PORTE
	bra	column3
	movlw	.8
	addwf	row_select
	bra	decoder
column3	movlw	b'01110000'
	cpfseq	PORTE
	bra	key_fail
	movlw	.12
	addwf	row_select
	
decoder	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	decfsz	row_select	; count down to zero
	bra	decoder		; keep going until finished
	movlw	.1
	movwf	Keypad_fail_flag
	movf	TABLAT, W
	return
key_fail
	movlw	.0
	movwf	Keypad_fail_flag
	return
	
	end