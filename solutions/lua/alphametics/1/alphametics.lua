local function split (str)
	local words = {}
	for word in str:gmatch("%S+") do
		table.insert(words, word)
	end
	return words
end

local PRECEDENCE = {
	["=="] = 5,
	["+"] = 10,
	["-"] = 10,
	["*"] = 20,
	["/"] = 20,
	["^"] = 30,
	[","] = 40,
}

local tokens
local pos

local expr
local peek
local advance
local led
local nud

peek = function ()
	local t = tokens[pos]
	return t
end

advance = function ()
	local tok = tokens[pos]
	pos = pos + 1
	return tok
end


nud = function (tok)
	if tok.type == "number" then
		return tok.value
	elseif tok.type == "variable" then
		return tok.value
	end
	error(("unexpected token '%s'"):format(tok.type))
end

led = function (tok, left)
	return {
		tok.type,
		left,
		expr(PRECEDENCE[tok.type])
	}
end

expr = function (rbp)
	local tok = advance()
	local left = nud(tok)
	while true do
		local next = peek()
		if not next then break end
		local lbp = PRECEDENCE[next.type] or 0
		if lbp <= rbp then break end
		tok = advance()
		left = led(tok, left)
	end
	return left
end

local function parse ()
	return expr(0)
end

local op = {
	['*'] = function (x, y) return x * y end,
	['+'] = function (x, y) return x + y end,
	['^'] = function (x, y) return x ^ y end,
	['=='] = function (x, y) return x == y end,
	[','] = function (x, y) return 10*x + y end,
}

local function eval (e, c)
	if type(e) == "table" then
		local v1 = eval(e[2], c)
		if v1 == "stuck" then
			return "stuck"
		end
		local v2 = eval(e[3], c)
		if v2 == "stuck" then
			return "stuck"
		end
		return op[e[1]](v1, v2)
	elseif type(e) == "string" then
		if c[e][1] == nil then
			return "stuck"
		else
			return c[e][1]
		end
	elseif type(e) == "number" then
		return e
	end
	error()
end

local function has_leading_zeros (concats, variables)
	for _, concat in ipairs(concats) do
		local s = ''
		for k = 1, #concat do
			s = s .. tostring(variables[string.sub(concat, k, k)][1])
		end
		local leadin = true
		for k = 1, #concat do
			if leadin and variables[string.sub(concat, k, k)][1] == 0 then
				return true
			elseif variables[string.sub(concat, k, k)][1] ~= 0 then
				leadin = false
			end
		end
	end
	return false
end

local function solve_ (variables, vars, e, i, leading, concats, used)
	local v = vars[i]
	for j = leading[v] and 1 or 0, 9 do
		if used[j] == nil then
			used[j] = true
			variables[v][1] = j
			local r = eval(e, variables)
			if r == true then
				if not has_leading_zeros(concats, variables) then
					return true
				end
			elseif r == false then
				do end
			elseif r == "stuck" and i < #vars then
				local r2 = solve_(variables, vars, e, i+1, leading, concats, used)
				if r2 then
					return true
				end
			end
			used[j] = nil
		end
	end
	variables[v][1] = nil
	return false
end

local function solve(puzzle)
	local variables = {}
	for c in string.gmatch(puzzle, '.') do
		if string.match(c, '%a') ~= nil then
			variables[c] = variables[c] or {}
		end
	end
	local vars = {}
	for c, _ in pairs(variables) do
		table.insert(vars, c)
	end
	local leading = {}
	tokens = {}
	local concats = {}
	pos = 1
	for _, word in ipairs(split(puzzle)) do
		if word == '+' then
			table.insert(tokens, { type = "+" })
		elseif word == '==' then
			table.insert(tokens, { type = "==" })
		elseif word == '*' then
			table.insert(tokens, { type = "*" })
		elseif word == '^' then
			table.insert(tokens, { type = "^" })
		elseif string.match(word, '^[A-Z]+$') ~= nil then
			table.insert(concats, word)
			local xs = {}
			for c in string.gmatch(word, '.') do
				table.insert(xs, c)
			end
			for i = 1, #xs do
				if i == 1 then
					leading[xs[i]] = true
				end
				table.insert(tokens, { type = 'variable', value = xs[i] })
				if i ~= #xs then
					table.insert(tokens, { type = ',' })
				end
			end
		elseif string.match(word, '^[0-9]+$') ~= nil then
			table.insert(tokens, { type = 'number', value = tonumber(word) })
		else
			error()
		end
	end
	local e = parse()
	if not solve_(variables, vars, e, 1, leading, concats, {}) then
		error()
	end
	local xs = {}
	for k, v in pairs(variables) do
		xs[k] = v[1]
	end
	return xs
end

return { solve = solve }
