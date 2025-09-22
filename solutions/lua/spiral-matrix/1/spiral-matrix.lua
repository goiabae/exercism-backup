local function f(mat, side, pos, speed, counter)
	if counter > (side*side) then
		return mat
	end

	mat[pos[1]][pos[2]] = counter

	local npos = { pos[1]+speed[1], pos[2]+speed[2] }
	local outside_bounds = npos[1] < 1 or npos[1] > side or npos[2] < 1 or npos[2] > side
	if outside_bounds or mat[npos[1]][npos[2]] ~= false then
		speed = { speed[2], -speed[1] } -- rotate clock-wise
	end

	return f(mat, side, { pos[1]+speed[1], pos[2]+speed[2] }, speed, counter + 1)
end

return function(size)
	local mat = {}
	for i = 1, size do
		mat[i] = {}
		for j = 1, size do
			mat[i][j] = false
		end
	end
	return f(mat, size, { 1, 1 }, { 0, 1 }, 1)
end
