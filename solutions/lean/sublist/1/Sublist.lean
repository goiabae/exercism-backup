namespace Sublist

inductive Classification where
  | sublist | superlist | equal | unequal
  deriving BEq, Repr

def windows { α : Type } (xs : List α) (n : Nat) : List (List α) :=
  (List.range (xs.length - n + 1)).map (fun i => xs.drop i |>.take n)

def isSublist { α : Type } [DecidableEq α] (xs : List α) (ys : List α) : Bool :=
  (windows xs ys.length).any (· == ys)

def sublist (listOne listTwo : List Nat) : Classification :=
  if listOne == listTwo then
    .equal
  else if listOne.length > listTwo.length && isSublist listOne listTwo then
    .superlist
  else if listOne.length < listTwo.length && isSublist listTwo listOne then
    .sublist
  else
    .unequal

end Sublist
