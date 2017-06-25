; Magic ints
sys_exit	equ	1
sys_read	equ	3
sys_write	equ	4
stdin		equ	0
stdout		equ	1
stderr		equ	2
inputlen	equ	128

section		.text
global		main
extern		printf

main:
	; mov	esi, instr
	; jmp	next
	jmp	accept

; Built in words:
bye:
	mov	ebx, 0
	mov	eax, 1
	int	0x80

dot:
	; printf requires two parameters be pushed to the stack.
	; - push value to print
	; - push format string
	; - call printf
	; The value to print is already at the top of the stack, so we can omit
	; - push value to print
	push	dword fmt
	call	printf
	add	esp, 8
	jmp	next

dup:
	pop	eax
	push 	eax
	push 	eax
	jmp	next

doliteral:
	push	dword [esi]
	add	esi, 4
	jmp	next

over:
	; TODO: This could be done without popping - just read 'a' off the stack
	; and push it.
	pop	ebx
	pop	eax
	push	eax
	push	ebx
	push	eax
	jmp	next

rot:
	pop	ecx
	pop	ebx
	pop	eax
	push	ebx
	push	ecx
	push	eax
	jmp	next

star:
	pop	eax
	pop	ebx
	imul	eax, ebx
	push	eax
	jmp	next

squared:
	call	enter
	dd 	dup, star, exit

swap:
	pop	eax
	pop	ebx
	push	eax
	push	ebx
	jmp	next

; Forth language

accept:
	mov	edx, inputlen
	mov	ecx, input
	mov	ebx, stdin
	mov	eax, sys_read
	int	0x80

enter:
	; Push esi to retstk
	mov	eax, retstkptr
	mov	[eax], esi
	add	dword [retstkptr], 4
	pop	eax
	mov	esi, eax
	jmp	next

exit:
	; Pop esi from retstk
	sub	dword [retstkptr], 4
	mov	esi, [retstkptr]
	jmp	next

next:
	mov	eax, esi
	add	esi, 4
	jmp	[eax]

section 	.data

retstk		times 16 dd 0
retstkptr	dd retstk
input		times inputlen db 0
instr		dd doliteral, 5, doliteral, 7, over, dot, dot, dot, bye
fmt		db `%d\n`
