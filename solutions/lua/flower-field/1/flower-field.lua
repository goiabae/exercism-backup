local function annotate(garden)
	local res = {}
	local height = #garden
	local width = garden[1] and #garden[1] or 0
	local function at(i, j)
		if i < 1 or i > height or j < 1 or j > width or garden[i]:sub(j, j) == ' ' then
			return 0
		else
			return 1
		end
	end
	for i = 1, height do
		local row = ""
		for j = 1, width do
			local neighbours =
				at(i-1, j-1) + at(i-1, j) + at(i-1, j+1) +
				at(i, j-1) + at(i, j+1) +
				at(i+1, j-1) + at(i+1, j) + at(i+1, j+1)
			if garden[i]:sub(j, j) == '*' then
				row = row .. '*'
			elseif neighbours == 0 then
				row = row .. ' '
			else
				row = row .. tostring(neighbours)
			end
		end
		res[i] = row
	end
	return res
end

return { annotate = annotate }
