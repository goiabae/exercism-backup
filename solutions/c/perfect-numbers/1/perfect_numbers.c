#include "perfect_numbers.h"

static int aliquot_sum(int n) {
	int sum = 0;
	for (int fac = 1; fac < n; fac++)
		sum += !(n % fac) * fac;
	return sum;
}

kind classify_number(int n) {
	if (n <= 0) return ERROR;
	int sum = aliquot_sum(n);
	if (sum < n) return DEFICIENT_NUMBER;
	if (sum == n) return PERFECT_NUMBER;
	if (sum > n) return ABUNDANT_NUMBER;
	return ERROR;
}
