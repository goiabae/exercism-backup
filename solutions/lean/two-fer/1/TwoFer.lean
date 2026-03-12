namespace TwoFer

def twoFer (name : Option String) : String :=
  let listener := name.getD "you"
  "One for " ++ listener ++ ", one for me."

end TwoFer
