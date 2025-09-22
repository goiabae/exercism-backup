local Proverb = {}

function Proverb.recite(strings)
	local res = ""
	if #strings == 0 then
		return res
	end
	for i = 2, #strings do
		res = res .. "For want of a " .. strings[i-1] .. " the " .. strings[i] .. " was lost.\n"
	end
	res = res .. "And all for the want of a " .. strings[1] .. ".\n"
	return res
end

return Proverb
