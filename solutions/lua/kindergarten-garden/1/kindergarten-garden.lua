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

local plant_names = {
	["V"] = "violets",
	["R"] = "radishes",
	["C"] = "clover",
	["G"] = "grass",
}

return function(s)
	local diagram = split_on(s, "\n")
	local garden = {}
	function garden.plants(student)
		local idx = student:sub(1, 1):byte() - string.byte("A")
		local res = {}
		for _, row in ipairs(diagram) do
			local d = row:sub(1+idx*2, 1+idx*2+1)
			assert(#d == 2)
			for p in string.gmatch(d, '.') do
				table.insert(res, plant_names[p])
			end
		end
		return res
	end
	return garden
end
