local function list_skip (xs, n)
	local ys = {}
	for i = n+1, #xs do
		table.insert(ys, xs[i])
	end
	return ys
end

local function append (xs, z)
	local ys = {}
	for _, x in ipairs(xs) do
		table.insert(ys, x)
	end
	table.insert(ys, z)
	return ys
end

local function prepend (z, xs)
	local ys = { z }
	for _, x in ipairs(xs) do
		table.insert(ys, x)
	end
	return ys
end

---@alias tree [string, tree[] | nil]

---@param children tree[]
---@param node_name string
---@return (tree | nil), tree[]
local function remove_child (children, node_name)
	local new_children = {}
	local removed = nil
	for _, child in ipairs(children) do
		if child[1] ~= node_name then
			table.insert(new_children, child)
		else
			removed = child
		end
	end
	return removed, new_children
end

---@param old_parent tree | nil
---@param tree tree
local function reparent (old_parent, tree, path)
	if #path == 0 then
		if tree[2] then
			return { tree[1], append(tree[2], old_parent) }
		else
			return { tree[1], { old_parent } }
		end
	end
	local new_parent, new_children = remove_child(tree[2], path[1])
	assert(new_parent)
	local a = append(new_children, old_parent)
	local n1 = (function ()
		if #a > 0 then
			return { tree[1], a }
		else
			return { tree[1] }
		end
	end)()
	return reparent(n1, new_parent, list_skip(path, 1))
end

local function path_to (tree, node_name)
	if tree[1] == node_name then
		return { tree[1] }
	end
	for _, child in ipairs(tree[2] or {}) do
		local subpath = path_to(child, node_name)
		if subpath then
			return prepend(tree[1], subpath)
		end
	end
	return nil
end

local function pov_from(node_name)
	local function of (tree)
		if tree[1] == node_name then
			return tree
		end
		local path = path_to(tree, node_name)
		if not path then error() end
		return reparent(nil, tree, list_skip(path, 1))
	end
	return { of = of }
end

local function path_from(source)
	return { to = function (destination)
		return { of = function (tree)
			local reparented_tree = pov_from(source).of(tree)
			if not reparented_tree then error() end
			local path = path_to(reparented_tree, destination)
			if not path then error() end
			return path
		end }
	end }
end

return { pov_from = pov_from, path_from = path_from }
