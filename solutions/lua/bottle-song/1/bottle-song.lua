local BottleSong = {}

LNUMS = { "no", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten" }
TNUMS = { "No", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten" }

function BottleSong.recite(start_bottles, take_down)
	local beg = start_bottles
	local fin = beg - take_down + 1

	local function f(i)
		return i == 1 and "bottle" or "bottles"
	end

	local res = ""
	for i = beg, fin, -1 do
		res = res
			.. string.format("%s green %s hanging on the wall,\n", TNUMS[i+1], f(i))
			.. string.format("%s green %s hanging on the wall,\n", TNUMS[i+1], f(i))
			.. "And if one green bottle should accidentally fall,\n"
			.. string.format("There'll be %s green %s hanging on the wall.\n", LNUMS[i], f(i-1))
			.. ((i ~= fin) and "\n" or "")
	end
	return res
end

return BottleSong
