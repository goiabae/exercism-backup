
---@param str string
---@param delimiter string
---@return string[]
local function string_split(str, delimiter)
	local result = {}
	for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

local t = {
	[' ||_ _ ||'] = 0,
	['       ||'] = 1,
	['  |___ | '] = 2,
	['   ___ ||'] = 3,
	[' |  _  ||'] = 4,
	[' | ___  |'] = 5,
	[' ||___  |'] = 6,
	['   _   ||'] = 7,
	[' ||___ ||'] = 8,
	[' | ___ ||'] = 9,
}

local function match (lines, i, j)
	if not (i <= (#lines-3)) then
		return nil
	end
	local x1 = lines[i]:sub(j, j)
	local y1 = lines[i+1]:sub(j, j)
	local z1 = lines[i+2]:sub(j, j)
	local x2 = lines[i]:sub(j+1, j+1)
	local y2 = lines[i+1]:sub(j+1, j+1)
	local z2 = lines[i+2]:sub(j+1, j+1)
	local x3 = lines[i]:sub(j+2, j+2)
	local y3 = lines[i+1]:sub(j+2, j+2)
	local z3 = lines[i+2]:sub(j+2, j+2)
	local s = x1 .. y1 .. z1 .. x2 .. y2 .. z2 .. x3 .. y3 .. z3
	return t[s]
end

return {
  convert = function(str)
		local lines = string_split(str, '\n')
		local m = 0
		for _, line in ipairs(lines) do
			m = math.max(m, #line)
		end
		for _, line in ipairs(lines) do
			if #line ~= m then
				error()
			end
		end
		local s = ''
		for i = 1, #lines, 4 do
			for j = 1, #(lines[1]), 3 do
				local n = match(lines, i, j)
				if not n then
					s = s .. '?'
				else
					s = s .. tostring(n)
				end
			end
			if i < (#lines-3) then
				s = s .. ','
			end
		end
		return s
  end
}
