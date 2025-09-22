local function list_eq(xs, ys)
	if #xs ~= #ys then return false end
	for i = 1, #xs do
		if xs[i] ~= ys[i] then
			return false
		end
	end
	return true
end

local function chars(str)
	local word_chars = {}
	str:lower():gsub('.', function(c)
		table.insert(word_chars, c)
		return c
	end)
	table.sort(word_chars)
	return word_chars
end

---@class Anagram
---@field word string
local Anagram = {}
Anagram.__index = Anagram

---@param word string
---@return Anagram
function Anagram:new(word)
	return setmetatable({ word = word }, Anagram)
end

---@param candidates string[]
---@return string[]
function Anagram:match(candidates)
	local word_chars = chars(self.word)
	local anagrams = {}
	for _, candidate in ipairs(candidates) do
		if candidate:lower() == self.word:lower() or #candidate ~= #self.word then
			goto continue
		end
		local candidate_chars = chars(candidate)
		if list_eq(word_chars, candidate_chars) then
			table.insert(anagrams, candidate)
		end
		::continue::
	end
	return anagrams
end

return Anagram
