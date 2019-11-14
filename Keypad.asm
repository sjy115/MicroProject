    #include p18f87k22.inc
    
    global Keypad_Setup, Keypad_getKey, Keypad_output
    extern Delay_ms

    
acs0    udata_acs   ; reserve data space in access ram
key	res 1
Keypad_output res 1
	
Keypad  code
  ; 
    db  b'1111', b'1101', b'0111', b'0101', b'1110', b'1100', b'0110', b'0100', b'1011', b'1001', b'0011', b'0001', b'1010', b'1000', b'0010', b'0000'
	
Keypad_Setup
    banksel	PADCFG1
    bsf		PADCFG1,REPU,BANKED
    bcf		EECON1, CFGS		; point to Flash program memory  
    bsf		EECON1, EEPGD		; access Flash program memory
    return
	
	
Keypad_getKey
	clrf	LATE
	movlw	0x0F
	movwf	TRISE
	movlw	.100
	call	Delay_ms
	;row0
	movlw	b'1110'
	cpfseq	PORTE
	bra	row1
	movlw	.1
	movwf	key
	bra	get_column
row1	movlw	b'1101'
	cpfseq	PORTE
	bra	row2
	movlw	.2
	movwf	key
	bra	get_column
row2	movlw	b'1011'
	cpfseq	PORTE
	bra	row3
	movlw	.3
	movwf	key
	bra	get_column
row3	movlw	b'0111'
	cpfseq	PORTE
	bra	key_fail
	movlw	.4
	movwf	key
	bra	get_column
get_column
	clrf	LATE
	movlw	0xF0
	movwf	TRISE
	movlw	.100
	call	Delay_ms
column0	movlw	b'11100000'
	cpfseq	PORTE
	bra	column1
	movlw	.0
	addwf	key
	bra	decoder
column1	movlw	b'11010000'
	cpfseq	PORTE
	bra	column2
	movlw	.4
	addwf	key
	bra	decoder
column2	movlw	b'10110000'
	cpfseq	PORTE
	bra	column3
	movlw	.8
	addwf	key
	bra	decoder
column3	movlw	b'01110000'
	cpfseq	PORTE
	bra	key_fail
	movlw	.12
	addwf	key
	
decoder	tblrd*+			 
	decfsz	key 
	bra	decoder 
	movff	TABLAT, Keypad_output
	return

key_fail
	movlw	.0
	;movwf	Keypad_fail_flag
	return
	end
	



