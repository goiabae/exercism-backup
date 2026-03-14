namespace ScrabbleScore

def xs : List (String × Int) := [
  ("AEIOULNRST", 1),
  ("DG", 2),
  ("BCMP", 3),
  ("FHVWY", 4),
  ("K", 5),
  ("JX", 8),
  ("QZ", 10),
]

def score (word : String) : Int :=
  let f := fun c =>
    xs
    |>.find? (fun p =>
      p.fst.toList.any (· == c.toUpper)
    )
    |>.getD ("", 0)
    |>.snd
  (word.toList.map f).sum

end ScrabbleScore
