ALPHA = "abcdefghijklmnopqrstuvwxyz"

return {
  rotate = function(input, key)
		local conv = {}
		for i = 1, #ALPHA do
			local j = ((i - 1 + key) % 26) + 1
			local from = ALPHA:sub(i, i)
			local to = ALPHA:sub(j, j)
			conv[from] = to
		end
		return input:gsub(".", function(c)
			if c:match("%u") then
				return conv[c:lower()]:upper()
			elseif c:match("%l") then
				return conv[c]
			else
				return c
			end
		end)
  end
}
