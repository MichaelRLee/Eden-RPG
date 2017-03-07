var a,b,c, root1, root2 : real

put "Input A"
get a
put "Input B"
get b
put "Input C"
get c
cls
if (b**2)+4*a*c > 0 then
root1 :=((-1)*b+sqrt ((b**2)+4*a*c))/2*a
root2 :=((-1)*b-sqrt ((b**2)+4*a*c))/2*a
put "The roots are :",root1," and ", root2
else
put "ERROR"
end if