
local function population (bv)
	local acc = 0
	while bv ~= 0 do
		acc = acc + (bv & 0x1)
		bv = bv >> 1
	end
	return acc
end

-- takes advantage of the fact that xs is strictly increasing
local function all_unique (xs, m)
	local acc = -1
	for i = 1, #xs do
		if ((m >> (i-1)) & 0x1) ~= 0 then
			if acc >= xs[i] then
				return false
			end
			acc = xs[i]
		end
	end
	return true
end

local lut = { 800*1*1.0, 800*2*0.95, 800*3*0.90, 800*4*0.80, 800*5*0.75 }

---@param xs integer[]
---@param m integer
---@param gm number
---@return number
local function f (xs, m, gm, v)
	if m == 0 then return 0 end
	if v[m] then return v[m] end
	local s = m
	local t = gm
	while s ~= 0 do
		local p = population(s)
		if p <= 5 and all_unique(xs, s) then
			local r = m ~ s
			local d = lut[p] + f(xs, r, t, v)
			t = math.min(t, d)
		end
		s = (s - 1) & m
	end
	v[m] = t
	return t
end

local function total(basket)
	local n = #basket
	if n == 0 then return 0 end
	local a = (1 << n) - 1
	local m = a
	table.sort(basket)
	local x = f(basket, m, math.maxinteger, {})
	return x
end

return { total = total }
