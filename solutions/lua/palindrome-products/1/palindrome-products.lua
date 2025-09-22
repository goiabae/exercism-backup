local function is_palindrome(n)
	return tostring(n) == tostring(n):reverse()
end

local function unique(xs, cmp)
	cmp = cmp or function (x, y) return x == y end
	local ys = {}
	for _, x in ipairs(xs) do
		for _, y in ipairs(ys) do
			if cmp(x, y) then
				goto continue
			end
		end
		table.insert(ys, x)
		::continue::
	end
	return ys
end

local function cmp(x, y) return (x[1] == y[1] and x[2] == y[2]) or (x[1] == y[2] and x[2] == y[1]) end

local function smallest(min, max)
	if not (min <= max) then
		error('min must be <= max')
	end
	local value
	local factors = {}
	for i = min, max do
		for j = min, max do
			if is_palindrome(i*j) then
				if value == nil then
					factors = { { i, j } }
					value = i * j
				elseif i * j == value then
					table.insert(factors, { i, j })
				elseif i * j < value then
					factors = { { i, j } }
					value = i * j
				end
			end
		end
	end
	return { factors = unique(factors, cmp), value = value }
end

local function largest(min, max)
	if not (min <= max) then
		error('min must be <= max')
	end
	local value
	local factors = {}
	for i = min, max do
		for j = min, max do
			if is_palindrome(i*j) then
				if value == nil then
					factors = { { i, j } }
					value = i * j
				elseif i *j == value then
					table.insert(factors, { i, j })
				elseif i * j > value then
					factors = { { i, j } }
					value = i * j
				end
			end
		end
	end
	return { factors = unique(factors, cmp), value = value }
end

return { smallest = smallest, largest = largest }
