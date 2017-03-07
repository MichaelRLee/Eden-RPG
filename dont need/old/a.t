var stream : int
var temp : string

open : stream, "settings.txt", get
for i : 1..7
get : stream, temp
put temp
end for
close : stream