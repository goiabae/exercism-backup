#include "affine_cipher.h"

#include <algorithm>
#include <cassert>
#include <cctype>
#include <cmath>
#include <locale>
#include <stdexcept>
#include <string_view>

namespace affine_cipher {

constexpr const std::string_view alphabet { "abcdefghijklmnopqrstuvwxyz" };
constexpr const auto m = alphabet.size();

static const std::locale loc {"C"};

static const auto filter = [](auto c){
	return c == ',' or c == '.' or std::isspace(c, loc);
};

std::string chunk(std::string str) {
	std::string res {};
	for (auto i = 1; i <= (int)str.size(); i++) {
		res += str[i-1];
		if (i % 5 == 0 and i != (int)str.size())
			res += " ";
	}
	return res;
}

int mmi(int a, int m) {
	for (auto x = 1; x <= m; x++)
		if ((a*x) % m == 1)
			return x;
	throw std::domain_error("no mmi found");
}

bool coprime(int x, int y) {
	for (auto i = 2; i <= std::min(x, y); i++)
		if ((x % i) == 0 and (y % i) == 0)
			return false;
	return true;
}

int euc(int a, int b) {
	return ((a % b) + b) % b;
}

std::string encode(std::string phrase, int a, int b) {
	if (not coprime(a, m))
		throw std::invalid_argument("a and m must be coprime");
	phrase.erase(std::remove_if(phrase.begin(), phrase.end(), filter), phrase.end());
	std::transform(phrase.begin(), phrase.end(), phrase.begin(), [&](auto c) {
		return std::isalpha(c, loc)
			? (a * (std::tolower(c, loc) - 'a') + b) % m + 'a'
			: c;
	});
	return chunk(phrase);
}

std::string decode(std::string phrase, int a, int b) {
	if (not coprime(a, m))
		throw std::invalid_argument("a and m must be coprime");
	phrase.erase(std::remove_if(phrase.begin(), phrase.end(), filter), phrase.end());
	std::transform(phrase.begin(), phrase.end(), phrase.begin(), [&](auto c) {
		return std::isalpha(c, loc)
			? euc(mmi(a, m) * ((c - 'a') - b), m) + 'a'
			: c;
	});
	return phrase;
}

}  // namespace affine_cipher
