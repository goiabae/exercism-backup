#include "alphametics.h"

#include <algorithm>
#include <bitset>
#include <cctype>
#include <cstddef>
#include <functional>
#include <iostream>
#include <iterator>
#include <locale>
#include <memory>
#include <optional>
#include <ostream>
#include <set>
#include <variant>
#include <vector>
#include <numeric>

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

using varptr = std::variant<int, std::monostate>*;

struct Equation {
	std::vector<varptr> summands;
	Equation* previous_equation;
	varptr expected_result;
	enum class State {
		NOT_INSTANTIATED,
		SOLUTION_FOUND,
		IMPOSSIBLE,
	};
	auto get_result () const -> std::optional<int>;
	auto get_state () const -> State;
	auto print_result (std::ostream& st) const -> std::ostream&;
};

auto Equation::print_result (std::ostream& st) const -> std::ostream& {
	{
		st << "Σ";
		st << '{';
		if (summands.size() > 0) {
			for (auto i = 0ul; i < summands.size()-1; i++) {
				const auto& summand = summands.at(i);
				if (std::holds_alternative<int>(*summand)) {
					st << std::get<int>(*summand) << ", ";
				} else {
					st << '_' << ", ";
				}
			}
			{
				const auto& summand = summands.at(summands.size()-1);
				if (std::holds_alternative<int>(*summand)) {
					st << std::get<int>(*summand);
				} else {
					st << '_';
				}
			}
		}
		st << '}';
	}
	if (previous_equation != nullptr) {
		st << " + ";
		st << "⌊";
		previous_equation->print_result(st);
		st << " / 10";
		st << "⌋";
	}
	return st;
}

auto operator<< (std::ostream& st, const Equation& eqn) -> std::ostream& {
	st << '(';
	eqn.print_result(st);
	st << ')';
	st << " % 10";
	st << " == ";
	if (std::holds_alternative<int>(*eqn.expected_result)) {
		st << std::get<int>(*eqn.expected_result);
	} else {
		st << '_';
	}
	return st;
}

auto Equation::get_result () const -> std::optional<int> {
	auto sum = 0; // sn
	for (const auto& summand : summands) {
		if (std::holds_alternative<std::monostate>(*summand)) return {};
		sum += std::get<int>(*summand);
	}
	auto carry = 0; // an
	if (previous_equation != nullptr) {
		auto result = previous_equation->get_result();
		if (not result.has_value()) {};
		carry = result.value() / 10;
	}
	auto result = sum + carry;
	return result;
}

auto Equation::get_state () const -> State {
	if (std::holds_alternative<std::monostate>(*expected_result)) return State::NOT_INSTANTIATED;
	auto expected = std::get<int>(*expected_result);
	auto sum = 0;
	for (const auto& summand : summands) {
		if (std::holds_alternative<std::monostate>(*summand)) return State::NOT_INSTANTIATED;
		sum += std::get<int>(*summand);
	}
	auto carry = 0;
	if (previous_equation != nullptr) {
		auto result = previous_equation->get_result();
		if (not result.has_value()) return State::NOT_INSTANTIATED;
		carry = result.value() / 10;
	}
	auto result = sum + carry;
	if ((result % 10) == expected) return State::SOLUTION_FOUND;
	return State::IMPOSSIBLE;
}

template <typename T>
auto format_vector (std::function<std::string(const T&)> f, const std::vector<T>& xs) -> std::string {
	std::vector<std::string> ys {};
	std::transform(xs.cbegin(), xs.cend(), std::back_inserter(ys), f);
	if (ys.size() == 0) {
		return "[]";
	} else if (ys.size() == 1) {
		return "[" + ys.at(0) + "]";
	} else {
		const std::string x = std::reduce(ys.cbegin()+1, ys.cend(), ys[0], [&](const std::string& acc, const std::string& x) {
			return acc + ", " + x;
		});
		const std::string formatted = "[" + x +  "]";
		return formatted;
	}
}

auto has_leading_zeros (const std::vector<varptr>& digits) -> bool {
	auto is_leading = true;
	for (const auto& digit : digits) {
		const auto& v = std::get<int>(*digit);
		if (v == 0 && is_leading) {
			return true;
		} else if (v != 0) {
			is_leading = false;
		}
	}
	return false;
}

auto solve_aux(std::vector<Equation*> eqns, std::vector<varptr> variables, int start, const std::vector<std::vector<varptr>>& number_digits, std::bitset<10>& used_numbers) -> Equation::State {
	for (auto j = 0; j < 10; j++) {
		if (used_numbers[j]) continue;
		used_numbers[j] = true;
		*variables[start] = j;
		if (static_cast<std::size_t>(start) == variables.size()-1) {
			const auto all_solved = std::all_of(eqns.cbegin(), eqns.cend(), [](Equation* const& eqn) -> bool{
				return eqn->get_state() == Equation::State::SOLUTION_FOUND;
			});
			if (all_solved) {
				const auto no_leading_zeros = std::all_of(number_digits.cbegin(), number_digits.cend(), [](const auto& digits){
					return !has_leading_zeros(digits);
				});
				if (no_leading_zeros) {
					return Equation::State::SOLUTION_FOUND;
				}
			}
		} else {
			const auto res = solve_aux(eqns, variables, start+1, number_digits, used_numbers);
			if (res == Equation::State::SOLUTION_FOUND) return Equation::State::SOLUTION_FOUND;
		}
		used_numbers[j] = false;
	}
	*variables[start] = std::monostate();
	return Equation::State::IMPOSSIBLE;
}

std::optional<std::map<char, int>> solve(std::string input) {
	std::cerr << "input: " << '\"' << input << '\"' << '\n';
	std::locale loc {};
	std::set<char> letters {};
	for (auto c : input) {
		if (std::isalpha(c, loc))
		  letters.insert(c);
	}
	std::map<char, int> output {};
	auto p = input.find("==");
	const auto before_equals = input.substr(0, p-1);
	std::cerr << "before-equals: " << '\"' << before_equals << '\"' << '\n';
	const auto after_equals = input.substr(p+3);
	const auto operands = split_on_pluses(before_equals);
	const auto result = after_equals;
	{
		auto x = format_vector<std::string>([](const std::string& x) -> std::string { return std::string("\"") + x + "\""; }, operands);
		std::cerr << "parsed-input: " << x << " == " << result << '\n';
	}
	std::vector<varptr> variables {};
	std::map<char, varptr> char_to_variable {};
	{
		for (auto i = 0ul; i < operands.size(); i++) {
			for (const auto& c : operands.at(i)) {
				if (char_to_variable.find(c) == char_to_variable.cend()) {
					auto p = new std::variant<int, std::monostate>();
					char_to_variable[c] = p;
					variables.push_back(p);
				}
			}
		}
		for (const auto& c : result) {
			if (char_to_variable.find(c) == char_to_variable.cend()) {
				auto p = new std::variant<int, std::monostate>();
				char_to_variable[c] = p;
				variables.push_back(p);
			}
		}
	}
	{
		std::vector<char> keys {};
		for (const auto& [k, _] : char_to_variable)
		keys.push_back(k);
		std::cerr << "found-variables: " << format_vector<char>([](const char& x) -> std::string { return std::string(1, x); }, keys) << '\n';
	}

	std::vector<int> lengths {};
	std::transform(operands.cbegin(), operands.cend(), std::back_inserter(lengths), [](const std::string& x){ return x.size(); });
	auto x = std::max_element(lengths.cbegin(), lengths.cend());
	auto y = *x;
	auto z = result.size();
	auto w = std::max(y, static_cast<int>(z));
	if (result.size() < static_cast<std::size_t>(w)) return {};
	const auto equation_count = w;
	std::cerr << "equation-count: " << equation_count << '\n';
	std::vector<std::string> padded_operands {};
	std::transform(operands.cbegin(), operands.cend(), std::back_inserter(padded_operands), [&equation_count](const std::string& operand){
		return pad_left(operand, equation_count);
	});
	{
		auto x = format_vector<std::string>([](const std::string& x) -> std::string { return std::string("\"") + x + "\""; }, padded_operands);
		std::cerr << "padded-input: " << x << " == " << result << '\n';
	}
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
	std::vector<Equation*> eqns {};
	for (auto i = equation_count-1; i >= 0; i--) {
		Equation* eqn = new Equation {};
		if (i == equation_count-1) {
			eqn->previous_equation = nullptr;
		} else {
			eqn->previous_equation = eqns.back();
		}
		eqn->expected_result = char_to_variable.at(result[i]);
		eqn->summands = {};
		for (auto j = 0ul; j < padded_operands.size(); j++) {
			const auto& padded_operand = padded_operands[j];
			const auto& column = padded_operand[i];
			if (column != ' ') {
				eqn->summands.push_back(char_to_variable.at(column));
			}
		}
		eqns.push_back(eqn);
	}
	std::bitset<10> used_numbers {};
	auto res = solve_aux(eqns, variables, 0, number_digits, used_numbers);
	if (res == Equation::State::SOLUTION_FOUND) {
		std::cerr << "SOLUTION FOUND!!" << '\n';
		std::map<char, int> result {};
		for (const auto& [k, p] : char_to_variable) {
			const auto n = std::get<int>(*p);
			std::cerr << '\t' << k << ": " << n << '\n';
			result[k] = n;
		}
		std::cerr << '\n';
		return result;
	} else {
		std::cerr << "SOLUTION IMPOSSIBLE!!" << '\n';
		std::cerr << '\n';
		return {};
	}
}

}  // namespace alphametics
