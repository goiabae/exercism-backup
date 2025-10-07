#include "sublist.h"

#include <stdbool.h>

static bool lists_equal(int* xs, size_t xn, int* ys, size_t yn) {
	if (xn != yn) return false;
	for (size_t i = 0; i < xn; i++)
		if (xs[i] != ys[i])
			return false;
	return true;
}

comparison_result_t check_lists(int *list_to_compare, int *base_list,
                                size_t list_to_compare_element_count,
                                size_t base_list_element_count) {
	(void)list_to_compare, (void)base_list, (void)list_to_compare_element_count, (void)base_list_element_count;
	if (lists_equal(list_to_compare, list_to_compare_element_count, base_list, base_list_element_count))
		return EQUAL;

	if (list_to_compare_element_count == base_list_element_count)
		return UNEQUAL;

	if (list_to_compare_element_count < base_list_element_count) {
		for (size_t off = 0; off < (base_list_element_count - list_to_compare_element_count + 1); off++) {
			bool all_equal = true;
			for (size_t j = 0; j < list_to_compare_element_count; j++) {
				if (base_list[j+off] != list_to_compare[j]) {
					all_equal = false;
					break;
				}
			}
			if (all_equal) return SUBLIST;
		}
		return UNEQUAL;
	}

	comparison_result_t x = check_lists(base_list, list_to_compare, base_list_element_count, list_to_compare_element_count);
	return (x == SUBLIST) ? SUPERLIST :
				 (x == SUPERLIST) ? SUBLIST :
				 x;
}
