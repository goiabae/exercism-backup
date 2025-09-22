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
		pattern = pattern:gsub("%a", function(c)
			return ("[%s%s]"):format(c:lower(), c:upper())
		end)
	end
	if whole_lines then
		pattern = "^" .. pattern .. "$"
	end

	for _, file in pairs(options.files) do
		local line_no = 1
		for line in io.lines(file) do
			local match = not line:match(pattern) ~= not inverted
			if match then
				if only_file_names then
					table.insert(matches, file)
					break
				else
					local out =
						(line_numbers and multiple_files) and ("%s:%d:%s"):format(file, line_no, line) or
						(line_numbers) and ("%d:%s"):format(line_no, line) or
						(multiple_files) and ("%s:%s"):format(file, line) or
						true and line
					table.insert(matches, out)
				end
			end
			line_no = line_no + 1
		end
	end

	return matches
end
