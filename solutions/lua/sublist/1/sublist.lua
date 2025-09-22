return function(sublist, list)
	for r = 0, #list - #sublist + 1 do
		local all_eq = true
		for i = 1, #sublist do
			if list[i+r] ~= sublist[i] then
				all_eq = false
			end
		end
		if all_eq then
			return true
		end
	end
	return false
end
