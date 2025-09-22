local Complex

Complex = function(r, i)
  local c = {
    r = r,
		i = i or 0,
  }

	function c.conj()
		return Complex(c.r, -c.i)
	end

	function c.abs()
		if c.r == 0 then
			return c.i
		end

		if c.i == 0 then
			return c.r
		end

		return math.sqrt(c.r*c.r + c.i*c.i)
	end

	function c.exp()
		if c.r == 0 and c.i == 0 then
			return Complex(1, 0)
		end

		if c.i == 0 then
			return Complex(math.exp(c.r), 0)
		end

		return Complex(math.exp(c.r) * math.cos(c.i),math.exp(c.r) * math.sin(c.i))
	end

  return setmetatable(c, {
			__add = function(a, b)
				return Complex(a.r + b.r, a.i + b.i)
			end,
			__sub = function(a, b)
				return Complex(a.r - b.r, a.i - b.i)
			end,
			__mul = function(a, b)
				return Complex(a.r * b.r - a.i * b.i, a.r * b.i + a.i * b.r)
			end,
			__div = function(a, b)
				local c = a * b.conj()
				local deno = b.r * b.r + b.i * b.i
				return Complex(c.r / deno, c.i / deno)
			end,
  })
end

return Complex
