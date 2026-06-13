
local Set = {}
Set.__index = Set

function Set.new (...)
	local xs = { ... }
	return setmetatable({ elements = xs }, Set)
end

function Set:contains (n)
	for _, elt in ipairs(self.elements) do
		if elt == n then
			return true
		end
	end
	return false
end

function Set:is_empty ()
	return #self.elements == 0
end

function Set:is_subset (super)
	for _, elt in ipairs(self.elements) do
		if not super:contains(elt) then
			return false
		end
	end
	return true
end

function Set:is_disjoint (other)
	for _, elt in ipairs(self.elements) do
		if other:contains(elt) then
			return false
		end
	end
	for _, elt in ipairs(other.elements) do
		if self:contains(elt) then
			return false
		end
	end
	return true
end

function Set:equals (other)
	return self:is_subset(other) and other:is_subset(self)
end

function Set:add (elt)
	if not self:contains(elt) then
		table.insert(self.elements, elt)
	end
end

function Set:intersection (other)
	local int = Set.new()
	for _, elt in ipairs(self.elements) do
		if other:contains(elt) then
			int:add(elt)
		end
	end
	return int
end

function Set:difference (other)
	local dif = Set.new()
	for _, elt in ipairs(self.elements) do
		if not other:contains(elt) then
			dif:add(elt)
		end
	end
	return dif
end

function Set:union (other)
	local uni = Set.new()
	for _, elt in ipairs(self.elements) do
		uni:add(elt)
	end
	for _, elt in ipairs(other.elements) do
		uni:add(elt)
	end
	return uni
end

return Set.new
