namespace DndCharacter

structure Character where
  mk ::
  strength     : Nat
  dexterity    : Nat
  constitution : Nat
  intelligence : Nat
  wisdom       : Nat
  charisma     : Nat
  hitpoints    : Int

def modifier (score : Nat) : Int :=
  (Int.ofNat score - 10) / 2

def ability {α} [RandomGen α] (generator : α) : (Nat × α) :=
  let (_1, generator) := randNat generator 1 6
  let (_2, generator) := randNat generator 1 6
  let (_3, generator) := randNat generator 1 6
  let (_4, generator) := randNat generator 1 6
  let (_5, generator) := randNat generator 1 6
  let (_6, generator) := randNat generator 1 6
  (#[_1, _2, _3, _4, _5, _6] |>.qsort (lt := fun x y => x > y) |>.take 3 |> Array.sum, generator)

def Character.new {α} [RandomGen α] (generator : α) : (Character × α) :=
  let (strength, generator) := ability generator
  let (dexterity, generator) := ability generator
  let (constitution, generator) := ability generator
  let (intelligence, generator) := ability generator
  let (wisdom, generator) := ability generator
  let (charisma, generator) := ability generator
  (Character.mk
    strength dexterity constitution intelligence wisdom charisma (10 + modifier constitution), generator)

end DndCharacter
