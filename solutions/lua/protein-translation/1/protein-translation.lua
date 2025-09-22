local function translate_codon(codon)
	if codon == "AUG" then
		return "Methionine"
	elseif codon == "UUU" or codon == "UUC" then
		return "Phenylalanine"
	elseif codon == "UUA" or codon == "UUG" then
		return "Leucine"
	elseif codon == "UCU" or codon == "UCC" or codon == "UCA" or codon == "UCG" then
		return "Serine"
	elseif codon == "UAU" or codon == "UAC" then
		return "Tyrosine"
	elseif codon == "UGU" or codon == "UGC" then
		return "Cysteine"
	elseif codon == "UGG" then
		return "Tryptophan"
	elseif codon == "UAA" or codon == "UAG" or codon == "UGA" then
		return "STOP"
	else
		error("")
	end
end

local function translate_rna_strand(rna_strand)
	local strand = {}
	for i = 1, #rna_strand, 3 do
		local codon = rna_strand:sub(i, i+2)
		local prot = translate_codon(codon)
		if prot == "STOP" then
			break
		end
		table.insert(strand, prot)
	end
	return strand
end

return { codon = translate_codon, rna_strand = translate_rna_strand }
