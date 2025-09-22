return function(n)
	return coroutine.create(function ()
			local primes = {}
			for i = 2, n do
				local not_div = true
				for _, p in ipairs(primes) do
					if i % p == 0 then
						not_div = false
					end
				end
				if not_div then
					table.insert(primes, i)
					coroutine.yield(i)
				end
			end
	end)
end
