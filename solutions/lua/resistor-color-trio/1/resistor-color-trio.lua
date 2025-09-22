COLORS = {
	black = 0,
	brown = 1,
	red = 2,
	orange = 3,
	yellow = 4,
	green = 5,
	blue = 6,
	violet = 7,
	grey = 8,
	white = 9
}

return {
	decode = function(c1, c2, c3)
		local acc = (10 * COLORS[c1] + COLORS[c2]) * 10 ^ COLORS[c3]

		local unit = 0
		while acc > 1000 do
			acc = (acc - (acc % 1000)) / 1000
			unit = unit +	 1
		end

		local units = {"", "kilo", "mega", "giga"}
		return acc, units[unit+1] .. "ohms"
		end
}
