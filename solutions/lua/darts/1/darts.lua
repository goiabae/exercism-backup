local Darts = {}

function Darts.score(x, y)
	local dist = math.sqrt(x*x + y*y)
	if dist <= 1 then
		return 10
	elseif dist <= 5 then
		return 5
	elseif dist <= 10 then
		return 1
	else
		return 0
	end
end

return Darts
