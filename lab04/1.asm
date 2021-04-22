extrn output: far
extrn X: byte

Stck segment stack 'stack'
	db 100 dup(0)
Stck ends

Code1 segment public 'code'
	assume cs:Code1, ss:Stck

	main:
		mov ah, 1
		int 21h
		mov X, al

		mov dl, ' '
		mov ah, 2
		int 21h

		call output

		mov ah, 4ch
		int 21h
Code1 ends
end main