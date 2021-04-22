extrn signed_number: word
extrn signed_dec_number: byte
extrn osn: word
public shex_to_sdec

code segment public 'code'
	shex_to_sdec proc near
		mov bx, 32768
		cmp bx, signed_number
		jns calc ; проверка на знак
		mov dl, '-'
		mov ah, 2
		int 21h
		neg signed_number

		calc:
			mov ax, signed_number
			xor dl, dl
			mov si, 4
			get_dec:
				xor dx, dx
				div osn
				mov signed_dec_number[si], dl
				dec si
				cmp ax, 0
				jne get_dec

		mov cx, 5
		xor si, si
		mov ah, 2
		print:
			mov dl, signed_dec_number[si]
			add dl, 30h
			int 21h
			inc si
			loop print

		ret
	shex_to_sdec endp
code ends
end