local function at(mat, i, j)
	if i < 1 or j < 1 or i > #mat or j > #(mat[#mat]) then return 0 end
	return mat[i][j]
end

local function tick(matrix)
	local new_matrix = {}
	for i = 1, #matrix do
		new_matrix[i] = {}
		for j = 1, #matrix[#matrix] do
			local cell = matrix[i][j]
			local live_neighbours = 0
				+ at(matrix, i-1, j-1) + at(matrix, i-1, j) + at(matrix, i-1, j+1)
				+ at(matrix, i, j-1)                        + at(matrix, i, j+1)
				+ at(matrix, i+1, j-1) + at(matrix, i+1, j) + at(matrix, i+1, j+1)
			if cell == 1 and (live_neighbours == 2 or live_neighbours == 3) or (cell == 0 and live_neighbours == 3) then
				new_matrix[i][j] = 1
			else
				new_matrix[i][j] = 0
			end
		end
	end
	return new_matrix
end

return { tick = tick }
