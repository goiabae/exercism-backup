ALPHA = "abcdefghijklmnopqrstuvwxyz"

return {
  rotate = function(input, key)
		local conv = {}
		for i = 1, #ALPHA do
			local j = ((i - 1 + key) % 26) + 1
			local from = ALPHA:sub(i, i)
			local to = ALPHA:sub(j, j)
			conv[from] = to
			conv[from:upper()] = to:upper()
		end
		return input:gsub(".", function(c)
			return c:match("%a") and conv[c] or c
		end)
  end
}
