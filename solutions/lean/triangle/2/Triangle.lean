namespace Triangle

private def is_triangle (f : Float → Float → Float → Bool) (sides : List Float) : Bool :=
  match sides with
  | [a, b, c] => a > 0 && b > 0 && c > 0 && a+b > c && b+c > a && c+a > b && f a b c
  | _ => false

def equilateral : List Float → Bool :=
  is_triangle (fun a b c => a == b && b == c && a == c)

def scalene : List Float → Bool :=
  is_triangle (fun a b c => (a != b) && (b != c) && (a != c))

def isosceles : List Float → Bool :=
  fun sides => is_triangle (fun _ _ _ => ! scalene sides) sides

end Triangle
