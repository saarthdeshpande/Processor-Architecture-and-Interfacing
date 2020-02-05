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
	msg1 db 10,"1. Decimal to Hexadecimal",13,"$"
	msg2 db 10,"2. Hexadecimal to Decimal",13,"$"
	msg3 db 10,"3. Exit",13,"$"
	response db 10,"Your Choice: ","$"
	hexinput db 10,"Enter Hexadecimal Number: ","$"
	decinput db 10,"Enter Decimal Number: ","$"
	hexresult db 10,"Hexadecimal Result: ","$"
	decresult db 10,"Decimal Result: ","$"
	string db 10,?,6 dup("$")
	ten dw 10
	sixteen dw 16
	
.code

	mov ax,@data
	mov ds,ax
	
	menu:	
		print msg1
		print msg2
		print msg3
		print response
		
		mov ah,01h
		int 21h
		sub al,30h
		
		cmp al,01
		jne option2
		call dectohex
		jmp menu
				
		option2:
			cmp al,02
			jne exit
			call hextodec
			jmp menu
		
		exit: 
			mov ah,04ch
			int 21h
			
	
	dectohex proc
		print decinput
		input string
		lea si,string+1
		mov cl,[si]
		mov ch,0
		mov ax,0
		
		strtohex:
			inc si
			mov dl,[si]
			sub dl,48
		  	add al,dl
			mul ten
			loop strtohex
	        div ten
        	
        	mov ch,4
        	mov cl,4
        	mov bx,ax
        	
        	print hexresult
        	
	        displayhex:
	        	mov ax,bx
	        	rol ax,cl
        		and ax,000Fh
        		mov dl,al
        		cmp dl,9
        		ja letter	;jump if digit > 9
        		add dl,30h
        		jmp digit
        		
        		letter:
        			add dl,55
        		
        		digit:
        			mov ah,02
        			int 21h
        			rol bx,cl
        			dec ch
        			jnz displayhex  		
        			ret
			endp
        			
	hextodec proc
		print hexinput
		input string
		mov ax,0
		lea si,string+1
		mov ch,0
		mov cl,[si]
		
		strtoint:
			inc si
			mov dl,[si]
			sub dl,48
		  	add al,dl
			mul sixteen
			loop strtoint
	        div sixteen
	        
	        print decresult
	        
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
	        
	end
        
	        
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
	
