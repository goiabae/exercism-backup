local function word_count(s)
	local words = {}
	for raw_word in string.gmatch(s, "['%w]+") do
		local word = string.lower(raw_word)
		if string.sub(word, 1, 1) == "'" then
			word = string.sub(word, 2)
		end
		if string.sub(word, #word, #word) == "'" then
			word = string.sub(word, 1, #word-1)
		end
		words[word] = (words[word] or 0) + 1
	end
	return words
end

return { word_count = word_count }
