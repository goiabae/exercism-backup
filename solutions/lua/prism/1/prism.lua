
---@param a number
---@return number
local function normalize (a)
	return (a + 360) % 360
end

--            P  -
--           /|  |
--          / |  | dy
--         /  |  |
-- counter/   |  |
-- clock /    |  |
--   +- /) th |  |
--   | C------+  -
--   +>|------|
--   dx
---@param x number
---@param y number
---@param angle number
---@param prism { id: integer, x: number, y: number, angle: number }
---@return boolean
local function in_line (x, y, angle, prism)
	local dx = prism.x - x
	local dy = prism.y - y

	-- ensure it's positive, going counter-clockwise
	local th = normalize(((math.atan(dy, dx) * 180) / math.pi))

	-- need to do this because we are in modular (mod 360) arithmetic land
	-- and we could have things like 0.0 and 359.99 being very close while in opposite ends
	local err = math.min(math.abs(th - angle), 360 - math.abs(th - angle))
	return err < 0.05
end

local function distance (a, b)
	local dx, dy = a[1] - b[1], a[2] - b[2]
	return math.sqrt(dx*dx + dy*dy)
end

---@param start { x: number, y: number, angle: number }
---@param prisms { id: integer, x: number, y: number, angle: number }[]
local function find_sequence (start, prisms)
	---@type integer[]
	local path = {}
	local x, y, angle = start.x, start.y, normalize(start.angle)
	while true do
		local d = math.maxinteger
		local p = nil
		for _, prism in ipairs(prisms) do
			if (not (prism.x == x and prism.y == y)) and in_line(x, y, angle, prism) then
				local a = distance({ x, y }, { prism.x, prism.y })
				if a < d then
					d, p = a, prism
				end
			end
		end
		if p then
			x, y, angle = p.x, p.y, normalize(angle + p.angle)
			table.insert(path, p.id)
		else
			break
		end
	end
	return path
end

return { find_sequence = find_sequence }
