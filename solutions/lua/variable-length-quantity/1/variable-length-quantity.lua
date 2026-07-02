local function decode(bytes)
	local values = {}
	local septets = {}
	local value = 0
	local ended = false
	for _, byte in ipairs(bytes) do
		ended = false
		local is_last = (byte & 0x80) == 0
		table.insert(septets, byte & (0x80-1))
		if is_last then
			local n = 0
			for i = #septets, 1, -1 do
				local septet = septets[i]
				value = value + (septet << (7 * n))
				n = n + 1
			end
			table.insert(values, value)
			septets = {}
			value = 0
			ended = true
		end
	end
	if not ended then
		error()
	end
	return values
end

local function encode(values)
	local bytes = {}
	for _, value in ipairs(values) do
		if value == 0 then
			table.insert(bytes, 0)
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
			table.insert(bytes, septet | mask)
		end
		::continue::
	end
	return bytes
end

return { decode = decode, encode = encode }
