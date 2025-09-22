return {
  transform = function(dataset)
		local new = {}
		for k, vs in pairs(dataset) do
			for _, v in ipairs(vs) do
				new[string.lower(v)] = k
			end
		end
		return new
  end
}
