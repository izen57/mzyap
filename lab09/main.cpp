#include <iostream>
#include <chrono>
#include <cmath>

void float_summ()
{
	float a = 123.456, b = 654.321, c = 0;
	asm
	(
		".intel_syntax noprefix\n"
		"movq rcx, 1000000\n"
		"fsrepeat:\n"
			"movss xmm0, [rbp - 12]\n"
			"movss xmm1, [rbp - 8]\n"
			"addss xmm0, xmm1\n"
			"addss xmm0, xmm0\n"
			"movss [rbp - 4], xmm0\n"
			"loop fsrepeat\n"
	);
}

void float_mult()
{
	float a = 123.456, b = 654.321, c = 0;
	asm
	(
		".intel_syntax noprefix\n"
		"movq rcx, 1000000\n"
		"fmrepeat:\n"
			"movss xmm0, [rbp - 12]\n"
			"movss xmm1, [rbp - 8]\n"
			"mulss xmm0, xmm1\n"
			"mulss xmm0, xmm0\n"
			"movss [rbp - 4], xmm0\n"
			"loop fmrepeat\n"
	);
}

void long_double_summ()
{
    long double a = 123.456, b = 654.321, c = 0;
	asm
	(
		".intel_syntax noprefix\n"
		"movq rcx, 1000000\n"
		"ldsrepeat:\n"
			"fldt [rbp - 48]\n"
			"fldt [rbp -32]\n"
			"faddp\n"
			"fstpt [rbp - 16]\n"
			"loop ldsrepeat\n"
	);
}

void long_double_mult()
{
    long double a = 123.456, b = 654.321, c = 0;
	asm
	(
		".intel_syntax noprefix\n"
		"movq rcx, 10000000\n"
		"ldmrepeat:"
			"fldt [rbp - 48]\n"
			"fldt [rbp - 32]\n"
			"fmulp\n"
			"fmul st, st\n"
			"fstpt [rbp - 16]\n"
			"loop ldmrepeat\n"
	);
}

int main()
{
	double a = 12323324, b = 12323324;
	float af = 12312, bf = 12312;
	long double ald = 132314242, bld = 132314242;

	auto begin = std::chrono::steady_clock::now();
	for (int i = 0; i < 100000; ++i)
		a *= b;
	auto end = std::chrono::steady_clock::now();
	long int time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	for (int i = 0; i < 100000; ++i)
		a += b;
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	for (int i = 0; i < 100000; ++i)
		af *= bf;
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	for (int i = 0; i < 100000; ++i)
		af += bf;
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	for (int i = 0; i < 100000; ++i)
		ald *= bld;
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	for (int i = 0; i < 100000; ++i)
		ald += bld;
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	float_summ();
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	float_mult();
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	long_double_summ();
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	begin = std::chrono::steady_clock::now();
	long_double_mult();
	end = std::chrono::steady_clock::now();
	time = (std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin)).count();
	std::cout << "The time: " << time << std::endl;

	std::cout << "sin(pi): " << sin(3.14) << std::endl;
	std::cout << "sin(pi): " << sin(3.141596) << std::endl;
	std::cout << "sin(pi / 2): " << sin(3.14 / 2) << std::endl;
	std::cout << "sin(pi / 2): " << sin(3.141596 / 2) << std::endl;

	long double pi = 0;
	asm
	(
		".intel_syntax noprefix\n"
		"fldpi\n"
		"fstpt [rbp - 80]\n"
	);

	std::cout << "asm sin(pi): " << sin(pi) << std::endl;
	std::cout << "asm sin(pi / 2): " << sin(pi / 2)  << std::endl;

	return 0;
}