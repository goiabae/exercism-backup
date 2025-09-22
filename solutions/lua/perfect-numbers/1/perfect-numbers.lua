local function aliquot_sum(n)
	local sum = 0
	local fac = 1
	while fac < n do
		if n % fac == 0 then
			sum = sum + fac
		end
		fac = fac + 1
	end
	return sum
end

local function classify(n)
	local sum = aliquot_sum(n)
	if sum < n then return "deficient" end
	if sum == n then return "perfect" end
	if sum > n then return "abundant" end
end

return { aliquot_sum = aliquot_sum, classify = classify }
