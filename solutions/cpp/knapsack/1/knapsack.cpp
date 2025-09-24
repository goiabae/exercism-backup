#include "knapsack.h"

namespace knapsack {

int maximum_value(int max_weight, const std::vector<Item>& items) {

	auto W = max_weight;
	auto n = static_cast<int>(items.size());

	// first row and column all zeros
	std::vector<int> m((n+1)*(W+1), 0);
	const auto at = [&](int i, int j) -> int& {
		return m[i*(W+1)+j];
	};

	for (auto i = 1; i <= n; i++)
		for (auto j = 1; j <= W; j++)
			at(i, j) = (items[i-1].weight > j)
				? at(i-1, j)
				: std::max(at(i-1, j), at(i-1, j-items[i-1].weight) + items[i-1].value);

	return at(n, W);
}

}  // namespace knapsack
