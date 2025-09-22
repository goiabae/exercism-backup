local triangle = {}

function triangle.kind(a, b, c)
	if not (a ~= 0 and b ~= 0 and c ~= 0 and (a+b > c) and (b+c > a) and (a+c > b)) then
		error("Input Error")
	end

	if a == b and b == c then
		return 'equilateral'
	end

	if a ~= b and b ~= c and a ~= c then
		return 'scalene'
	end

	return 'isosceles'
end

return triangle
