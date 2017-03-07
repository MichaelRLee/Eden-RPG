%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   WORKING ON                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the fun part                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

setscreen ("graphics:800;600,nobuttonbar, nocursor, noecho")
colourback (white)

type sprite : 
record
    name : string
    image : array 1..4,1..4 of int
    sprite : int
    dir : int
    x : int
    y : int
end record

var menu : int := Pic.FileNew ("images/menu.bmp") %Main menu options picture
var menuWords : int := Pic.FileNew ("images/menu options.bmp") %Options for menu
var arrowPic : int := Pic.FileNew ("images/arrow.bmp") %picture of the arrow
var optionsMenu : int := Pic.FileNew ("images/options menu.bmp") %background for options menu
var logo : int := Pic.FileNew ("images/logo.bmp") %EDEN logo
var logoFlash : int := Pic.FileNew ("images/logo flash.bmp") %white, bigger, logo
var startPic : int := Pic.FileNew ("images/press start.bmp")
var pauseMenuPic : int := Pic.FileNew ("images/pause menu.bmp")
var pauseMenuSprite : int := Sprite.New (pauseMenuPic)
var pressStart : int
var intro : array 0..3 of int
var xArrow, yArrow, arrow, temp, stream : int := 0 %xArrow, yArrow, arrow are position for and the arrow
var optionNum : string := "" %Used for confirmed options/ choises
var done, stop : boolean := false %used for ending the game
var key : string (1)
var text : array 0 .. 40 of int %array for text pictures
var controls : array 0..6,1..2 of int %controls
var controlPics : array 0..6 of int
var colourKey : array 0..2 of int
var player : sprite
var town : sprite
var count, endCount : int := 0

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

%gets the player images
proc playerImport
    var temp : string
    open : stream, "sprite location.txt", get
    for i : 1..2
        for j : 1..4
            get : stream, temp
            player.image (j,i) := Pic.FileNew (temp)
        end for 
    end for
        close : stream
end playerImport

%change the keys
procedure changeKey (num : int)
    xArrow += 350
    Sprite.SetPosition (arrow, xArrow, yArrow, false)
    Sprite.Show (arrow)
    %changes the key if it's valid
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
proc menuFuntion (option : int)
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
end menuFuntion

/*
proc pauseMenu
    Sprite.Show (pauseMenuSprite)
    Sprite.Show (town.sprite)
end pauseMenu


proc hitDetection (dir : string)
if dir = "up" then
for i : 1..3
end if

    
end hitDetection
*/

proc move
    if hasch = true then
        getch (key)
        if keyPress (key) = "menu" then
            %done := true
            %pauseMenu
        elsif keyPress (key) = "up" then
            %hitDetection ("up")
            town.y -= 10
            player.dir := 2
        elsif keyPress (key) = "down" then
            %hitDetection ("up")
            town.y += 10
            player.dir := 1
        elsif keyPress (key) = "left" then
            %hitDetection ("up")
            town.x += 10
            %player.dir := 4
        elsif keyPress (key) = "right" then
            %hitDetection ("up")
            town.x -= 10
            %player.dir := 3
        end if
        if keyPress (key) = "up" or keyPress (key) = "down" or keyPress (key) = "left" or keyPress (key) = "right" then
            count += 1
            endCount := 0
        end if
    else
        endCount += 1
    end if
end move


proc playerMove
    if count > 0 then
        Sprite.Animate (player.sprite, player.image (((count div 3) mod 4) + 1, player.dir), maxx div 2, maxy div 2, true)
    end if
    if endCount = 12 then
        count := 0
        Sprite.Animate (player.sprite, player.image (1, player.dir), maxx div 2, maxy div 2, true)
    end if
    Sprite.SetPosition (town.sprite,town.x,town.y,true)
    Sprite.Show (town.sprite)
end playerMove

%imports letter and other symbols
proc picInitialize
    var temp : string
    open : stream, "text.txt", get
    for i : 0 .. 40
        get : stream, temp
        text (i) := Pic.FileNew (temp)
    end for
        
    close : stream
    open : stream, "introPics.txt", get
    for i : 0..3
        get : stream, temp
        intro (i) := Pic.FileNew (temp)
    end for
        
    close : stream
end picInitialize

%gets controls from the text file
proc settingsConfig
    var temp : array 0..6 of int
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
        
    Sprite.SetPosition  (controlPics (0),542,465,true)
    Sprite.SetPosition  (controlPics (1),542,420,true)
    Sprite.SetPosition  (controlPics (2),542,375,true)
    Sprite.SetPosition  (controlPics (3),542,330,true)
    Sprite.SetPosition  (controlPics (4),542,285,true)
    Sprite.SetPosition  (controlPics (5),542,235,true)
    Sprite.SetPosition  (controlPics (6),542,192,true)
end settingsConfig

proc pressKey
    if hasch = true then
        getch (key)
        stop := true
    end if
end pressKey


picInitialize
settingsConfig
playerImport

%playerImport

player.dir := 1
town.image(1,1) := Pic.FileNew ("images/town 1.bmp")
town.sprite := Sprite.New (town.image(1,1))
town.x := maxx div 2
town.y := maxy div 2

Sprite.SetPosition (pauseMenuSprite,695, 420,true)
player.sprite := Sprite.New (player.image (1,1))
Sprite.SetPosition (player.sprite, maxx div 2,maxy div 2, true)
Sprite.Show (player.sprite)
Sprite.SetPosition (town.sprite,town.x,town.y,true)
Sprite.SetHeight (town.sprite, 0)


loop
    move
    playerMove
    exit when done = true
    delay (10)
end loop
