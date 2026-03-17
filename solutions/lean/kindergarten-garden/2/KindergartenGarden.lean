namespace KindergartenGarden

inductive Plant where
  | grass | clover | radishes | violets
  deriving BEq, Repr, Inhabited

def listToVector? (n : Nat) (xs : List α) : Option (Vector α n) :=
  if h : xs.length = n then
    some ⟨xs.toArray, h⟩
  else
    none

def plantsList (diagram : String) (student : String) : List Plant :=
  let diagram := String.splitOn diagram "\n"
  let idx := (student.front.toUInt8 - 'A'.toUInt8).toNat
  let f (row : String) : List Plant :=
    let d : String := row.extract ⟨idx*2⟩ ⟨idx*2+1+1⟩
    d.toList.map (fun p =>
      match p with
      | 'V' => .violets
      | 'R' => .radishes
      | 'C' => .clover
      | 'G' => .grass
      | _ => .violets
    )
  (diagram.map f).flatten

def plants (diagram : String) (student: String) : Vector Plant 4 :=
  plantsList diagram student |> listToVector? 4 |> Option.get!

end KindergartenGarden
