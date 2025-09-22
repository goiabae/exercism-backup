---@type { [string]: fun(a: integer, b: integer): integer }
local ops = {
	["plus"] = function(a, b) return a + b end,
	["minus"] = function(a, b) return a - b end,
	["multiplied"] = function(a, b) return a * b end,
	["divided"] = function(a, b) return a / b end,
}

---@alias kind
---| '"num"'
---| '"op"'

---@param terms [kind, string][]
---@return integer?
local function eval(terms)
	if #terms == 0 or terms[1][1] ~= "num" then
		return nil
	end
	local i = 2
	local acc = assert(tonumber(terms[1][2]))
	while i <= #terms do
		if terms[i][1] == "num" or not (terms[i][1] == "op" and terms[i+1] and terms[i+1][1] == "num") then
			return nil
		end
		acc = ops[terms[i][2]](acc, assert(tonumber(terms[i+1][2])))
		i = i + 2
	end
	return acc
end

---@param text string
---@return [kind, string][]?
local function parse(text)
	local terms = {}
	for word in string.gmatch(text, '[^ ?]+') do
		if word == "What" or word == "is" or word == "by" then
			goto continue
		end
		if string.match(word, '-?%d+') then
			table.insert(terms, { "num", word })
		else
			for name, _ in pairs(ops) do
				if name == word then
					table.insert(terms, { "op", name })
					goto continue
				end
			end
			return nil
		end
		::continue::
	end
	return terms
end

---@param question string
---@return integer
local function answer(question)
	return eval(parse(question) or error("Invalid question")) or error("Invalid question")
end

return { answer = answer }
