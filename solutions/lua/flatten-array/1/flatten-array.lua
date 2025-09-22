local function flatten(input)
	local res = {}
	for i = 1, #input do
		local elt = input[i]
		if elt and type(elt) == "number" then
			table.insert(res, elt)
		elseif elt and type(elt) == "table" then
			elt = flatten(elt)
			for _, subelt in ipairs(elt) do
				table.insert(res, subelt)
			end
		end
	end
	return res
end

return flatten
