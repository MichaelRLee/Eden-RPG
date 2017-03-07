type a :
record
b : string
c : int
end record

var d : array 1..5 of a
var stream : int

for i : 1..5
d (i).b := chr (i + 100)
d (i).c := i
end for

open : stream, "temp.txt", put
for i : 1..5
put : stream, d (i).c
end for
close : stream