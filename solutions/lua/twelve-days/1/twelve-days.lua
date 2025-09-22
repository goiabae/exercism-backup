ORDINAL = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth" }
CARDINAL = { "", "a", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve" }
GIFTS = { 'Partridge in a Pear Tree', 'Turtle Doves', 'French Hens', 'Calling Birds', 'Gold Rings', 'Geese-a-Laying', 'Swans-a-Swimming', 'Maids-a-Milking', 'Ladies Dancing', 'Lords-a-Leaping', 'Pipers Piping', 'Drummers Drumming' }

local function aux(days)
	local x = ""
	for i = 1, days do
		local tmp = ""
		if i == days then
			tmp = ""
		elseif i == 1 then
			tmp = ", and "
		else
			tmp = ", "
		end
		x = tmp .. CARDINAL[i+1] .. " " .. GIFTS[i] .. x
	end
	x = "On the " .. ORDINAL[days] .. " day of Christmas my true love gave to me: " .. x .. "."
	return x
end

local function recite(start_verse, end_verse)
	local verses = {}
	for i = start_verse, end_verse do
		table.insert(verses, aux(i))
	end
	return verses
end

return { recite = recite }
