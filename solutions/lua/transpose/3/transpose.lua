---@param str string
---@param sep string
---@return string[]
local function split_on(str, sep)
	local res = {}
	local beg, fin = 1, 1
	while fin <= #str do
		if str:sub(fin, fin) == sep then
			local s = str:sub(beg, fin-1) or ''
			table.insert(res, s)
			beg, fin = fin+1, fin+1
		else
			fin = fin + 1
		end
	end
	table.insert(res, str:sub(beg))
	return res
end

local function fold(xs, init, f)
	local acc = init
	for i, x in ipairs(xs) do
		acc = f(acc, i, x)
	end
	return acc
end

local function reverse(xs)
	return setmetatable({}, {
			__index = function (_, key)
				return xs[#xs - key + 1]
			end
	})
end

---@param s string
---@return string
return function(s)
	local lines = split_on(s, "\n")
	-- fold over lines in reverse, padding to the left with the current maximum width
	do
		local cur = 0
		for i = #lines, 1, -1 do
			cur = math.max(cur, #lines[i])
			lines[i] = ("%-" .. tostring(cur) .. "s"):format(lines[i])
		end
		for _, line in ipairs(reverse(lines)) do
			print(line)
		end
	end
	local height = #lines
	local width = fold(lines, 0, function(width, _, line) return math.max(width, #line) end)
	local transposed = {}
	for i = 1, width do
		local x = ""
		for j = 1, height do
			x = x .. lines[j]:sub(i, i)
		end
		table.insert(transposed, x)
	end
	return table.concat(transposed, "\n")
end
