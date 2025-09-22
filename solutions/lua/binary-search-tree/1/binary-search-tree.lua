---@class BinarySearchTree
---@field value integer
---@field left BinarySearchTree?
---@field right BinarySearchTree?
local BinarySearchTree = {}
BinarySearchTree.__index = BinarySearchTree

function BinarySearchTree:new(value)
	return setmetatable({ value = value }, BinarySearchTree)
end

function BinarySearchTree:insert(value)
	if value <= self.value then
		if self.left == nil then
			self.left = BinarySearchTree:new(value)
		else
			self.left:insert(value)
		end
	elseif value > self.value then
		if self.right == nil then
			self.right = BinarySearchTree:new(value)
		else
			self.right:insert(value)
		end
	end
end

---@param lst integer[]
---@return BinarySearchTree
function BinarySearchTree:from_list(lst)
	assert(#lst > 0)
	local bst = BinarySearchTree:new(lst[1])
	for i = 2, #lst do
		bst:insert(lst[i])
	end
	return bst
end

function BinarySearchTree:values()

	local left = self.left and self.left:values() or nil
	local right = self.right and self.right:values() or nil
	local center = function () return self.value end

	local function f()
		if left then
			local l = left()
			if l == nil then
				left = nil
				return f()
			else
				return l
			end
		end

		if center then
			local c = center()
			center = nil
			return c
		end

		if right then
			local r = right()
			if r == nil then
				right = nil
				return f()
			else
				return r
			end
		end

		return nil
	end

	return f
end

return BinarySearchTree
