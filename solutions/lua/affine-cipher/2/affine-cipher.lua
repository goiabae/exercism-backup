local function chunk(str)
	local res = ""
	for i = 1, #str do
		res = res .. str:sub(i, i)
		if i % 5 == 0 and i ~= #str then
			res = res .. " "
		end
	end
	return res
end

local alphabet = "abcdefghijklmnopqrstuvwxyz"

local letters = {}
for i = 1, #alphabet do
	local c = alphabet:sub(i, i)
	local C = string.upper(c)
	letters[c] = i-1
	letters[i-1] = c
	letters[C] = i-1
end

local m = #alphabet

local function all(xs, f)
	for _, x in ipairs(xs) do
		if not f(x) then
			return false
		end
	end
	return true
end

local function primes(n)
	local ps = {}
	local i = 2
	local function f()
		if i > n then return nil end
		if all(ps, function(p) return i % p ~= 0 end) then
			table.insert(ps, i)
			local p = i
			i = i + 1
			return p
		else
			i = i + 1
			return f()
		end
	end
	return f
end

local function tot(n)
	local res = 1
	for p in primes(n) do
		if n % p == 0 then
			res = res * (1 - (1 / p))
		end
	end
	return res * n
end

local function mmi(a, m)
	return math.floor(a ^ (tot(m) - 1))
end

local function coprime(x, y)
	for i = 2, math.min(x, y) do
		if x % i == 0 and y % i == 0 then
			return false
		end
	end
	return true
end

local function filter(str)
	local res = ""
	for c in str:gmatch("[^%s,.]") do
		res = res .. c
	end
	return res
end

local function encode(phrase, key)
	if not coprime(key.a, m) then
		error("a and m must be coprime.")
	end
	return chunk(filter(phrase):gsub('%a', function(x)
		return letters[(key.a * letters[x] + key.b) % m]
	end))
end

local function decode(phrase, key)
	if not coprime(key.a, m) then
		error("a and m must be coprime.")
	end
	return filter(phrase):gsub('%a', function(y)
		return letters[(mmi(key.a, m) * (letters[y] - key.b)) % m]
	end)
end

return { encode = encode, decode = decode }
