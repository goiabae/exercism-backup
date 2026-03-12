namespace ArmstrongNumbers

def log10Floor (n : Nat) : Nat :=
  if n < 10 then
    0
  else
    1 + log10Floor (n / 10)

def isArmstrongNumber (number : Nat) : Bool :=
  let len := (log10Floor number) + 1
  Nat.toDigits 10 number
  |> List.map (fun c => c.toNat - '0'.toNat)
  |> List.map (· ^ len)
  |> List.sum
  |> (· == number)

end ArmstrongNumbers
