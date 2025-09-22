local Hamming = {}

function Hamming.compute(a, b)
	if #a ~= #b then
		return -1
	end
	local dist = 0
	for i = 1, #a do
		dist = dist + ((string.sub(a, i, i) ~= string.sub(b, i, i)) and 1 or 0)
	end
	return dist
end

return Hamming
