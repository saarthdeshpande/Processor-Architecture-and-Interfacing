org 0000H
mov R1,#05		; Counter
mov R0,#30H		; Source
mov DPTR,#2000H 	; Destination
back:
	mov A,@R0
	movx @DPTR,A		; A -> external destination
	inc R0			; increment source 
	inc DPTR		; increment destination 
	djnz R1,back
end