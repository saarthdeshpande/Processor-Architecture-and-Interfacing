.model small

print macro msg
	lea dx,msg
	mov ah,09
	int 21h
	endm

input macro msg
	lea dx,msg
	mov ah,0ah
	int 21h
	endm

.data	
	main db 10,10,13,"STRING MANIPULATIONS","$"
	option1 db 10,13,"1. Concatenate Two Strings.","$"
	option2 db 10,13,"2. Compare Two Strings","$"
	option3 db 10,13,"3. Number of Occurences of Substring in given string","$"
	option4 db 10,13,"4. Find diversity of characters","$"
	option5 db 10,13,"5. Exit","$"
	response db 10,13,"Your Choice: ","$"
	
	string1 db 20,?,18 dup("$")
	string2 db 10,?,8 dup("$")
	para db 80 dup("$")
	count db 1 dup(0)
	lowercase db 1 dup(0)
	uppercase db 1 dup(0)
	numeric db 1 dup(0)
	newline db 1 dup(0)
	words db 1 dup(0)
	special db 1 dup(0)
	
.code
	public string1, string2, para, count, lowercase, uppercase, newline, words, special, numeric
	extrn concatenate: far
	extrn compare: far
	extrn substring: far
	extrn diversity: far
	
	mov ax,@data
	mov ds,ax
	mov es,ax
	
	menu:
		print main
		print option1
		print option2
		print option3
		print option4
		print option5
		print response
		
		mov ah,01h
		int 21h
		sub al,30h
		
		cmp al,01
		jne choice2
		call concatenate
		jmp menu
		
		choice2:
			cmp al,02
			jne choice3
			call compare
			jmp menu
			
		choice3:
			cmp al,03
			jne choice4
			call substring
			jmp menu
		
		choice4:
			cmp al,04
			jne exit
			call diversity
			jmp menu
			
		exit:
			mov ah,4ch
			int 21h
			
	end
