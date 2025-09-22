local function is_palindrome(n)
	return tostring(n) == tostring(n):reverse()
end

local function factor(n, min, max)
	local factors = {}
	for i = min, max do
		if n % i == 0 then
			local j = n // i
			if i * j == n and i <= j and j >= min and j <= max then
				table.insert(factors, { i, j })
			end
		end
	end
	return factors
end

local function smallest(min, max)
	if not (min <= max) then
		error('min must be <= max')
	end

	for n = min*min, max*max do
		if is_palindrome(n) then
			local factors = factor(n, min, max)
			if #factors > 0 then
				return { value = n, factors = factors }
			end
		end
	end

	return { factors = {} }
end

local function largest(min, max)
	if not (min <= max) then
		error('min must be <= max')
	end

	for n = max*max, min*min, -1 do
		if is_palindrome(n) then
			local factors = factor(n, min, max)
			if #factors > 0 then
				return { value = n, factors = factors }
			end
		end
	end

	return { factors = {} }
end

return { smallest = smallest, largest = largest }
