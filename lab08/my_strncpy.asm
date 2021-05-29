; Соглашение о вызовах для 64-разрядных Окон
section .text

global my_strncpy

my_strncpy:
	; dest - rcx, src - rdx, size - r8
	mov rdi, rcx
	mov rsi, rdx
	mov rcx, r8

	cmp rsi, rdi

	je quit
	jg simple_copy ; копирование не с конца

	std
	add rsi, rcx
	add rdi, rcx
	simple_copy:
		rep movsb

	quit:
		ret