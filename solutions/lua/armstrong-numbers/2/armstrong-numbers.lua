local ArmstrongNumbers = {}

function ArmstrongNumbers.is_armstrong_number(number)
	if number < 10 then return true end
	local acc = number
	local res = 0
	local len = math.floor(math.log(number, 10) + 1)
	for _ = 0, len do
		res = res + ((acc % 10) ^ len)
		acc = (acc - (acc % 10)) / 10
	end
	return number == res;
end

return ArmstrongNumbers
