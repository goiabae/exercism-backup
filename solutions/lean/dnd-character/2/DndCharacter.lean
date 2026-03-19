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
  let tmp := Int.ofNat score - 10
  tmp / 2

def ability {α} [RandomGen α] (generator : α) : (Nat × α) :=
  let (_1, generator) := RandomGen.next generator
  let (_2, generator) := RandomGen.next generator
  let (_3, generator) := RandomGen.next generator
  let (_4, generator) := RandomGen.next generator
  let (_5, generator) := RandomGen.next generator
  let (_6, generator) := RandomGen.next generator
  (#[_1, _2, _3, _4, _5, _6]|>.map (fun n => (n % 6) + 1) |>.qsort |>.drop 3 |> Array.sum, generator)

def Character.new {α} [RandomGen α] (generator : α) : (Character × α) :=
  let (strength, generator) := ability generator
  let (dexterity, generator) := ability generator
  let (constitution, generator) := ability generator
  let (intelligence, generator) := ability generator
  let (wisdom, generator) := ability generator
  let (charisma, generator) := ability generator
  (Character.mk
    strength dexterity constitution intelligence wisdom charisma (10 + constitution), generator)

end DndCharacter
