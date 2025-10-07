#include "all_your_base.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ERROR_VALUE 0

static bool all_zeroes(int8_t* digits, size_t digits_length) {
	for (size_t i = 0; i < digits_length; i++)
		if (digits[i] != 0)
			return false;
	return true;
}

static size_t to_digits(int num, int from_base, int8_t* output_digits) {
	size_t digits_length = 0;
	for (int acc = num; acc != 0; acc /= from_base)
		output_digits[digits_length++] = acc % from_base;
	return digits_length;
}

static int from_digits(int8_t* digits, size_t digits_length, int from_base) {
	int res = 0;
	for (size_t i = 0; i < digits_length; i++)
		res = res*from_base + digits[i];
	return res;
}

static void reverse(int8_t* array, size_t length) {
	for (size_t i = 0; i < (length / 2); i++) {
		int8_t tmp = array[i];
		array[i] = array[length-i-1];
		array[length-i-1] = tmp;
	}
}

size_t rebase(int8_t* digits, int input_base, int output_base, int input_length) {
	if (input_base <= 1 || output_base <= 1)
		return ERROR_VALUE;
	if (input_length == 0)
		return 0;
	if (all_zeroes(digits, input_length)) {
		digits[0] = 0;
		return 1;
	}
	for (size_t i = 0; i < (size_t)input_length; i++) {
		int8_t d = digits[i];
		if (d >= input_base || d < 0)
			return ERROR_VALUE;
	}
	int num = from_digits(digits, input_length, input_base);
	size_t len = to_digits(num, output_base, digits);
	reverse(digits, len);
	return len;
}
