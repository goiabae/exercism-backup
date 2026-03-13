namespace Grains

def grains (square : Int) : Option Nat :=
  if square <= 0 || square > 64 then
    none
  else
    some (Int.toNat (Int.pow 2 (Int.toNat (square - 1))))

def totalGrains : Nat :=
  let id := fun x => x
  let seq := List.map Nat.succ (List.range 64)
  match List.mapM id (List.map (fun x => grains (Int.ofNat x)) seq) with
  | none => 0
  | some ns =>
    List.sum ns

end Grains
