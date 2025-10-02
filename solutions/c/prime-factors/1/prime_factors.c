#include "prime_factors.h"

size_t find_factors(uint64_t n, uint64_t factors[static MAXFACTORS]) {
	int factor_count = 0;
	while (n > 1) {
		for (uint64_t i = 2; i < (n+1); i++) {
			if (n % i == 0) {
				factors[factor_count++] = i;
				n /= i;
				break;
			}
		}
	}
	return factor_count;
}

/* namespace prime_factors { */

/* std::vector<long long> of(long long value) { */
/* 	std::vector<long long> ps {}; */
/* 	while (value > 1) { */
/* 		for (auto i = 2; i < (value+1); i++) { */
/* 			if (value % i == 0) { */
/* 				ps.push_back(i); */
/* 				value /= i; */
/* 				break; */
/* 			} */
/* 		} */
/* 	} */
/* 	return ps; */
/* } */

/* }  // namespace prime_factors */
