#include "sublist.h"

#include <stdbool.h>

static bool lists_equal(int* xs, size_t xn, int* ys, size_t yn) {
	if (xn != yn) return false;
	for (size_t i = 0; i < xn; i++)
		if (xs[i] != ys[i])
			return false;
	return true;
}

comparison_result_t check_lists(int *xs, int *ys, size_t xn, size_t yn) {
	if (lists_equal(xs, xn, ys, yn))
		return EQUAL;

	if (xn == yn)
		return UNEQUAL;

	if (xn < yn) {
		for (size_t off = 0; off < (yn - xn + 1); off++)
			if (lists_equal(xs, xn, &ys[off], xn))
				return SUBLIST;
		return UNEQUAL;
	}

	comparison_result_t x = check_lists(ys, xs, yn, xn);
	return (x == SUBLIST) ? SUPERLIST
		: (x == SUPERLIST) ? SUBLIST
		: x;
}
