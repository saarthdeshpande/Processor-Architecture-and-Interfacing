mov TMOD,#20H	; Timer 1 Mode 2
mov TH1, #-3	; 9600 Baud Rate
mov SCON, #50H	; Mode 1, variable Baud Rate, REN enabled
setb TR1		; start Timer 1

next: 
	mov A,#”P”
	acall S_COMM
	mov A,#”I”
	acall S_COMM
	mov A,#”C”
	acall S_COMM
	mov A,#”T”
	acall S_COMM
	mov A,#”*”
	acall S_COMM
	sjmp next	; Infinite Loop

	; Serial Data transfer subroutine

S_COMM: 
	mov SBUF, acall	; Load SBUF
here: 
	jnb TI, here	; Wait for last bit to transfer
	clr TI 			; Ready for next byte
	ret
end