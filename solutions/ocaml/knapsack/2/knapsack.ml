open Base

type item = {
  weight : int;
  value : int;
}

let maximum_value (items: item list) (capacity: int): int =
  let m: int array array = Array.init ((List.length items) + 1) ~f:(fun _ -> Array.create ~len:(capacity + 1) 0)in
  let items = Array.of_list items in
  let n = Array.length items in

  begin
    for i = 1 to n do
      for j = 1 to capacity do
        m.(i).(j) <-
          if items.(i-1).weight > j then
            m.(i-1).(j)
          else
            Int.max m.(i-1).(j) (m.(i-1).(j-items.(i-1).weight) + items.(i-1).value)
      done
    done;
    m.(n).(capacity)
  end
