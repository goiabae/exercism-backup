open Base

let square_root (radicand : int) : int =
  let radicand = Float.of_int radicand in
  let err = 0E-10 in
  let rec aux (r : float) : float =
    if Float.((abs (radicand - r*r)) <= err) then
      r
    else
      aux Float.((r + (radicand / r)) / 2.0)
  in Float.to_int (aux (radicand))
