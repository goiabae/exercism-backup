#include "dnd_character.h"

#include <math.h>
#include <stdlib.h>

int ability(void) {
	return (rand() % 16) + 3;
}

int modifier(int score) {
	return floor((score - 10.) / 2);
}

dnd_character_t make_dnd_character(void) {
	int constitution = ability();
	return (dnd_character_t) {
		.strength = ability(),
		.dexterity = ability(),
		.constitution = constitution,
		.intelligence = ability(),
		.wisdom = ability(),
		.charisma = ability(),
		.hitpoints = 10 + modifier(constitution),
	};
}
