return {
	to_roman = function(number)
		local letters = {{'M', 1000}, {'C', 100}, {'X', 10}, {'I', 1}}
		local cinq = {{}, {'D', 500}, {'L', 50}, {'V', 5}}
		local res = ""
		while number > 0 do
			for i, p in pairs(letters) do
				local l = p[1]
				local v = p[2]
				local m = number // p[2]
				if m == 9 then
					res = res .. l .. letters[i-1][1]
				elseif 5 <= m and m <= 8 then
					res = res .. cinq[i][1] .. string.rep(l, m-5)
				elseif m == 4 then
					res = res .. l .. cinq[i][1]
				elseif 1 <= m and m <= 3 then
					res = res .. string.rep(l, m)
				end
				if m > 0 then
					number = number - m*v
					break
				end
			end
		end
		return res
	end
}
