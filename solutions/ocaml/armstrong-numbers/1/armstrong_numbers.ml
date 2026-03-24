open Base

let _ = List.sum (module Int) [1; 2; 3] ~f:(fun x -> x)

let validate (candidate : int) : bool =
  let digits = String.to_list (Int.to_string candidate) in
  List.map ~f:(fun x -> Char.(to_int x - to_int '0') ** (List.length digits)) digits
  |> (List.sum (module Int) ~f:(fun x -> x))
  |> (fun x -> x = candidate)
