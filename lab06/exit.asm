public exit

code segment public 'code'
	exit proc near
		mov ah, 4ch
		int 21h
	exit endp
code ends
end