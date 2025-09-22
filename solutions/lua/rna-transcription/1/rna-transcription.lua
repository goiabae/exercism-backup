return function(dna)
	local conv = {
		C = "G",
		G = "C",
		A = "U",
		T = "A",
	}
	return string.gsub(dna, ".", function (c)
		return conv[c]
	end)
end
