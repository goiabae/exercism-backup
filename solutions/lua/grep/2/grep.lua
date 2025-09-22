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

local function iter(f)
	local i = 0
	return function()
		local v = f()
		if v then
			i = i + 1
			return i, v
		end
	end
end

return function(options)
	local matches = {}

	local case_insensitive = false
	local line_numbers = false
	local only_file_names = false
	local whole_lines = false
	local inverted = false
	local multiple_files = #options.files > 1

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
		for i, line in iter(io.lines(file)) do
			local match = not string.match(line, pattern) ~= not inverted
			if match then
				if only_file_names then
					if not memberof(file, matches) then
						table.insert(matches, file)
					end
				else
					local out =
						(line_numbers and multiple_files) and ("%s:%d:%s"):format(file, i, line) or
						(line_numbers) and ("%d:%s"):format(i, line) or
						(multiple_files) and ("%s:%s"):format(file, line) or
						true and line
					table.insert(matches, out)
				end
			end
		end
	end

	return matches
end
