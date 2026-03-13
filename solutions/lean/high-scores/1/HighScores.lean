namespace HighScores

def latestList (scores : List Nat) : Nat :=
  scores.toArray.back!

def latestArray (scores : Array Nat) : Nat :=
  scores.back!

def personalBestArray (scores : Array Nat) : Nat :=
  scores.foldr Nat.max 0

def personalBestList (scores : List Nat) : Nat :=
  personalBestArray scores.toArray

def personalTopThreeArray (scores : Array Nat) : Array Nat :=
  scores
  |>.qsort (lt := fun x y => x > y)
  |>.take 3

def personalTopThreeList (scores : List Nat) : List Nat :=
  (personalTopThreeArray (scores.toArray)).toList

end HighScores
