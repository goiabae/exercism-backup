return function(s, length)
	if #s == 0 then
		error("series cannot be empty")
	end
	if length == 0 then
		error("slice length cannot be zero")
	end
	if length > #s then
		error("slice length cannot be greater than series length")
	end
	if length < 0 then
		error("slice length cannot be negative")
	end
	local i = 1
	return function()
		if i > (#s - length + 1) then
			return nil
		else
			local sub = s:sub(i, i+length-1)
			i = i + 1
			return sub
		end
	end
end
