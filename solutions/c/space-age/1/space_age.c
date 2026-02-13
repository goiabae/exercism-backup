#include "space_age.h"

const int base = 31557600.0;

#define ON(X, F) if (planet == X) return seconds / (base * F);

float age(planet_t planet, int64_t seconds) {
	ON(MERCURY, 0.2408467);
	ON(EARTH, 1.0);
	ON(VENUS, 0.61519726);
	ON(MARS, 1.8808158);
	ON(JUPITER, 11.862615);
	ON(SATURN, 29.447498);
	ON(URANUS, 84.016846);
	ON(NEPTUNE, 164.79132);
	return -1;
}
