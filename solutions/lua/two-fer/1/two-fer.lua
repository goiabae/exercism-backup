local TwoFer = {}

function TwoFer.two_fer(name)
	return "One for " .. (name and name or "you") .. ", one for me."
end

return TwoFer
