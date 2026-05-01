local function default ()
	return {
		played = 0,
		won = 0,
		drawn = 0,
		lost = 0,
		points = 0,
	}
end

---@param str string
---@param n integer
---@return string
local function pad_right (str, n)
	return str .. string.rep(' ', n - #str)
end

---@param str string
---@param n integer
---@return string
local function pad_left (str, n)
	return string.rep(' ', n - #str) .. str
end

return function(results)
	local teams = {}
	for _, line in ipairs(results) do
		if not string.match(line, "[@]") then
			local tup = {}
			for part in string.gmatch(line, "[^;]+") do
				table.insert(tup, part)
			end
			if #tup == 3 then
				local t1 = tup[1]
				local t2 = tup[2]
				teams[t1] = teams[t1] or default()
				teams[t2] = teams[t2] or default()
				local result = tup[3]
				if result == "win" then
					teams[t1].won = teams[t1].won + 1
					teams[t1].points = teams[t1].points + 3
					teams[t2].lost = teams[t2].lost + 1
					teams[t1].played = teams[t1].played + 1
					teams[t2].played = teams[t2].played + 1
				elseif result == "loss" then
					teams[t2].won = teams[t2].won + 1
					teams[t2].points = teams[t2].points + 3
					teams[t1].lost = teams[t1].lost + 1
					teams[t1].played = teams[t1].played + 1
					teams[t2].played = teams[t2].played + 1
				elseif result == "draw" then
					teams[t1].drawn = teams[t1].drawn + 1
					teams[t2].drawn = teams[t2].drawn + 1
					teams[t1].points = teams[t1].points + 1
					teams[t2].points = teams[t2].points + 1
					teams[t1].played = teams[t1].played + 1
					teams[t2].played = teams[t2].played + 1
				end
			end
		end
	end
	local header = 'Team                           | MP |  W |  D |  L |  P'
	local result = { header }
	local xs = {}
	for name, team in pairs(teams) do
		table.insert(xs, { name, team })
	end
	table.sort(xs, function (a, b)
		if a[2].points == b[2].points then
			return a[1] < b[1]
		else
			return a[2].points > b[2].points
		end
	end)
	for _, x in ipairs(xs) do
		local name, team = x[1], x[2]
		local str = ("%s | %s | %s | %s | %s | %s"):format(
			pad_right(name, #'Team                          '),
			pad_left(tostring(team.played), 2),
			pad_left(tostring(team.won), 2),
			pad_left(tostring(team.drawn), 2),
			pad_left(tostring(team.lost), 2),
			pad_left(tostring(team.points), 2)
		)
		table.insert(result, str)
	end
	return result
end
