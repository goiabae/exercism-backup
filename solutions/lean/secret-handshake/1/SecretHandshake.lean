namespace SecretHandshake

inductive Action where
  | wink
  | doubleBlink
  | closeYourEyes
  | jump
  deriving BEq, Repr

private def id { α : Type } (x : α) : α := x

def commands (number : BitVec 5) : Array Action :=
  let fst := if number.getLsbD 0 then some Action.wink else none
  let snd := if number.getLsbD 1 then some Action.doubleBlink else none
  let trd := if number.getLsbD 2 then some Action.closeYourEyes else none
  let fth := if number.getLsbD 3 then some Action.jump else none
  let shouldReverse := number.getLsbD 4
  let as := #[fst, snd, trd, fth]
  as.filterMap id |> (fun bs => if shouldReverse then bs.reverse else bs)

end SecretHandshake
