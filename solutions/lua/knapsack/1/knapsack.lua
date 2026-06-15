local function maximum_value(maximum_weight, items)
	local W = maximum_weight
	local n = #items
	local m = {}
	for i = 0, (n+1)*(W+1) do
		m[i] = 0
	end
	local function at (i, j, v)
		if v then
			m[i*(W+1)+j] = v
		else
			return m[i*(W+1)+j]
		end
	end
	for i = 1, n do
		for j = 1, W do
			at(i, j, (function ()
				if items[i-1+1].weight > j then
					return at(i-1, j)
				else
					return math.max(at(i-1, j), at(i-1, j-items[i-1+1].weight) + items[i-1+1].value)
				end
			end)())
		end
	end
	return at(n, W)
end

return { maximum_value = maximum_value }
