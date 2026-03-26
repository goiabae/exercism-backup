let nth_prime number =
  if number == 0 then
    Error "there is no zeroth prime"
  else
  let rec aux ps i =
    if number <= List.length ps then
      List.hd ps
    else
      let is_prime = List.for_all (fun p -> (i mod p) <> 0) ps in
      if is_prime then
        aux (i :: ps) (i + 1)
      else
        aux ps (i + 1)
  in Ok (aux [] 2)
