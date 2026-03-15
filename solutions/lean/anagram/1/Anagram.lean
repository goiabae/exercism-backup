namespace Anagram

def swap { α : Type } { β : Type } { γ : Type } (f : α → β → γ) := fun y x => f x y
def fork { α : Type } { β : Type } { γ : Type } { δ : Type } { ε : Type } (f : γ → δ → ε) (g : α → β → γ) (h : α → β → δ) := fun (x : α) (y : β) => f (g x y) (h x y)

def andThen { α : Type } { β : Type } { γ : Type } (f : α → β) (g : β → γ) := fun x => g (f x)

def isAnagram (x : String) (y : String) : Bool :=
  let sort s := String.mk s.toList.toArray.qsort.toList
  sort x == sort y

def findAnagrams (subject : String) (candidates : List String) : List String :=
  candidates.filter (andThen String.toLower (swap (fork (· && ·) (· != ·) isAnagram) subject.toLower))

end Anagram
