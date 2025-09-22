ALLERGENS = {
	["eggs"] = 1 << 0,
	["peanuts"] = 1 << 1,
	["shellfish"] = 1 << 2,
	["strawberries"] = 1 << 3,
	["tomatoes"] = 1 << 4,
	["chocolate"] = 1 << 5,
	["pollen"] = 1 << 6,
	["cats"] = 1 << 7,
}

local function allergic_to(score, which)
	return (score & ALLERGENS[which]) ~= 0
end

local function list(score)
	local xs = {}
	for k, v in pairs(ALLERGENS) do
		if allergic_to(score, k) then
			table.insert(xs, k)
		end
	end
	table.sort(xs, function(a, b) return ALLERGENS[a] < ALLERGENS[b] end)
	return xs
end

return { list = list, allergic_to = allergic_to }
