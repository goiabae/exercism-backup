---@param xs integer[]
---@param beg integer
---@param end_ integer | nil
---@return integer[]
local function slice (xs, beg, end_)
	end_ = end_ or -1
	end_ = (end_ == -1) and #xs or end_
	local res = {}
	for i = beg, end_-1 do
		table.insert(res, xs[i+1])
	end
	return res
end

---@param xs integer[]
---@param count integer
---@return integer[][]
local function group (xs, count)
	local res = {}
	local i = 0
	while i < #xs do
		if (i + count) > #xs then
			table.insert(res, slice(xs, i))
			break
		else
			table.insert(res, slice(xs, i, i+count))
		end
		i = i + count
	end
	return res
end

---@param str string
---@return integer[]
local function digits_of (str)
	local res = {}
	for c in string.gmatch(str, '.') do
		table.insert(res, string.byte(c) - string.byte('0'))
	end
	return res
end

---@param index integer
---@return string
local function milliard_spec (index)
	local ys = {"", "thousand", "million", "billion"}
	if index > 0 then
		return " " .. ys[index+1]
	else
		return ""
	end
end

local DIGITS = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
local DEZENA = {"", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"}
local DEZ = {"ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}

local function list_rev (xs)
	local ys = {}
	for i = #xs, 1, -1 do
		table.insert(ys, xs[i])
	end
	return ys
end

local function zip (i1, i2)
	return function()
		local a = i1()
		local b = i2()
		if a ~= nil and b ~= nil then
			return a, b
		end
	end
end

---@alias iterator<T...> fun (): T...?


local function list_iter (seq)
	local i = 1
	return function()
		if i > #seq then return nil end
		i = i + 1
		return i-1, seq[i-1]
	end
end

---@generic T..., U...
---@param it iterator<T...>
---@param f fun (T...): U...
---@return iterator<U...>
local function iter_map (it, f)
	return function ()
		return (function (a, ...)
			if a == nil then
				return nil
			end
			return f(a, ...)
		end)(it())
	end
end

local function in_english (number)
	if not (0 <= number and number <= 999999999999) then
		return -1
	end

	local digits = tostring(number)
	digits = string.reverse(digits)
	local milliards = group(digits_of(digits), 3)
	---@type string[]
	local res = {}

	local it = iter_map(list_iter(milliards), function (i, x) return milliard_spec(i-1), x end)
	for spec, milliard in it do
		-- [x]
		if #milliard == 1 then
			local x  =  milliard[0+1]
			table.insert(res, DIGITS[x+1] .. spec)
		elseif #milliard == 2 then
			local x = milliard[0+1]
			local y = milliard[1+1]
			if y == 1 then -- [x, 1]
				table.insert(res, DEZ[x+1] .. spec)
			elseif x == 0 then -- [0, y]
				table.insert(res, DEZENA[y+1] .. spec)
			else -- [x, y]
				table.insert(res, DEZENA[y+1] .. '-' .. DIGITS[x+1] .. spec)
			end
		elseif #milliard == 3 then
			local x = milliard[0+1]
			local y = milliard[1+1]
			local z = milliard[2+1]
			if x == 0 and y == 0 and z == 0 then -- [0, 0, 0]
				do end
			elseif y == 0 and z == 0 then -- [x, 0, 0]
				table.insert(res, DIGITS[x+1] .. spec)
			elseif x == 0 and y == 0 then -- [0, 0, z]
				table.insert(res, DIGITS[z+1] .. " hundred" .. spec)
			elseif x == 0 then -- [0, y, z]
				table.insert(res, DIGITS[z+1] .. " hundred " .. DEZENA[y+1] .. spec)
			else -- [x, y, z]
				table.insert(res, DIGITS[z+1] .. " hundred " .. DEZENA[y+1] .. "-" .. DIGITS[x+1] .. spec)
			end
		end
	end

	return table.concat(list_rev(res), " ")
end

return function(n)
	return in_english(n)
end
