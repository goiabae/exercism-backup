
local function fix (x, f)
	return function (...)
		return f(x, ...)
	end
end

local function list_iter (xs, f)
	for _, x in ipairs(xs) do
		f(x)
	end
end

local function list_filter (xs, p)
	local ys = {}
	for _, x in ipairs(xs) do
		if p(x) then
			table.insert(ys, x)
		end
	end
	return ys
end

---@generic T
---@param xs T[]
---@param ys T[]
---@return T[]
local function concat (xs, ys)
	local zs = {}
	for _, x in ipairs(xs) do
		table.insert(zs, x)
	end
	for _, y in ipairs(ys) do
		table.insert(zs, y)
	end
	return zs
end

local function recompute (cell)
	local new_value = cell.get_value()
	if not (cell.value == new_value) then
		cell.value = new_value
		return list_iter(cell.callbacks, function (p) local cb = p[2] return cb(cell.get_value()) end)
	end
end

local function create_input_cell (value)
	local cell = {
		get_value = function () return value end,
		callbacks = {},
		next_cbid = 0,
	}
	cell.set_value = function (v) value = v; recompute(cell) end
	return cell
end

local function add_callback (cell, k)
	local id = cell.next_cbid
	cell.callbacks = concat(cell.callbacks, {{id, k}})
	cell.next_cbid = id + 1
	return id
end

local function remove_callback (cell, to_remove)
	cell.callbacks = list_filter(cell.callbacks, function (p)
		local cb = p[2]
		return cb ~= to_remove
	end)
end


local function create_compute_cell_1 (a, f)
	local cell = {
		get_value = function () return f(a.get_value()) end,
		value = f(a.get_value()),
		callbacks = {},
		next_cbid = 0,
	}
	add_callback(a, function (_) return recompute(cell) end)
	cell.watch = fix(cell, add_callback)
	cell.unwatch = fix(cell, remove_callback)
	return cell
end

local function create_compute_cell_2 (a, b, f)
	local cell = {
		value = f(a.get_value(), b.get_value()),
		get_value = function () return f(a.get_value(), b.get_value()) end,
		callbacks = {},
		next_cbid = 0,
	}
	cell.watch = fix(cell, add_callback)
	cell.unwatch = fix(cell, remove_callback)
	add_callback(a, (function (_) return recompute(cell) end))
	add_callback(b, (function (_) return recompute(cell) end))
	return cell
end

local function compute_cell (...)
	local args = { ... }
	if #args == 2 then
		return create_compute_cell_1(args[1], args[2])
	elseif #args == 3 then
		return create_compute_cell_2(args[1], args[2], args[3])
	else
		error()
	end
end

local function Reactor()
	return {
		InputCell = create_input_cell,
		ComputeCell = compute_cell,
	}
end

return { Reactor = Reactor }
