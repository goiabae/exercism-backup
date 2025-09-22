return {
  valid = function(isbn)
		local digits = {}
		for c in string.gmatch(isbn, ".") do
			if string.match(c, "%d") then
				table.insert(digits, tonumber(c))
			elseif c == "X" and string.sub(isbn, #isbn, #isbn) == "X" then
				table.insert(digits, 10)
			elseif string.match(c, "%a") then
				return false
			end
		end
		if #digits ~= 10 then
			return false
		end
		local sum = 0
		for i = 1, #digits do
			local j = #digits - i + 1
			sum = sum + i*digits[j]
		end
		return sum % 11 == 0
  end
}
