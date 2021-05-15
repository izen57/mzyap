m: m.exe
	./$^

mno: mno.exe
	./$^

m.exe: main.cpp
	g++ -m80387 -masm=intel -S $^
	g++ -c -masm=intel -ggdb $^ -o m.o
	g++ -o $@ m.o

mno.exe: main.cpp
	g++ -mno-80387 -masm=intel -S $^
	g++ -masm=intel -ggdb $^ -o mno.o
	g++ -o $@ mno.o

clear:
	rm -f *.exe *.o *.s *.exe