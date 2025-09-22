local rotation = {
	["L"] = {
		["south"] = "east",
		["east"] = "north",
		["north"] = "west",
		["west"] = "south",
	},
	["R"] = {
		["south"] = "west",
		["west"] = "north",
		["north"] = "east",
		["east"] = "south",
	}
}

return function(bot)
	function bot:move(dirs)
		for dir in string.gmatch(dirs, ".") do
			if dir == "L" or dir == "R" then
				bot.heading = rotation[dir][bot.heading]
			elseif dir == "A" then
				bot.x = bot.x + ((bot.heading == "east") and 1 or (bot.heading == "west" and -1 or 0))
				bot.y = bot.y + ((bot.heading == "north") and 1 or (bot.heading == "south" and -1 or 0))
			else
				error("")
			end
		end
	end
	return bot
end
