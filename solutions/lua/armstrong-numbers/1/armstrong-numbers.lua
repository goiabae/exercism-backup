local ArmstrongNumbers = {}

function ArmstrongNumbers.is_armstrong_number(number)
	if number < 10 then return true end

	local acc = number
	local res = 0
	local len = math.floor(math.log(number, 10) + 1)
	local i = 0
	while i ~= len do
		i = i + 1
		res = res + ((acc % 10) ^ len)
		acc = (acc - (acc % 10)) / 10
	end
	return number == res;
end

return ArmstrongNumbers
