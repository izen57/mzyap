.model tiny
.code
.186

org 100h ; выделение памяти под префикс программного сегмента (PSP)

main:
	jmp init
	current db 0
	is_init db 1 ; флаг инициализации
	speed db 1fh ; скорость автоповтора нажатой клавиши. Изначально минимальный, т. е. 0001 1111
	; где 5 и 6 биты - 0 мс, с 0 по 4 биты - 2 символа в секунду
	old_interruption dd ?

my_interruption:
	pusha ; сохраняет в стеке содержимое восьми 16-битных регистров общего назначения
	push es
	push ds
	mov ah, 2 ; считать время из часов реального времени
	int 1ah ; доступ к системным часам

	cmp dh, current
	mov current, dh
	je end_loop
	mov al, 0f3h ; установка параметров режима автоповтора нажатой клавиши
	out 60h, al ; инструкция OUT выводит данные из регистра AL или AX в порт ввода-вывода
	mov al, speed
	out 60h, al ; передача за кодом команды вторым байтом данных

	dec speed ; увеличение скорости
	cmp speed, 1fh ; проверка на максимальную скорость
	je reset_speed ; если скорость максимальна, то происходит сброс
	jmp end_loop

	reset_speed:
		mov speed, 1fh

	end_loop:
		pop ds
		pop es
		popa
		jmp cs:old_interruption

init:
	mov ax, 3508h ; установка обработчика прерываний (ah = 35h, al = 8 (считать символ без эха))
	int 21h
	cmp es:is_init, 1
	je exit

	mov word ptr old_interruption, bx ; запись адреса старого обработчика
	mov word ptr old_interruption + 2, es

	mov ax, 2508h ; адрес собственного обработчика
	mov dx, offset my_interruption
	int 21h
	mov dx, offset init
	int 27h ; начиная с адреса init, программа будет удалена из памяти

exit: ; выполняю обратные операции: установка старого обработчика
	pusha
	push es
	push ds
	mov ax, 2508h

	mov dx, word ptr es:old_interruption
	mov ds, word ptr es:old_interruption + 2
	int 21h

	mov al, 0f3h
	out 60h, al
	xor al, al
	out 60h, al
	pop ds
	pop es
	popa

	mov ah, 49h ; освобождение блока памяти, начинающегося с адреса ES:0000
	int 21h
	mov ah, 4ch
	int 21h

end main