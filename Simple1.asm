	#include p18f87k22.inc

	extern  LCD_Setup, LCD_Write_Message, LCD_clear_display, LCD_set_position, LCD_Send_Byte_D	    ; external LCD subroutines
	extern	Keypad_Setup, Keypad_getKey, Keypad_fail_flag
	

rst	code	0    ; reset vector
	goto	setup

main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	call	LCD_Setup	; setup LCD
	call	Keypad_Setup
	goto	start
	
	; ******* Main programme ****************************************
start 	call	Keypad_getKey
	tstfsz	Keypad_fail_flag
	call	LCD_Send_Byte_D
	call	Keypad_Setup
	goto	start		; goto current line in code
	end