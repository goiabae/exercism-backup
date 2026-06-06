
---@alias state
---| 'running'
---| 'stopped'
---| 'ready'

---@class Stopwatch
---@field st state
---@field tot number
---@field cur number
---@field p string[]
local Stopwatch = {}

local function n2t (n)
	local s = math.floor(n % 60)
	local m = math.floor((n % (60 * 60)) / 60)
	local h = math.floor(n / (60 * 60))
	return ('%02d:%02d:%02d'):format(h, m, s)
end

local function t2n (t)
	local h = tonumber(t:sub(1, 2))
	local m = tonumber(t:sub(4, 5))
	local s = tonumber(t:sub(7, 8))
	local n = s + (m * 60) + (h * 60 * 60)
	return n
end

function Stopwatch:new()
  local obj = {}
	obj.st = 'ready'
	obj.tot = 0.0
	obj.cur = 0.0
	obj.p = {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Stopwatch:start()
	if self.st == 'running' then
		error('cannot start an already running stopwatch')
	end
	self.st = 'running'
end

function Stopwatch:stop()
	if self.st == 'stopped' then
		error('cannot stop a stopwatch that is not running')
	elseif self.st == 'ready' then
		error('cannot stop a stopwatch that is not running')
	end
	self.st = 'stopped'
end

function Stopwatch:reset()
	if self.st == 'ready' then
		error('cannot reset a stopwatch that is not stopped')
	elseif self.st == 'running' then
		error('cannot reset a stopwatch that is not stopped')
	end
	self.st = 'ready'
	self.tot = 0.0
	self.cur = 0.0
	self.p = {}
end

function Stopwatch:advance_time(timestamp)
	if self.st == 'running' then
		self.tot = self.tot + t2n(timestamp)
		self.cur = self.cur + t2n(timestamp)
	end
end

function Stopwatch:total()
	return n2t(self.tot)
end

function Stopwatch:lap()
	if self.st ~= 'running' then
		error('cannot lap a stopwatch that is not running')
	end
	table.insert(self.p, n2t(self.cur))
	self.cur = 0.0
end

function Stopwatch:current_lap()
	return n2t(self.cur)
end

function Stopwatch:previous_laps()
	return self.p
end

function Stopwatch:state()
	return self.st
end

return Stopwatch
