import Std

namespace Etl

def transform (legacy : Std.HashMap Nat (List Char)) : Std.HashMap Char Nat :=
  legacy.fold (fun acc n cs =>
    cs.foldr (fun c acc => acc.insert c.toLower n) acc
  ) Std.HashMap.emptyWithCapacity

end Etl
