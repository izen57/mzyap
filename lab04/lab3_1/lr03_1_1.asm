EXTRN output_X: near ; идентификатор output_X описан в другом модуле и расположен в том же сегменте (2 байта)

STK SEGMENT PARA STACK 'STACK' ; сегмент стека STK. Выравнивание по параграфу
	db 100 dup(0) ; выделение 100 раз по байту и заполнение этой памяти нулями
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA' ; публичный сегмент данных DSEG, выровненный по параграфу
	X db 'R'; выделение 1 байта под строку
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE' ; публичный сегмент кода CSEG, выровненный по параграфу
	assume CS:CSEG, DS:DSEG, SS:STK ; привязка сегментных регистров: кода к CSEG, данных к DSEG, стека к STK
main: 
	mov ax, DSEG
	mov ds, ax ; передача регистру данных адреса соответствующего сегмента через регистр ax

	call output_X	 ; вызов процедуры (передача управления по метке с сохранением адреса возврата в стек)

	mov ax, 4c00h ; код функции: управление в программу не вернётся, память, занимаемая программой, будет очищена
	int 21h
CSEG ENDS

PUBLIC X

END main