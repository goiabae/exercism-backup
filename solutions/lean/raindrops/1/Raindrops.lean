namespace Raindrops

def convert (x : Nat) : String :=
  if ! (x % 3 == 0 || x % 5 == 0 || x % 7 == 0) then
    s!"{x}"
  else
    (if x % 3 == 0 then "Pling" else "")
    ++ (if x % 5 == 0 then "Plang" else "")
    ++ (if x % 7 == 0 then "Plong" else "")

end Raindrops
