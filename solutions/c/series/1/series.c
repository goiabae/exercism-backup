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

/* std::vector<std::string> slice(std::string s, int length) { */
/* 	if (s.size() == 0) */
/* 		throw std::domain_error("series cannot be empty"); */
/* 	if (length == 0) */
/* 		throw std::domain_error("slice length cannot be zero"); */
/* 	if (length > (int)s.size()) */
/* 		throw std::domain_error("slice length cannot be greater that series length"); */
/* 	if (length < 0) */
/* 		throw std::domain_error("slice length cannot be negative"); */

/* 	std::vector<std::string> res {}; */
/* 	for (auto i = 0ul; i <= (s.size() - length); i++) */
/* 		res.push_back(s.substr(i, length)); */
/* 	return res; */
/* } */
