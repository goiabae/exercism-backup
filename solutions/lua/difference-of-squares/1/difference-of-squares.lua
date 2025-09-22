local function square_of_sum(n)
	local acc = 0
	for i = 0, n do
		acc = acc + i
	end
	return acc * acc
end

local function sum_of_squares(n)
	local acc = 0
	for i = 0, n do
		acc = acc + i*i
	end
	return acc
end

local function difference_of_squares(n)
	return square_of_sum(n) - sum_of_squares(n)
end

return { square_of_sum = square_of_sum, sum_of_squares = sum_of_squares, difference_of_squares = difference_of_squares }
