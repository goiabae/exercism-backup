namespace Diamond

def UInt8.toInt32 (x : UInt8) : Int32 := Int32.ofNat x.toNat
def abs (x : Int32) : Int32 := if x < 0 then -x else x

def rows (which : Char) : List String :=
  let letterCount := which.toUInt8 - 'A'.toUInt8 + 1
  let rowCount := letterCount*2 - 1
  List.range rowCount.toNat
  |> List.map (fun rowIdx =>
    let i := if rowIdx.toInt32 < (UInt8.toInt32 letterCount) then
      Int32.ofNat rowIdx
    else
      (UInt8.toInt32 rowCount) - rowIdx.toInt32 - 1
    let letter := Char.ofUInt8 ('A'.toUInt8 + i.toNatClampNeg.toUInt8)
    List.range rowCount.toNat
    |> List.map (fun col =>
      let centerDist := abs ((Int32.ofNat col) - (UInt8.toInt32 letterCount) + 1)
      if centerDist == i then letter else ' '
    )
    |> String.mk
  )

end Diamond
