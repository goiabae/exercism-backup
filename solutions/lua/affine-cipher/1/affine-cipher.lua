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

local function tot(n)
	local primes = {}
	local res = 1
	for i = 2, n do
		if all(primes, function(p) return i % p ~= 0 end) and n % i == 0 then
			table.insert(primes, i)
			res = res * (1 - (1 / i))
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
	return chunk(filter(phrase):gsub('.', function(x)
		if string.match(x, "%d") then
			return x
		else
			return letters[(key.a * letters[x] + key.b) % m]
		end
	end))
end

local function decode(phrase, key)
	if not coprime(key.a, m) then
		error("a and m must be coprime.")
	end
	return filter(phrase):gsub('.', function(y)
		if string.match(y, "%d") then
			return y
		else
			return letters[(mmi(key.a, m) * (letters[y] - key.b)) % m]
		end
	end)
end

return { encode = encode, decode = decode }
