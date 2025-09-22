
---@class HighScores
local HighScores = {}
HighScores.__index = HighScores

function HighScores:scores()
	return self
end

function HighScores:latest()
	return self[#self]
end

function HighScores:personal_best()
	local best = 0
	for i = 1, #self do
		best = math.max(best, self[i])
	end
	return best
end

function HighScores:personal_top_three()
	local sorted = {}
	for i = 1, #self do
		table.insert(sorted, self[i])
	end
	table.sort(sorted, function(a, b) return a > b end)
	local top = {}
	for i = 1, 3 do
		table.insert(top, sorted[i])
	end
	return top
end

function HighScores.new(scores)
	local high_scores = setmetatable(scores, HighScores)
	return high_scores
end

return HighScores.new
