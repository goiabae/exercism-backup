namespace Allergies

inductive Allergen where
  | eggs : Allergen
  | peanuts : Allergen
  | shellfish : Allergen
  | strawberries : Allergen
  | tomatoes : Allergen
  | chocolate : Allergen
  | pollen : Allergen
  | cats : Allergen
  deriving BEq, Repr

def toNat : Allergen → Nat
  | .eggs => 1
  | .peanuts => 2
  | .shellfish => 3
  | .strawberries => 4
  | .tomatoes => 5
  | .chocolate => 6
  | .pollen => 7
  | .cats => 8

private def isBitSet (set : UInt64) (n : UInt64) : Bool :=
  (UInt64.shiftRight (UInt64.land set (UInt64.shiftLeft 1 (n - 1))) (n - 1)) == 1

def allergicTo (allergen : Allergen) (score : Nat) : Bool :=
  let set := UInt64.ofNat score
  isBitSet set (UInt64.ofNat (toNat allergen))

def list (score : Nat) : List Allergen :=
  let als := [.eggs, .peanuts, .shellfish, .strawberries, .tomatoes, .chocolate, .pollen, .cats]
  List.filter (allergicTo · score) als

end Allergies
