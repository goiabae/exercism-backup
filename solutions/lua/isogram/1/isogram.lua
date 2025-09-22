return function(s)
	local ls = {}
	for i = 1, #s do
		local c = string.lower(string.sub(s, i, i))
		if c ~= "-" and c ~= " " then
			if ls[c] ~= nil then
				return false
			end
			ls[c] = true
		end
	end
	return true
end
