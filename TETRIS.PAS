unit Tetris;



interface



uses Crt,dos,Graph,Imagen,Pcx,Piezas,Teclas;




procedure Sombras;
procedure PonerDatos(eMarcador:tMarcador; where:word);
procedure PonerDatos2(eMarcador1,eMarcador2:tMarcador; where:word);
procedure DibujaCuadro(iX,iY,iColor:integer; yPlayer:byte; where:word);
procedure DibujaFondo(iX,iY,iColor:integer; where:word);
procedure DibujaPantalla(eMarcador:tMarcador; Pantalla:tPantalla; where:word);
procedure LimpiarPantalla;
procedure LimpiarPantallas;
procedure CrearListaPiezas(var ListaPiezas:tListaPiezas; var G:tGrabar);
procedure BorrarListaPiezas(var ListaPiezas:tListaPiezas);
function Velocidad(iSpeed:integer):integer;
procedure IniciaPantalla(var Pantalla:tPantalla);
procedure DibujaNext(var eMarcador:tMarcador; where:word; var G:tGrabar);
procedure DibujaNext2(var eMarcador1,eMarcador2:tMarcador; where:word; var G:tGrabar);
procedure Marcar6Linea(iLinea:integer; eMarcador:tMarcador; Pantalla:tPantalla; where:word);
procedure Marcar7Linea(iLinea:integer; eMarcador:tMarcador; Pantalla:tPantalla; where:word);
procedure MarcarPunto(var eMarcador:tMarcador; x1,y1,estado:integer; where:word);
procedure BorrarLinea(iLinea:integer; var Pantalla:tPantalla);
function VerLineaAbajo(Pantalla:tPantalla):byte;
procedure CrearLinea(yX:byte; var Pantalla:tPantalla);
procedure CrearNuevaPieza(var eMarcador:tMarcador; var G:tGrabar);
procedure PonerAltura(var eMarcador:tMarcador; var Pantalla:tPantalla);
procedure IniciaEstad;
procedure PonerEstad;
function VerWinDeath(yWin1,yWin2:byte; var yWinDeath:byte):boolean;
procedure VerGanadorDeath(sNombre:string; var bEnter:boolean);
procedure WinDeath(yWinDeath:byte);
procedure Presentacion;
{procedure Opciones(c1,c2:integer);}
function Menu:boolean;
procedure mRecords;
procedure mOpciones;
function VerRecords:boolean; {dice si se pulso la r}
function PedirNombre(Titulo:string):string;
procedure PonerRecord(lPuntos:tPuntos; wLineas:word; sTitulo:string);



implementation



procedure Sombras;
var
  Paleta:tPaleta;
begin
GetPaleta(Paleta);
PonSombras(0,0,0,iSombras);
ClsWhere(0,SegA000);
QuitaSombras(Paleta,iSombras);
end;





procedure PonerDatos(eMarcador:tMarcador; where:word);
var
  sPuntos,sLineas,sSpeed,s1:string;

begin
with eMarcador do
  begin
    WriteColorWhere(iX+19,iY-15,-1,Nombre,Color81,where);

    WriteColorWhere(iX+120,iY+15,-1,'Puntos',Color81,where);
    WriteColorWhere(iX+120,iY+30,-1,'Lineas',Color81,where);
    WriteColorWhere(iX+120,iY+45,-1,'Nivel',Color81,where);

    str(lPuntos,sPuntos);
    str(wLineas,sLineas);
    str(iSpeed,sSpeed);

    WriteColorWhere(iX+120+64,iY+15,-1,sPuntos,Color81,where);
    WriteColorWhere(iX+120+64,iY+30,-1,sLineas,Color81,where);
    WriteColorWhere(iX+120+64,iY+45,-1,sSpeed,Color81,where);
  end;

if bDepurar then
  begin
    str(MemAvail,s1);
    WriteWhere(1,190,14,-1,s1,where);
    str(Grabar^.Num,s1);
    WriteWhere(1,1,15,-1,s1,where);
    if Grabar^.Num>0 then
      str(Grabar^.Eventos[Grabar^.Num-1].tpo,s1);
    WriteWhere(1,10,15,-1,s1,where);
  end;

end; (*procedure PonerDatos*)





procedure PonerDatos2(eMarcador1,eMarcador2:tMarcador; where:word);
var
  sPuntos,sLineas,sSpeed,s1,s2:string;

begin
with eMarcador2 do
  begin
    WriteColorWhere(iX+15,iY-15,-1,Nombre,Color82,where);

    WriteColorWhere(120,iY+10,-1,'P',Color82,where);
    WriteColorWhere(120,iY+25,-1,'L',Color82,where);
    WriteColorWhere(120,iY+40,-1,'N',Color82,where);

    str(lPuntos,sPuntos);
    str(wLineas,sLineas);
    str(iSpeed,sSpeed);

    WriteColorWhere(136,iY+10,-1,sPuntos,Color82,where);
    WriteColorWhere(136,iY+40,-1,sSpeed,Color82,where);
    if bDeath and (wLineas<25) then
      WriteColorWhere(136,iY+25,-1,sLineas,Color83,where)
    else
      WriteColorWhere(136,iY+25,-1,sLineas,Color82,where);
  end;

with eMarcador1 do
  begin
    WriteColorWhere(iX+15,iY-15,-1,Nombre,Color81,where);

    WriteColorWhere(136,iY+95,-1,'P',Color81,where);
    WriteColorWhere(136,iY+110,-1,'L',Color81,where);
    WriteColorWhere(136,iY+125,-1,'N',Color81,where);

    str(lPuntos,sPuntos);
    str(wLineas,sLineas);
    str(iSpeed,sSpeed);

    WriteColorWhere(152,iY+95,-1,sPuntos,Color81,where);
    WriteColorWhere(152,iY+125,-1,sSpeed,Color81,where);
    if bDeath and (wLineas<25) then
      WriteColorWhere(152,iY+110,-1,sLineas,Color83,where)
    else
      WriteColorWhere(152,iY+110,-1,sLineas,Color81,where);
  end;

if bDeath and not bRepet then
  begin
    str(yWin2,s2);
    str(yWin1,s1);
    WriteColorWhere(141,0,-1,s2,Color82,where);
    WriteWhere(156,0,15,-1,'-',where);
    WriteColorWhere(172,0,-1,s1,Color81,where);
  end;

if bDepurar then
  begin
    str(MemAvail,s1);
    WriteWhere(1,190,14,-1,s1,where);
    str(Grabar^.Num,s1);
    WriteWhere(120,1,15,-1,s1,where);
    if Grabar^.Num>0 then
      str(Grabar^.Eventos[Grabar^.Num-1].tpo,s1);
    WriteWhere(120,10,15,-1,s1,where);

    {str(Estad.Jug[1].DesHaz,s1);
    WriteWhere(100,190,13,-1,s1,where);
    str(Estad.Jug[2].DesHaz,s1);
    WriteWhere(160,190,13,-1,s1,where);}
  end;

end; (*procedure PonerDatos2*)





procedure DibujaCuadro(iX,iY,iColor:integer; yPlayer:byte; where:word);
var
  iI,iJ:integer;
begin

if yPlayer<>2
then {PLAYER1}
  case iColor of
    0:PutImagenXYWhere(0,0,Pieza1,wScreen2); {velocidad cte}
    1:PutImagenXYWhere(iX,iY,Pieza1,where);
    2:PutImagenXYWhere(iX,iY,Pieza2,where);
    3:PutImagenXYWhere(iX,iY,Pieza3,where);
    4:PutImagenXYWhere(iX,iY,Pieza4,where);
    5:PutImagenXYWhere(iX,iY,Pieza5,where);
    6:PutImagenXYWhere(iX,iY,Pieza6,where);
    7:PutImagenXYWhere(iX,iY,Pieza7,where);
    8:PutImagenXYWhere(iX,iY,Pieza8,where); {mandar}
    10:PutImagenXYWhere(iX,iY,Pieza10,where); {receptaculo}
    11:PutImagenXYWhere(iX,iY,Pieza22,where); {hexa y octo}
    12:PutImagenXYWhere(iX,iY,Pieza23,where); {verde oscuro}
    13:PutImagenXYWhere(iX,iY,Pieza24,where); {blancos}
    20:PutImagenXYWhere(iX,iY,Pieza20,where); {circulos}
    else
      {for iI:=iX to iX+8 do
        for iJ:=iY to iY+8 do
          mem[where:(iJ)*320+iI]:=iColor;}
  end (*case*)
else {PLAYER2}
  case iColor of
    0:PutImagenXYWhere(0,0,Pieza11,wScreen2); {velocidad cte}
    1:PutImagenXYWhere(iX,iY,Pieza11,where);
    2:PutImagenXYWhere(iX,iY,Pieza12,where);
    3:PutImagenXYWhere(iX,iY,Pieza13,where);
    4:PutImagenXYWhere(iX,iY,Pieza14,where);
    5:PutImagenXYWhere(iX,iY,Pieza15,where);
    6:PutImagenXYWhere(iX,iY,Pieza16,where);
    7:PutImagenXYWhere(iX,iY,Pieza17,where);
    8:PutImagenXYWhere(iX,iY,Pieza8,where);
    10:PutImagenXYWhere(iX,iY,Pieza10,where);
    11:PutImagenXYWhere(iX,iY,Pieza22,where);
    12:PutImagenXYWhere(iX,iY,Pieza23,where);
    13:PutImagenXYWhere(iX,iY,Pieza24,where);
    20:PutImagenXYWhere(iX,iY,Pieza21,where);
    else
      {for iI:=iX to iX+8 do
        for iJ:=iY to iY+8 do
          mem[where:(iJ)*320+iI]:=iColor;}
  end; (*case*)

end; (*procedure DibujaCuadro*)





procedure DibujaFondo(iX,iY,iColor:integer; where:word);
var
  iI:integer;
begin

for iI:=0 to 18 do
  begin
    DibujaCuadro(iX,iY+iI*9,iColor,0,where);
  end;

for iI:=0 to 18 do
  begin
    DibujaCuadro(iX+11*9,iY+iI*9,iColor,0,where);
  end;

for iI:=1 to 10 do
  begin
    DibujaCuadro(iX+iI*9,iY+18*9,iColor,0,where);
  end;

end; (*procedure DibujaFondo*)





procedure DibujaPantalla(eMarcador:tMarcador; Pantalla:tPantalla; where:word);
var
  iI,iJ:integer;
begin

with eMarcador do
  if bGameOver and not bdeath and not bRepet then
    for iI:=1 to 10 do
      for iJ:=0 to 17 do
        if Nombre=NombreJug1 then
          DibujaCuadro(iX+iI*9,iY+iJ*9,20,1,where)
        else
          DibujaCuadro(iX+iI*9,iY+iJ*9,20,2,where)
  else
    for iI:=1 to 10 do
      for iJ:=0 to 17 do
        if Nombre=NombreJug1 then
          DibujaCuadro(iX+iI*9,iY+iJ*9,Pantalla[iI,iJ],1,where)
        else
          DibujaCuadro(iX+iI*9,iY+iJ*9,Pantalla[iI,iJ],2,where);

end; (*procedure DibujaPantalla*)





procedure LimpiarPantallas;
var
  x,y:integer;
begin
for y:=-7 to -1 do
  for x:=1 to 10 do
    begin
      Pantalla1[x,y]:=0;
      Pantalla2[x,y]:=0;
    end;
end;





procedure LimpiarPantalla;
var
  x,y:integer;
begin
for y:=-7 to -1 do
  for x:=1 to 10 do
    Pantalla1[x,y]:=0;
end;





function DatoLista(pPosLista,ListaPiezas:tListaPiezas):byte;
begin
if pPosLista=nil then
  DatoLista:=0
else
  DatoLista:=pPosLista^.Pieza;
end; (*function DatoLista*)





procedure NuevoDato(pPosLista:tListaPiezas; var ListaPiezas:tListaPiezas;
                    var G:tGrabar);
var
  pActual,pNuevo:tListaPiezas;
  pza:byte;

begin

pActual:=pPosLista;
if pActual=nil then pActual:=ListaPiezas;

while pActual^.siguiente<>nil do
  begin
    pActual:=pActual^.siguiente; {pActual->ultimo}

    closegraph;
    OldKeyInt;
    writeln('Error en NuevoDato');
    readln;
    halt;
  end;

new(pNuevo);
pNuevo^.siguiente:=nil;
pza:=CreaPieza;
pNuevo^.Pieza:=pza;
pActual^.siguiente:=pNuevo;

with G do
  if NumF<MaxFichas then
    begin
      Fichas[NumF]:=pza;
      NumF:=NumF+1;
      if NumF>MaxFichas then
        NumF:=MaxFichas;
    end;

end; (*procedure NuevoDato*)





procedure CrearListaPiezas(var ListaPiezas:tListaPiezas; var G:tGrabar);
var
  pza:byte;

begin
New(ListaPiezas);
ListaPiezas^.siguiente:=nil;
pza:=CreaPieza;
ListaPiezas^.Pieza:=pza;

with G do
  if NumF<MaxFichas then
    begin
      Fichas[NumF]:=pza;
      NumF:=NumF+1;
      if NumF>MaxFichas then
        NumF:=MaxFichas;
    end;

NuevoDato(ListaPiezas,ListaPiezas,G);

end; (*procedure CrearListaPiezas*)





procedure BorrarListaPiezas(var ListaPiezas:tListaPiezas);
var
  pActual,pSig:tListaPiezas;

begin
pActual:=ListaPiezas;
while pActual<>nil do
  begin
    pSig:=pActual^.Siguiente;
    Dispose(pActual);
    pActual:=pSig;
  end;
end; (*procedure BorrarListaPiezas*)





function Velocidad(iSpeed:integer):integer;
var
  Vel,v:real;
begin
case iSpeed of
  0:Vel:=30;  {70}
  1:Vel:=27;  {60}
  2:Vel:=24;  {51}
  3:Vel:=22;  {43}
  4:Vel:=20;  {36}
  5:Vel:=18;  {29}
  6:Vel:=16;  {23}
  7:Vel:=14;  {18}
  8:Vel:=13;  {15}
  9:Vel:=12;  {13}
  10:Vel:=11;  {11}
  11:Vel:=10;  {10}
  12:Vel:=9;  {9}
  13:Vel:=8;  {8}
  14:Vel:=7;  {7}
  15:Vel:=6;  {6}
  16:Vel:=5;  {5}
  17:Vel:=4;  {4}
  18:Vel:=3;  {3}
  19:Vel:=2;  {2}
  else Vel:=2;
end; (*case*)

v:=Vel*CPU;
if v<1 then v:=1;
if v>125 then v:=125;
Velocidad:=round(v);
end; (*function Velocidad*)





procedure IniciaPantalla(var Pantalla:tPantalla);
var
  iI,iJ:integer;
begin

for iI:=-1 to 12 do
  for iJ:=-7 to 19 do
    Pantalla[iI,iJ]:=255;

for iI:=1 to 10 do
  for iJ:=-7 to 17 do
    Pantalla[iI,iJ]:=0;

end; (*procedure IniciaPantalla*)





procedure DibujaNext(var eMarcador:tMarcador; where:word; var G:tGrabar);
var
  Pant:tPantalla;
  iI,iJ:integer;
  ePiezaNext:tPieza;

begin
if not eMarcador.bGameOver
then with eMarcador do
  begin
    if DatoLista(pPosLista^.siguiente,ListaPiezas)=0 then
      NuevoDato(pPosLista,ListaPiezas,G);
    ePiezaNext.tipo:=DatoLista(pPosLista,ListaPiezas);
    ePiezaNext.rotate:=1;
    DatosPieza(ePiezaNext,iI);

    IniciaPantalla(Pant);
    DibujaPieza(ePiezaNext,1,1,Pant);

    for iI:=1 to 4 do
      for iJ:=1 to 2 do
        if Pant[iI,iJ]<>0
        then DibujaCuadro(iX+125+(iI-1)*9,iY+75+(iJ-1)*9,Pant[iI,iJ],1,where);
  end;

end; (*procedure DibujaNext*)





procedure DibujaNext2(var eMarcador1,eMarcador2:tMarcador; where:word;
                      var G:tGrabar);
var
  Pant:tPantalla;
  iI,iJ:integer;
  ePiezaNext:tPieza;

begin
if not eMarcador2.bGameOver
then with eMarcador2 do
  begin
    if DatoLista(pPosLista^.siguiente,ListaPiezas)=0 then
      NuevoDato(pPosLista,ListaPiezas,G);
    ePiezaNext.tipo:=DatoLista(pPosLista,ListaPiezas);
    ePiezaNext.rotate:=1;
    DatosPieza(ePiezaNext,iI);

    IniciaPantalla(Pant);
    DibujaPieza(ePiezaNext,1,1,Pant);

    for iI:=1 to 4 do
      for iJ:=1 to 2 do
        if Pant[iI,iJ]<>0
        then DibujaCuadro(iX+125+(iI-1)*9,iY+60+(iJ-1)*9,Pant[iI,iJ],2,where);
  end;

if not eMarcador1.bGameOver
then with eMarcador1 do
  begin
    if DatoLista(pPosLista^.siguiente,ListaPiezas)=0 then
      NuevoDato(pPosLista,ListaPiezas,G);
    ePiezaNext.tipo:=DatoLista(pPosLista,ListaPiezas);
    ePiezaNext.rotate:=1;
    DatosPieza(ePiezaNext,iI);

    IniciaPantalla(Pant);
    DibujaPieza(ePiezaNext,1,1,Pant);

    for iI:=1 to 4 do
      for iJ:=1 to 2 do
        if Pant[iI,iJ]<>0
        then DibujaCuadro(eMarcador2.iX+158+(iI-1)*9,iY+145+(iJ-1)*9,Pant[iI,iJ],1,where);
  end;

end; (*procedure DibujaNext2*)





procedure Marcar6Linea(iLinea:integer; eMarcador:tMarcador; Pantalla:tPantalla; where:word);
var
  iI,iJ:integer;
  yTam:integer;

begin
yTam:=9;

with eMarcador do
  for iI:=1 to 10 do
    if Nombre=NombreJug1 then
      DibujaCuadro(iX+iI*yTam,iY+iLinea*yTam,Pantalla[iI,iLinea],1,where)
    else
      DibujaCuadro(iX+iI*yTam,iY+iLinea*yTam,Pantalla[iI,iLinea],2,where);
end; (*procedure Marcar6Linea*)





procedure Marcar7Linea(iLinea:integer; eMarcador:tMarcador; Pantalla:tPantalla; where:word);
var
  iI,iJ:integer;
  yTam:integer;

begin
yTam:=9;

with eMarcador do
  for iI:=1 to 10 do
    for iJ:=0 to 8 do
      LineWhere(iX+iI*yTam,iY+iLinea*yTam+iJ,iX+iI*yTam+8,iY+iLinea*yTam+iJ,0,where);
end; (*procedure Marcar6Linea*)





procedure MarcarPunto(var eMarcador:tMarcador; x1,y1,estado:integer; where:word);
var
  i,x,y,ancho:integer;
begin
with eMarcador do
  begin
    x:=iX+x1*9;
    y:=iY+y1*9;
  end;

if estado>=9 then
  CuadradoWhere(x,y,x+8,y+8,0,where)
else
  begin
    ancho:=8;
    for i:=1 to estado do
      case i of
        1,3,5,7: begin
             LineWhere(x,y,x,y+ancho,0,where);
             LineWhere(x,y+ancho,x+ancho,y+ancho,0,where);
           end;
        2,4,6,8: begin
             LineWhere(x,y,x+ancho,y,0,where);
             LineWhere(x+ancho,y,x+ancho,y+ancho,0,where);
             x:=x+1;
             y:=y+1;
             ancho:=ancho-2;
           end;
      end;
  end;
end;





procedure BorrarLinea(iLinea:integer; var Pantalla:tPantalla);
var
  iI,iJ:integer;

begin
for iJ:=iLinea downto 1 do
  for iI:=1 to 10 do
    Pantalla[iI,iJ]:=Pantalla[iI,iJ-1];
for iI:=1 to 10 do
  Pantalla[iI,0]:=0;
end; (*procedure BorrarLinea*)





function VerLineaAbajo(Pantalla:tPantalla):byte;
{mira linea de abajo y devuelve un cuadrado en negro}
type
  tNegros=array[1..10] of byte;
var
  iI,iX,iY:integer;
  ayNegros:tNegros; {almacena la x de las casillas negras (0-10)}


  function EstaLibre(Negros:tNegros; X:integer):boolean;
  var
    i:integer;
    Libre:boolean;
  begin
    Libre:=false;
    for i:=1 to 10 do
      if Negros[i]=X then
        Libre:=true;
    EstaLibre:=Libre;
  end;


begin

for iX:=1 to 10 do
  ayNegros[iX]:=0;

iI:=0; {numero de negros en la linea 17}
iY:=17;
while (iI=0) and (iY>=0) do
  begin
    for iX:=1 to 10 do
      if Pantalla[iX,iY]=0 then
        begin
          iI:=iI+1;
          ayNegros[iI]:=iX;
        end;
    iY:=iY-1;
  end;

if iI=1 then
  VerLineaAbajo:=ayNegros[1]
else
  if iI=0 then
    VerLineaAbajo:=5
  else
    begin
      if EstaLibre(ayNegros,5) then
        VerLineaAbajo:=5
      else
      if EstaLibre(ayNegros,6) then
        VerLineaAbajo:=6
      else
      if EstaLibre(ayNegros,4) then
        VerLineaAbajo:=4
      else
      if EstaLibre(ayNegros,7) then
        VerLineaAbajo:=7
      else
      if EstaLibre(ayNegros,3) then
        VerLineaAbajo:=3
      else
      if EstaLibre(ayNegros,8) then
        VerLineaAbajo:=8
      else
      if EstaLibre(ayNegros,2) then
        VerLineaAbajo:=2
      else
      if EstaLibre(ayNegros,9) then
        VerLineaAbajo:=9
      else
      if EstaLibre(ayNegros,1) then
        VerLineaAbajo:=1
      else
      if EstaLibre(ayNegros,10) then
        VerLineaAbajo:=10
      else
        VerLineaAbajo:=5;
    end;

end; (*function VerLineaAbajo*)





procedure CrearLinea(yX:byte; var Pantalla:tPantalla);
var
  iI,iJ:integer;

begin

for iJ:=1 to 16 do
  for iI:=1 to 10 do
    Pantalla[iI,iJ]:=Pantalla[iI,iJ+1];

for iI:=1 to 10 do
  if iI<>yX then
    Pantalla[iI,17]:=8
  else
    Pantalla[iI,17]:=0;

end; (*procedure CrearLinea*)





procedure CrearNuevaPieza(var eMarcador:tMarcador; var G:tGrabar);
begin
with eMarcador do
  if not bGameOver then
    begin
      bPausaPpio:=true;
      if DatoLista(pPosLista^.siguiente,ListaPiezas)=0 then
        NuevoDato(pPosLista,ListaPiezas,G);
      ePieza.tipo:=DatoLista(pPosLista,ListaPiezas);
      ePieza.rotate:=1;
      DatosPieza(ePieza,iPiezaX);
      iPiezaY:=0; {Fichas mas altas}
      pPosLista:=pPosLista^.siguiente;
    end
end;





procedure PonerAltura(var eMarcador:tMarcador; var Pantalla:tPantalla);
type
  tHueco=array[1..9] of integer;
var
  x,y,i,j,k,r:integer;
  h:tHueco;
  b:boolean;

begin

  for y:=17 downto 18-eMarcador.Altura do
    begin
      for i:=1 to 7 do
        h[i]:=-1;
      {i:=random(2)+8;}
      i:=1; {Numero de ptos aleat}
      for j:=1 to i do
        begin
          repeat
            r:=random(10)+1;
            b:=true;
            for k:=1 to j-1 do
              if h[k]=r then
                b:=false;
          until b;
          h[j]:=r;
        end;
      for j:=1 to i do
        Pantalla[h[j],y]:=random(7)+1;
    end;
end;





procedure IniciaEstad;
var
  j:integer;

begin
  with Estad do
    for j:=1 to 2 do
      begin
        Tot[j].Mandar:=0;
        Tot[j].Mejor:=0;
        Tot[j].DesHaz:=0;
        Tot[j].MejorDes:=0;

        Jug[j].Mandar:=0;
        Jug[j].Mejor:=0;
        Jug[j].DesHaz:=0;
        Jug[j].MejorDes:=0;
      end;
end;





procedure PonerEstad;
var
  s:string;
  c,c2,j,iY:integer;

begin
with Estad do
  begin
    iY:=140;
    c:=132;
    c2:=99;
    WriteColorWhere(50,iY-15,-1,eMarcador2.Nombre,Color82,SegA000);
    WriteColorWhere(195,iY-15,-1,eMarcador1.Nombre,Color81,SegA000);

    str(Jug[2].Mandar,s);
    WriteWhere(20,iY,c,-1,'Mandar '+s+' lineas',SegA000);
    str(Jug[1].Mandar,s);
    WriteWhere(165,iY,c2,-1,'Mandar '+s+' lineas',SegA000);
    inc(iY,10);

    str(Jug[2].Mejor,s);
    WriteWhere(20,iY,c,-1,'Mejor '+s+' lineas',SegA000);
    str(Jug[1].Mejor,s);
    WriteWhere(165,iY,c2,-1,'Mejor '+s+' lineas',SegA000);
    inc(iY,20);

    str(Jug[2].DesHaz,s);
    WriteWhere(20,iY,c,-1,'Deshacer '+s+' ptos',SegA000);
    str(Jug[1].DesHaz,s);
    WriteWhere(165,iY,c2,-1,'Deshacer '+s+' ptos',SegA000);
    inc(iY,10);

    str(Jug[2].MejorDes,s);
    WriteWhere(20,iY,c,-1,'Mejor '+s+' ptos',SegA000);
    str(Jug[1].MejorDes,s);
    WriteWhere(165,iY,c2,-1,'Mejor '+s+' ptos',SegA000);

    for j:=1 to 2 do
      begin {acumular totales}
        inc(Tot[j].Mandar,Jug[j].Mandar);
        if Tot[j].Mejor<Jug[j].Mejor then
          Tot[j].Mejor:=Jug[j].Mejor;
        inc(Tot[j].DesHaz,Jug[j].DesHaz);
        if Tot[j].MejorDes<Jug[j].MejorDes then
          Tot[j].MejorDes:=Jug[j].MejorDes;

        Jug[j].Mandar:=0;
        Jug[j].Mejor:=0;
        Jug[j].DesHaz:=0;
        Jug[j].MejorDes:=0;
      end;
  end;
end;





procedure LaDeath(iY:integer; yWin,yWinDeath:byte; sPlayer:string);
{ver marcador}
var
  iA,iI:integer;
  str1:string;

begin
WriteColorWhere(70,iY-15,-1,'Victorias',Color83,SegA000);
if sPlayer=NombreJug1 then
  WriteColorWhere(70+10*8,iY-15,-1,sPlayer,Color81,SegA000)
else
  WriteColorWhere(70+10*8,iY-15,-1,sPlayer,Color82,SegA000);

iA:=80;
for iI:=0 to yWinDeath do
  begin
    Cuadrado(iA,iY,iA+25,iY+25,7);
    iA:=iA+30;
  end;

iA:=80;
SetColor(0);
for iI:=0 to yWinDeath do
  begin
    str(iI,str1);
    WriteWhere(iA+9,iY+10,0,-1,str1,SegA000);
    iA:=iA+30;
  end;

iA:=80;
SetColor(15);
rectangle(iA+yWin*30,iY,iA+25+yWin*30,iY+25);
end; (*procedure LaDeath*)





function VerWinDeath(yWin1,yWin2:byte; var yWinDeath:byte):boolean;
var
  salir:boolean;

begin
salir:=false;
ClearWasDownArray;

GetPaleta(Paleta);
PonSombras(0,0,0,iSombras);

ClsWhere(yFondo,SegA000);

LaDeath(25,yWin1,yWinDeath,eMarcador1.Nombre); {50,130}
LaDeath(80,yWin2,yWinDeath,eMarcador2.Nombre);

PonerEstad;

QuitaSombras(Paleta,iSombras);

repeat
until TeclaPulsada;
if WasDown[escscan] then
  salir:=true;
repeat
until not TeclaPulsada;

Sombras;

if salir then
  VerWinDeath:=false
else
  VerWinDeath:=true;
end; (*procedure VerWinDeath*)





procedure VerGanadorDeath(sNombre:string; var bEnter:boolean);
var
  PaletaPcx:tPaleta;
  s:string;
  c,c2,iY:integer;

begin
GetPaleta(Paleta);
PonSombras(0,0,0,iSombras);

repeat
until not TeclaPulsada;


LoadPcx('rtetris.pcx','',false,iError);
GetPalPcx('rtetris.pcx','',PaletaPcx,iError);

SetPal(PaletaPcx,255,63,63,63);

WriteWhere(110,25,255,-1,'GANADOR!!!',SegA000);
WriteWhere(118,50,255,-1,sNombre,SegA000);

if bDeath then
  with Estad do
    begin
      iY:=140;
      c:=84;
      c2:=85; {‡‡‡}
      WriteWhere(50,iY-15,c,-1,eMarcador2.Nombre,SegA000);
      WriteWhere(195,iY-15,c2,-1,eMarcador1.Nombre,SegA000);

      str(Tot[2].Mandar,s);
      WriteWhere(20,iY,c,-1,'Mandar '+s+' lineas',SegA000);
      str(Tot[1].Mandar,s);
      WriteWhere(165,iY,c2,-1,'Mandar '+s+' lineas',SegA000);
      inc(iY,10);

      str(Tot[2].Mejor,s);
      WriteWhere(20,iY,c,-1,'Mejor '+s+' lineas',SegA000);
      str(Tot[1].Mejor,s);
      WriteWhere(165,iY,c2,-1,'Mejor '+s+' lineas',SegA000);
      inc(iY,20);

      str(Tot[2].DesHaz,s);
      WriteWhere(20,iY,c,-1,'Deshacer '+s+' ptos',SegA000);
      str(Tot[1].DesHaz,s);
      WriteWhere(165,iY,c2,-1,'Deshacer '+s+' ptos',SegA000);
      inc(iY,10);

      str(Tot[2].MejorDes,s);
      WriteWhere(20,iY,c,-1,'Mejor '+s+' ptos',SegA000);
      str(Tot[1].MejorDes,s);
      WriteWhere(165,iY,c2,-1,'Mejor '+s+' ptos',SegA000);
    end;

QuitaSombras(PaletaPcx,iSombras);

repeat
until TeclaPulsada;

if KeyDown[EntScan] then
  bEnter:=true
else
  bEnter:=false;

PonSombras(0,0,0,iSombras);
ClsWhere(0,SegA000);
QuitaSombras(Paleta,iSombras);

end; (*procedure VerGanadorDeath*)





procedure WinDeath(yWinDeath:byte);
var
  iA,iY,iI:integer;
  str1:string;

begin
iY:=80;
WriteColorWhere(75,iY-30,-1,'Victorias para Ganar',Color83,wScreen1);

SetColor(14);
iA:=80;
for iI:=1 to 5 do
  begin
    CuadradoWhere(iA,iY,iA+25,iY+25,7,wScreen1);
    iA:=iA+30;
  end;

iA:=80;
for iI:=1 to 5 do
  begin
    str(iI,str1);
    WriteWhere(iA+8,iY+10,0,-1,str1,wScreen1);
    iA:=iA+30;
  end;

iA:=80;
RectangleWhere(iA+(yWinDeath-1)*30,iY,iA-5+yWinDeath*30,iY+25,15,wScreen1);
end; (*procedure WinDeath*)





procedure Presentacion;
type
  pChar=array[char] of array[0..15] of byte;
var
  p:^pChar;
  Car:char;
  i,j,b:integer;
  iCar,iCarIni:integer;
  iX,iY:integer;
  x,y:integer;
  regs:registers;
  sTexto:string;

begin
regs.ax:=$1130;
regs.bh:=6;
intr($10,regs); {captura la fuente de texto}
p:=ptr(regs.es,regs.bp);

sTexto:=sTextoInicio;
iY:=28;
iX:=0;
iCarIni:=0;

repeat
  x:=-iX*9;
  iCar:=iCarIni;
  while iCar<=iCarIni+5 do
    begin
      Car:=sTexto[iCar mod length(sTexto)+1];
      j:=0;
      while j<=15 do
        begin
          b:=p^[car][j];
          i:=7;
          while i>=0 do
            begin
              if odd(b) and (x+i*9>=0) and (x+i*9<=315-9)
              then
                begin
                  PutImagenXYWhere(x+i*9,iY+j*9,Pieza10,wScreen1);
                end;
              b:=b shr 1;
              dec(i);
            end;
          inc(j);
        end;
      inc(x,8*9);
      inc(iCar);
    end;

  WaitRetrace;
  flip(wScreen1,SegA000);
  ClsWhere(0,wScreen1);
  Esperar(75); {50}

  inc(iX);
  if iX>7 then
    begin
      iX:=0;
      inc(iCarIni);
      if iCarIni>=length(sTextoInicio)
      then iCarIni:=0;
    end;

until KeyPressed;

end; (*procedure Presentacion*)





procedure Players(iPlayers:integer);
var
  iA,iY,iI:integer;
  str1:string;

begin
iY:=80;
WriteColorWhere(55,iY-30,-1,'Escoger Numero Jugadores',Color83,wScreen1);

iA:=80;
for iI:=1 to 3 do
  begin
    CuadradoWhere(iA,iY,iA+45,iY+25,7,wScreen1);
    iA:=iA+50;
  end;

iA:=80;
for iI:=1 to 2 do
  begin
    str(iI,str1);
    WriteWhere(iA+18,iY+10,0,-1,str1,wScreen1);
    iA:=iA+50;
  end;
WriteWhere(iA+10,iY+10,0,-1,'Opc',wScreen1);

RectangleWhere(30+iPlayers*50,iY,75+iPlayers*50,iY+25,15,wScreen1);
end; (*procedure Players*)





procedure Death(bDeath:boolean);
var
  iA,iY:integer;

begin
iY:=80;
WriteColorWhere(75,iY-30,-1,'Escoger Modo de juego',Color83,wScreen1);

iA:=95;
CuadradoWhere(iA,iY,iA+59,iY+25,7,wScreen1);
WriteWhere(iA+7,iY+10,0,-1,'Normal',wScreen1);
iA:=165;
CuadradoWhere(iA,iY,iA+59,iY+25,7,wScreen1);
WriteWhere(iA+8,iY+10,0,-1,'Death',wScreen1);

if bDeath then
  RectangleWhere(165,iY,165+59,iY+25,15,wScreen1)
else
  RectangleWhere(95,iY,95+59,iY+25,15,wScreen1);
end; (*procedure Death*)





procedure Opciones(c1,c2:integer);
var
  s,cad:string;
  i,col:byte;

begin
WriteColorWhere(34,10,-1,NombreJug2,Color82,wScreen1); {20,180}
WriteColorWhere(194,10,-1,NombreJug1,Color81,wScreen1);

{0=Aleat,1=Normal,2=Muy facil,3=Facil,4=Moderado,5=Dificil,6=Muy Dif,
 7=Imposible,8=Clasico,9=Pocas fic,10=Bastantes,11=Muchas,12=Todas,
 13=Cuadrados,14=Largas,15=Largas Mazo,16=Eles,17=Piramides}
case TipoFichas of
  0:cad:='Aleatorio';
  1:cad:='Muy facil';
  2:cad:='Facil';
  3:cad:='Moderado';
  4:cad:='Normal';
  5:cad:='Dificil';
  6:cad:='Muy dificil';
  7:cad:='Imposible';
  8:cad:='Clasico';
  9:cad:='Pocas fichas';
  10:cad:='Bastantes';
  11:cad:='Muchas fichas';
  12:cad:='Todas por igual';
  13:cad:='Largas';
  14:cad:='Largas Mazo';
  15:cad:='Cuadrados';
  16:cad:='Eles';
  17:cad:='Piramides';
end;

if (c2=0) or (c1=0) then
  begin
    WriteColorWhere(70,30,-1,'Fichas',Color83,wScreen1);
    WriteColorWhere(130,30,-1,cad,Color83,wScreen1);
  end
else
  begin
    WriteWhere(70,30,15,-1,'Fichas',wScreen1);
    WriteWhere(130,30,15,-1,cad,wScreen1);
  end;

str(eMarcador2.wLineas,cad);
if c2=1 then
  begin
    WriteColorWhere(20,50,-1,'Lineas',Color83,wScreen1);
    WriteColorWhere(100,50,-1,cad,Color83,wScreen1);
  end
else
  begin
    WriteWhere(20,50,15,-1,'Lineas',wScreen1);
    WriteWhere(100,50,15,-1,cad,wScreen1);
  end;
str(eMarcador1.wLineas,cad);
if c1=1 then
  begin
    WriteColorWhere(180,50,-1,'Lineas',Color83,wScreen1);
    WriteColorWhere(260,50,-1,cad,Color83,wScreen1);
  end
else
  begin
    WriteWhere(180,50,15,-1,'Lineas',wScreen1);
    WriteWhere(260,50,15,-1,cad,wScreen1);
  end;

str(eMarcador2.iSpeed,cad);
if c2=2 then
  begin
    WriteColorWhere(20,70,-1,'Nivel',Color83,wScreen1);
    WriteColorWhere(100,70,-1,cad,Color83,wScreen1);
  end
else
  begin
    WriteWhere(20,70,15,-1,'Nivel',wScreen1);
    WriteWhere(100,70,15,-1,cad,wScreen1);
  end;
str(eMarcador1.iSpeed,cad);
if c1=2 then
  begin
    WriteColorWhere(180,70,-1,'Nivel',Color83,wScreen1);
    WriteColorWhere(260,70,-1,cad,Color83,wScreen1);
  end
else
  begin
    WriteWhere(180,70,15,-1,'Nivel',wScreen1);
    WriteWhere(260,70,15,-1,cad,wScreen1);
  end;

str(eMarcador2.Altura,cad);
if c2=3 then
  begin
    WriteColorWhere(20,90,-1,'Altura',Color83,wScreen1);
    WriteColorWhere(100,90,-1,cad,Color83,wScreen1);
  end
else
  begin
    WriteWhere(20,90,15,-1,'Altura',wScreen1);
    WriteWhere(100,90,15,-1,cad,wScreen1);
  end;
str(eMarcador1.Altura,cad);
if c1=3 then
  begin
    WriteColorWhere(180,90,-1,'Altura',Color83,wScreen1);
    WriteColorWhere(260,90,-1,cad,Color83,wScreen1);
  end
else
  begin
    WriteWhere(180,90,15,-1,'Altura',wScreen1);
    WriteWhere(260,90,15,-1,cad,wScreen1);
  end;

for i:=1 to 4 do
  begin
    str(i,cad);
    if i>1 then
      s:='s'
    else
      s:='';
    if c2-3=i then
      begin
        WriteColorWhere(20,100+20*i,-1,cad+' linea'+s,Color83,wScreen1);
        str(eMarcador2.Tactica[i],cad);
        WriteColorWhere(100,100+20*i,-1,cad,Color83,wScreen1);
      end
    else
      begin
        WriteWhere(20,100+20*i,15,-1,cad+' linea'+s,wScreen1);
        str(eMarcador2.Tactica[i],cad);
        WriteWhere(100,100+20*i,15,-1,cad,wScreen1);
      end;

    str(i,cad);
    if i>1 then
      s:='s'
    else
      s:='';
    if c1-3=i then
      begin
        WriteColorWhere(180,100+20*i,-1,cad+' linea'+s,Color83,wScreen1);
        str(eMarcador1.Tactica[i],cad);
        WriteColorWhere(260,100+20*i,-1,cad,Color83,wScreen1);
      end
    else
      begin
        WriteWhere(180,100+20*i,15,-1,cad+' linea'+s,wScreen1);
        str(eMarcador1.Tactica[i],cad);
        WriteWhere(260,100+20*i,15,-1,cad,wScreen1);
      end;
  end;
end; (*procedure Opciones*)





function Menu:boolean;
var
  iCursor,cur1,cur2,iI,iJ,iCar:integer;
  f:file;
  b:array[1..8] of boolean;

begin

repeat
until not WasDown[EscScan];

Menu:=true;
OldKeyInt;

{--- Numero jugadores y opciones ---}
repeat
  GetPaleta(Paleta);
  PonSombras(0,0,0,iSombras);

  iCursor:=1;
  ClsWhere(yFondo,wScreen1);
  Players(iCursor);
  WaitRetrace;
  Flip(wScreen1,SegA000);
  QuitaSombras(Paleta,iSombras);

  repeat
    repeat
    until keyPressed;
    iCar:=ord(readkey);

    case iCar of
      75:begin {left}
           if iCursor>1 then
             iCursor:=iCursor-1;
         end;
      77:begin {right}
           if iCursor<3 then
             iCursor:=iCursor+1;
         end;
    end; (*case*)

    ClsWhere(yFondo,wScreen1);
    Players(iCursor);
    WaitRetrace;
    Flip(wScreen1,SegA000);
  until (iCar=13) or (iCar=27);

  if iCar=27 then
    begin
      Menu:=false;
      exit;
    end;


  {--- Opciones ---}

  if iCursor=3 then
    begin
      assign(f,'Opciones.dat');
      reset(f,1);
      with eMarcador1 do
        begin
          blockread(f,Tactica,sizeof(tTactica));
          blockread(f,iSpeed,sizeof(iSpeed));
          blockread(f,Altura,sizeof(Altura));
          blockread(f,wLineas,sizeof(wLineas));
        end;
      with eMarcador2 do
        begin
          blockread(f,Tactica,sizeof(tTactica));
          blockread(f,iSpeed,sizeof(iSpeed));
          blockread(f,Altura,sizeof(Altura));
          blockread(f,wLineas,sizeof(wLineas));
        end;
      blockread(f,TipoFichas,1);

      GetPaleta(Paleta);
      PonSombras(0,0,0,iSombras);

      NewKeyInt;

      Cur1:=1;
      Cur2:=1;
      ClsWhere(yFondo,wScreen1);
      Opciones(Cur1,Cur2); {ver opciones}
      WaitRetrace;
      Flip(wScreen1,SegA000);
      QuitaSombras(Paleta,iSombras);

      for iI:=1 to 8 do
        b[iI]:=true;

      repeat
        {JUG 1}
        if KeyDown[LeftScan] then
          begin
            if b[1] then
              begin {left}
                if Cur1=0 then
                  if TipoFichas>0 then
                    dec(TipoFichas,1);
                if Cur1=1 then
                  if eMarcador1.wLineas>0 then
                    dec(eMarcador1.wLineas,10);
                if Cur1=2 then
                  if eMarcador1.iSpeed>0 then
                    dec(eMarcador1.iSpeed);
                if Cur1=3 then
                  if eMarcador1.Altura>0 then
                    dec(eMarcador1.Altura);
                if Cur1 in [4..7] then
                  if eMarcador1.Tactica[Cur1-3]>0 then
                    dec(eMarcador1.Tactica[Cur1-3]);
                b[1]:=false;
              end;
          end
        else
          b[1]:=true;

        if KeyDown[RightScan] then
          begin
            if b[2] then
              begin {right}
                if Cur1=0 then
                  if TipoFichas<MaxTipoFichas then
                    inc(TipoFichas,1);
                if Cur1=1 then
                  if eMarcador1.wLineas<180 then
                    inc(eMarcador1.wLineas,10);
                if Cur1=2 then
                  if eMarcador1.iSpeed<19 then
                    inc(eMarcador1.iSpeed);
                if Cur1=3 then
                  if eMarcador1.Altura<15 then
                    inc(eMarcador1.Altura);
                if Cur1 in [4..7] then
                  if eMarcador1.Tactica[Cur1-3]<9 then
                    inc(eMarcador1.Tactica[Cur1-3]);
                b[2]:=false;
              end;
          end
        else
          b[2]:=true;

        if KeyDown[UpScan] then
          begin {arr}
            if b[3] then
              if Cur1>0 then
                Cur1:=Cur1-1;
            b[3]:=false;
          end
        else
          b[3]:=true;

        if KeyDown[DownScan] then
          begin {aba}
            if b[4] then
              if Cur1<7 then
                Cur1:=Cur1+1;
            b[4]:=false;
          end
        else
          b[4]:=true;

        {JUG 2}
        if KeyDown[ScanOf('f')] then
          begin {left}
            if b[5] then
              begin
                if Cur2=0 then
                  if TipoFichas>0 then
                    dec(TipoFichas,1);
                if Cur2=1 then
                  if eMarcador2.wLineas>0 then
                    dec(eMarcador2.wLineas,10);
                if Cur2=2 then
                  if eMarcador2.iSpeed>0 then
                    dec(eMarcador2.iSpeed);
                if Cur2=3 then
                  if eMarcador2.Altura>0 then
                    dec(eMarcador2.Altura);
                if Cur2 in [4..7] then
                  if eMarcador2.Tactica[Cur2-3]>0 then
                    dec(eMarcador2.Tactica[Cur2-3]);
                b[5]:=false;
              end
          end
        else
          b[5]:=true;

        if KeyDown[ScanOf('h')] then
          begin
            if b[6] then
              begin {right}
                if Cur2=0 then
                  if TipoFichas<MaxTipoFichas then
                    inc(TipoFichas,1);
                if Cur2=1 then
                  if eMarcador2.wLineas<180 then
                    inc(eMarcador2.wLineas,10);
                if Cur2=2 then
                  if eMarcador2.iSpeed<19 then
                    inc(eMarcador2.iSpeed);
                if Cur2=3 then
                  if eMarcador2.Altura<15 then
                    inc(eMarcador2.Altura);
                if Cur2 in [4..7] then
                  if eMarcador2.Tactica[Cur2-3]<9 then
                    inc(eMarcador2.Tactica[Cur2-3]);
                b[6]:=false;
              end
          end
        else
          b[6]:=true;

        if KeyDown[ScanOf('t')] then
          begin {arr}
            if b[7] then
              if Cur2>0 then
                Cur2:=Cur2-1;
            b[7]:=false;
          end
        else
          b[7]:=true;

        if KeyDown[ScanOf('g')] then
          begin {aba}
            if b[8] then
              if Cur2<7 then
                Cur2:=Cur2+1;
            b[8]:=false;
          end
        else
          b[8]:=true;

        ClsWhere(yFondo,wScreen1);
        Opciones(Cur1,Cur2); {ver opciones}
        WaitRetrace;
        Flip(wScreen1,SegA000);

        if KeyDown[AltScan] and KeyDown[ScanOf('X')] then
          begin
            OldKeyInt;
            CloseGraph;
            halt;
          end;

      until KeyDown[EscScan] or KeyDown[EntScan];

      rewrite(f,1);
      with eMarcador1 do
        begin
          blockwrite(f,Tactica,sizeof(tTactica));
          blockwrite(f,iSpeed,sizeof(iSpeed));
          blockwrite(f,Altura,sizeof(Altura));
          blockwrite(f,wLineas,sizeof(wLineas));
        end;
      with eMarcador2 do
        begin
          blockwrite(f,Tactica,sizeof(tTactica));
          blockwrite(f,iSpeed,sizeof(iSpeed));
          blockwrite(f,Altura,sizeof(Altura));
          blockwrite(f,wLineas,sizeof(wLineas));
        end;
      if TipoFichas=0 then {Aleatorio}
        TipoFichas:=random(MaxTipoFichas)+1;
      blockwrite(f,TipoFichas,1);
      close(f);

      OldKeyInt;
    end; {Opciones}

until iCursor<>3;

iPlayers:=iCursor;


{--- Normal o Death ---}

if iPlayers=2 then
  begin
    GetPaleta(Paleta);
    PonSombras(0,0,0,iSombras);

    ClsWhere(yFondo,wScreen1);
    bDeath:=false;
    Death(bDeath);
    WaitRetrace;
    Flip(wScreen1,SegA000);
    QuitaSombras(Paleta,iSombras);

    repeat
      repeat
      until keyPressed;
      iCar:=ord(readkey);

      case iCar of
        75:begin {left}
             bDeath:=false;
           end;
        77:begin {right}
             bDeath:=true;
           end;
      end; (*case*)

      ClsWhere(yFondo,wScreen1);
      Death(bDeath);
      WaitRetrace;
      Flip(wScreen1,SegA000);
    until (iCar=13) or (iCar=27);

    if iCar=27
    then
      begin
        Menu:=false;
        exit;
      end;


    {--- Victorias ---}

    if bDeath
    then
      begin
        GetPaleta(Paleta);
        PonSombras(0,0,0,iSombras);

        yWinDeath:=1;
        ClsWhere(yFondo,wScreen1);
        WinDeath(yWinDeath);
        WaitRetrace;
        Flip(wScreen1,SegA000);
        QuitaSombras(Paleta,iSombras);

        repeat
          repeat
          until keyPressed;
          iCar:=ord(readkey);

          case iCar of
            75:if yWinDeath>1
               then
                 begin
                   yWinDeath:=yWinDeath-1;
                 end;
            77:if yWinDeath<5
               then
                 begin
                   yWinDeath:=yWinDeath+1;
                  end;
          end; (*case*)

          ClsWhere(yFondo,wScreen1);
          WinDeath(yWinDeath);
          WaitRetrace;
          Flip(wScreen1,SegA000);
        until (iCar=13) or (iCar=27);

        if iCar=27
        then
          begin
            Menu:=false;
            exit;
          end;
      end;
  end
else
  bDeath:=false; {1 player}

NewKeyInt;
end; (*procedure menu*)





procedure mRecords;
var
  iI:integer;
  f:file of tRecords;

begin
assign(f,'records.dat');
{$I-}
reset(f);
{$I+}
if IOResult<>0 then
  begin {crearlo}
    rewrite(f);
    for iI:=1 to 10 do
      begin
        Records[iI].Nombre:='';
        Records[iI].lPuntos:=1;
        Records[iI].wLineas:=1;
      end;
    for iI:=11 to 15 do
      begin
        Records[iI].Nombre:='';
        Records[iI].lPuntos:=1;
        Records[iI].wLineas:=1;
      end;
    write(f,Records);
  end
else
  begin
    {$I-}
    read(f,Records);
    {$I+}
  end;
{$I-}
close(f);
{$I+}
end; (*procedure mRecords*)





procedure mOpciones;
var
  f:file;

begin
assign(f,'Opciones.dat');
{$I-}
reset(f,1);
{$I+}
if (IOResult<>0) or (FileSize(f)<>(sizeof(tTactica)+sizeof(tLineas)+3)*2+1) then
  begin {crearlo si no existe o el tama¤o no es correcto}
    with eMarcador1 do
      begin
        Tactica[1]:=0;
        Tactica[2]:=1;
        Tactica[3]:=2;
        Tactica[4]:=4;
        iSpeed:=5;
        Altura:=0;
        wLineas:=0;
      end;
    with eMarcador2 do
      begin
        Tactica[1]:=0;
        Tactica[2]:=1;
        Tactica[3]:=2;
        Tactica[4]:=4;
        iSpeed:=5;
        Altura:=0;
        wLineas:=0;
      end;
    TipoFichas:=1; {normal}

    rewrite(f,1);
    with eMarcador1 do
      begin
        blockwrite(f,Tactica,sizeof(tTactica));
        blockwrite(f,iSpeed,sizeof(iSpeed));
        blockwrite(f,Altura,sizeof(Altura));
        blockwrite(f,wLineas,sizeof(wLineas));
      end;
    with eMarcador2 do
      begin
        blockwrite(f,Tactica,sizeof(tTactica));
        blockwrite(f,iSpeed,sizeof(iSpeed));
        blockwrite(f,Altura,sizeof(Altura));
        blockwrite(f,wLineas,sizeof(wLineas));
      end;
    blockwrite(f,TipoFichas,1);
  end
else
  begin
    {$I-}
    with eMarcador1 do
      begin
        blockread(f,Tactica,sizeof(tTactica));
        blockread(f,iSpeed,sizeof(iSpeed));
        blockread(f,Altura,sizeof(Altura));
        blockread(f,wLineas,sizeof(wLineas));
      end;
    with eMarcador2 do
      begin
        blockread(f,Tactica,sizeof(tTactica));
        blockread(f,iSpeed,sizeof(iSpeed));
        blockread(f,Altura,sizeof(Altura));
        blockread(f,wLineas,sizeof(wLineas));
      end;
    blockread(f,TipoFichas,1);
    {$I+}
  end;
close(f);
end; (*procedure mOpciones*)





function VerRecords:boolean; {dice si se pulso la r}
var
  iA,iB,iI:integer;
  str1:string;
  bRep:boolean;
  wRND,wCronoH,wCronoM,wCronoS,wCronoS100:word;

begin

{RANDOMIZE}
getTime(wCronoH,wCronoM,wCronoS,wCronoS100);
wRND:=wCronoS100*wCronoS+wCronoM*wCronoH;
randseed:=wRND;

{closegraph;
oldkeyint;
writeln(wrnd);
readln;
readln;
halt;}


ClearWasDownArray;
GetPaleta(Paleta);
PonSombras(0,0,0,iSombras);

ClsWhere(yFondo,SegA000);

WriteColorWhere(15,1,-1,'Record de Puntos',Color83,SegA000);

iA:=0;
iB:=15;
for iI:=1 to 10 do
  begin
    WriteWhere(2,iB,15,-1,Records[iI].Nombre,SegA000);
    WriteWhere(18*8,iB,15,-1,'Pun',SegA000);
    str(Records[iI].lPuntos,str1);
    WriteWhere(22*8,iB,15,-1,str1,SegA000);
    WriteWhere(31*8,iB,15,-1,'Lin',SegA000);
    str(Records[iI].wLineas,str1);
    WriteWhere(35*8,iB,15,-1,str1,SegA000);
    iB:=iB+10;
  end;

WriteColorWhere(15,120,-1,'Record de Lineas',Color83,SegA000);

iB:=135;
for iI:=11 to 15 do
  begin
    WriteWhere(2,iB,15,-1,Records[iI].Nombre,SegA000);
    WriteWhere(18*8,iB,15,-1,'Lin',SegA000);
    str(Records[iI].wLineas,str1);
    WriteWhere(22*8,iB,15,-1,str1,SegA000);
    WriteWhere(28*8,iB,15,-1,'Pun',SegA000);
    str(Records[iI].lPuntos,str1);
    WriteWhere(32*8,iB,15,-1,str1,SegA000);
    iB:=iB+10;
  end;

QuitaSombras(Paleta,iSombras);

bRep:=false;
repeat
until TeclaPulsada;
if WasDown[escscan] then
  begin
    PonSombras(0,0,0,iSombras);
    OldKeyInt;
    CloseGraph;
    halt;
  end;
if WasDown[ScanOf('r')] then
  bRep:=true;
repeat
until not teclapulsada;

VerRecords:=bRep;
end; (*procedure VerRecords*)





procedure CorrerPuntos(iPuesto:integer; lPuntos:tPuntos; wLineas:tLineas;
                       sNombre:string);
var
  iI:integer;

begin
for iI:=10 downto iPuesto+1 do
  begin
    Records[iI].Nombre:=Records[iI-1].Nombre;
    Records[iI].lPuntos:=Records[iI-1].lPuntos;
    Records[iI].wLineas:=Records[iI-1].wLineas;
  end;

Records[iPuesto].Nombre:=sNombre;
Records[iPuesto].lPuntos:=lPuntos;
Records[iPuesto].wLineas:=wLineas;
end; (*procedure CorrerPuntos*)





procedure CorrerLineas(iPuesto:integer; lPuntos:tPuntos; wLineas:tLineas;
                       sNombre:string);
var
  iI:integer;

begin
for iI:=15 downto iPuesto+1 do
  begin
    Records[iI].Nombre:=Records[iI-1].Nombre;
    Records[iI].lPuntos:=Records[iI-1].lPuntos;
    Records[iI].wLineas:=Records[iI-1].wLineas;
  end;

Records[iPuesto].Nombre:=sNombre;
Records[iPuesto].lPuntos:=lPuntos;
Records[iPuesto].wLineas:=wLineas;
end; (*procedure CorrerLineas*)





function PedirNombre(Titulo:string):string;
var
  iCar:integer;
  sText:string;

begin
ClsWhere(yFondo,SegA000);
Cuadrado(70,50,225,110,15);
Cuadrado(75,55,220,70,1);
WriteWhere(100,59,15,-1,Titulo,SegA000);
Cuadrado(75,90,220,105,7);
QuitaSombras(Paleta,iSombras);
sText:='';

SetColor(0);
repeat
  iCar:=ord(ReadKey);
  if (iCar>=32) and (length(sText)<MaxLongNombre) then
    begin {letras}
      sText:=sText+Chr(iCar);
      WriteWhere(82,94,0,-1,sText,SegA000);
    end;
  if (iCar=8) and (length(sText)>0) then
    begin {delete}
      sText:=copy(sText,1,length(sText)-1);
      WriteWhere(82+length(sText)*8,94,7,-1,'Û',SegA000);
    end;
until (iCar=13);
ClsWhere(0,SegA000);
PedirNombre:=sText;
end;





procedure PonerRecord(lPuntos:tPuntos; wLineas:word; sTitulo:string);
var
  PeorPuntos:tPuntos;
  PeorLineas:tLineas;
  iI:integer;
  sNombre:string;
  f:file of tRecords;
  bSal:boolean;

begin
OldKeyInt;

PeorPuntos:=Records[1].lPuntos;
for iI:=1 to 10 do
  if Records[iI].lPuntos<PeorPuntos then PeorPuntos:=Records[iI].lPuntos;
PeorLineas:=Records[11].wLineas;
for iI:=11 to 15 do
  if Records[iI].wLineas<PeorLineas then PeorLineas:=Records[iI].wLineas;


if (lPuntos>PeorPuntos) or (wLineas>PeorLineas) then
  begin
    GetPaleta(Paleta);
    PonSombras(0,0,0,iSombras);

    if sTitulo='' then sTitulo:='Record';
    sNombre:=PedirNombre(sTitulo);

    bSal:=false;
    iI:=1;
    repeat
      if Records[iI].lPuntos<lPuntos then
        begin
          CorrerPuntos(iI,lPuntos,wLineas,sNombre);
          bSal:=true;
        end;
      iI:=iI+1;
    until (iI>10) or bSal;

    bSal:=false;
    iI:=11;
    repeat
      if Records[iI].wLineas<wLineas then
        begin
          CorrerLineas(iI,lPuntos,wLineas,sNombre);
          bSal:=true;
        end;
      iI:=iI+1;
    until (iI>15) or bSal;

    assign(f,'records.dat');
    reset(f);
    write(f,Records);
    close(f);
  end;

{else
  begin
    ClsWhere(0,SegA000);
  end;}

NewKeyInt;
end; (*procedure PonerRecord*)





end.
