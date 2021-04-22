; прямоугольная цифровая матрица. Заменить строку с наибольшей суммой элементов последней строкой матрицы
stk segment stack 'stack'
	db 100 dup (0)
stk ends

vars segment public 'data'
	input_rows db 'Input the count of rows: $'
	input_cols db 'Input the count of columns: $'
	input_members db 'Input members of the matrix:', 0ah, '$'
	matrix db 9 * 9 dup (0) ; матрица 9 на 9
	rows db 0 ; кол-во строк
	cols db 0 ; кол-во столбцов
vars ends

code segment public 'code'
	assume ds:vars, ss:stk

	print_lf proc
		mov ah, 2
		mov dl, 0ah ; перевод строки
		int 21h
		ret
	print_lf endp

	input proc
		mov ah, 9 ; вывод строки в stdout
		mov dx, offset input_rows
		int 21h
		mov ah, 1 ; считать символ с эхом
		int 21h
		sub al, '0'
		mov rows, al

		call print_lf

		mov ah, 9 ; вывод строки в stdout
		mov dx, offset input_cols
		int 21h
		mov ah, 1 ; считать символ с эхом
		int 21h
		sub al, '0'
		mov cols, al

		call print_lf

		mov ah, 9 ; вывод строки в stdout
		mov dx, offset input_members
		int 21h

		mov al, rows
		mul cols
		mov cx, ax
		xor si, si
		fill_matrix:
			mov ah, 1
			int 21h
			sub al, '0'
			mov matrix[si], al

			call print_lf

			inc si
			loop fill_matrix
		ret
	input endp

	output proc
		mov ah, 2
		mov dl, ' '
		int 21h

		mov al, rows
		mul cols
		mov cx, ax
		xor si, si
		cycle:
			mov ah, 2
			mov dl, matrix[si]
			add dl, '0'
			int 21h
			; печать матрицы построчно: если (индекс элемента + 1) делится без остатка на кол-во столбцов, то выполняется перевод строки, иначе печатается пробел
			mov ax, si
			inc ax
			div cols
			mov al, ah
			xor ah, ah

			cmp ax, 0
			jne print_space
			call print_lf
			print_space:
				mov ah, 2
				mov dl, ' '
				int 21h

			inc si
			loop cycle
		ret
	output endp

	find_max proc
		push bp
		mov bp, sp
		sub sp, 4 ; будет 4 локальных переменных
		; вместо
		; maxsum db 0 ; наибольшая сумма
		; tempsum db 0 ; сумма элементов в строке
		; maxindex db 0 ; номер строки с наиб. суммой элементов
		; tempindex db 0 ; номер текущей строки
		xor al, al
		mov [bp - 1], al ; maxsum
		mov [bp - 2], al ; tempsum
		mov [bp - 3], al ; maxindex
		mov [bp - 4], al ; tempindex

		mov cl, rows
		xor ch, ch 
		xor si, si ; индекс i
		stroki:
			mov dx, cx ; запоминаем счётчик внешнего цикла
			mov cl, cols ; счётчик внутреннего цикла
			xor ch, ch 
			xor bx, bx ; индекс j
		po_stroke:
			mov al, matrix[si][bx] ; временно
			add [bp - 2], al ; сумма элементов строки
			inc bx
			loopne po_stroke
			je end_row
		end_row:
			mov ax, si ; индекс строки с макс. суммой
			mov [bp - 4], al
			mov al, [bp - 2] ; временно
			cmp al, [bp - 1]

			jbe not_new_maxsum ; если сумма эл-ов в строке больше максимальной, то задаю новую макс. сумму
			mov al, [bp - 2]
			mov [bp - 1], al
			mov al, [bp - 4]
			mov [bp - 3], al
			not_new_maxsum:
				xor al, al
				mov [bp - 2], al
				mov [bp - 4], al
			mov cl, cols
			xor ch, ch
			add si, cx ; в si адрес начала каждой строки (длина строки = cols)
			mov cx, dx
			loop stroki

		mov cl, cols
		xor ch, ch
		mov bl, [bp - 3]
		xor bh, bh
		mov al, cols
		xor ah, ah
		mul rows
		mov dl, cols
		sub al, dl
		mov si, ax

		change_row:
			mov al, matrix[si]
			mov matrix[bx], al
			inc si
			inc bx
			loop change_row

		mov sp, bp
		pop bp
		ret 4
	find_max endp

	main:
		mov ax, vars
		mov ds, ax

		call input
		call print_lf
		call output
		call find_max
		call print_lf
		call output

		mov ah, 4ch
		int 21h
code ends
end main