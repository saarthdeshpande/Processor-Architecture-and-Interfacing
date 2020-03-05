mov r0,#40h	; starting location
mov r1,#6h	; value of 6h can be changed as per number of elements to add
mov r4,#0h	; to store lower byte
mov r3,#0h	; to store carry - higher byte

addition:
	mov a,@r0
	add a,r4
	mov r4,a 
	jnc nocarry
	inc r3
	inc r0
	djnz r1,addition

jmp end_

nocarry:
	inc r0
	djnz r1,addition

end_:
	END
