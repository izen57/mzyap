extrn signed_number: word
extrn signed_dec_number: byte
public inp

code segment public 'code'
	inp proc near
		xor bx, bx
		mov ah, 1 ; ввод символа
		int 21h
		cmp al, '-'
		jne pos_num ; если не минус, т. е. число положительное
		mov dl, 1 ; флаг минуса

		in_symbol:
			mov ah, 1
			int 21h

			pos_num:
				cmp al, 0dh ; если введён возврат каретки, то ввод завершается
				je end_of_inp
				mov cl, al
				cmp cl, 40h ; если введено число больше 9, то корректирую
				jbe not_hex
				sub cl, 7
				not_hex:
					sub cl, '0'

				sal bx, 1 ; арифметический сдвиг влево
				sal bx, 1 ; эквивалентно
				sal bx, 1 ; умножению
				sal bx, 1 ; на 2^4 (16)
				xor ch, ch
				add bx, cx ; складываю разряды
				jmp in_symbol
		end_of_inp:
			cmp dl, 1
			jne put_num
			neg bx

		put_num:
			mov signed_number, bx
		ret
	inp endp
code ends
end