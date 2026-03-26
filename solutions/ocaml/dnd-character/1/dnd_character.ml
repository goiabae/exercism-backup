open Base

type character = {
  charisma : int;
  constitution : int;
  dexterity : int;
  hitpoints : int;
  intelligence : int;
  strength : int;
  wisdom : int;
}

let ability () = 3 + Random.int 16

let modifier ~(score : int) : int =
  Float.(iround_down_exn (((of_int score) - 10.0) / 2.0))

let generate_character () : character =
  let constitution = ability () in
  { charisma = ability ();
    constitution = constitution;
    dexterity = ability ();
    hitpoints = 10 + modifier ~score:constitution;
    intelligence = ability ();
    strength = ability ();
    wisdom = ability ();
  }
