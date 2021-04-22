public output

Data segment public 'data'
	X db 'A'
Data ends

Code2 segment public 'code'
	assume cs:Code2, ds:Data

	output proc far
		mov ah, 2
		mov dl, X
		sub dl, 32

		int 21h
		ret
	output endp
Code2 ends

public X
end