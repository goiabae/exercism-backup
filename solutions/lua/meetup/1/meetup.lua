local function euc (x, y)
	return ((x % y) + y) % y
end

local function int_of_day (d)
	return ({
		["Monday"] = 0,
		["Tuesday"] = 1,
		["Wednesday"] = 2,
		["Thursday"] = 3,
		["Friday"] = 4,
		["Saturday"] = 5,
		["Sunday"] = 6,
	})[d] + 1
end

---@param fst day
---@param sched schedule
---@param count integer
---@param day day
local function find_day_int (fst, sched, count, day)
	local o = int_of_day(fst)
	local h = int_of_day(day)
	local d = 1 + euc(h - o, 7)
	local m = (function ()
		if sched == "first" then
			return 0
		elseif sched == "second" then
			return 1
		elseif sched == "third" then
			return 2
		elseif sched == "fourth" then
			return 3
		elseif sched == "last" then
			return math.floor((count - d) / 7)
		elseif sched == "teenth" then
			return 1 + ((d < 6) and 1 or 0)
		else
			error()
		end
	end)()
	return d + 7 * m
end

local function leap_year (y)
	return (y % 4 == 0) and ((y % 100 ~= 0) or (y % 400 == 0))
end

---@alias schedule
---| "teenth"
---| "first"
---| "second"
---| "third"
---| "fourth"
---| "last"

---@alias day
---| "Monday"
---| "Tuesday"
---| "Wednesday"
---| "Thursday"
---| "Friday"
---| "Saturday"
---| "Sunday"

---@alias config { year: integer, month: integer, week: schedule, day: day }

---@return integer
local function days_in_month (d)
	local l = leap_year(d.year)
	local t = {
		31, 28 + (l and 1 or 0), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	}
	return t[d.month]
end

---@return day
local function day_of_week (d)
	local q = d.day
	local m = d.month + 12*((d.month < 3) and 1 or 0)
	local y = d.year - 1*((d.month < 3) and 1 or 0)
	local K = y % 100
	local J = math.floor(y / 100)
	local h = (q + math.floor((13 * (m + 1)) / 5) + K + math.floor(K / 4) + math.floor(J / 4) + 5*J) % 7
	---@type day[]
	local t = { "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday" }
	return t[h + 1]
end

---@param config config
return function(config)
	local schedule = config.week
	local fst = { year = config.year, month = config.month, day = 1 }
	local first_weekday = day_of_week(fst)
	local day_count = days_in_month(fst)
	local day = find_day_int(first_weekday, schedule, day_count, config.day)
	return day
end
