local function is_saddle(n, m, mat, i, j)
	for k = 1, n do
		if k ~= i and mat[k][j] < mat[i][j] then
			return false
		end
	end
	for k = 1, m do
		if k ~= j and mat[i][k] > mat[i][j] then
			return false
		end
	end
	return true
end

return function(matrix)
	local points = {}
	for i = 1, #matrix do
		for j = 1, #(matrix[1]) do
			if is_saddle(#matrix, #(matrix[1]), matrix, i, j) then
				table.insert(points, { row = i, column = j })
			end
		end
	end
	return points
end
