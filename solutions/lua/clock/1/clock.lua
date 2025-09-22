local Clock = {}
Clock.__index = Clock

function Clock.__tostring(clk)
	return string.format("%02d:%02d", clk.h, clk.m)
end

function Clock.new(h, m)
	local clk = {
		h = (h + ((m - (m % 60)) / 60)) % 24,
		m = m % 60,
	}
	setmetatable(clk, Clock)
	return clk
end

function Clock:plus(minutes)
	return Clock.new(self.h, self.m + minutes)
end

function Clock:minus(minutes)
	return Clock.new(self.h, self.m - minutes)
end

function Clock:equals(other)
	return self.h == other.h and self.m == other.m
end

function Clock.at(hours, minutes)
	return Clock.new(hours, minutes and minutes or 0)
end

return Clock
