ALPHA = "abcdefghijklmnopqrstuvwxyz"

return {
  rotate = function(input, key)
		local conv = {}
		for i = 1, #ALPHA do
			local from = string.sub(ALPHA, i, i)
			local j = ((i - 1 + key) % 26) + 1
			local to = string.sub(ALPHA, j, j)
			conv[from] = to
		end
		local res = ""
		for i = 1, #input do
			local c = string.sub(input, i, i)
			if string.match(c, "%u") then
				res = res .. string.upper(conv[string.lower(c)])
			elseif string.match(c, "%l") then
				res = res .. conv[c]
			else
				res = res .. c
			end
		end
		return res
  end
}
