#include "etl.h"

#include "etl.h"
#include "stdlib.h"
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static int tolower(int c) {
	if ('A' <= c && c <= 'Z') return c - 'A' + 'a';
	return c;
}

static bool contains(new_map* map, int key) {
	for (int i = 0; i < 100; i++)
		if (map->key == key) return true;
	return false;
}

static int cmp (void const *a_, void const *b_) {
	new_map const* a = a_;
	new_map const* b = b_;
	if (a->key < b->key) return -1;
	if (a->key > b->key) return 1;
	return 0;
}

int convert(const legacy_map *input, const size_t input_len, new_map **output) {
	*output = malloc(sizeof(new_map) * 100);
	int sz = 0;
	for (size_t i = 0; i < input_len; i++) {
		int k = input[i].value;
		for (char const *vs = input[i].keys; *vs != 0x0; vs++) {
			int newkey = tolower(*vs);
			if (!contains(*output, newkey)) {
				(*output)[sz++] = (new_map) {
					.key = newkey,
					.value = k,
				};
			}
		}
	}
	qsort(*output, sz, sizeof(new_map), cmp);
	return sz;
}
