return function(n)
	if n <= 0 then error("Only positive numbers are allowed") end
	local i = 0
	while n ~= 1 do
		n = (n % 2 == 0) and n / 2 or 3*n + 1
		i = i + 1
	end
	return i
end
