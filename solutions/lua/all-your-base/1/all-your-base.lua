local all_your_base = {}

local function reversed(xs)
	local sx = {}
	for i = #xs, 1, -1 do
		table.insert(sx, xs[i])
	end
	return sx
end

all_your_base.convert = function(from_digits, from_base)
	if from_base < 2 then
		error("invalid input base")
	end

	for _, v in ipairs(from_digits) do
		if v < 0 then
			error("negative digits are not allowed")
		end
		if v > (from_base - 1) then
			error("digit out of range")
		end
	end

	local res = 0
	for i = 0, #from_digits-1 do
		res = res + from_digits[i+1] * (from_base ^ (#from_digits - i - 1))
	end

	local o = {
		num = res
	}

	function o.to(base)
		if base < 2 then
			error("invalid output base")
		end
		local digits = {}
		local acc = o.num
		if acc == 0 then
			return { 0 }
		end
		while acc ~= 0 do
			table.insert(digits, acc % base)
			acc = (acc - (acc % base)) / base
		end
		return reversed(digits)
	end

	return o
end

return all_your_base
