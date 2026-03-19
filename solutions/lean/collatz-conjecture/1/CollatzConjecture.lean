namespace CollatzConjecture

def Positive := { x : Nat // 0 < x }

def steps (n : Positive) : Nat :=
  let rec aux (i : Nat) (n : Positive) : Nat :=
    if n == 1 then
      i
    else if (n % 2) == 0 then
      aux (i + 1) (n / 2)
    else
      aux (i + 1) (3 * n + 1)
  aux 0 n

end CollatzConjecture
