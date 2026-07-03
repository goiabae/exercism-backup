local function as_bits (integer, n)
	local s = ''
	for i = 1, n do
		s = ((((integer >> (i-1)) & 1) ~= 0) and '1' or '0') .. s
	end
	return s
end

local function count_bits (s)
	local n = 0
	for c in string.gmatch(s, '.') do
		if c == '1' then
			n = n + 1
		end
	end
	return n
end

local function from_bits (bits, n)
	local integer = 0
	for i = 1, n do
		integer = (integer << 1) + ((bits:sub(i,i) == '1') and 1 or 0)
	end
	return integer
end

local function pad_right (s, n)
	return s .. string.rep('0', n-#s)
end

local function transmit_sequence(sequence)
	if #sequence == 0 then
		return {}
	end
	local bytes = {}
	local bits = ''
	for _, integer in ipairs(sequence) do
		bits = bits .. as_bits(integer, 8)
	end
	while true do
		if #bits == 0 then
			break
		end
		if #bits < 7 then
			local s = pad_right(bits, 7)
			local n = count_bits(s)
			local b = nil
			if (n % 2) == 0 then
				b = s .. '0'
			else
				b = s .. '1'
			end
			table.insert(bytes, from_bits(b, 8))
			break
		end
		local s = string.sub(bits, 1, 7)
		local n = count_bits(s)
		local b = nil
		if (n % 2) == 0 then
			b = s .. '0'
		else
			b = s .. '1'
		end
		table.insert(bytes, from_bits(b, 8))
		bits = string.sub(bits, 7+1)
	end
	return bytes
end

local function decode_message(message)
	local bits = ''
	for _, byte in ipairs(message) do
		bits = bits .. as_bits(byte, 8)
	end
	local unpaired_bits = ''
	while #bits > 0 do
		local s = string.sub(bits, 1, 7)
		local p = string.sub(bits, 8, 8)
		local n = count_bits(s)
		if (((n % 2) == 0) and p == '1') or (((n % 2) == 1) and p == '0') then
			error('wrong parity')
		end
		unpaired_bits = unpaired_bits .. s
		bits = string.sub(bits, 8+1)
	end
	local bytes = {}
	while #unpaired_bits > 0 do
		if #unpaired_bits < 8 then
			local s = pad_right(unpaired_bits, 8)
			local n = from_bits(s, 8)
			if n ~= 0 then
				table.insert(bytes, n)
			end
			break
		end
		local s = string.sub(unpaired_bits, 1, 8)
		table.insert(bytes, from_bits(s, 8))
		unpaired_bits = string.sub(unpaired_bits, 8+1)
	end
	return bytes
end

return { transmit_sequence = transmit_sequence, decode_message = decode_message }
