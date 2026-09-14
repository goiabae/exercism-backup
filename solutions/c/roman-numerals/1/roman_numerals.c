#include "roman_numerals.h"

#include <stdlib.h>

typedef struct { char first; int second; } pair;

// using M = std::vector<std::pair<char, int>>;
typedef pair m[];

char *to_roman_numeral(unsigned int number) {
	pair letters[] = {{'M', 1000}, {'C', 100}, {'X', 10}, {'I', 1}};
	pair cinq[] = {{'K', 0}, {'D', 500}, {'L', 50}, {'V', 5}};
	char *res = malloc(sizeof(char) * 500);
	int sz = 0;
	while (number > 0) {
		for (int i = 0ul; i < 4; i++) {
			pair p = letters[i];
			char l = p.first;
			int v = p.second;
			int m = number / v;
			if (m == 9) {
				res[sz++] = l;
				res[sz++] = letters[i-1].first;
			} else if (5 <= m && m <= 8) {
				res[sz++] = cinq[i].first;
				for (int j = 0; j < (m-5); j++)
					res[sz++] = l;
			} else if (m == 4) {
				res[sz++] = l;
				res[sz++] = cinq[i].first;
			} else if (1 <= m && m <= 3) {
				for (int j = 0; j < m; j++)
					res[sz++] = l;
			}
			if (m > 0) {
				number -= m*v;
				break;
			}
		}
	}
	res[sz] = '\0';
	return res;
}
