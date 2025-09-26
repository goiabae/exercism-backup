#include "parallel_letter_frequency.h"
#include <algorithm>
#include <cctype>
#include <execution>
#include <locale>
#include <numeric>

namespace parallel_letter_frequency {

template <typename K, typename V>
std::map<K, V> merge(std::map<K, V> ma, std::map<K, V> mb) {
	for (const auto& [k, v] : mb) {
		if (ma.find(k) != ma.end())
			ma[k] += v;
		else
			ma[k] = v;
	}
	return ma;
}

std::map<char, int> freq(std::string_view sv) {
	std::map<char, int> m {};
	std::for_each(sv.begin(), sv.end(), [&m](auto it){
		std::locale loc{"C"};
		if (not std::isalpha(it, loc))
			return;
		auto c = std::tolower(it, loc);
		if (m.find(c) != m.end())
			m[c]++;
		else
			m[c] = 1;
	});
	return m;
}
std::map<char, int> frequency(std::vector<std::string_view> svs) {
	return std::transform_reduce(std::execution::par_unseq, svs.begin(), svs.end(), std::map<char, int>{}, merge<char, int>, freq);
}

}
