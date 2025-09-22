return function(which)
	local letter_count = string.byte(which) - string.byte('A') + 1
	local row_count = letter_count*2 - 1
	local res = ""

	for row_idx = 0, row_count-1 do
		local i = (row_idx < letter_count) and row_idx or (row_count-row_idx-1)
		local letter = string.char(string.byte('A') + i)
		local row = ""
		for col = 0, row_count-1 do
			local center_dist = math.abs(col - letter_count + 1)
			row = row .. ((center_dist == i) and letter or ' ')
		end
		res = res .. row .. "\n"
	end
	return res
end
