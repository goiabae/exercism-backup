import Std.Time

namespace Gigasecond

def add (moment : Std.Time.PlainDateTime) : Std.Time.PlainDateTime :=
  moment.addSeconds 1000000000

end Gigasecond
