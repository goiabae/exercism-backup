namespace KindergartenGarden

inductive Plant where
  | grass | clover | radishes | violets
  deriving BEq, Repr

def firstChar (s : String) : Char :=
  s.front

def listToVector? (xs : List α) (n : Nat) : Option (Vector α n) :=
  if h : xs.length = n then
    some ⟨xs.toArray, h⟩
  else
    none

def plants (diagram : String) (student: String) : Vector Plant 4 :=
  let diagram := String.splitOn diagram "\n"
  let idx := (UInt8.toNat ((Char.toUInt8 (firstChar student)) - (Char.toUInt8 'A')))
  let f (row : String) : List Plant :=
    let d : String := row.extract ⟨idx*2⟩ ⟨idx*2+1⟩
    d.toList.map (fun p =>
      if p == 'V' then
        .violets
      else if p == 'R' then
        .radishes
      else if p == 'C' then
        .clover
      else if p == 'G' then
        .grass
      else
        .violets -- shouldn't happen?
    )
  let ys := List.map f diagram |> List.flatten
  match listToVector? ys 4 with
  | some zs => zs
  | none => (throw "this" : Vector Plant 4)

/- ---@param str string
 - ---@param sep string
 - ---@return string[]
 - local function split_on(str, sep)
 - 	local res = {}
 - 	local beg, fin = 1, 1
 - 	while fin <= #str do
 - 		if str:sub(fin, fin) == sep then
 - 			local s = str:sub(beg, fin-1) or ''
 - 			table.insert(res, s)
 - 			beg, fin = fin+1, fin+1
 - 		else
 - 			fin = fin + 1
 - 		end
 - 	end
 - 	table.insert(res, str:sub(beg))
 - 	return res
 - end
 -
 - local plant_names = {
 - 	["V"] = "violets",
 - 	["R"] = "radishes",
 - 	["C"] = "clover",
 - 	["G"] = "grass",
 - }
 -
 - return function(s)
 - 	local diagram = split_on(s, "\n")
 - 	local garden = {}
 - 	function garden.plants(student)
 - 		local idx = student:sub(1, 1):byte() - string.byte("A")
 - 		local res = {}
 - 		for _, row in ipairs(diagram) do
 - 			local d = row:sub(1+idx*2, 1+idx*2+1)
 - 			assert(#d == 2)
 - 			for p in string.gmatch(d, '.') do
 - 				table.insert(res, plant_names[p])
 - 			end
 - 		end
 - 		return res
 - 	end
 - 	return garden
 - end -/


end KindergartenGarden
