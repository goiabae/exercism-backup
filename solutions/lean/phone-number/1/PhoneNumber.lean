namespace PhoneNumber

def clean (phrase : String) : Option String :=
  if phrase.any (fun c => c.isAlpha || c == '@' || c == ':' || c == '!') then
    none
  else

  let digits := String.mk (phrase.toList.filter Char.isDigit)
  let count := digits.length

  if count == 9
  || (count == 11 && digits.front != '1')
  || count > 11
  then
    none
  else

  let digits := if count == 11 then digits.drop 1 else digits
  let areaCode := digits.take 3
  let exchangeCode := (digits.drop 3).take 3

  if exchangeCode.front == '1'
  || exchangeCode.front == '0'
  || areaCode.front == '1'
  || areaCode.front == '0'
  then
    none
  else
    some digits

end PhoneNumber
