
---@class CircularBuffer
---@field cap integer
---@field read_head integer
---@field write_head integer
---@field len integer
local CircularBuffer = {}
CircularBuffer.__index = CircularBuffer

---@param cap integer
function CircularBuffer:new(cap)
	local buf = setmetatable({}, CircularBuffer)
	buf.cap = cap
	buf.read_head = 1
	buf.write_head = 1
	buf.len = 0
	return buf
end

---@param value string
function CircularBuffer:write(value)
	if value == nil then
		return
	end
	if self.len == self.cap then
		error("buffer is full")
	end
	self[self.write_head] = value
	self.write_head = ((self.write_head -1 + 1) % self.cap) + 1
	self.len = self.len + 1
end


---@return string?
function CircularBuffer:read()
	if self.len == 0 then
		error("buffer is empty")
	end
	local idx = self.read_head
	self.read_head = ((self.read_head -1 +1) % self.cap) + 1
	self.len = self.len - 1
	return self[idx]
end

function CircularBuffer:clear()
	self.len = 0
end

function CircularBuffer:forceWrite(value)
	if self.len < self.cap then
		self:write(value)
		return
	end
	self.read_head = (self.len >= self.cap) and (((self.read_head + 1 -1) % self.cap) + 1) or self.read_head
	self[self.write_head] = value
	self.write_head = ((self.write_head -1 + 1) % self.cap) + 1
end

return CircularBuffer
