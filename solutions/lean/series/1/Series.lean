namespace Series

def slices (s : String) (length : Nat) : Option (Array String) :=
  if s.isEmpty
  || length == 0
  || length > s.length
  || length < 0
  then
    none
  else
    Array.range (s.length - length + 1)
    |>.map (fun i => s.extract ⟨i⟩ ⟨i+length⟩)
    |> some

end Series
