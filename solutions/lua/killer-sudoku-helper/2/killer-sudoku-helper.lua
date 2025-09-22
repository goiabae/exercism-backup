local function append(xs, elt)
	local ys = {}
	for _, x in ipairs(xs) do
		table.insert(ys, x)
	end
	table.insert(ys, elt)
	return ys
end

local function memberof(elt, lst)
	for _, x in ipairs(lst) do
		if elt == x then
			return true
		end
	end
	return false
end

local function combinations(sum, size, exclude)
	local function aux(acc, sum, size)
		local all_combs = {}
		-- numbers strictly increasing
		for i = (acc[#acc] or 0) + 1, 9 do
			if exclude and memberof(i, exclude) then
				goto continue
			elseif sum == i and size == 1 then
				return { append(acc, i) }
			end
			for _, comb in ipairs(aux(append(acc, i), sum - i, size - 1)) do
				table.insert(all_combs, comb)
			end
			::continue::
		end
		return all_combs
	end
	return aux({}, sum, size)
end

return { combinations = combinations }
