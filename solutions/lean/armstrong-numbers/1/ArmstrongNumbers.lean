namespace ArmstrongNumbers

def log10Floor (n : Nat) : Nat :=
  if n < 10 then
    0
  else
    1 + log10Floor (n / 10)

def digitsRev : Nat → List Nat
  | 0 => [0]
  | n =>
    if n < 10 then
      [n]
    else
      (n % 10) :: digitsRev (n / 10)

def sumList (xs : List Nat) : Nat :=
  xs.foldl (fun acc x => acc + x) 0

def isArmstrongNumber (number : Nat) : Bool :=
  if number < 10 then
    true
  else
    let len := (log10Floor number) + 1
    digitsRev number
    |> .map (· ^ len)
    |> sumList
    |> (· == number)

end ArmstrongNumbers
