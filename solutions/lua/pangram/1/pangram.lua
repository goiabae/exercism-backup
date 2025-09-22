return function(s)
	local letters = {}
	local alphabet = "abcdefghijklmnopqrstuvwxyz"
	for c in string.gmatch(s, "%a") do
		local lc = string.lower(c)
		letters[lc] = (letters[lc] or 0) + 1
	end
	for c in string.gmatch(alphabet, ".") do
		if letters[c] == nil then
			return false
		end
	end
	return true
end
