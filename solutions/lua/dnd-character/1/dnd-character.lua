local Character = {}

math.randomseed(os.time())

local function ability(scores)
	table.sort(scores, function(a, b) return a > b end)
	local acc = 0
	for i = 1, 3 do
		acc = acc + scores[i]
	end
	return acc
end

local function roll_dice()
	local rolls = {}
	for _ = 1, 4 do
		table.insert(rolls, math.random(1, 6))
	end
	return rolls
end

local function modifier(input)
	local tmp = (input - 10)
	return (tmp - (tmp % 2)) / 2
end


MAGIC = 12

function Character:new(name)
	local char = {
		name = name,
		strength = MAGIC,
		dexterity = MAGIC,
		constitution = MAGIC,
		intelligence = MAGIC,
		wisdom = MAGIC,
		charisma = MAGIC,
		hitpoints = 10 + modifier(MAGIC),
	}
	return char
end

return { Character = Character, ability = ability, roll_dice = roll_dice, modifier = modifier }
