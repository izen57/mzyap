extrn signed_number: word
extrn unsigned_bin_number: byte
public shex_to_ubin

code segment public 'code'
	shex_to_ubin proc near
		mov ax, signed_number
		cmp dl, 1
		mov si, 16 ; для записи в переменную
		jne pos
		; neg ax
		pos:
			dec si
			mov dx, ax ; готовлю буфер
			and dx, 1 ; получаю последний бит числа
			mov unsigned_bin_number[si], dl ; записываю в переменную
			shr ax, 1 ; сдвигаю число вправо на один бит
			cmp ax, 0 ; если число равно нулю, то выхожу из цикла
			jne pos

		mov cx, 16
		xor si, si
		mov ah, 2
		print:
			mov dl, unsigned_bin_number[si]
			add dl, 30h
			int 21h
			inc si
			loop print
		ret
	shex_to_ubin endp
code ends
end