org 0000H
mov R0,#4BH		; Source
mov R1,#30H		; Destination
mov R2,#10  	; Counter
back:
	mov A,@R0		; source -> A
	mov @R1,A		; A -> destination
	inc R0			; increment source 
	inc R1		; increment destination 
	djnz R1,back
end