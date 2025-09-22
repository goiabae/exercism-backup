local EliudsEggs = {}

function EliudsEggs.egg_count(number)
	local count = 0
	while number > 0 do
		count = count + (((number % 2) == 1) and 1 or 0)
		number = (number - (number % 2)) / 2
	end
	return count
end

return EliudsEggs
