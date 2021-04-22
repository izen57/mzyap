SD1 SEGMENT para common 'DATA' ; общий сегмент данных (сегменты будут “наложены” друг на друга по одним и тем же адресам памяти), выравнивание - 16 байтов
	C1 LABEL byte 
	ORG 1h 
	C2 LABEL byte
SD1 ENDS

CSEG SEGMENT para 'CODE' ; приватный (по умолчанию) сегмент кода
	ASSUME CS:CSEG, DS:SD1 ; привязка регистров
main:
	mov ax, SD1
	mov ds, ax ; передача в регистр данных адреса соотв. сегмента
	mov ah, 2 ; вывод символа в поток вывода
	mov dl, C1
	int 21h
	mov dl, C2
	int 21h
	mov ax, 4c00h ; завершение программы
	int 21h
CSEG ENDS
END main