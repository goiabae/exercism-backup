namespace DifferenceOfSquares

private def iota (i : Nat) : List Nat := List.map Nat.succ (List.range i)

private def square (x : Nat) : Nat := x * x

def squareOfSum (number : Nat) : Nat :=
  iota number
  |> List.foldl Nat.add 0
  |> square

def sumOfSquares (number : Nat) : Nat :=
  iota number
  |> .map square
  |> List.foldl Nat.add 0

def differenceOfSquares (number : Nat) : Nat :=
  (squareOfSum number) - (sumOfSquares number)

end DifferenceOfSquares
