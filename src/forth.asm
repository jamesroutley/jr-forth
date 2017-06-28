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
extern		wordC
extern          findC

; adds a word's headers to the dictionary
; param: link_address, immediate_flag, name
%macro  header  4
        align 16, db 0
%1:
        dd      %2           ; Add address of previous entry
        db      %3           ; Add immediate_flag
        db      %4,0         ; Add null-terminated string literal
        align 16, db 0
%endmacro

main:
	mov	ebp, retstk	; esb contains return stack pointer,
				; points to the top of the return stack
	push 	0
	jmp	word_f


; dictionary:
dict:

        header bye_hd, 0, 0, 'BYE'
bye:
	mov	ebx, 0
	mov	eax, 1
	int	0x80

        header dot_hd, bye_hd, 0, '.'
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
        jmp     bye
	jmp	next

        header dup_hd, dot_hd, 0, 'DUP'
dup:
	pop	eax
	push 	eax
	push 	eax
	jmp	next

        header doliteral_hd, dot_hd, 0, 'DOLITERAL'
doliteral:
	push	dword [esi]
	add	esi, 4
	jmp	next

        header over_hd, doliteral_hd, 0, 'OVER'
over:
	; TODO: This could be done without popping - just read 'a' off the stack
	; and push it.
	pop	ebx
	pop	eax
	push	eax
	push	ebx
	push	eax
	jmp	next

        header rot_hd, over_hd, 0, 'ROT'
rot:
	pop	ecx
	pop	ebx
	pop	eax
	push	ebx
	push	ecx
	push	eax
	jmp	next

        header star_hd, rot_hd, 0, '*'
star:
	pop	eax
	pop	ebx
	imul	eax, ebx
	push	eax
	jmp	next

        header squared_hd, star_hd, 0, 'SQUARED'
squared:
	call	enter
	dd 	dup, star, exit

        header swap_hd, squared_hd, 0, 'SWAP'
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
        jmp     word_f

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

find:   ; ( str -- xt|str 0|-1 )
        ; Name of entry to find is already on stack
        push    dword [latest]  ; Push pointer to latest entry in dict to stack
        push    xt              ; xt will store location of code to execute
        call    findC
        add     esp, 12
        push    dword [xt]
        push    eax             ; push found flag to stack
        ; jmp     dot
        ; jmp     bye

next:
	mov	eax, esi	; Store current program counter value
	add	esi, 4		; Increment program counter
	jmp	[eax]		; Jump to current program counter value

quit:
        mov     ebp, retstk     ; Empty return stack
        jmp     accept

word_f:
                                ; Push necessary args to stack
	pop	eax		; Delimiter. If 0, delimit on whitespace
        push 	eax             ; Push delimiter
        push    cur_word        ; Push cur_word
        push    cur_input       ; push cur_input
	push 	input           ; push input

	call	wordC		; Call out to a C function which will read the
				; current word into cur_word
	add	esp, 16         ; Remove args from stack
	push	cur_word	; Push cur_word to stack
	jmp	find


section 	.data

retstk		times 16 dd 0
; input		times inputlen db 0
input		db ' bye DUP SQUARED .',0  ; Used for testing
fmt		db `%p\n`
cur_input	dd input
cur_word	times 16 db 0
latest          dd swap_hd
xt              dd 0
