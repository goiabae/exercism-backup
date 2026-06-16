
local function list_print (p)
	return function (xs)
		local s = ''
		s = s .. '{'
		for _, x in ipairs(xs) do
			s = s .. ' ' .. p(x)
		end
		s = s .. ' }'
		return s
	end
end

local function quoted (s)
	return '"' .. s .. '"'
end

local printer = list_print(function (x) return quoted(tostring(x)) end)

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
	if s == ' ||_ _ ||' then
		return 0
	end
	if x1 == ' ' and y1 == ' ' and z1 == ' ' and x2 == ' ' and y2 == ' ' and z2 == ' ' and x3 == ' ' and y3 == '|' and z3 == '|' then
		return 1
	end
	if x1 == ' ' and y1 == ' ' and z1 == '|' and x2 == '_' and y2 == '_' and z2 == '_' and x3 == ' ' and y3 == '|' and z3 == ' ' then
		return 2
	end
	if x1 == ' ' and y1 == ' ' and z1 == ' ' and x2 == '_' and y2 == '_' and z2 == '_' and x3 == ' ' and y3 == '|' and z3 == '|' then
		return 3
	end
	if x1 == ' ' and y1 == '|' and z1 == ' ' and x2 == ' ' and y2 == '_' and z2 == ' ' and x3 == ' ' and y3 == '|' and z3 == '|' then
		return 4
	end
	if x1 == ' ' and y1 == '|' and z1 == ' ' and x2 == '_' and y2 == '_' and z2 == '_' and x3 == ' ' and y3 == ' ' and z3 == '|' then
		return 5
	end
	if x1 == ' ' and y1 == '|' and z1 == '|' and x2 == '_' and y2 == '_' and z2 == '_' and x3 == ' ' and y3 == ' ' and z3 == '|' then
		return 6
	end
	if x1 == ' ' and y1 == ' ' and z1 == ' ' and x2 == '_' and y2 == ' ' and z2 == ' ' and x3 == ' ' and y3 == '|' and z3 == '|' then
		return 7
	end
	if x1 == ' ' and y1 == '|' and z1 == '|' and x2 == '_' and y2 == '_' and z2 == '_' and x3 == ' ' and y3 == '|' and z3 == '|' then
		return 8
	end
	if x1 == ' ' and y1 == '|' and z1 == ' ' and x2 == '_' and y2 == '_' and z2 == '_' and x3 == ' ' and y3 == '|' and z3 == '|' then
		return 9
	end
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
