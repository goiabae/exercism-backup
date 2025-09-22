local xs = {
	["AEIOULNRST"] = 1,
	["DG"] = 2,
	["BCMP"] = 3,
	["FHVWY"] = 4,
	["K"] = 5,
	["JX"] = 8,
	["QZ"] = 10
}

local function score(word)
	local res = 0
	if word == nil then
		return res
	end
	for c in string.gmatch(word, ".") do
		for k, v in pairs(xs) do
			if string.match(string.upper(c), "[" .. k .. "]") then
				res = res + v
				break
			end
		end
	end
	return res
end

return { score = score }
