#include "series.h"

#include <stdlib.h>
#include <string.h>

static void substr(char* buf, char* text, int start, int length) {
	for (int i = 0; i < length; i++) {
		buf[i] = text[start+i];
	}
	buf[length] = '\0';
}

slices_t slices(char *input_text, unsigned int substring_length) {
	if ( substring_length == 0) {
		slices_t slices;
		slices.substring_count = 0;
		slices.substring = malloc(sizeof(char*) * 1);
		slices.substring[0] = "";
		return slices;
	}
	slices_t slices;
	slices.substring_count = 0;
	slices.substring = malloc(sizeof(char*) * 100);
	int size = strlen(input_text);
	for (int i = 0; i <= (size - (int)substring_length); i++) {
		char** s = &slices.substring[slices.substring_count++];
		*s = malloc(sizeof(char) * 100);
		substr(*s, input_text, i, substring_length);
	}
	return slices;
}
