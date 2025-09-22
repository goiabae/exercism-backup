return function(array, target)
	if #array == 0 then
		return -1
	end

	local l = 0
	local r = #array -1

	while l <= r do
		local m = (l + r) // 2

		if array[m+1] < target then
			l = m + 1
		elseif array[m+1] > target then
			r = m - 1
		else
			return m+1
		end
	end

	return -1
end
