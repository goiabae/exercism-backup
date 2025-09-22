local BankAccount = {}

function BankAccount:new()
	local account = {
		_balance = 0,
		_closed = false,
	}
	function account:balance()
		return self._balance
	end
	function account:deposit(n)
		if n <= 0 or self._closed then
			error("deposit must be positive")
		end
		self._balance = self._balance + n
	end
	function account:withdraw(n)
		if n > self._balance or n <= 0 or self._closed then
			error("")
		end
		self._balance = self._balance - n
	end
	function account:close()
		self._closed = true
	end
	return account
end

return BankAccount
