local alphabet = "abcdefghijklmnopqrstuvwxyz"

local function random_alpha()
	local i = math.floor(math.random(1, #alphabet))
	return string.sub(alphabet, i, i)
end

local function random_digit()
	return math.floor(math.random(0, 9))
end

local used_names = {}

local function random_unique_name()
	local name = random_alpha() .. random_alpha() .. tostring(random_digit()) .. tostring(random_digit()) .. tostring(random_digit())
	if used_names[name] then
		return random_unique_name()
	else
		used_names[name] = true
		return name
	end
end

---@class Robot
---@field name string
local Robot = {}
Robot.__index = Robot

---@return Robot
function Robot:new()
	local bot = setmetatable({ name = random_unique_name() }, Robot)
	return bot
end

function Robot:reset()
	self.name = random_unique_name()
end

return Robot
