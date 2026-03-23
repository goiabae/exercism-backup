namespace House

abbrev VerseIndex := { x : Nat // 1 ≤ x ∧ x ≤ 12 }

def subjects := #[
  "the house that Jack built",
  "the malt",
  "the rat",
  "the cat",
  "the dog",
  "the cow with the crumpled horn",
  "the maiden all forlorn",
  "the man all tattered and torn",
  "the priest all shaven and shorn",
  "the rooster that crowed in the morn",
  "the farmer sowing his corn",
  "the horse and the hound and the horn",
]

def verbs := #[
  "lay in",
  "ate",
  "killed",
  "worried",
  "tossed",
  "milked",
  "kissed",
  "married",
  "woke",
  "kept",
  "belonged to",
  "",
]

def verse which :=
  List.range which
  |> List.map (fun i =>
    if i == (which - 1) then
      "This is " ++ subjects[which-1]!
    else
      "that " ++ verbs[i]! ++ " " ++ subjects[i]!
  )
  |> List.reverse
  |> String.intercalate " "
  |> (· ++ ".")

def recite (startVerse endVerse : VerseIndex) : String :=
  List.range (endVerse - startVerse + 1)
  |>.map (· + startVerse |> verse)
  |> String.intercalate "\n\n"

end House
