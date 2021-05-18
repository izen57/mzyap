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
		mov ah, 2 ; вывожу минус
		int 21h
		neg signed_number ; перевожу число в доп. код

		calc:
			mov ax, signed_number
			xor dl, dl
			mov si, 4 ; максимум 5 цифр
			get_dec:
				xor dx, dx
				div osn ; делю число в ax на основание с. с. (10)
				mov signed_dec_number[si], dl ; записываю в память последнюю цифру
				dec si
				cmp ax, 0 ; цикл длится пока ax не равен нулю
				jne get_dec

		; вывод десятичного числа
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