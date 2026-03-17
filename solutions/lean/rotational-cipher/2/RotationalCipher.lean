namespace RotationalCipher

def convert (c : Char) (key : UInt32) : Char :=
  let start := if c.isUpper then 'A' else 'a'
  let i := (c.toUInt8 - start.toUInt8).toUInt32
  let j := (i + key) % 26
  let to := Char.ofUInt8 (start.toUInt8 + j.toUInt8)
  to

def rotate (key : UInt32) (input : String) : String :=
  input.map fun char =>
    if char.isAlpha then
      convert char key
    else
      char

end RotationalCipher
