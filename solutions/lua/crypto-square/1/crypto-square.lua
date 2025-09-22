return {
  ciphertext = function(plaintext)
		local normalized = ""
		for match in string.gmatch(plaintext, "[^%s%p]+") do
			normalized = normalized .. string.lower(match)
		end
		local width = math.floor(math.sqrt(#normalized))
		local height = math.ceil(math.sqrt(#normalized))
		if (width * height) < #normalized then
			width = height
		end
		local res = {}
		for i = 1, width do
			local x = normalized:sub(1, height)
			normalized = normalized:sub(height+1)
			table.insert(res, x)
		end
		local res2 = {}
		for j = 1, height do
			local x = ""
			for i = 1, width do
				x = x .. res[i]:sub(j, j)
			end
			local y = ("%-" .. tostring(width) .. "s"):format(x)
			table.insert(res2, y)
		end
		return table.concat(res2, ' ')
  end
}
