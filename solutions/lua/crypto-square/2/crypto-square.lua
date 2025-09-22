return {
  ciphertext = function(plaintext)
		local normalized = ""
		for match in string.gmatch(plaintext, "[^%s%p]+") do
			normalized = normalized .. string.lower(match)
		end
		local width = math.floor(math.sqrt(#normalized))
		local height = math.ceil(math.sqrt(#normalized))
		if (width * height) < #normalized then
			local m = math.max(height, width)
			width, height = m, m
		end
		local res = {}
		for i = 0, height-1 do
			local x = ""
			for j = 0, height-1 do
				local k = 1+j*height+i
				x = x .. normalized:sub(k, k)
			end
			local y = ("%-" .. tostring(width) .. "s"):format(x)
			table.insert(res, y)
		end
		return table.concat(res, " ")
  end
}
