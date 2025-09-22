local function translate_codon(codon)
	if codon == "AUG" then
		return "Methionine"
	elseif codon:match("UU[UC]") then
		return "Phenylalanine"
	elseif codon:match("UU[AG]") then
		return "Leucine"
	elseif codon:match("UC[ACGU]") then
		return "Serine"
	elseif codon:match("UA[CU]") then
		return "Tyrosine"
	elseif codon:match("UG[CU]") then
		return "Cysteine"
	elseif codon == "UGG" then
		return "Tryptophan"
	elseif codon:match("UA[AG]") or codon == "UGA" then
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
