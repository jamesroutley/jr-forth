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
	pop		eax
	; Call printf
	push	ebp
	mov		ebp, esp

	push 	eax
	push	dword fmt
	call	printf
	add		esp, 8

	mov		esp, ebp
	pop		ebp
	mov		eax, 0
	ret
	jmp		next

dup:
	pop		eax
	push 	eax
	push 	eax
	jmp		next

five:
	push	5
	jmp		next

star:
	pop		eax
	pop		ebx
	imul	eax, ebx
	push	eax
	jmp		next

; Forth language
next:
	mov		eax, esi
	add		esi, 4
	jmp		[eax]

section 	.data

instr		dd five, dup, star, dot, bye
fmt			db	`%d\n`
