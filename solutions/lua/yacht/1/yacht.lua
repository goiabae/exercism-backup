---@param xs integer[]
---@return integer[]
local function sorted(xs)
	local ys = {}
	for _, v in pairs(xs) do
		table.insert(ys, v)
	end
	table.sort(ys)
	return ys
end

---@generic K, V
---@param xm { [K]: V }
---@param pred fun(k: K, v: V): boolean
---@return boolean
local function all(xm, pred)
	for k, v in pairs(xm) do
		if not pred(k, v) then
			return false
		end
	end
	return true
end

---@generic T
---@param set T[]
---@return { [T]: integer }
local function frequencies(set)
	local res = {}
	for _, x in pairs(set) do
		res[x] = (res[x] or 0) + 1
	end
	return res
end

---@generic T
---@param set T[]
---@param pred fun(v: T): boolean
---@return boolean
local function any(set, pred)
	for _, v in pairs(set) do
		if pred(v) then
			return true
		end
	end
	return false
end


---@generic T
---@param x T
---@param set T[]
---@return boolean
local function memberof(x, set)
	for _, v in pairs(set) do
		if x == v then
			return true
		end
	end
	return false
end

---@param xs integer[]
---@return integer
local function sum(xs)
	local acc = 0
	for _, x in pairs(xs) do
		acc = acc + x
	end
	return acc
end

---@generic T
---@param xs T[]
---@param pred fun(x: T): boolean
---@return integer
local function count(xs, pred)
	local acc = 0
	for _, x in pairs(xs) do
		if pred(x) then
			acc = acc + 1
		end
	end
	return acc
end

local yacht = {}

local cat_to_num = {
	['ones'] = 1,
	['twos'] = 2,
	['threes'] = 3,
	['fours'] = 4,
	['fives'] = 5,
	['sixes'] = 6,
}

local function is_little_straight(dice)
	return all(sorted(dice), function(i, d) return d == i end)
end

local function is_big_straight(dice)
	return all(sorted(dice), function(i, d) return d == (i+1) end)
end

local function is_yacht(dice)
	local prev = dice[1]
	for i, d in ipairs(dice) do
		if i ~= 1 then
			if d ~= prev then
				return false
			end
			prev = d
		end
	end
	return true
end

local function has_same(dice, count)
	local counts = frequencies(dice)
	return any(counts, function(v) return v == count end)
end

local function has_same_or_bigger(dice, count)
	local counts = frequencies(dice)
	return any(counts, function(v) return v >= count end)
end

local function is_category(dice, category)
	if category == 'full house' then
		return has_same(dice, 2) and has_same(dice, 3)
	elseif category == 'four of a kind' then
		return has_same_or_bigger(dice, 4)
	elseif category == 'little straight' then
		return is_little_straight(dice)
	elseif category == 'big straight' then
		return is_big_straight(dice)
	elseif category == 'yacht' then
		return is_yacht(dice)
	else
		return true
	end
end

---@return integer
local function count_same(dice, count)
	for d, v in pairs(frequencies(dice)) do
		if v >= count then
			return d
		end
	end

	return 0
end

---@param dice integer[]
---@return integer
function yacht.score(dice, category)
	if not is_category(dice, category) then
		return 0
	end

	if memberof(category, {'ones', 'twos', 'threes', 'fours', 'fives', 'sixes'}) then
		local num = cat_to_num[category]
		local acc = count(dice, function(d) return d == num end)
		return num * acc
	elseif memberof(category, {'full house', 'choice'}) then
		return sum(dice)
	elseif category == 'four of a kind' then
		return count_same(dice, 4) * 4
	elseif category == 'choice' then
		return sum(dice)
	elseif memberof(category, {'little straight', 'big straight'}) then
		return 30
	elseif category == 'yacht' then
		return 50
	else
		assert(false)
		return -1
	end
end

return yacht
