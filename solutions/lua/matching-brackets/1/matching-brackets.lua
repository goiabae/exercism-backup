local matching = {
	["]"] = "[",
	[")"] = "(",
	["}"] = "{",
}

return {
  valid = function(s)
		local stk = {}
		for c in string.gmatch(s, '[%[%]%{%}%(%)]') do
			if string.match(c, "[%[%{%(]") then
				table.insert(stk, c)
			elseif string.match(c, "[%]%}%)]") and #stk > 0 and stk[#stk] == matching[c] then
				table.remove(stk)
			else
				return false
			end
		end
		return #stk == 0
  end
}
