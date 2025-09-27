#include "rotational_cipher.h"

#include <assert.h>
#include <ctype.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define ALPHA_SIZE 26

static const char* ALPHA = "abcdefghijklmnopqrstuvwxyz";

#define Pair(T) struct { T first, second; }

typedef Pair(char) CharPair;
typedef struct { CharPair* pairs; int pair_count; } CharMap;

static char find(CharMap map, char first) {
	for (int i = 0; i < map.pair_count; i++)
		if (map.pairs[i].first == first)
			return map.pairs[i].second;
	assert(false);
}

static void insert(CharMap* map, char first, char second) {
	map->pairs[map->pair_count++] = (CharPair) { first, second };
}

char *rotate(const char *text, int shift_key) {
	CharMap conv = { malloc(sizeof(CharPair) * 26 * 2), 0 };
	for (int i = 1; i <= ALPHA_SIZE; i++) {
		int j =  ((i - 1 + shift_key) % 26) + 1;
		char from = ALPHA[i-1];
		char to = ALPHA[j-1];
		insert(&conv, from, to);
		insert(&conv, toupper(from), toupper(to));
	}
	size_t text_len = strlen(text);
	char* output = malloc(sizeof(char) * (text_len + 1));
	output[text_len] = '\0';
	for (int i = 0; i < (int)text_len; i++) {
		char c = text[i];
		output[i] = isalpha(c) ? find(conv, c) : c;
	}
	free(conv.pairs);
	return output;
}
