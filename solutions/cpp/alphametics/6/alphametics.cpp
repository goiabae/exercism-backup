#include "alphametics.h"

#include <algorithm>
#include <bitset>
#include <cctype>
#include <cstddef>
#include <iterator>
#include <optional>
#include <variant>
#include <vector>

namespace alphametics {

std::vector<std::string> split(const std::string& str, const char* delimiter) {
	std::vector<std::string> result;

	if (!delimiter || *delimiter == '\0') {
		result.push_back(str);
		return result;
	}

	std::string delim(delimiter);
	size_t start = 0;
	size_t end;

	while ((end = str.find(delim, start)) != std::string::npos) {
		result.emplace_back(str.substr(start, end - start));
		start = end + delim.length();
	}

	// Add the last segment
	result.emplace_back(str.substr(start));

	return result;
}

std::vector<std::string> split_on_pluses (std::string str) {
	return split(str, " + ");
}

std::string pad_left (const std::string& str, std::size_t length) {
	const auto to_pad_count = length - str.size();
	return std::string(to_pad_count, ' ') + str;
}

using varptr = int*;

struct Equation {
	std::vector<varptr> summands;
	Equation* previous_equation;
	varptr expected_result;
	auto get_result () const -> std::optional<int>;
	auto get_result2 (int previous_result) const -> int;
	auto get_state () const -> bool;
	auto is_valid (int result) const -> bool;
};

auto Equation::get_result () const -> std::optional<int> {
	auto sum = 0;
	for (const auto& summand : summands) {
		if (*summand == -1) return {};
		sum += *summand;
	}
	auto carry = 0;
	if (previous_equation != nullptr) {
		auto result = previous_equation->get_result();
		if (not result.has_value()) return {};
		carry = result.value() / 10;
	}
	auto result = sum + carry;
	return result;
}

auto Equation::get_result2 (int previous_result) const -> int {
	if (previous_result == -1) return -1;
	auto sum = 0;
	for (const auto& summand : summands) {
		if (*summand == -1) return -1;
		sum += *summand;
	}
	auto carry = previous_result / 10;;
	auto result = sum + carry;
	return result;
}

auto Equation::is_valid (int result) const -> bool {
	if (*expected_result == -1) return false;
	return (result % 10) == *expected_result;
}

auto Equation::get_state () const -> bool {
	if (*expected_result == -1) return false;
	auto expected = *expected_result;
	auto sum = 0;
	for (const auto& summand : summands) {
		if (*summand == -1) return false;
		sum += *summand;
	}
	auto carry = 0;
	if (previous_equation != nullptr) {
		auto result = previous_equation->get_result();
		if (not result.has_value()) return false;
		carry = result.value() / 10;
	}
	auto result = sum + carry;
	if ((result % 10) == expected) return true;
	return false;
}

auto has_leading_zeros (const std::vector<varptr>& digits) -> bool {
	auto is_leading = true;
	for (const auto& digit : digits) {
		const auto& v = *digit;
		if (v == 0 && is_leading) {
			return true;
		} else if (v != 0) {
			is_leading = false;
		}
	}
	return false;
}

auto solve_aux(const std::vector<Equation>& eqns, std::vector<varptr>& variables, int start, const std::vector<std::vector<varptr>>& number_digits, std::bitset<10>& used_numbers) -> bool {
	for (auto j = 0; j < 10; j++) {
		if (used_numbers[j]) continue;
		used_numbers[j] = true;
		*variables[start] = j;
		if (static_cast<std::size_t>(start) == variables.size()-1) {
			auto all_solved = true;
			int previous_result = 0;
			for (const auto& eqn : eqns) {
				int result = eqn.get_result2(previous_result);
				if (result == -1 || !eqn.is_valid(result)) {
					all_solved = false;
					break;
				}
				previous_result = result;
			}
			if (all_solved) {
				const auto no_leading_zeros = std::all_of(number_digits.cbegin(), number_digits.cend(), [](const auto& digits){
					return !has_leading_zeros(digits);
				});
				if (no_leading_zeros) {
					return true;
				}
			}
		} else {
			const auto res = solve_aux(eqns, variables, start+1, number_digits, used_numbers);
			if (res) return true;
		}
		used_numbers[j] = false;
	}
	*variables[start] = -1;
	return false;
}

std::optional<std::map<char, int>> solve(std::string input) {
	auto p = input.find("==");
	const auto before_equals = input.substr(0, p-1);
	const auto after_equals = input.substr(p+3);
	const auto operands = split_on_pluses(before_equals);
	const auto result = after_equals;
	std::vector<varptr> variables {};
	std::map<char, varptr> char_to_variable {};
	{
		for (auto i = 0ul; i < operands.size(); i++) {
			for (const auto& c : operands.at(i)) {
				if (char_to_variable.find(c) == char_to_variable.cend()) {
					auto p = new int {-1};
					char_to_variable[c] = p;
					variables.push_back(p);
				}
			}
		}
		for (const auto& c : result) {
			if (char_to_variable.find(c) == char_to_variable.cend()) {
				auto p = new int {-1};
				char_to_variable[c] = p;
				variables.push_back(p);
			}
		}
	}
	std::vector<int> lengths {};
	std::transform(operands.cbegin(), operands.cend(), std::back_inserter(lengths), [](const std::string& x){ return x.size(); });
	auto x = std::max_element(lengths.cbegin(), lengths.cend());
	auto y = *x;
	auto z = result.size();
	auto w = std::max(y, static_cast<int>(z));
	if (result.size() < static_cast<std::size_t>(w)) return {};
	const auto equation_count = w;
	std::vector<std::string> padded_operands {};
	std::transform(operands.cbegin(), operands.cend(), std::back_inserter(padded_operands), [&equation_count](const std::string& operand){
		return pad_left(operand, equation_count);
	});
	std::vector<std::vector<varptr>> number_digits {};
	{
		for (const auto& operand : operands) {
			std::vector<varptr> digits {};
			for (const auto& c : operand) {
				digits.push_back(char_to_variable.at(c));
			}
			number_digits.push_back(digits);
		}
		{
			std::vector<varptr> digits {};
			for (const auto& c : result) {
				digits.push_back(char_to_variable.at(c));
			}
			number_digits.push_back(digits);
		}
	}
	std::vector<Equation> eqns {};
	eqns.reserve(equation_count);
	for (auto i = equation_count-1; i >= 0; i--) {
		Equation eqn {};
		if (i == equation_count-1) {
			eqn.previous_equation = nullptr;
		} else {
			eqn.previous_equation = &eqns.back();
		}
		eqn.expected_result = char_to_variable.at(result[i]);
		eqn.summands = {};
		for (auto j = 0ul; j < padded_operands.size(); j++) {
			const auto& padded_operand = padded_operands[j];
			const auto& column = padded_operand[i];
			if (column != ' ') {
				eqn.summands.push_back(char_to_variable.at(column));
			}
		}
		eqns.push_back(eqn);
	}
	std::bitset<10> used_numbers {};
	auto solution_found = solve_aux(eqns, variables, 0, number_digits, used_numbers);
	if (solution_found) {
		std::map<char, int> result {};
		for (const auto& [k, p] : char_to_variable) {
			const auto n = *p;
			result[k] = n;
		}
		return result;
	} else {
		return {};
	}
}

}  // namespace alphametics
