local function suffix_for (number)
	local s = tostring(number)
	local n2 = (#s >= 2) and tonumber(s:sub(#s - 1, #s - 1)) or 0
	local n = tonumber(s:sub(#s))
	if n2 == 1 then
		return "th"
	elseif n == 1 then
		return "st"
	elseif n == 2 then
		return "nd"
	elseif n == 3 then
		return "rd"
	else
		return "th"
	end
end

return {
  format = function(name, number)
		return name .. ", you are the " .. number .. suffix_for(number) .. " customer we serve today. Thank you!"
  end
}
