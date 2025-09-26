#include "raindrops.h"
#include <stdio.h>

#define BUFFER_LENGTH 16

static void aux(char **result, int n, int m, int *buffer_length, const char* txt) {
	if (n % m == 0)
		snprintf(*result, *buffer_length, "%s", txt),
		*result += 5, *buffer_length -=5;
}

void convert(char result[], int n) {
	int buffer_length = BUFFER_LENGTH;
	if (n % 3 && n % 5 && n % 7) {
		snprintf(result, buffer_length, "%d", n);
		return;
	}
	aux(&result, n, 3, &buffer_length, "Pling");
	aux(&result, n, 5, &buffer_length, "Plang");
	aux(&result, n, 7, &buffer_length, "Plong");
}
