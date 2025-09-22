local function triangle(i, j)
	if i < 0 or j < 0 then return 0 end
	if i == 0 and j == 0 then return 1 end
	return triangle(i - 1, j - 1) + triangle(i - 1, j)
end

return function(rows)
	local tri = {}
	if rows == 0 then
		return { rows = tri }
	end
	for i = 0, rows-1 do
		tri[i+1] = {}
		for j = 0, i do
			tri[i+1][j+1] = triangle(i, j)
		end
	end
	return { rows = tri, last_row = tri[#tri] }
end
