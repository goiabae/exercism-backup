#include "luhn.h"

#include <ctype.h>
#include <stddef.h>
#include <string.h>

static bool is_valid_digit(char c) {
	return isdigit(c) || c == ' ';
}

bool luhn(const char* num) {
	size_t len = strlen(num);
	if (len <= 1) return false;
	int sum = 0;
	int count = 0;
	int i = len;
	while (i > 0) {
		i -= 1;
		if (!is_valid_digit(num[i])) return false;
		if (num[i] == ' ') continue;
		int a = (num[i] - '0') * ((count % 2 == 1) ? 2 : 1);
		sum += (a > 9) ? a - 9 : a;
		count += 1;
	}

	if (count <= 1) return false;
	return sum % 10 == 0;
}
