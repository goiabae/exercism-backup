
local function population (bv)
	local acc = 0
	while bv ~= 0 do
		acc = acc + (bv & 0x1)
		bv = bv >> 1
	end
	return acc
end

local lut = { 800*1*1.0, 800*2*0.95, 800*3*0.90, 800*4*0.80, 800*5*0.75 }

local function bit (bv, n)
	return (bv >> (n - 1)) & 0x1
end

local function mask (v, n)
	return (v ~= 0) and (1 << (n - 1)) or 0
end

local function f (xs, l, v)
	local h = string.format("%d;%d;%d;%d;%d", xs[1], xs[2], xs[3], xs[4], xs[5])
	if v[h] then return v[h] end
	local t = math.maxinteger
	local s = l
	while s ~= 0 do
		local p = population(s)
		for i = 1, 5 do
			xs[i] = xs[i] - bit(s, i)
		end
		local l2 = mask(xs[1], 1) | mask(xs[2], 2) | mask(xs[3], 3) | mask(xs[4], 4) | mask(xs[5], 5)
		local d = lut[p] + f(xs, l2, v)
		for i = 1, 5 do
			xs[i] = xs[i] + bit(s, i)
		end
		t = math.min(t, d)
		s = (s - 1) & l
	end
	v[h] = t
	return t
end

local function total(basket)
	local b = { 0, 0, 0, 0, 0}
	for _, x in ipairs(basket) do
		b[x] = b[x] + 1
	end
	local m = mask(b[1], 1) | mask(b[2], 2) | mask(b[3], 3) | mask(b[4], 4) | mask(b[5], 5)
	return f(b, m, { ['0;0;0;0;0'] = 0 })
end

return { total = total }
