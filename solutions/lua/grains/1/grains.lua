local grains = {}

function grains.square(n)
	return math.pow(2, n - 1)
end

function grains.total()
	local acc = 0
	for i = 1, 64 do
		acc = acc + grains.square(i)
	end
	return acc
end

return grains
