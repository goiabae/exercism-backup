return function(s)
	local acro = ""
	for word in string.gmatch(s, "['%a]+") do
		if word == "HyperText" then
			acro = acro .. "HT"
		elseif string.match(word, "%u+") then
			acro = acro .. string.upper(string.sub(word, 1, 1))
		elseif string.match(word, "%l+") then
			acro = acro .. string.upper(string.sub(word, 1, 1))
		end
	end
	return acro
end
