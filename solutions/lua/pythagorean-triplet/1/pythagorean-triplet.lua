local function idiv(a, b)
	return (a - (a % b)) / b
end

return function(sum)
	local triplets = {}
	for a = 1, idiv(sum, 3) + 1 do
		for b = a, idiv(sum-a, 2) + 1 do
			local c = sum-a-b
			if a*a + b*b == c*c then
				table.insert(triplets, {a, b, c})
			end
		end
	end
	return triplets
end
