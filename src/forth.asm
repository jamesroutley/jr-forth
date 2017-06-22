section		.text
global		main	
extern		printf

main:
	mov		esi, instr
	jmp		next

; Built in words:
bye:
	mov		ebx, 0
	mov		eax, 1
	int		0x80

dot:
	; printf requires two parameters be pushed to the stack.
	; - push value to print
	; - push format string
	; - call printf
	; The value to print is already at the top of the stack, so we can omit
	; - push value to print
	push	dword fmt
	call	printf
	add		esp, 8
	jmp		next

dup:
	pop		eax
	push 	eax
	push 	eax
	jmp		next

doliteral:
	push	dword [esi]
	add		esi, 4
	jmp		next

over:
	; TODO: This could be done without popping - just read 'a' off the stack
	; and push it.
	pop		eax
	pop		ebx
	push	eax
	push	ebx
	push	eax

star:
	pop		eax
	pop		ebx
	imul	eax, ebx
	push	eax
	jmp		next

squared:
	call	enter
	dd 		dup, star, exit

swap:
	pop		eax
	pop		ebx
	push	eax
	push	ebx
	jmp		next

; Forth language
enter:
	; Push esi to retstk
	mov		eax, retstkptr
	mov		[eax], esi
	add		dword [retstkptr], 4
	pop		eax
	mov		esi, eax
	jmp		next

exit:
	; Pop esi from retstk
	sub		dword [retstkptr], 4
	mov		esi, [retstkptr]
	jmp		next

next:
	mov		eax, esi
	add		esi, 4
	jmp		[eax]

section 	.data

retstk		times 16 dd 0
retstkptr	dd retstk
instr		dd doliteral, 5, doliteral, 7, swap, dot, dot, bye
fmt			db	`%d\n`
