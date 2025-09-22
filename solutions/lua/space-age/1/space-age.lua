local SpaceAge = {}

function SpaceAge:new(n)
	local base = 31557600.0
	local age = {}
	age.seconds = n
	age["on_mercury"] = function() return n / (base * 0.2408467) end
	age["on_earth"] = function() return n / (base * 1) end
	age["on_venus"] = function() return n / (base * 0.61519726) end
	age["on_mars"] = function() return n / (base * 1.8808158) end
	age["on_jupiter"] = function() return n / (base * 11.862615) end
	age["on_saturn"] = function() return n / (base * 29.447498) end
	age["on_uranus"] = function() return n / (base * 84.016846) end
	age["on_neptune"] = function() return n / (base * 164.79132) end
	return age
end

return SpaceAge
