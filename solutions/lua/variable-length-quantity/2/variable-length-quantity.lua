local function decode(octets)
	local values = {}
	local septets = {}
	local reached_sentinel_octet = false
	for _, octet in ipairs(octets) do
		reached_sentinel_octet = false
		local is_last = (octet & 0x80) == 0
		table.insert(septets, octet & (0x80-1))
		if is_last then
			local value = 0
			for i = 1, #septets do
				local septet = septets[i]
				value = (value << 7) + septet
			end
			table.insert(values, value)
			septets = {}
			reached_sentinel_octet = true
		end
	end
	if not reached_sentinel_octet then
		error()
	end
	return values
end

local function encode(values)
	local octets = {}
	for _, value in ipairs(values) do
		if value == 0 then
			table.insert(octets, 0)
			goto continue
		end
		local septets = {}
		while value ~= 0 do
			local septet = value & (0x80-1)
			table.insert(septets, septet)
			value = value >> 7
		end
		for i = #septets, 1, -1 do
			local septet = septets[i]
			local mask = (i == 1) and 0x0 or 0x80
			table.insert(octets, septet | mask)
		end
		::continue::
	end
	return octets
end

return { decode = decode, encode = encode }
