open Base

let ys = function
  | 'A' | 'E' | 'I' | 'O' | 'U' | 'L' | 'N' | 'R' | 'S' | 'T' -> 1
  | 'D' | 'G' -> 2
  | 'B' | 'C' | 'M' | 'P' -> 3
  | 'F' | 'H' | 'V' | 'W' | 'Y' -> 4
  | 'K' -> 5
  | 'J' | 'X' -> 8
  | 'Q' | 'Z' -> 10
  | _ -> 0

let score (word: string): int =
  if String.is_empty word then 0 else
  List.sum (module Int) String.(to_list (uppercase word)) ~f:ys
