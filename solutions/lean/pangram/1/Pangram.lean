import Std

namespace Pangram

def setEq {α} [BEq α] [Hashable α] (a b : Std.HashSet α) : Bool :=
  a.size == b.size && a.all (fun x => b.contains x)

def isPangram (sentence : String) : Bool :=
  let xs :=
    sentence.toList
    |>.filter Char.isAlpha
    |>.map Char.toLower
    |> Std.HashSet.ofList
  let ys :=
    List.range 26
    |>.map (fun o => Char.ofUInt8 ('a'.toUInt8 + o.toUInt8))
    |> Std.HashSet.ofList
  setEq xs ys

end Pangram
