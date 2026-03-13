namespace Hamming

inductive Nucleotide where
  | A
  | C
  | G
  | T
deriving DecidableEq

private def convert : Char -> Option Nucleotide
| 'A' => some .A
| 'C' => some .C
| 'G' => some .G
| 'T' => some .T
| _ => none

private def parse (str: String) : Option (List Nucleotide) :=
  (str.toList.mapM convert).map .reverse

def distance (strand1 : String) (strand2 : String) : Option Nat :=
  if strand1.length != strand2.length then
    none
  else
  let ons1 := parse strand1
  let ons2 := parse strand2
  Option.bind ons1 (fun ns1 =>
    ons2.bind (fun ns2 =>
      some (List.sum (List.zipWith (fun x y => if x != y then 1 else 0) ns1 ns2))
    )
  )

end Hamming
