#include <iostream>
extern "C" void my_strncpy(char *dest, const char *src, size_t size);

size_t get_string_lenght(const char *str)
{
	size_t result;
	asm
	(
		".intel_syntax noprefix\n"
		"xor rcx, rcx\n"
		"not rcx\n"
		"xor al, al\n"
		"mov rdi, %1\n"
		"repne scasb\n"
		"not rcx\n"
		"dec rcx\n"
		"mov %0, rcx\n"
		:"=r"(result)
		:"r"(str)
		:"rcx", "rdi", "al"
	);
	return result;
}

int main(void)
{
	char str[] = "Hello";
	std::cout <<  "String lenght: " << get_string_lenght(str) << std::endl;
	char check[] = "abcdefghijklmnopqrstuvwxyz";
	std::cout << "Test: Destination = Source + 3, copysize: 5\n";
    std::cout << "Start: " << check << std::endl;
    my_strncpy(check + 3, check, 5);
    std::cout << "Mine:  " << check << std::endl;

    std::cout << "Test 2: Source = Destination + 2, copysize: 2\n";
    std::cout << "Start: " << check << std::endl;
    my_strncpy(check, check + 2, 2);
    std::cout << "Mine:  " << check << std::endl;

	return 0;
}