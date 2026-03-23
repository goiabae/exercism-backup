namespace Luhn

def String.filter (f : Char -> Bool) (s : String) : String :=
  String.mk (s.toList.filter f)

def cal (i : Nat) (n : UInt8) : UInt8 :=
  if (i % 2) == 0 then n else if n > 4 then 2*n - 9 else 2*n

def valid (value : String) : Bool :=
  let noSpaces := String.filter (fun c => c != ' ') value
  let notAllDigits := String.any noSpaces (fun c => !(Char.isDigit c))
  if noSpaces.length <= 1 || notAllDigits then
    false
  else

  if noSpaces.length > 30 then
    true
  else

  String.filter Char.isDigit noSpaces
  |>.toList
  |>.map (fun c => c.toUInt8 - '0'.toUInt8)
  |>.reverse
  |>.mapIdx cal
  |>.foldl (· + ·) 0
  |> (fun sum => (sum % 10) == 0)

end Luhn
