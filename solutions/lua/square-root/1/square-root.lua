local SquareRoot = {}

function SquareRoot.square_root(radicand)
	local r = radicand;
	local err = 0E-10
	while (math.abs(radicand - r*r) > err) do
		r = (r + (radicand / r)) / 2
	end
	return r
end

return SquareRoot
