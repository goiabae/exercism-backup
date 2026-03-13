namespace Darts

def score (x : Float) (y : Float) : Int :=
  let dist := Float.sqrt (x * x + y * y)
  if dist <= 1 then
    10
  else if dist <= 5 then
    5
  else if dist <= 10 then
    1
  else
    0

end Darts
