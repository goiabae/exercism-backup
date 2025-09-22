---@alias state
---| '"win"'
---| '"draw"'
---| '"ongoing"'

---@param board string[]
---@return state
local function gamestate(board)

	local all_marked = true
	local xs = 0
	local os = 0

	for i = 1, 3 do
		for j = 1, 3 do
			if board[i]:sub(j, j):match("X") then
				xs = xs + 1
			elseif board[i]:sub(j, j):match("O") then
				os = os + 1
			else
				all_marked = false
			end
		end
	end

	local x_row = false
	local o_row = false
	local x_col = false
	local o_col = false

	for _, line in pairs(board) do
		x_row = x_row or string.match(line, "XXX") ~= nil
		o_row = o_row or string.match(line, "OOO") ~= nil
	end

	for i = 1, 3 do
		local col = board[1]:sub(i, i) .. board[2]:sub(i, i) .. board[3]:sub(i, i)
		x_col = x_col or col == "XXX"
		o_col = o_col or col == "OOO"
	end

	local diag1 = board[1]:sub(1, 1) .. board[2]:sub(2, 2) .. board[3]:sub(3, 3)
	local diag2 = board[1]:sub(3, 3) .. board[2]:sub(2, 2) .. board[3]:sub(1, 1)

	if os > xs or math.abs(xs - os) > 1 or (x_row and (os >= xs or (all_marked and not x_col))) then
		error()
	end

	if x_row or o_row or x_col or o_col or diag1 == "XXX" or diag2 == "XXX" or diag1 == "OOO" or diag2 == "OOO" then
		return "win"
	elseif all_marked then
		return "draw"
	else
		return "ongoing"
	end
end

return { gamestate = gamestate }
