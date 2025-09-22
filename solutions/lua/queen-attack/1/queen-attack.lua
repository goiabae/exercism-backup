return function (quin)
	if quin.row < 0 or quin.row > 7 or quin.column < 0 or quin.column > 7 then
		error("")
	end
	function quin.can_attack(other)
		return
			quin.row == other.row
			or quin.column == other.column
			or math.abs(quin.column - other.column) == math.abs(quin.row - other.row)
	end
	return quin
end
