#pragma once

#include <array>
#include <cstddef>
#include <optional>
#include <string>

namespace zebra_puzzle {

struct Solution {
    std::string_view drinksWater;
    std::string_view ownsZebra;
};

enum class Nationality { Norwegian, Ukrainian, Englishman, Spaniard, Japanese };
enum class Color { Red, Blue, Yellow, Ivory, Green };
enum class Drink { Tea, Milk, Coffee, OrangeJuice, Water };
enum class Smoke { LuckyStrike, OldGold, Kools, Chesterfield, Parliaments };
enum class Pet { Zebra, Fox, Horse, Snail, Dog };

constexpr std::string_view to_string(Nationality nationality) {
	switch (nationality) {
	case Nationality::Norwegian: return "Norwegian";
	case Nationality::Ukrainian: return "Ukrainian";
	case Nationality::Englishman: return "Englishman";
	case Nationality::Spaniard: return "Spaniard";
	case Nationality::Japanese: return "Japanese";
	}
	throw;
}

struct House {
	std::optional<Nationality> nationality;
	std::optional<Color> color;
	std::optional<Drink> drink;
	std::optional<Smoke> smoke;
	std::optional<Pet> pet;
};

using PartialState = std::array<House, 5>;

constexpr bool is_valid(const PartialState& state) {
	for (int i = 0; i < 5; i++) {
		const auto& house = state[i];

		// The Englishman lives in the red house.
		if (house.nationality and house.color)
			if ((house.nationality == Nationality::Englishman) xor (house.color == Color::Red))
				return false;

		// The Spaniard owns the dog.
		if (house.nationality and house.pet)
			if ((house.nationality == Nationality::Spaniard) xor (house.pet == Pet::Dog))
				return false;

		// The person in the green house drinks coffee.
		if (house.color and house.drink)
			if ((house.color == Color::Green) xor (house.drink == Drink::Coffee))
				return false;

		// The Ukrainian drinks tea.
		if (house.nationality and house.drink)
			if ((house.nationality == Nationality::Ukrainian) xor (house.drink == Drink::Tea))
				return false;

		// The snail owner likes to go dancing (smokes Old Gold).
		if (house.pet and house.smoke)
			if ((house.pet == Pet::Snail) xor (house.smoke == Smoke::OldGold))
				return false;

		// The person in the yellow house is a painter (smokes Kools).
		if (house.smoke and house.color)
			if ((house.color == Color::Yellow) xor (house.smoke == Smoke::Kools))
				return false;

		// The person who plays football (smokes Lucky Strike) drinks orange juice.
		if (house.smoke and house.drink)
			if ((house.smoke == Smoke::LuckyStrike) xor (house.drink == Drink::OrangeJuice))
				return false;

		// The Japanese person plays chess (smokes Parliaments).
		if (house.nationality and house.smoke)
			if ((house.nationality == Nationality::Japanese) xor (house.smoke == Smoke::Parliaments))
				return false;

		// The person in the middle house drinks milk.
		if (i == 2 and house.drink.value_or(Drink::Milk) != Drink::Milk)
			return false;

		// The Norwegian lives in the first house.
		if (i == 0 and house.nationality.value_or(Nationality::Norwegian) != Nationality::Norwegian)
			return false;

		// The green house is immediately to the right of the ivory house.
		if (house.color and i > 0) {
			auto prev_house = state[i-1];
			if (prev_house.color) {
				if ((house.color == Color::Green) xor (prev_house.color == Color::Ivory))
					return false;
			}
		}

		// The person who enjoys reading (smokes Chesterfield) lives in the house next to the person with the fox.
		if (house.smoke.value_or(Smoke::Chesterfield) == Smoke::Chesterfield) {
			auto prev_fox = i > 0 and state[i-1].pet.value_or(Pet::Fox) == Pet::Fox;
			auto next_fox = i < 4 and state[i+1].pet.value_or(Pet::Fox) == Pet::Fox;
			if (not (prev_fox or next_fox))
				return false;
		}

		// The painter's (smokes Kool) house is next to the house with the horse.
		if (house.smoke.value_or(Smoke::Kools) == Smoke::Kools) {
			auto prev_horse = i > 0 and state[i-1].pet.value_or(Pet::Horse) == Pet::Horse;
			auto next_horse = i < 4 and (state[i+1].pet.value_or(Pet::Horse) == Pet::Horse);
			if (not (prev_horse or next_horse))
				return false;
		}

		// The Norwegian lives next to the blue house.
		if (house.nationality.has_value() and house.nationality.value() == Nationality::Norwegian) {
			auto prev_blue = i > 0 and state[i-1].color.value_or(Color::Blue) == Color::Blue;
			auto next_blue = i < 4 and state[i+1].color.value_or(Color::Blue) == Color::Blue;
			if (not (prev_blue or next_blue))
				return false;
		}
	}
	return true;
}

constexpr inline bool find(PartialState&, int) {
	return true;
}

template<bool other(PartialState& state, int i), typename T, std::optional<T> House::*Member>
constexpr bool find(PartialState& state, int i) {
	const auto get_field = [&](int k) -> std::optional<T>& { return state[k].*Member; };
	for (auto n = 0ul; n < 5ul; n++) {
		const auto elt = static_cast<T>(n);
		auto already_used = false;
		for (auto j = 0ul; j < (std::size_t)i and not already_used; j++)
			if (elt == get_field(j).value())
				already_used = true;
		if (not already_used) {
			get_field(i) = elt;
			if (is_valid(state) and ((i == 4) ? other(state, 0) : find<other, T, Member>(state, i+1)))
				return true;
		}
	}
	get_field(i) = {};
	return false;
}

constexpr Solution solve() {
	PartialState state {};
	find<find<find<find<find<find, Pet, &House::pet>, Smoke, &House::smoke>, Drink, &House::drink>, Color, &House::color>, Nationality, &House::nationality>(state, 0);
	Solution solution {};
	for (auto house : state) {
		if (house.nationality) {
			if (house.drink == Drink::Water)
				solution.drinksWater = to_string(house.nationality.value());
			if (house.pet == Pet::Zebra)
				solution.ownsZebra = to_string(house.nationality.value());
		}
	}
	return solution;
}

}  // namespace zebra_puzzle
