%prep for battles
%battles
%menu
%Finish making all areas
%comment moar

%The program generates the correct screen size and type
setscreen ("graphics:800;600,nobuttonbar, nocursor, noecho")

%record for any person in game
type person : 
record
    name : string %person name
    pic : array 1..4, 1..4 of int
    dir : int %(up = 1, down = 2, left = 3, right = 4)
    sprite : int%sprite for person 
    level : int%person's level
    health : int%person's base health
    energy : int%person't base energy (acts like "mana"
    attack: int%person's base attack
    defense : int%person's base defense
    speed : int%what order the monsters will attack in
    dodge : real%chance of taking no damage
    crit : real%person's damage boost whatever the appropriate antonym for boost is
    attacks : array 1..10, 1..3 of string %list of attacks (includes name, damage boost,and special)
    EXP : array 1..2 of int%experience (1-amount, 2-amount to next level)
end record

type area :%record for any "background"
record
    x : int %x and y variables position the background image so that only the background moves not the player's picture
    y : int
    pic : int %picture of background
    sprite : int %this is the part that actually moves
    border : array 1..4 of int %used for drawing borders so the player can't actually move outside the background picture
    borderColour : int %colour for the border above
end record

type building: %variable for anything you are unable to move through
record 
    x : int %the x and y are where its located relevent to the position of the background image
    y : int
    Colour : int %some "buidings" are used to take you to the next area (change the background pic and the "buildings"). This is done by determining the if the colour of the "building" is equal to this variable
    pic : int %the "building's picture
    direction : string %much like colour, this is used to make sure the user walking in the appropriate direction to use the "door" for lack of a better term
    destination : string %where the "door" will take you
    destinationX : int %starting x and y coordinates for the new area
    destinationY : int
end record

type monster : %stats for the monster are stored using this record
record
    alive : boolean %if they are dead of alive
    name : string %type of enemy
    pic :  array 1..3 of int %default picture, attacking picture, and dead picture
    sprite : int %sprite for the monster
    health : int %this and next two are pretty self explanitory
    attack: int 
    defense : int
    speed : int %determines what order attacks will happen
    dodge : real %chance of not avoiding attack
    crit : real %extra/ less damage
    expGive : int %how much experience the player will gain one the monster is defeated
end record

type stats :
record
    file : string
    health : int
    energy : int
    attack : int
    defense : int
    speed : int
    dodge : int
    crit : int
end record

var font : int := Font.New ("serif:16") %I don't always make new fonts, but when I do, I make them because I need a bigger size
var damageNum : int := Font.New ("mono:12:bold") %again, I need a smaller size
var background : int := Pic.FileNew ("images/world.bmp") %Main menu background
var menu : int := Pic.FileNew ("images/menu.bmp") %Main menu options picture
var menuWords : int := Pic.FileNew ("images/menu options.bmp") %Options for menu
var arrowPic : int := Pic.FileNew ("images/arrow.bmp") %picture of the arrow
var optionsMenu : int := Pic.FileNew ("images/options menu.bmp") %background for options menu
var logo : int := Pic.FileNew ("images/logo.bmp") %EDEN logo
var logoFlash : int := Pic.FileNew ("images/logo flash.bmp") %white, bigger, logo
var startPic : int := Pic.FileNew ("images/press start.bmp") %picture that says "press enter"
var contOrNew : int := Pic.FileNew ("images/ng-c.bmp") %picture that says "New Game" and "Continue"
var intro : array 0..3 of int %array of pictures that show at the begining of the game
var xArrow, yArrow, arrow, temp, stream,pressStart,count,endCount, earnExp : int := 0 %xArrow, yArrow, arrow are position for and the arrow, arrow is a sprite variable, temp is for the funtion "menuFunction", stream is for openning files, press start is another sprite variable, count and end count are used for walking animations
var optionNum : string := "" %Used for confirmed options/ choises
var done, stop : boolean := false %used for ending the game
var key : string (1) %used explicitely for getch
var text : array 0 .. 40 of int %array for text pictures
var controls : array 0..6,1..2 of int %controls
var controlPics : array 0..6 of int%pictures for the different keys (controls)
var buildingNum : int %number of buildings
var buildings : flexible array 1..0 of building %different solid things in the area
var place : area %place where the player is
var player : person%player sprite and stuff
var continue, back, battleEnd, giveEXP : boolean := false %whether to start the game section from the begining or not
var chance, encounter : real %chance of encounter and variable for determining if there is an encounter or not
var monsterData : array 1..2 of int %stores the range of monsters that are fight-able in an area
var battleSprites : array 1..5 of int %battle sprites for battleing (default, attack, ability and dead picture
var monsters : array 1..3 of monster %array of enemies for in a battle
var equiped : array 1..6 of stats
var cutscenes : array 

%when a key is pressed, the game gives it a value
function keyPress (key : string (1)) : string
    if ord (key) = controls (0,1) then
        result "up"
    elsif ord (key) = controls (1,1) then
        result "down"
    elsif ord (key) = controls (2,1) then
        result "left"
    elsif ord (key) = controls (3,1) then
        result "right"
    elsif ord (key) = controls (4,1) or ord (key) = 10 then
        result "confirm"
    elsif ord (key) = controls (5,1) then
        result "back"
    elsif ord (key) = controls (6,1) then
        result "menu"
    else
        result ""
    end if
end keyPress

%if a key is pressed, skips something (made this a procedure to save space)
proc pressKey
    if hasch = true then
        getch (key)
        stop := true
    end if
end pressKey

%after a delay, inputs are "stored." This gets rid of the ones stored so that players don't do things they didn't mean to
proc noInput
    loop
        if hasch = true then
            getch (key)
        else
            exit
        end if
    end loop
end noInput

proc print (text : string, x,y: int)
    for i : 1..length (text)
        Font.Draw (text(1..i), x,y,font, black)
        delay (10)
    end for
end print

%standard flashing arrow for "next" when reading text
proc confirm
    var temp : int := Pic.FileNew ("images/next.bmp") %arrow image
    var next : int := Sprite.New (temp) %sprite of above
    Sprite.SetPosition (next,maxx - 25,25,true)
    %loops a flashing arrow until the correct key is pressed
    loop
        if hasch then
            getch (key)
            if keyPress (key) = "confirm" or keyPress (key) = "back" then
                exit
            end if
        end if
        Sprite.Show (next)
        delay (500)
        View.Update
        if hasch then
            getch (key)
            if keyPress (key) = "confirm" or keyPress (key) = "back" then
                exit
            end if
        end if
        Sprite.Hide (next)
        delay (500)
        View.Update        
    end loop
    noInput
    Sprite.Free (next)
end confirm

%change the keys
procedure changeKey (num : int)
    xArrow += 350
    Sprite.SetPosition (arrow, xArrow, yArrow, false)
    Sprite.Show (arrow)
    %changes the key if it's valid key
    loop
        getch (key)
        if ord (key) > 96 and ord (key) < 123 then
            controls (num,1) := ord (key)
            controls (num,2) := ord (key) - 97
            exit
        elsif ord (key) = 200 then
            controls (num,1) := 200
            controls (num,2) := 36
            exit
        elsif ord (key) = 208 then
            controls (num,1) := 208
            controls (num,2) := 37
            exit
        elsif ord (key) = 203 then
            controls (num,1) := 203
            controls (num,2) := 38
            exit
        elsif ord (key) = 205 then
            controls (num,1) := 205
            controls (num,2) := 39
            exit
        elsif ord (key) = 27 then
            controls (num,1) := 27
            controls (num,2) := 40
            exit
        end if
    end loop
    xArrow -= 350
    %changes the key that is displayed
    for i : 0..6
        Sprite.Hide (controlPics (i))
    end for
        Sprite.SetPosition (arrow, xArrow, yArrow, false)
    Sprite.Show (arrow)
    open : stream, "settings.txt", put
    %saves the new settings
    for i : 1..2
        for j : 0..6
            put : stream, controls (j,i)
        end for
            
        put : stream, ""
    end for
        close : stream
end changeKey

%used for selecting the different options from a menu
proc menuFunction (option : int)
    if hasch = true then
        getch (key)
        if keyPress (key) = "up" then
            %if the option is the top one, it goes to the bottom
            if temp mod option = 0 then
                temp := option - 1
            else
                temp -= 1
            end if
        elsif keyPress (key) = "down" then
            temp += 1
            %optionNum only has a value when the confirm button is given the same value as temp
        elsif keyPress (key) = "confirm" then
            optionNum := intstr (temp mod option)
        end if
        temp := temp mod option
    end if
end menuFunction

%changes the location the player is in (num is used to pass on the location of the array the info is stored in)
proc relocate (num: int)
    var temp : string %used to store file locations 
    var monster : int
    %opens .dat file for location
    open : stream, buildings(num).destination, get
    %gets picture location & makes it a picture
    get : stream, temp 
    place.pic := Pic.FileNew (temp)
    %gets the number of objects, the colour of the border, and the chance of fighting a monster
    get : stream, buildingNum 
    get : stream, place.borderColour
    get : stream, chance
    %gets border locations
    for i : 1..4
        get : stream, place.border (i)
    end for
        %gets monster data for the area
    for i : 1..2
        get : stream, monster
        monsterData (i) := monster
    end for
        %resets all objects and the creates the new ones
    new buildings, 0
    new buildings, buildingNum
    %gets the info for the "solid" objects
    for i : 1.. buildingNum
        get : stream, buildings(i).x
        get : stream, buildings(i).y
        get : stream, buildings(i).Colour
        get : stream, buildings(i).direction
        get : stream, temp
        get : stream, buildings(i).destination
        get : stream, buildings(i).destinationX
        get : stream, buildings(i).destinationY
        %creates the picture for the building
        buildings(i).pic := Pic.FileNew (temp)
    end for
        %changes the picture for the background, resets the position of the background, and displays the picture for the background
    Sprite.ChangePic (place.sprite, place.pic)
    Sprite.SetPosition (place.sprite, place.x, place.y,true)
    Sprite.Show (place.sprite)
    close : stream
end relocate

%compares the colour and direction provided by keyAction to that of anu "building" to see if the location will change (col = one corner, col2 = 2nd corner,dir = direction moving)
proc colourCheck (col,col2 : int, dir: string)
    var change : boolean := false %if the location will be changed
    var num : int %stores the location of the appropriate "building"
    %checks the colours and directions provided with that of the buildings
    for i : 1.. buildingNum
        if (col = buildings(i).Colour or col2 = buildings(i).Colour) and dir = buildings(i).direction then
            if (col = buildings(i).Colour and col2 = buildings(i).Colour) and dir = buildings(i).direction then
                change := true
                num := i 
            end if
        end if
    end for
        %if the object you colided with wasn't a "door"
    if change = false then
        %sometimes the image of a "building" is left over, and when you next try to move in that direction. This erases parts of that image and allows you to move again.
        if dir = "up" then
            drawdot (maxx div 2 - 23, maxy div 2 + 45, 18)
            drawdot (maxx div 2 + 23, maxy div 2 + 45, 18)
        elsif dir = "down" then
            drawdot (maxx div 2 - 23, maxy div 2 - 20, 18)
            drawdot (maxx div 2 + 23, maxy div 2 - 20, 18)
        elsif dir = "left" then
            drawdot (maxx div 2-25, maxy div 2 - 15, 18)
            drawdot (maxx div 2-25, maxy div 2 + 30, 18)
        elsif dir = "right" then
            drawdot (maxx div 2+25, maxy div 2 - 15, 18)
            drawdot (maxx div 2+25, maxy div 2 + 30, 18)
        end if
    else 
        %preps for relocation by resets things to default values
        cls
        drawfill (1,1,18,18)
        place.x := maxx div 2
        place.y := maxy div 2
        place.x += buildings(num).destinationX
        place.y += buildings(num).destinationY
        relocate (num)
    end if
end colourCheck

%when you press and (direction) key
proc keyAction
    %moving up
    if keyPress (key) = "up" then
        %changes the direction of the sprite
        player.dir := 2
        %resets count
        count += 1
        %checks if two positions in the middle of the sprite are the default colours (valid position)
        if whatdotcolour (maxx div 2 - 23, maxy div 2 + 45) = 18 and whatdotcolour (maxx div 2+23, maxy div 2 + 45) = 18 then
            place.y -=10
        else colourCheck(whatdotcolour (maxx div 2 - 23, maxy div 2 + 45), whatdotcolour (maxx div 2+23, maxy div 2 + 45), "up")                
        end if
        %for the next three, pretty much the same as above
        %move down
    elsif keyPress (key) = "down" then
        player.dir := 1
        if whatdotcolour (maxx div 2 - 23, maxy div 2 -20) = 18 and whatdotcolour (maxx div 2 + 23, maxy div 2 -20) = 18 then
            place.y += 10
        else colourCheck (whatdotcolour (maxx div 2 - 23, maxy div 2 -20), whatdotcolour (maxx div 2 + 23, maxy div 2 -20), "down")
        end if
        %move left
    elsif keyPress (key) = "left" then
        player.dir := 3
        if whatdotcolour (maxx div 2-25, maxy div 2 - 15) = 18 and whatdotcolour (maxx div 2-25, maxy div 2 + 30) = 18 then
            place.x += 10
        else colourCheck(whatdotcolour (maxx div 2-25, maxy div 2 - 15), whatdotcolour (maxx div 2-25, maxy div 2 + 30), "left")
        end if
        %move right
    elsif keyPress (key) = "right" then
        player.dir := 4
        if whatdotcolour (maxx div 2+25, maxy div 2-15) = 18 and whatdotcolour (maxx div 2+25, maxy div 2+30) = 18 then
            place.x -= 10
        else colourCheck(whatdotcolour (maxx div 2+25, maxy div 2-15),whatdotcolour (maxx div 2+25, maxy div 2+30), "right")
        end if
    end if
end keyAction

%does moving animation
proc moving
    %endCount is the amount of time you have been standing still (<10 = <50 ms)
    if endCount < 10 then
        %changes the sprite's position
        Sprite.Animate (player.sprite, player.pic ((count div 4) mod 4 + 1,player.dir),maxx div 2, maxy div 2, true)
        %updates the sprite's location
        Sprite.Show (place.sprite)
    elsif endCount >= 10 then
        %resets count (used to determine which image to use for walking), and resets the player to the standing still pic
        count := 0
        Sprite.ChangePic (player.sprite, player.pic (1,player.dir))
    end if
end moving

%reads stats from the .dat file
proc getStats
    %get base stats for player
    open : stream, "player.dat", get
    get :stream, player.name
    get :stream, player.level
    get : stream, player.health
    player.health := player.level *5 + 15
    get :stream, player.energy
    get :stream, player.attack
    get :stream, player.defense
    get :stream, player.speed
    get :stream, player.dodge
    get :stream, player.crit
    get: stream, player.EXP (1)
    close : stream
    %total amount of exp
    player.EXP (2) := ((player.level+1) * (30) div 4)
    open : stream, "equip.dat", get
    for i : 1..6
        get : stream, equiped(i).file
    end for
        close : stream
    for i : 1..6
        open : stream, equiped(i).file, get
        get : stream, equiped(i).health
        get : stream, equiped(i).energy
        get : stream, equiped(i).attack
        get : stream, equiped(i).defense
        get : stream, equiped(i).speed
        get : stream, equiped(i).dodge
        get : stream, equiped(i).crit
        close : stream
    end for
end getStats

%updates the battle screen
proc update
    var options :int := Pic.FileNew ("images/battle 2.bmp") %menu
    var back : int := Pic.FileNew ("images/battle.bmp") %background picture
    var totalHealth : string := intstr (15 + player.level * 5) %calculates yout total health
    cls
    %redraws backgroud, menu, and current health
    Pic.Draw (back,1,1,picCopy)
    Pic.Draw (options,400,1,picMerge)  
    Font.Draw("Health: "+intstr (player.health,0) + "/"+totalHealth,25,100,font,black)
    View.Update
end update

proc endBattle
    var back : int := Pic.FileNew ("images/battle.bmp") %background picture
    Pic.Draw (back,1,1,picMerge)
    Sprite.Hide (arrow)
    if giveEXP = true then
        giveEXP := false
        player.EXP(1) += earnExp
        Font.Draw (intstr (earnExp,0)+" EXP earned!", 25,140, font, black)
        View.Update
        confirm
    end if
    earnExp := 0
    for i : 1..3
        if monsters (i).alive = true then
        monsters (i).alive := false
            Sprite.Free (monsters (i).sprite)
        end if
    end for
        Sprite.Free (battleSprites (5))
    cls
    Sprite.Show (player.sprite)
    View.Update
end endBattle

proc check (target : int)
    var fade : int := Pic.FileNew ("images/kill.bmp")
    var count : int := 0 %number of dead enemies
    if monsters (target).health < 1 then
        Sprite.Hide (monsters (target).sprite)
        update
        Pic.Draw (monsters (target).pic (3),200,400 - (target * 50),picMerge)
        delay (500)
        Pic.DrawSpecial (fade, 1, 200,picMerge,picFadeIn,300)
        update
        monsters (target).alive := false
        Sprite.Free (monsters (target).sprite)
        earnExp += monsters(target).expGive
    end if
    %counts the number of dead enemies and if they are all dead, sets the variable to end battles to true
    for i : 1..3
        if monsters (i).alive = false then
            count += 1
        end if
    end for
        if count = 3 then
        battleEnd := true
    end if
end check

proc showDamage (text : string, x,y : int)
    for i : 1..length (text)
        Font.Draw (text (1..i), x-5, y, damageNum,brightred)
        delay (100)
    end for
        delay (500)
end showDamage

%calculates dodge or crit
proc extraDamage (target : string, num : int, var damage : int, defense : int)
    var text : string
    var temp : real %for random number calculation
    %if the calculations is for the player (if the player is attacking)
    if target = "person" then
        %if random num is smaller than player the players crit num then double damage. if next random num is less than enemy dodge number, than no damage done to enemy
        rand (temp) 
        if temp < player.crit then
            damage := damage *2
        end if
        rand (temp)
        if temp < monsters (num).dodge then
            damage := monsters(num).defense                 
        end if
        if damage = monsters (num).defense then
            text := "Miss"
        else
            text := intstr (damage - monsters (num).defense,1)
        end if
        showDamage (text, 180, 425 - (num * 50))
    else rand (temp)
        %escentially the same as above, with the calcuations being a bit different as the attack and defense variables only aply to the player, not enemies
        if temp < monsters (num).crit then
            player.health -= (monsters(num).attack * 2) - defense
            text := intstr (monsters (num).attack *2 - defense, 1)
        end if
        rand (temp)
        if temp >= player.dodge then
            player.health -= monsters(num).attack - defense
            text := intstr (monsters (num).attack - defense,1)
        else
            text := "Miss"
        end if
        showDamage (text, 610, maxy div 2 +75)
    end if
end extraDamage

%attack animation (enemy or player, which enemy)
proc animate (sprite : string, count : int)
    %if its an enemy
    if sprite = "enemy" then
        %change the sprite to the attack animation, update that, delay, normal sprite
        Sprite.Animate (monsters (count).sprite,monsters(count).pic(2),215, 400 - (count*50),false)
        update
        delay (500)
        Sprite.Animate (monsters (count).sprite,monsters(count).pic(1),200, 400 - (count*50),false)
    else
        %change the sprite to the attack animation, update that, delay, normal sprite
        Sprite.Animate (battleSprites (5),battleSprites (2),585, 300,false)
        update
        delay (500)
        Sprite.Animate (battleSprites (5),battleSprites(1),600, 300,false)
    end if
end animate

%calculates base damage before crits/ dodges (order, alive entities, total number of enemies
proc attacking (order : array 1..7, 1..2 of int, num, target: int)
    var defense : int := player.defense %player's defense value (armour + base)
    var damage : int := player.attack %palyers attack value (armour/weapon + base)
    var count, temp : int := 0 %amount of monsters that have attacked and variable because I needed one as a place holder
    %calculates defense and attack
    for i : 1..6
        defense += equiped(i).defense
    end for
        for i : 1..6
        damage += equiped(i).attack
    end for
        delay (500)
    for i : 1..4
        % if the attacker isn't the player, increase the amount of enemies that have attacked and make sure the attacker is alive
        if order (i,1) not= 0 then 
            count += 1
            if monsters (count).alive = true then
                %attack animation (enemy, array value), calculate amount of  damage done (minimum = 1) and update the screen
                animate ("enemy", count)
                if defense < monsters(count).attack then
                    %(enemy, array value, place holder, player defense value)
                    extraDamage ("enemy", count, temp,defense)
                else player.health -=1
                    showDamage ("1", 610, maxy div 2 +75)
                    update
                end if
            end if
        else
            %attack animation, calculate damage done (minimum = 1),and updates screen as well as any deaths
            animate ("player",0)
            if monsters(temp + 1).defense >= damage then
                monsters (target).health -= 1
                showDamage ("1", 180, 425 - (num * 50))
            else
                extraDamage ("person", target,damage,defense)
                monsters (target).health := monsters(target).health - (damage- monsters(target).defense)
            end if
            %sees if monster was killed, as wel as updates the sreen
            check (target)
        end if
        update
        delay (500)
    end for
        noInput
end attacking

%calculates in what order who will attack (number of alive enemies, target for player, total number of enemies)
proc order (numMon, target:int)
    var turn : array 1..7,1..2 of int %array holding number code for entities and their speed
    var temp, temp2, num : int %variables for moving data and one for the number of entities
    %number of enemies + 1 (player)
    num := numMon +1
    %assignes a value to each active part of the array ("0" for player and the rest for enemies) and then assignes the correct speed for each entity 
    for i : 1.. num
        turn (i,1) := i - 1
    end for
        turn (1,2) := player.speed
    for i : 2.. num
        turn (i,2) := monsters(i-1).speed
    end for
        %sorting algorithm-- sorts fastest to slowest
    for i : 1..num
        for j : 1..numMon
            if turn (j,2) < turn (j+1,2) then
                temp := turn (j,1)
                temp2 := turn (j,2)
                turn (j,1) := turn (j+1,1)
                turn (j,2) := turn (j+1,2)
                turn (j+1,1) := temp
                turn (j+1,2) := temp2
            end if
        end for
    end for
        for i : num + 1..7
        turn (i,1) := i
        turn (i,2) := 0
    end for
        %hides the arrow used to select which enemy to attack
    Sprite.Hide (arrow)
    %passes values for the turn for each player, the number of alive enemies, the targeted enemy's array value, and the total number of enemies in the fight
    attacking (turn, num, target)
end order

%if user selects attack
proc attack
    var count: int := 0 %counter for number of enemies still alive
    %resets value of variable and then counts the number of monsters alive
    optionNum := ""
    for i : 1..3
        if monsters (i).alive = true then
            count += 1
        end if
    end for
        %this part allows you to select with enemy you would like to attack. It only allows you to attack monsters that are still alive, and makes that user friendly by only allowing you to pick monsters which are alive
    loop
        menuFunction (3)
        if temp = 0 and monsters (1).alive = true then
            xArrow := 175
            yArrow := 380
        elsif temp = 0 and monsters (1).alive = false then
            temp := 1
        elsif temp = 1 and monsters(2).alive = true then
            xArrow := 175
            yArrow := 330
        elsif temp = 1 and monsters (2).alive = false then
            temp := 2
        elsif temp = 2 and monsters (3).alive = true then
            xArrow := 175
            yArrow := 278
        elsif temp = 2 and monsters (3).alive = false then
            temp := 0
        end if
        %if you didn't want to pick attck or want to go back, this goes back to the previous menu
        if keyPress (key) = "back" then
            exit
        end if
        %if SOMETHING was picked, it resets the options value, and then passes a value for the alive monsters, the monster chosen, and the total number of monsters
        if optionNum not= "" then
            optionNum := ""
            order (count,temp + 1)
            exit
        end if
        Sprite.SetPosition (arrow, xArrow, yArrow, true)
    end loop
    temp := 0
end attack

%battle main menu (numMonsters used to pass on value)
proc battle 
    var stop : boolean := false %if the battle is over
    %updates screen and then allows user to select "attack," "abilities," "bag," or "escape,"
    update 
    giveEXP := true 
    loop
        Sprite.Show (arrow)
        menuFunction (4)
        case temp of
        label 0 : 
            xArrow := 595
            yArrow := 148
        label 1 : 
            xArrow := 595
            yArrow := 110
        label 2 : 
            xArrow := 595
            yArrow := 74
        label 3 :
            xArrow := 595
            yArrow := 38
        end case
        Sprite.SetPosition (arrow, xArrow, yArrow, true)
        delay (10)
        if optionNum = "0" then
            attack
        elsif optionNum = "1" then
            
        elsif optionNum = "2" then
            
        elsif optionNum = "3" then
            optionNum := ""
            battleEnd := true
            giveEXP := false
        end if
        exit when battleEnd = true
    end loop
    battleEnd := false
    endBattle
    temp := 0
end battle

%draws the starting pictures for the start of the battle
proc battlePicStart (numMonsters:int)
    var back : int := Pic.FileNew ("images/battle.bmp") %background picture
    var Black : int := Pic.FileNew ("images/black.bmp") %a 800*600 black picture
    var temp, startText : string:= "" %used to store file locations, and the battle start text
    %opens file and gets the location of pictures used for fighting, with then turns them into pictures
    open : stream, "attack pictures.dat", get
    for i : 1..4
        get : stream, temp
        battleSprites (i) := Pic.FileNew (temp)
    end for
        %turns one of the pictures into sprites & sets its values
    battleSprites (5) := Sprite.New (battleSprites (1))
    Sprite.SetPosition (battleSprites (5),600, 300, false)
    Sprite.SetHeight (battleSprites (5), 15)
    close : stream
    %transition to battle sequence
    Pic.DrawSpecial (Black, 1,1, picCopy, picGrowCentreToEdge,100)
    delay (250)
    cls
    Pic.DrawSpecial (back,1,1,picCopy,picFadeIn, 100)
    %sets positions for monsters and then shows them
    %also shows the player
    for i : 1..numMonsters
        Sprite.SetPosition (monsters (i).sprite,200,400 - (i*50), false)
        Sprite.SetHeight (monsters (i).sprite,15)
        Sprite.Show (monsters (i).sprite)
    end for
        Sprite.Show (battleSprites (5))
    View.Update
    %creates battle start text
    delay (150)
    for i : 1.. numMonsters
        delay (100)
        startText += "A "+monsters (i).name + " apeared!"
        print (startText, 25, 165-(i*35))
        startText := ""
    end for
        %standard battle intro
    noInput
    confirm
    battle
end battlePicStart

%creates enemies
proc battleStart
    var numMonsters, monType : int %number of enemies and what enemies will be in the battle
    var mon,temp: string %both used to store file locaions
    var range, range2 : int %number range of possible monsters
    %resets the screen
    Sprite.Hide (place.sprite)
    Sprite.Hide (player.sprite) 
    cls
    %sets the high and low values of monsters that are fightable for said area
    range := monsterData (1)
    range2 := monsterData (2)
    %determines number of enemies in said battle : 1/3 chance 1 enemy, 1/2 chance for 2, and 1/6 chance for 3)
    randint (numMonsters,4,9)
    %generates number of enemy above-- random enemy from the range, and then gets said enemy's stats
    for i : 1.. numMonsters div 3
        randint (monType, range,range2)
        %creates correct file location
        mon := "monsters/"+intstr (monType,0)+".dat"
        open : stream, mon, get
        %IT LIVES!!!!!!!!!!!!
        monsters (i).alive := true
        %gets stats and stuff
        get : stream, monsters(i).name
        for j : 1..3
            get : stream, temp 
            monsters (i).pic(j) := Pic.FileNew (temp)
        end for
            %turns picture into sprite
        monsters (i).sprite := Sprite.New (monsters (i).pic (1))
        get : stream, monsters (i).health
        get : stream, monsters (i).attack
        put monsters (i).attack
        get : stream, monsters (i).defense
        get : stream, monsters (i).speed
        get : stream, monsters (i).crit
        get : stream, monsters (i).dodge
        get : stream, monsters (i).expGive
    end for
        close : stream
    noInput
    battlePicStart (numMonsters div 3)
end battleStart

%procedure for moving character
proc move
    %when a key is pressed
    if hasch = true then
        getch (key)
        %brings up in game menu (work on later)
        if keyPress (key) = "menu" then
            done := true
            %moving keys
        elsif keyPress (key) = "up" or keyPress (key) = "down" or keyPress (key) = "left" or keyPress (key) = "right" then
            count +=1 %increases
            endCount := 0 %resets value
            keyAction
            rand (encounter) %random number to check to see if encounted a monster
            if encounter < chance then %ITS TIME FOR A DEATH BATTLE!!!
                battleStart
            end if
        end if
    end if
    endCount += 1 %increases (value won't reset unless movement key is pressed)
    moving%any movement animation that needs to be done
end move

%Imports pictures that are needed from the start
proc picInitialize
    var temp : string
    %text
    open : stream, "text.txt", get
    for i : 0 .. 40
        get : stream, temp
        text (i) := Pic.FileNew (temp)
    end for        
        %intro to game
    close : stream
    open : stream, "introPics.txt", get
    for i : 0..3
        get : stream, temp
        intro (i) := Pic.FileNew (temp)
    end for
        close : stream
    %player sprites
    open : stream, "sprite location.txt", get
    for i : 1..4
        for j : 1..4
            get : stream, temp
            player.pic (j,i) := Pic.FileNew (temp)
        end for
    end for
end picInitialize

%gets controls from the text file
proc settingsConfig
    var temp : array 0..6 of int %used to get and then discard pictures once they have been turned into sprites (to save memory)
    %gets controls and their pictures
    open : stream, "settings.txt", get
    for j : 1..2
        for i : 0..6
            get : stream, controls (i,j)
        end for
    end for
        
    close : stream
    %sets the position for the setting sprites
    for i : 0..6
        controlPics (i) := Sprite.New (text (controls (i,2)))
    end for
        
    %sets position for pic in the options file
    Sprite.SetPosition  (controlPics (0),542,465,true)
    Sprite.SetPosition  (controlPics (1),542,420,true)
    Sprite.SetPosition  (controlPics (2),542,375,true)
    Sprite.SetPosition  (controlPics (3),542,330,true)
    Sprite.SetPosition  (controlPics (4),542,285,true)
    Sprite.SetPosition  (controlPics (5),542,235,true)
    Sprite.SetPosition  (controlPics (6),542,192,true)
end settingsConfig

%part 2 of gameInitialize
proc gameInitialize2
    player.sprite := Sprite.New (player.pic (1,1))
    Sprite.SetPosition (player.sprite, maxx div 2, maxy div 2, true)
    Sprite.SetHeight (player.sprite,10)
    Sprite.Show (player.sprite)
    place.sprite := Sprite.New (place.pic)
    Sprite.SetPosition (place.sprite, place.x, place.y,true)
    Sprite.SetHeight (place.sprite,5)
    Sprite.Show (place.sprite)
    endCount := 10
    player.dir := 1
end gameInitialize2

%initializes many game values (loc = file location)
proc gameInitialize(loc : string)
    var temp: string %used to store file locations
    var monster : int %temp stores upper and lower ranges for enemies in a said area
    open : stream, loc, get
    %creates background pic
    get : stream, temp
    place.pic := Pic.FileNew (temp)
    %gets numper of buildings, colour of border, and chance of running into an enemy
    get : stream, buildingNum
    get : stream, place.borderColour
    %gets locations for borders
    get : stream, chance
    for i : 1..4
        get : stream, place.border (i)
    end for
        %gets enemy ranges and stores them
    for i : 1..2
        get : stream, monster
        monsterData (i) := monster
    end for
        %creates buildings and obtains the values
    new buildings, buildingNum
    for i : 1.. buildingNum
        get : stream, buildings(i).x
        get : stream, buildings(i).y
        get : stream, buildings(i).Colour
        get : stream, buildings(i).direction
        get : stream, temp
        get : stream, buildings(i).destination
        get : stream, buildings(i).destinationX
        get : stream, buildings(i).destinationY
        %gets the building [ic
        buildings(i).pic := Pic.FileNew (temp)
    end for
        close : stream
    gameInitialize2 %part 2 [is usually the best]
    %default value for monsters state
    for i : 1..3
        monsters (i).alive := false
    end for
end gameInitialize

%initializes the game part of the game
proc gameLoad
    var temp, disregard : string %temp- file locations, disregard- do that
    var x,y:int
    %sets default values 
    colourback (18)
    place.x := maxx div 2 
    place.y := maxy div 2
    drawfill (1,1,18,18)
    %get ALL the save files
    open : stream, "game.sav", get
    get : stream, disregard
    %x-coordinate from center of last save
    get : stream, x
    %same as above, but with the y-coordinate
    get : stream, y 
    get : stream, temp %file location of area last area
    close : stream
    %adds value of x to the center to get the correct position
    place.x += x
    place.y += y
    %gets game stats and then moves on to part 2
    getStats
    gameInitialize (temp)
end gameLoad

%reads save file and determines of continue is an option or not
proc gameStart
    var state:string %to read the file
    open:stream, "game.sav", get
    get : stream, state
    %if there has been a save
    if state = "newGame" then
        continue := false
    else
        continue := true
    end if
end gameStart

%to erase a save file
proc startNewGame
    var temp : array 1..10 of string%temp stores default info
    %obtains the default save info and uses it to reset the save file
    open:stream, "newGame.sav", get
    for i : 1..4
        get: stream, temp (i)
    end for
        close : stream
    open : stream, "game.sav", put
    for i : 1..4
        put : stream, temp (i)
    end for
        close : stream
    %obtains the default player stats to reset player stats
    open:stream, "newPlayer.dat", get
    for i : 1..10
        get: stream, temp (i)
    end for
        close : stream
    open : stream, "player.dat", put
    for i : 1..10
        put : stream, temp (i)
    end for
        close : stream
end startNewGame


picInitialize
settingsConfig
gameStart

arrow := Sprite.New (arrowPic)

%if the person isn't continuing
if continue = false then
    startNewGame
end if
%load save info
gameLoad

loop
    %check and moves player if nessecary
    move
    %moves the background (emulates person moving)
    Sprite.SetPosition (place.sprite, place.x, place.y,true)
    %draws the buildings reletive to the section of drawn background (moves WITH the background)
    for i : 1..buildingNum
        Pic.Draw (buildings(i).pic, buildings(i).x + place.x, buildings(i).y + place.y,picCopy)
    end for
        %draws the background in the same way the buildings are drawn
    drawfillbox (place.border(4)-300+place.x ,place.border(1)+place.y,place.border(3)+300+place.x,place.border (1)+ 300+place.y,place.borderColour)
    drawfillbox (place.border (3)+place.x ,place.border (1)+ place.y,place.border (3)+300+place.x,place.border (2)+place.y,place.borderColour)
    drawfillbox (place.border (4)+place.x, place.border (2)+place.y, place.border (3) + place.x, place.border (2) - 300 + place.y, place.borderColour)
    drawfillbox (place.border (4) + place.x, place.border (1) + place.y, place.border (4) + place.x - 300, place.border (2) + place.y, place.borderColour)
    delay (5)
    exit when done = true
end loop
%gets rid of any objects
cls
Sprite.Free (player.sprite)
Sprite.Free (place.sprite)