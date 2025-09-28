#include "high_scores.h"

#include <stdio.h>
#include <stdlib.h>

int32_t latest(const int32_t *scores, size_t scores_len) {
	if (scores_len < 1 || scores == NULL)
		return -1;
	return scores[scores_len-1];
}

int32_t personal_best(const int32_t *scores, size_t scores_len) {
	if (scores == NULL) return -1;
	int32_t max = 0;
	for (int i = 0; i < (int)scores_len; i++)
		if (scores[i] > max) max = scores[i];
	return max;
}

static int cmp(const void* va, const void* vb) {
	int32_t a = *(int32_t*)va;
	int32_t b = *(int32_t*)vb;
	if (a == b) return 0;
	if (a < b) return -1;
	return 1;
}

size_t personal_top_three(
	const int32_t *scores,
	size_t scores_len,
	int32_t *output
) {
	if (scores == NULL) return -1;

	qsort((int32_t*)scores, scores_len, sizeof(int32_t), cmp);

	int n = 0;

	if (scores_len >= 1)
		output[0] = scores[scores_len - (1 + n++)];

	if (scores_len >= 2)
		output[1] = scores[scores_len - (1 + n++)];

	if (scores_len >= 3)
		output[2] = scores[scores_len - (1 + n++)];

	return n;
}
