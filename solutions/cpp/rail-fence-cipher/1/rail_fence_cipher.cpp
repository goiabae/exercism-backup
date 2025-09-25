#include "rail_fence_cipher.h"

#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <utility>
#include <vector>
#include <array>

namespace rail_fence_cipher {

std::vector<std::pair<int, int>> get_mapping(int num_rails, int length) {
	std::vector<std::pair<int, int>> res {};
	int dec = 0;
	for (auto n = 0; n < num_rails; n++) {
		float middle = 0.5*((float)num_rails - ((num_rails & 1) ^ 1));
		int dist_from_middle = std::abs(n - 0.5*((float)num_rails - 1));
		std::array<int, 2> offsets {
			2*((int)middle - dist_from_middle),
			2*(num_rails - 1 - (int)middle + dist_from_middle),
		};

		bool flag = true;
		for (
			int enc = n;
			enc < length;
			enc += offsets[(flag + (offsets[0] != 0 and n > middle)) % 2],
			flag = (offsets[0] == 0) or not flag
		)
			res.push_back({dec++, enc});
	}

	return res;
}

std::string encode(const std::string& plaintext, int num_rails) {
	auto mapping = get_mapping(num_rails, plaintext.size());
	std::string encoded {};
	for (auto [dec, enc] : mapping)
		encoded += plaintext[enc];
	return encoded;
}

std::string decode(const std::string& ciphertext, int num_rails) {
	auto mapping = get_mapping(num_rails, ciphertext.size());
	std::sort(mapping.begin(), mapping.end(), [](auto pa, auto pb){ return pa.second < pb.second; });
	std::string decoded {};
	for (auto [dec, enc] : mapping)
		decoded += ciphertext[dec];
	return decoded;
}

}  // namespace rail_fence_cipher
