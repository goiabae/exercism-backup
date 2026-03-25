open Base

let xs : (string * int) list = [
  ("AEIOULNRST", 1);
  ("DG", 2);
  ("BCMP", 3);
  ("FHVWY", 4);
  ("K", 5);
  ("JX", 8);
  ("QZ", 10);
]

let score (word: string): int =
  if String.is_empty word then 0 else
  List.sum (module Int) (String.to_list word) ~f:(fun c ->
    List.sum (module Int) xs ~f:(fun (k, v) ->
      let matches = List.exists ~f:(fun c2 -> Char.(c2 = uppercase c)) (String.to_list k) in
      v * Bool.to_int matches
    )
  )
