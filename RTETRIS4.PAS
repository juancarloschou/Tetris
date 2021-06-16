{$R+}

program rTetris4;


  {rtetris1: (2001)
Version basada en el Tetris original de 1997}

  {rtetris2: (2002)
Solucionada la desaparicion de fichas
Velocidad constante, acelerada la velocidad y ajustada a la veloc de la CPU
Menu de Opciones, altura inicial, menus en pantalla virtual
Nuevas fichas: Largas de 6 y 8, cuadrados grande y peque¤o (desaparece color)}

  {rTetris3:
Intento de que vengan mas octotetris y puntos cuando estes lleno (sin hacer)}

  {rTetris4: (2003)
Mejor justificacion del codigo y uso eficiente de la memoria
Repeticion de jugadas grabables. Cuando mandas el agujero sale centrado
Mas fichas: Decatetris, estrellas, L grande}



uses Crt,dos,Graph,Imagen,Pcx,Piezas,Teclas;



{var
i,x,y:integer;
s:string;}





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
    WriteColorWhere(136,iY+25,-1,sLineas,Color82,where);
    WriteColorWhere(136,iY+40,-1,sSpeed,Color82,where);
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
    WriteColorWhere(152,iY+110,-1,sLineas,Color81,where);
    WriteColorWhere(152,iY+125,-1,sSpeed,Color81,where);
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
    8:PutImagenXYWhere(iX,iY,Pieza8,where);
    10:PutImagenXYWhere(iX,iY,Pieza10,where);
    11:PutImagenXYWhere(iX,iY,Pieza22,where);
    12:PutImagenXYWhere(iX,iY,Pieza23,where);
    13:PutImagenXYWhere(iX,iY,Pieza24,where);
    20:PutImagenXYWhere(iX,iY,Pieza20,where);
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

end; (*function VerPiezaAbajo*)





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





function Romper(var Pantalla:tPantalla; color:byte):integer;
var
  r,iI,iJ,iK:integer;

begin
r:=0;
for iJ:=1 to 17 do
  for iI:=1 to 10 do
    if Pantalla[iI,iJ]=color then
      begin
        Pantalla[iI,iJ]:=0;
        inc(r);
        for ik:=iJ downto 1 do
          Pantalla[iI,ik]:= Pantalla[iI,ik-1];
        Pantalla[iI,0]:=0;
      end;

Romper:=r;
end; (*procedure Romper*)





procedure LaPieza10(var eMarcador:tMarcador);
var
  i,r,j:integer;
  p,q:longint;

begin
with eMarcador do
  begin
    if Nombre=NombreJug1 then
      i:=Pantalla1[iPiezaX,iPiezaY+1] {color abajo}
    else
      i:=Pantalla2[iPiezaX,iPiezaY+1];

    if ePieza.color=i then
      begin {romper mazo}
        if Nombre=NombreJug1 then
          j:=1
        else
          j:=2;

        if j=1 then
          r:=Romper(Pantalla1,ePieza.color)
        else
          r:=Romper(Pantalla2,ePieza.color);

        p:=lPuntos;
        q:=r*((iSpeed+2) div 2);
        p:=p+50*q;
        if p>MaxPuntos then p:=MaxPuntos;
        lPuntos:=p;

        if not bRepet then
          begin
            inc(Estad.Jug[j].DesHaz,r);
            if Estad.Jug[j].MejorDes<r then
              Estad.Jug[j].MejorDes:=r;
          end;

        if bDeath then
          if r>9 then
            if Nombre=NombreJug1
            then
              with eMarcador2 do
                begin
                  eCrear.bCrear:=true;
                  inc(eCrear.yCuantas,r div 10);
                  eCrear.yX:=VerLineaAbajo(Pantalla2)
                end
            else
              with eMarcador1 do
                begin
                  eCrear.bCrear:=true;
                  inc(eCrear.yCuantas,r div 10);
                  eCrear.yX:=VerLineaAbajo(Pantalla1);
                end;

      end;
  end;
end; (*procedure Pieza10*)





procedure CrearNuevaPieza(var eMarcador:tMarcador; var G:tGrabar);
begin
if not eMarcador.bGameOver then
  with eMarcador do
    begin
      bPausaPpio:=true;
      if DatoLista(pPosLista^.siguiente,ListaPiezas)=0 then
        NuevoDato(pPosLista,ListaPiezas,G);
      ePieza.tipo:=DatoLista(pPosLista,ListaPiezas);
      ePieza.rotate:=1;
      DatosPieza(ePieza,iPiezaX);
      iPiezaY:=1;
      pPosLista:=pPosLista^.siguiente;
    end
end;





procedure BorrarLineas(var eMarcador:tMarcador; var Pantalla:tPantalla;
                       var G:tGrabar; bPintar:boolean);
var
  iI,iJ,j:integer;
  p,m:longint;
  b:boolean;

begin
with eMarcador do
  begin

    if bPintar then
      case eBorrar.iEstado of
        1:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar7Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1);
          end;
        2:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar6Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1); {negro}
          end;
        3:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar7Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1); {ficha}
          end;
        4:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar6Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1);
          end;
        5:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar7Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1);
          end;
        6:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar6Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1);
          end;
        7:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar7Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1);
          end;
        8:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar6Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1);
          end;
        9:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar7Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1);
          end;
        10:begin
            for iI:=1 to eBorrar.yCuantas do
              Marcar6Linea(eBorrar.aCual[iI],eMarcador,Pantalla,wScreen1);
          end;
      end;

    case eBorrar.iEstado of
      11:begin
           for iI:=1 to eBorrar.yCuantas do
             BorrarLinea(eBorrar.aCual[iI],Pantalla);

           if bDeath then
             wLineas:=wLineas-eBorrar.yCuantas
           else
             wLineas:=wLineas+eBorrar.yCuantas;

           if wLineas>MaxLineas then
             wLineas:=MaxLineas;

           p:=lPuntos;
           case eBorrar.yCuantas of {MaxTetrisLineas}
             1:begin
                 p:=p+60*((iSpeed+2) div 2);
               end;
             2:begin
                 p:=p+150*((iSpeed+2) div 2);
               end;
             3:begin
                 p:=p+300*((iSpeed+2) div 2);
               end;
             4:begin
                 p:=p+600*((iSpeed+2) div 2);
               end;
             5:begin
                 m:=((iSpeed+2) div 2);
                 m:=1200*m;
                 p:=p+m;
               end;
             6:begin
                 m:=((iSpeed+2) div 2);
                 m:=2500*m;
                 p:=p+m;
               end;
             7:begin
                 m:=((iSpeed+2) div 2);
                 m:=5000*m;
                 p:=p+m;
               end;
             8:begin
                 m:=((iSpeed+2) div 2);
                 m:=8000*m;
                 p:=p+m;
               end;
             9:begin
                 m:=((iSpeed+2) div 2);
                 m:=11000*m;
                 p:=p+m;
               end;
             10:begin
                 m:=((iSpeed+2) div 2);
                 m:=15000*m;
                 p:=p+m;
               end;
           end; (*case*)
           if p>MaxPuntos then p:=MaxPuntos;
           lPuntos:=p;


           {Ver si vaciamos la pantalla}
           b:=true;
           for iI:=0 to 17 do
             for iJ:=1 to 10 do
               if Pantalla[iJ,iI]<>0 then
                 b:=false;
           if b then
             begin
               p:=lPuntos;
               m:=((iSpeed+2) div 2);
               m:=10000*m;
               p:=p+m;
               if p>MaxPuntos then p:=MaxPuntos;
               lPuntos:=p;
               eBorrar.Vacio:=true;
             end;

           if not bRepet then
             with Estad do
               begin
                 if Nombre=NombreJug1 then
                   j:=1
                 else
                   j:=2;

                 iI:=eBorrar.yCuantas;
                 if b then
                   iI:=iI+5;
                 inc(Jug[j].Mandar,iI);
                 if iI>Jug[j].Mejor then
                   Jug[j].Mejor:=iI;
               end;


           if (wLineas>=wNextLevel) and (iSpeed<19) and (not bDeath)
           then
             begin
               iSpeed:=iSpeed+1;
               iLimite:=Velocidad(iSpeed);
               wNextLevel:=wNextLevel+10;
             end;

           if eCrear.bCrear
           then
             begin
               eCrear.bCrear:=false;
               for iI:=1 to eCrear.yCuantas do
                 CrearLinea(eCrear.yX,Pantalla);
               eCrear.yCuantas:=0;
             end;

           CrearNuevaPieza(eMarcador,G);
           if bMiraPieza(ePieza,iPiezaX,iPiezaY,Pantalla) then bGameOver:=true;

           if bDeath and (wLineas<=0)
           then
             begin
               if eMarcador.Nombre=NombreJug1
               then eMarcador2.bGameOver:=true
               else eMarcador1.bGameOver:=true
             end;
         end;

      12:begin
           if bDeath
           then {sumarle lineas al contrario}
             if Nombre=NombreJug1
             then
               with eMarcador2 do
                 begin
                   eCrear.bCrear:=true;
                   if eMarcador1.eBorrar.yCuantas>4 then
                     inc(eCrear.yCuantas,eMarcador.Tactica[4]+(eMarcador1.eBorrar.yCuantas-4)) {‡ *2}
                   else
                     inc(eCrear.yCuantas,eMarcador.Tactica[eMarcador1.eBorrar.yCuantas]);
                   if eMarcador1.eBorrar.Vacio then
                     begin
                       inc(eCrear.yCuantas,5);
                       eMarcador1.eBorrar.Vacio:=false;
                     end;
                   eCrear.yX:=VerLineaAbajo(Pantalla2);
                 end
             else
               with eMarcador1 do
                 begin
                   eCrear.bCrear:=true;
                   if eMarcador2.eBorrar.yCuantas>4 then
                     inc(eCrear.yCuantas,eMarcador.Tactica[4]+(eMarcador2.eBorrar.yCuantas-4)) {‡ *2}
                   else
                     inc(eCrear.yCuantas,eMarcador.Tactica[eMarcador2.eBorrar.yCuantas]);
                   if eMarcador2.eBorrar.Vacio then
                     begin
                       inc(eCrear.yCuantas,5);
                       eMarcador2.eBorrar.Vacio:=false;
                     end;
                   eCrear.yX:=VerLineaAbajo(Pantalla1);
                 end;
           eBorrar.bBorrar:=false;
           eBorrar.iEstado:=-1;
           eBorrar.yCuantas:=0;
         end;

    end; (*case*)

    eBorrar.iEstado:=eBorrar.iEstado+1;
  end; (*with eMarcador*)

end; (*procedure BorrarLineas*)





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





procedure NuevaPieza(var eMarcador:tMarcador; var Pantalla:tPantalla;
                     var G:tGrabar);
var
  iI,iJ:integer;
  bLleno:boolean;
  bHayAlguna:boolean;
  abLinea:array[0..17] of boolean; {dice las lineas hechas->trues}

begin

if eMarcador.ePieza.tipo=10 then
  LaPieza10(eMarcador);

{Comprobar lineas}
bHayAlguna:=false;
for iJ:=0 to 17 do
  begin
    bLleno:=true;
    for iI:=1 to 10 do
      if Pantalla[iI,iJ]=0 then
        bLleno:=false;
    abLinea[iJ]:=bLleno;
    if bLleno then
      bHayAlguna:=true;
  end;

with eMarcador do
  if bHayAlguna then
    begin
      eBorrar.bBorrar:=true;
      eBorrar.iEstado:=1;
      iI:=0;
      for iJ:=0 to 17 do
        if abLinea[iJ] then
          if iI<MaxTetrisLineas then
            begin
              iI:=iI+1;
              eBorrar.aCual[iI]:=iJ;
            end;
      eBorrar.yCuantas:=iI;
    end
  else {no hemos hecho lineas}
    begin
      if eCrear.bCrear
      then
        begin
          eCrear.bCrear:=false;
          for iI:=1 to eCrear.yCuantas do
            CrearLinea(eCrear.yX,Pantalla);
          eCrear.yCuantas:=0;
        end;

      CrearNuevaPieza(eMarcador,G);
      if bMiraPieza(ePieza,iPiezaX,iPiezaY,Pantalla) then
        bGameOver:=true;
    end;

end; (*procedure NuevaPieza*)





procedure PonerAltura(eMarcador:tMarcador; var Pantalla:tPantalla);
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
      i:=1;
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

GetPaleta(Paleta);
PonSombras(0,0,0,iSombras);
ClsWhere(0,SegA000);
QuitaSombras(Paleta,0);

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
      c2:=85; {¤¤¤}
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
QuitaSombras(Paleta,0);
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
  1:cad:='Normal';
  2:cad:='Muy facil';
  3:cad:='Facil';
  4:cad:='Moderado';
  5:cad:='Dificil';
  6:cad:='Muy dificil';
  7:cad:='Imposible';
  8:cad:='Clasico';
  9:cad:='Pocas fichas';
  10:cad:='Bastantes';
  11:cad:='Muchas fichas';
  12:cad:='Todas por igual';
  13:cad:='Cuadrados';
  14:cad:='Largas';
  15:cad:='Largas Mazo';
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

  if iCar=27
  then
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

if iPlayers=2
then
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
  end;

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

{Cuadrado(0,0,GetMaxX,GetMaxY,yFondo); {0 4 112 185}
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
  if (iCar>=32) and (length(sText)<yLongNombre) then
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





procedure GameOver(eMarcador:tMarcador);
var
  iI,i2,iJ:integer;
  cCar:char;

begin

bRepeticion:=false;

if bDeath then
  begin
    {circulos parriba}
    if not bRepet then
      begin
        ClsWhere(0,wScreen1);
        with eMarcador1 do
          begin
            DibujaFondo(iX,iY,10,wScreen1);
            DibujaPantalla(eMarcador1,Pantalla1,wScreen1);
          end;
        with eMarcador2 do
          begin
            DibujaFondo(iX,iY,10,wScreen1);
            DibujaPantalla(eMarcador2,Pantalla2,wScreen1);
          end;
        PonerDatos2(eMarcador1,eMarcador2,wScreen1);
        DibujaNext2(eMarcador1,eMarcador2,wScreen1,Grabar^);

        WaitRetrace;
        Flip(wScreen1,SegA000);

        Esperar(1500);
        iJ:=17;
        repeat
          ClsWhere(0,wScreen1);

          with eMarcador1 do
            begin
              DibujaFondo(iX,iY,10,wScreen1);
              DibujaPantalla(eMarcador1,Pantalla1,wScreen1);
            end;
          with eMarcador2 do
            begin
              DibujaFondo(iX,iY,10,wScreen1);
              DibujaPantalla(eMarcador2,Pantalla2,wScreen1);
            end;

          with eMarcador1 do
            if bGameOver then
              for iI:=1 to 10 do {x}
                for i2:=17 downto iJ do {y}
                  DibujaCuadro(iX+iI*9,iY+i2*9,20,1,wScreen1);
          with eMarcador2 do
            if bGameOver then
              for iI:=1 to 10 do
                for i2:=17 downto iJ do
                  DibujaCuadro(iX+iI*9,iY+i2*9,20,2,wScreen1);

          PonerDatos2(eMarcador1,eMarcador2,wScreen1);
          WaitRetrace;
          Flip(wScreen1,SegA000);
          iJ:=iJ-1;
          Esperar(60);
        until iJ=-1;

        repeat
        until not TeclaPulsada;

        iJ:=0;
        repeat
          Esperar(50);
          iJ:=iJ+1;
        until TeclaPulsada or (iJ>40); {espera unos 2 seg}
        if KeyDown[yRepet] then
          bRepeticion:=true;
        if iJ<=40 then
          Esperar(100);

        if eMarcador1.bGameover and eMarcador2.bGameover then
          {empate}
        else
          if eMarcador.Nombre=NombreJug1 then
            yWin2:=yWin2+1
          else
            yWin1:=yWin1+1;
      end;

    bSalir:=true;
  end

else {normal}
  if ((eMarcador1.bGameOver) and (eMarcador2.bGameOver)) or (iPlayers=1) then
    begin
      if not bRepet then
        begin
          ClsWhere(0,wScreen1);
          if iPlayers=2 then
            begin
              with eMarcador1 do
                begin
                  DibujaFondo(iX,iY,10,wScreen1);
                  DibujaPantalla(eMarcador1,Pantalla1,wScreen1);
                end;
              with eMarcador2 do
                begin
                  DibujaFondo(iX,iY,10,wScreen1);
                  DibujaPantalla(eMarcador2,Pantalla2,wScreen1);
                end;
              PonerDatos2(eMarcador1,eMarcador2,wScreen1);
              DibujaNext2(eMarcador1,eMarcador2,wScreen1,Grabar^);
            end
          else
            with eMarcador1 do
              begin
                DibujaFondo(iX,iY,10,wScreen1);
                DibujaPantalla(eMarcador1,Pantalla1,wScreen1);
                PonerDatos(eMarcador1,wScreen1);
                DibujaNext(eMarcador1,wScreen1,Grabar^);
              end;
          WaitRetrace;
          Flip(wScreen1,SegA000);

          Esperar(300);
          repeat
          until not TeclaPulsada;

          iJ:=0;
          repeat
            Esperar(50);
            iJ:=iJ+1;
          until TeclaPulsada or (iJ>40); {espera unos 2 seg}
          if KeyDown[yRepet] then
            bRepeticion:=true;
          if iJ<=40 then
            Esperar(100);

          if iPlayers=2 then
            begin
              PonerRecord(eMarcador1.lPuntos,eMarcador1.wLineas,eMarcador1.nombre);
              PonerRecord(eMarcador2.lPuntos,eMarcador2.wLineas,eMarcador2.nombre);
            end
          else
            PonerRecord(eMarcador1.lPuntos,eMarcador1.wLineas,'');
        end;

      bSalir:=true;
    end;

end; (*procedure GameOver*)





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
  Esperar(50);

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





procedure CargarImagenes;
var
  sFicha:string;
  ImagenAux:tImagen;

begin
sFicha:='fichas0';
LoadImagenSPR(sFicha,'',0,Pieza1,iError);
LoadImagenSPR(sFicha,'',1,Pieza2,iError);
LoadImagenSPR(sFicha,'',2,Pieza3,iError);
LoadImagenSPR(sFicha,'',3,Pieza4,iError);
LoadImagenSPR(sFicha,'',4,Pieza5,iError);
LoadImagenSPR(sFicha,'',5,Pieza6,iError);
LoadImagenSPR(sFicha,'',6,Pieza7,iError);
sFicha:='fichas3';
LoadImagenSPR(sFicha,'',0,Pieza11,iError);
LoadImagenSPR(sFicha,'',1,Pieza12,iError);
LoadImagenSPR(sFicha,'',2,Pieza13,iError);
LoadImagenSPR(sFicha,'',3,Pieza14,iError);
LoadImagenSPR(sFicha,'',4,Pieza15,iError);
LoadImagenSPR(sFicha,'',5,Pieza16,iError);
LoadImagenSPR(sFicha,'',6,Pieza17,iError);
sFicha:='fichas5';
LoadImagenSPR(sFicha,'',13,Pieza8,iError); {crecen}
LoadImagenSPR(sFicha,'',14,Pieza10,iError); {fondo}
sFicha:='fichas4';
LoadImagenSPR(sFicha,'',11,Pieza20,iError); {game over, player1-rojo}
LoadImagenSPR(sFicha,'',8,Pieza21,iError);  {game over, player2-azul}
sFicha:='fichas7';
LoadImagenSPR(sFicha,'',12,Pieza22,iError); {larga}
sFicha:='fichas8';
LoadImagenSPR(sFicha,'',9,Pieza23,iError); {cuadrado}
sFicha:='fichas5';
LoadImagenSPR(sFicha,'',7,Pieza24,iError); {superlarga}

LoadImagenSPR('fichas0','',0,ImagenAux,iError);
end;





procedure Depurar;
begin
  if KeyDown[ScanOf('­')] then
    begin
      bDepurar:=not bDepurar;
      repeat
      until not KeyDown[ScanOf('­')];
    end;
end;





procedure CargarListaPiezas(var Lista:tListaPiezas; var G:tGrabar);
var
  pAct,pAnt:tListaPiezas;
  NF:word;

begin
with G do
  begin
    NF:=0;
    New(Lista);
    Lista^.Pieza:=Fichas[NF];
    pAnt:=Lista;
    NF:=NF+1;

    repeat
      New(pAct);
      pAct^.Pieza:=Fichas[NF];
      pAnt^.Siguiente:=pAct;
      pAnt:=pAct;
      NF:=NF+1;
    until NF>=NumF;
    pAct^.Siguiente:=nil;
  end;
end;





procedure Grabacion(var G:tGrabar; lTpo:longint; yTcl:byte);
begin
  with G do
    if Num<MaxEventos then
      begin
        Eventos[Num].Tpo:=lTpo;
        Eventos[Num].Tecla:=yTcl;
        Num:=Num+1;
        if Num>MaxEventos then
          Num:=MaxEventos;
      end
  else
    if yTcl=13 then
      begin
        Eventos[MaxEventos-1].Tpo:=lTpo;
        Eventos[MaxEventos-1].Tecla:=yTcl;
        Num:=MaxEventos;
      end;
end;





function VerEvento(lTpo:longint; Tecla:byte; NumEv:word; var G:tGrabar):boolean;
var
  w:word;
  b:boolean;

begin
  w:=NumEv;
  b:=false;
  with G do
    repeat
      if (Eventos[w].Tpo=lTpo) and (Eventos[w].Tecla=Tecla) then
        b:=true;
      w:=w+1;
    until (w>=Num) or (Eventos[w].Tpo>lTiempo);
  VerEvento:=b;
end;





procedure Simulador(var NE:word; var lTpo:longint; var G:tGrabar;
                    var iR:integer; bPant:boolean; veloc:byte);
var
  s:string;

begin

  if not eMarcador1.bPause {and not eMarcador1.bGameOver} then
    eMarcador1.iTime:=eMarcador1.iTime+1;
  if G.Tipo>1 then
    if not eMarcador2.bPause {and not eMarcador2.bGameOver} then
      eMarcador2.iTime:=eMarcador2.iTime+1;

  if G.Tipo>1 then
    LimpiarPantallas
  else
    LimpiarPantalla;


  if bPant then
    begin
      ClsWhere(0,wScreen1);

      with eMarcador1 do
        begin
          DibujaFondo(iX,iY,10,wScreen1);
          DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
          DibujaPantalla(eMarcador1,Pantalla1,wScreen1);
          if eBorrar.bBorrar then
            BorrarLineas(eMarcador1,Pantalla1,G,bPant);
        end;

      if G.Tipo>1 then
        with eMarcador2 do
          begin
            DibujaFondo(iX,iY,10,wScreen1);
            DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
            DibujaPantalla(eMarcador2,Pantalla2,wScreen1);
            if eBorrar.bBorrar then
              BorrarLineas(eMarcador2,Pantalla2,G,bPant);
          end;

      if G.Tipo>1 then
        begin
          DibujaNext2(eMarcador1,eMarcador2,wScreen1,Grabar^);
          PonerDatos2(eMarcador1,eMarcador2,wScreen1);
        end
      else
        begin
          DibujaNext(eMarcador1,wScreen1,Grabar^);
          PonerDatos(eMarcador1,wScreen1);
        end;


      if iR>=0 then
        begin
          WriteWhere(310,1,15,-1,'R',wScreen1);
          iR:=iR+1;
          if veloc=4 then
            iR:=iR+2;
          if veloc=5 then
            iR:=iR+5;
          if veloc=6 then
            iR:=iR+12;
          if iR>10 then
            iR:=-1;
        end
      else
        begin
          iR:=iR-1;
          if iR<-10 then
            iR:=0;
        end;

      if bDepurar then
        begin
          str(NE,s);
          WriteWhere(180,1,15,-1,s,wScreen1);
          str(lTpo,s);
          WriteWhere(180,10,15,-1,s,wScreen1);
          {str(veloc,s);
          WriteWhere(310,190,15,-1,s,wScreen1);}
        end;

      case veloc of
        0: s:='V/10';
        1: s:='V/5';
        2: s:='V/2';
        3: s:='V*1';
        4: s:='V*2';
        5: s:='V*5';
        6: s:='V*10';
      end;
      WriteWhere(285,190,15,-1,s,wScreen1);

      WaitRetrace;
      Flip(wScreen1,SegA000);
    end
  else
    begin
      if eMarcador1.eBorrar.bBorrar then
        BorrarLineas(eMarcador1,Pantalla1,G,bPant);
      if G.Tipo>1 then
        if eMarcador2.eBorrar.bBorrar then
          BorrarLineas(eMarcador2,Pantalla2,G,bPant);
    end;


  if KeyDown[AltScan] and KeyDown[ScanOf('X')] then
    begin
      OldKeyInt;
      CloseGraph;
      halt;
    end;


  if eMarcador1.bGameOver and not bSalir then
    GameOver(eMarcador1);
  if G.Tipo>1 then
    if eMarcador2.bGameOver and not bSalir then
      GameOver(eMarcador2);


  if VerEvento(lTpo,6,NE,G) then
    begin
      with eMarcador1 do
        if not bPause then
          bPause:=true
        else
          bPause:=false;
      NE:=NE+1;
    end;

  if G.Tipo>1 then
    if VerEvento(lTpo,12,NE,G) then
      begin
        with eMarcador2 do
          if not bPause then
            bPause:=true
          else
            bPause:=false;
        NE:=NE+1;
      end;


  with eMarcador1 do
    if not eBorrar.bBorrar and not bPause {and not bGameOver} then
      begin {solo movemos si no hacemos linea}
        if bPausaPpio and not VerEvento(lTpo,3,NE,G) then
          bPausaPpio:=false;

        if VerEvento(lTpo,1,NE,G) then
          begin
            if bIzquierda(ePieza,iPiezaX,iPiezaY,Pantalla1)
            then
              begin
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaX:=iPiezaX-1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
              end;
          end;

        if VerEvento(lTpo,2,NE,G) then
          begin
            if bDerecha(ePieza,iPiezaX,iPiezaY,Pantalla1)
            then
              begin
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaX:=iPiezaX+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
              end;
          end;

        if VerEvento(lTpo,3,NE,G) and (not bPausaPpio)
        then
          begin
            iTime:=0;
            if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla1) then
              begin
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaY:=iPiezaY+1;
                iDrops:=iDrops+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
              end
            else
              begin
                lPuntos:=lPuntos+iDrops;
                if lPuntos>MaxPuntos then lPuntos:=MaxPuntos;
                iDrops:=0;
                NuevaPieza(eMarcador1,Pantalla1,Grabar^);
              end;
          end;

        if not VerEvento(lTpo,3,NE,G) then
          iDrops:=0;

        if VerEvento(lTpo,5,NE,G) then
          RotateDer(eMarcador1,Pantalla1);

        if VerEvento(lTpo,4,NE,G) then
          RotateIzq(eMarcador1,Pantalla1);


        if iTime>=iLimite then
          begin
            iTime:=0;
            if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla1) then
              begin
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaY:=iPiezaY+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
              end
            else
              NuevaPieza(eMarcador1,Pantalla1,Grabar^)
          end;
      end;

  { ----- +++++ ----- }

  if G.Tipo>1 then
    with eMarcador2 do
      if not eBorrar.bBorrar and not bPause {and not bGameOver} then
        begin {solo movemos si no hacemos linea}
          if bPausaPpio and not VerEvento(lTpo,9,NE,G) then
            bPausaPpio:=false;

          if VerEvento(lTpo,7,NE,G) then
            begin
              if bIzquierda(ePieza,iPiezaX,iPiezaY,Pantalla2) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                  iPiezaX:=iPiezaX-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
                end;
            end;

          if VerEvento(lTpo,8,NE,G) then
            begin
              if bDerecha(ePieza,iPiezaX,iPiezaY,Pantalla2) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                  iPiezaX:=iPiezaX+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                end;
            end;

          if VerEvento(lTpo,9,NE,G) and (not bPausaPpio) then
            begin
              iTime:=0;
              if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla2) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                  iPiezaY:=iPiezaY+1;
                  iDrops:=iDrops+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
                end
              else
                begin
                  lPuntos:=lPuntos+iDrops;
                  if lPuntos>MaxPuntos then lPuntos:=MaxPuntos;
                  iDrops:=0;
                  NuevaPieza(eMarcador2,Pantalla2,Grabar^)
                end;
            end;

          if not VerEvento(lTpo,9,NE,G) then
            iDrops:=0;

          if VerEvento(lTpo,11,NE,G) then
            RotateDer(eMarcador2,Pantalla2);

          if VerEvento(lTpo,10,NE,G) then
            RotateIzq(eMarcador2,Pantalla2);


          if iTime>=iLimite then
            begin
              iTime:=0;
              if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla2) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
                end
              else
                NuevaPieza(eMarcador2,Pantalla2,Grabar^)
            end;
        end;


  lTpo:=lTpo+1;
  if lTpo>MaxTiempo then
    lTpo:=MaxTiempo;

  if NE<G.Num then
    if G.Eventos[NE].Tpo < lTpo then
      NE:=NE+1;
  if NE<G.Num then
    if G.Eventos[NE].Tpo < lTpo then
      NE:=NE+1;

end;





procedure IniciaSimulador(var G:tGrabar);
begin
with eMarcador1 do
  begin
    if G.Tipo>1 then
      begin
        iX:=211;
        iY:=15;
      end
    else
      begin
        iX:=60;
        iY:=15
      end;

    Tactica:=G.Opc1.Tactica;
    iSpeed:=G.Opc1.iSpeed;
    Altura:=G.Opc1.Altura;
    wLineas:=G.Opc1.wLineas;

    eBorrar.bBorrar:=false;
    eBorrar.iEstado:=0;
    eBorrar.yCuantas:=0;
    eBorrar.Vacio:=false;
    eCrear.bCrear:=false;
    eCrear.yCuantas:=0;
    eCrear.yX:=10;

    iDrops:=0;
    lPuntos:=0;
    wNextLevel:=(iSpeed+1)*10;
    iLimite:=Velocidad(iSpeed);
    iTime:=0;

    bPausaPpio:=false;
    bPause:=false;
    bGameOver:=false;

    IniciaPantalla(Pantalla1);
    pPosLista:=ListaPiezas;
    NuevaPieza(eMarcador1,Pantalla1,G);
    Pantalla1:=G.Altura1;
  end;

if G.Tipo>1 then {2 players normal o death}
with eMarcador2 do
  begin
    iX:=0;
    iY:=15;

    Tactica:=G.Opc2.Tactica;
    iSpeed:=G.Opc2.iSpeed;
    Altura:=G.Opc2.Altura;
    wLineas:=G.Opc2.wLineas;

    eBorrar.bBorrar:=false;
    eBorrar.iEstado:=0;
    eBorrar.yCuantas:=0;
    eBorrar.Vacio:=false;
    eCrear.bCrear:=false;
    eCrear.yCuantas:=0;
    eCrear.yX:=10;

    iDrops:=0;
    lPuntos:=0;
    wNextLevel:=(iSpeed+1)*10;
    iLimite:=Velocidad(iSpeed);
    iTime:=0;

    bPausaPpio:=false;
    bPause:=false;
    bGameOver:=false;

    IniciaPantalla(Pantalla2);
    pPosLista:=ListaPiezas;
    NuevaPieza(eMarcador2,Pantalla2,G);
    Pantalla2:=G.Altura2;
  end;

  bSalir:=false;
end;





procedure SimulaMas(var NE:word; Tiempo1,Tiempo2:longint; var G:tGrabar);
var
  R:integer;
  wNE:word;
  lTpo:longint;

begin

wNE:=NE;
lTpo:=Tiempo1;

while G.Eventos[wNE].Tpo<lTpo do
  if wNE<G.Num then
    wNE:=wNE+1;

repeat

  Simulador(wNE,lTpo,G,R,false,0);

until (lTpo>=Tiempo2);

NE:=wNE;
end;




procedure SimulaMenos(var NE:word; Tiempo:longint; var G:tGrabar);
var
  R:integer;
  wNE:word;
  lTpo:longint;

begin

IniciaSimulador(G);

wNE:=0;
lTpo:=0;

repeat

  Simulador(wNE,lTpo,G,R,false,0);

until (lTpo>=Tiempo);

NE:=wNE;
end;




procedure Repeticion(var G:tGrabar; bNombre:boolean);
var
  NE:word; {N§ evento}
  f:file of tGrabar;
  s:string;
  pAct:tListaPiezas;
  iR:integer;
  Sal:boolean;
  Pause:boolean;
  Veloc:byte; {0=muy lenta, 1=lenta, 2=normal, 3=rapida, 4=muy rapida}
  BarraTpo:integer; {sin usar, barra desplazamiento del Tpo}
  SimTpo:longint;

begin

bRepet:=true;
Pause:=false;

bDeath:=false;
if G.tipo=1 then
  iPlayers:=1
else
  begin
    iPlayers:=2;
    if G.tipo=3 then
      bDeath:=true;
  end;

CargarListaPiezas(ListaPiezas,G);
IniciaSimulador(G);


  {closegraph;
  oldkeyint;
  for NE:=0 to G.Num do
    begin
      write(NE,'->',G.Eventos[NE].tpo,'sg  ',G.Eventos[NE].tecla);
      readln;
    end;
  writeln('fin');
  readln;
  IniciaSVGA256(yModo,'',iError);
  newkeyint;}


{---------------------- SIMULAR REPETICION ----------------------------------}

NE:=0;
lTiempo:=0;
Veloc:=3; {0=muy lenta, 1=lenta, 2=moderada, 3=normal, 4=rapida,
           5=muy rapida, 6=rapidisima}
iR:=0;

repeat

  if not Pause and (lTiempo<=G.Eventos[G.Num-1].Tpo) then
    begin
      case Veloc of
        0: Esperar(400);
        1: Esperar(125);
        2: Esperar(40);
        4: begin
             SimTpo:=lTiempo;
             lTiempo:=lTiempo+2;
             SimulaMas(NE,SimTpo,lTiempo,G);
           end;
        5: begin
             SimTpo:=lTiempo;
             lTiempo:=lTiempo+5;
             SimulaMas(NE,SimTpo,lTiempo,G);
           end;
        6: begin
             SimTpo:=lTiempo;
             lTiempo:=lTiempo+12;
             SimulaMas(NE,SimTpo,lTiempo,G);
           end;
      end;

      Simulador(NE,lTiempo,G,iR,true,Veloc);
    end;


  if KeyDown[InsScan] then Pause:=false;
  if KeyDown[DelScan] then Pause:=true;

  if KeyDown[IniScan] then
    begin
      lTiempo:=0;
      SimulaMenos(NE,lTiempo,G);
      repeat
      until not TeclaPulsada;
    end;
  if KeyDown[FinScan] then
    begin
      SimTpo:=lTiempo;
      lTiempo:=G.Eventos[G.Num-1].Tpo-250;
      if SimTpo<lTiempo then
        SimulaMas(NE,SimTpo,lTiempo,G)
      else
        SimulaMenos(NE,lTiempo,G);
      repeat
      until not TeclaPulsada;
    end;

  if KeyDown[PgUpScan] then
    begin
      lTiempo:=lTiempo-1000;
      if lTiempo<0 then
        lTiempo:=0;
      SimulaMenos(NE,lTiempo,G);
      repeat
      until not TeclaPulsada;
    end;
  if KeyDown[PgDnScan] then
    begin
      SimTpo:=lTiempo;
      lTiempo:=lTiempo+1000;
      if lTiempo>G.Eventos[G.Num-1].Tpo then
        lTiempo:=G.Eventos[G.Num-1].Tpo-100;
      if SimTpo<lTiempo then
        SimulaMas(NE,SimTpo,lTiempo,G)
      else
        SimulaMenos(NE,lTiempo,G);
      repeat
      until not TeclaPulsada;
    end;

  if KeyDown[MenosScan] then
    begin
      if Veloc>0 then
        Veloc:=Veloc-1;
      repeat
      until not TeclaPulsada;
    end;
  if KeyDown[MasScan] then
    begin
      Veloc:=Veloc+1;
      if Veloc>6 then
        Veloc:=6;
      repeat
      until not TeclaPulsada;
    end;

  if KeyDown[AltScan] and KeyDown[ScanOf('X')] then
    begin
      OldKeyInt;
      CloseGraph;
      halt;
    end;

  Depurar;

until KeyDown[EscScan]; {bSalir or (NE>=G.Num) or (G.Eventos[NE].Tecla=13);}


{if NE>=G.Num then
  begin
    closegraph;
    oldkeyint;
    writeln(NE,'->',NE,'   tcl-> ',G.Eventos[NE].tecla);
    writeln('bSalir->',bSalir);
    readln;
    halt;
  end;}


BorrarListaPiezas(ListaPiezas);


if bNombre then
  begin
    OldKeyInt;

    iR:=0;
    Sal:=false;
    repeat

      s:=PedirNombre('Repeticion');

      if s<>'' then
        begin
          {$I-}
          assign(f,s+'.rep');
          reset(f);
          {$I+}
          if IOResult<>0 then
            begin {no existe}
              {$I-}
              rewrite(f);
              {$I+}
              if IOResult=0 then
                begin
                  {$I-}
                  write(f,G);
                  {$I+}
                  if IOResult=0 then
                    Sal:=true;
                  close(f);
                end;
            end
          else
            close(f);
        end
      else
        Sal:=true;

      inc(iR);
    until Sal or (iR>=3);

    NewKeyInt;
  end;


bRepet:=false;
bRepeticion:=false;

end;





procedure ElegirRepeticion;
const
  MaxRep=2000;
type
  tRep=array[0..MaxRep] of string[8];
var
  Dir:SearchRec;
  Rep:tRep;
  NumRep:integer;
  i,j:word;
  f:file of tGrabar;


  procedure DibujaRep(pos,ini:word; var Rep:tRep);
  var
    i1,y:integer;
  begin
    ClsWhere(yFondo,wScreen1);
    y:=1;
    i1:=0;
    while (i1<=19) and (i1<=NumRep) do
      begin
        if ini+i1=pos then
          WriteColorWhere(105,y,-1,Rep[ini+i1],Color83,wScreen1)
        else
          WriteWhere(105,y,15,-1,Rep[ini+i1],wScreen1);
        y:=y+10;
        inc(i1);
      end;
    WaitRetrace;
    flip(wScreen1,SegA000);
  end;


  procedure QuickSort(var A:tRep; Lo,Hi:Integer);

    procedure Sort(l,r:Integer);
    var
      i,j:integer;
      x,y:string;

    begin
      i:=l;
      j:=r;
      x:=a[(l+r) div 2];
      repeat
        while a[i]<x do
          i:=i+1;
        while x<a[j] do
          j:=j-1;
        if i<=j then
          begin
            y:=a[i];
            a[i]:=a[j];
            a[j]:=y;
            i:=i+1;
            j:=j-1;
          end;
      until i>j;
      if l<j then
        Sort(l,j);
      if i<r then
        Sort(i,r);
    end;

  begin {QuickSort};
    Sort(Lo,Hi);
  end;


begin

FindFirst('*.REP',Archive,Dir);
i:=0;
while DosError=0 do
  begin
    Rep[i]:=QuitaExtension(Dir.Name);
    FindNext(Dir);
    inc(i);
  end;
NumRep:=i-1;
if NumRep<0 then
  NumRep:=0;

QuickSort(Rep,0,NumRep); {ordena por nombre}


i:=0; {posic en array del seleccionado}
j:=0; {posic en array del primero de la pantalla}

DibujaRep(i,j,Rep);

repeat
  if KeyDown[UpScan] then
    if i>0 then
      begin
        dec(i);
        if (j>0) and (i<NumRep-10) then
          dec(j);
        DibujaRep(i,j,Rep);
        esperar(80);
      end;

  if KeyDown[DownScan] then
    if i<NumRep then
      begin
        inc(i);
        if (j<NumRep-19) and (i>10) then
          inc(j);
        DibujaRep(i,j,Rep);
        esperar(80);
      end;

  if KeyDown[EntScan] then
    begin
      {$I-}
      assign(f,Rep[i]+'.rep');
      reset(f);
      {$I+}
      if IOResult=0 then
        begin
          {$I-}
          read(f,Grabar^);
          {$I+}
          if IOResult=0 then
            begin
              Repeticion(Grabar^,false);
              repeat
              until not KeyDown[EscScan];
              DibujaRep(i,j,Rep);
            end;
          close(f);
        end;
    end;

until KeyDown[EscScan];

end;





procedure m1Player;
var
  f:file;

begin

Grabar^.Tipo:=1;
Grabar^.NumF:=0;
CrearListaPiezas(ListaPiezas,Grabar^);
bDeath:=false;


with eMarcador1 do
  begin
    iX:=60;
    iY:=15;

    assign(f,'Opciones.dat');
    reset(f,1);
    blockread(f,Tactica,sizeof(tTactica));
    blockread(f,iSpeed,sizeof(iSpeed));
    blockread(f,Altura,sizeof(Altura));
    blockread(f,wLineas,sizeof(wLineas));
    close(f);

    eBorrar.iEstado:=0;
    eBorrar.bBorrar:=false;
    eBorrar.yCuantas:=0;
    eBorrar.Vacio:=false;
    eCrear.bCrear:=false;
    eCrear.yCuantas:=0;
    eCrear.yX:=10;

    iDrops:=0;
    lPuntos:=0;
    wNextLevel:=(iSpeed+1)*10;
    iLimite:=Velocidad(iSpeed);
    iTime:=0;

    bPausaPpio:=false;
    bPause:=false;
    bGameOver:=false;

    IniciaPantalla(Pantalla1);
    pPosLista:=ListaPiezas;
    NuevaPieza(eMarcador1,Pantalla1,Grabar^);
    PonerAltura(eMarcador1,Pantalla1);

    bSalir:=false;

    Grabar^.Opc1.wLineas:=wLineas;
    Grabar^.Opc1.iSpeed:=iSpeed;
    Grabar^.Opc1.Altura:=Altura;
    Grabar^.Opc1.Tactica:=Tactica;

    Grabar^.Altura1:=Pantalla1;

    Grabar^.Num:=0;
    lTiempo:=0;


    repeat

      if not bPause then iTime:=iTime+1;

      ClsWhere(0,wScreen1);
      LimpiarPantalla;

      DibujaFondo(iX,iY,10,wScreen1);
      DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
      DibujaPantalla(eMarcador1,Pantalla1,wScreen1);
      DibujaNext(eMarcador1,wScreen1,Grabar^);
      PonerDatos(eMarcador1,wScreen1);

      if eBorrar.bBorrar then
        BorrarLineas(eMarcador1,Pantalla1,Grabar^,true);

      WaitRetrace;
      Flip(wScreen1,SegA000);


      if WasDown[escScan] then
        bSalir:=true;

      if KeyDown[AltScan] and KeyDown[ScanOf('X')]
      then
        begin
          OldKeyInt;
          CloseGraph;
          halt;
        end;


      if not bPause and WasDown[yPause1]
      then
        begin
          bPause:=true;
          bSoltadaPause:=false;
          Grabacion(Grabar^,lTiempo,6);
          CargarImagenes;
        end;
      if bPause then if not WasDown[yPause1] then bSoltadaPause:=true;
      if bPause and bSoltadaPause and WasDown[yPause1] then
        begin
          bPause:=false;
          Grabacion(Grabar^,lTiempo,6);
        end;


      if (not eBorrar.bBorrar) and (not bPause)
      then
        begin {solo movemos si no hacemos linea}

          if bPausaPpio and (not KeyDown[yDown1])
          then bPausaPpio:=false;

          if bGameOver then GameOver(eMarcador1);


          if WasDown[yLeft1]
          then
            if bIzquierda(ePieza,iPiezaX,iPiezaY,Pantalla1)
            then
              begin
                Grabacion(Grabar^,lTiempo,1);
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaX:=iPiezaX-1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
              end;

          if WasDown[yRight1]
          then
            if bDerecha(ePieza,iPiezaX,iPiezaY,Pantalla1)
            then
              begin
                Grabacion(Grabar^,lTiempo,2);
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaX:=iPiezaX+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
              end;

          if (KeyDown[yDown1]) and (not bPausaPpio)
          then
            begin
              Grabacion(Grabar^,lTiempo,3);
              iTime:=0;
              if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla1)
              then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                  iPiezaY:=iPiezaY+1;
                  iDrops:=iDrops+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                end
              else
                begin
                  lPuntos:=lPuntos+iDrops;
                  if lPuntos>MaxPuntos then lPuntos:=MaxPuntos;
                  iDrops:=0;
                  NuevaPieza(eMarcador1,Pantalla1,Grabar^)
                end;
            end;

          if not KeyDown[yDown1]
          then iDrops:=0;


          if WasDown[yK1]
          then
            begin
              Grabacion(Grabar^,lTiempo,5);
              RotateDer(eMarcador1,Pantalla1);
            end;

          if WasDown[yJ1] or WasDown[yUp1]
          then
            begin
              Grabacion(Grabar^,lTiempo,4);
              RotateIzq(eMarcador1,Pantalla1);
            end;


          if iTime>=iLimite
          then
            begin
              iTime:=0;
              if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla1)
              then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                end
              else
                NuevaPieza(eMarcador1,Pantalla1,Grabar^)
            end;
        end;

      ClearWasDownArray;

      lTiempo:=lTiempo+1;
      if lTiempo>MaxTiempo then
        lTiempo:=MaxTiempo;

      Depurar;

    until bSalir;

  end; (*with eMarcador*)


Grabacion(Grabar^,lTiempo-1,13);

BorrarListaPiezas(ListaPiezas);

if bRepeticion then
  Repeticion(Grabar^,true);

end; (*procedure m1Player*)





procedure m2Player;
var
  f:file;

begin

Grabar^.Tipo:=2;
Grabar^.NumF:=0;
CrearListaPiezas(ListaPiezas,Grabar^);

assign(f,'Opciones.dat');
reset(f,1);

with eMarcador1 do
  begin
    iX:=211;
    iY:=15;

    blockread(f,Tactica,sizeof(tTactica));
    blockread(f,iSpeed,sizeof(iSpeed));
    blockread(f,Altura,sizeof(Altura));
    blockread(f,wLineas,sizeof(wLineas));

    eBorrar.bBorrar:=false;
    eBorrar.iEstado:=0;
    eBorrar.yCuantas:=0;
    eBorrar.Vacio:=false;
    eCrear.bCrear:=false;
    eCrear.yCuantas:=0;
    eCrear.yX:=10;

    iDrops:=0;
    lPuntos:=0;
    wNextLevel:=(iSpeed+1)*10;
    iLimite:=Velocidad(iSpeed);
    iTime:=0;

    bPausaPpio:=false;
    bPause:=false;
    bGameOver:=false;

    IniciaPantalla(Pantalla1);
    pPosLista:=ListaPiezas;
    NuevaPieza(eMarcador1,Pantalla1,Grabar^);
    PonerAltura(eMarcador1,Pantalla1);
  end;


with eMarcador2 do
  begin
    iX:=0;
    iY:=15;

    blockread(f,Tactica,sizeof(tTactica));
    blockread(f,iSpeed,sizeof(iSpeed));
    blockread(f,Altura,sizeof(Altura));
    blockread(f,wLineas,sizeof(wLineas));

    eBorrar.bBorrar:=false;
    eBorrar.iEstado:=0;
    eBorrar.yCuantas:=0;
    eBorrar.Vacio:=false;
    eCrear.bCrear:=false;
    eCrear.yCuantas:=0;
    eCrear.yX:=10;

    iDrops:=0;
    lPuntos:=0;
    wNextLevel:=(iSpeed+1)*10;
    iLimite:=Velocidad(iSpeed);
    iTime:=0;

    bPausaPpio:=false;
    bPause:=false;
    bGameOver:=false;

    IniciaPantalla(Pantalla2);
    pPosLista:=ListaPiezas;
    NuevaPieza(eMarcador2,Pantalla2,Grabar^);
    PonerAltura(eMarcador2,Pantalla2);
  end;

close(f);
bSalir:=false;

with eMarcador1 do
  begin
    Grabar^.Opc1.wLineas:=wLineas;
    Grabar^.Opc1.iSpeed:=iSpeed;
    Grabar^.Opc1.Altura:=Altura;
    Grabar^.Opc1.Tactica:=Tactica;
  end;
with eMarcador2 do
  begin
    Grabar^.Opc2.wLineas:=wLineas;
    Grabar^.Opc2.iSpeed:=iSpeed;
    Grabar^.Opc2.Altura:=Altura;
    Grabar^.Opc2.Tactica:=Tactica;
  end;

Grabar^.Altura1:=Pantalla1;
Grabar^.Altura2:=Pantalla2;

Grabar^.Num:=0;
lTiempo:=0;


repeat

  if not eMarcador1.bPause then eMarcador1.iTime:=eMarcador1.iTime+1;
  if not eMarcador2.bPause then eMarcador2.iTime:=eMarcador2.iTime+1;


  ClsWhere(0,wScreen1);
  LimpiarPantallas;

  with eMarcador1 do
    begin
      DibujaFondo(iX,iY,10,wScreen1);
      DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
      DibujaPantalla(eMarcador1,Pantalla1,wScreen1);

      if eBorrar.bBorrar then
        BorrarLineas(eMarcador1,Pantalla1,Grabar^,true);
    end;

  with eMarcador2 do
    begin
      DibujaFondo(iX,iY,10,wScreen1);
      DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
      DibujaPantalla(eMarcador2,Pantalla2,wScreen1);

      if eBorrar.bBorrar then
        BorrarLineas(eMarcador2,Pantalla2,Grabar^,true);
    end;

  DibujaNext2(eMarcador1,eMarcador2,wScreen1,Grabar^);
  PonerDatos2(eMarcador1,eMarcador2,wScreen1);

  WaitRetrace;
  Flip(wScreen1,SegA000);


  if WasDown[escScan] then
    bSalir:=true;

  if KeyDown[AltScan] and KeyDown[ScanOf('X')]
  then
    begin
      OldKeyInt;
      CloseGraph;
      halt;
    end;


  with eMarcador1 do
    begin
      if not bPause and WasDown[yPause1] then
        begin
          bPause:=true;
          bSoltadaPause:=false;
          Grabacion(Grabar^,lTiempo,6);
          CargarImagenes;
        end;
      if bPause then if not WasDown[yPause1] then bSoltadaPause:=true;
      if bPause and bSoltadaPause and WasDown[yPause1] then
        begin
          bPause:=false;
          Grabacion(Grabar^,lTiempo,6);
        end;
      if bGameOver and not bSalir then GameOver(eMarcador1);
    end;


  with eMarcador2 do
    begin
      if not bPause and WasDown[yPause2] then
        begin
          bPause:=true;
          bSoltadaPause:=false;
          Grabacion(Grabar^,lTiempo,12);
          CargarImagenes;
        end;
      if bPause then if not WasDown[yPause2] then bSoltadaPause:=true;
      if bPause and bSoltadaPause and WasDown[yPause2] then
        begin
          bPause:=false;
          Grabacion(Grabar^,lTiempo,12);
        end;
      if bGameOver and not bSalir then GameOver(eMarcador2);
    end;


  if not eMarcador1.bGameOver then
  with eMarcador1 do
   if (not eBorrar.bBorrar) and (not bPause)
   then
    begin {solo movemos si no hacemos linea}

      if eMarcador1.bPausaPpio and (not KeyDown[yDown1])
      then
        begin
          eMarcador1.bPausaPpio:=false;
        end;


      if WasDown[yLeft1]
      then
        begin
          if bIzquierda(ePieza,iPiezaX,iPiezaY,Pantalla1)
          then
            begin
              Grabacion(Grabar^,lTiempo,1);
              BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
              iPiezaX:=iPiezaX-1;
              DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
            end;
        end;

      if WasDown[yRight1]
      then
        begin
          if bDerecha(ePieza,iPiezaX,iPiezaY,Pantalla1)
          then
            begin
              Grabacion(Grabar^,lTiempo,2);
              BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
              iPiezaX:=iPiezaX+1;
              DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
            end;
        end;

      if (KeyDown[yDown1]) and (not bPausaPpio)
      then
        begin
          Grabacion(Grabar^,lTiempo,3);
          iTime:=0;
          if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla1)
          then
            begin
              BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
              iPiezaY:=iPiezaY+1;
              iDrops:=iDrops+1;
              DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
            end
          else
            begin
              lPuntos:=lPuntos+iDrops;
              if lPuntos>MaxPuntos then lPuntos:=MaxPuntos;
              iDrops:=0;
              NuevaPieza(eMarcador1,Pantalla1,Grabar^)
            end;
        end;

      if not KeyDown[yDown1]
      then
        begin
          iDrops:=0;
        end;


      if WasDown[yK1]
      then
        begin
          Grabacion(Grabar^,lTiempo,5);
          RotateDer(eMarcador1,Pantalla1);
        end;

      if WasDown[yJ1] or WasDown[yUp1]
      then
        begin
          Grabacion(Grabar^,lTiempo,4);
          RotateIzq(eMarcador1,Pantalla1);
        end;


      if iTime>=iLimite
      then
        begin
          iTime:=0;
          if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla1)
          then
            begin
              BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
              iPiezaY:=iPiezaY+1;
              DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
            end
          else
            begin
              NuevaPieza(eMarcador1,Pantalla1,Grabar^)
            end;
        end;
    end;


  { ----- +++++ ----- }


  if not eMarcador2.bGameOver then
  with eMarcador2 do
   if (not eBorrar.bBorrar) and (not bPause)
   then
    begin {solo movemos si no hacemos linea}

      if eMarcador2.bPausaPpio and (not KeyDown[yDown2])
      then
        begin
          eMarcador2.bPausaPpio:=false;
        end;


      if WasDown[yLeft2]
      then
        begin
          if bIzquierda(ePieza,iPiezaX,iPiezaY,Pantalla2)
          then
            begin
              Grabacion(Grabar^,lTiempo,7);
              BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
              iPiezaX:=iPiezaX-1;
              DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
            end;
        end;

      if WasDown[yRight2]
      then
        begin
          if bDerecha(ePieza,iPiezaX,iPiezaY,Pantalla2)
          then
            begin
              Grabacion(Grabar^,lTiempo,8);
              BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
              iPiezaX:=iPiezaX+1;
              DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
            end;
        end;

      if (KeyDown[yDown2]) and (not bPausaPpio)
      then
        begin
          Grabacion(Grabar^,lTiempo,9);
          iTime:=0;
          if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla2)
          then
            begin
              BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
              iPiezaY:=iPiezaY+1;
              iDrops:=iDrops+1;
              DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
            end
          else
            begin
              lPuntos:=lPuntos+iDrops;
              if lPuntos>MaxPuntos then lPuntos:=MaxPuntos;
              iDrops:=0;
              NuevaPieza(eMarcador2,Pantalla2,Grabar^)
            end;
        end;

      if not KeyDown[yDown2]
      then
        begin
          iDrops:=0;
        end;


      if WasDown[yK2]
      then
        begin
          Grabacion(Grabar^,lTiempo,11);
          RotateDer(eMarcador2,Pantalla2);
        end;

      if WasDown[yJ2] or WasDown[yUp2]
      then
        begin
          Grabacion(Grabar^,lTiempo,10);
          RotateIzq(eMarcador2,Pantalla2);
        end;


      if iTime>=iLimite
      then
        begin
          iTime:=0;
          if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla2)
          then
            begin
              BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
              iPiezaY:=iPiezaY+1;
              DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
            end
          else
            begin
              NuevaPieza(eMarcador2,Pantalla2,Grabar^)
            end;
        end;
    end;

  ClearWasDownArray;

  lTiempo:=lTiempo+1;
  if lTiempo>MaxTiempo then
    lTiempo:=MaxTiempo;

  Depurar;

until bSalir;


Grabacion(Grabar^,lTiempo-1,13);

BorrarListaPiezas(ListaPiezas);

if bRepeticion then
  Repeticion(Grabar^,true);

end; (*procedure m2Player*)





procedure CargarOpciones;
var
  f:file;

begin
  assign(f,'Opciones.dat');
  reset(f,1);

  with eMarcador1 do
    begin
      iX:=211;
      iY:=15;

      blockread(f,Tactica,sizeof(tTactica));
      blockread(f,iSpeed,sizeof(iSpeed));
      blockread(f,Altura,sizeof(Altura));
      blockread(f,wLineas,sizeof(wLineas));

      eBorrar.bBorrar:=false;
      eBorrar.iEstado:=0;
      eBorrar.yCuantas:=0;
      eBorrar.Vacio:=false;
      eCrear.bCrear:=false;
      eCrear.yCuantas:=0;
      eCrear.yX:=10;

      iDrops:=0;
      lPuntos:=0;
      wLineas:=100; {‡}
      wNextLevel:=(iSpeed+1)*10;
      iLimite:=Velocidad(iSpeed);
      iTime:=0;

      bPausaPpio:=false;
      bPause:=false;
      bGameOver:=false;

      IniciaPantalla(Pantalla1);
      pPosLista:=ListaPiezas;
      NuevaPieza(eMarcador1,Pantalla1,Grabar^);
      PonerAltura(eMarcador1,Pantalla1);
    end;

  with eMarcador2 do
    begin
      iX:=0;
      iY:=15;

      blockread(f,Tactica,sizeof(tTactica));
      blockread(f,iSpeed,sizeof(iSpeed));
      blockread(f,Altura,sizeof(Altura));
      blockread(f,wLineas,sizeof(wLineas));

      eBorrar.bBorrar:=false;
      eBorrar.iEstado:=0;
      eBorrar.yCuantas:=0;
      eBorrar.Vacio:=false;
      eCrear.bCrear:=false;
      eCrear.yCuantas:=0;
      eCrear.yX:=10;

      iDrops:=0;
      lPuntos:=0;
      wLineas:=100; {‡}
      wNextLevel:=(iSpeed+1)*10;
      iLimite:=Velocidad(iSpeed);
      iTime:=0;

      bPausaPpio:=false;
      bPause:=false;
      bGameOver:=false;

      IniciaPantalla(Pantalla2);
      pPosLista:=ListaPiezas;
      NuevaPieza(eMarcador2,Pantalla2,Grabar^);
      PonerAltura(eMarcador2,Pantalla2);
    end;

  close(f);
  bSalir:=false;
end;





procedure m2PlayerDeath(var bEnter:boolean);
var
  bCeroCero,b:boolean;

begin
yWin1:=0;
yWin2:=0;

bEnter:=false;
bCeroCero:=false;
IniciaEstad;

repeat

  if ((yWin1<>0) or (yWin2<>0)) or bCeroCero then
    begin
      b:=VerWinDeath(yWin1,yWin2,yWinDeath);
      if not b then {pulsar Esc}
        exit;
    end;

  if yWin1>=yWinDeath then
    begin
      VerGanadorDeath(eMarcador1.Nombre,bEnter);
      exit;
    end;
  if yWin2>=yWinDeath then
    begin
      VerGanadorDeath(eMarcador2.Nombre,bEnter);
      exit;
    end;


  Grabar^.Tipo:=3;
  Grabar^.NumF:=0;
  CrearListaPiezas(ListaPiezas,Grabar^);

  CargarOpciones;

  with eMarcador1 do
    begin
      Grabar^.Opc1.wLineas:=wLineas;
      Grabar^.Opc1.iSpeed:=iSpeed;
      Grabar^.Opc1.Altura:=Altura;
      Grabar^.Opc1.Tactica:=Tactica;
    end;
  with eMarcador2 do
    begin
      Grabar^.Opc2.wLineas:=wLineas;
      Grabar^.Opc2.iSpeed:=iSpeed;
      Grabar^.Opc2.Altura:=Altura;
      Grabar^.Opc2.Tactica:=Tactica;
    end;

  Grabar^.Altura1:=Pantalla1;
  Grabar^.Altura2:=Pantalla2;

  Grabar^.Num:=0;
  lTiempo:=0;


  repeat

    if not eMarcador1.bPause then eMarcador1.iTime:=eMarcador1.iTime+1;
    if not eMarcador2.bPause then eMarcador2.iTime:=eMarcador2.iTime+1;

    ClsWhere(0,wScreen1);
    LimpiarPantallas;

    with eMarcador1 do
      begin
        DibujaFondo(iX,iY,10,wScreen1);
        DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
        DibujaPantalla(eMarcador1,Pantalla1,wScreen1);

        if eBorrar.bBorrar then
          BorrarLineas(eMarcador1,Pantalla1,Grabar^,true);
      end;

    with eMarcador2 do
      begin
        DibujaFondo(iX,iY,10,wScreen1);
        DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
        DibujaPantalla(eMarcador2,Pantalla2,wScreen1);

        if eBorrar.bBorrar then
          BorrarLineas(eMarcador2,Pantalla2,Grabar^,true);
      end;

    DibujaNext2(eMarcador1,eMarcador2,wScreen1,Grabar^);
    PonerDatos2(eMarcador1,eMarcador2,wScreen1);

    WaitRetrace;
    Flip(wScreen1,SegA000);


    if WasDown[escScan] then
      begin
        bSalir:=true;
        if (yWin1=0) and (yWin2=0) then
          bCeroCero:=true
        else
          bCeroCero:=false;
      end;

    if KeyDown[AltScan] and KeyDown[ScanOf('X')]
    then
      begin
        OldKeyInt;
        CloseGraph;
        halt;
      end;


    with eMarcador1 do
      begin
        if not bPause and WasDown[yPause1] then
          begin
            bPause:=true;
            bSoltadaPause:=false;
            Grabacion(Grabar^,lTiempo,6);
            CargarImagenes;
          end;
        if bPause then if not WasDown[yPause1] then bSoltadaPause:=true;
        if bPause and bSoltadaPause and WasDown[yPause1] then
          begin
            bPause:=false;
            Grabacion(Grabar^,lTiempo,6);
          end;

        if bGameOver and not bSalir then GameOver(eMarcador1);
      end;


    with eMarcador2 do
      begin
        if not bPause and WasDown[yPause2] then
          begin
            bPause:=true;
            bSoltadaPause:=false;
            Grabacion(Grabar^,lTiempo,12);
            CargarImagenes;
          end;
        if bPause then if not WasDown[yPause2] then bSoltadaPause:=true;
        if bPause and bSoltadaPause and WasDown[yPause2] then
          begin
            bPause:=false;
            Grabacion(Grabar^,lTiempo,12);
          end;

        if bGameOver and not bSalir then GameOver(eMarcador2);
      end;


    if not eMarcador1.bGameOver then
    with eMarcador1 do
     if (not eBorrar.bBorrar) and (not bPause)
     then
      begin {solo movemos si no hacemos linea}

        if eMarcador1.bPausaPpio and (not KeyDown[yDown1])
        then
          begin
            eMarcador1.bPausaPpio:=false;
          end;


        if WasDown[yLeft1]
        then
          begin
            if bIzquierda(ePieza,iPiezaX,iPiezaY,Pantalla1)
            then
              begin
                Grabacion(Grabar^,lTiempo,1);
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaX:=iPiezaX-1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
              end;
          end;

        if WasDown[yRight1]
        then
          begin
            if bDerecha(ePieza,iPiezaX,iPiezaY,Pantalla1)
            then
              begin
                Grabacion(Grabar^,lTiempo,2);
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaX:=iPiezaX+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
              end;
          end;

        if (KeyDown[yDown1]) and (not bPausaPpio)
        then
          begin
            Grabacion(Grabar^,lTiempo,3);
            iTime:=0;
            if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla1)
            then
              begin
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaY:=iPiezaY+1;
                iDrops:=iDrops+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1); {cambio, ver ppio programa}
              end
            else
              begin
                lPuntos:=lPuntos+iDrops;
                if lPuntos>MaxPuntos then lPuntos:=MaxPuntos;
                iDrops:=0;
                NuevaPieza(eMarcador1,Pantalla1,Grabar^)
              end;
          end;

        if not KeyDown[yDown1]
        then
          begin
            iDrops:=0;
          end;


        if WasDown[yK1]
        then
          begin
            Grabacion(Grabar^,lTiempo,5);
            RotateDer(eMarcador1,Pantalla1);
          end;

        if WasDown[yJ1] or WasDown[yUp1]
        then
          begin
            Grabacion(Grabar^,lTiempo,4);
            RotateIzq(eMarcador1,Pantalla1);
          end;


        if iTime>=iLimite
        then
          begin
            iTime:=0;
            if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla1)
            then
              begin
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
                iPiezaY:=iPiezaY+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla1);
              end
            else
              begin
                NuevaPieza(eMarcador1,Pantalla1,Grabar^)
              end;
          end;
      end;


    { ----- +++++ ----- }


    if not eMarcador2.bGameOver then
    with eMarcador2 do
     if (not eBorrar.bBorrar) and (not bPause)
     then
      begin {solo movemos si no hacemos linea}

        if eMarcador2.bPausaPpio and (not KeyDown[yDown2])
        then
          begin
            eMarcador2.bPausaPpio:=false;
          end;


        if WasDown[yLeft2]
        then
          begin
            if bIzquierda(ePieza,iPiezaX,iPiezaY,Pantalla2)
            then
              begin
                Grabacion(Grabar^,lTiempo,7);
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                iPiezaX:=iPiezaX-1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
              end;
          end;

        if WasDown[yRight2]
        then
          begin
            if bDerecha(ePieza,iPiezaX,iPiezaY,Pantalla2)
            then
              begin
                Grabacion(Grabar^,lTiempo,8);
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                iPiezaX:=iPiezaX+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
              end;
          end;

        if (KeyDown[yDown2]) and (not bPausaPpio)
        then
          begin
            Grabacion(Grabar^,lTiempo,9);
            iTime:=0;
            if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla2)
            then
              begin
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                iPiezaY:=iPiezaY+1;
                iDrops:=iDrops+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
              end
            else
              begin
                lPuntos:=lPuntos+iDrops;
                if lPuntos>MaxPuntos then lPuntos:=MaxPuntos;
                iDrops:=0;
                NuevaPieza(eMarcador2,Pantalla2,Grabar^)
              end;
          end;

        if not KeyDown[yDown2]
        then
          begin
            iDrops:=0;
          end;


        if WasDown[yK2]
        then
          begin
            Grabacion(Grabar^,lTiempo,11);
            RotateDer(eMarcador2,Pantalla2);
          end;

        if WasDown[yJ2] or WasDown[yUp2]
        then
          begin
            Grabacion(Grabar^,lTiempo,10);
            RotateIzq(eMarcador2,Pantalla2);
          end;


        if iTime>=iLimite
        then
          begin
            iTime:=0;
            if bAbajo(ePieza,iPiezaX,iPiezaY,Pantalla2)
            then
              begin
                BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla2);
                iPiezaY:=iPiezaY+1;
                DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla2); {cambio, ver ppio programa}
              end
            else
              begin
                NuevaPieza(eMarcador2,Pantalla2,Grabar^)
              end;
          end;
      end;

    ClearWasDownArray;

    lTiempo:=lTiempo+1;
    if lTiempo>MaxTiempo then
      lTiempo:=MaxTiempo;

    Depurar;

  until bSalir;


  Grabacion(Grabar^,lTiempo-1,13);

  BorrarListaPiezas(ListaPiezas);

  if bRepeticion then
    Repeticion(Grabar^,true);

until false;

end; (*procedure m2PlayerDeath*)







begin {*****************************   PPAL   ******************************}

iSombras:=0; {Velocidad ensombrecimiento}
yModo:=0;


CPU:=CalculaCPU;



{IniciaSVGA256(0,'',iError);
LoadPaleta(Paleta,'rtetris.pal','',iError);
GetPalPcx('rtetris.pcx','',Paleta,iError);
SetPaleta(Paleta);
x:=1;
y:=1;
for i:=0 to 125 do
  begin
    str(i,s);
    WriteWhere(x,y,i,-1,s,segA000);
    x:=x+30;
    if x>=300 then
      begin
        x:=1;
        y:=y+10;
      end;
  end;
readln;
x:=1;
y:=1;
clswhere(0,sega000);
for i:=126 to 255 do
  begin
    str(i,s);
    WriteWhere(x,y,i,-1,s,segA000);
    x:=x+30;
    if x>=300 then
      begin
        x:=1;
        y:=y+10;
      end;
  end;
readln;
closegraph;}



IniciaSVGA256(yModo,'',iError);
if iError<>0 then
  begin
    readln;
    ClrScr;
    Write('Error: ');
    Writeln(iError);
    readln;
    Halt;
  end;
SetColor(15);


LoadPaleta(Paleta,'rtetris.pal','',iError);
SetPaleta(Paleta);


yFondo:=46; {46, el rojo del fondo de las pantallas}

for iCol8:=0 to 7 do
  Color81[iCol8]:=95+iCol8;
for iCol8:=0 to 7 do
  Color82[iCol8]:=128+iCol8;
for iCol8:=0 to 7 do
  Color83[iCol8]:=64+iCol8; {61-73}


mRecords;
mOpciones;

CargarImagenes;


yJ1:=ScanOf('.');
yK1:=CtrlScan;
yRight1:=RightScan;
yLeft1:=LeftScan;
yDown1:=DownScan;
yUp1:=UpScan;
yPause1:=F12Scan;

yJ2:=ScanOf('a');
yK2:=ScanOf(' ');
yRight2:=ScanOf('h');
yLeft2:=ScanOf('f');
yDown2:=ScanOf('g');
yUp2:=ScanOf('t');
yPause2:=F1Scan;

yRepet:=EntScan;
bRepet:=false;

bMenu:=false;
bDepurar:=false;


wScreen1:=CrearPantalla;
wScreen2:=CrearPantalla2;

GetMem(Grabar,SizeOf(tGrabar));

eMarcador1.Nombre:=NombreJug1;
eMarcador2.Nombre:=NombreJug2;


Presentacion;

NewKeyInt;


repeat

  if VerRecords then
    ElegirRepeticion

  else
    if Menu then
      begin

        GetPaleta(Paleta);
        PonSombras(0,0,0,iSombras);
        ClsWhere(0,SegA000);
        QuitaSombras(Paleta,iSombras);

        if iPlayers=1 then
          m1Player
        else
          if bDeath then
            repeat
              m2PlayerDeath(bEnt);
            until not bEnt
          else
            m2Player;

      end
    else
      NewKeyInt;

until bMenu;


FreeMem(Grabar,SizeOf(tGrabar));


OldKeyInt;
CloseGraph;


end.


