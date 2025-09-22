local School = {}

function School:new()
	local school = { count = 0, students = {} }
	self.__index = self
	return setmetatable(school, self)
end

function School:roster()
	local res = {}
	for _, s in pairs(self.students) do
		if res[s.grade] == nil then
			res[s.grade] = {}
		end
		table.insert(res[s.grade], s.name)
	end
	return res
end

function School:add(name, grade)
	for _, s in pairs(self.students) do
		if s.name == name then
			return self
		end
	end
	table.insert(self.students, { name = name, grade = grade })
	table.sort(self.students, function (a, b) return a.grade < b.grade end)
	return self
end

function School:grade(grade_number)
	local res = {}
	for _, s in pairs(self.students) do
		if s.grade == grade_number then
			table.insert(res, s.name)
		end
	end
	return res
end

return School
