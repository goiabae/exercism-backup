namespace EliudsEggs

def eggCount (number : Nat) : Nat :=
  (number % 2) + (if number <= 1 then 0 else (eggCount (number / 2)))

end EliudsEggs
