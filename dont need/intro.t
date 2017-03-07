setscreen ("graphics:800;600,nobuttonbar, nocursor, noecho")



var font : int := Font.New ("serif:16")
var stream : int
var key : string (1)
var textArea : int := Pic.FileNew ("images/text area.bmp")
var temp : int := Pic.FileNew ("images/intro/background.bmp")
var temp2 : array 1..5 of int
var background :int := Sprite.New (temp)
var person :  int
var count : int := maxx-800
var ex : int



proc noInput
    loop
        if hasch = true then
            getch (key)
        else
            exit
        end if
    end loop
end noInput

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

proc say (subfolder : string, num : int)
    var text, temp, file : string := ""
    file := "text/"+ subfolder + intstr (num,0) + ".dat"
    open : stream, file, get
    loop
        exit when eof (stream)
        get : stream, temp
        temp += " "
        text += temp
    end loop
    close : stream
    for i : 1..length (text)
        Font.Draw (text(1..i), 50,175,font, black)
        View.Update
        delay (25)
    end for
        noInput
    confirm
    cls   
end say


temp2 (1) := Pic.FileNew ("images/intro/intro.bmp")
temp2 (2) := Pic.FileNew ("images/intro/intro2.bmp")
temp2 (3) := Pic.FileNew ("images/intro/intro.bmp")
temp2 (4) := Pic.FileNew ("images/intro/intro3.bmp")
temp2 (5) := Pic.FileNew ("images/intro/ex.bmp")
person:= Sprite.New (temp2 (1))
ex := Sprite.New (temp2 (5))
Sprite.SetPosition (person, maxx div 2, maxy div 2, true)
Sprite.SetPosition (background, count,1, false)
Sprite.SetPosition (ex,maxx div 2- 30, maxy div 2 + 75, true)
Sprite.Show (person)
Sprite.Show (background)
Sprite.SetHeight (person,5)
Sprite.SetHeight (background, 1)
delay (500)
Pic.Draw (textArea,1,1,picMerge)
say ("intro/",1)
say ("intro/",2)
for j : 1..10
    for i : 1..4
        count -= 10
        Sprite.Animate (person, temp2 (i), maxx div 2, maxy div 2, true)
        delay (125)
        Sprite.SetPosition (background,count,1, false)
        Sprite.Show (background)
    end for
end for
Sprite.Animate (person, temp2 (1), maxx div 2, maxy div 2, true)
Sprite.Show (ex)
Sprite.Free (background)
Sprite.Free (ex)
Sprite.Free (person)

