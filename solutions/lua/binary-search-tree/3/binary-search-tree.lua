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
	local side = (value <= self.value) and "left" or "right"
	if self[side] then
		self[side]:insert(value)
	else
		self[side] = BinarySearchTree:new(value)
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

---@return fun(): integer?
function BinarySearchTree:values()
	local function yield(bst)
		if bst.left then yield(bst.left) end
		coroutine.yield(bst.value)
		if bst.right then yield(bst.right) end
	end
	return coroutine.wrap(function() yield(self) end)
end

return BinarySearchTree
