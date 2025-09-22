return {
  valid = function(s)
		local nospaces = ""
		for str in string.gmatch(s, "[^%s]*") do
			nospaces = nospaces .. str
		end
		if (#nospaces <= 1) or (string.match(nospaces, "%d+") ~= nospaces) then
			return false
		end
		local digits = string.reverse(nospaces)
		local acc = 0
		for i = 1, #digits do
			local j = i-1
			local n = tonumber(string.sub(digits, i, i))
			if j % 2 == 0 then
				acc = acc + n
			elseif n > 4 then
				acc = acc + 2*n - 9
			else
				acc = acc + 2*n
			end
		end
		return acc % 10 == 0
  end
}
