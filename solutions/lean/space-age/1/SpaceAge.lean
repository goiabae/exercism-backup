namespace SpaceAge

inductive Planet where
  | Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Neptune
  | Uranus

def orbitalPeriod (p : Planet) :=
  let secondsInYear := 31557600.0
  let periodInYears := match p with
    | .Mercury => 0.2408467
    | .Venus => 0.61519726
    | .Earth => 1.0
    | .Mars => 1.8808158
    | .Jupiter => 11.862615
    | .Saturn => 29.447498
    | .Uranus => 84.016846
    | .Neptune => 164.79132
  secondsInYear * periodInYears

def age (planet : Planet) (seconds : Nat) : Float :=
  seconds.toFloat / (orbitalPeriod planet)

end SpaceAge
