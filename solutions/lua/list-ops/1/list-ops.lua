local function reduce(xs, init, f)
	local acc = init
	for i = 1, #xs do
		acc = f(xs[i], acc)
	end
	return acc
end

local function map(xs, f)
	local ys = {}
	for k, v in pairs(xs) do
		ys[k] = f(v)
	end
	return ys
end

local function filter(xs, pred)
	local ys = {}
	for _, v in pairs(xs) do
		if pred(v) then
			table.insert(ys, v)
		end
	end
	return ys
end

return { map = map, reduce = reduce, filter = filter }
