let aliquot_sum n =
  let rec aux sum fac =
    if fac < n then
      aux (if (n mod fac) = 0 then sum + fac else sum) (fac + 1)
    else
      sum
  in aux 0 1

let classify (n: int): (string, string) result =
  if n <= 0 then
    Error "Classification is only possible for positive integers."
  else
  let sum = aliquot_sum n in
  if sum < n then Ok "deficient" else
  if sum == n then Ok "perfect" else
  Ok "abundant"
