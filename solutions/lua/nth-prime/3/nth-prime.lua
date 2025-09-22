return function(number)
	if number <= 0 then
		error("")
	end

	local ps = {}
	local i = 2
	while #ps < number do
		local is_prime = true
		for j = 1, #ps do
			local p = ps[j]
			if p*p > i then
				break
			end
			if i % p == 0 then
				is_prime = false
				break
			end
		end
		if is_prime then
			table.insert(ps, i)
		end
		i = i + 1
	end
	return ps[#ps]
end
