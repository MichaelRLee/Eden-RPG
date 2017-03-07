var a : int := Pic.FileNew ("images/lake.bmp")
var x, y, button : int

Pic.Draw (a,1,1,picCopy)
loop
mousewhere (x,y,button)
locate (24, 70)
put whatdotcolour (x,y)
end loop