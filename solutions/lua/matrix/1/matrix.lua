return function(s)
	local mat = {}

	for row in string.gmatch(s, "[%d ]+") do
		local a = {}
		for num in string.gmatch(row, "%d+") do
			table.insert(a, tonumber(num))
		end
		table.insert(mat, a)
	end

	function mat.row(i)
		return mat[i]
	end

	function mat.column(i)
		local res = {}
		for j = 1, #mat do
			table.insert(res, mat[j][i])
		end
		return res
	end

	return mat
end
