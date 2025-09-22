local function copy(xs)
	local ys = {}
	for k, v in ipairs(xs) do
		ys[k] = v
	end
	return ys
end

local function change(total_amount, values)
	if total_amount < 0 then
		error("target can't be negative")
	end

	---@type { [integer]: integer }
	local smallest = {}

	local function aux(amount)
		if smallest[amount] then
			return smallest[amount]
		end

		if amount == 0 then
			return {}
		end

		for _, v in ipairs(values) do
			if v <= amount then
				local chain = aux(amount - v)
				if chain ~= nil then
					chain = copy(chain)
					table.insert(chain, v)
					if smallest[amount] == nil or #chain < #(smallest[amount]) then
						table.sort(chain)
						smallest[amount] = chain
					end
				end
			end
		end

		return smallest[amount]
	end

	local chain = aux(total_amount)
	if chain == nil then
		error("can't make target with given coins")
	end
	return chain
end

return change
