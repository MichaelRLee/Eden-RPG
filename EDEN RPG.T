%***********************************************************************%
%                          PROGRAM HEADER                               %
%***********************************************************************%
%                                                                       %
% PROGRAMMER'S NAME:    Michael Lee                                     %
%                                                                       %
% PROGRAM NAME:         EDEN RPG                                        %
%                                                                       %
% CLASS:                ICS 3U1                                         %
%                                                                       %
% ASSIGNMENT:           Performance Task                                %
%                                                                       %
% TEACHER:              Mrs. Barsan                                     %
%                                                                       %
% DUE DATE:             Monday, January 21, 2013                        %
%                                                                       %
%***********************************************************************%
% WHAT THE PROGRAM DOES                                                 %
%                                                                       %
% This program is a turn based RPG that (a game). It has multiple areas %
%and enemies, and a story                                               %
%                                                                       %
%***********************************************************************%
% PROCEDURES                                                            %
%                                                                       %
% pressKey: if the user presses a key, a loop ends                      %
% noInput:  the program waits until any input that were put in during a %
%           delay are gone                                              %
% print:    Displays text in a larger font letter by letter, with only a%
%           small delay                                                 %
% confirm:  displays a flashing arrow and waits for the user to press   %
%           confirm or back                                             %
% changeKey:    Changes the key a control is bound to                   %
% menuFuntion:  used for any menu with multiple options. has two uses , %
%               one for which option the user is currently selected, and%
%               then one to confirm                                     %
% relocate: changes the area that the player is in                      %
% colourCheck:  checks if a certain colour relocates a player           %
% heal:     restores player's health and energy                         %
% keyAction:    execute whatever the key pressed in move does in the    %
%               game part                                               %
% moving:   animates the person walking                                 %
% getStats: gets the players stats and that of what they have equiped   %
% update:   updats health and energy when in battle                     %
% levelUp:  level ups player                                            %
% endBattle:    any extra calculations or actions after the battle      %
% check:    checks if player or enemy is dead                           %
% showDamage:   displays damage done                                    %
% statCalc: calculates player's total stats in battle                   %
% extraDamage:  calculates any dodge or crit                            %
% animate:  animates attack                                             %
% attacking:    does damage to player or enemy                          %
% order:    calculates battle order of attack                           %
% attack:   player selects which enemy to attack                        %
% ability:  does specail ability for class and then attack (temp stat   %
%           boost, but must have enough energy                          %
% battle:   battle main menu                                            %
% pattlePicStart:   initializes pictures for battle                     %
% battleStart:  initializes monsters for battle                         %
% save:     saves player stuff to the appropriate file                  %
% party:    displays info for anyone in the player's group              %
% equip2:   allows user to select armour for previously selected area   %
% euqipMenu:    allow user to select area to change armour for          %
% pauseMenu:    brings up in game menu                                  %
% move:     checks what key is pressed and does appropriate actions     %
% picInitialize:    initializes picture for game                        %
% settingsConfig:   allows user to configure controls                   %
% gameInitialze2:   continues gameInitialize                            %
% gameInitialize:   initializes many elements in the game               %
% gameLoad: loads game info from previously started game                %
% gameStart:    checks if game should be a new game or a continued one  %
% startNewGame: resets stats for player                                 %
% say:      says certain things for cut scenes                          %
%***********************************************************************%
% ERROR HANDLING                                                        %
%                                                                       %
% The only knowen possible error is the player entering their name as   %
% more than 255 characters, in which case, the program will crash       %
%                                                                       %
%***********************************************************************%
% PROGRAM LIMITATIONS                                                   %
%                                                                       %
% This program has a few limitations such as only 255 characters for a  %
% name, and there are very few pieces of armour                         % 
%                                                                       %
%***********************************************************************%
% EXTENSIONS AND IMPROVEMENTS                                           %
%                                                                       %
% This program could be improved in a variety of ways:                  %
% 1. Adding more items                                                  %
% 2. Adding more areas                                                  %
% 3. better graphics                                                    %
%***********************************************************************%


%The program generates the correct screen size and type
setscreen ("graphics:800;600,nobuttonbar, nocursor, noecho")

%record for any person in game
type person : 
record
    name : string %person name
    pic : array 1..4, 1..4 of int
    dir : int %(up = 1, down = 2, left = 3, right = 4)
    sprite : int%sprite for person 
    Class : string %determines different things such as leving stats
    level : int%person's level
    health : array 1..2 of int%person's base health
    energy : array 1..2 of int%person't base energy (acts like "mana"
    attack: int%person's base attack
    defense : int%person's base defense
    speed : int%what order the monsters will attack in
    dodge : real%chance of taking no damage
    crit : real%person's damage boost whatever the appropriate antonym for boost is
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

type stats : %for any stat increase or decrease
record
    file : string %file location
    health : int %health increase
    energy : int %energy increase
    attack : int %attack    "
    defense : int %defense  "
    speed : int%speed       "
    dodge : real %dodge percent increase
    crit : real %crit percent    "
    where : string %where on the body is usable
end record

type items : %used for any item
record
    file : string %file location
    number : int %amount of said item
end record

var font : int := Font.New ("serif:16") %I don't always make new fonts, but when I do, I make them because I need a bigger size
var damageNum : int := Font.New ("mono:12:bold") %again, I need a different size
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
var xArrow, yArrow, arrow, temp, stream,pressStart,count,endCount, earnExp : int := 0 %xArrow, yArrow, arrow are position for and the arrow, arrow is a sprite variable, temp is for the funtion "menuFunction", stream is for openning files, press start is another sprite variable, count and end count are used for walking animations, earnExp is amout of exp earned from a battle
var optionNum, location : string := "" %Used for confirmed options/ choises
var done, stop, continue, back, battleEnd, giveEXP,lose,win : boolean := false %used for ending the game, exiting loops, whether to start the game section from the begining or not, going back to a different menu, if a battle is over, and whether or no to give EXP, if you win or lose the game
var key : string (1) %used explicitely for getch
var text : array 0 .. 40 of int %array for text pictures
var controls : array 0..6,1..2 of int %controls
var controlPics : array 0..6 of int%pictures for the different keys (controls)
var buildingNum : int %number of buildings
var buildings : flexible array 1..0 of building %different solid things in the area
var place : area %place where the player is
var player : person%player sprite and stuff
var chance, encounter : real %chance of encounter and variable for determining if there is an encounter or not
var monsterData : array 1..2 of int %stores the range of monsters that are fight-able in an area
var battleSprites : array 1..5 of int %battle sprites for battleing (default, attack, ability and dead picture
var monsters : array 1..3 of monster %array of enemies for in a battle
var equiped : array 1..6 of stats %euqiped items that give stat boosts
var cutscene : int %if and which cutscene to play
var sceneTemp : flexible array 1..0 of int %temporary variables for cut scenes (new sceneTemp,0 delets all the pictures or values)
var equipables : array 1..18 of items %array of all equipabe items
var equipableStats : array 1..18 of stats %stats for above items
var badGuy : int := Pic.FileNew ("monsters/3/1.bmp") %pic for bad guy

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

%used displaying text
proc print (text : string, x,y: int)
    for i : 1..length (text)
	%scrolls text
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
    open : stream, "settings.dat", put
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
    location := buildings(num).destination
    %opens .dat file for location
    open : stream, buildings(num).destination, get
    %gets picture location & makes it a picture
    get : stream, temp 
    place.pic := Pic.FileNew (temp)
    %gets the number of objects, the colour of the border, and the chance of fighting a monster
    get : stream, buildingNum 
    get : stream, place.borderColour
    get : stream, chance
    get : stream, cutscene
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

%restores health if the location allows it
proc heal (col, col2 : int) %colour at two locations
%if the building is the correct colour and has the correct direction (key) assigned to it, restore health and energy
    for i : 1.. buildingNum 
	if (col = buildings(i).Colour or col2 = buildings(i).Colour) and buildings(i).direction = "confirm" then
	    player.health (1) := player.health (2)
	    player.energy (1) := player.energy (2)
	    Pic.Draw (intro(0),1,1,picCopy)
	    delay (1000)
	    noInput
	    cls
	end if
    end for
end heal

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
	%check if the player should get healed
    elsif keyPress (key) = "confirm" then
	heal (whatdotcolour (maxx div 2, maxy div 2 + 50), whatdotcolour (maxx div 2-30, maxy div 2))
    end if
end keyAction

%does moving animation
proc moving
    %endCount is the amount of time you have been standing still (<10 = <50 ms)
    if endCount < 10 then
	%changes the sprite's position
	Sprite.Animate (player.sprite, player.pic ((count div 4) mod 4 + 1,player.dir),maxx div 2, maxy div 2, true)
	%updates the sprite's location
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
    get : stream, player.Class
    get :stream, player.level
    get : stream, player.health (1)
    player.health (2) := player.level *5 + 15
    player.energy (2) := player.level *5 + 15
    get :stream, player.energy (1)
    get :stream, player.attack
    get :stream, player.defense
    get :stream, player.speed
    get :stream, player.dodge
    get :stream, player.crit
    get: stream, player.EXP (1)
    close : stream
    %total amount of exp
    player.EXP (2) := ((player.level+1) * (30) div 4)
    %gets item stat boosts
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
	get : stream, equiped(i). where
	close : stream
    end for
end getStats

%updates the battle screen
proc update
    var options :int := Pic.FileNew ("images/battle 2.bmp") %menu
    var back : int := Pic.FileNew ("images/battle.bmp") %background picture
    cls
    %redraws backgroud, menu, and current health
    Pic.Draw (back,1,1,picCopy)
    Pic.Draw (options,400,1,picMerge)  
    Font.Draw("Health: "+intstr (player.health(1),0) + "/"+intstr (player.health(2),0),25,100,font,black)
    Font.Draw("Energy: "+intstr (player.energy(1),0) + "/"+intstr (player.energy(2),0),25,75,font,black)
    View.Update
end update

%levels up the player
proc levelUp
    var temp : int %int and real variable
    var temp2 : real
    %levels up as many times as needed
    loop
    %if exp is enough to level up, then add stat boosts based on player class
	if player.EXP (1) >= player.EXP (2) then
	    Font.Draw("LEVEL UP!",25,100,font,black)
	    View.Update
	    confirm
	    player.EXP (1) -= player.EXP (2)
	    player.level +=1
	    player.EXP (2) := ((player.level+1) * (30) div 4)
	    player.health (2) := player.level *5 + 15
	    player.energy (2) := player.level *5 + 15
	    open : stream, "class/"+player.Class+".dat",get
	    get : stream, temp
	    player.health(2) += temp
	    get : stream, temp
	    player.energy(2) += temp
	    get : stream, temp
	    player.attack += temp
	    get : stream, temp
	    player.defense += temp
	    get : stream, temp
	    player.speed += temp
	    get : stream, temp2
	    player.dodge += temp2
	    get : stream, temp2
	    player.crit += temp2
	    close : stream
	else
	    exit
	end if
    end loop
end levelUp

%any follow up calculations or changes when the battle is finished
proc endBattle
    var back : int := Pic.FileNew ("images/battle.bmp") %background picture
    Pic.Draw (back,1,1,picMerge)
    Sprite.Hide (arrow)
    %gives exp if to player if they won
    if giveEXP = true then
	giveEXP := false
	player.EXP(1) += earnExp
	Font.Draw (intstr (earnExp,0)+" EXP earned!", 25,140, font, black)
	View.Update
	confirm
	cls
	levelUp
    end if
    %resets amount for next battle
    earnExp := 0
    %deletes any alive enemies (used if player escaped from battle)
    for i : 1..3
	if monsters (i).alive = true then
	    monsters (i).alive := false
	    Sprite.Free (monsters (i).sprite)
	end if
    end for
	%changes the player back to normal
    Sprite.Free (battleSprites (5))
    cls
    Sprite.Show (player.sprite)
    View.Update
end endBattle

%after attack calculations
proc check (target : int)
    var fade : int := Pic.FileNew ("images/kill.bmp") %used to fade out enemies
    var count : int := 0 %number of dead enemies
    %if the enemy died, reset the sprite value, and add it's exp to the possible earned amount
    if monsters (target).health < 1 and monsters(target).alive=true then
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
    %check if player died
    if player.health (1) < 1 then
	Sprite.Animate (battleSprites (5),battleSprites (4),585, 300,false)
	update
	delay (500)
	done := true
	battleEnd := true
	lose := true
    end if
end check

%displays amount of damage done by player
proc showDamage (text : string, x,y : int)
    for i : 1..length (text)
	Font.Draw (text (1..i), x-5, y, damageNum,brightred)
	delay (100)
    end for
	delay (500)
end showDamage

%calculates stat boosts from equiped items
proc statCalc (var attack, defense : int, var crit, dodge : real)
    for i : 1..6
	defense += equiped(i).defense
    end for
	for i : 1..6
	attack += equiped(i).attack
    end for
	for i : 1..6
	crit += equiped(i).crit
    end for
	for i : 1..6
	dodge += equiped(i).dodge
    end for
end statCalc

%calculates dodge or crit
proc extraDamage (target : string, num : int, var damage, defense : int, var dodge, crit : real)
    var text : string
    var temp : real %for random number calculation
    %if the calculations is for the player (if the player is attacking)
    if target = "person" then
	%if random num is smaller than player the players crit num then double damage. if next random num is less than enemy dodge number, than no damage done to enemy
	rand (temp) 
	if temp < crit then
	    damage := damage *2
	end if
	rand (temp)
	if temp < monsters (num).dodge then
	    damage := monsters(num).defense                 
	end if
	%for displaying damage delt to player
	if damage = monsters (num).defense then
	    text := "Miss"
	else
	    text := intstr (damage - monsters (num).defense,1)
	end if
	showDamage (text, 180, 425 - (num * 50))
    else rand (temp)
	%escentially the same as above, with the calcuations being a bit different as the attack and defense variables only aply to the player, not enemies
	if temp < monsters (num).crit then
	    player.health(1) -= (monsters(num).attack * 2) - defense
	    text := intstr (monsters (num).attack *2 - defense, 1)
	end if
	rand (temp)
	%for calculating damage done by player and then displaying it
	if temp >= dodge then
	    player.health(1) -= monsters(num).attack - defense
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

%calculates base damage before crits/ dodges (order, alive entities, target)
proc attacking (order : array 1..7, 1..2 of int, num, target: int)
    var defense : int := player.defense %player's defense value (armour + base)
    var damage : int := player.attack %palyers attack value (armour/weapon + base)
    var dodge : real := player.dodge
    var crit : real := player.crit
    var count, temp : int := 0 %amount of monsters that have attacked and variable because I needed one as a place holder
    %calculates defense and attack
    statCalc (defense,damage,crit,dodge)
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
		    extraDamage ("enemy", count, temp,defense,dodge, crit)
		else player.health(1) -=1
		    showDamage ("1", 610, maxy div 2 +75)
		end if
	    end if
	    check (target)
	elsif player.health (1) > 0 then
	    %attack animation, calculate damage done (minimum = 1),and updates screen as well as any deaths
	    animate ("player",0)
	    if monsters(temp + 1).defense >= damage then
		monsters (target).health -= 1
		showDamage ("1", 180, 425 - (num * 50))
	    else
		extraDamage ("person", target,damage,defense,dodge, crit)
		monsters (target).health := monsters(target).health - (damage- monsters(target).defense)
	    end if
	    %sees if monster was killed, as wel as updates the sreen
	    check (target)
	end if
	update
	delay (500)
    end for
	update
    noInput
end attacking

%calculates in what order who will attack (number of alive enemies, target for player)
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
    %passes values for the turn for each player, the number of alive enemies, the targeted enemy's array value)
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

%if user want to use an ability
proc ability
    var temp3 : int
    var temp2 : real
    %energy is used, then class ability is used
    player.energy(1) -= 5
    update
    if player.Class = "archer" then
	temp2 := player.crit
	player.crit := 0.8
	attack
	player.crit := temp2
    elsif player.Class = "knight" then
	temp := player.attack
	player.attack := round (player.attack * 1.5)
	attack
	player.attack := temp
    else
	temp2 := player.dodge
	player.crit := 0.8
	attack
	player.dodge := temp2
    end if
end ability

%battle main menu
proc battle 
    var stop : boolean := false %if the battle is over
    %updates screen and then allows user to select "attack," "abilities," "bag," or "escape," and sets default give exp to true
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
	%attack, ability, items, and escape
	if optionNum = "0" then
	    attack
	elsif optionNum = "1" then
	    optionNum := ""
	    if player.energy (1)  > 4 then
		ability
	    end if
	elsif optionNum = "2" then
	    temp := 0
	    optionNum := ""
	elsif optionNum = "3" then
	    optionNum := ""
	    battleEnd := true
	    giveEXP := false
	end if
	exit when battleEnd = true
    end loop
    %resets variables
    battleEnd := false
    endBattle
    temp := 0
    Sprite.Show (place.sprite)
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

%saves player data
proc save
    optionNum := ""
    %opens save file and puts location and into it
    open : stream, "game.sav", put
    put : stream, "continue"
    %x&y coordinate from center, location
    put : stream, place.x- maxx div 2
    put : stream, place.y -maxy div 2
    put : stream, location
    close : stream
    %puts items, equiped items, and player stats into an external doccument
    open : stream, "items.dat",put
    for i : 1..18
	put: stream, equipables (i).number
    end for
	close : stream
    open : stream, "equip.dat", put
    for i : 1..6
	put : stream, equiped (i).file
    end for
	close : stream
    open : stream, "player.dat", put
    put :stream, player.name
    put : stream, player.Class
    put :stream, player.level
    put : stream, player.health (1)
    put :stream, player.energy (1)
    put :stream, player.attack
    put :stream, player.defense
    put :stream, player.speed
    put :stream, player.dodge
    put :stream, player.crit
    put: stream, player.EXP (1)
    player.EXP (2) := (player.level+1) * (30) div 4
    close : stream
    colour (white)
    locate (1,1)
    put "Saved"..
    delay (1000)
    noInput
    cls
    colour (black)
end save

%shows player stats
proc party
    var playerSheet : int := Pic.FileNew ("images/stats.bmp") %background image
    optionNum := ""
    colourback (white)
    %locates and displays stats
    loop
	delay (100)
	Pic.Draw (playerSheet,1,1,picCopy)
	locatexy (460,530)
	put player.name
	locatexy (460, 600-105)
	put player.Class
	locatexy (465,450)
	put player.health (1), "/ ", player.health (2)
	locatexy (470,390)
	put player.energy (1), "/ ", player.health (2)
	locatexy (462,600- 272)
	put player.attack
	locatexy (480,600- 330)
	put player.defense
	locatexy (455,600- 390)
	put player.speed
	locatexy (460,600- 450)
	put player.crit * 100
	locatexy (485,600- 510)
	put player.dodge * 100
	if hasch then
	    getch (key)
	end if
	if keyPress (key) = "back" then
	    key := "]"
	    exit
	elsif keyPress (key) = "menu" then
	    exit
	end if
    end loop
    colourback (18)
end party

%allows plaer to select item to equip to selected area
proc equip2
    var canEquip : array 1..5 of stats %equipable stats for area
    var count : int := 0 %number of equipable stats
    var num : int %number assigned to area
    var pic3 : int := Pic.FileNew ("images/arrow3.bmp") %different arrow pic
    var arrow3 : int := Sprite.New (pic3) %turns above into sprite
    var str : string %temp for displaying name of item
    var done : boolean := false %for exiting loop
    %resets and assignes values to variabels
    temp := 0
    num := strint (optionNum) + 1
    Sprite.SetHeight (arrow3,28)
    Sprite.SetPosition (arrow3,1,1,true)
    Sprite.Show (arrow3)
    %checks if item is equipable
    for i : 1..18
	if equipables (i).number > 0 and equipableStats (i). where = optionNum or equipableStats (i). where = "anywhere" then
	    count += 1
	    canEquip (count) := equipableStats (i)
	end if
    end for
	optionNum := ""
    %displays eqipable item
    loop
	for i : 1.. count
	    locatexy (480,((600 + 50)- num * 100)- (i-1)*20)
	    str := canEquip (i).file
	    for j : 1..(length (str) - 4)
		if str (j) = "_" then 
		    put " ".. 
		else put str (j)..
		end if
	    end for
	end for
	%allows user to equip equipment
	    menuFunction (count)
	case temp of
	label 0 : 
	    xArrow := 480 + round (length (canEquip (1).file) *4.5+75)
	    yArrow := ((600 + 50)- num * 100)- (temp)*20
	label 1 :
	    xArrow := 480 + round (length (canEquip (2).file) *4.5+75)
	    yArrow := ((600 + 50)- num * 100)- (temp)*20
	label 2 :
	    xArrow := 480 + round (length (canEquip (3).file) *4.5+75)
	    yArrow := ((600 + 50)- num * 100)- (temp)*20
	end case
	Sprite.SetPosition (arrow3,xArrow,yArrow,true)
	if optionNum not= "" then
	    equiped (num) := canEquip (strint (optionNum)+1)
	    optionNum := ""
	    equiped (num) .file := "items/equipables/"+equiped(num).file
	    done := true            
	end if
	%goes back (resets key variable)
	if keyPress (key) = "back" or done = true then
	    key := "]"
	    cls
	    exit
	end if
    end loop
    %resets values
    optionNum := ""
    temp := num - 1
    Sprite.Free (arrow3)
end equip2

%menu for changing equipment
proc equipMenu
    var pic : int := Pic.FileNew ("images/equip.bmp") %background pic
    var pic2 : int := Pic.FileNew ("images/arrow2.bmp") %new arrow pic
    var sprite : int := Sprite.New (pic) %next two turns above into sprites
    var arrow2 : int := Sprite.New (pic2)
    var str : string
    optionNum := ""
    temp := 0
    colourback (white)
    Sprite.SetHeight (sprite,25)
    Sprite.SetHeight (arrow2,26)
    Sprite.SetPosition (sprite,1,1,false)
    Sprite.SetPosition (arrow2,1,1,true)
    Sprite.Show (arrow2)
    Sprite.Show (sprite)
    %displays stuff currently equipped
    loop
	for i : 1..6
	    locatexy (480,(600 + 50)- i * 100)
	    str := equiped (i).file (18..*)
	    for j : 1..(length (str) - 4)
		if str (j) = "_" then 
		    put " ".. 
		else put str (j)..
		end if
	    end for
	end for
	    delay (10)
	    %allows user to select what they want to change
	menuFunction (6)
	case temp of
	label 0 : 
	    xArrow := 480 + round (length (equiped (1).file) *4.5)
	    yArrow := 550
	label 1 :
	    xArrow := 480 +round (length (equiped (2).file) *4.5)
	    yArrow := 450
	label 2 :
	    xArrow := 480 + round (length (equiped (3).file) *4.5)
	    yArrow := 350
	label 3 :
	    xArrow := 480 + round (length (equiped (4).file) *4.5)
	    yArrow := 250
	label 4 :
	    xArrow := 480 + round (length (equiped (5).file) *4.5)
	    yArrow := 150
	label 5 :
	    xArrow := 480 + round (length (equiped (6).file) *4.5)
	    yArrow := 50
	end case
	if optionNum not= "" then
	    equip2
	end if
	Sprite.SetPosition (arrow2,xArrow,yArrow,true)
	%goes back to pause of game
	if keyPress (key) = "back" then
	    key := "]"
	    exit
	elsif keyPress (key) = "menu" then
	    exit
	end if
    end loop
    colourback (18)
    Sprite.Free (arrow2)
    Sprite.Free (sprite)
    temp := 1
end equipMenu

%allows you to check player info, save, and exit
proc pauseMenu
    var image : array 1..4 of int 
    image (1):= Pic.FileNew ("images/pause menu.bmp") %image for menu
    var sprite : int := Sprite.New (image(1))
    image (2):= Pic.FileNew ("images/pause menu2.bmp") %image for menu
    image (3):= Pic.FileNew ("images/pause menu3.bmp") %image for menu
    image (4):= Pic.FileNew ("images/pause menu4.bmp") %image for menu
    %resets key so that you can exit by pressing menu again (randomly chose })
    key := "}"
    Sprite.SetPosition (sprite,maxx-205, maxy - 355, false)
    %draws the arrow in certain positions and allows you to pick options
    loop
    %allows the user to pic the correct option
	Sprite.Show (sprite)
	delay (5)
	menuFunction (4)
	case temp of
	label 0:
	    Sprite.ChangePic (sprite, image (1))
	label 1:
	    Sprite.ChangePic (sprite, image (2))
	label 2:
	    Sprite.ChangePic (sprite,image (3))
	label 3:
	    Sprite.ChangePic (sprite,image (4))
	end case
	%party, equip, save, quit
	if optionNum = "0" then
	    party
	elsif optionNum = "1" then
	    equipMenu
	elsif optionNum = "2" then
	    save
	elsif optionNum = "3" then
	    done:= true
	    exit
	end if
	%exits pause menu
	if keyPress (key) = "back" or keyPress (key) = "menu" then
	    key := "}"
	    exit
	end if
	View.Update
    end loop
    Sprite.Free (sprite)
    temp := 0
    optionNum := ""
end pauseMenu

%procedure for moving character
proc move
    %when a key is pressed
    if hasch = true then
	getch (key)
	%brings up in game menu
	if keyPress (key) = "menu" then
	    pauseMenu
	    %moving keys
	elsif keyPress (key) = "up" or keyPress (key) = "down" or keyPress (key) = "left" or keyPress (key) = "right" then
	    count +=1 %increases
	    endCount := 0 %resets value
	    keyAction
	    rand (encounter) %random number to check to see if encounted a monster
	    if encounter < chance then %ITS TIME FOR A DEATH BATTLE!!!
		battleStart
	    end if
	elsif keyPress (key) = "confirm" then
	    keyAction
	end if
    end if
    endCount += 1 %increases (value won't reset unless movement key is pressed)
    moving%any movement animation that needs to be done
end move

%Imports pictures that are needed from the start
proc picInitialize
    var temp : string
    %text
    open : stream, "text.dat", get
    for i : 0 .. 40
	get : stream, temp
	text (i) := Pic.FileNew (temp)
    end for        
	%intro to game
    close : stream
    open : stream, "introPics.dat", get
    for i : 0..3
	get : stream, temp
	intro (i) := Pic.FileNew (temp)
    end for
	close : stream
    %player sprites
    open : stream, "sprite location.dat", get
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
    open : stream, "settings.dat", get
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
    open : stream, "items/equipables/manifest.dat", get
    for i :1..18
	get : stream, equipables(i).file
    end for
	close : stream
    open : stream, "items.dat",get
    for i : 1..18
	get : stream, equipables (i).number
    end for
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
    get : stream, cutscene
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
    get : stream, location %file location of area last area
    close : stream
    %adds value of x to the center to get the correct position
    place.x += x
    place.y += y
    %gets game stats and then moves on to part 2
    getStats
    gameInitialize (location)
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

%to start a new game
proc startNewGame
    var temp2 : string
    var temp : int %temp stores default info
    Sprite.Hide (player.sprite)
    Sprite.Hide (place.sprite)
    %obtains the default save info and uses it to reset the save file
    open:stream, "newGame.sav", get
    get : stream, temp2
    get: stream, temp
    place.x := temp
    get: stream, temp
    place.y := temp
    get : stream, location %file location of area last area
    close : stream
    gameInitialize (location)
    %resets the equiped items
    open:stream, "startEquip.dat", get
    for i : 1..6
	get: stream, equiped (i).file
    end for
	close : stream
    open: stream, "equip.dat", put
    for i : 1..6
	put: stream, equiped (i).file
    end for
	close : stream
    %resets items
    for i : 1..18
	equipables(i).number := 0
    end for
	open : stream, "newPlayer.dat", get
    get :stream, player.name
    get : stream, player.Class
    get :stream, player.level
    get : stream, player.health (1)
    player.health (2) := 20
    get :stream, player.energy (1)
    player.energy (2) := 20
    get :stream, player.attack
    get :stream, player.defense
    get :stream, player.speed
    get :stream, player.dodge
    get :stream, player.crit
    get: stream, player.EXP (1)
    close : stream
end startNewGame

%displays text in a certain way (which folder its located in, and which file
proc say (subfolder : string, num : int)
    var text, temp, file : string := "" %what to display, temp for geting text, and file location
    var overlay : int := Pic.FileNew ("images/text area.bmp") %background to go behind text
    %assignes correct location of the file to file
    file := "text/"+ subfolder + intstr (num,0) + ".dat"
    %opens and reads the whole file
    open : stream, file, get
    loop
	exit when eof (stream)
	get : stream, temp
	temp += " "
	text += temp
    end loop
    close : stream %draws background pic and displays text in a scrolling fasion
    Pic.Draw (overlay,1,1,picMerge)
    delay (500)
    for i : 1..length (text)
	Font.Draw (text(1..i), 25,125,font, black)
	View.Update
	delay (10)
    end for
	Font.Draw (text, 25,125,font, black)
    noInput
    confirm
    cls   
end say

%different initializers
picInitialize
settingsConfig
gameStart

%turns arrow picture into a sprite
arrow := Sprite.New (arrowPic)
Sprite.SetHeight (arrow,20)
pressStart := Sprite.New (startPic)
Sprite.SetPosition (pressStart,400,150,true)
%intro
drawfill (1,1,black,black)

%used a loop to be able to exit
loop
    %fades intro pics in and out, and allows users to skip to main menu
    temp += 1
    pressKey
    Pic.DrawSpecial (intro (0), 1,1, picCopy, picFadeIn, 500)
    if hasch = true then
	exit
    end if
    delay (500)
    pressKey
    if stop = true then exit
    end if
    Pic.DrawSpecial (intro (temp), 1,1, picCopy, picFadeIn, 1000)
    pressKey
    if stop = true then exit
    end if
    delay (1500)
    pressKey
    if stop = true then exit
    end if
    exit when temp =3
end loop
noInput
stop := false
temp := 0
%main menu start up animations
Pic.DrawSpecial (intro (0), 1,1, picCopy, picFadeIn, 500)
delay (1000)
Pic.DrawSpecial (background, 1, 1, picCopy, picFadeIn, 2500)
delay (500)
Pic.DrawSpecial (logoFlash, 279, 375, picMerge, picWipeLeftToRight, 50)
delay (250)
Pic.DrawSpecial (logo, 279, 375, picMerge, picFadeIn, 300)
Pic.DrawSpecial (background, 1, 1, picCopy, picFadeIn, 100)
Pic.Draw (logo, 279, 375, picMerge)
delay (250)
noInput
loop
    Sprite.Show (pressStart)
    pressKey
    if stop = true then exit
    end if
    delay (500)
    Sprite.Hide (pressStart)
    pressKey
    if stop = true then exit
    end if
    delay (500)
end loop
stop := false
Sprite.Hide (pressStart)
Sprite.Free (pressStart)
Pic.DrawSpecial (menu, 248, 8, picMerge, picWipeUpperLeftToLowerRightNoBar, 250)
delay (500)
Pic.DrawSpecial (menuWords, 248, 8, picMerge, picWipeCentreToEdgeNoBar, 100)
delay (250)

%Sets the sprite position for the arrow and displays it
xArrow := 320
yArrow := 150
Sprite.SetPosition (arrow, xArrow, yArrow, false)
Sprite.Show (arrow)

noInput
%main menu loop
loop
    menuFunction (3)
    case temp of
    label 0 : %when the option is play
	xArrow := 320
	yArrow := 150
    label 1 : %when it's option
	xArrow := 283
	yArrow := 98
    label 2 : %when it's quite
	xArrow := 320
	yArrow := 43
    end case
    %starts game when play is selected
    if optionNum = "0" then
	optionNum := ""
	noInput
	if continue = true then
	    Pic.DrawSpecial (contOrNew, 248, 8, picMerge, picWipeCentreToEdgeNoBar, 100)
	    loop
		menuFunction (2)
		case temp of
		label 0 : %when the option is new game
		    xArrow := 250
		    yArrow := 133
		label 1 : %when it's continue
		    xArrow := 273
		    yArrow := 62
		end case
		if optionNum = "0" then
		    temp := 0
		    optionNum := ""
		    cls
		    continue := false
		    exit
		elsif optionNum = "1" then
		    temp := 0
		    optionNum := ""
		    cls
		    continue := true
		    exit
		end if
		Sprite.SetPosition (arrow, xArrow, yArrow, false)
	    end loop
	end if
	exit
	%goes to option menu
    elsif optionNum = "1" then
	optionNum := ""
	temp := 0
	Pic.DrawSpecial (optionsMenu, 1, 1, picCopy, picGrowBottomToTop, 500)
	loop
	    menuFunction (8)
	    %in order: up, down, left, right, confirm, back, menu
	    case temp of
	    label 0 :
		xArrow := 147
		yArrow := 462
	    label 1 :
		xArrow := 147
		yArrow := 414
	    label 2 :
		xArrow := 147
		yArrow := 367
	    label 3 :
		xArrow := 147
		yArrow := 326
	    label 4 :
		xArrow := 147
		yArrow := 278
	    label 5 :
		xArrow := 147
		yArrow := 230
	    label 6 :
		xArrow := 147
		yArrow := 183
	    label 7 :
		xArrow := 587
		yArrow := 127
	    end case
	    %shows the thing that corresponds to the control
	    for i : 0..6
		Sprite.Show (controlPics (i))
	    end for
		
	    %for changing the controls
	    if optionNum = "0" then
		optionNum := ""
		changeKey (0)
		settingsConfig
	    elsif optionNum = "1" then
		optionNum := ""
		changeKey (1)
		settingsConfig
	    elsif optionNum = "2" then
		optionNum := ""
		changeKey (2)
		settingsConfig
	    elsif optionNum = "3" then
		optionNum := ""
		changeKey (3)
		settingsConfig
	    elsif optionNum = "4" then
		optionNum := ""
		changeKey (4)
		settingsConfig
	    elsif optionNum = "5" then
		optionNum := ""
		changeKey (5)
		settingsConfig
	    elsif optionNum = "6" then
		optionNum := ""
		changeKey (6)
		settingsConfig
		%If exit is selected, go through an animation, then go back to normal
	    elsif optionNum = "7" then
		%hides the control pictures
		for i : 0..6
		    Sprite.Hide (controlPics (i))
		end for
		    
		Pic.DrawSpecial (background, 1, 1, picCopy, picGrowTopToBottom, 500)
		Pic.Draw (logo, 279, 375, picMerge)
		delay (250)
		Pic.DrawSpecial (menu, 248, 8, picMerge, picWipeUpperLeftToLowerRightNoBar, 250)
		delay (500)
		Pic.DrawSpecial (menuWords, 248, 8, picMerge, picWipeCentreToEdgeNoBar, 100)
		delay (250)
		exit
	    end if
	    Sprite.SetPosition (arrow, xArrow, yArrow, false)
	end loop
	temp := 1
	optionNum := ""
	noInput
	%finishes the game when quit is selected
    elsif optionNum = "2" then
	optionNum := ""
	cls
	done := true
	exit
    end if
    %resets sprite position
    Sprite.SetPosition (arrow, xArrow, yArrow, false)
end loop
%gets rid of the arrow
Sprite.Hide (arrow)

Pic.DrawSpecial (intro (0),1,1, picCopy,picFadeIn, 750)
delay (500)

if continue = false and done = false then
    %load save info
    gameLoad
    %resets stats
    startNewGame
    %by default, the player sprite is shown. this changes it
    Sprite.Hide (player.sprite)
    Sprite.Hide (place.sprite)
    %creates 11 elements in the array
    new sceneTemp, 11
    %pictures and sprite declarations
    sceneTemp (1) := Pic.FileNew ("images/intro/background.bmp")
    sceneTemp (2) := Pic.FileNew ("images/intro/backpack1.bmp")
    sceneTemp (3) := Pic.FileNew ("images/intro/backpack3.bmp")
    sceneTemp (4) := Pic.FileNew ("images/intro/backpack1.bmp")
    sceneTemp (5) := Pic.FileNew ("images/intro/backpack2.bmp")
    sceneTemp (6) := Sprite.New (sceneTemp (2))
    sceneTemp (7) := Sprite.New (sceneTemp (1))
    sceneTemp (8) := Pic.FileNew ("images/intro/ex.bmp")
    sceneTemp (9) := Sprite.New (sceneTemp (8))
    sceneTemp (10) := Pic.FileNew ("images/lake.bmp")
    sceneTemp (11) := Pic.FileNew ("images/intro/backpack4.bmp")
    Sprite.SetPosition (sceneTemp (6),maxx div 2, maxy div 2, true)
    Sprite.SetPosition (sceneTemp (7),1, 1, false)
    Sprite.SetPosition (sceneTemp (9),maxx div 2, maxy div 2 + 75, true)
    Sprite.SetHeight (sceneTemp (6),3)
    Sprite.SetHeight (sceneTemp (7),2)
    Sprite.SetHeight (sceneTemp (9),3)
    %intro cut scene
    Pic.Draw (sceneTemp (1),1,1,picMerge)
    Sprite.Show (sceneTemp (6))
    View.Update
    say("intro//",1)
    Pic.Draw (sceneTemp (1),1,1,picMerge)
    View.Update
    say("intro//",2)
    Sprite.Show (sceneTemp (7))
    %walking animation
    for decreasing i : -1..-45
	Sprite.SetPosition (sceneTemp (7),i * 12, 1, false)
	Sprite.Animate (sceneTemp (6), sceneTemp (i mod  4 + 2), maxx div 2, maxy div 2, true)
	delay (75)
	View.Update
    end for
	%realization (!) and flash
    Sprite.Show (sceneTemp(9))
    View.Update
    delay (1000)
    Sprite.Hide (sceneTemp(9))
    View.Update
    delay (100)
    Sprite.Animate (sceneTemp (7),sceneTemp (10),maxx div 2, maxy div 2, true)
    View.Update
    delay (100)
    Sprite.Hide (sceneTemp (7))
    Pic.Draw (sceneTemp (1),-540,1,picMerge)
    View.Update
    delay (100)
    say("intro//",3)  
    Pic.Draw (sceneTemp (1),-540,1,picMerge)
    %flashing background and text
    for i : 4..5
	for j : 1..5
	    delay (50)
	    Pic.Draw (sceneTemp (10),-900,-600,picMerge)
	    delay (50)
	    Pic.Draw (sceneTemp (1),-540,1,picMerge)
	    View.Update
	end for
	    say("intro//",i)
	Pic.Draw (sceneTemp (1),1,1,picMerge)
    end for
	for i : 1..5
	delay (50)
	Pic.Draw (sceneTemp (10),-900,-600,picMerge)
	delay (50)
	Pic.Draw (sceneTemp (1),-540,1,picMerge)
	View.Update
    end for
	%OMGWTFBBQLOLLMAOROLFCOPTRGG
    Pic.Draw (sceneTemp (10),-600,-300,picMerge)
    delay (100)
    Sprite.Animate (sceneTemp (6), sceneTemp (11), maxx div 2 - 20,maxy div 2, true)
    View.Update
    say("intro//",6)
    Pic.DrawSpecial (intro (0),1,1,picCopy,picFadeIn, 500)
    delay (1000)
    Sprite.Hide (sceneTemp (6))
    say("intro//",7)
    Pic.Draw (intro (0),1,1,picCopy)
    delay (1000)
    Sprite.Free (sceneTemp(6))
    Sprite.Free (sceneTemp(7))
    Sprite.Free (sceneTemp(9))
    %end of part one of scene, gets rid of images/sprites
    new sceneTemp, 0
    %part 2, new elements initialized, new pictures and sprites created
    new sceneTemp, 10
    sceneTemp (1) := Pic.FileNew ("images/intro/sleep.bmp")
    sceneTemp (2) := Pic.FileNew ("images/intro/sleep2.bmp")
    sceneTemp (3) := Pic.FileNew ("images/hotel_upstairs.bmp")
    sceneTemp (4) := Pic.FileNew ("images/intro/oldman1.bmp")
    sceneTemp (5) := Pic.FileNew ("images/intro/oldman2.bmp")
    sceneTemp (6) := Sprite.New (sceneTemp (4))
    sceneTemp (7) := Pic.FileNew ("images/yn.bmp")
    sceneTemp (8) := Pic.FileNew ("images/text area.bmp")
    sceneTemp (9) := Pic.FileNew ("images/name.bmp")
    sceneTemp (10) := Sprite.New (arrowPic)
    Sprite.SetPosition (sceneTemp (6),maxx div 2 + 120, -30,true)
    %wakes up in hous and talks to old man who comes in
    Pic.DrawSpecial (sceneTemp (1),1,1,picCopy,picFadeIn,500)
    delay (500)
    Pic.Draw (sceneTemp (2),1,1,picMerge)
    say("intro2/",1)
    View.Update
    Pic.Draw (sceneTemp (3),-105,-675,picMerge)
    Sprite.ChangePic (player.sprite, player.pic (1,4))
    Sprite.Show (player.sprite)
    View.Update
    say("intro2/",2)
    Pic.Draw (sceneTemp (3),-105,-675,picMerge)
    View.Update
    say("intro2/",3)
    Pic.Draw (sceneTemp (3),-105,-675,picMerge)
    View.Update
    say("intro2/",4)
    Pic.Draw (sceneTemp (3),-105,-675,picMerge)
    Sprite.Show (sceneTemp (6))
    %old man entering and turning
    for i : -30..maxy div 2 by 2
	Sprite.SetPosition (sceneTemp (6), maxx div 2 + 120, i,true)
	delay (10)
	View.Update
    end for
	Sprite.ChangePic (sceneTemp (6), sceneTemp (5))
    View.Update
    %long conversation
    for i : 5..35
	say("intro2/",i)
	Pic.Draw (sceneTemp (3),-105,-675,picMerge)
	View.Update
    end for
	%class selection time
    Pic.Draw (sceneTemp (8),1,1,picMerge)
    Font.Draw ("Ben: Do you know how to use a sword?", 25,125,font, black)
    Pic.Draw (sceneTemp(7), maxx - 125, 150, picMerge)
    Sprite.Show ( sceneTemp (10))
    View.Update
    %yes or no question (yes = knight class, no = next)
    loop
	menuFunction (2)
	case temp of
	label 0:
	    xArrow := maxx - 80
	    yArrow := 207
	label 1:
	    xArrow := maxx - 80
	    yArrow := 173
	end case
	if optionNum= "0" then
	    player.Class := "knight"
	    equipables (13).number := 1
	    exit
	elsif optionNum = "1" then
	    exit
	end if
	Sprite.SetPosition ( sceneTemp (10), xArrow, yArrow, true)
    end loop
    %resets for next question/ finish
    Sprite.Hide ( sceneTemp (10))
    cls
    optionNum := ""
    temp := 0
    %if you aren't a knight
    if player.Class = "civ" then
	%archer question
	Pic.Draw (sceneTemp (3),-105,-675,picMerge)
	Pic.Draw (sceneTemp (8),1,1,picMerge)
	Font.Draw ("Ben: How about a bow and arrow?", 25,125,font, black)      
	Pic.Draw (sceneTemp(7), maxx - 125, 150, picMerge)
	Sprite.Show ( sceneTemp (10))
	View.Update
	loop
	    %yes or no question (yes = archer class, no = martial)
	    menuFunction (2)
	    case temp of
	    label 0:
		xArrow := maxx - 80
		yArrow := 207
	    label 1:
		xArrow := maxx - 80
		yArrow := 173
	    end case
	    if optionNum = "0" then
		player.Class := "archer"
		equipables (11).number := 1
		exit
	    elsif optionNum = "1" then
		exit
	    end if
	    Sprite.SetPosition ( sceneTemp (10), xArrow, yArrow, true)
	end loop
	Sprite.Hide ( sceneTemp (10))
	cls
	optionNum := ""
	temp := 0
    end if
    %assigns you martial artist class because it requires very little training to hit something with a large stick
    Pic.Draw (sceneTemp (3),-105,-675,picMerge)
    if player.Class = "civ" then
	player.Class := "Martial-Artist"
	equipables (12).number := 1
	say("intro2/", 40)
	Pic.Draw (sceneTemp (3),-105,-675,picMerge)
    end if
    %tells user their class
    Pic.Draw (sceneTemp (3),-105,-675,picMerge)
    Pic.Draw (sceneTemp (8),1,1,picMerge)
    Font.Draw ("You are now a " + player.Class+ " class.", 25,125,font, black)
    confirm
    View.Update
    %LONG CONVERSATION
    for i : 36..39
	say("intro2/",i)
	Pic.Draw (sceneTemp (3),-105,-675,picMerge)
	View.Update
    end for
	setscreen ("cursor,echo")
    Sprite.Hide(sceneTemp (6))
    Sprite.Hide(player.sprite)
    Pic.Draw (sceneTemp (9),1,1,picCopy)
    locatexy (510,448)
    colourback (white)
    get player.name
    colourback (18)
    Sprite.Show(sceneTemp (6))
    Sprite.Show(player.sprite)
    cls
    setscreen ("nocursor,noecho")
    Pic.Draw (sceneTemp (3),-105,-675,picMerge)
    View.Update
    say("intro2/",41)
    %NOW you can play :D
    Sprite.Free(sceneTemp (6))
    Sprite.Free (sceneTemp (10))
    new sceneTemp,0
    Pic.DrawSpecial (intro(0),1,1,picCopy, picFadeIn, 500)
    %warning message
    Font.Draw ("NOTE: MENUS WON'T WORK PROPERLY UNLESS GAME IS RESTARTED",maxx div 2 - 300, maxy div 2, font, white)
    delay (5000)
    cls
    Sprite.Show (place.sprite)
    for i : 9..10
	equipables(i).number := 1
    end for
    else
    %load save info
    gameLoad
    getStats
end if


Sprite.Free (arrow)
arrow := Sprite.New (arrowPic)
Sprite.Show (arrow)
Sprite.Hide (arrow)

%gets equipabel items
for i : 1..18
    open : stream, ("items/equipables/" +equipables(i).file), get
    equipableStats (i). file := equipables (i).file
    get : stream, equipableStats(i).health
    get : stream, equipableStats(i). energy
    get : stream, equipableStats(i). attack
    get : stream, equipableStats(i). defense
    get : stream, equipableStats(i). speed
    get : stream, equipableStats(i). dodge
    get : stream, equipableStats(i). crit
    get : stream, equipableStats(i). where
    close: stream
end for
    
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
    %end game cutscene
    if cutscene = 1 then
	cls
	%conversation, battle, end game
	Sprite.Hide (place.sprite)
	Pic.Draw (place.pic,-200,-200,picCopy)
	Pic.Draw (badGuy,maxx div 2 + 200, maxy div 2, picMerge)
	say ("end/",1)
	Pic.Draw (place.pic,-200,-200,picCopy)
	Pic.Draw (badGuy,maxx div 2 + 200, maxy div 2, picMerge)
	say ("end/",2)
	Pic.Draw (place.pic,-200,-200,picCopy)
	Pic.Draw (badGuy,maxx div 2 + 200, maxy div 2, picMerge)
	monsterData (1) := 3
	monsterData (2) := 3
	battleStart
	Sprite.Hide (place.sprite)
	Pic.Draw (place.pic,-200,-200,picCopy)
	say ("end/",3)
	Pic.Draw (place.pic,-200,-200,picCopy)
	done := true
	win := true
    end if
end loop
%gets rid of any objects
cls
Sprite.Free (player.sprite)
Sprite.Free (place.sprite)
%if they lose or win, message
if lose = true then
    Font.Draw ("GAME OVER",355,maxy div 2,font, white)
elsif win = true then
    Font.Draw ("END OF BETA",350,maxy div 2,font, white)    
end if
