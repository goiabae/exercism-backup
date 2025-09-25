#include "two_bucket.h"

#include <array>
#include <optional>
#include <stdexcept>
#include <unordered_set>
#include <vector>
#include <cstddef>

namespace two_bucket {

enum class Action {
	FillOne,
	FillTwo,
	OneToTwo,
	TwoToOne,
	EmptyOne,
	EmptyTwo,
};

struct Bucket {
	int capacity;
	int volume;

	bool is_full() const { return volume == capacity; }
	bool is_empty() const { return volume == 0; }
	int available() const { return capacity - volume; }

	Bucket add(int n) const {
		if (n > available()) throw;
		return Bucket { capacity, volume + n };
	}
	Bucket remove(int n) const {
		if (n > volume) throw;
		return Bucket { capacity, volume - n };
	}
};

std::array actions {
	Action::FillOne,
	Action::FillTwo,
	Action::OneToTwo,
	Action::TwoToOne,
	Action::EmptyOne,
	Action::EmptyTwo,
};

struct HashPair {
	size_t operator()(const std::pair<int, int>& p) const noexcept {
		auto h1 = std::hash<int>{}(p.first);
		auto h2 = std::hash<int>{}(p.second);
		return h1 ^ (h2 + 0x9e3779b9 + (h1 << 6) + (h1 >> 2));
	}
};

std::array<Bucket, 2> do_action(std::array<Bucket, 2> buckets, Action action) {
	switch (action) {
	case Action::FillOne: return { Bucket { buckets[0].capacity, buckets[0].capacity }, buckets[1] };
	case Action::FillTwo: return { buckets[0], Bucket { buckets[1].capacity, buckets[1].capacity } };
	case Action::OneToTwo: {
		auto to_tx = std::min(buckets[0].volume, buckets[1].available());
		return {
			buckets[0].remove(to_tx),
			buckets[1].add(to_tx),
		};
	}
	case Action::TwoToOne: {
		auto to_tx = std::min(buckets[1].volume, buckets[0].available());
		return {
			buckets[0].add(to_tx),
			buckets[1].remove(to_tx),
		};
	}
	case Action::EmptyOne: return {
		buckets[0].remove(buckets[0].volume),
		buckets[1],
	};
	case Action::EmptyTwo: return {
		buckets[0],
		buckets[1].remove(buckets[1].volume),
	};
	}
	throw;
}

std::optional<std::vector<Action>> aux(
	const std::vector<Action>& action_chain,
	std::unordered_set<std::pair<int, int>, HashPair>& states,
	std::array<Bucket, 2> buckets,
	int target_volume,
	int start_bucket,
	int other_bucket
) {
	for (auto action : actions) {
		auto new_buckets = do_action(buckets, action);
		if (new_buckets[start_bucket].is_empty() and new_buckets[other_bucket].is_full())
			continue;

		auto state = std::make_pair(new_buckets[0].volume, new_buckets[1].volume);
		if (states.find(state) != states.end())
			continue;
		states.insert(state);

		auto new_action_chain = action_chain;
		new_action_chain.push_back(action);
		if (new_buckets[0].volume == target_volume or new_buckets[1].volume == target_volume)
			return new_action_chain;

		auto result = aux(new_action_chain, states, new_buckets, target_volume, start_bucket, other_bucket);
		if (result.has_value())
			return result;
	}
	return {};
}

measure_result measure(
	int bucket1_capacity,
	int bucket2_capacity,
	int target_volume,
	bucket_id start_bucket
) {
	std::vector<Action> action_chain {};
	std::unordered_set<std::pair<int, int>, HashPair> states {};
	std::array start_buckets { Bucket { bucket1_capacity, 0 }, Bucket { bucket2_capacity, 0 } };
	int start_index = (start_bucket == bucket_id::one) ? 0 : 1;
	int other_index = (start_index + 1) % 2;

	auto result_chain = aux(action_chain, states, start_buckets, target_volume, start_index, other_index);

	if (not result_chain.has_value())
		throw std::domain_error("couldn't achieve target volume");

	auto buckets = start_buckets;
	for (auto action : result_chain.value())
		buckets = do_action(buckets, action);

	auto num_moves = (int)result_chain.value().size();
	auto goal_bucket = buckets[0].volume == target_volume ? bucket_id::one : bucket_id::two;
	auto other_bucket_volume = buckets[0].volume == target_volume ? buckets[1].volume : buckets[0].volume;
	return measure_result { num_moves, goal_bucket, other_bucket_volume };
}

}  // namespace two_bucket
