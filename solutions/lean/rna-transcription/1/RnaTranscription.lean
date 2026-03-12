namespace RnaTranscription

def toRna (dna : String) : String :=
  dna.map (fun c => match c with
    | 'A' => 'U'
    | 'C' => 'G'
    | 'G' => 'C'
    | 'T' => 'A'
    | _ => panic "unreachable"
  )

end RnaTranscription
