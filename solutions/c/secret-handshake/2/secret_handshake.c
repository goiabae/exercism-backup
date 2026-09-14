#include "secret_handshake.h"

#include <stdlib.h>
#include <string.h>

static void rev(const char *arr[], int n) {
  int l = 0, r = n - 1;
  while (l < r) {
    const char* temp = arr[l];
    arr[l] = arr[r];
    arr[r] = temp;
    l++;
    r--;
  }
}

const char **commands(size_t number) {
	const char **sigs = malloc(sizeof(char const*) * 5);
	memset(sigs, 0, 5 * sizeof(const char*));
	int sz = 0;
	if (number == 0) return sigs;
	if ((number & 1) != 0) sigs[sz++] = "wink";
	if ((number & 2) != 0) sigs[sz++] = "double blink";
	if ((number & 4) != 0) sigs[sz++] = "close your eyes";
	if ((number & 8) != 0) sigs[sz++] = "jump";
	if ((number & 16) != 0)
		rev(sigs, sz);
	sigs[sz] = 0x0;
	return sigs;
}
