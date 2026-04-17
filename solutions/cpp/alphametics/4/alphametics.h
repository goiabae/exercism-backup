#include <map>
#include <optional>
#include <string>
#if !defined(ALPHAMETICS_H)
#define ALPHAMETICS_H

namespace alphametics {

std::optional<std::map<char, int>> solve(std::string);

}  // namespace alphametics

#endif  // ALPHAMETICS_H
