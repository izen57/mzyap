EXTRN X: byte ; идентификатор вне модуля типа byte
PUBLIC exit ; идентификатор виден в других модулях

SD2 SEGMENT para 'DATA' ; приватный сегмент данных, выровненный на 16 байтов
	Y db 'Y' ; выделение байта под строку "Y"
SD2 ENDS

SC2 SEGMENT para public 'CODE' ; публичный сегмент кода, выровненный на 16 байтов
	assume CS:SC2, DS:SD2 ; привязка сегментов к регистрам
exit:
	mov ax, seg X
	mov es, ax ; передача в es сегментной части адреса идентификатора X
	mov bh, es:X ; передача в bh 

	mov ax, SD2
	mov ds, ax ; передача в ds сегмента с данными

	xchg ah, Y ; обмен значений: помещение в регистр ah адреса "Y"
	xchg ah, ES:X ; 
	xchg ah, Y	

	mov ah, 2 ; вывод символа
	mov dl, Y ; но вывелся всё равно "X"
	int 21h

	mov ax, 4c00h ; завершение программы
	int 21h
SC2 ENDS
END