namespace IsbnVerifier

inductive Control { α : Type } where
  | yield: α -> Control
  | break
  | continue
  | fail

abbrev Iteration (α : Type) := List (Control (α := α))

def sequence { α : Type } (i : Iteration α) : Option (List α) :=
  let rec aux (is : List (Control (α := α))) (acc : List α) :=
    match is with
    | [] => .some acc
    | .break :: _ => .some acc
    | .continue :: is => aux is acc
    | .yield v :: is => aux is (v :: acc)
    | .fail :: _ => .none
  Option.map List.reverse (aux i [])

def isValid (s : String) : Bool :=
  if s.isEmpty then
    false
  else
  let lastChar := String.back s
  let digits := String.toList s |> List.map (fun c =>
    if Char.isDigit c then
      .yield ((Char.toUInt8 c) - Char.toUInt8 '0')
    else if (c == 'X' && lastChar == 'X') then
      .yield 10
    else if Char.isAlpha c then
      .fail
    else
      .continue
  ) |> sequence
  match digits with
  | .none => false
  | .some digits =>
    if 10 != List.length digits then
      false
    else
      List.range (List.length digits)
      |> List.map (fun i =>
        let j := (List.length digits) - i - 1
        (i + 1) * (List.getD digits j 0).toNat
      )
      |> List.sum
      |> (fun sum => 0 == (sum % 11))

end IsbnVerifier
