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
		const auto prev_house = (i > 0) ? state[i-1] : std::optional<House> {};
		const auto next_house = (i < 4) ? state[i+1] : std::optional<House> {};

		if (
			(house.nationality and house.color and ((house.nationality == Nationality::Englishman) xor (house.color == Color::Red)))
			or (house.nationality and house.pet and ((house.nationality == Nationality::Spaniard) xor (house.pet == Pet::Dog)))
			or (house.color and house.drink and ((house.color == Color::Green) xor (house.drink == Drink::Coffee)))
			or (house.nationality and house.drink and ((house.nationality == Nationality::Ukrainian) xor (house.drink == Drink::Tea)))
			or (house.pet and house.smoke and ((house.pet == Pet::Snail) xor (house.smoke == Smoke::OldGold)))
			or (house.smoke and house.color and ((house.color == Color::Yellow) xor (house.smoke == Smoke::Kools)))
			or (house.smoke and house.drink and ((house.smoke == Smoke::LuckyStrike) xor (house.drink == Drink::OrangeJuice)))
			or (house.nationality and house.smoke and ((house.nationality == Nationality::Japanese) xor (house.smoke == Smoke::Parliaments)))
			or (i == 2 and house.drink and house.drink != Drink::Milk)
			or (i == 0 and house.nationality and house.nationality != Nationality::Norwegian)
			or (house.color and prev_house and (prev_house.value().color and ((house.color == Color::Green) xor (prev_house.value().color == Color::Ivory))))
			or (house.smoke == Smoke::Chesterfield and (not (prev_house.value_or(House{}).pet.value_or(Pet::Fox) == Pet::Fox or next_house.value_or(House{}).pet.value_or(Pet::Fox) == Pet::Fox)))
			or (house.smoke == Smoke::Kools and (not ((prev_house and prev_house.value().pet.value_or(Pet::Horse) == Pet::Horse) or (next_house.value_or(House{}).pet.value_or(Pet::Horse) == Pet::Horse))))
			or (house.nationality == Nationality::Norwegian and (not ((prev_house and prev_house.value().color.value_or(Color::Blue) == Color::Blue) or (next_house.value_or(House{}).color.value_or(Color::Blue) == Color::Blue))))
		) return false;
	}
	return true;
}

constexpr inline bool find(PartialState&, int) { return true; }

template<bool other(PartialState& state, int i), typename T, std::optional<T> House::*Member>
constexpr bool find(PartialState& state, int i) {
	const auto get_field = [&](int k) -> std::optional<T>& { return state[k].*Member; };
	for (auto n = 0ul; n < 5ul; n++) {
		const auto elt = static_cast<T>(n);
		auto already_used = false;
		for (auto j = 0ul; j < (std::size_t)i and not already_used; j++)
			already_used = already_used or elt == get_field(j);
		if (already_used) continue;
		get_field(i) = elt;
		if (is_valid(state) and ((i == 4) ? other(state, 0) : find<other, T, Member>(state, i+1)))
			return true;
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
