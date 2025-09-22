local house = {}

local subjects = {
	"the house that Jack built",
	"the malt",
	"the rat",
	"the cat",
	"the dog",
	"the cow with the crumpled horn",
	"the maiden all forlorn",
	"the man all tattered and torn",
	"the priest all shaven and shorn",
	"the rooster that crowed in the morn",
	"the farmer sowing his corn",
	"the horse and the hound and the horn",
}

local verbs = {
	"lay in",
	"ate",
	"killed",
	"worried",
	"tossed",
	"milked",
	"kissed",
	"married",
	"woke",
	"kept",
	"belonged to",
	nil,
}

assert(#subjects == #verbs + 1)

house.verse = function(which)
	local res = "."
	for i = 1, which do
		local phrase
		if i == which then
			phrase = "This is " .. subjects[which]
		else
			phrase = "that " .. verbs[i] .. " " .. subjects[i]
		end
		res = phrase .. ((i ~= 1) and "\n" or "") .. res
	end
	return res
end

house.recite = function()
	local res = ""
	for i = 1, #subjects do
		res = res .. house.verse(i)
		if i ~= #subjects then
			res = res .. "\n"
		end
	end
	return res
end

return house
