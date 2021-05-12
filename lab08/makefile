run: main.exe
	./$<

main.exe: main.cpp my_strncpy.asm
	nasm -f elf64 my_strncpy.asm -o my_strncpy.o
	g++ -c -masm=intel -ggdb -g $< -o main.o
	g++ -o $@ main.o my_strncpy.o

clean:
	rm -f *.exe *.o