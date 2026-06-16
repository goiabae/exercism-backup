
local function list_rep (elt, n)
	local xs = {}
	for _ = 1, n do
		table.insert(xs, elt)
	end
	return xs
end

---@param num_rails integer
---@param text string
---@param is_encoding boolean
---@return string
local function code (num_rails, text, is_encoding)
	local coded = list_rep('A', #text)
	local dec = 0
	for n = 0, num_rails-1 do
		local middle = 0.5*(num_rails - ((num_rails & 1) ~ 1))
		local dist_from_middle = math.floor(math.abs(n - 0.5*(num_rails - 1)))
		---@type integer[]
		local offsets = {
			2*(math.floor(middle) - dist_from_middle),
			2*(num_rails - 1 - math.floor(middle) + dist_from_middle),
		}
		local flag = true
		local enc = n
		while enc < #text do
			if is_encoding then
				coded[dec+1] = text:sub(enc+1, enc+1)
			else
				coded[enc+1] = text:sub(dec+1, dec+1)
			end
			dec = dec + 1
			enc = enc + offsets[(flag ~= (offsets[1] ~= 0 and n > middle)) and 2 or 1]
			flag = (offsets[1] == 0) or not flag
		end
	end

	return table.concat(coded)
end

local function encode(plaintext, rail_count)
	return code(rail_count, plaintext, true)
end

local function decode(ciphertext, rail_count)
	return code(rail_count, ciphertext, false)
end

return { encode = encode, decode = decode }
