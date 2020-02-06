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
	numberinput db 10,"Number of Elements: ","$"
	arrayinput db 10,"Enter Element: ","$"
	resultoutput db 10,"Sum = ","$"
	string db 10,?,6 dup("$")
	array db 20 dup(0)
	ten dw 10
	n_elements dw 0
	n_elements_ dw 0
.code
	
	mov ax,@data
	mov ds,ax
	
	print numberinput
	
	mov ah,01h	; number of elements input
	int 21h
	sub al,30h
	
	
	mov ah,0
	mov n_elements,ax
	mov n_elements_,ax
	
	lea di,array
	
	multipleinputs:
		print arrayinput
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
	        
	        mov [di],al
	        inc di
	        
	        dec n_elements
	        jnz multipleinputs
	      
        print resultoutput
        mov ax,0
        
        lea si,array
	mov cx,n_elements_
        mov ch,0
        
	addition:
		add ax,[si]
		inc si
		loop addition
		
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
	        
    	mov ah,4ch
    	int 21h
	        
    	end
	        
		
