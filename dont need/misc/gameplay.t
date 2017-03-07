%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   WORKING ON                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Go to Game Game                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

setscreen ("graphics:800;600,nobuttonbar, nocursor, noecho")

type person : 
record
    name : string
    x : int
    y : int
    pic : array 1..3, 1..4 of int
    sprite : int
end record

type area :
record
    num : int
    x : int
    y : int
    pic : int
    sprite : int
end record

var background : int := Pic.FileNew ("images/world.bmp") %Main menu background
var menu : int := Pic.FileNew ("images/menu.bmp") %Main menu options picture
var menuWords : int := Pic.FileNew ("images/menu options.bmp") %Options for menu
var arrowPic : int := Pic.FileNew ("images/arrow.bmp") %picture of the arrow
var optionsMenu : int := Pic.FileNew ("images/options menu.bmp") %background for options menu
var logo : int := Pic.FileNew ("images/logo.bmp") %EDEN logo
var logoFlash : int := Pic.FileNew ("images/logo flash.bmp") %white, bigger, logo
var town : int := Pic.FileNew ("images/town 1.bmp") %First world area
var startPic : int := Pic.FileNew ("images/press start.bmp")
var area : int := Sprite.New (town)
var pressStart : int
var intro : array 0..3 of int
var xArrow, yArrow, arrow, temp, stream : int := 0 %xArrow, yArrow, arrow are position for and the arrow
var optionNum : string := "" %Used for confirmed options/ choises
var done, stop : boolean := false %used for ending the game
var key : string (1)
var text : array 0 .. 40 of int %array for text pictures
var controls : array 0..6,1..2 of int %controls
var controlPics : array 0..6 of int

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

proc move
    if hasch = true then
        getch (key)
        if keyPress (key) = "menu" then
            done := true
        end if
    end if
end move

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
%turns arrow picture into a sprite
arrow := Sprite.New (arrowPic)
pressStart := Sprite.New (startPic)
Sprite.SetPosition (pressStart,400,150,true)
Sprite.SetPosition (area,maxx div 2, maxy div 2, true)
%intro
drawfill (1,1,black,black)
loop
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
loop
    if hasch = true then
        getch (key)
    else
        exit
    end if
end loop
stop := false
temp := 0
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
loop
    if hasch = true then
        getch (key)
    else
        exit
    end if
end loop
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
Pic.DrawSpecial (menu, 248, 8, picMerge, picWipeUpperLeftToLowerRightNoBar, 250)
delay (500)
Pic.DrawSpecial (menuWords, 248, 8, picMerge, picWipeCentreToEdgeNoBar, 100)
delay (250)

%Sets the sprite position for the arrow and displays it
xArrow := 320
yArrow := 150
Sprite.SetPosition (arrow, xArrow, yArrow, false)
Sprite.Show (arrow)

loop
    if hasch = true then
        getch (key)
    else
        exit
    end if
end loop
%main menu loop
loop
    menuFuntion (3)
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
        cls
        exit
        %goes to option menu
    elsif optionNum = "1" then
        optionNum := ""
        temp := 0
        Pic.DrawSpecial (optionsMenu, 1, 1, picCopy, picGrowBottomToTop, 500)
        loop
            menuFuntion (8)
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
        loop
            if hasch = true then
                getch (key)
            else
                exit
            end if
        end loop
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
%game loop
if done = false then
    Sprite.Show (area)
end if
loop
    move
    exit when done = true
end loop
