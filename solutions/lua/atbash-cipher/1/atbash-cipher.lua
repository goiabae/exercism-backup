ALPHABET = "abcdefghijklmnopqrstuvwxyz"

local function slice(xs, from, to)
	local res = {}
	for i = from+1, to do
		table.insert(res, xs[i])
	end
	return res
end

local function group(xs, count)
	local res = {}
	local i = 0
	while i < #xs do
		if (i + count) > #xs then
			table.insert(res, slice(xs, i, #xs))
			break
		else
			table.insert(res, slice(xs, i, i+count))
		end
		i = i + count
	end
	return res
end

local function concat(xs, sep)
	local res = ""
	for i = 1, #xs do
		if i ~= 1 then
			res = res .. sep
		end
		res = res .. xs[i]
	end
	return res
end

local function map(xs, f)
	local res = {}
	for i = 1, #xs do
		table.insert(res, f(xs[i]))
	end
	return res
end

return {
  encode = function(plaintext)
		local conv = {}
		for i = 1, #ALPHABET do
			local a = string.sub(ALPHABET, i, i)
			local b = string.sub(ALPHABET, #ALPHABET - i + 1, #ALPHABET - i + 1)
			conv[a] = b
		end

		local letters = {}
		for i = 1, #plaintext do
			local c = string.sub(plaintext, i, i)
			if string.match(c, "%a") then
				table.insert(letters, conv[string.lower(c)])
			elseif string.match(c, "%d") then
				table.insert(letters, c)
			end
		end

		local groups = group(letters, 5)
		local words = map(groups, function(c) return concat(c, "") end)
		return concat(words, " ")
  end
}
