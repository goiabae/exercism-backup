#ifndef AFFINE_CIPHER_H
#define AFFINE_CIPHER_H

#include <string>

namespace affine_cipher {

std::string encode(std::string, int, int);
std::string decode(std::string, int, int);

}  // namespace affine_cipher

#endif  // AFFINE_CIPHER_H
