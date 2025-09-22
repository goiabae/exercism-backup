return function(s)
	local acro = ""
	for word in string.gmatch(s, "[%w][^%u ]+") do
		acro = acro .. string.upper(string.sub(word, 1, 1))
	end
	return acro
end
