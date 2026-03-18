import Std

namespace AtbashCipher

def List.chunksOf { α : Type } (n : Nat) (xs : List α) : List (List α) :=
  let chunkCount := (xs.length / n) + if xs.length % n != 0 then 1 else 0
  List.range chunkCount |> List.map (fun i => List.take n (List.drop (n * i) xs))

def List.intersperse { α : Type } (sep : α) (xs : List α) :=
  match xs with
  | [] => []
  | x :: [] => [x]
  | x :: xss => x :: sep :: (List.intersperse sep xss)

def alphabet :=
  List.range 26 |> List.map (fun i => Char.ofUInt8 (i.toUInt8 + Char.toUInt8 'a'))

def String.filter (f : Char -> Bool) (s : String) : String :=
  String.mk (s.toList.filter f)

def encodeBlocks (text : String) : List String :=
  let blockSize := Nat.min 5 text.length
  let conv : Std.HashMap Char Char := List.zip alphabet alphabet.reverse |> Std.HashMap.ofList
  text.toList
  |>.filter Char.isAlphanum
  |>.map (fun c => if Char.isAlpha c then conv.getD (Char.toLower c) 'a' else c)
  |> List.chunksOf blockSize
  |>.map String.mk

def encode (text : String) : String :=
  List.intersperse " " (encodeBlocks text) |> List.foldl (fun acc x => acc ++ x) ""

def decode (text : String) : String :=
  let conv : Std.HashMap Char Char := List.zip alphabet.reverse alphabet |> Std.HashMap.ofList
  String.filter Char.isAlphanum text
  |>.map (fun c => if Char.isAlpha c then conv.getD (Char.toLower c) 'a' else c)

end AtbashCipher
