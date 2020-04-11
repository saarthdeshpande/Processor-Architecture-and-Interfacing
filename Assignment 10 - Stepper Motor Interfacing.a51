mov A, #66H

back:
	rr A
	acall DELAY
	sjmp back

DELAY:
	mov r2, #100

H1:
	mov r3, #255

H2:
	djnz r3,H2
	djnz r2, H1
	ret
end