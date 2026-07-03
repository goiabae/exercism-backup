local function iter_lines (grid, w)
	local n, m = #grid, (#(grid[1] or {}))
	return coroutine.wrap(function ()
		for j = 1, #grid do
			for i = 1, m - w + 1 do
				local c = grid[j]:sub(i, i+w-1)
				coroutine.yield(c, { i, j }, { i+w-1, j })
				coroutine.yield(string.reverse(c), { i+w-1, j }, { i, j })
			end
		end
		for i = 1, m do
			for j = 1, n-w+1 do
				local s = ''
				for k = 0, w-1 do
					s = s .. grid[j+k]:sub(i, i)
				end
				coroutine.yield(s, { i, j }, { i, j+w-1 })
				coroutine.yield(string.reverse(s), { i, j+w-1 }, { i, j })
			end
		end
		for i = 1, m-w+1 do
			for j = 1, n-w+1 do
				local s = ''
				for k = 0, w-1 do
					s = s .. grid[j+k]:sub(i+k, i+k)
				end
				coroutine.yield(s, { i, j }, { i+w-1, j+w-1 })
				coroutine.yield(string.reverse(s), { i+w-1, j+w-1 }, { i, j })
			end
		end
		for i = m, w, -1 do
			for j = 1, n-w+1 do
				local s = ''
				for k = 0, w-1 do
					s = s .. grid[j+k]:sub(i-k, i-k)
				end
				coroutine.yield(s, { i, j }, { i+w-1, j+w-1 })
				coroutine.yield(string.reverse(s), { i-w+1, j+w-1 }, { i, j })
			end
		end
	end)
end

return function(grid)
	return {
		search = function (words)
			local matches = {}
			for _, word in ipairs(words) do
				for match, beg, fin in iter_lines(grid, #word) do
					if match == word then
						matches[word] = { ['start'] = beg, ['end'] = fin }
					end
				end
			end
			return matches
		end
	}
end
