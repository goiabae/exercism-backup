local PhoneNumber = {}
PhoneNumber.__index = PhoneNumber

local invalid = {
	number = "0000000000"
}

function PhoneNumber:new(str)
	if string.match(str, "[%d.() -]+") ~= str then
		return invalid
	end
	local phone = {
		number = ""
	}
	setmetatable(phone, PhoneNumber)
	for c in string.gmatch(str, "%d") do
		phone.number = phone.number .. c
	end
	if #phone.number == 9 then
		return invalid
	end
	if #phone.number == 11 then
		if string.sub(phone.number, 1, 1) ~= "1" then
			return invalid
		else
			phone.number = string.sub(phone.number, 2)
		end
	end
	return phone
end

function PhoneNumber:areaCode()
	return string.sub(self.number, 1, 3)
end

function PhoneNumber:__tostring()
	return string.format("(%d) %d-%d", self.number:sub(1, 3), self.number:sub(4, 6), self.number:sub(7, 10))
end

return PhoneNumber
