return function(input)
	local factors = {}
	for i = 2, input do
		if input == 1 then
			break
		end
		while input % i == 0 do
			table.insert(factors, i)
			input = input / i
		end
	end
	return factors
end
