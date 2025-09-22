return function(n)
	local sigs = {}
	if ((n & 1) ~= 0) then table.insert(sigs, "wink") end
	if ((n & 2) ~= 0) then table.insert(sigs, "double blink") end
	if ((n & 4) ~= 0) then table.insert(sigs, "close your eyes") end
	if ((n & 8) ~= 0) then table.insert(sigs, "jump") end
	if ((n & 16) ~= 0) then
		local reversed = {}
		for i = #sigs, 1, -1 do
			table.insert(reversed, sigs[i])
		end
		return reversed
	end
	return sigs
end
