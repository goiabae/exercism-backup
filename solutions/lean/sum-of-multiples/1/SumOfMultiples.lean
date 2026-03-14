import Std

namespace SumOfMultiples

def sum (factors : List UInt64) (limit : UInt64) : UInt64 :=
  let limit' := UInt64.toNat limit
  let factors' := List.map UInt64.toNat factors
  factors'.foldl (fun set fac =>
    List.range limit'
    |>.map (· * fac)
    |>.filter (· < limit')
    |>.foldl Std.HashSet.insert set
  ) Std.HashSet.emptyWithCapacity
  |>.toList
  |>.sum
  |> UInt64.ofNat

end SumOfMultiples
