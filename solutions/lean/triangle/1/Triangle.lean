namespace Triangle


private def is_triangle (a b c : Float) : Bool :=
  a > 0 && b > 0 && c > 0 && a+b > c && b+c > a && c+a > b

def equilateral (sides : List Float) : Bool :=
  let a := sides[0]!
  let b := sides[1]!
  let c := sides[2]!
  is_triangle a b c && a == b && b == c && a == c

def scalene (sides : List Float) : Bool :=
  let a := sides[0]!
  let b := sides[1]!
  let c := sides[2]!
  (is_triangle a b c) && (a != b) && (b != c) && (a != c)

def isosceles (sides : List Float) : Bool :=
  let a := sides[0]!
  let b := sides[1]!
  let c := sides[2]!
  is_triangle a b c && (!(scalene sides))

end Triangle
