namespace LineUp



def format (name : String) (number : Fin 1000) : String :=
  let th := s!"{name}, you are the {number}th customer we serve today. Thank you!"
  let st := s!"{name}, you are the {number}st customer we serve today. Thank you!"
  let nd := s!"{name}, you are the {number}nd customer we serve today. Thank you!"
  let rd := s!"{name}, you are the {number}rd customer we serve today. Thank you!"
  match s!"{number}".toList.reverse with
  | _ :: '1' :: _ => th
  | '1' :: _ => st
  | '2' :: _ => nd
  | '3' :: _ => rd
  | _ => th

end LineUp
