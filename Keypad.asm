    #include p18f87k22.inc
    
    global Keypad_Setup

acs0    udata_acs   ; reserve data space in access ram
cnt_upper	res 1   ; reserve one byte for a counter variable
cnt_high	res 1
cnt_low		res 1
row_select	res 1
column_select	res 1
		
Keypad code
    
Keypad_Setup
	banksel	PADCFG1
	bsf	PADCFG1,REPU,BANKED
	return

Keypad_getKey
	movlw	.4
	movwf	cnt_row
	movlw	.4
	movwf	cnt_column
get_row
	clrf	LATE
	movlw	0x0F
	movwf	TRISE
row0
	movlw	b'1110'
	cpfseq	PORTE
	bra	row1
	movlw	.0
	movwf	row_select
	bra	get_column
row1	movlw	b'1101'
	cpfseq	PORTE
	bra	row2
	movlw	.1
	movwf	row_select
	bra	get_column
row2	movlw	b'1101'
	cpfseq	PORTE
	bra	row3
	movlw	.2
	movwf	row_select
	bra	get_column
row3	movlw	b'1101'
	cpfseq	PORTE
	bra	key_fail
	movlw	.3
	movwf	row_select
	bra	get_column
get_column
	clrf	LATE
	movlw	0xF0
	movwf	TRISE
	swapf	PORTE
column0
	movlw	b'1110'
	cpfseq	PORTE
	bra	column1
	movlw	.3
check	cpfseq	row_select
	bra	inc_check
	bra	check
	movlw	'1'
	return
inc_check
	decfsz	w
	
next	movlw	.1
	cpfseq	row_select
	bra	next
	
column1	movlw	b'1101'
	cpfseq	PORTE
	bra	column2
	movlw	.1
	movwf	column_select
	bra	key_output
column2	movlw	b'1101'
	cpfseq	PORTE
	bra	column3
	movlw	.2
	movwf	column_select
	bra	key_output
column3	movlw	b'1101'
	cpfseq	PORTE
	bra	key_fail
	movlw	.3
	movwf	column_select
key_output
	
	
	
	
key_fail	
delb	movlw	upper(0x3FFFFF)	    ; load 22-bit number into
	movwf	cnt_upper		    ; FR 0x15
	movlw	high(0x3FFFFF)	    ;
	movwf	cnt_high		    ; and FR 0x16
	movlw	low(0x3FFFFF)	    ;
	movwf	cnt_low		    ; and FR 0x17
	
	movlw	0x00		    ; W=0
dloop	decf	cnt_low, f	    ; no carry when 0x00 -> 0xff
	subwfb	cnt_high, f		    ; "
	subwfb	cnt_upper, f		    ; "
	bc	dloop		    ; if carry, then loop again
	return
	end