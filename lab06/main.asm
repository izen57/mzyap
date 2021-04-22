; ввод: знаковое в 16 с. с.
; вывод: беззнаковое в 2 с. с., знаковое в 10 с. с.
extrn inp: near
extrn shex_to_ubin: near
extrn shex_to_sdec: near
extrn exit: near
public signed_number
public unsigned_bin_number
public signed_dec_number
public osn

stk segment stack 'stack'
	db 100h dup (0)
stk ends

vars segment public 'data'
	menu db 'Enter the command number:', 0ah
		db '1. Enter signed hexadecimal number', 0ah
		db '2. Display unsigned binary number', 0ah
		db '3. Display signed decimal number', 0ah
		db '0. Exit', 0ah, '$'
	modules dw exit, inp, shex_to_ubin, shex_to_sdec
	signed_number dw 0
	unsigned_bin_number db 16 dup (0)
	signed_dec_number db 5 dup (0)
	osn dw 10
vars ends

code segment public 'code'
	assume ds:vars, ss:stk, cs:code

	main:
		mov ax, vars
		mov ds, ax
		menu_loop:
			mov ah, 9
			mov dx, offset menu
			int 21h

			mov ah, 1
			int 21h
			sub al, 30h
			mov cl, 2
			mul cl
			mov si, ax

			mov ah, 2
			mov dl, 0ah
			int 21h

			call modules[si]

			mov ah, 2
			mov dl, 0ah
			int 21h
			int 21h

			jmp menu_loop

code ends
end main