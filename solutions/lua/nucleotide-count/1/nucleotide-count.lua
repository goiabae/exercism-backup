local DNA = {}
DNA.__index = DNA

function DNA:new(str)
	local dna = {
		nucleotideCounts = {
			A = 0,
			T = 0,
			C = 0,
			G = 0,
		}
	}
	setmetatable(dna, self)
	for c in string.gmatch(str, ".") do
		if c == "A" then
			dna.nucleotideCounts.A = dna.nucleotideCounts.A + 1
		elseif c == "T" then
			dna.nucleotideCounts.T = dna.nucleotideCounts.T + 1
		elseif c == "C" then
			dna.nucleotideCounts.C = dna.nucleotideCounts.C + 1
		elseif c == "G" then
			dna.nucleotideCounts.G = dna.nucleotideCounts.G + 1
		else
			error("Invalid Sequence")
		end
	end
	return dna
end

function DNA:count(nuc)
	if self.nucleotideCounts[nuc] == nil then
		error("Invalid Nucleotide")
	end
	return self.nucleotideCounts[nuc]
end

return DNA
