
---@generic T
---@param xs T[]
---@return T[]
local function reversed (xs)
	local ys = {}
	for i = #xs, 1, -1 do
		table.insert(ys, xs[i])
	end
	return ys
end

---@generic T
---@param xs T[]
---@param ys T[]
---@return T[]
local function concat (xs, ys)
	local zs = {}
	for _, x in ipairs(xs) do
		table.insert(zs, x)
	end
	for _, y in ipairs(ys) do
		table.insert(zs, y)
	end
	return zs
end

---@alias card string
---@alias deck card[]

local to_pay = {
	['J'] = 1,
	['Q'] = 2,
	['K'] = 3,
	['A'] = 4,
}

local function hash_deck (deck)
	local h = ''
	for _, a in ipairs(deck) do
		if to_pay[a] then
			h = h .. a
		else
			h = h .. 'X'
		end
	end
	return h
end

local function hash (playerA, playerB, pile, a_is_playing)
	return hash_deck(playerA) .. ';' .. hash_deck(playerB) .. ';' .. hash_deck(pile) .. ';' .. (a_is_playing and 'A' or 'B')
end

---@param swapped boolean
local function hash_add (visited, a, b, pile, swapped)
	local h
	if swapped then
		h = hash(b, a, pile, not swapped)
	else
		h = hash(a, b, pile, not swapped)
	end
	if visited[h] then
		return true
	else
		visited[h] = true
		return false
	end
end

local function has_won (_, b, pile)
	return #b == 0 and #pile == 0
end

local sm = {}

---@param a deck
---@param b deck
---@param pile deck
---@param steps integer
---@param tricks integer
---@param visited { string:boolean }
---@param swapped boolean
---@return { status: string, tricks: integer, cards: integer }
function sm.place (a, b, pile, steps, tricks, visited, swapped)
	local top = table.remove(a)
	if top then
		table.insert(pile, top)
		if hash_add(visited, a, b, pile, swapped) then
			return { status = 'loop', cards = steps, tricks = tricks }
		end
		steps = steps + 1
		if to_pay[top] then
			return sm.paying(b, a, pile, to_pay[top], steps, tricks, visited, not swapped)
		else
			return sm.place(b, a, pile, steps, tricks, visited, not swapped)
		end
	else
		return sm.collect_and_run(b, a, pile, steps, tricks, true, visited, not swapped)
	end
end

---@param a deck
---@param b deck
---@param pile deck
---@param steps integer
---@param ran_out boolean
---@param visited { string:boolean }
---@param swapped boolean
---@return { status: string, tricks: integer, cards: integer }
function sm.collect_and_run (a, b, pile, steps, tricks, ran_out, visited, swapped)
	tricks = tricks + 1
	if ran_out then
		a = concat(reversed(pile), a)
	else
		b = concat(reversed(pile), b)
	end
	pile = {}
	if has_won(a, b, pile) or has_won(b, a, pile) then
		return { status = 'finished', cards = steps, tricks = tricks }
	elseif hash_add(visited, a, b, pile, swapped) then
		return { status = 'loop', cards = steps, tricks = tricks }
	else
		if ran_out then
			return sm.place(a, b, pile, steps, tricks, visited, swapped)
		else
			return sm.place(b, a, pile, steps, tricks, visited, not swapped)
		end
	end
end

-- `playerA' is paying `n' cards to `playerB'
---@param a deck
---@param b deck
---@param pile deck
---@param left_to_pay integer
---@param steps integer
---@param visited { string:boolean }
---@param swapped boolean
---@return { status: string, tricks: integer, cards: integer }
function sm.paying (a, b, pile, left_to_pay, steps, tricks, visited, swapped)
	if left_to_pay == 0 then
		return sm.collect_and_run(a, b, pile, steps, tricks, false, visited, swapped)
	else
		if #a == 0 then
			return sm.collect_and_run(b, a, pile, steps, tricks, true, visited, not swapped)
		else
			local top = table.remove(a)
			table.insert(pile, top)
			steps = steps + 1
			if hash_add(visited, a, b, pile, swapped) then
				return { status = 'loop', cards = steps, tricks = tricks }
			elseif to_pay[top] then
				return sm.paying(b, a, pile, to_pay[top], steps, tricks, visited, not swapped)
			else
				return sm.paying(a, b, pile, left_to_pay-1, steps, tricks, visited, swapped)
			end
		end
	end
end

---@param playerA string[]
---@param playerB string[]
---@return { status: string, tricks: integer, cards: integer }
local function simulate_game(playerA, playerB)
	local visited = {}
	local a, b = reversed(playerA), reversed(playerB)
	hash_add(visited, a, b, {}, false)
	return sm.place(a, b, {}, 0, 0, visited, false)
end

return { simulate_game = simulate_game }
