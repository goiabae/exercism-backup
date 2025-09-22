local function gcd(a, b)
	while b ~= 0 do
		local t = b
		b = a % b
		a = t
	end
	return a
end

local function reduce(a)
	if a[2] < 0 then
		a[1] = -a[1]
		a[2] = -a[2]
	end
	local d = gcd(a[1], a[2])
	if d > 1 then
		return { a[1] / d, a[2] / d }
	end
	return a
end

local function add(a, b)
	return reduce({ a[1]*b[2] + b[1]*a[2], a[2]*b[2] })
end

local function subtract(a, b)
	return reduce({ a[1]*b[2] - b[1]*a[2], a[2]*b[2] })
end

local function multiply(a, b)
	return reduce({ a[1]*b[1], a[2]*b[2] })
end

local function divide(a, b)
	return reduce({ a[1]*b[2], a[2]*b[1] })
end

local function abs(a)
	local b = reduce(a)
	if b[1] < 0 then
		return { -b[1], b[2] }
	end
	return b
end

local function exp_rational(a, p)
	return reduce({ a[1] ^ p, a[2] ^ p })
end

local function exp_real(p, a)
	a = reduce(a)
	local xp = a[1] / a[2]
	return p ^ xp
end

return {
  add = add,
  subtract = subtract,
  multiply = multiply,
  divide = divide,
  abs = abs,
  exp_rational = exp_rational,
  exp_real = exp_real,
  reduce = reduce
}
