
local function list_fold (xs, init, f)
	local acc = init
	for _, x in ipairs(xs) do
		acc = f(acc, x)
	end
	return acc
end

---@generic T, U
---@param xs T[]
---@param f fun (x: T): U
---@return U[]
local function list_map (xs, f)
	local ys = {}
	for _, x in ipairs(xs) do
		table.insert(ys, f(x))
	end
	return ys
end

local function string_split(str, delimiter)
	local result = {}
	for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

local function list_print (p)
	return function (xs)
		local s = ''
		s = s .. '{'
		for _, x in ipairs(xs) do
			s = s .. ' ' .. p(x)
		end
		s = s .. ' }'
		return s
	end
end

local function quoted (s)
	return '"' .. s .. '"'
end

---@class Option<T>
---@field is_some fun (self: any): boolean
---@field some fun (self: any): `T`

---@class None<T>: Option<T>
---@class Some<T>: Option<T>

---@generic T
---@return None<T>
local function None ()
	return {
		is_some = function (_) return false end,
		some = function (_) error() end,
	}
end

---@generic T
---@return Some<T>
local function Some (x)
	return {
		is_some = function (_) return true end,
		some = function (_) return x end,
	}
end

local function option_bind (o, f)
	if o:is_some() then
		return f(o:some())
	else
		return None()
	end
end

local function list_drop (xs, n)
	if #xs == 0 then
		return None()
	end
	local ys = {}
	for i = 1, #xs-n do
		table.insert(ys, xs[i])
	end
	return Some(ys)
end

local function list_skip (xs, n)
	local ys = {}
	for i = n+1, #xs do
		table.insert(ys, xs[i])
	end
	return ys
end

local function Word (name, f)
	return {
		type = "word",
		name = name,
		func = f,
	}
end

local function Phrase (p)
	return {
		type = "phrase",
		phrase = p,
	}
end

local function append (xs, z)
	local ys = {}
	for _, x in ipairs(xs) do
		table.insert(ys, x)
	end
	table.insert(ys, z)
	return ys
end

local function list_rev (xs)
	local ys = {}
	for i = #xs, 1, -1 do
		table.insert(ys, xs[i])
	end
	return ys
end

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

local function binop (name, op)
	return Word(name, function (env, stk)
		if #stk >= 2 then
			local x = stk[#stk]
			local y = stk[#stk-1]
			local rest = list_drop(stk, 2):some()
			return Some { env, append(rest, op(y, x)) }
		else
			return None()
		end
	end)
end

local plus = binop("+", function (x, y) return x + y end)
local minus = binop("-", function (x, y) return x - y end)
local times = binop("*", function (x, y) return x * y end)

local div = binop("/", function (x, y)
	if y == 0 then error() end
	return math.floor(x / y)
end)

local dup = Word("dup", function (env, stk)
	if #stk >= 1 then
		local x = stk[#stk]
		local rest = list_drop(stk, 1):some()
		return Some { env, append(append(rest, x), x) }
	else
		return None()
	end
end)

local swap = Word("swap", function (env, stk)
	if #stk >= 2 then
		local x = stk[#stk]
		local y = stk[#stk - 1]
		local rest = list_drop(stk, 2):some()
		return Some { env, append(append(rest, x), y) }
	else
		return None()
	end
end)

local over = Word("over", function (env, stk)
	if #stk >= 2 then
		local y = stk[#stk - 1]
		return Some { env, append(stk, y) }
	else
		return None()
	end
end)

local drop = Word("drop", function (env, stk)
	if #stk >= 1 then
		local rest = list_drop(stk, 1):some()
		return Some { env, rest }
	else
		return None()
	end
end)

local exn = Word("exn", function (_, _) return None() end)
local nop = Word("nop", function (env, stk) return Some { env, stk } end)

local function const (num)
	return Word(tostring(num), function (env, stk)
		return Some { env, append(stk, num) }
	end)
end

local function prepend (z, xs)
	local ys = { z }
	for _, x in ipairs(xs) do
		table.insert(ys, x)
	end
	return ys
end

local function initial_env ()
	return {
		["+"] = plus,
		["-"] = minus,
		["*"] = times,
		["/"] = div,
		["dup"] = dup,
		["swap"] = swap,
		["over"] = over,
		["drop"] = drop,
	}
end

local printer = list_print(function (x) return quoted(tostring(x)) end)
local printer2 = list_print(function (x) return quoted(x.name) end)

local function compile_phrase (tks, env)
	local function f (acc, tk)
		local n = tonumber(tk)
		if n then
			return prepend(const(n), acc)
		else
			local code = env[string.lower(tk)]
			if not code then
				return prepend(exn, acc)
			else
				if code.type == "word" then
					return prepend(code, acc)
				elseif code.type == "phrase" then
					return concat(list_rev(code.phrase), acc)
				else
					error()
				end
			end
		end
	end
	local t1 = list_fold(tks, {}, f)
	local t2 = list_rev(t1)
	return Phrase(t2)
end

local function def (name, phrase)
	return Word(name, function (env, stk)
		env[string.lower(name)] = phrase
		return Some { env, stk }
	end)
end

local function compile (env, words)
	if #words == 0 then
		return nop
	elseif #words == 1 and words[1] == ":" then
		return exn
	elseif #words >= 2 and words[1] == ":" then
		local name = words[2]
		local rest = list_skip(words, 2)
		if string.match(name, "%d+") == name then
			return exn
		else
			local t1 = (#rest > 0) and rest[#rest] or nil
			local t2 = list_drop(rest, 1)
			if t1 == nil then
				return exn
			elseif t1 and t1 == ";" and not t2:is_some() then
				return exn
			elseif t1 and t1 == ";" and t2:is_some() and #(t2:some()) == 0 then
				return exn
			elseif t1  and t1 == ";" and t2:is_some() then
				local phrase = t2:some()
				if string.match(name, "^-?%d+$") == name then
					error()
				end
				return def(name, compile(env, phrase))
			elseif t1 then
				assert(false)
				return exn
			else
				error(0)
			end
		end
	else
		local phrase = words
		return compile_phrase(phrase, env)
	end
end

local function eval_code (env, stk, code)
	local function aux (state, code2)
		return option_bind(state, function (pair)
			local env2, stk2 = table.unpack(pair)
			return eval_code(env2, stk2, code2)
		end)
	end
	if code.type == "word" then
		return code.func(env, stk)
	elseif code.type == "phrase" then
		return list_fold(code.phrase, Some { env, stk }, aux)
	else
		error()
	end
end

---@param line string
---@return string[]
local function parse_line (line)
	return string_split(string.lower(line), ' ')
end

---@param ast string[][]
---@return Option<any>
local function eval (ast)
	local function aux (state, line)
		return option_bind(state, function (pair)
			local env, stk = table.unpack(pair)
			return eval_code(env, stk, compile(env, line))
		end)
	end
	return list_fold(ast, Some { initial_env(), {} }, aux)
end

local function get_stack (result)
	local _, stk = table.unpack(result)
	return Some(stk)
end

local function evaluate(instructions)
	local ast = list_map(instructions, parse_line)
	local result = eval(ast)
	return option_bind(result, get_stack):some()
end

return { evaluate = evaluate }
