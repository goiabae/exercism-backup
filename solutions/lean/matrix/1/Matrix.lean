namespace Matrix

def row (xs : String) (n : Nat) : List Nat :=
  (xs.splitOn "\n")[n-1]!.splitOn " " |>.map (·.toNat!)

def column (xs : String) (n : Nat) : List Nat :=
  (xs.splitOn "\n").map (fun row =>
    (row.splitOn " ")[n-1]!.toNat!
  )

end Matrix
