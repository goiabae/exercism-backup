import Std

namespace Isogram

def isIsogram (phrase : String) : Bool :=
  let letters := phrase.toList.filter Char.isAlpha |>.map Char.toUpper
  (Std.HashSet.ofList letters).size == letters.length

end Isogram
