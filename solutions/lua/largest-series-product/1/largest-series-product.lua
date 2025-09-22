return function(config)
	if config.span > #config.digits or config.span < 0 then
		error()
	end

	local max = 0
	for i = 1, #config.digits - config.span + 1 do
		local acc = 1
		for c in config.digits:sub(i, i+config.span-1):gmatch('.') do
			acc = acc * tonumber(c)
		end
		max = math.max(max, acc)
	end
	return max
end
