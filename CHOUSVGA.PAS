program svga;
uses crt,graph,imagen;
var
x,y,c:integer;

begin
IniciaSVGA256(0,'',c);
setcolor(15);

for y:=0 to getmaxy do
  for x:=0 to getmaxx do
    begin
      c:=x*y div (round(sin(x))*200-round(cos(y))*200+1);
      putpixel(x,y,c);
    end;
readln;
end.

