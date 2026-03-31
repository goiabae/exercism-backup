---@class Bucket
---@field capacity integer
---@field volume integer
local Bucket = {}

---@param init { capacity: integer, volume: integer }
---@return Bucket
function Bucket.new (init)
	return setmetatable(init, { __index = Bucket })
end

function Bucket:is_full ()
	return self.volume == self.capacity
end

function Bucket:is_empty ()
	return self.volume == 0
end

function Bucket:available ()
	return self.capacity - self.volume
end

---@param n integer
function Bucket:add (n)
	if n > self:available() then error() end
	return Bucket.new { capacity = self.capacity, volume = self.volume + n }
end

---@param n integer
function Bucket:remove (n)
	if n > self.volume then error() end
	return Bucket.new { capacity = self.capacity, volume = self.volume - n }
end

---@alias Action
---| "fill_one"
---| "fill_two"
---| "one_to_two"
---| "two_to_one"
---| "empty_one"
---| "empty_two"

---@type Action[]
local actions = {
	"fill_one",
	"fill_two",
	"one_to_two",
	"two_to_one",
	"empty_one",
	"empty_two",
}

---@param buckets [Bucket, Bucket]
---@param action Action
---@return [Bucket, Bucket]
local function do_action (buckets, action)
	if action == "fill_one" then
		return {
			Bucket.new { capacity = buckets[1].capacity, volume = buckets[1].capacity }, buckets[2]
		}
	elseif action == "fill_two" then
		return {
			buckets[1], Bucket.new { capacity = buckets[2].capacity, volume = buckets[2].capacity }
		}
	elseif action == "one_to_two" then
		local to_tx = math.min(buckets[1].volume, buckets[2]:available())
		return {
			buckets[1]:remove(to_tx),
			buckets[2]:add(to_tx),
		}
	elseif action == "two_to_one" then
		local to_tx = math.min(buckets[2].volume, buckets[1]:available())
		return {
			buckets[1]:add(to_tx),
			buckets[2]:remove(to_tx),
		}
	elseif action == "empty_one" then
		return {
			buckets[1]:remove(buckets[1].volume),
			buckets[2],
		}
	elseif action == "empty_two" then
		return {
			buckets[1],
			buckets[2]:remove(buckets[2].volume),
		}
	end
	error()
end

---@param action_chain Action[]
---@param states { [integer]: { [integer]: boolean } }
---@param buckets [Bucket, Bucket]
---@param target_volume integer
---@param start_bucket integer
---@param other_bucket integer
---@return boolean
local function aux (
	action_chain,
	states,
	buckets,
	target_volume,
	start_bucket,
	other_bucket
)
	for _, action in ipairs(actions) do
		local new_buckets = do_action(buckets, action)
		if (new_buckets[start_bucket]:is_empty() and new_buckets[other_bucket]:is_full()) then
			do end
		else
			local state = { new_buckets[1].volume, new_buckets[2].volume }
			if states[state[1]] and states[state[1]][state[2]] then
				do end
			else
				states[state[1]] = states[state[1]] or {}
				states[state[1]][state[2]] = true
				table.insert(action_chain, action)
				if new_buckets[1].volume == target_volume or new_buckets[2].volume == target_volume then
					return true
				end
				local result = aux(action_chain, states, new_buckets, target_volume, start_bucket, other_bucket)
				if result then return true end
				table.remove(action_chain)
			end
		end
	end
	return false
end

---@param args { bucket_one_capacity: integer, bucket_two_capacity: integer, goal_volume: integer, start_bucket: integer }
---@return { moves: integer, other_bucket_volume: integer, goal_bucket_volume: integer }
local function measure (args)
	local bucket1_capacity = args.bucket_one_capacity
	local bucket2_capacity = args.bucket_two_capacity
	local target_volume = args.goal_volume
	local start_bucket = args.start_bucket
	local action_chain = {} ---@type Action[]
	local states = {} ---@type { [integer]: { [integer]: boolean } }
	local start_buckets = { ---@type Bucket[]
		Bucket.new { capacity = bucket1_capacity, volume = 0 },
		Bucket.new { capacity = bucket2_capacity, volume = 0 }
	}
	local start_index = (start_bucket == 1) and 1 or 2
	local other_index = (start_bucket == 1) and 2 or 1

	local found_chain = aux(action_chain, states, start_buckets, target_volume, start_index, other_index)

	if not found_chain then
		error("couldn't achieve target volume")
	end

	local buckets = start_buckets
	for _, action in ipairs(action_chain) do
		buckets = do_action(buckets, action)
	end

	local num_moves = #action_chain
	local goal_bucket = buckets[1].volume == target_volume and 1 or 2
	local other_bucket_volume = buckets[1].volume == target_volume and buckets[2].volume or buckets[1].volume
	return {
		moves = num_moves,
		other_bucket_volume = other_bucket_volume,
		goal_bucket_number = goal_bucket,
	}
end


return { measure = measure }
