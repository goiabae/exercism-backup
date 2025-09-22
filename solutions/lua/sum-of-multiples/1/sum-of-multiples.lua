local function sum_keys(o)
	local acc = 0
	for k, _ in pairs(o) do
		acc = acc + k
	end
	return acc
end

return function(factors)
	local res = {}
	function res.to(limit)
    local muls = {}

		for _, fac in ipairs(factors) do
			if fac ~= 0 then
				local i = 0
				while i*fac < limit do
					muls[i*fac] = true
					i = i + 1
				end
			end
		end

		return sum_keys(muls)
	end
	return res
end
