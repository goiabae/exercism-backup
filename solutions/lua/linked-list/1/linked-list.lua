
---@class Node
---@field value integer
---@field next Node?
---@field prev Node?

---@param value integer
---@return Node
local function new_node(value)
	return { value = value }
end

---@class LinkedList
---@field first Node?
---@field last Node?
local LinkedList = {}
LinkedList.__index = LinkedList

function LinkedList.new()
	local list = setmetatable({}, LinkedList)
	return list
end

---@param value integer
function LinkedList:push(value)
	if self.first == nil then
		assert(self.last == nil)
		self.first = new_node(value)
		self.last = self.first
		return
	end

	local fst = self.first
	self.first = new_node(value)
	self.first.next = fst
	fst.prev = self.first
end

---@return integer
function LinkedList:pop()
	if self.first == nil then
		assert(self.last == nil)
		error("")
	end

	local fst = self.first
	assert(fst)
	self.first = fst.next
	if self.first then
		self.first.prev = nil
	end
	return fst.value
end

---@return integer
function LinkedList:shift()
	local last = self.last
	assert(last)
	if last.prev then
		last.prev.next = nil
	end
	self.last = last.prev
	return last.value
end

---@param value integer
function LinkedList:unshift(value)
	if self.first == nil and self.last == nil then
		self.first = new_node(value)
		self.last = self.first
		return
	end

	assert(self.first and self.last)

	local node = new_node(value)
	node.prev = self.last
	self.last.next = node
	self.last = node
end

---@return integer
function LinkedList:count()
	local hd = self.first
	local count = 0
	while hd ~= nil do
		count = count + 1
		hd = hd.next
	end
	return count
end

---@param value integer
function LinkedList:delete(value)
	local hd = self.first
	while hd ~= nil do
		if hd.value == value then
			if hd.prev ~= nil then
				hd.prev.next = hd.next
			elseif hd.prev == nil then
				self.first = hd.next
			end
			if hd.next ~= nil then
				hd.next.prev = hd.prev
			elseif hd.next == nil then
				self.last = hd.prev
			end
		end
		hd = hd.next
	end
end

return LinkedList.new
