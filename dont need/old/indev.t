%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           CHANGES NEEDED                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                               %
%   Add random encounters when in grass (bright green colour)                   %
%                                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setscreen ("graphics:800;600,nobuttonbar")

var playerImages : array 1 .. 3, 1 .. 2 of int
var location : array 1 .. 2 of int
var border : int := Pic.FileNew ("images/border.bmp")
var border2 : int := Pic.FileNew ("images/border2.bmp")
var player : int
var key : string (1)
var playerHeight : int := 68
var playerLength := 36
var speed : int := 5
var x, y : int
x := maxx div 2
y := maxy div 2
var count := 1
var playerCount : int
var stationary : int := 0
var direction : int
var out : boolean := false
var battle : int := 0

procedure move
    if hasch then
	count += 1
	stationary := 0
	getch (key)
	if ord (key) = 200 then %up
	    if whatdotcolor (x, y + 15) = 73 and whatdotcolor (x + playerLength, y + 15) = 73 or whatdotcolor (x, y + 15) = 67 and whatdotcolor (x +
		    playerLength, y + 15) = 67 or whatdotcolor (x, y + 15) = 73 and whatdotcolor (x + playerLength, y + 15) = 67 or whatdotcolor (x, y + 15) = 67 and whatdotcolor (x +
		    playerLength, y + 15) = 73 then
		direction := 2
		y += speed
	    elsif whatdotcolor (x, y + 15) = brightred and whatdotcolor (x + playerLength, y + 15) = brightred then
		location (1) += 1
		out := true
		y := 10
	    elsif whatdotcolour (x, y + 15) = 47 and whatdotcolour (x + playerLength, y + 15) = 47 then
		direction := 2
		y += speed
		randint (battle, 1, 75)
		if battle = 1 then
		    drawfill (1, 1, white, black)
		    delay (1000)
		end if
	    else
		y := y
	    end if
	elsif ord (key) = 203 then     %left
	    if whatdotcolor (x - 5, y) = 73 and whatdotcolor (x - 5, y + 10) = 73 or whatdotcolor (x - 5, y) = 67 and whatdotcolor (x - 5, y + 10) = 67 or
		    whatdotcolor (x - 5, y) = 73 and whatdotcolor (x - 5, y + 10) = 67 or whatdotcolor (x - 5, y) = 67 and whatdotcolor (x - 5, y + 10) = 73 then
		x -= speed
	    elsif whatdotcolour (x - 5, y) = 47 and whatdotcolour (x - 5, y + 10) = 47 then
		x -= speed
		randint (battle, 1, 75)
		if battle = 1 then
		    drawfill (1, 1, white, black)
		    delay (1000)
		end if
	    else
		x := x
	    end if
	elsif ord (key) = 205 then     %right
	    if whatdotcolor (x + playerLength + 5, y) = 73 and whatdotcolor (x + playerLength + 5, y + 10) = 73 or whatdotcolor (x + playerLength + 5, y) = 67 and whatdotcolor (x +
		    playerLength + 5, y + 10) = 67 or whatdotcolor (x + playerLength + 5, y) = 73 and whatdotcolor (x + playerLength + 5, y + 10) = 67 or whatdotcolor (x + playerLength + 5, y) = 67
		    and whatdotcolor (x + playerLength + 5, y + 10) = 73 then
		x += speed
	    elsif whatdotcolour (x + playerLength + 5, y) = 47 and whatdotcolour (x + playerLength + 5, y + 10) = 47 then
		x += speed
		randint (battle, 1, 75)
		if battle = 1 then
		    drawfill (1, 1, white, black)
		    delay (1000)
		end if
	    else
		x := x
	    end if
	elsif ord (key) = 208 then     %down
	    if whatdotcolor (x, y - 5) = 73 and whatdotcolor (x + playerLength, y - 5) = 73 or whatdotcolor (x, y - 5) = 67 and whatdotcolor (x + playerLength, y - 5) = 67
		    or whatdotcolor (x, y - 5) = 73 and whatdotcolor (x + playerLength, y - 5) = 67 or whatdotcolor (x, y - 5) = 67 and whatdotcolor (x + playerLength, y - 5) = 73 then
		direction := 1
		y -= speed
	    elsif whatdotcolor (x, y - 5) = brightred and whatdotcolor (x + playerLength, y - 5) = brightred then
		location (1) -= 1
		out := true
		y := 550
	    elsif whatdotcolour (x, y - 5) = 47 and whatdotcolour (x + playerLength, y - 5) = 47 then
		direction := 1
		y -= speed
		randint (battle, 1, 75)
		if battle = 1 then
		    drawfill (1, 1, white, black)
		    delay (1000)
		end if
	    else
		y := y
	    end if
	end if
    else
	stationary += 1
    end if
end move

playerImages (1, 1) := Pic.FileNew ("images/player2.bmp")
playerImages (2, 1) := Pic.FileNew ("images/player3.bmp")
playerImages (3, 1) := Pic.FileNew ("images/player1.bmp")
playerImages (1, 2) := Pic.FileNew ("images/player5.bmp")
playerImages (2, 2) := Pic.FileNew ("images/player6.bmp")
playerImages (3, 2) := Pic.FileNew ("images/player4.bmp")
for i : 1 .. 2
    location (i) := 0
end for
player := Sprite.New (playerImages (2, 1))
direction := 1
Sprite.SetPosition (player, x, y, false)
Sprite.Show (player)

loop
    if location (1) = 0 then
	Pic.Draw (border, 1, 1, picCopy)
    elsif location (1) = 1 then
	Pic.Draw (border2, 1, 1, picCopy)
    end if
    loop
	move
	if battle = 1 then
	    if location (1) = 0 then
		Pic.Draw (border, 1, 1, picCopy)
	    elsif location (1) = 1 then
		Pic.Draw (border2, 1, 1, picCopy)
	    end if
	end if
	if stationary > 1 then
	    playerCount := 3
	else
	    playerCount := (count div 8) mod 2 + 1
	end if
	Sprite.Animate (player, playerImages (playerCount, direction), x, y, false)
	delay (25)
	if out = true then
	    out := false
	    exit
	end if
    end loop
end loop
Sprite.Free (player)
