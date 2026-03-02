#include "eliuds_eggs.h"

unsigned int egg_count(unsigned int number) {
	int count = 0;
	while (number > 0) {
		count += (((number % 2) == 1) ? 1 : 0);
		number = (number - (number % 2)) / 2;
	}
	return count;
}
