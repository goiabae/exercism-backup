#include "rail_fence_cipher.h"

#include <array>

namespace rail_fence_cipher {

std::string code(int num_rails, const std::string& text, bool is_encoding) {
	std::string coded(text.length(), 'A');
	auto dec = 0;
	for (auto n = 0; n < num_rails; n++) {
		auto middle = 0.5*((float)num_rails - ((num_rails & 1) ^ 1));
		auto dist_from_middle = (int)std::abs(n - 0.5*((float)num_rails - 1));
		std::array offsets {
			2*((int)middle - dist_from_middle),
			2*(num_rails - 1 - (int)middle + dist_from_middle),
		};

		auto flag = true;
		for (
			auto enc = n;
			enc < (int)text.length();
			enc += offsets[(flag + (offsets[0] != 0 and n > middle)) % 2],
			flag = (offsets[0] == 0) or not flag
		)
			if (is_encoding)
				coded[dec++] = text[enc];
			else
				coded[enc] = text[dec++];
	}

	return coded;
}

std::string encode(const std::string& plaintext, int num_rails) {
	return code(num_rails, plaintext, true);
}

std::string decode(const std::string& ciphertext, int num_rails) {
	return code(num_rails, ciphertext, false);
}

}  // namespace rail_fence_cipher
