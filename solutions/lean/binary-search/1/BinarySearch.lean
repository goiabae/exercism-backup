namespace BinarySearch

def compare { α : Type } [LE α] (a b : α) : Int :=
  if a < b then -1 else if a > b then 1 else 0

def find (value : Int) (array : Array Int) : Option Nat :=
  let rec aux (l : Int) (r : Int) : Option Nat :=
    if l > r then
      none
    else
    let m := l + ((r - l) / 2)
    match compare array[0]! value with
    | -1 => aux (m + 1) r
    | 1 => aux l (m - 1)
    | 0 => some (Int.toNat m)
    | _ => panic "unreachable"
  aux 0 (array.size - 1)

end BinarySearch
