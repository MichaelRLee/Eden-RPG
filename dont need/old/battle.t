var menu : int := Pic.FileNew ("images/battle.bmp")
var playerImage : int := Pic.FileNew ("images/player1.bmp")
var enemyImage : int := Pic.FileNew ("images/inverse player.bmp")
var battleMenu : int := Pic.FileNew ("images/battle menu.bmp")
var player : int
var enemy : int
var key : string (1)
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
var numbers : array 0 .. 9, 1 .. 2 of int
var temp : int
var temp2 : int
var pics : array 0 .. 9 of int

procedure menuSelect
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
    open : stream, "text.txt", get
    for i : 0 .. 9
        get : stream, temp
        pics (i) := Pic.FileNew (temp)
        for j : 1 .. 2
            numbers (i, j) := Sprite.New (pics (i))
            Sprite.SetPosition (numbers (i, j), -20, -20, false)
        end for
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

procedure playerAttack
    var extra : int
    randint (extra, ((level div 4) * 3), level)
    randint (crit, 1, 20)
    if crit = 1 then
        damage := (attack + extra) div 2
    elsif crit < 20 then
        damage := attack + extra
    elsif crit = 20 then
        damage := (attack + extra) * 2
    end if
    temp := damage div 10
    temp2 := damage mod 10
    for i : 325 .. 330
        Sprite.SetPosition (numbers (temp, 1), 122, i, false)
        Sprite.Show (numbers (temp, 1))
        delay (20)
    end for
        for i : 325 .. 330
        Sprite.SetPosition (numbers (temp2, 2), 133, i, false)
        Sprite.Show (numbers (temp2, 2))
        Sprite.SetPosition (numbers (temp, 1), 122, 330 - ((i - 324) div 2), false)
        Sprite.Show (numbers (temp, 1))
        delay (20)
    end for
        for i : 325 .. 330
        Sprite.SetPosition (numbers (temp2, 2), 133, 330 - ((i - 324) div 2), false)
        Sprite.Show (numbers (temp2, 2))
        delay (20)
    end for
        delay (100)
    Sprite.Hide (numbers (temp, 1))
    Sprite.Hide (numbers (temp2, 2))
    enemy1Health -= damage
end playerAttack

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
            playerAttack
            option := ""
        elsif option = "2" then
            locate (1, 1)
            colour (brightcyan)
            put "Abilities!"
            colour (black)
            option := ""
        elsif option = "3" then
            locate (1, 1)
            colour (brightcyan)
            put "Bag!"
            colour (black)
            option := ""
        else
            cls
            exit
        end if
    end if
    loop
        if hasch = true then
            getch (key)
        elsif hasch = false then
            exit
        end if
    end loop
    if enemy1Health < 0 then
        Sprite.Hide (enemy)
        exit
    end if
end loop
Sprite.Hide (player)
Sprite.Hide (enemy)
Sprite.Hide (arrow)
Sprite.Free (player)
Sprite.Free (enemy)
Sprite.Free (arrow)
for i : 0 .. 9
    for j : 1 .. 2
        Sprite.Free (numbers (i, j))
    end for
end for
Pic.Draw (menu, 1, 1, picCopy)
Pic.Draw (battleMenu, 590, 3, picMerge)
