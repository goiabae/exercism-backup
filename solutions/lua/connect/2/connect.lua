local function parse(board_str)
	local rows = {}
	for i = 1, #board_str do
		rows[i] = {}
		for c in string.gmatch(board_str[i], "[^ ]") do
			table.insert(rows[i], c)
		end
	end
	rows.height = #rows
	rows.width = rows[1] and #rows[1] or 0
	return rows
end

local function find_path(board, visited, i, j, c, at_end)
	visited[i] = visited[i] or {}
	visited[i][j] = true
	if i < 1 or i > board.height or j < 1 or j > board.width or board[i][j] ~= c then
		return false
	elseif at_end(i, j) then
		return true
	end
	local dirs = {
		{-1, 0},
		{-1, 1},
		{0, -1},
		{0, 1},
		{1, -1},
		{1, 0}
	}
	for _, dir in ipairs(dirs) do
		local coord = { i+dir[1], j+dir[2] }
		if not (visited[coord[1]] and visited[coord[1]][coord[2]]) and find_path(board, visited, coord[1], coord[2], c, at_end) then
			return true
		end
	end
	return false
end

return {
  winner = function(board_str)
		local board = parse(board_str)
		local left_right = function(i, j) return j == board.width end
		local top_bottom = function(i, j) return i == board.height end
		local function find_any_path(c)
			for i = 1, board.height do
				if find_path(board, {}, i, 1, c, left_right) then
					return c
				end
			end
			for j = 1, board.width do
				if find_path(board, {}, 1, j, c, top_bottom) then
					return c
				end
			end
		end
		return find_any_path("X") or find_any_path("O") or ''
  end
}
