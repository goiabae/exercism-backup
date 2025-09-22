local function answer(question)
	local terms = {}
	for word in string.gmatch(question, '[^ ?]+') do
		if word == "What" or word == "is" or word == "by" then
			goto continue
		end
		if string.match(word, '-?%d+') then
			table.insert(terms, { "num", word })
		elseif word == "plus" then
			table.insert(terms, { "op", "+" })
		elseif word == "minus" then
			table.insert(terms, { "op", "-" })
		elseif word == "multiplied" then
			table.insert(terms, { "op", "*" })
		elseif word == "divided" then
			table.insert(terms, { "op", "/" })
		else
			print(word)
			error("Invalid question")
		end
		::continue::
	end
	for _, term in ipairs(terms) do
		print(term[2])
	end
	if #terms == 0 then
		error("Invalid question")
	end
	local i = 1
	if terms[i][1] ~= "num" then
		error("Invalid question")
	end
	local acc = assert(tonumber(terms[i][2]))
	i = i + 1
	while i <= #terms do
		if terms[i][1] == "num" then
			error("Invalid question")
		elseif terms[i][1] == "op" then
			if not terms[i+1] then
				error("Invalid question")
			end
			if terms[i+1][1] ~= "num" then
				error("Invalid question")
			end
			if terms[i][2] == "+" then
				acc = acc + tonumber(terms[i+1][2])
				i = i + 2
			elseif terms[i][2] == "-" then
				acc = acc - tonumber(terms[i+1][2])
				i = i + 2
			elseif terms[i][2] == "*" then
				acc = acc * tonumber(terms[i+1][2])
				i = i + 2
			elseif terms[i][2] == "/" then
				acc = acc / tonumber(terms[i+1][2])
				i = i + 2
			else
				print(terms[i][2])
				assert(false)
			end
		end
	end
	return acc
end

return { answer = answer }
