	mov	81H,#30H	; Initialize stack pointer

	mov	A,#3CH		
	lcall COMMAND

	mov	A,#0EH		; Command for setting display cursor on
	lcall COMMAND

	mov	A,#01H		; Command for clearing display
	lcall COMMAND

	mov	A,#06H		; Shift cursor right
	lcall COMMAND

	mov	A,#0CH		; Cursor line 2, positiion 0
	lcall COMMAND

	mov	A,#'H'		; Display letter H
	lcall DISPLAY

	mov	A,#'E'		; Display letter E
	lcall DISPLAY
	
	mov	A,#'L'		; Display letter L
	lcall DISPLAY
	
	mov	A,#'L'		; Display letter L
	lcall DISPLAY
	
	mov	A,#'O'		; Display letter O
	lcall DISPLAY


HERE:				; Command routine
	sjmp HERE
	
COMMAND:
	lcall READY	; Check if LCD is ready
	mov	P1,A	; Issue command code
	clr	P3.2	; Make RS=0 to issue command
	clr	P3.3	; Make R/W=0 to enable writing
	setb P3.4	; Make E=1
	clr	P3.4	; Make E=0
	ret	

DISPLAY:		; Display routine
	lcall READY	; Check if LCD is ready
	mov	P1,A	; Give data
	setb P3.2	; RS=1 TO get data
	clr	P3.3	; Make R/W=0 to enable writing
	setb P3.4	; Make E=1
	clr	P3.4	; Make E=0
	ret

READY:				; Ready routine
	clr	P3.4		; Disable display
	clr	P3.2		; RS = 0 in order to access command register
	mov	P1,#0FFH	; Configure P1 as input port
	setb P3.3		; R/W=1 to enable writing
	L1:
		setb P3.4 	; Make E=1
		jb	P1.7,L1	; Check D7 bit. If 1,LCD is busy wait till it becomes 0
		clr	P3.4	; Make E=0 to disable display
		ret
end