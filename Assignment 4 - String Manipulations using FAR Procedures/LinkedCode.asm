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
	
	
	inputstring1 db 10,13,"Enter String 1: ","$"
	inputstring2 db 10,13,"Enter String 2: ","$"
	inputpara db 10,13,"Enter Paragraph (Ctrl+Z to Stop): $"
	
	resultstring db 10,13,"Resultant String: ","$"
	
	truecmp db 10,13,"Two Strings are Same!$"
	falsecmp db 10,13,"Two Strings are NOT Same!$"
	
	falsesub db 10,13,"String 2 is NOT a substring of String 1!$"
	truesub db 10,13,"String 2 is a substring of String 1!$"
	n_occurrences db 10,13,"No. of Occurrences: $"
	
	lowercaseoutput db 10,13,"Lower-Case Characters: $"
	uppercaseoutput db 10,13,"Upper-Case Characters: $"
	numericoutput db 10,13,"Numeric Characters: $"
	newlineoutput db 10,13,"New Lines: $"
	wordsoutput db 10,13,"No. of Words: $"
	specialoutput db 10,13,"Special Characters: $"
	
.code
	extrn string1: byte
	extrn string2: byte
	extrn para: byte
	extrn count: byte
	extrn numeric: byte
	extrn lowercase: byte
	extrn uppercase: byte
	extrn newline: byte
	extrn words: byte
	extrn special: byte
	public concatenate
	public compare
	public substring
	public diversity
	
	concatenate proc
	
		print inputstring1
		input string1
		
		lea di,string1+1
		mov cl,byte ptr [di]
		mov ch,0
		add di,cx
		inc di
		
		print inputstring2
		input string2
		
		lea si,string2+1
		mov cl,byte ptr[si]
		mov ch,0
		inc si
		
		rep movsb
		
		mov byte ptr[di],"$"
		
		print resultstring
		print string1+2
		
		ret
		endp
		
	compare proc
		
		print inputstring1
		input string1
		lea di,string1+1
		mov cl,byte ptr [di]
		mov ch,0
		inc di
		
		print inputstring2
		input string2
		lea si,string2+1
		inc si
		
		repe cmpsb
		
		cmp cx,0
		je true
		
		print falsecmp
		ret
		
		true:
			print truecmp		
		
		ret
		endp
		
	substring proc
		
		print inputstring1
		input string1
		lea si,string1+1
		mov cl,[si]
		inc si
		
		print inputstring2
		input string2
		lea di,string2+1				
		mov ch,[di]
		inc di
		mov dh,ch
		
		mov [count],0
		
		loop1:    
			mov al,[si]
			mov bp,si       ;backup of si pointer
			cmp al,[di]
			je loop2
			inc si
			
			dec cl          ;counter for main string
			jnz loop1

			mov dl,[count]
			cmp dl,0        ;dl = 0 implies no string found
			je fail
			jmp result

		loop2:   
			dec ch          ;counter for sub-string
			cmp ch,0
			je success
			inc si
			inc di
			mov al,[si]
			cmp al,[di]
			je loop2        ;continue this loop till string are same
			
			jmp loop1       ;inc case of mismatch, start again

		success: 
			add [count],01
			lea di,string2
			add di,2        ;move di to string place
			inc bp
			mov si,bp       ;restore si from bp
			dec cl
			mov ch,dh       ;restore ch from dh
			
			jmp loop1       ;start again till main string ends
			
		fail:
			print falsesub
			ret             ;return from procedure 

		result: 
			print truesub
			print n_occurrences
		       
			mov dl,[count]  
			add dl,30h              
			mov ah,02h      ;display dl contents
			int 21h         
		ret             
		endp 
		
	diversity proc
		
		print inputpara
		
		lea si,para
		
		mov [count],0
		mov [numeric],0
		mov [words],0
		mov [newline],0
		mov [uppercase],0
		mov [lowercase],0
		mov [special],0
		
		charinput:   
			mov ah,01	; take one char at a time
			int 21h
			add [count],1
			cmp al,0dh	; compare it with carriage return char
			jne ctrlZ
			add [newline],01
			add [words],01		
			mov al,0ah	; replace it with new line char

		ctrlZ:   
			mov [si],al
			inc si
			cmp al,1ah	; check whether "ctrl+z" is pressed to terminate the input 
			jne charinput
			dec si
			mov byte ptr[si],'$'
		sub [count],1
		mov cl,[count]
		mov ch,0
		
		lea si,para
		
		chartype:
			mov al,[si]
			cmp al,20h
			je spacetype
			numerictype:
				cmp al,39h
				ja uppercasetype
				cmp al,30h
				jb specialtype
				add [numeric],01
				jmp loop_t				
			uppercasetype:
				cmp al,40h	; > 'A'
				jbe specialtype
				cmp al,5ah	; < 'Z'
				ja lowercasetype
				add [uppercase],01
				jmp loop_t			
			lowercasetype:
				cmp al,61h
				jb specialtype
				cmp al,7ah
				ja specialtype
				add [lowercase],01
				jmp loop_t				
			specialtype:
				cmp al,20h
				je loop_t
				cmp al,0ah
				je loop_t
				add [special],01
				jmp loop_t
			spacetype:
				add [words],01
				jmp loop_t
			loop_t:	
				inc si
				loop chartype
			
		end_:	
			sub [special],1
			print lowercaseoutput
			mov dl,[lowercase]  
			add dl,30h              
			mov ah,02h      ;display dl contents
			int 21h  
			
			print uppercaseoutput
			mov dl,[uppercase]  
			add dl,30h              
			mov ah,02h      ;display dl contents
			int 21h
			
			print numericoutput
			mov dl,[numeric]  
			add dl,30h              
			mov ah,02h      ;display dl contents
			int 21h
			
			print newlineoutput
			mov dl,[newline]  
			add dl,30h              
			mov ah,02h      ;display dl contents
			int 21h
			
			print wordsoutput
			mov dl,[words]  
			add dl,30h              
			mov ah,02h      ;display dl contents
			int 21h
			
			print specialoutput
			mov dl,[special]  
			add dl,30h              
			mov ah,02h      ;display dl contents
			int 21h
		
		ret
		endp
	end

