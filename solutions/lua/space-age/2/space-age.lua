local SpaceAge = {}

FACTORS = {
	["mercury"] = 0.2408467,
	["earth"]   = 1.0,
	["venus"]   = 0.61519726,
	["mars"]    = 1.8808158,
	["jupiter"] = 11.862615,
	["saturn"]  = 29.447498,
	["uranus"]  = 84.016846,
	["neptune"] = 164.79132,
}

function SpaceAge:new(n)
	local base = 31557600.0
	local age = {}
	age.seconds = n
	for planet, factor in pairs(FACTORS) do
		age["on_" .. planet] = function()
			return tonumber(string.format("%.2f", n / (base * factor)))
		end
	end
  return age
end

return SpaceAge
