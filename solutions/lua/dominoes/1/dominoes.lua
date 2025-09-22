
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
local function for_all(xm, pred)
	for k, v in pairs(xm) do
		if not pred(k, v) then
			return false
		end
	end
	return true
end

---@generic K, V, W
---@param xm { [K]: V }
---@param f fun(k: K, v: V) W?
---@return W?
local function find_map(xm, f)
	for k, v in pairs(xm) do
		local r = f(k, v)
		if r ~= nil then
			return r
		end
	end
	return nil
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

local function contains(lst, elt)
	for _, v in pairs(lst) do
		if v[1] == elt then
			return true
		end
	end
	return false
end

local function memberof(elt, lst)
	for _, v in pairs(lst) do
		if v == elt then
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

---@param v1 [integer, integer]
---@param v2 [integer, integer]
---@return boolean
local function vertex_eq(v1, v2)
	return (v1[1] == v2[1] and v1[2] == v2[2]) or (v1[1] == v2[2] and v1[2] == v2[1])
end

---@class WUGraph
---@field assocs [integer, integer, integer][]
local WUGraph = {}
WUGraph.__index = WUGraph

function WUGraph.can_go(g, a, b)
	return any(g.assocs, function(k, v)
		return vertex_eq({a, b}, {v[1], v[2]}) and v[3] > 0
	end)
end

---@return WUGraph?
function WUGraph.go_to(g, a, b)
	if not WUGraph.can_go(g, a, b) then
		return nil
	else
		return {
			assocs = map(g.assocs, function(_, v)
				if vertex_eq({a, b}, v) then
					return { v[1], v[2], v[3]-1 }
				else
					return v
				end
			end)
		}
	end
end

---@param g WUGraph
---@param n integer
---@return integer[]
function WUGraph.neighbours_of(g, n)
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

---@param g WUGraph
---@return integer[]
function WUGraph.nodes(g)
	local ns = {}
	local xs = map(g.assocs, function(_, v) return v[1] end)
	local ys = map(g.assocs, function(_, v) return v[2] end)
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

function WUGraph.print(g)
	print()
	for _, v in pairs(g.assocs) do
		if v[3] > 1 then
			print(("%d <-%d-> %d"):format(v[1], v[3], v[2]))
		else
			print(("%d <-> %d"):format(v[1], v[2]))
		end
	end
	for _, n in pairs(WUGraph.nodes(g)) do
		print(n)
	end
end

---@param alist [integer, integer][]
---@return WUGraph
function WUGraph.from_assoc_list(alist)
	local g = setmetatable({ assocs = {} }, WUGraph)
	for _, p in pairs(alist) do
		local a = p[1]
		local b = p[2]
		local k = find(g.assocs, function(q) return (p[1] == q[1] and p[2] == q[2]) or (p[1] == q[2] and p[2] == q[1]) end)
		if k ~= nil then
			g.assocs[k][3] = g.assocs[k][3] + 1
		else
			table.insert(g.assocs, { a, b, 1 })
		end
	end
	return g
end

---@param g WUGraph
---@return integer[]?
function WUGraph.find_full_cycle(g_)
	---@param path [integer, integer][]
	---@param cur integer
	---@param g WUGraph
	---@return [integer, integer][]?
	local function aux(path, cur, g)
		local cond1 = (#path <= 0) or (path[1][1] == cur)
		local contains_all_nodes = for_all(WUGraph.nodes(g), function(_, n) return contains(path, n) end)
		local all_paths_consumed = for_all(g.assocs, function(_, v) return v[3] == 0 end)
		if cond1 and contains_all_nodes and all_paths_consumed then
			return path -- FIXME: maybe reversed
		else
			return find_map(WUGraph.neighbours_of(g, cur), function(_, n)
				local new_g = WUGraph.go_to(g, cur, n)
				if new_g == nil then
					return nil
				end
				return aux(append(path, {cur, n}), n, new_g)
			end)
		end
	end
	if #(WUGraph.nodes(g_)) == 0 then
		return {}
	else
		return find_map(WUGraph.nodes(g_), function(_, n) return aux({}, n, g_) end)
	end
end

local function chain(dominoes)
	local graph = WUGraph.from_assoc_list(dominoes)
	return WUGraph.find_full_cycle(graph)
end

local function can_chain(dominoes)
	return chain(dominoes) ~= nil
end

return { can_chain = can_chain }
