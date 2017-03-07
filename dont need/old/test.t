var menu : int := Pic.FileNew ("images/battle.bmp")
var playerImage : int := Pic.FileNew ("images/player1.bmp")
var enemyImage : int := Pic.FileNew ("images/inverse player.bmp")
var battleMenu : int := Pic.FileNew ("images/battle menu.bmp")
var player : int
var enemy : int
var menuMax, MenuCount : int := 0
var option : string := ""
var arrowImage : int := Pic.FileNew ("images/arrow.bmp")
var arrow : int
var attackMenu : int := Pic.FileNew ("images/battle options.bmp")
var punch : int := Pic.FileNew ("images/attack punch.bmp")
var playerHealth : int := 100
var enemy1Health : int := 100
var attack : int := 10
var crit : int
var level : int := 1
var damage : int
var numbers : array 0 .. 9 of int
var temp : int
var pics : array 0 .. 9 of int

procedure menuSelect
    var key : string (1)
    getch (key)
    if ord (key) = 200 then
	if MenuCount = 0 then
	    MenuCount := (menuMax - 1)
	else
	    MenuCount -= 1
	end if
    elsif ord (key) = 208 then
	MenuCount += 1
    elsif ord (key) = 122 or ord (key) = 10 then
	option := intstr (MenuCount mod menuMax)
    end if
end menuSelect

procedure initialize
    var stream : int
    var temp : string
    open : stream, "numbers.txt", get
    for i : 0 .. 9
	get : stream, temp
	pics (i) := Pic.FileNew (temp)
	numbers (i) := Sprite.New (pics (i))
	Sprite.SetPosition (numbers (i), -20, -20, false)
    end for
    close : stream
    Pic.Draw (menu, 1, 1, picCopy)
    Pic.Draw (battleMenu, 590, 3, picMerge)

    player := Sprite.New (playerImage)
    Sprite.SetPosition (player, 620, 250, false)
    Sprite.Show (player)

    enemy := Sprite.New (enemyImage)
    Sprite.SetPosition (enemy, 115, 250, false)
    Sprite.Show (enemy)

    arrow := Sprite.New (arrowImage)
    Sprite.SetPosition (arrow, 617, 137, false)
    Sprite.Show (arrow)
end initialize

setscreen ("graphics:800;600,nobuttonbar, nocursor, noecho")

initialize

MenuCount := 1

loop
    menuMax := 4
    menuSelect
    if MenuCount mod 4 = 1 then
	Sprite.SetPosition (arrow, 617, 137, false)
    elsif MenuCount mod 4 = 2 then
	Sprite.SetPosition (arrow, 617, 100, false)
    elsif MenuCount mod 4 = 3 then
	Sprite.SetPosition (arrow, 617, 65, false)
    else
	Sprite.SetPosition (arrow, 617, 30, false)
    end if
    if option not= "" then
	if option = "1" then
	    temp := damage div 10
	    Sprite.SetPosition (numbers (temp), 10, 10, false)
	    Sprite.Show (numbers (temp))
	    %temp := damage mod 10
	    %Sprite.SetPosition (numbers (temp), 125, 250, false)
	    %Sprite.Show (numbers (temp))
	    delay (1000)
	    %Sprite.Hide (numbers (temp))
	    %temp := damage div 10
	    %Sprite.Hide (numbers (temp))
	end if
    end if
end loop
Sprite.Hide (player)
Sprite.Hide (enemy)
Sprite.Hide (arrow)
Sprite.Free (player)
Sprite.Free (enemy)
Sprite.Free (arrow)
Sprite.Free (numbers (1))
Sprite.Free (numbers (2))
Sprite.Free (numbers (3))
Sprite.Free (numbers (4))
Sprite.Free (numbers (5))
Sprite.Free (numbers (6))
Sprite.Free (numbers (7))
Sprite.Free (numbers (8))
Sprite.Free (numbers (9))
Sprite.Free (numbers (0))
