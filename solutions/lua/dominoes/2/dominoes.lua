
---@generic K, V
---@param xm { [K]: V }
---@param pred fun(k: K, v: V): boolean
---@return boolean
local function any(xm, pred)
	for k, v in pairs(xm) do
		if pred(k, v) then
			return true
		end
	end
	return false
end

---@generic K, V
---@param xm { [K]: V }
---@param pred fun(k: K, v: V): boolean
---@return boolean
local function all(xm, pred)
	for k, v in pairs(xm) do
		if not pred(k, v) then
			return false
		end
	end
	return true
end

local function append(xs, v)
	local ys = {}
	for _, x in ipairs(xs) do
		table.insert(ys, x)
	end
	table.insert(ys, v)
	return ys
end

local function find(xm, pred)
	for k, v in pairs(xm) do
		if pred(v) then
			return k
		end
	end
	return nil
end

---@generic T
---@param elt T
---@param lst T[]
---@param cmp? fun(x: T): boolean
---@return boolean
local function memberof(elt, lst, cmp)
	cmp = cmp or function(x) return x == elt end
	for _, v in pairs(lst) do
		if cmp(v) then
			return true
		end
	end
	return false
end

local function map(xm, f)
	local ym = {}
	for k, v in pairs(xm) do
		ym[k] = f(k, v)
	end
	return ym
end

local function vertex_eq(v1, v2)
	return (v1[1] == v2[1] and v1[2] == v2[2]) or (v1[1] == v2[2] and v1[2] == v2[1])
end

local function can_go(g, a, b)
	return any(g.assocs, function(_, v)
		return vertex_eq({a, b}, v) and v[3] > 0
	end)
end

local function go_to(g, a, b)
	if not can_go(g, a, b) then
		return nil
	else
		return {
			assocs = map(g.assocs, function(_, v)
				if vertex_eq({a, b}, v) then
					return { v[1], v[2], v[3]-1 }
				else
					return v
				end
			end),
			nodes = g.nodes,
		}
	end
end

local function neighbours_of(g, n)
	local ns = {}
	for _, v in pairs(g.assocs) do
		if v[1] == n and not find(ns, function(_, q) return v[1] == q end) then
			table.insert(ns, v[2])
		elseif v[2] == n and not find(ns, function(_, q) return v[2] == q end) then
			table.insert(ns, v[1])
		end
	end
	return ns
end

local function nodes(alist)
	local ns = {}
	local xs = map(alist, function(_, v) return v[1] end)
	local ys = map(alist, function(_, v) return v[2] end)
	for _, x in pairs(xs) do
		if not memberof(x, ns) then
			table.insert(ns, x)
		end
	end
	for _, y in pairs(ys) do
		if not memberof(y, ns) then
			table.insert(ns, y)
		end
	end
	return ns
end

local function from_assoc_list(alist)
	local g = { assocs = {}, nodes = {} }
	for _, p in pairs(alist) do
		local k = find(g.assocs, function(q) return vertex_eq(p, q) end)
		if k ~= nil then
			g.assocs[k][3] = g.assocs[k][3] + 1
		else
			table.insert(g.assocs, { p[1], p[2], 1 })
		end
	end
	g.nodes = nodes(alist)
	return g
end

local function find_full_cycle(g_)
	if #g_.nodes == 0 then
		return {}
	end

	local function aux(path, cur, g)
		local contains_all_nodes = all(g.nodes, function(_, n) return memberof(n, path, function(x) return x[1] == n end) end)
		local all_paths_consumed = all(g.assocs, function(_, v) return v[3] == 0 end)
		local forms_cycle = (#path <= 0) or (path[1][1] == cur)

		if contains_all_nodes and all_paths_consumed and forms_cycle then
			return path
		end

		for _, n in pairs(neighbours_of(g, cur)) do
			local new_g = go_to(g, cur, n)
			if new_g then
				local cycle = aux(append(path, {cur, n}), n, new_g)
				if cycle then
					return cycle
				end
			end
		end

		return nil
	end

	for _, n in pairs(g_.nodes) do
		local p = aux({}, n, g_)
		if p then
			return p
		end
	end

	return nil
end

local function can_chain(dominoes)
	return find_full_cycle(from_assoc_list(dominoes)) ~= nil
end

return { can_chain = can_chain }
