local baffling_birthdays = {}

baffling_birthdays.shared_birthday = function(birthdates)
	local seen = {}
	for _, x in ipairs(birthdates) do
		local a = string.sub(x, 6)
		if seen[a] then
			return true
		end
		seen[a] = true
	end
	return false
end

math.randomseed(os.time())

local function is_leap (year)
	return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

---@return string
local function random_birthdate ()
	local y = math.floor((math.random()*1000 % 1000) + 1900)
	if is_leap(y) then return random_birthdate() end
	local m = math.floor((math.random()*100 % 12) + 1)
	local d = math.floor((math.random()*100 % 31) + 1)
	local x = ("%04d-%02d-%02d"):format(y, m, d)
	return x
end

baffling_birthdays.random_birthdates = function(count)
	local ds = {}
	for _ = 1, count do
		table.insert(ds, random_birthdate())
	end
	return ds
end

baffling_birthdays.estimated_probability_of_shared_birthday = function(group_size)
	local x = 1
	for i = 0, group_size-1 do
		x = x * ((365 - i) / 365)
	end
	return 100 * (1 - x)
end

return baffling_birthdays
