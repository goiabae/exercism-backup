local function insensitivize(pattern)
	local res = ""
	for c in string.gmatch(pattern, '.') do
		res = res .. ("[%s%s]"):format(string.lower(c), string.upper(c))
	end
	return res
end

local function memberof(elt, lst)
	for _, x in pairs(lst) do
		if x == elt then
			return true
		end
	end
	return false
end

return function(options)
	local matches = {}
	local case_insensitive = false
	local line_numbers = false
	local only_file_names = false
	local whole_lines = false
	local inverted = false
	for _, flag in pairs(options.flags) do
		local c = flag:sub(2, 2)
		if c == "i" then
			case_insensitive = true
		elseif c == "n" then
			line_numbers = true
		elseif c == "l" then
			only_file_names = true
		elseif c == "x" then
			whole_lines = true
		elseif c == "v" then
			inverted = true
		end
	end
	local pattern = options.pattern
	if case_insensitive then
		pattern = insensitivize(pattern)
	end
	if whole_lines then
		pattern = "^" .. pattern .. "$"
	end
	for _, file in pairs(options.files) do
		local i = 1
		for line in io.lines(file) do
			local match = string.match(line, pattern)
			if inverted then
				match = not match
			end
			if match then
				if only_file_names then
					if not memberof(file, matches) then
						table.insert(matches, file)
					end
				else
					local out = line
					if line_numbers then
						out = ("%d:%s"):format(i, out)
					end
					if #options.files > 1 then
						out = ("%s:%s"):format(file, out)
					end
					table.insert(matches, out)
				end
			end
			i = i + 1
		end
	end
	return matches
end
