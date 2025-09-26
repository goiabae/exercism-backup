#pragma once

#include <map>
#include <vector>
#include <string_view>

namespace parallel_letter_frequency {

std::map<char, int> frequency(std::vector<std::string_view>);

}
