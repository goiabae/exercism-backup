
---@generic T, U
---@param xs T[]
---@param f function (acc: U, x: T): U
---@return U
local function fold (xs, init, f)
	local acc = init
	for i = 1, #xs do
		acc = f(acc, xs[i])
	end
	return acc
end

---@generic T, U
---param xs T[]
---@param f function (x: T): U
---@return U[]
local function array_map (xs, f)
	local ys = {}
	for i = 1, #xs do
		table.insert(ys, f(xs[i]))
	end
	return ys
end

---@param str string
---@return string[]
local function string_to_array (str)
	local cs = {}
	for c in string.gmatch(str, ".") do
		table.insert(cs, c)
	end
	return cs
end

---@generic T, U
---@param xs T[]
---@param f function (i: integer, x: T): U[]
---@return U[]
local function array_concat_mapi (xs, f)
	local ys = {}
	for i = 1, #xs do
		local zs = f(i, xs[i])
		for j = 1, #zs do
			table.insert(ys, zs[j])
		end
	end
	return ys
end

---@generic T, U
---@param xs T[]
---@param f function (i: integer, x: T): U?
---@return U[]
local function array_filter_mapi (xs, f)
	local ys = {}
	for i = 1, #xs do
		local y = f(i, xs[i])
		if y then
			table.insert(ys, y)
		end
	end
	return ys
end

---@generic T
---@param xs T[]
---@param f function (x: T): boolean
---@return T[]
local function array_filter (xs, f)
	local ys = {}
	for i = 1, #xs do
		if f(xs[i]) then
			table.insert(ys, xs[i])
		end
	end
	return ys
end

---@generic T
---@param xs T[]
---@param pos integer
---@param len integer
---@return T[]
local function array_sub(xs, pos, len)
	local ys = {}
	for i = pos, pos + len - 1 do
		table.insert(ys, xs[i])
	end
	return ys
end

local function array_for_all (xs, f)
	for i = 1, #xs do
		if not f(xs[i]) then
			return false
		end
	end
	return true
end

local sum_map = function (xs, f) return fold(xs, 0, function (acc, it) return acc + f(it) end) end
local vert_side = function (c) return c == "+" or c == "|" end
local hori_side = function (c) return c == "+" or c == "-" end

---@param rows string[]
---@return integer
local function count_rectangles (rows)
	local rows = array_map(rows, string_to_array)
	local grid = array_concat_mapi(rows, function (i, row)
		return array_filter_mapi(row, function (j, c)
			if c == "+" then
				return { i, j }
		  else
				return nil
			end
		end)
	end)
	return sum_map(grid, function (p1)
		local i1, j1 = table.unpack(p1)
		local same_row = array_filter(grid, function (p) return p[1] == i1 and p[2] > j1 end)
		local same_column = array_filter(grid, function (p) return p[2] == j1 and p[1] > i1 end)
		return sum_map(same_row, function (p2)
			local i2, j2 = table.unpack(p2)
			return sum_map(same_column, function (p2_)
				local i2, j1 = table.unpack(p2_)
				return sum_map(grid, function (p)
					local i = p[1]
					local j = p[2]
					if not (i == i2 and j == j2) then
						return 0
					end
					local top_side = array_for_all(array_sub(rows[i1], j1, j2 - j1), hori_side)
					local bottom_side = array_for_all(array_sub(rows[i2], j1, j2 - j1), hori_side)
					local left_side = array_for_all(array_map(array_sub(rows, i1, i2 - i1), function (it) return it[j1] end), vert_side)
					local right_side = array_for_all(array_map(array_sub(rows, i1, i2 - i1), function (it) return it[j2] end), vert_side)
					if left_side and right_side and top_side and bottom_side then return 1 else return 0 end
				end)
			end)
		end)
	end)
end

return { count = count_rectangles }
