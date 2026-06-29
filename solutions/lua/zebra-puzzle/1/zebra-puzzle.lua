
---@alias Nationality
---| "norwegian"
---| "ukranian"
---| "englishman"
---| "spaniard"
---| "japanese"

---@type { integer:Nationality }
local t1 = {
[0] = "norwegian",
[1] = "ukranian",
[2] = "englishman",
[3] = "spaniard",
[4] = "japanese",
}

---@alias Color
---| "red"
---| "blue"
---| "yellow"
---| "ivory"
---| "green"

---@type { integer:Color }
local t2 = {
[0] = "red",
[1] = "blue",
[2] = "yellow",
[3] = "ivory",
[4] = "green",
}

---@alias Drink
---| "tea"
---| "milk"
---| "coffee"
---| "orange_juice"
---| "water"

---@type { integer:Drink }
local t3 = {
[0] = "tea",
[1] = "milk",
[2] = "coffee",
[3] = "orange_juice",
[4] = "water",
}

---@alias Smoke
---| "lucky_strike"
---| "old_gold"
---| "kools"
---| "chesterfield"
---| "parliaments"

---@type { integer:Smoke }
local t4 = {
	[0] = "lucky_strike",
	[1] = "old_gold",
	[2] = "kools",
	[3] = "chesterfield",
	[4] = "parliaments",
}

---@alias Pet
---| "zebra"
---| "fox"
---| "horse"
---| "snail"
---| "dog"

---@type { integer:Pet }
local t5 = {
	[0] = "zebra",
	[1] = "fox",
	[2] = "horse",
	[3] = "snail",
	[4] = "dog",
}

---@alias House { nationality: Nationality | nil, color: Color | nil, drink: Drink | nil, smoke: Smoke | nil, pet: Pet | nil }
---@alias PartialState [House, House, House, House, House]

local function xor (a, b)
	if a then
		if b then
			return false
		else
			return true
		end
	else
		if b then
			return true
		else
			return false
		end
	end
end

---@param state PartialState
local function is_valid (state)
	for i = 0, 4 do
		local house = state[i+1]
		local prev_house = (function () if i > 0 then return state[i-1+1] else return nil end end)()
		local next_house = (function () if i < 4 then return state[i+1+1] else return nil end end)()
		if
			(house.nationality and house.color and xor((house.nationality == "englishman"), (house.color == "red")))
			or (house.nationality and house.pet and xor((house.nationality == "spaniard"), (house.pet == "dog")))
			or (house.color and house.drink and xor((house.color == "green"), (house.drink == "coffee")))
			or (house.nationality and house.drink and xor((house.nationality == "ukranian"), (house.drink == "tea")))
			or (house.pet and house.smoke and xor((house.pet == "snail"), (house.smoke == "old_gold")))
			or (house.smoke and house.color and xor((house.color == "yellow"), (house.smoke == "kools")))
			or (house.smoke and house.drink and xor((house.smoke == "lucky_strike"), (house.drink == "orange_juice")))
			or (house.nationality and house.smoke and xor((house.nationality == "japanese"), (house.smoke == "parliaments")))
			or (i == 2 and house.drink and house.drink ~= "milk")
			or (i == 0 and house.nationality and house.nationality ~= "norwegian")
			or (house.color and prev_house and (prev_house.color and xor(house.color == "green", prev_house.color == "ivory")))
			or (house.smoke == "chesterfield" and (not (((prev_house or {}).pet or "fox") == "fox" or ((next_house or {}).pet or "fox") == "fox")))
			or (house.smoke == "kools" and (not (((prev_house or {}).pet or "horse") == "horse" or ((next_house or {}).pet or "horse") == "horse")))
			or (house.nationality == "norwegian" and (not ((prev_house and (prev_house.color or "blue") == "blue") or ((next_house or {}).color or "blue") == "blue")))
		then return false end
	end
	return true
end

local find_base = function (_, _) return true end

local function find (other, member, lut)
	local function recur (state, i)
		local function get_field (k) return state[k+1][member] end
		local function set_field (k, v) state[k+1][member] = v return v end
		for n = 0, 4 do
			local elt = lut[n]
			local already_used = false
			local j = 0
			while j < i and not already_used do
				already_used = already_used or elt == get_field(j)
				j = j + 1
			end
			if already_used then goto continue end
			set_field(i, elt)
			if (is_valid(state)) then
				if i == 4 then
					if other(state, 0) then
						return true
					end
				else
					if recur(state, i+1) then
						return true
					end
				end
			end
			::continue::
		end
		set_field(i, nil)
		return false
	end
	return recur
end

local function solve ()
	local state = {{}, {}, {}, {}, {}}
	local f = find(find(find(find(find(find_base, "pet", t5), "smoke", t4), "drink", t3), "color", t2), "nationality", t1)
	f(state, 0)
	local solution = {}
	for _, house in ipairs(state) do
		if house.nationality ~= nil then
			if house.drink == "water" then
				solution.drinks_water = house.nationality
			else
				solution.owns_zebra = house.nationality
			end
		end
	end
	return solution
end

local solution = solve()

local zebra_puzzle = {}

local lut = {
	["norwegian"] = "Norwegian",
	["ukranian"] = "Ukranian",
	["englishman"] = "Englishman",
	["spaniard"] = "Spaniard",
	["japanese"] = "Japanese",
}

function zebra_puzzle.drinks_water()
	return lut[solution.drinks_water]
end

function zebra_puzzle.owns_zebra()
	return lut[solution.owns_zebra]
end

return zebra_puzzle
