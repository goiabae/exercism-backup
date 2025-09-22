local bob = {}

function bob.hey(say)
	if #say == 0 or say:match("%s+") == say then
		return "Fine, be that way."
	end

	local onlyalpha = ""
	for alp in say:gmatch("%a+") do
		onlyalpha = onlyalpha .. alp
	end

	local nospaces = ""
	for sub in say:gmatch("[^%s]+") do
		nospaces = nospaces .. sub
	end

	local isupper = onlyalpha:match("%u+") == onlyalpha
	local isquestion = nospaces:sub(#nospaces, #nospaces) == "?"

	return isupper
		and (isquestion and "Calm down, I know what I'm doing!" or "Whoa, chill out!")
		or (isquestion and "Sure" or "Whatever")
end

return bob
