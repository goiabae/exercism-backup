namespace Bob

private def isUpper (s : String) :=
  let s := List.filter Char.isAlpha (String.toList s)
  (! (List.isEmpty s)) && (List.all s Char.isUpper)

def response (heyBob : String) : String :=
  let s := String.trim heyBob
  if String.isEmpty s then
    "Fine. Be that way!"
  else match (isUpper s, (String.stripSuffix s "?") != s) with
    | (true, true) => "Calm down, I know what I'm doing!"
    | (true, false) => "Whoa, chill out!"
    | (false, true) => "Sure."
    | (false, false) => "Whatever."

end Bob
