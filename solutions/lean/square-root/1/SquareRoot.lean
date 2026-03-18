namespace SquareRoot

def squareRoot (radicand : Nat) : Nat := Id.run do
  let mut r := radicand.toFloat
  let err := 0E-10
  while (radicand.toFloat - r*r).abs > err do
    r := (r + (radicand.toFloat / r)) / 2
  return r.toUInt64.toNat

end SquareRoot
