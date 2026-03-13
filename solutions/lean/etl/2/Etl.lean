import Std

namespace Etl

def transform (legacy : Std.HashMap Nat (List Char)) : Std.HashMap Char Nat :=
  legacy.fold (fun acc n cs =>
    cs.foldl (·.insert ·.toLower n) acc
  ) ∅

end Etl
