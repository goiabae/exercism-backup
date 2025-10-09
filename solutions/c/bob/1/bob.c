#include "bob.h"

#include <ctype.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

static bool all_spaces(const char* str, size_t len) {
	for (size_t i = 0; i < len; i++) {
		char c = str[i];
		if (c != ' ' && c != '\n' && c != '\r' && c != '\t')
			return false;
	}
	return true;
}

static char* filter(const char* str, size_t len, size_t* out_len) {
	char* out = (char*)malloc(sizeof(char) * len);
	*out_len = 0;
	for (size_t i = 0; i < len; i++) {
		char c = str[i];
		if (isalpha(c) || c == '?')
			out[(*out_len)++] = c;
	}
	return out;
}

static bool all_upper(const char* str, size_t len) {
	if (len == 1 && str[0] == '?') return false;
	if (len == 0) return false;
	for (size_t i = 0; i < len; i++) {
		char c = str[i];
		if (!(isupper(c) || c == '?')) return false;
	}
	return true;
}

char *hey_bob(char *greeting) {
	size_t len = strlen(greeting);
	if (len == 0 || all_spaces(greeting, len))
		return "Fine. Be that way!";

	size_t filtered_len = 0;
	const char* filtered = filter(greeting, len, &filtered_len);
	bool is_upper = all_upper(filtered, filtered_len);
	bool is_question = filtered_len > 0 && filtered[filtered_len-1] == '?';

	return is_upper
		? (is_question ? "Calm down, I know what I'm doing!" : "Whoa, chill out!")
		: (is_question ? "Sure." : "Whatever.");
}
