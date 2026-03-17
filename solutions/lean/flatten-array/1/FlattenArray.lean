namespace FlattenArray

inductive Box (α : Type) : Type where
  | zero
  | one (value : α)
  | many (boxes : Array (Box α))

def flatten (box : Box Int) : Array Int :=
  let rec aux (acc : Array Int) (box : Box Int) : Array Int :=
    match box with
    | .zero => acc
    | .one value => acc.push value
    | .many boxes => boxes.foldl aux acc
  aux #[] box

end FlattenArray
