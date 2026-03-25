open Base

let sum factors limit =
  List.fold_left factors ~init:(Set.empty (module Int)) ~f:(fun set fac ->
    if fac <> 0 then
      List.range ~stride:fac 0 limit |> List.fold_left ~init:set ~f:Set.add
    else set
  )
  |> Set.sum (module Int) ~f:(fun x -> x)
