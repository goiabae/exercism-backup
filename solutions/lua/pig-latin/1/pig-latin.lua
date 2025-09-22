---@return string[]
local function split(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local match
local function set_match(str, ...)
	local patterns = { ... }
	local tmp = nil
	for _, pattern in ipairs(patterns) do
		tmp = str:match(pattern)
		if tmp ~= nil then
			match = tmp
			return match
		else
			match = nil
		end
	end
end

---@param phrase string
return function(phrase)
	local res = {}
	for _, word in ipairs(split(phrase, " ")) do
		if set_match(phrase, "^[aeiou].*", "^xr.*", "^yt.*") then
			table.insert(res, phrase .. "ay")
		elseif set_match(word, "^[^aeiou]*qu") then
			table.insert(res, string.gsub(word, match, "") .. match .. "ay")
		elseif set_match(word, "^[^aeiou]+y") then
			local sub = string.sub(match, 1, #match-1)
			table.insert(res, string.gsub(word, sub, "") .. sub .. "ay")
		elseif set_match(word, "^[^aeiou]+") then
			table.insert(res, string.gsub(word, match, "") .. match .. "ay")
		end
	end
	return table.concat(res, " ")
end
