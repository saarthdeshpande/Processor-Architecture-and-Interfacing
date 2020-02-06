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

.model small
.data
	heading db 10,13,"String Operations","$"
	inputstring db 10,10,13,"Enter String: ","$"
	response db 10,10,13,"Do you wish to continue? (1 for YES;0 for NO) ","$"
	string db 10,?,8 dup("$")
	reversestring db 10,?,8 dup("$")
	displayoutput db 10,10,13,"String: ","$"
	lengthoutput db 10,10,13,"Length = ","$"
	palindromeTrue db 10,10,13,"String is a palindrome.","$"
	palindromeFalse db 10,10,13,"String is not a palindrome.","$"
	reverseoutput db 10,10,13,"Reversed String: ","$"
	two db 2
	ten dw 10
.code
	
	mov ax,@data
	mov ds,ax
	
	stringOperations:
		print heading
		print inputstring
		input string
		
		lea si,string+1		; Start: Assign "$" to last character of string
		mov cl,[si]
		inc cl
		mov ch,0
		
		add si,cx
		mov byte ptr[si],"$"	; End
		
		call displaystring	
		call stringlength
		call reverse
		call palindrome
		
		print response
		
		mov ah,01h	; response from user
		int 21h
		sub al,30h
		
		cmp al,01
		je stringOperations
		
		exit: 
			mov ah,04ch
			int 21h
	
	displaystring proc
	
		print displayoutput
		print string+2
	
		ret
		endp
		
	palindrome proc
		
		lea si,string+1
		mov cl,[si]
		mov ch,0
		
		inc si
		
		lea di,reversestring
		
		mov ax,cx
		div two
		
		mov cx,ax
		mov ch,0
		
		checkpalindrome:
			mov dl,[si]
			cmp [di],dl
			jne false_
			inc di
			inc si
			loop checkpalindrome
			
		print palindromeTrue
		ret
		endp		
			
		false_:
			print palindromeFalse	
	
		ret
		endp
		
	stringlength proc
	
		print lengthoutput
		
		mov al,string+1
		
		mov cx,0
		mov ah,0
		
		converttodec:
			mov dx,0
			div ten
		 	push dx
	  		inc cx
			cmp ax,0
			jne converttodec
		
		mov ax,0
		
		displaydec:
			pop dx
			add dx,48
			mov ah,02h
			int 21h
			loop displaydec	
	
		ret
		endp
		
	reverse	proc
	
		lea si,string+1
		mov cl,[si]
		mov ch,0
		add si,cx
		
		lea di,reversestring
				
		reversal:
			mov dl,[si]
			mov [di],dl
			inc di
			dec si
			loop reversal
		
		mov byte ptr[di],"$"
			
		print reverseoutput
		
		print reversestring
	
		ret
		endp	
	        
    	end
