#include "yacht.h"

#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>

static int count(dice_t dice, int num) {
	int acc = 0;
	for (size_t i = 0; i < 5; i++)
		if (dice.faces[i] == num)
			acc++;
	return acc;
}

static int sum(dice_t dice) {
	int acc = 0;
	for (size_t i = 0; i < 5; i++)
		acc += dice.faces[i];
	return acc;
}

static int comp(const void *a, const void *b) {
	return *(int*)a - *(int*)b;
}

static bool is_little_straight(dice_t dice) {
	int sorted_faces[5];
	memcpy(sorted_faces, dice.faces, 5 * sizeof(int));
	qsort(sorted_faces, 5, sizeof(int), comp);
	for (size_t i = 0; i < 5; i++)
		if (sorted_faces[i] != (int)(i+1))
			return false;
	return true;
}

static bool is_big_straight(dice_t dice) {
	int sorted_faces[5];
	memcpy(sorted_faces, dice.faces, 5 * sizeof(int));
	qsort(sorted_faces, 5, sizeof(int), comp);
	for (size_t i = 0; i < 5; i++)
		if (sorted_faces[i] != (int)(i+2))
			return false;
	return true;
}

static bool is_yacht(dice_t dice) {
	for (size_t i = 0; i < (5-1); i++)
		if (dice.faces[i] != dice.faces[i+1])
			return false;
	return true;
}

typedef struct {
  int first;
	int second;
} IntPair;

typedef struct {
	IntPair* pairs;
	int count;
} IntMap;

static IntMap frequencies(int set[static 5]) {
	IntPair* freqs = malloc(sizeof(IntPair) * 5);
	int freq_count = 0;
	for (size_t i = 0; i < 5; i++) {
		int found = -1;
		for (size_t j = 0; j < (size_t)freq_count; j++)
			if (freqs[j].first == set[i])
				found = j;
		if (found == -1)
			freqs[freq_count++] = (IntPair) {
				.first = set[i],
				.second = 1,
			};
		else
			freqs[found].second++;
	}
	return (IntMap) {
		.pairs = freqs,
		.count = freq_count,
	};
}

static bool has_same(dice_t dice, int count) {
	IntMap counts = frequencies(dice.faces);
	for (size_t i = 0; i < (size_t)counts.count; i++)
		if (counts.pairs[i].second == count)
			return true;
	return false;
}

static bool has_same_or_bigger(dice_t dice, int count) {
	IntMap counts = frequencies(dice.faces);
	for (size_t i = 0; i < (size_t)counts.count; i++)
		if (counts.pairs[i].second >= count)
			return true;
	return false;
}

static bool is_category(dice_t dice, category_t category) {
	if (category == FULL_HOUSE)
		return has_same(dice, 2) && has_same(dice, 3);
	else if (category == FOUR_OF_A_KIND)
		return has_same_or_bigger(dice, 4);
	else if (category == LITTLE_STRAIGHT)
		return is_little_straight(dice);
	else if (category == BIG_STRAIGHT)
		return is_big_straight(dice);
	else if (category == YACHT)
		return is_yacht(dice);
	else
		return true;
}

static int find_count_same_or_bigger(dice_t dice, int count) {
	IntMap freqs = frequencies(dice.faces);
	for (size_t i = 0; i < (size_t)freqs.count; i++)
		if (freqs.pairs[i].second >= count)
			return freqs.pairs[i].first;
	assert(false);
}

int score(dice_t dice, category_t category) {
	if (!is_category(dice, category))
		return 0;

	switch (category) {
	case ONES:
	case TWOS:
	case THREES:
	case FOURS:
	case FIVES:
	case SIXES: return category * count(dice, category);
	case CHOICE:
	case FULL_HOUSE: return sum(dice);
	case FOUR_OF_A_KIND: return find_count_same_or_bigger(dice, 4) * 4;
	case LITTLE_STRAIGHT:
	case BIG_STRAIGHT: return 30;
	case YACHT: return 50;
	}
	assert(false);
}
