#include "variable_length_quantity.h"
#include <stdbool.h>
#include <stdint.h>

int encode(const uint32_t *values, size_t values_len, uint8_t *octets) {
	// write to `output`, return final output's length
	// `output` buffer should be enough to hold the full result
	int sz = 0;
	for (size_t i = 0; i < values_len; i++) {
		uint32_t value = values[i];
		if (value == 0) {
			octets[sz++] =0;
			continue;
		}
		int septets[100];
		int sz2 = 0;
		while (value != 0) {
			int septet = value & (0x80-1);
			septets[sz2++] = septet;
			value = value >> 7;
		}
		for (int i = sz2; i >= 1; i -= 1) {
			int septet = septets[i-1];
			int mask = (i == 1) ? 0x0 : 0x80;
			octets[sz++] = septet | mask;
		}
	}
	return sz;
}

int decode(const uint8_t *octets, size_t octets_len, uint32_t *values) {
	// write to `output`, return final output's length
	// return -1 if error
	// `output` buffer should be enough to hold the full result
	uint8_t septets[100];
	int sz2 = 0;
	int sz = 0;
	bool reached_sentinel_octet = false;
	for (size_t j = 0; j < octets_len; j++) {
		uint8_t octet = octets[j];
		reached_sentinel_octet = false;
		bool is_last = (octet & 0x80) == 0;
		septets[sz2++] = octet & (0x80-1);
		if (is_last) {
			int value = 0;
			for ( int i = 1; i <= sz2; i++) {
				uint8_t septet = septets[i-1];
				value = (value << 7) + septet;
			}
			values[sz++] = value;
			sz2 = 0;
			reached_sentinel_octet = true;
		}
	}
	if (!reached_sentinel_octet)
		return -1;
	return sz;
}
