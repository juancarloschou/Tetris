unit Piezas;


interface


uses dos,imagen,teclas;


CONST

{NombreJug1='Rafa';
NombreJug2='Chou';}
NombreJug1='Jugador1';
NombreJug2='Jugador2';
MaxLongNombre=16;
MaxPuntos=999999999; {1000 M}
MaxLineas=99999; {100 K}
MaxTetrisLineas=15; {Lineas que se hacen a la vez}
sTextoInicio='   CHOU TETRIS. Juan Carlos P‚rez Casal. 2003.   ';
{sTextoInicio='  ­RAFA!   KURRATE UN PORRO PERO YA!!!  ';}
MaxEventos=12000; {5000-12000}
MaxFichas=4000;   {1000-4500}
MaxTiempo=2147483640;
MaxTipoFichas=17;
MaxCuadColor=64;
MaxLineasDeath=100;



TYPE

tPieza=record
         tipo:byte;
         color:byte;
         rotate:1..4;
       end;
tPantalla=array[-1..12,-7..20] of byte; {1..10,-7..17 validos}

tpNodo=^tNodo;
tNodo=record
        Pieza:byte;
        siguiente:tpNodo;
      end;
tlistaPiezas=tpNodo;

tVirtualPointer= ^tPantalla;
tVirtualScreen2=Array [1..3200] of byte;
tVirtualPointer2= ^tVirtualScreen2;

tPuntos=0..MaxPuntos;
tLineas=-20..MaxLineas;
tRecords=array[1..15] of
           record
             Nombre:string[MaxLongNombre];
             lPuntos:tPuntos;
             wLineas:tLineas;
           end;
tBorrarLineas=record
                bBorrar:boolean; {dice si hay que borrar alguna}
                iEstado:integer;
                yCuantas:byte; {cuantas lineas 1-10}
                aCual:array [1..MaxTetrisLineas] of byte; {cuales lineas}
                Vacio:boolean; {si vaciamos la pant al hacer lineas}
              end;
tCrearLineas=record
               bCrear:boolean; {dice si hay que crear alguna}
               yCuantas:byte; {cuantas lineas 1-25, se acumulan}
               yX:byte; {donde esta el hueco}
             end;
tDeshazLineas=record
                bDeshaz:boolean; {dice si hay que deshacer alguna}
                iEstado:integer;
                Tipo:byte; {1->Todo un color, 2->CuadColor}
                Color:byte; {tipo 1}
                Vacio:boolean; {si vaciamos la pant al hacer lineas SIN USAR???}
              end;
tCoord=record
         x:integer;
         y:integer;
       end;
tCuadColor=record {cuadrado de 4*4 o 5*5 del mismo color (8*8 verdes)}
               {bCuad:boolean;}
               Tipo:byte; {4,5,8}
               Color:byte;
               yCuantas:byte; {cuantos ptos se borran 16,25,64}
               aCual:array [1..MaxCuadColor] of tCoord; {cuales ptos}
               {Vacio:boolean; {SIN USAR???!!!}
             end;
tTactica=array [1..4] of byte; {cuanto manda cada linea}
tMarcador=record
            Nombre:string[8];
            Alias:string[MaxLongNombre];
            lPuntos:tPuntos;
            wLineas:tLineas;
            wNextLevel:word;
            iSpeed:integer;
            iTime:integer;
            iLimite:integer;
            bPausaPpio:boolean;
            bPause:boolean;
            bSoltadaPause:boolean;
            bGameOver:boolean;
            iDrops:integer;
            iX,iY:integer;
            ePieza:tPieza;
            iPiezaX,iPiezaY:integer;
            pPosLista:tListaPiezas;
            eBorrar:tBorrarLineas;
            eCrear:tCrearLineas;
            eDeshaz:tDeshazLineas;
            eCuad:tCuadColor;
            Tactica:tTactica;
            Altura:byte;
          end;

tEventos=record
           Tpo:longint;
           Tecla:byte; {1=izq1,der1,3=aba1,arr1,giro1,6=pausa1
                        7=izq2,der2,9=aba2,arr2,giro2,12=pausa2,13=final}
         end;
tOpciones=record
            wLineas:tLineas;
            iSpeed:integer;
            Altura:byte;
            Tactica:tTactica;
          end;
tGrabar=record
          Tipo:byte; {1->1 jug, 2->2 jug, 3->death}
          Eventos:array[0..MaxEventos] of tEventos;
          Num:word; {eventos}
          Fichas:array[0..MaxFichas] of byte;
          NumF:word; {fichas}
          Opc1:tOpciones;
          Opc2:tOpciones;
          Altura1:tPantalla;
          Altura2:tPantalla;
        end;

tEstadJug=record
            Mandar:word; {lineas mandadas}
            Mejor:byte; {mejor ataque no deshacer}
            DesHaz:word; {ptos deshechos}
            MejorDes:word; {mejor ataque deshacer}
          end;
tEstadisticas=record
                Jug:array[1..2] of tEstadJug;
                Tot:array[1..2] of tEstadJug;
              end;



VAR

Color81,Color82,Color83:tColor8;
iCol8:integer;

iError:integer;
yModo:byte;
CPU:real;

VirtualScreen1:tVirtualPointer;
wScreen1:word;
VirtualScreen2:tVirtualPointer2;
wScreen2:word;

iPlayers:integer; {1-2 jugadores}
bDeath:boolean; {normal-death mode}
yWinDeath:byte; {en el death, N§ victorias para ganar}
yWin1,yWin2:byte; {victorias que llevan los jugadores}
yFondo:byte; {color fondo rojizo}
Pantalla1:tPantalla;
Pantalla2:tPantalla;
eMarcador1:tMarcador;
eMarcador2:tMarcador;
{iNivel1:integer;
iNivel2:integer;}
bMenu:boolean;
bSalir:boolean;
ListaPiezas:tListaPiezas;
iSombras:integer;
Pieza1,Pieza2,Pieza3,Pieza4,Pieza5,Pieza6,Pieza7:tImagen;
Pieza11,Pieza12,Pieza13,Pieza14,Pieza15,Pieza16,Pieza17:tImagen;
Pieza8,Pieza10,Pieza20,Pieza21,Pieza22,Pieza23,Pieza24:tImagen;
Paleta:tPaleta;
yk1,yJ1,yUp1,yDown1,yRight1,yLeft1,yPause1:byte;
yk2,yJ2,yUp2,yDown2,yRight2,yLeft2,yPause2:byte;
yRepet:byte;
lTiempo:longint;
Records:tRecords;
bRepeticion:boolean; {si el usuario elige ver repet}
bRepet:boolean; {si se esta ejecutando una repet}
bDepurar:boolean; {si pulsas ­ pone mas datos en pant}
Grabar:^tGrabar;
Estad:tEstadisticas;
bEnt:boolean; {si pulsas enter durante la puesta de sol se repite la partida}
TipoFichas:byte; {En las opciones eliges el tipo de fichas que salen}
b00:boolean; {no tiene uso pero hace falta (bCeroCero)}





function CreaPieza:byte;
function CrearPantalla2:word;
function CalculaCPU:real;
procedure DatosPieza(var ePieza:tPieza; var iPiezaX:integer);
procedure DibujaPieza(ePieza:tPieza; iX,iY:integer; var Pantalla:tPantalla);
procedure BorraPieza(ePieza:tPieza; iX,iY:integer; var Pantalla:tPantalla);
function bMiraPieza(ePieza:tPieza; iX,iY:integer; var Pantalla:tPantalla):boolean;
function bDerecha(ePieza:tPieza; iX,iY:integer; Pantalla:tPantalla):boolean;
function bIzquierda(ePieza:tPieza; iX,iY:integer; Pantalla:tPantalla):boolean;
function bAbajo(ePieza:tPieza; iX,iY:integer; Pantalla:tPantalla):boolean;
procedure RotateDer(var eMarcador:tMarcador; var Pantalla:tPantalla);
procedure RotateIzq(var eMarcador:tMarcador; var Pantalla:tPantalla);





implementation





function CreaPieza:byte;
var
  i,Pza:byte;

begin

if KeyDown[ScanOf('d')] and KeyDown[ScanOf('j')] then
  Pza:=12
else

{0=Aleat,1=Muy facil,2=Facil,3=Moderado,4=Normal,5=Dificil,6=Muy Dif,
 7=Imposible,8=Clasico,9=Pocas fic,10=Bastantes,11=Muchas,12=Todas,
 13=Largas,14=Largas Mazo,15=Cuadrados,16=Eles,17=Piramides}

case TipoFichas of
  1: {Muy Facil}
     if random(8)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(5)=0 then
         if random(3)>0 then
           if random(3)>0 then
             Pza:=12 {larga 10}
           else
             Pza:=11 {larga 8}
         else
           Pza:=9 {larga 6}
       else
         if random(55)=0 then
           Pza:=13 {estrella}
         else
           if random(40)=0 then
             Pza:=14 {L grande}
           else
             if random(5)=0 then
               Pza:=1 {larga 4}
             else
               Pza:=random(6)+2; {resto}
  2: {Facil}
     if random(10)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(6)=0 then
         if random(3)>0 then
           if random(2)=0 then
             Pza:=12 {larga 10}
           else
             Pza:=11 {larga 8}
         else
           Pza:=9 {larga 6}
       else
         if random(40)=0 then
           Pza:=13 {estrella}
         else
           if random(25)=0 then
             Pza:=14 {L grande}
           else
             if random(5)=0 then
               Pza:=1 {larga 4}
             else
               Pza:=random(6)+2; {resto}
  3: {Moderado}
     if random(11)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(7)=0 then
         if random(25)=0 then
           Pza:=8 {gran Cuadrado}
         else
           if random(2)=0 then
             if random(2)=0 then
               Pza:=12 {larga 10}
             else
               Pza:=11 {larga 8}
           else
             Pza:=9 {larga 6}
       else
         if random(25)=0 then
           Pza:=13 {estrella}
         else
           if random(20)=0 then
             Pza:=14 {L grande}
           else
             if random(5)=0 then
               Pza:=1 {larga 4}
             else
               Pza:=random(6)+2; {resto}
  4: {Normal}
     if random(13)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(7)=0 then
         if random(16)=0 then
           Pza:=8 {gran Cuadrado}
         else
           if random(2)=0 then
             if random(3)=0 then
               Pza:=12 {larga 10}
             else
               Pza:=11 {larga 8}
           else
             Pza:=9 {larga 6}
       else
         if random(19)=0 then
           Pza:=13 {estrella}
         else
           if random(16)=0 then
             Pza:=14 {L grande}
           else
             if random(5)=0 then
               Pza:=1 {larga 4}
             else
               Pza:=random(6)+2; {resto}
  5: {Dificil}
     if random(16)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(8)=0 then
         if random(10)=0 then
           Pza:=8 {gran Cuadrado}
         else
           if random(3)=0 then
             if random(3)=0 then
               Pza:=12 {larga 10}
             else
               Pza:=11 {larga 8}
           else
             Pza:=9 {larga 6}
       else
         if random(14)=0 then
           Pza:=13 {estrella}
         else
           if random(12)=0 then
             Pza:=14 {L grande}
           else
             if random(6)=0 then
               Pza:=1 {larga 4}
             else
               Pza:=random(6)+2; {resto}
  6: {Muy Dificil}
     if random(22)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(10)=0 then
         if random(5)=0 then
           Pza:=8 {gran Cuadrado}
         else
           if random(3)=0 then
             if random(4)=0 then
               Pza:=12 {larga 10}
             else
               Pza:=11 {larga 8}
           else
             Pza:=9 {larga 6}
       else
         if random(10)=0 then
           Pza:=13 {estrella}
         else
           if random(8)=0 then
             Pza:=14 {L grande}
           else
             if random(8)=0 then
               Pza:=1 {larga 4}
             else
               Pza:=random(6)+2; {resto}
  7: {Imposible}
     if random(30)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(11)=0 then
         Pza:=8 {gran Cuadrado}
       else
         if random(13)=0 then
           if random(4)=0 then
             if random(4)=0 then
               Pza:=12 {larga 10}
             else
               Pza:=11 {larga 8}
           else
             Pza:=9 {larga 6}
         else
           if random(7)=0 then
             Pza:=13 {estrella}
           else
             if random(6)=0 then
               Pza:=14 {L grande}
             else
               if random(15)=0 then
                 Pza:=1 {larga 4}
               else
                 Pza:=random(6)+2; {resto}
  8: {Clasico}
     if random(5)=0 then
       Pza:=1 {larga 4}
     else
       Pza:=random(6)+2; {resto}
  9: {Pocas Fichas}
     if random(7)=0 then
       if random(2)=0 then
         Pza:=11 {larga 8}
       else
         Pza:=9 {larga 6}
     else
       if random(5)=0 then
         Pza:=1 {larga 4}
       else
         Pza:=random(6)+2; {resto}
  10: {Bastantes}
     if random(13)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(7)=0 then
         if random(2)=0 then
           if random(3)=0 then
             Pza:=12 {larga 10}
           else
             Pza:=11 {larga 8}
         else
           Pza:=9 {larga 6}
       else
         if random(5)=0 then
           Pza:=1 {larga 4}
         else
           Pza:=random(6)+2; {resto}
  11: {Muchas}
     if random(13)=0 then
       Pza:=10 {punto multicolor}
     else
       if random(7)=0 then
         if random(16)=0 then
           Pza:=8 {gran Cuadrado}
         else
           if random(2)=0 then
             if random(3)=0 then
               Pza:=12 {larga 10}
             else
               Pza:=11 {larga 8}
           else
             Pza:=9 {larga 6}
       else
         if random(5)=0 then
           Pza:=1 {larga 4}
         else
           Pza:=random(6)+2; {resto}
  12: {Todas}
      Pza:=random(14)+1; {todas por igual}
  13: {Solo Largas}
      if random(19)=0 then
        Pza:=10
      else
        if random(5)=0 then
          Pza:=12 {larga 10}
        else
          if random(4)=0 then
            Pza:=11 {larga 8}
          else
            if random(3)=0 then
              Pza:=9 {larga 6}
            else
              Pza:=1; {larga 4}
  14: {Largas Mazo}
      if random(19)=0 then
        Pza:=10
      else
        if random(5)=0 then
          Pza:=1 {larga 4}
        else
          if random(4)=0 then
            Pza:=9 {larga 6}
          else
            if random(3)=0 then
              Pza:=11 {larga 8}
            else
              Pza:=12; {larga 10}
  15: {Cuadrados}
      if random(19)=0 then
        Pza:=10
      else
        if random(4)=0 then
          Pza:=2
        else
          if random(4)=0 then
            Pza:=8 {gran Cuadrado}
          else
            if random(3)=0 then
              if random(2)=0 then
                if random(2)=0 then
                  Pza:=12 {larga 10}
                else
                  Pza:=11 {larga 8}
              else
                Pza:=9 {larga 6}
            else
              if random(4)=0 then
                Pza:=1
              else
                Pza:=2;
  16: {Eles}
      if random(19)=0 then
        Pza:=10
      else
        if random(12)=0 then
          Pza:=11
        else
          if random(9)=0 then
            Pza:=1
          else
            if random(12)=0 then
              Pza:=14
            else
              if random(2)=0 then
                Pza:=3
              else
                Pza:=4;
  17: {Piramides}
      if random(19)=0 then
        Pza:=10
      else
        if random(12)=0 then
          Pza:=11
        else
          if random(9)=0 then
            Pza:=1
          else
            if random(12)=0 then
              Pza:=13
            else
              begin
                i:=random(3);
                case i of
                  0:Pza:=5;
                  1:Pza:=6;
                  2:Pza:=7;
                end;
              end;

end;

CreaPieza:=Pza;
{CreaPieza:=8;}
end;





function CrearPantalla2:word;
var
  pPant:pointer;
begin
  GetMem(pPant,SizeOf(tVirtualScreen2));
  CrearPantalla2:=Seg(pPant^);
end;





function CalculaCPU:real;
var
  wCronoH,wCronoM,wCronoS,wCronoS100:word;
  r,rIni,rFin,rTpo,CP:real;
  i:word;

begin
getTime(wCronoH,wCronoM,wCronoS,wCronoS100);
rIni:=wCronoH*3600+wCronoM*60+wCronoS+wCronoS100/100;

for i:=1 to 56000 do {55800}
  r:=sqrt(230945.2167);

getTime(wCronoH,wCronoM,wCronoS,wCronoS100);
rFin:=wCronoH*3600+wCronoM*60+wCronoS+wCronoS100/100;

rTpo:=rFin-rIni;
writeln(rTpo:0:8);

if 1/rTpo > 10 then
  CP:=(1/rTpo)*0.3
else
  if 1/rTpo > 3 then
    CP:=(1/rTpo)*0.6
  else
    if 1/rTpo > 1/3 then
      CP:=(1/rTpo)*1.5 {*1.0}
    else
      CP:=(1/rTpo)*0.5;

CalculaCPU:=CP;
end;





procedure DatosPieza(var ePieza:tPieza; var iPiezaX:integer);
begin

case ePieza.tipo of
  1:begin {larga}
      ePieza.color:=1;
      case ePieza.rotate of
        1:begin {----}
            iPiezaX:=4; {colocacion inicial}
          end;
      end; (*case*)
    end;

  2:begin {cuadrado}
      ePieza.color:=2;
      iPiezaX:=5; {colocacion inicial}
    end;

  3:begin
      ePieza.color:=3;
      case ePieza.rotate of
        1:begin {|-}
            iPiezaX:=4;
          end;
      end; (*case*)
    end;

  4:begin
      ePieza.color:=4;
      case ePieza.rotate of
        1:begin {-|}
            iPiezaX:=4;
          end;
      end; (*case*)
    end;

  5:begin
      ePieza.color:=5;
      case ePieza.rotate of
        1:begin
            iPiezaX:=4;
          end;
      end; (*case*)
    end;

  6:begin
      ePieza.color:=6;
      case ePieza.rotate of
        1:begin
            iPiezaX:=4;
          end;
      end; (*case*)
    end;

  7:begin
      ePieza.color:=7;
      case ePieza.rotate of
        1:begin
            iPiezaX:=4;
          end;
      end; (*case*)
    end;

  8:begin {megacuadrado}
      ePieza.color:=12;
      iPiezaX:=4;
    end;

  9:begin {larga 6}
      ePieza.color:=11;
      case ePieza.rotate of
        1:begin {----}
            iPiezaX:=3; {colocacion inicial}
          end;
      end; (*case*)
    end;

  10:begin {punto}
      ePieza.color:=1;
      iPiezaX:=5; {colocacion inicial}
    end;

  11:begin {larga 8}
      ePieza.color:=11;
      case ePieza.rotate of
        1:begin {|}
            iPiezaX:=5;
          end;
      end; (*case*)
    end;

  12:begin {larga 10}
      ePieza.color:=13;
      case ePieza.rotate of
        1:begin {|}
            iPiezaX:=5;
          end;
      end; (*case*)
    end;

  13:begin {estrella}
      ePieza.color:=13;
      iPiezaX:=5;
    end;

  14:begin {L grande}
      ePieza.color:=12;
      iPiezaX:=4;
    end;

end; (*case*)

end; (*procedure DatosPieza*)





procedure DibujaPieza(ePieza:tPieza; iX,iY:integer; var Pantalla:tPantalla);
begin

case ePieza.tipo of
  1:begin {larga}
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
            Pantalla[iX+3,iY]:=ePieza.color;
          end;
        2:begin
            Pantalla[iX,iY-1]:=ePieza.color;
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
          end;
      end; (*case*)
    end; {1}

  2:begin {cuadrado}
      Pantalla[iX,iY]:=ePieza.color;
      Pantalla[iX+1,iY]:=ePieza.color;
      Pantalla[iX,iY+1]:=ePieza.color;
      Pantalla[iX+1,iY+1]:=ePieza.color;
    end; {2}

  3:begin
      case ePieza.rotate of
        1:begin {|-}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
          end;
        2:begin {|_ L}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
            Pantalla[iX+1,iY+2]:=ePieza.color;
          end;
        3:begin {_|}
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+2,iY+1]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
          end;
        4:begin {-|}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+2]:=ePieza.color;
          end;
      end; (*case*)
    end; {3}

  4:begin
      case ePieza.rotate of
        1:begin {-|}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
            Pantalla[iX+2,iY+1]:=ePieza.color;
          end;
        2:begin {|-}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
          end;
        3:begin {|_}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+2,iY+1]:=ePieza.color;
          end;
        4:begin {_|}
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+2]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
          end;
      end; (*case*)
    end; {4}

  5:begin
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
          end;
        2:begin
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+2]:=ePieza.color;
          end;
      end; (*case*)
    end; {5}

  6:begin
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+2,iY+1]:=ePieza.color;
          end;
        2:begin
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
          end;
      end; (*case*)
    end; {6}

  7:begin
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
          end;
        2:begin
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
          end;
        3:begin
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX+2,iY+1]:=ePieza.color;
          end;
        4:begin
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+1,iY+1]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX+1,iY+2]:=ePieza.color;
          end;
      end; (*case*)
    end; {7}

  8:begin {cuadrado grande}
      Pantalla[iX,iY-2]:=ePieza.color;
      Pantalla[iX+1,iY-2]:=ePieza.color;
      Pantalla[iX+2,iY-2]:=ePieza.color;
      Pantalla[iX+3,iY-2]:=ePieza.color;
      Pantalla[iX,iY-1]:=ePieza.color;
      Pantalla[iX+1,iY-1]:=ePieza.color;
      Pantalla[iX+2,iY-1]:=ePieza.color;
      Pantalla[iX+3,iY-1]:=ePieza.color;
      Pantalla[iX,iY]:=ePieza.color;
      Pantalla[iX+1,iY]:=ePieza.color;
      Pantalla[iX+2,iY]:=ePieza.color;
      Pantalla[iX+3,iY]:=ePieza.color;
      Pantalla[iX,iY+1]:=ePieza.color;
      Pantalla[iX+1,iY+1]:=ePieza.color;
      Pantalla[iX+2,iY+1]:=ePieza.color;
      Pantalla[iX+3,iY+1]:=ePieza.color;
    end; {8}

  9:begin {larga}
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
            Pantalla[iX+3,iY]:=ePieza.color;
            Pantalla[iX+4,iY]:=ePieza.color;
            Pantalla[iX+5,iY]:=ePieza.color;
          end;
        2:begin
            Pantalla[iX,iY-2]:=ePieza.color;
            Pantalla[iX,iY-1]:=ePieza.color;
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
            Pantalla[iX,iY+3]:=ePieza.color;
          end;
      end; (*case*)
    end; {9}

  10:begin {punto}
       Pantalla[iX,iY]:=ePieza.color;
     end; {10}

  11:begin {larga8}
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY-5]:=ePieza.color;
            Pantalla[iX,iY-4]:=ePieza.color;
            Pantalla[iX,iY-3]:=ePieza.color;
            Pantalla[iX,iY-2]:=ePieza.color;
            Pantalla[iX,iY-1]:=ePieza.color;
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
          end;
        2:begin
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
            Pantalla[iX+3,iY]:=ePieza.color;
            Pantalla[iX+4,iY]:=ePieza.color;
            Pantalla[iX+5,iY]:=ePieza.color;
            Pantalla[iX+6,iY]:=ePieza.color;
            Pantalla[iX+7,iY]:=ePieza.color;
          end;
      end; (*case*)
    end; {11}

  12:begin {larga10}
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY-7]:=ePieza.color;
            Pantalla[iX,iY-6]:=ePieza.color;
            Pantalla[iX,iY-5]:=ePieza.color;
            Pantalla[iX,iY-4]:=ePieza.color;
            Pantalla[iX,iY-3]:=ePieza.color;
            Pantalla[iX,iY-2]:=ePieza.color;
            Pantalla[iX,iY-1]:=ePieza.color;
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
          end;
        2:begin
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
            Pantalla[iX+3,iY]:=ePieza.color;
            Pantalla[iX+4,iY]:=ePieza.color;
            Pantalla[iX+5,iY]:=ePieza.color;
            Pantalla[iX+6,iY]:=ePieza.color;
            Pantalla[iX+7,iY]:=ePieza.color;
            Pantalla[iX+8,iY]:=ePieza.color;
            Pantalla[iX+9,iY]:=ePieza.color;
          end;
      end; (*case*)
    end; {12}

  13:begin {estrella}
       Pantalla[iX-1,iY]:=ePieza.color;
       Pantalla[iX,iY]:=ePieza.color;
       Pantalla[iX+1,iY]:=ePieza.color;
       Pantalla[iX,iY-1]:=ePieza.color;
       Pantalla[iX,iY+1]:=ePieza.color;
     end;

  14:begin {L grande}
      case ePieza.rotate of
        1:begin {|-}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
          end;
        2:begin {|_ L}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX,iY+1]:=ePieza.color;
            Pantalla[iX,iY+2]:=ePieza.color;
            Pantalla[iX+1,iY+2]:=ePieza.color;
            Pantalla[iX+2,iY+2]:=ePieza.color;
          end;
        3:begin {_|}
            Pantalla[iX,iY+2]:=ePieza.color;
            Pantalla[iX+1,iY+2]:=ePieza.color;
            Pantalla[iX+2,iY+2]:=ePieza.color;
            Pantalla[iX+2,iY+1]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
          end;
        4:begin {-|}
            Pantalla[iX,iY]:=ePieza.color;
            Pantalla[iX+1,iY]:=ePieza.color;
            Pantalla[iX+2,iY]:=ePieza.color;
            Pantalla[iX+2,iY+1]:=ePieza.color;
            Pantalla[iX+2,iY+2]:=ePieza.color;
          end;
      end; (*case*)
    end; {14}

end; (*case*)
end; (*procedure DibujaPieza*)





procedure BorraPieza(ePieza:tPieza; iX,iY:integer; var Pantalla:tPantalla);
begin

case ePieza.tipo of
  1:begin {larga}
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
            Pantalla[iX+3,iY]:=0;
          end;
        2:begin
            Pantalla[iX,iY-1]:=0;
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
          end;
      end; (*case*)
    end;

  2:begin {cuadrado}
      Pantalla[iX,iY]:=0;
      Pantalla[iX+1,iY]:=0;
      Pantalla[iX,iY+1]:=0;
      Pantalla[iX+1,iY+1]:=0;
    end;

  3:begin
      case ePieza.rotate of
        1:begin {|-}
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
          end;
        2:begin {|_ L}
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
            Pantalla[iX+1,iY+2]:=0;
          end;
        3:begin {_|}
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+2,iY+1]:=0;
            Pantalla[iX+2,iY]:=0;
          end;
        4:begin {-|}
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+1,iY+2]:=0;
          end;
      end; (*case*)
    end;

  4:begin
      case ePieza.rotate of
        1:begin {-|}
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
            Pantalla[iX+2,iY+1]:=0;
          end;
        2:begin {|-}
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
          end;
        3:begin {|_}
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+2,iY+1]:=0;
          end;
        4:begin {_|}
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+1,iY+2]:=0;
            Pantalla[iX,iY+2]:=0;
          end;
      end; (*case*)
    end; {4}

  5:begin
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
          end;
        2:begin
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+1,iY+2]:=0;
          end;
      end; (*case*)
    end; {5}

  6:begin
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+2,iY+1]:=0;
          end;
        2:begin
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+1,iY]:=0;
          end;
      end; (*case*)
    end; {6}

  7:begin
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+2,iY]:=0;
          end;
        2:begin
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
          end;
        3:begin
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX+2,iY+1]:=0;
          end;
        4:begin
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+1,iY+1]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX+1,iY+2]:=0;
          end;
      end; (*case*)
    end; {7}

  8:begin {cuadrado grande}
      Pantalla[iX,iY-2]:=0;
      Pantalla[iX+1,iY-2]:=0;
      Pantalla[iX+2,iY-2]:=0;
      Pantalla[iX+3,iY-2]:=0;
      Pantalla[iX,iY-1]:=0;
      Pantalla[iX+1,iY-1]:=0;
      Pantalla[iX+2,iY-1]:=0;
      Pantalla[iX+3,iY-1]:=0;
      Pantalla[iX,iY]:=0;
      Pantalla[iX+1,iY]:=0;
      Pantalla[iX+2,iY]:=0;
      Pantalla[iX+3,iY]:=0;
      Pantalla[iX,iY+1]:=0;
      Pantalla[iX+1,iY+1]:=0;
      Pantalla[iX+2,iY+1]:=0;
      Pantalla[iX+3,iY+1]:=0;
    end; {8}

  9:begin {larga}
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
            Pantalla[iX+3,iY]:=0;
            Pantalla[iX+4,iY]:=0;
            Pantalla[iX+5,iY]:=0;
          end;
        2:begin
            Pantalla[iX,iY-2]:=0;
            Pantalla[iX,iY-1]:=0;
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
            Pantalla[iX,iY+3]:=0;
          end;
      end; (*case*)
    end; {9}

  10:begin {punto}
       Pantalla[iX,iY]:=0;
     end; {10}

  11:begin {larga}
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY-5]:=0;
            Pantalla[iX,iY-4]:=0;
            Pantalla[iX,iY-3]:=0;
            Pantalla[iX,iY-2]:=0;
            Pantalla[iX,iY-1]:=0;
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
          end;
        2:begin
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
            Pantalla[iX+3,iY]:=0;
            Pantalla[iX+4,iY]:=0;
            Pantalla[iX+5,iY]:=0;
            Pantalla[iX+6,iY]:=0;
            Pantalla[iX+7,iY]:=0;
          end;
      end; (*case*)
    end; {11}

  12:begin {larga}
      case ePieza.rotate of
        1:begin
            Pantalla[iX,iY-7]:=0;
            Pantalla[iX,iY-6]:=0;
            Pantalla[iX,iY-5]:=0;
            Pantalla[iX,iY-4]:=0;
            Pantalla[iX,iY-3]:=0;
            Pantalla[iX,iY-2]:=0;
            Pantalla[iX,iY-1]:=0;
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
          end;
        2:begin
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
            Pantalla[iX+3,iY]:=0;
            Pantalla[iX+4,iY]:=0;
            Pantalla[iX+5,iY]:=0;
            Pantalla[iX+6,iY]:=0;
            Pantalla[iX+7,iY]:=0;
            Pantalla[iX+8,iY]:=0;
            Pantalla[iX+9,iY]:=0;
          end;
      end; (*case*)
    end; {12}

  13:begin {estrella}
       Pantalla[iX-1,iY]:=0;
       Pantalla[iX,iY]:=0;
       Pantalla[iX+1,iY]:=0;
       Pantalla[iX,iY-1]:=0;
       Pantalla[iX,iY+1]:=0;
     end;

  14:begin {L grande}
      case ePieza.rotate of
        1:begin {|-}
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
          end;
        2:begin {|_ L}
            Pantalla[iX,iY]:=0;
            Pantalla[iX,iY+1]:=0;
            Pantalla[iX,iY+2]:=0;
            Pantalla[iX+1,iY+2]:=0;
            Pantalla[iX+2,iY+2]:=0;
          end;
        3:begin {_|}
            Pantalla[iX,iY+2]:=0;
            Pantalla[iX+1,iY+2]:=0;
            Pantalla[iX+2,iY+2]:=0;
            Pantalla[iX+2,iY+1]:=0;
            Pantalla[iX+2,iY]:=0;
          end;
        4:begin {-|}
            Pantalla[iX,iY]:=0;
            Pantalla[iX+1,iY]:=0;
            Pantalla[iX+2,iY]:=0;
            Pantalla[iX+2,iY+1]:=0;
            Pantalla[iX+2,iY+2]:=0;
          end;
      end; (*case*)
    end; {14}

end; (*case*)
end; (*procedure BorraPieza*)





function bMiraPieza(ePieza:tPieza; iX,iY:integer; var Pantalla:tPantalla):boolean;
begin
bMiraPieza:=false; {no hay nada donde vamos a poner la pieza}

case ePieza.tipo of
  1:begin {larga}
      case ePieza.rotate of
        1:begin
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+3,iY]<>0 then bMiraPieza:=true;
          end;
        2:begin
            if Pantalla[iX,iY-1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end;

  2:begin {cuadrado}
      if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
      if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
      if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
      if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
    end;

  3:begin
      case ePieza.rotate of
        1:begin {|-}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
          end;
        2:begin {|_ L}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+2]<>0 then bMiraPieza:=true;
          end;
        3:begin {_|}
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
          end;
        4:begin {-|}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+2]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end;

  4:begin
      case ePieza.rotate of
        1:begin {-|}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+1]<>0 then bMiraPieza:=true;
          end;
        2:begin {|-}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
          end;
        3:begin {|_}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+1]<>0 then bMiraPieza:=true;
          end;
        4:begin {_|}
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end; {4}

  5:begin
      case ePieza.rotate of
        1:begin
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
          end;
        2:begin
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+2]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end; {5}

  6:begin
      case ePieza.rotate of
        1:begin
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+1]<>0 then bMiraPieza:=true;
          end;
        2:begin
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end; {6}

  7:begin
      case ePieza.rotate of
        1:begin
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
          end;
        2:begin
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
          end;
        3:begin
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+1]<>0 then bMiraPieza:=true;
          end;
        4:begin
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+2]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end; {7}

  8:begin {cuadrado}
      if Pantalla[iX,iY-2]<>0 then bMiraPieza:=true;
      if Pantalla[iX+1,iY-2]<>0 then bMiraPieza:=true;
      if Pantalla[iX+2,iY-2]<>0 then bMiraPieza:=true;
      if Pantalla[iX+3,iY-2]<>0 then bMiraPieza:=true;
      if Pantalla[iX,iY-1]<>0 then bMiraPieza:=true;
      if Pantalla[iX+1,iY-1]<>0 then bMiraPieza:=true;
      if Pantalla[iX+2,iY-1]<>0 then bMiraPieza:=true;
      if Pantalla[iX+3,iY-1]<>0 then bMiraPieza:=true;
      if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
      if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
      if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
      if Pantalla[iX+3,iY]<>0 then bMiraPieza:=true;
      if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
      if Pantalla[iX+1,iY+1]<>0 then bMiraPieza:=true;
      if Pantalla[iX+2,iY+1]<>0 then bMiraPieza:=true;
      if Pantalla[iX+3,iY+1]<>0 then bMiraPieza:=true;
    end;

  9:begin {larga 6}
      case ePieza.rotate of
        1:begin
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+3,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+4,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+5,iY]<>0 then bMiraPieza:=true;
          end;
        2:begin
            if Pantalla[iX,iY-2]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY-1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+3]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end;

  10:begin {pto}
       if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
     end;

  11:begin {larga 8}
      case ePieza.rotate of
        1:begin
            if iY-5>=0 then if Pantalla[iX,iY-5]<>0 then bMiraPieza:=true;
            if iY-4>=0 then if Pantalla[iX,iY-4]<>0 then bMiraPieza:=true;
            if iY-3>=0 then if Pantalla[iX,iY-3]<>0 then bMiraPieza:=true;
            if iY-2>=0 then if Pantalla[iX,iY-2]<>0 then bMiraPieza:=true;
            if iY-1>=0 then if Pantalla[iX,iY-1]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if iY+1>=0 then if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if iY+2>=0 then if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
          end;
        2:begin
            if iY>=0 then if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+3,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+4,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+5,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+6,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+7,iY]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end;

  12:begin {larga 10}
      case ePieza.rotate of
        1:begin
            if iY-7>=0 then if Pantalla[iX,iY-7]<>0 then bMiraPieza:=true;
            if iY-6>=0 then if Pantalla[iX,iY-6]<>0 then bMiraPieza:=true;
            if iY-5>=0 then if Pantalla[iX,iY-5]<>0 then bMiraPieza:=true;
            if iY-4>=0 then if Pantalla[iX,iY-4]<>0 then bMiraPieza:=true;
            if iY-3>=0 then if Pantalla[iX,iY-3]<>0 then bMiraPieza:=true;
            if iY-2>=0 then if Pantalla[iX,iY-2]<>0 then bMiraPieza:=true;
            if iY-1>=0 then if Pantalla[iX,iY-1]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if iY+1>=0 then if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if iY+2>=0 then if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
          end;
        2:begin
            if iY>=0 then if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+3,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+4,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+5,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+6,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+7,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+8,iY]<>0 then bMiraPieza:=true;
            if iY>=0 then if Pantalla[iX+9,iY]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end;

  13:begin {estrella}
       if Pantalla[iX-1,iY]<>0 then bMiraPieza:=true;
       if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
       if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
       if Pantalla[iX,iY-1]<>0 then bMiraPieza:=true;
       if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
     end;

  14:begin {L}
      case ePieza.rotate of
        1:begin {|-}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
          end;
        2:begin {|_ L}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+2]<>0 then bMiraPieza:=true;
          end;
        3:begin {_|}
            if Pantalla[iX,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+2]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
          end;
        4:begin {-|}
            if Pantalla[iX,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+1,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+1]<>0 then bMiraPieza:=true;
            if Pantalla[iX+2,iY+2]<>0 then bMiraPieza:=true;
          end;
      end; (*case*)
    end;

end; (*case*)
end; (*procedure bMiraPieza*)





function bDerecha(ePieza:tPieza; iX,iY:integer; Pantalla:tPantalla):boolean;
{dice si puede ir a la derecha}
begin
bDerecha:=false;

case ePieza.tipo of
  1:begin {larga}
      case ePieza.rotate of
        1:begin {----}
            if (Pantalla[iX+4,iY]=0) then
              bDerecha:=true
          end;
        2:begin {|}
            if (Pantalla[iX+1,iY-1]=0) and (Pantalla[iX+1,iY]=0) and
               (Pantalla[iX+1,iY+1]=0) and (Pantalla[iX+1,iY+2]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  2:begin {cuadrado}
      if (Pantalla[iX+2,iY]=0) and (Pantalla[iX+2,iY+1]=0) then
        bDerecha:=true
    end;

  3:begin
      case ePieza.rotate of
        1:begin {|-}
            if (Pantalla[iX+3,iY]=0) and (Pantalla[iX+1,iY+1]=0) then
              bDerecha:=true
          end;
        2:begin {|_ L}
            if (Pantalla[iX+1,iY]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bDerecha:=true
          end;
        3:begin {_|}
            if (Pantalla[iX+3,iY]=0) and (Pantalla[iX+3,iY+1]=0) then
              bDerecha:=true
          end;
        4:begin {-|}
            if (Pantalla[iX+2,iY]=0) and (Pantalla[iX+2,iY+1]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  4:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX+3,iY]=0) and (Pantalla[iX+3,iY+1]=0) then
              bDerecha:=true
          end;
        2:begin
            if (Pantalla[iX+2,iY]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+1,iY+2]=0) then
              bDerecha:=true
          end;
        3:begin
            if (Pantalla[iX+1,iY]=0) and (Pantalla[iX+3,iY+1]=0) then
              bDerecha:=true
          end;
        4:begin
            if (Pantalla[iX+2,iY]=0) and (Pantalla[iX+2,iY+1]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  5:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX+3,iY]=0) and (Pantalla[iX+2,iY+1]=0) then
              bDerecha:=true
          end;
        2:begin
            if (Pantalla[iX+1,iY]=0) and (Pantalla[iX+2,iY+1]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  6:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX+2,iY]=0) and (Pantalla[iX+3,iY+1]=0) then
              bDerecha:=true
          end;
        2:begin
            if (Pantalla[iX+2,iY]=0) and (Pantalla[iX+2,iY+1]=0) and
               (Pantalla[iX+1,iY+2]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  7:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX+3,iY]=0) and (Pantalla[iX+2,iY+1]=0) then
              bDerecha:=true
          end;
        2:begin
            if (Pantalla[iX+1,iY]=0) and (Pantalla[iX+2,iY+1]=0) and
               (Pantalla[iX+1,iY+2]=0) then
              bDerecha:=true
          end;
        3:begin
            if (Pantalla[iX+2,iY]=0) and (Pantalla[iX+3,iY+1]=0) then
              bDerecha:=true
          end;
        4:begin
            if (Pantalla[iX+2,iY]=0) and (Pantalla[iX+2,iY+1]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  8:begin {cuadrado}
      if (Pantalla[iX+4,iY-2]=0) and (Pantalla[iX+4,iY-1]=0) and
         (Pantalla[iX+4,iY]=0) and (Pantalla[iX+4,iY+1]=0) then
        bDerecha:=true
    end;

  9:begin {larga6}
      case ePieza.rotate of
        1:begin {----}
            if (Pantalla[iX+6,iY]=0) then
              bDerecha:=true
          end;
        2:begin {|}
            if (Pantalla[iX+1,iY-2]=0) and (Pantalla[iX+1,iY-1]=0) and
               (Pantalla[iX+1,iY]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+1,iY+2]=0) and (Pantalla[iX+1,iY+3]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  10:begin {pto}
      if Pantalla[iX+1,iY]=0
      then
        bDerecha:=true
    end;

  11:begin {larga8}
      case ePieza.rotate of
        1:begin {|}
            if (Pantalla[iX+1,iY-5]=0) and (Pantalla[iX+1,iY-4]=0) and
               (Pantalla[iX+1,iY-3]=0) and (Pantalla[iX+1,iY-2]=0) and
               (Pantalla[iX+1,iY-1]=0) and (Pantalla[iX+1,iY]=0) and
               (Pantalla[iX+1,iY+1]=0) and (Pantalla[iX+1,iY+2]=0) then
              bDerecha:=true
          end;
        2:begin {----}
            if (Pantalla[iX+8,iY]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  12:begin {larga10}
      case ePieza.rotate of
        1:begin {|}
            if (Pantalla[iX+1,iY-7]=0) and (Pantalla[iX+1,iY-6]=0) and
               (Pantalla[iX+1,iY-5]=0) and (Pantalla[iX+1,iY-4]=0) and
               (Pantalla[iX+1,iY-3]=0) and (Pantalla[iX+1,iY-2]=0) and
               (Pantalla[iX+1,iY-1]=0) and (Pantalla[iX+1,iY]=0) and
               (Pantalla[iX+1,iY+1]=0) and (Pantalla[iX+1,iY+2]=0) then
              bDerecha:=true
          end;
        2:begin {----}
            if (Pantalla[iX+10,iY]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

  13:begin {estrella}
       if (Pantalla[iX+1,iY-1]=0) and (Pantalla[iX+2,iY]=0) and
          (Pantalla[iX+1,iY+1]=0) then
         bDerecha:=true
     end;

  14:begin {L}
      case ePieza.rotate of
        1:begin {|-}
            if (Pantalla[iX+3,iY]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+1,iY+2]=0) then
              bDerecha:=true
          end;
        2:begin {|_ L}
            if (Pantalla[iX+1,iY]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+3,iY+2]=0) then
              bDerecha:=true
          end;
        3:begin {_|}
            if (Pantalla[iX+3,iY]=0) and (Pantalla[iX+3,iY+1]=0) and
               (Pantalla[iX+3,iY+2]=0) then
              bDerecha:=true
          end;
        4:begin {-|}
            if (Pantalla[iX+3,iY]=0) and (Pantalla[iX+3,iY+1]=0) and
               (Pantalla[iX+3,iY+2]=0) then
              bDerecha:=true
          end;
      end; (*case*)
    end;

end; (*case*)
end; (*function bDerecha*)





function bIzquierda(ePieza:tPieza; iX,iY:integer; Pantalla:tPantalla):boolean;
{dice si puede ir a la Izquierda}
begin
bIzquierda:=false;

case ePieza.tipo of
  1:begin {larga}
      case ePieza.rotate of
        1:begin {----}
            if (Pantalla[iX-1,iY]=0) then
              bIzquierda:=true
          end;
        2:begin {|}
            if (Pantalla[iX-1,iY-1]=0) and (Pantalla[iX-1,iY]=0) and
               (Pantalla[iX-1,iY+1]=0) and (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

  2:begin {cuadrado}
      if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) then
        bIzquierda:=true
    end;

  3:begin
      case ePieza.rotate of
        1:begin {|-}
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) then
              bIzquierda:=true
          end;
        2:begin {|_ L}
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
        3:begin {_|}
            if (Pantalla[iX-1,iY+1]=0) and (Pantalla[iX+1,iY]=0) then
              bIzquierda:=true
          end;
        4:begin {-|}
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX,iY+1]=0) and
               (Pantalla[iX,iY+2]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

  4:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX+1,iY+1]=0) then
              bIzquierda:=true
          end;
        2:begin
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0)
            then
              bIzquierda:=true
          end;
        3:begin
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) then
              bIzquierda:=true
          end;
        4:begin
            if (Pantalla[iX,iY]=0) and (Pantalla[iX,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

  5:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX,iY]=0) and (Pantalla[iX-1,iY+1]=0) then
              bIzquierda:=true;
          end;
        2:begin
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX,iY+2]=0) then
              bIzquierda:=true;
          end;
      end; (*case*)
    end;

  6:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX,iY+1]=0) then
              bIzquierda:=true
          end;
        2:begin
            if (Pantalla[iX,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

  7:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX,iY+1]=0) then
              bIzquierda:=true
          end;
        2:begin
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
        3:begin
            if (Pantalla[iX,iY]=0) and (Pantalla[iX-1,iY+1]=0) then
              bIzquierda:=true
          end;
        4:begin
            if (Pantalla[iX,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX,iY+2]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

  8:begin {cuadrado}
      if (Pantalla[iX-1,iY-2]=0) and (Pantalla[iX-1,iY-1]=0) and
         (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) then
        bIzquierda:=true
    end;

  9:begin {larga}
      case ePieza.rotate of
        1:begin {----}
            if (Pantalla[iX-1,iY]=0) then
              bIzquierda:=true
          end;
        2:begin {|}
            if (Pantalla[iX-1,iY-2]=0) and (Pantalla[iX-1,iY-1]=0) and
               (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0) and (Pantalla[iX-1,iY+3]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

  10:begin {pto}
      if Pantalla[iX-1,iY]=0 then
        bIzquierda:=true
    end;

  11:begin {larga8}
      case ePieza.rotate of
        1:begin {|}
            if (Pantalla[iX-1,iY-5]=0) and (Pantalla[iX-1,iY-4]=0) and
               (Pantalla[iX-1,iY-3]=0) and (Pantalla[iX-1,iY-2]=0) and
               (Pantalla[iX-1,iY-1]=0) and (Pantalla[iX-1,iY]=0) and
               (Pantalla[iX-1,iY+1]=0) and (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
        2:begin {----}
            if (Pantalla[iX-1,iY]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

  12:begin {larga10}
      case ePieza.rotate of
        1:begin {|}
            if (Pantalla[iX-1,iY-7]=0) and (Pantalla[iX-1,iY-6]=0) and
               (Pantalla[iX-1,iY-5]=0) and (Pantalla[iX-1,iY-4]=0) and
               (Pantalla[iX-1,iY-3]=0) and (Pantalla[iX-1,iY-2]=0) and
               (Pantalla[iX-1,iY-1]=0) and (Pantalla[iX-1,iY]=0) and
               (Pantalla[iX-1,iY+1]=0) and (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
        2:begin {----}
            if (Pantalla[iX-1,iY]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

  13:begin {estrella}
       if (Pantalla[iX-1,iY-1]=0) and (Pantalla[iX-2,iY]=0) and
          (Pantalla[iX-1,iY+1]=0) then
         bIzquierda:=true
     end;

  14:begin
      case ePieza.rotate of
        1:begin {|-}
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
        2:begin {|_ L}
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX-1,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
        3:begin {_|}
            if (Pantalla[iX+1,iY]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX-1,iY+2]=0) then
              bIzquierda:=true
          end;
        4:begin {-|}
            if (Pantalla[iX-1,iY]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+1,iY+2]=0) then
              bIzquierda:=true
          end;
      end; (*case*)
    end;

end; (*case*)
end; (*function bIzquierda*)





function bAbajo(ePieza:tPieza; iX,iY:integer; Pantalla:tPantalla):boolean;
{dice si puede ir Abajo}
begin
bAbajo:=false;

case ePieza.tipo of
  1:begin {larga}
      case ePieza.rotate of
        1:begin {----}
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+1]=0) and (Pantalla[iX+3,iY+1]=0) then
              bAbajo:=true
          end;
        2:begin {|}
            if (Pantalla[iX,iY+3]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  2:begin {cuadrado}
      if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+2]=0) then
        bAbajo:=true
    end;

  3:begin
      case ePieza.rotate of
        1:begin {|-}
            if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+1]=0) then
              bAbajo:=true
          end;
        2:begin {|_ L}
            if (Pantalla[iX,iY+3]=0) and (Pantalla[iX+1,iY+3]=0) then
              bAbajo:=true
          end;
        3:begin {_|}
            if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+2]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bAbajo:=true
          end;
        4:begin {-|}
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+3]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  4:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bAbajo:=true
          end;
        2:begin
            if (Pantalla[iX,iY+3]=0) and (Pantalla[iX+1,iY+1]=0) then
              bAbajo:=true
          end;
        3:begin
            if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+2]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bAbajo:=true
          end;
        4:begin
            if (Pantalla[iX,iY+3]=0) and (Pantalla[iX+1,iY+3]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  5:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+2]=0) and
               (Pantalla[iX+2,iY+1]=0) then
              bAbajo:=true
          end;
        2:begin
            if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+3]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  6:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+2]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bAbajo:=true
          end;
        2:begin
            if (Pantalla[iX,iY+3]=0) and (Pantalla[iX+1,iY+2]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  7:begin
      case ePieza.rotate of
        1:begin
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+2]=0) and
               (Pantalla[iX+2,iY+1]=0) then
              bAbajo:=true
          end;
        2:begin
            if (Pantalla[iX,iY+3]=0) and (Pantalla[iX+1,iY+2]=0) then
              bAbajo:=true
          end;
        3:begin
            if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+2]=0) and
               (Pantalla[iX+2,iY+2]=0) then
              bAbajo:=true
          end;
        4:begin
            if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+3]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  8:begin {cuadrado}
      if (Pantalla[iX,iY+2]=0) and (Pantalla[iX+1,iY+2]=0) and
         (Pantalla[iX+2,iY+2]=0) and (Pantalla[iX+3,iY+2]=0) then
        bAbajo:=true
    end;

  9:begin {larga}
      case ePieza.rotate of
        1:begin {----}
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+1]=0) and (Pantalla[iX+3,iY+1]=0) and
               (Pantalla[iX+4,iY+1]=0) and (Pantalla[iX+5,iY+1]=0) then
              bAbajo:=true
          end;
        2:begin {|}
            if (Pantalla[iX,iY+4]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  10:begin {pto}
      if Pantalla[iX,iY+1]=0 then
        bAbajo:=true
    end;

  11:begin {larga}
      case ePieza.rotate of
        1:begin {|}
            if (Pantalla[iX,iY+3]=0) then
              bAbajo:=true
          end;
        2:begin {----}
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+1]=0) and (Pantalla[iX+3,iY+1]=0) and
               (Pantalla[iX+4,iY+1]=0) and (Pantalla[iX+5,iY+1]=0) and
               (Pantalla[iX+6,iY+1]=0) and (Pantalla[iX+7,iY+1]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  12:begin {larga}
      case ePieza.rotate of
        1:begin {|}
            if (Pantalla[iX,iY+3]=0) then
              bAbajo:=true
          end;
        2:begin {----}
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+1]=0) and (Pantalla[iX+3,iY+1]=0) and
               (Pantalla[iX+4,iY+1]=0) and (Pantalla[iX+5,iY+1]=0) and
               (Pantalla[iX+6,iY+1]=0) and (Pantalla[iX+7,iY+1]=0) and
               (Pantalla[iX+8,iY+1]=0) and (Pantalla[iX+9,iY+1]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

  13:begin {estrella}
       if (Pantalla[iX-1,iY+1]=0) and (Pantalla[iX,iY+2]=0) and
          (Pantalla[iX+1,iY+1]=0) then
         bAbajo:=true
     end;

  14:begin
      case ePieza.rotate of
        1:begin {|-}
            if (Pantalla[iX,iY+3]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+1]=0) then
              bAbajo:=true
          end;
        2:begin {|_ L}
            if (Pantalla[iX,iY+3]=0) and (Pantalla[iX+1,iY+3]=0) and
               (Pantalla[iX+2,iY+3]=0) then
              bAbajo:=true
          end;
        3:begin {_|}
            if (Pantalla[iX,iY+3]=0) and (Pantalla[iX+1,iY+3]=0) and
               (Pantalla[iX+2,iY+3]=0) then
              bAbajo:=true
          end;
        4:begin {-|}
            if (Pantalla[iX,iY+1]=0) and (Pantalla[iX+1,iY+1]=0) and
               (Pantalla[iX+2,iY+3]=0) then
              bAbajo:=true
          end;
      end; (*case*)
    end;

end; (*case*)
end; (*function bAbajo*)





procedure RotateDer(var eMarcador:tMarcador; var Pantalla:tPantalla);

begin
with eMarcador do
  case ePieza.tipo of
    1:begin {larga}
        case ePieza.rotate of
          1:begin {----}
              if (Pantalla[iPiezaX+1,iPiezaY+2]=0) and (Pantalla[iPiezaX+1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY-1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
                end;
            end;
          2:begin {|}
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) and (Pantalla[iPiezaX+1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {1}

    3:begin
        case ePieza.rotate of
          1:begin {|-}
              if (Pantalla[iPiezaX+1,iPiezaY-1]=0) and (Pantalla[iPiezaX+1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin {|_ L}
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) and (Pantalla[iPiezaX+1,iPiezaY]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=3;
                  iPiezaX:=iPiezaX-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          3:begin {_|}
              if (Pantalla[iPiezaX,iPiezaY]=0) and (Pantalla[iPiezaX+1,iPiezaY]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=4;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          4:begin {-|}
              if (Pantalla[iPiezaX,iPiezaY+1]=0) and (Pantalla[iPiezaX,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {3}

    4:begin
        case ePieza.rotate of
          1:begin
              if (Pantalla[iPiezaX+1,iPiezaY-1]=0) and (Pantalla[iPiezaX+2,iPiezaY-1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin
              if (Pantalla[iPiezaX-1,iPiezaY]=0) and (Pantalla[iPiezaX-1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=3;
                  iPiezaX:=iPiezaX-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          3:begin
              if (Pantalla[iPiezaX+1,iPiezaY]=0) and (Pantalla[iPiezaX,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=4;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          4:begin
              if (Pantalla[iPiezaX,iPiezaY+1]=0) and (Pantalla[iPiezaX+2,iPiezaY]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {4}

    5:begin
        case ePieza.rotate of
          1:begin
              if (Pantalla[iPiezaX+1,iPiezaY-1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin
              if (Pantalla[iPiezaX,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX-1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {5}

    6:begin
        case ePieza.rotate of
          1:begin
              if (Pantalla[iPiezaX+2,iPiezaY-1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {6}

    7:begin
        case ePieza.rotate of
          1:begin
              if (Pantalla[iPiezaX+1,iPiezaY-1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=3;
                  iPiezaX:=iPiezaX-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          3:begin
              if (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=4;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          4:begin
              if (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {7}

    9:begin {larga6}
        case ePieza.rotate of
          1:begin {----}
              if (Pantalla[iPiezaX+2,iPiezaY-2]=0) and (Pantalla[iPiezaX+2,iPiezaY-1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) and (Pantalla[iPiezaX+2,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+3]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+2;
                  iPiezaY:=iPiezaY-2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
                end;
            end;
          2:begin {|}
              if (Pantalla[iPiezaX-2,iPiezaY+2]=0) and (Pantalla[iPiezaX-1,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) and (Pantalla[iPiezaX+2,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-2;
                  iPiezaY:=iPiezaY+2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end;

    10:begin {pto}
         case ePieza.color of
           2..7:ePieza.color:=ePieza.color-1;
           1:ePieza.color:=12;
           12:ePieza.color:=11;
           11:ePieza.color:=8;
           8:ePieza.color:=13;
           13:ePieza.color:=7;
         end;
         DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
       end;

    11:begin {larga8}
        case ePieza.rotate of
          1:begin {|}
              if (Pantalla[iPiezaX-3,iPiezaY-2]=0) and (Pantalla[iPiezaX-2,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX-1,iPiezaY-2]=0) and (Pantalla[iPiezaX+1,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY-2]=0) and (Pantalla[iPiezaX+3,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY-2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX-3;
                  iPiezaY:=iPiezaY-2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin {----}
              if (Pantalla[iPiezaX+3,iPiezaY-3]=0) and (Pantalla[iPiezaX+3,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY-1]=0) and (Pantalla[iPiezaX+3,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY+2]=0) and (Pantalla[iPiezaX+3,iPiezaY+3]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY+4]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX+3;
                  iPiezaY:=iPiezaY+2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
                end;
            end;
        end; (*case*)
      end;

    12:begin {larga10}
        case ePieza.rotate of
          1:begin {|}
              if (Pantalla[iPiezaX-4,iPiezaY-2]=0) and (Pantalla[iPiezaX-3,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX-2,iPiezaY-2]=0) and (Pantalla[iPiezaX-1,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY-2]=0) and (Pantalla[iPiezaX+2,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY-2]=0) and (Pantalla[iPiezaX+4,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+5,iPiezaY-2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX-4;
                  iPiezaY:=iPiezaY-2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin {----}
              if (Pantalla[iPiezaX+4,iPiezaY-5]=0) and (Pantalla[iPiezaX+4,iPiezaY-4]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY-3]=0) and (Pantalla[iPiezaX+4,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY-1]=0) and (Pantalla[iPiezaX+4,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY+2]=0) and (Pantalla[iPiezaX+4,iPiezaY+3]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY+4]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX+4;
                  iPiezaY:=iPiezaY+2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
                end;
            end;
        end; (*case*)
      end;

    14:begin
        case ePieza.rotate of
          1:begin {|-}
              if (Pantalla[iPiezaX+1,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin {|_ L}
              if (Pantalla[iPiezaX+2,iPiezaY]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=3;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          3:begin {_|}
              if (Pantalla[iPiezaX,iPiezaY]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=4;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          4:begin {-|}
              if (Pantalla[iPiezaX,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {14}

  end; (*case*)
end; (*procedure RotateDer*)





procedure RotateIzq(var eMarcador:tMarcador; var Pantalla:tPantalla);
var
  iI:integer;

begin
with eMarcador do
  case ePieza.tipo of
    1:begin {larga}
        case ePieza.rotate of
          1:begin {----}
              if (Pantalla[iPiezaX+1,iPiezaY+2]=0) and (Pantalla[iPiezaX+1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY-1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
                end;
            end;
          2:begin {|}
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) and (Pantalla[iPiezaX+1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {1}

    3:begin
        case ePieza.rotate of
          1:begin {|-}
              if (Pantalla[iPiezaX,iPiezaY-1]=0) and (Pantalla[iPiezaX+1,iPiezaY-1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=4;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin {|_ L}
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) and (Pantalla[iPiezaX-1,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          3:begin {_|}
              if (Pantalla[iPiezaX+1,iPiezaY]=0) and (Pantalla[iPiezaX+1,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          4:begin {-|}
              if (Pantalla[iPiezaX,iPiezaY+1]=0) and (Pantalla[iPiezaX,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=3;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {3}

    4:begin
        case ePieza.rotate of
          1:begin
              if (Pantalla[iPiezaX+1,iPiezaY-1]=0) and (Pantalla[iPiezaX,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=4;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) and (Pantalla[iPiezaX+1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          3:begin
              if (Pantalla[iPiezaX+1,iPiezaY]=0) and (Pantalla[iPiezaX+2,iPiezaY]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          4:begin
              if (Pantalla[iPiezaX,iPiezaY]=0) and (Pantalla[iPiezaX,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=3;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end;

    5:begin
        case ePieza.rotate of
          1:begin
              if (Pantalla[iPiezaX+1,iPiezaY-1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin
              if (Pantalla[iPiezaX,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX-1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {5}

    6:begin
        case ePieza.rotate of
          1:begin
              if (Pantalla[iPiezaX+2,iPiezaY-1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {6}

    7:begin
        case ePieza.rotate of
          1:begin
              if (Pantalla[iPiezaX+1,iPiezaY-1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=4;
                  iPiezaY:=iPiezaY-1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin
              if (Pantalla[iPiezaX-1,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-1;
                  iPiezaY:=iPiezaY+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          3:begin
              if (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          4:begin
              if (Pantalla[iPiezaX+2,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=3;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {7}

    9:begin {larga6}
        case ePieza.rotate of
          1:begin {----}
              if (Pantalla[iPiezaX+2,iPiezaY-2]=0) and (Pantalla[iPiezaX+2,iPiezaY-1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+1]=0) and (Pantalla[iPiezaX+2,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+3]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX+2;
                  iPiezaY:=iPiezaY-2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
                end;
            end;
          2:begin {|}
              if (Pantalla[iPiezaX-2,iPiezaY+2]=0) and (Pantalla[iPiezaX-1,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) and (Pantalla[iPiezaX+2,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX-2;
                  iPiezaY:=iPiezaY+2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end;

    10:begin {pto}
         case ePieza.color of
           1..6:ePieza.color:=ePieza.color+1;
           7:ePieza.color:=13;
           13:ePieza.color:=8;
           8:ePieza.color:=11;
           11:ePieza.color:=12;
           12:ePieza.color:=1;
         end;
         DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
       end;

    11:begin {larga8}
        case ePieza.rotate of
          1:begin {|}
              if (Pantalla[iPiezaX-3,iPiezaY-2]=0) and (Pantalla[iPiezaX-2,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX-1,iPiezaY-2]=0) and (Pantalla[iPiezaX+1,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY-2]=0) and (Pantalla[iPiezaX+3,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY-2]=0)
              then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX-3;
                  iPiezaY:=iPiezaY-2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin {----}
              if (Pantalla[iPiezaX+3,iPiezaY-3]=0) and (Pantalla[iPiezaX+3,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY-1]=0) and (Pantalla[iPiezaX+3,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY+2]=0) and (Pantalla[iPiezaX+3,iPiezaY+3]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY+4]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX+3;
                  iPiezaY:=iPiezaY+2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
                end;
            end;
        end; (*case*)
      end;

    12:begin {larga10}
        case ePieza.rotate of
          1:begin {|}
              if (Pantalla[iPiezaX-4,iPiezaY-2]=0) and (Pantalla[iPiezaX-3,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX-2,iPiezaY-2]=0) and (Pantalla[iPiezaX-1,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY-2]=0) and (Pantalla[iPiezaX+2,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+3,iPiezaY-2]=0) and (Pantalla[iPiezaX+4,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+5,iPiezaY-2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  iPiezaX:=iPiezaX-4;
                  iPiezaY:=iPiezaY-2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin {----}
              if (Pantalla[iPiezaX+4,iPiezaY-5]=0) and (Pantalla[iPiezaX+4,iPiezaY-4]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY-3]=0) and (Pantalla[iPiezaX+4,iPiezaY-2]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY-1]=0) and (Pantalla[iPiezaX+4,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY+2]=0) and (Pantalla[iPiezaX+4,iPiezaY+3]=0) and
                 (Pantalla[iPiezaX+4,iPiezaY+4]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  iPiezaX:=iPiezaX+4;
                  iPiezaY:=iPiezaY+2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla); {cambio, ver ppio programa}
                end;
            end;
        end; (*case*)
      end;

    14:begin {L grande}
        case ePieza.rotate of
          1:begin {|-}
              if (Pantalla[iPiezaX+2,iPiezaY+1]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=4;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          2:begin {|_ L}
              if (Pantalla[iPiezaX+1,iPiezaY]=0) and
                 (Pantalla[iPiezaX+2,iPiezaY]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=1;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          3:begin {_|}
              if (Pantalla[iPiezaX,iPiezaY]=0) and
                 (Pantalla[iPiezaX,iPiezaY+1]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=2;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
          4:begin {-|}
              if (Pantalla[iPiezaX,iPiezaY+2]=0) and
                 (Pantalla[iPiezaX+1,iPiezaY+2]=0) then
                begin
                  BorraPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                  ePieza.rotate:=3;
                  DibujaPieza(ePieza,iPiezaX,iPiezaY,Pantalla);
                end;
            end;
        end; (*case*)
      end; {14}

  end; (*case*)
end; (*procedure RotateIzq*)





end.



