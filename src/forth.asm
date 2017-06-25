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
	mov	ebp, retstk	; esb contains return stack pointer,
				; points to the top of the return stack
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
	mov	ebp, esi	; Move program counter value to return stack
	add	dword ebp, 4	; Increment return stack pointer
	pop	esi		; Pop location of first word in compound
				; statement into the program counter
	jmp	next		; Start executing word

exit:
	; Pop esi from retstk
	sub	dword ebp, 4	; Decrement return stack pointer
	mov	esi, ebp	; Move old program location to esi
	jmp	next		; Continue execution

next:
	mov	eax, esi	; Store current program counter value
	add	esi, 4		; Increment program counter
	jmp	[eax]		; Jump to current program counter value

section 	.data

retstk		times 16 dd 0
input		times inputlen db 0
instr		dd doliteral, 5, doliteral, 7, over, dot, dot, dot, bye
fmt		db `%d\n`
