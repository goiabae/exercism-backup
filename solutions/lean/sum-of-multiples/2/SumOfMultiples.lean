import Std

namespace SumOfMultiples

private def ceilDiv (a b : Nat) : Nat :=
  a / b + if a % b = 0 then 0 else 1

def sum (factors : List UInt64) (limit : UInt64) : UInt64 :=
  let limit' := UInt64.toNat limit
  let factors' := List.map UInt64.toNat factors
  factors'.foldl (fun set fac =>
    List.range (ceilDiv limit' fac)
    |>.map (· * fac)
    |> set.insertMany
  ) Std.HashSet.emptyWithCapacity
  |>.toList.sum
  |> UInt64.ofNat

end SumOfMultiples
