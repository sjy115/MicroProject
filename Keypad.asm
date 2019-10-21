    #include p18f87k22.inc
    
    
	constant    Keypad_cnt_ms
Keypad code
    
Keypad_Setup
	bsf	PADCFG1,REPU,banked
	clrf	LATE
	movlw	0x0F
	movwf	TRISF

delb	movlw	upper(0x3FFFFF)	    ; load 22-bit number into
	movwf	0x15		    ; FR 0x15
	;movlw	high(0x3FFFFF)	    ;
	movlw	0xFF	    ;
	movwf	0x16		    ; and FR 0x16
	movlw	low(0x3FFFFF)	    ;
	movwf	0x17		    ; and FR 0x17
	
	movlw	0x00		    ; W=0
dloop	decf	0x17, f		    ; no carry when 0x00 -> 0xff
	subwfb	0x16, f		    ; "
	subwfb	0x15, f		    ; "
	bc	dloop		    ; if carry, then loop again
	return	