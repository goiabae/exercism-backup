#include "nth_prime.h"

#include <assert.h>
#include <stdbool.h>

#define BUF_SIZE 10001

uint32_t nth(uint32_t n) {
	if (n <= 0) return 0;

	assert(n <= BUF_SIZE);

	int ps[BUF_SIZE];
	int ps_count = 0;

	for (int i = 2; ps_count < (int)n; i++) {
		bool is_prime = true;
		for (int j = 0; j < ps_count; j++) {
			int p = ps[j];
			if (p*p > i) break;
			if (i % p == 0) {
				is_prime = false;
				break;
			}
		}
		if (is_prime)
			ps[ps_count++] = i;
	}
	return ps[n-1];
}
