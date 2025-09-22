return {
  encode = function(s)
		if #s == 0 then
			return ""
		end
		if #s == 1 then
			return s
		end
		local chunks = {}
		local cur = { char = string.sub(s, 1, 1), count = 0 }
		for i = 1, #s do
			local c = string.sub(s, i, i)
			if c == cur.char then
				cur.count = cur.count + 1
			else
				table.insert(chunks, cur)
				cur = { char = c, count = 1 }
			end
		end
		table.insert(chunks, cur)
		local res = ""
		for i = 1, #chunks do
			if chunks[i].count > 1 then
				res = res .. tostring(chunks[i].count) .. chunks[i].char
			else
				res = res .. chunks[i].char
			end
		end
		--print(res)
		return res
  end,
  decode = function(s)
		local res = ""
		while true do
			if #s == 0 then
				break
			end

			local len = 1
			local len_str = string.match(s, "^%d+")
			if len_str ~= nil then
				s = string.sub(s, #len_str+1)
				len = assert(tonumber(len_str))
			end

			local c = string.sub(s, 1, 1)
			s = string.sub(s, 2)
			res = res .. string.rep(c, len)
		end
		return res
  end
}
