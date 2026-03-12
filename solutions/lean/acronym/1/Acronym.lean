namespace Acronym

def splitOnMany (s : String) (on: List Char) : List String :=
  s.split (on.contains ·)

def abbreviate (phrase : String) : String :=
  splitOnMany phrase [' ', '-', '_']
  |> .filter (·.isEmpty.not)
  |> .map (·.front.toUpper)
  |> String.mk


end Acronym
