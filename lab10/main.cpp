#include <chrono>
#include <iostream>

struct vector
{
	float x;
	float y;
	float z;
	float w;
};

float cpp_multiplication(vector *v1, vector *v2)
{
	return v1->x * v2->x + v1->y * v2->y + v1->z * v2->z + v1->w * v2->w;
}

void asm_multiplication(vector *v1, vector *v2)
{
	float result = 0;
	asm
	(
		"movups (%%rsi), %%xmm0\n"
		"mulps (%%rdi), %%xmm0\n"
		"haddps %%xmm0, %%xmm0\n"
		"haddps %%xmm0, %%xmm0\n"
		:"=Yz"(result)
		:"S"(v1), "D"(v2)
	);
}

int main(void)
{
	vector v1{0, 2, -84, 9.2}, v2{-3, 632, 782, -0.02};

	auto begin = std::chrono::steady_clock::now();
	float result = cpp_multiplication(&v1, &v2);
	auto end = std::chrono::steady_clock::now();
	long int time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();

	std::cout << result << std::endl;
	std::cout << "Время, затраченное на скалярное произведение в C++: " << time << " наносекунд" << std::endl;

	begin = std::chrono::steady_clock::now();
	asm_multiplication(&v1, &v2);
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();

	std::cout << "Время, затраченное на скалярное произведение ассемблерной вставкой: " << time << " наносекунд" << std::endl;
}