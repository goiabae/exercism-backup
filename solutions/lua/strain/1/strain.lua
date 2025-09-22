local function keep(xs, pred)
	local ys = {}
	for _, v in pairs(xs) do
		if pred(v) then
			table.insert(ys, v)
		end
	end
	return ys
end

local function discard(xs, pred)
	return keep(xs, function(x) return not pred(x) end)
end

return { keep = keep, discard = discard }
