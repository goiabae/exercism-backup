open Base

type 'a control =
  | Yield of 'a
  | Break
  | Continue
  | Fail

type 'a iteration = 'a control list

let sequence (i : 'a iteration) : 'a list option =
  let rec aux (is : 'a control list) (acc : 'a list) =
    match is with
    | [] -> Some acc
    | Break :: _ -> Some acc
    | Continue :: is -> aux is acc
    | Yield v :: is -> aux is (v :: acc)
    | Fail :: _ -> None
  in Option.map (aux i []) ~f:List.rev

let is_valid s =
  if List.is_empty (String.to_list s) then
    false
  else
  let last_char = String.to_list s |> List.last_exn in
  let digits = s
    |> String.to_list
    |> List.map ~f:(fun c ->
      if Char.is_digit c then
        Yield Char.(to_int c - to_int '0')
      else if Char.(c = 'X' && last_char = 'X') then
        Yield 10
      else if Char.is_alpha c then
        Fail
      else
        Continue
    )
    |> sequence
  in match digits with
    | None -> false
    | Some digits ->
       if 10 <> List.length digits then
         false
       else
         List.init (List.length digits) ~f:(fun i ->
           let j = (List.length digits) - i - 1 in
           (i + 1) * (List.nth_exn digits j)
         )
         |> List.sum (module Int) ~f:(fun x -> x)
         |> (fun sum -> 0 = sum % 11)
