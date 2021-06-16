unit imagen;
{$G+}


interface


type
tImagen=record
          TamanoX:word; {Nß puntos ancho}
          TamanoY:word; {Nß puntos alto}
          MapaBits:pointer; {Apunta a la imagen en memoria (array de colores)}
        end;

tPantalla=array[0..64000] of byte; {Pantalla virtual de 320*200 en memoria}

tColor=record {Color son 3 bytes}
         R:byte; {Rojo  (Red)}
         G:byte; {Verde (Green)}
         B:byte; {Azul  (Blue)}
       end;
tPaleta=array[0..255] of tColor; {Paleta son 256 colores (768 bytes)}

tColor8=array[0..7] of byte; {Color letras del WriteWhere}
tColor16=array[0..15] of byte;

tProcedureWriteWhereChar=array[char] of array[0..7] of byte; {todas las letras}


var
pProcedureWriteWhere:^tProcedureWriteWhereChar;
bProcedureWriteWhere:boolean; {si es la primera vez que se ejecuta}





{ SPR (archivos de imagen}
function NumeroSPR(sNombre,sPath:string; var iError:integer):word;
procedure LoadImagenSPR(sNombre,sPath:string; wNumero:word;
                        var Imagen:tImagen; var iError:integer);
procedure SaveImagenSPR(Imagen:tImagen; wNumero:word;
                        sNombre,sPath:string; var iError:integer);

{ Pausas }
procedure Pausa; {Hasta que se suelten teclas, se pulse tecla y suelten}
procedure PausaUnitTeclas; {Idem pero con unit teclas}
procedure Esperar(wMilesimas:word); {Segun tiempo digas}

{ Para modo texto }
procedure DimCursor(iDimension:integer);
function GetTextColor:byte;
function GetTextBackGround:byte;
function GetTextFlash:boolean;
procedure TextFlash(bActivarFlash:boolean);
procedure TextBlink(bState:boolean);
procedure EnableHighBack;
procedure DisableHighBack;

{ Para strings }
function Mayusculas(sCadena:string):string;
function Minusculas(sCadena:string):string;
procedure QuitarBlancosIni(var sCadena:string);
procedure QuitarBlancosFin(var sCadena:string);
function Extension(sNombre:string):string;
function QuitaExtension(sNombre:string):string;
function Chars(yChar:byte; wNum:word):string;
function IntAStr(i:longint):string;
function ByteAHex(y:byte):string;
function ByteABin(y:byte):string;

{ Escribir en modo texto y grafico (sin pantalla virtual) }
procedure GraphTextXY(iX,iY:integer; Variable:real);
procedure GraphText(Variable:real);
function ModoGT:boolean;
procedure GTWriteReal(Variable:real);
procedure GTWriteString(sText:string);
procedure GTWriteRealXY(iX,iY:integer; Variable:real);
procedure GTWriteStringXY(iX,iY:integer; sText:string);
procedure GTWriteIzqStringXY(iX,iY:integer; sText:string);
procedure GTLocate(iX,iY:integer; bComoTexto:boolean);
procedure GTCls(yColor:byte);

{ Modo grafico sin pantalla virtual }
procedure Cuadrado(iX1,iY1,iX2,iY2,iColor:integer);
procedure WaitRetrace; {Espera hasta refresco de pantalla}

{ Paleta }
procedure GetColorPal(Col:byte; var R,G,B:Byte);
procedure SetColorPal(Col,R,G,B:Byte);
procedure GetPal(Paleta:tPaleta; Col:byte; var R,G,B:Byte);
procedure SetPal(var Paleta:tPaleta; Col,R,G,B:Byte);
procedure GetPaleta(var Paleta:tPaleta);
procedure SetPaleta(Paleta:tPaleta);
procedure GetPalReservado(iReservaPal:integer; var Paleta:tPaleta);
procedure SetPalReservado(iReservaPal:integer; Paleta:tPaleta);
procedure PonSombras(SombraR,SombraG,SombraB:byte; wDelay:word);
procedure QuitaSombras(PaletaBuena:tPaleta; wDelay:word);
procedure SavePaleta(Paleta:tPaleta; sNombre,sPath:string;
                     bSobreEscribir:boolean; var iError:integer);
procedure LoadPaleta(var Paleta:tPaleta; sNombre,sPath:string;
                     var iError:integer);
function PaletaErrorMsg(iCodigoError:integer):string;
procedure InviertePaleta(var Paleta:tPaleta);
procedure PaletaDe(var Paleta:tPaleta; r,g,b:byte);

{ Pantallas Virtuales }
function CrearPantalla:word; {Crea una Pantalla Virtual}
  {Where siempre es el word que devuelve CrearPantalla}
procedure flip(wDesde,wHasta:Word); {Copia una pantalla en otra}
  {El monitor es el word que devuelve SegA000}
procedure ClsWhere(yColor:Byte ;where:word);
procedure PutPixelWhere(iX,iY:integer; yColor:byte; where:word);
procedure PutPixelWhere320(iX,iY:integer; yColor:byte; where:word);
procedure PutPixelWhereLento(iX,iY:integer; yColor:byte; where:word);
function GetPixelWhere(iX,iY:integer; where:word):byte;
procedure LineWhere(x1,y1,x2,y2:integer; col:byte; where:word);
procedure LineWhere320(x1,y1,x2,y2:integer; col:byte; where:word);
procedure CirculoWhere(x,y,radio:integer; color:byte; where:word);
procedure WriteWhere(iX,iY,iColor,iFondo:integer; sText:string; where:word);
procedure WriteColorWhere(iX,iY,iFondo:integer; sText:string;
                          color:tColor8; where:word);
procedure Write16Where(iX,iY,iColor,iFondo:integer; sText:string; where:word);
procedure CuadradoWhere(iX1,iY1,iX2,iY2:integer; col:byte; where:word);
procedure RectangleWhere(iX1,iY1,iX2,iY2:integer; col:byte; where:word); {no lleno}

{ Imagenes }
procedure GetImagen(iXini,iYini,iXfin,iYfin:integer; var Imagen:tImagen);
procedure GetImagenWhere(iXini,iYini,iXfin,iYfin:integer; var Imagen:tImagen;
                         where:word);
function GetPixelImagen(iX,iY:integer; Imagen:tImagen):byte;
procedure GetImagenImagen(iXini,iYini,iXfin,iYfin:integer; var Hasta:tImagen;
                          var Desde:tImagen);
procedure FreeImagen(var Imagen:tImagen); {parece que no funciona}
procedure PutImagen(Imagen:tImagen);
procedure PutImagenXY(iXini,iYini:integer; Imagen:tImagen);
procedure PutImagenXYWhere(iXini,iYini:integer; Imagen:tImagen; where:word);
procedure PutImagenXYXY(iX,iY,iXini,iYini,iXfin,iYfin:integer; Imagen:tImagen);
procedure PutImagenXYTam(iX,iY,iXini,iYini,iTamX,iTamY:integer; Imagen:tImagen);
procedure PutImagenXYXYWhere(iX,iY,iXini,iYini,iXfin,iYfin:integer;
                             Imagen:tImagen; where:word);
procedure PutImagenXYTamWhere(iX,iY,iXini,iYini,iTamX,iTamY:integer;
                              Imagen:tImagen; where:word);
procedure PutImagenTxt(Imagen:tImagen);
procedure PutImagenBig(Imagen:tImagen; iRadio:integer);
procedure PutImagenXYBig(iX,iY:integer; Imagen:tImagen; iRadio:integer);
procedure PutImagenSin(Imagen:tImagen; iSin:integer);
procedure PutImagenXYSin(iXini,iYini:integer; Imagen:tImagen; iSin:integer);
procedure PutImagenXYSinWhere(iXini,iYini:integer; Imagen:tImagen;
                              iSin:integer; where:word);
procedure PutImagenXYSinWhere320(iXini,iYini:integer; Imagen:tImagen;
                                 iSin:integer; where:word);

{ Inicia Modo Grafico }
procedure IniciaSVGA256(iModo:integer; sPath:string; var iError:integer);

{ Visualiza info en pantalla }
procedure WritePaleta(Paleta:tPaleta; sPath:string);
procedure DibujaMem;





implementation


uses crt,dos,graph,teclas;






function NumeroSPR(sNombre,sPath:string; var iError:integer):word;

{SPR -> union de imagenes sin paleta, 2 words para tama§o X e Y.
Devuelve el Numero de imagenes dentro de un fichero SPR
0 no hay nada; 1-> 1 imagen (la 0); 2-> 2 imagenes (la 0 y 1)...}

var
 fImagen:file;
 eDirInfo: SearchRec;
 wNum,wRes,wX,wY:word;


begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if (Extension(sNombre)<>'') and (Mayusculas(Extension(sNombre))<>'SPR') then
  begin
    iError:=7;
    exit;
  end;
if Extension(sNombre)='' then sNombre:=sNombre+'.SPR';


assign(fImagen,sPath+sNombre);
{$I-}
reset(fImagen,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


wNum:=0; {Imagen por la que vamos}
while not EOF(fImagen) do
  begin
    BlockRead(fImagen,wX,2,wRes);
    BlockRead(fImagen,wY,2,wRes);
    Seek(fImagen,FilePos(fImagen)+wX*wY);
    wNum:=wNum+1;
  end; {Bucle de imagenes en fichero}

close(fImagen);

NumeroSPR:=wNum;
end; (*procedure NumeroSPR*)





procedure LoadImagenSPR(sNombre,sPath:string; wNumero:word;
                        var Imagen:tImagen; var iError:integer);
var
 fImagen:file;
 eDirInfo: SearchRec;
 wX,wY:word;
 wN,wRes:word;
 lTam:longint;
 w,wSeg,wOfs:word;
 lTamX,lTamY,lSize:longint;
 pImagenMem:^byte;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if (Extension(sNombre)<>'') and (Mayusculas(Extension(sNombre))<>'SPR') then
  begin
    iError:=7;
    exit;
  end;
if Extension(sNombre)='' then sNombre:=sNombre+'.SPR';


assign(fImagen,sPath+sNombre);
{$I-}
reset(fImagen,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


wN:=0; {Imagen por la que vamos}
while wN<=wNumero do
  begin
    if EOF(fImagen) then
      begin
        iError:=6; {wNumero fuera de rango}
        exit;
      end;

    BlockRead(fImagen,wX,2,wRes);
    BlockRead(fImagen,wY,2,wRes);
    lTam:=wX*wY;
    if wN<>wNumero
    then
      begin {busca siguiente imagen}
        Seek(fImagen,FilePos(fImagen)+lTam);
      end
    else
      with Imagen do
        begin {es la imagen deseada}
          TamanoX:=wX;
          TamanoY:=wY;

          lTamX:=TamanoX;
          lTamY:=TamanoY;
          lSize:=lTamX*lTamY;
          if lSize>65528 then exit; {error}

          GetMem(MapaBits,lSize);
          wSeg:=seg(MapaBits^);
          wOfs:=ofs(MapaBits^);

          pImagenMem:=Ptr(wSeg,wOfs);

          BlockRead(fImagen,pImagenMem^,lSize,wRes);
          {Lectura directa del disco a la memoria del la imagen}

        end; {with Imagen}

    wN:=wN+1;
  end; {Bucle de imagenes en fichero}

close(fImagen);
end; (*procedure LoadImagenSPR*)




procedure SaveImagenSPR(Imagen:tImagen; wNumero:word;
                        sNombre,sPath:string; var iError:integer);
var
 fImagen:file;
 eDirInfo:SearchRec;
 bExiste:boolean;
 iX,iY,i:integer;
 yI:byte;
 wX,wY,wRes,wN,wNumFichero:word;
 w,wSeg,wOfs:word;
 pImagenMem:^byte;


begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if (Extension(sNombre)<>'') and (Mayusculas(Extension(sNombre))<>'SPR') then
  begin
    iError:=7;
    exit;
  end;

if Extension(sNombre)='' then sNombre:=sNombre+'.SPR';


assign(fImagen,sPath+sNombre);
{$I-}
reset(fImagen,1);
{$I+}
if IOResult<>0
then bExiste:=false
else bExiste:=true;
{Si existe el fichero, se sobreescriben imagenes o se a§aden al final}


if bExiste then wNumFichero:=NumeroSPR(sNombre,sPath,i);

if wNumero<0 then
  begin
    iError:=6;
    exit;
  end;

if bExiste then
  begin
    if wNumero>(wNumFichero+1)
    then
      begin
        iError:=6;
        exit;
      end;
  end
else {no existe}
  if wNumero>0
  then
    begin
      iError:=6;
      exit;
    end;


if bExiste
then
  if wNumero>wNumFichero then
    begin {a§adir imagenes al final del fichero SPR}
      reset(fImagen,1);
      seek(fImagen,FileSize(fImagen));
    end
  else
    begin {sobreescribir imagenes del fichero SPR}
      reset(fImagen,1);
      wN:=0;
      while wN<>wNumero do
        begin
          if (EOF(fImagen)) and (wNumero<>0) then
            begin
              iError:=6; {wNumero fuera de rango}
              halt;
            end;
          BlockRead(fImagen,wX,2,wRes);
          BlockRead(fImagen,wY,2,wRes);

          Seek(fImagen,FilePos(fImagen)+wX*wY);
          wN:=wN+1;
        end; (*while*)
    end
else {empezar un nuevo fichero SPR}
  rewrite(fImagen,1);


{Cursor colocado donde hay que escribir}

with Imagen do
  begin
    BlockWrite(fImagen,TamanoX,SizeOf(TamanoX),wRes);
    BlockWrite(fImagen,TamanoY,SizeOf(TamanoY),wRes);

    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    pImagenMem:=Ptr(wSeg,wOfs);

    BlockWrite(fImagen,pImagenMem^,TamanoX*TamanoY,wRes);
  end; (*with Imagen*)

close(fImagen);
end; (*procedure SaveImagenSPR*)










procedure Pausa;
begin
NewKeyInt;

repeat
until not TeclaPulsada;
repeat
until TeclaPulsada;
repeat
until not TeclaPulsada;

OldKeyInt;
end; (*procedure Pausa*)





procedure PausaUnitTeclas;
begin

repeat
until not TeclaPulsada;
repeat
until TeclaPulsada;
repeat
until not TeclaPulsada;

end; (*procedure PausaUnitTeclas*)





procedure Esperar(wMilesimas:word);
var
 wCronoH,wCronoM,wCronoS,wCronoS100:word;
 rParada,rObjetivo:real;

begin
if wMilesimas>0
then
  begin
    getTime(wCronoH,wCronoM,wCronoS,wCronoS100);
    rParada:=wCronoH*3600+wCronoM*60+wCronoS+wCronoS100/100;
    rObjetivo:=rParada+wMilesimas/1000;
    repeat
      getTime(wCronoH,wCronoM,wCronoS,wCronoS100);
    until wCronoH*3600+wCronoM*60+wCronoS+wCronoS100/100>=rObjetivo;
  end;
end; (*procedure Esperar*)





(*á********************   ATRIBUTOS DEL MODO TEXTO   **********************)





procedure DimCursor(iDimension:integer);
var
 regs:Registers;
 iI:integer;

begin
if Byte(Ptr($0040, $49)^)=7
then iI:=6  {monocromo}
else iI:=0; {color}


Regs.AH:=$01;

if iDimension=0 then
  begin
    Regs.CH:=$20;
    Regs.CL:=$20;
  end
else
  if iDimension=2 then
    begin
      Regs.CH:=$0;
      Regs.CL:=$7+iI;
    end
  else
    begin
      Regs.CH:=$6+iI;
      Regs.CL:=$7+iI;
    end;

Intr($10,Regs);
end; (*procedure DimCursor*)





function GetTextColor:byte;
{TextAttr = Textcolor + Textback*16 + bFlashTextColor*128}
var
 iI:integer;

begin
iI:=TextAttr;
if iI>=128 then iI:=TextAttr-128;
GetTextColor:=iI mod 16;
end; (*function GetTextColor*)





function GetTextBackGround:byte;
{TextAttr = Textcolor + Textback*16 + bFlashTextColor*128}
var
 iI:integer;

begin
iI:=TextAttr;
if iI>=128
then iI:=TextAttr-128;
GetTextBackGround:=iI div 16;
end; (*function GetTextBackGround*)





function GetTextFlash:boolean;
{TextAttr : Textcolor + Textback*16 + bFlashTextColor*128}
begin
if TextAttr>=128
then GetTextFlash:=true
else GetTextFlash:=false;
end; (*function GetTextFlash*)





procedure TextFlash(bActivarFlash:boolean);
{TextAttr = Textcolor + Textback*16 + bFlashTextColor*128}
begin

if bActivarFlash
then
  if TextAttr<128
  then TextAttr:=TextAttr+128
else
  if TextAttr>=128
  then TextAttr:=TextAttr-128;
end; (*procedure TextFlash*)





procedure TextBlink(bState:boolean);
begin
{true  -> Modo normal, color fondo 0..7}
{false -> Modo especial, color fondo 0..15}
asm
  mov dx,3dah
  in al,dx
  mov dx,3c0h
  mov al,10h+32
  out dx,al
  inc dx
  in al,dx
  and al,11110111b
  mov ah,bState
  shl ah,3
  or al,ah
  dec dx
  out dx,al
end;
end; (*procedure TextBlink*)





procedure EnableHighBack;
var
 regs:Registers;

begin
{Modo especial, color fondo 0..15}
Regs.ax:=$1003;
Regs.bx:=0;
Intr($10,Regs);
end; (*procedure EnableHighBack*)





procedure DisableHighBack;
var
 regs:Registers;

begin
{Modo normal, color fondo 0..7}
Regs.ax:=$1003;
Regs.bx:=1;
Intr($10,Regs);
end; (*procedure DisableHighBack*)





(*á*****************************   STRINGS  ********************************)





function Mayusculas(sCadena:string):string;
var
 wI:word;

begin
Mayusculas:=sCadena;
for wI:=1 to length(sCadena) do
  if (Ord(sCadena[wI])>=97) and (Ord(sCadena[wI])<=122) then
    Mayusculas[wI]:=Chr(Ord(sCadena[wI])-32)
  else Mayusculas[wI]:=sCadena[wI];
end; (*function Mayusculas*)





function Minusculas(sCadena:string):string;
var
 wI:word;

begin
Minusculas:=sCadena;
for wI:=1 to length(sCadena) do
  if (Ord(sCadena[wI])>=65) and (Ord(sCadena[wI])<=90) then
    Minusculas[wI]:=Chr(Ord(sCadena[wI])+32)
  else Minusculas[wI]:=sCadena[wI];
end; (*function Minusculas*)





procedure QuitarBlancosIni(var sCadena:string);
begin
while (length(sCadena)>0) and (sCadena[1]=' ') do
  delete(sCadena,1,1);
end; (*procedure QuitarBlancosIni*)





procedure QuitarBlancosFin(var sCadena:string);
begin
while sCadena[length(sCadena)]=' ' do
  delete(sCadena,length(sCadena),1);
end; (*procedure quitarBlancosFin*)





function Extension(sNombre:string):string;
var
 sExt:string;

begin
if pos('.',sNombre)=0 then Extension:='' {No hay extension}
else
  begin
    sExt:=(copy(sNombre,pos('.',sNombre)+1,3));
    QuitarBlancosFin(sExt);
    Extension:=sExt;
  end;
end; (*function Extension*)





function QuitaExtension(sNombre:string):string;
begin
if pos('.',sNombre)=0 then QuitaExtension:=sNombre {No hay extension}
  else QuitaExtension:=copy(sNombre,1,pos('.',sNombre)-1);
end; (*function QuitaExtension*)





function Chars(yChar:byte; wNum:word):string;
var
 s:string;
 w:word;

begin
s:='';
for w:=1 to wNum do s:=s+chr(yChar);
Chars:=s;
end; (*function Chars*)





function IntAStr(i:longint):string;
{ Convert any integer type to a string }
var
  S:string[12];
begin
  Str(i, S);
  IntAStr:=S;
end;





function ByteAHex(y:byte):string;
var
 sHex:string;


  function Traducir(y:byte):char;
  begin
  if y<10
  then Traducir:=chr(y+48)  {Ord('0')=48}
  else Traducir:=chr(y+55); {Ord('A')=65. 65-10=55}
  end; (*function traducir*)


begin
sHex:='';
sHex:=sHex+Traducir(y shr 4);  { $12 shr 4  = $1 }
sHex:=sHex+Traducir(y and 15); { $12 and $F = $2 } {15=$F=00001111}

ByteAHex:=sHex;
end; (*function ByteAHex*)





function ByteABin(y:byte):string;
var
 sBin:string;
 i:integer;

begin
sBin:='';
for i:=7 downto 0 do
  if y and (1 shl i)<>0
  then sBin:=sBin+'1'
  else sBin:=sBin+'0';

ByteABin:=sBin;
end; (*ByteABin*)





(*á**********************   MODO GRAFICO & TEXTO   ************************)





procedure GraphTextXY(iX,iY:integer; Variable:real);
{Como OutTextXY pero recibe variables numericas en vez de texto}
var
 sText:string;

begin
str(Variable:0:0,sText);
OutTextXY(iX,iY,sText);
end; (*procedure GraphTextXY*)





procedure GraphText(Variable:real);
{Como OutText pero recibe variables numericas en vez de texto}
var
 sText:string;

begin
str(Variable:0:0,sText);
OutText(sText);
end; (*procedure GraphText*)





function ModoGT:boolean;
{true si estamos en modo grafico}
begin
{GetGraphMode;
if GraphResult=GrOk then
  ModoGT:=false
else}
  ModoGT:=true;
end; (*procedure ModoGT*)





procedure GTWriteReal(Variable:real);

{ GT se refiere a modo Grafico & Texto.                           }
{ Son procedimientos que miran si estamos en modo grafico o en    }
{ modo texto, y segun donde estemos actuaran de una forma u otra. }

begin
if ModoGT then
  GraphText(Variable)
else
  write(Variable:0:0);
end; (*procedure GTWriteReal*)





procedure GTWriteString(sText:string);
begin
if ModoGT
then
  OutText(sText)
else
  write(sText);
end; (*procedure GTWriteString*)





procedure GTWriteRealXY(iX,iY:integer; Variable:real);
begin
if ModoGT then
  GraphTextXY(iX,iY,Variable)
else
  begin
    GotoXY(iX,iY);
    write(Variable:0:0);
  end;
end; (*procedure GTWriteRealXY*)





procedure GTWriteStringXY(iX,iY:integer; sText:string);
begin
if ModoGT
then
  OutTextXY(iX,iY,sText)
else
  begin
    GotoXY(iX,iY);
    write(sText);
  end;
end; (*procedure GTWriteStringXY*)





procedure GTWriteIzqStringXY(iX,iY:integer; sText:string);
var
 iMaxX,iMaxY,x,y,iTextAncho,iTextAlto:integer;
 s:string;

begin
iTextAncho:=TextWidth(sText) div length(sText);
iTextAlto:=TextHeight(sText);
x:=iX;
y:=iY;
iMaxX:=GetMaxX;
iMaxY:=GetMaxY;
s:=sText;

repeat
  {SetColor(0);
  OutTextXY(1,1,'€€');
  OutTextXY(1,10,'€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€');
  Setcolor(15);
  GraphTextXY(1,1,pos(' ',s));
  OutTextXY(1,10,s);
  readln;}

  case pos(' ',s) of
    0:if iMaxX-x>=iTextAncho*length(s)
        then
          begin
            OutTextXY(x,y,s);
            x:=x+iTextAncho*length(s);
            s:='';
          end
        else
          begin
            x:=0;
            y:=y+iTextAlto+2;
          end; {0}

    1:if iMaxX-x>=iTextAncho
        then
          begin
            OutTextXY(x,y,copy(s,1,1));
            {OutTextXY(x,y,'#');}
            x:=x+iTextAncho;
            s:=copy(s,2,length(s)-1);
          end
        else
          begin
            x:=0;
            y:=y+iTextAlto+2;
            s:=copy(s,2,length(s)-1);
          end; {1}

    else if iMaxX-x>=iTextAncho*(pos(' ',s)-1)
           then
             begin
               OutTextXY(x,y,copy(s,1,pos(' ',s)-1));
               x:=x+iTextAncho*(pos(' ',s)-1);
               s:=copy(s,pos(' ',s),length(s)-pos(' ',s)+1);
             end
           else
             begin
               x:=0;
               y:=y+iTextAlto+2;
             end; {else}
  end; (*case*)
until s='';

end; (*procedure GTWriteIzqStringXY*)





procedure GTLocate(iX,iY:integer; bComoTexto:boolean);
{bComoTexto decide si las coordenadas del modo grafico se varian para
  que coincidan con las de modo texto}

begin
if ModoGT
then
  begin
    if bComoTexto
    then MoveTo(iX*8,iY*8) {Funciona asi?}
    else MoveTo(iX,iY);
  end
else GotoXY(iX,iY);
end; (*procedure GTLocate*)





procedure GTCls(yColor:byte);
var
 ySetColor:byte;
 yColorBackGround:byte;
 FillInfo:FillSettingsType; {Guardan valores antiguos}
 Paleta:tPaleta;
 axPantalla: array[1..4] of PointType;

begin
if ModoGT then
  begin
    ySetColor:=GetColor;
    GetFillSettings(FillInfo); {Save fill style and color}
    GetPaleta(Paleta);

    ClearViewPort;
    SetColor(yColor);
    setfillstyle(1,yColor);

    axPantalla[1].X:=0;
    axPantalla[1].Y:=0;
    axPantalla[2].X:=GetMaxX;
    axPantalla[2].Y:=0;
    axPantalla[3].X:=GetMaxX;
    axPantalla[3].Y:=GetMaxY;
    axPantalla[4].X:=0;
    axPantalla[4].Y:=GetMaxY;
    FillPoly(4,axPantalla);

    SetColor(ySetColor);
    with FillInfo do
      SetFillStyle(Pattern, Color); {Restore old fill style and color}
  end
else {Modo Texto}
  begin
    yColorBackGround:=GetTextBackGround;
    TextBackground(yColor);
    ClrScr;
    TextBackground(yColorBackGround);
  end
end; (*procedure GTCls*)





(*á*************************   MODO GRAFICO   ******************************)





procedure Cuadrado(iX1,iY1,iX2,iY2,iColor:integer);
var
 ySetColor:byte;
 OldStyle: LineSettingsType;
 FillInfo:FillSettingsType; {Guardan valores antiguos}
 axVentana: array[1..4] of PointType;

begin
ySetColor:=GetColor;
GetLineSettings(OldStyle);
GetFillSettings(FillInfo); {Save fill style and color}


SetColor(iColor);
SetLineStyle(0, 0, NormWidth);
setfillstyle(1,iColor);

SetColor(iColor);
axVentana[1].X:=iX1;
axVentana[1].Y:=iY1;
axVentana[2].X:=iX2;
axVentana[2].Y:=iY1;
axVentana[3].X:=iX2;
axVentana[3].Y:=iY2;
axVentana[4].X:=iX1;
axVentana[4].Y:=iY2;
SetFillStyle(1,iColor);
FillPoly(4,axVentana);


SetColor(ySetColor);
with FillInfo do
  SetFillStyle(Pattern, Color); {Restore old fill style and color}
with OldStyle do          { Restore old line style }
  SetLineStyle(LineStyle, Pattern, Thickness);

end; (*procedure Cuadrado*)





procedure WaitRetrace; assembler;
{ This waits until you are in a Verticle retrace ... this means that all
  screen manipulation you do only appears on screen in the next verticle
  retrace ... this removes most of the "fuzz" that you see on the screen
  when changing the pallette. It unfortunately slows down your program
  by "synching" your program with your monitor card ... it does mean
  that the program will run at almost the same speed on different
  speeds of computers which have similar monitors. In our SilkyDemo,
  we used a WaitRetrace, and it therefore runs at the same (fairly
  fast) speed when Turbo is on or off. }

 label
  l1, l2;
asm

    mov dx,3DAh
l1:
    in al,dx
    and al,08h
    jnz l1
l2:
    in al,dx
    and al,08h
    jz  l2

end; (*procedure WaitRetrace*)





(*á******************************   PALETA   ******************************)





procedure SetColorPal(Col,R,G,B:Byte);
{Hace lo mismo que: SetRGBPalette(col,r,g,b);}

{cambia el color Col (de 0 a 255) segun tres valores:
 Red,Green,Blue-> valores validos de 0 a 63 (si se pasa dan la vuelta: 66->2)
 La agrupacion de los tres colores producen 64*64*64=262144=64KB posibles
  colores para Col.
(0,0,0) es el negro. (63,63,63) es el blanco.}


{What you do is you enter in the number of the color you want to change into
port $3c8, then enter the values of red, green and blue respectively
into port $3c9:

procedure SetColorPal(Color : Byte; R,G,B : Byte);
Begin
   Port[$3c8] := Color;
   Port[$3c9] := R;
   Port[$3c9] := G;
   Port[$3c9] := B;
End;}


begin
asm
  mov    dx,3c8h    {dx:=3c8h}
  mov    al,[col]   {al:=col}
  out    dx,al      {manda AL(col) al puerto DX(3c8h)}
  inc    dx         {dx:=dx+1  ->3c9h}
  mov    al,[r]     {al:=r}
  out    dx,al      {manda AL(r) al puerto DX(3c9h)}
  mov    al,[g]     {al:=g}
  out    dx,al      {manda AL(g) al puerto DX(3c9h)}
  mov    al,[b]     {al:=b}
  out    dx,al      {manda AL(b) al puerto DX(3c9h)}

{ ah/al ->256   ->2e8  }
{ dx    ->65536 ->2e16 }
end; (*asm*)

{writeln(dx); {3c9h=969}
end; (*procedure SetColorPal*)





procedure GetColorPal(Col:byte; var R,G,B:Byte);

{cambia el color Col (de 0 a 255) segun tres valores:
 Red,Green,Blue-> valores validos de 0 a 63 (si se pasa dan la vuelta: 66->2)
 La agrupacion de los tres colores producen 64*64*64=262144=64KB posibles
  colores para Col.
(0,0,0) es el negro. (63,63,63) es el blanco.}


{This is very easy to do. To read in the pallette value, you enter in the
number of the color you want into port $3c7, then read in the values of
red, green and blue respectively from port $3c9:

procedure GetColorPal(Color : Byte; Var R,G,B : Byte);
Begin
   Port[$3c7] := Color;
   R := Port[$3c9];
   G := Port[$3c9];
   B := Port[$3c9];
End;}


var
 yR,yG,yB:byte;

begin
asm
  mov    dx,3c7h    {dx:=3c7h}
  mov    al,[col]   {al:=col}
  out    dx,al      {manda AL(col) al puerto DX(3c7h)}
  mov    dx,3c9h    {dx:=3c9h}
  in     al,dx      {lee del puerto DX(3c9h) y lo pone en AL(r)}
  mov    [yR],al    {r:=al}
  in     al,dx      {lee del puerto DX(3c9h) y lo pone en AL(g)}
  mov    [yG],al    {g:=al}
  in     al,dx      {lee del puerto DX(3c9h) y lo pone en AL(b)}
  mov    [yB],al    {b:=al}

{ ah/al ->256   ->2e8  }
{ dx    ->65536 ->2e16 }
end; (*asm*)

R:=yR;
G:=yG;
B:=yB;
end; (*procedure GetColorPal*)





procedure SetPal(var Paleta:tPaleta; Col,R,G,B:Byte);
{cambia el color Col (de 0 a 255) segun tres valores:
 Red,Green,Blue-> valores validos de 0 a 63 (si se pasa dan la vuelta: 66->2)
 La agrupacion de los tres colores producen 64*64*64=262144=64KB posibles
  colores para Col.
(0,0,0) es el negro. (63,63,63) es el blanco.}

begin
Paleta[Col].R:=R;
Paleta[Col].G:=G;
Paleta[Col].B:=B;
end; (*procedure SetPal*)





procedure GetPal(Paleta:tPaleta; Col:byte; var R,G,B:Byte);
begin
R:=Paleta[Col].R;
G:=Paleta[Col].G;
B:=Paleta[Col].B;
end; (*procedure GetPal*)





procedure GetPaleta(var Paleta:tPaleta);
{Almacena los 256 colores actuales}
var
 yColor:byte;
 yR,yG,yB:byte;

begin
for yColor:=0 to 255 do
  begin
    GetColorPal(yColor,yR,yG,yB);

    Paleta[yColor].R:=yR;
    Paleta[yColor].G:=yG;
    Paleta[yColor].B:=yB;
  end;
end; (*procedure GetPaleta*)





procedure SetPaleta(Paleta:tPaleta);
{Pone los 256 colores de Paleta:tPaleta}
var
 yColor:byte;

begin
WaitRetrace; (*Espera al refresco de la pantalla*)
for yColor:=0 to 255 do
  SetColorPal(yColor,Paleta[yColor].R,Paleta[yColor].G,Paleta[yColor].B);
end; (*procedure SetPaleta*)





procedure GetPalReservado(iReservaPal:integer; var Paleta:tPaleta);
{Almacena solo los iReservaPal primeros colores}
var
 yColor:byte;
 yR,yG,yB:byte;

begin
for yColor:=0 to iReservaPal do
  begin
    GetColorPal(yColor,yR,yG,yB);

    Paleta[yColor].R:=yR;
    Paleta[yColor].G:=yG;
    Paleta[yColor].B:=yB;
  end;

end; (*procedure GetPalReservado*)





procedure SetPalReservado(iReservaPal:integer; Paleta:tPaleta);
{Pone solo los iReservaPal primeros colores}
var
 yColor:byte;

begin
WaitRetrace;
for yColor:=0 to iReservaPal do
  SetColorPal(yColor,Paleta[yColor].R,Paleta[yColor].G,Paleta[yColor].B);

end; (*procedure SetPalReservado*)





procedure PonPaletaReservado(iReservaPal:integer; PaletaReservada:tPaleta;
                             var Paleta:tPaleta);

{Pone solo los iReservaPal primeros colores.
En vez de enviarlos a la paleta de pantalla los manda a Paleta}
var
 yColor:byte;

begin
for yColor:=0 to iReservaPal do
  begin
    Paleta[yColor].R:=PaletaReservada[yColor].R;
    Paleta[yColor].G:=PaletaReservada[yColor].G;
    Paleta[yColor].B:=PaletaReservada[yColor].B;
  end;
end; (*procedure PonPaletaReservado*)





procedure PonSombras(SombraR,SombraG,SombraB:byte; wDelay:word);
{"Ensombrece" la pantalla progresivamente hasta alcanzar el color dado
 por SombraR,SombraG,SombraB}
var
 PalTemp:tPaleta;
 yI,yJ:byte;

begin
for yI:=0 to 63 do
  begin
    Delay(wDelay);
    WaitRetrace;
    For yJ:=0 to 255 do
      begin
        GetColorPal(yJ,PalTemp[yJ].R,PalTemp[yJ].G,PalTemp[yJ].B);
        If PalTemp[yJ].R>SombraR then dec (PalTemp[yJ].R);
        If PalTemp[yJ].R<SombraR then inc (PalTemp[yJ].R);
        If PalTemp[yJ].G>SombraR then dec (PalTemp[yJ].G);
        If PalTemp[yJ].G<SombraR then inc (PalTemp[yJ].G);
        If PalTemp[yJ].B>SombraR then dec (PalTemp[yJ].B);
        If PalTemp[yJ].B<SombraR then inc (PalTemp[yJ].B);
        SetColorPal(yJ,PalTemp[yJ].R,PalTemp[yJ].G,PalTemp[yJ].B);
      end;
  end; (*for yI*)
end; (*procedure PonSombras*)





procedure QuitaSombras(PaletaBuena:tPaleta; wDelay:word);
{"Clarea" la pantalla progresivamente hasta alcanzar el color dado
 por PaletaBuena}
var
 PalTemp:tPaleta;
 yI,yJ:byte;
{bAumentar:boolean;
 r,g,b:-5..5;
 Rnd:0..5;}

begin
{Cambia un poco algunos colores para que al aumentar desde (0,0,0) no sean
 al ppio todos iguales (grises)}

{for yI:=1 to 150 do
  begin
    r:=0; g:=0; b:=0;
    yJ:=Random(256);
    Getpal(yJ,PalTemp[yJ].R,PalTemp[yJ].G,PalTemp[yJ].B);
    Rnd:=random(4);
    Case Rnd of
      1:begin
          r:=Random(11)-5; (*0..10-5=-5..5*)
          if PalTemp[yJ].R+r<0 then r:=-r
          else if PalTemp[yJ].R+r>63 then r:=-r;
        end;
      2:begin
          g:=Random(11)-5;
          if PalTemp[yJ].R+g<0 then g:=-g
          else if PalTemp[yJ].R+g>63 then g:=-g;
        end;
      3:begin
          b:=Random(11)-5;
          if PalTemp[yJ].R+b<0 then b:=-b
          else if PalTemp[yJ].R+b>63 then b:=-b;
        end;
    end; (*case*)
    SetPal(yJ,PalTemp[yJ].R+r,PalTemp[yJ].G+g,PalTemp[yJ].B+b);
  end;}

for yI:=0 to 63 do
  begin
    Delay(wDelay);
    WaitRetrace;
    For yJ:=0 to 255 do
      begin
        GetColorPal(yJ,PalTemp[yJ].R,PalTemp[yJ].G,PalTemp[yJ].B);
        If PalTemp[yJ].R>PaletaBuena[yJ].R then dec (PalTemp[yJ].R);
        If PalTemp[yJ].R<PaletaBuena[yJ].R then inc (PalTemp[yJ].R);
        If PalTemp[yJ].G>PaletaBuena[yJ].G then dec (PalTemp[yJ].G);
        If PalTemp[yJ].G<PaletaBuena[yJ].G then inc (PalTemp[yJ].G);
        If PalTemp[yJ].B>PaletaBuena[yJ].B then dec (PalTemp[yJ].B);
        If PalTemp[yJ].B<PaletaBuena[yJ].B then inc (PalTemp[yJ].B);
        SetColorPal(yJ,PalTemp[yJ].R,PalTemp[yJ].G,PalTemp[yJ].B);
      end;

  end; (*for yI*)
end; (*procedure QuitaSombras*)





procedure LoadPaleta(var Paleta:tPaleta; sNombre,sPath:string;
                     var iError:integer);

{El nombre no tiene que tener extension .PAL
Si no encuentra el fichero da iError=1
Si es de un tipo desconocido da iError=2}

var
 fPaleta:file of tPaleta;
 eDirInfo: SearchRec;
 PaletaTemp:tPaleta;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
{if (Extension(sNombre)<>'') and (Mayusculas(Extension(sNombre))<>'PAL') then
  begin
    GTCls(0);
    SetColor(15);
    GTWriteStringXY(1,1,'Archivo PAL con extension desconocida -> ');
    GTWriteStringXY(42*8,1,Extension(sNombre));
    readln;
    halt;
  end;}
{if Mayusculas(Extension(sNombre))<>'PAL' then sNombre:=sNombre+'.pal';}

FindFirst(sPath+sNombre,Archive,eDirInfo);


{
GTCls(0);
SetColor(15);
GTWriteString(sPath+sNombre);
readln;
halt;
}


if DosError<>0 then {no encontrado}
  iError:=1
else {si existe}
  begin
    assign(fPaleta,sPath+sNombre);
    reset(fPaleta);

    {$I-}
    read(fPaleta,PaletaTemp);
    {$I+}

    if IOResult<>0
    then iError:=2
    else Paleta:=PaletaTemp;

    close(fPaleta);
  end;

end; (*procedure LoadPaleta*)






procedure SavePaleta(Paleta:tPaleta; sNombre,sPath:string;
                     bSobreEscribir:boolean; var iError:integer);

{Dar el sNombre sin .pal
Si bSobreescribir es true y el fichero ya existe se sobreescribira (Error=4),
 si es false no hara nada y devuelve iError=3}

var
 fPaleta:file of tPaleta;
 eDirInfo: SearchRec;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if (Extension(sNombre)<>'') and (Mayusculas(Extension(sNombre))<>'PAL') then
  begin
    GTCls(0);
    SetColor(15);
    GTWriteStringXY(1,1,'Archivo PAL con extension desconocida -> ');
    GTWriteStringXY(42*8,1,Extension(sNombre));
    readln;
    halt;
  end;

if Mayusculas(Extension(sNombre))<>'PAL' then sNombre:=sNombre+'.pal';
FindFirst(sPath+sNombre,Archive,eDirInfo);

if DosError<>0 then {no encontrado}
  begin
   assign(fPaleta,sPath+sNombre);
   rewrite(fPaleta);
   write(fPaleta,Paleta);
   close(fPaleta);
  end
else {si existe}
  begin
   if bSobreEscribir then
     begin
      assign(fPaleta,sPath+sNombre);
      rewrite(fPaleta);
      write(fPaleta,Paleta);
      close(fPaleta);
     end
   else iError:=3; {ya existe y no ponemos sobreescribir}
  end;

end; (*procedure SavePaleta*)





function PaletaErrorMsg(iCodigoError:integer):string;
begin
case iCodigoError of
  0:PaletaErrorMsg:='No error';
  1:PaletaErrorMsg:='Fichero no encontrado';
  2:PaletaErrorMsg:='Formato desconocido';
  3:PaletaErrorMsg:='Fichero existente. No sobreescribir';
  4:PaletaErrorMsg:='Fichero existente sobreescrito';
end;
end; (*function PaletaErrorMsg*)





procedure InviertePaleta(var Paleta:tPaleta);
var
 iI:integer;
 PaletaAux:tPaleta;

begin
for iI:=0 to 255 do
  PaletaAux[iI]:=Paleta[iI];
for iI:=0 to 255 do
  Paleta[iI]:=PaletaAux[255-iI];
end; (*procedure InviertePaleta*)





procedure PaletaDe(var Paleta:tPaleta; r,g,b:byte);
{crea una paleta con todos colores igual a (r,gb)}
var
 iI:integer;

begin
for iI:=0 to 255 do
  begin
    Paleta[iI].r:=r;
    Paleta[iI].g:=g;
    Paleta[iI].b:=b;
  end;
end; (*procedure PaletaDe*)





(*á******************   PANTALLAS VIRTUALES  ( WHERE )   ********************)





function CrearPantalla:word;
var
  pPant:pointer;
begin
  GetMem(pPant,SizeOf(tPantalla));
  CrearPantalla:=Seg(pPant^);
end;





procedure flip(wDesde,wHasta:Word); assembler;
  { This copies the entire screen at "source" to destination }
asm
  push    ds
  mov     ax, [wHasta]
  mov     es, ax
  mov     ax, [wDesde]
  mov     ds, ax
  xor     si, si
  xor     di, di
  mov     cx, 16000
  db      $F3, $66, $A5
  pop     ds
end;





procedure ClsWhere(yColor:Byte; where:word); assembler;
{This clears the screen to the specified color
 Solo para 320*200}
asm
   push    es
   mov     cx, 16000;
   mov     es,[where]
   xor     di,di
   mov     al,[yColor]
   mov     ah,al
   mov     dx, ax
   db      $66, $C1, $E0, $10         {shl eax, 16}
   mov     ax, dx
   db      $F3, $66, $AB              {rep stosd}
   pop     es
end; (*procedure Cls32*)





procedure PutPixelWhere(iX,iY:integer; yColor:byte; where:word);
var
 w:word;

begin
{mem[where:iY*320+iX]:=yColor;}



asm
  mov ax,iY
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,iX
  mov ax,where
  mov es,ax
  mov es,where
  mov al,yColor
  mov es:[bx],al
end;



(*
asm
  push    ds              {; Make sure these two go out the }
  push    es              {; same they went in }
  mov     ax,[where]
  mov     es,ax           {; Point to segment of screen }
  mov     bx,[iX]
  mov     dx,[iY]
  push    bx              {; and this again for later}
  mov     bx, dx          {; bx = dx}
  mov     dh, dl          {; dx = dx * 256}
  xor     dl, dl
  {shl     bx, 1
  shl     bx, 1
  shl     bx, 1
  shl     bx, 1
  shl     bx, 1
  shl     bx, 1           {; bx = bx * 64}
  shl     bx, 6
  add     dx, bx          {; dx = dx + bx (ie y*320)}
  pop     bx              {; get back our x}
  add     bx, dx          {; finalise location}
  mov     di, bx          {; di = offset }
                          {; es:di = where to go}
  xor     al,al
  mov     ah, [yColor]
  mov     es:[di],ah      {; move the value in ah to screen point es:[di] }
  pop     es
  pop     ds
end;
*)

end; (*procedure PutPixelWhere*)





procedure PutPixelWhere320(iX,iY:integer; yColor:byte; where:word);
var
 w:word;

begin
if (iX>=0) and (iX<320) and (iY>=0) and (iY<200) then
asm
  mov ax,iY
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,iX
  mov ax,where
  mov es,ax
  mov es,where
  mov al,yColor
  mov es:[bx],al
end;
end;





procedure PutPixelWhereLento(iX,iY:integer; yColor:byte; where:word);
begin
mem[where:iY*320+iX]:=yColor;
end; (*procedure PutPixelWhereLento*)





function GetPixelWhere(iX,iY:integer; where:word):byte;
begin
asm
  mov ax,iY
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,iX
  mov ax,where
  mov es,ax
  mov al,es:[bx]
  mov @result,al
end;
end; (*GetPixelWhere*)





procedure LineWhere(x1,y1,x2,y2:integer; col:byte; where:word);
{This draws a line from x1,y1 to x2,y2 using the first method}


  function sgn(a:real):integer;
  begin
  if a>0 then sgn:=+1;
  if a<0 then sgn:=-1;
  if a=0 then sgn:=0;
  end;


var
 i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;

begin
u:= x2 - x1;
v:= y2 - y1;
d1x:= sgn(u);
d1y:= sgn(v);
d2x:= sgn(u);
d2y:= 0;
m:= abs(u);
n := abs(v);
IF NOT (M>N) then
  BEGIN
    d2x := 0 ;
    d2y := sgn(v);
    m := abs(v);
    n := abs(u);
  END;
s:= m shr 1;
FOR i := 0 TO m DO
  BEGIN
    PutPixelWhere(x1,y1,col,where);
    s:= s + n;
    IF not (s<m) THEN
      BEGIN
        s:=s-m;
        x1:=x1+d1x;
        y1:=y1+d1y;
      END
    ELSE
      BEGIN
        x1:=x1+d2x;
        y1:=y1+d2y;
      END;
  end;

end; (*procedure LineWhere*)





procedure LineWhere320(x1,y1,x2,y2:integer; col:byte; where:word);
{Sin salirse de los 320*200}

  function sgn(a:real):integer;
  begin
  if a>0 then sgn:=+1;
  if a<0 then sgn:=-1;
  if a=0 then sgn:=0;
  end;


var
 i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;

begin
u:= x2 - x1;
v:= y2 - y1;
d1x:= sgn(u);
d1y:= sgn(v);
d2x:= sgn(u);
d2y:= 0;
m:= abs(u);
n := abs(v);
IF NOT (M>N) then
  BEGIN
    d2x := 0 ;
    d2y := sgn(v);
    m := abs(v);
    n := abs(u);
  END;
s:= m shr 1;
FOR i := 0 TO m DO
  BEGIN
    if (x1>0) and (x1<320) and (y1>0) and (y1<200) then
      PutPixelWhere(x1,y1,col,where);
    s:= s + n;
    IF not (s<m) THEN
      BEGIN
        s:=s-m;
        x1:=x1+d1x;
        y1:=y1+d1y;
      END
    ELSE
      BEGIN
        x1:=x1+d2x;
        y1:=y1+d2y;
      END;
  end;

end; (*procedure LineWhere320*)





procedure CirculoWhere(x,y,radio:integer; color:byte; where:word);
var
 d:integer;
 x2,y2:integer;

begin
d:=3-(radio shl 1);
PutPixelWhere(x-radio,y,color,where);
PutPixelWhere(x+radio,y,color,where);
PutPixelWhere(x,y+radio,color,where);
PutPixelWhere(x,y-radio,color,where);
x2:=0;
y2:=radio;
while (x2<y2) do
  begin
    if d<0
    then d:=d+(x2 shl 2)+6
    else
      begin
        d:=d+((x2-y2)shl 2)+10;
        y2:=y2-1;
      end;
    x2:=x2+1;
    PutPixelWhere(x+x2,y+y2,color,where);
    PutPixelWhere(x-x2,y+y2,color,where);
    PutPixelWhere(x+x2,y-y2,color,where);
    PutPixelWhere(x-x2,y-y2,color,where);
    PutPixelWhere(x+y2,y+x2,color,where);
    PutPixelWhere(x-y2,y+x2,color,where);
    PutPixelWhere(x+y2,y-x2,color,where);
    PutPixelWhere(x-y2,y-x2,color,where);
  end;
end; (*procedure CirculoWhere*)





procedure WriteWhere(iX,iY,iColor,iFondo:integer; sText:string; where:word);

{Tama§o de cada letra: x=8,y=8}
{si iColor o iFondo son -1 entonces no se dibuja}

var
 c:char;
 i,j,z,b:integer;
 regs:registers;

begin
if bProcedureWriteWhere then
  begin
    regs.ax:=$1130;
    regs.bh:=3;
    intr($10,regs);
    pProcedureWriteWhere:=ptr(regs.es,regs.bp);
    bProcedureWriteWhere:=false;
  end;

for z:=1 to length(sText) do
  begin
    c:=sText[z];
    for j:=0 to 7 do
      begin
        b:=pProcedureWriteWhere^[c][j];
        for i:=iX+7 downto iX do
          begin
            if odd(b) {impar -> si el ultimo bit es uno}
            then
              begin
                if iColor<>-1
                then PutPixelWhere(i,iY+j,iColor,where)
              end
            else
              begin
                if iFondo<>-1
                then PutPixelWhere(i,iY+j,iFondo,where);
              end;
            b:=b shr 1;
          end;
      end;
    inc(iX,8);
  end;

end; (*procedure WriteWhere*)





procedure WriteColorWhere(iX,iY,iFondo:integer; sText:string;
                          color:tColor8; where:word);

{Tama§o de cada letra: x=8,y=8}
{con Color[8] y el fondo no se dibuja}

var
 c:char;
 i,j,z,b:integer;
 regs:registers;

begin
if bProcedureWriteWhere then
  begin
    regs.ax:=$1130;
    regs.bh:=3;
    intr($10,regs);
    pProcedureWriteWhere:=ptr(regs.es,regs.bp);
    bProcedureWriteWhere:=false;
  end;

for z:=1 to length(sText) do
  begin
    c:=sText[z];
    for j:=0 to 7 do
      begin
        b:=pProcedureWriteWhere^[c][j];
        for i:=iX+7 downto iX do
          begin
            if odd(b) {impar -> si el ultimo bit es uno}
            then
              begin
                if color[j]<>-1
                then PutPixelWhere(i,iY+j,color[j],where)
              end
            else
              begin
                if iFondo<>-1
                then PutPixelWhere(i,iY+j,iFondo,where);
              end;
            b:=b shr 1;
          end;
      end;
    inc(iX,8);
  end;

end; (*procedure WriteWhere*)





procedure Write16Where(iX,iY,iColor,iFondo:integer; sText:string; where:word);
{Tama§o de cada letra: x=8,y=16}
{si iColor o iFondo son -1 entonces no se dibuja}

type
 pChar=array[char] of array[0..15] of byte;
var
 p:^pChar;
 c:char;
 i,j,z,b:integer;
 regs:registers;

begin
regs.ax:=$1130;
regs.bh:=6;
intr($10,regs);
p:=ptr(regs.es,regs.bp);

for z:=1 to length(sText) do
  begin
    c:=sText[z];
    for j:=0 to 15 do
      begin
        b:=p^[c][j];
        for i:=iX+7 downto iX do
          begin
            if odd(b) {impar -> si el ultimo bit es uno}
            then
              begin
                if iColor<>-1
                then PutPixelWhere(i,iY+j,iColor,where)
              end
            else
              begin
                if iFondo<>-1
                then PutPixelWhere(i,iY+j,iFondo,where);
              end;
            b:=b shr 1;
          end;
      end;
    inc(iX,8);
  end;

end; (*procedure Write16Where*)





procedure CuadradoWhere(iX1,iY1,iX2,iY2:integer; col:byte; where:word);
var
  y:integer;
begin
  for y:=iY1 to iY2 do
    LineWhere(iX1,y,iX2,y,col,where);
end;





procedure RectangleWhere(iX1,iY1,iX2,iY2:integer; col:byte; where:word);
begin
  LineWhere(iX1,iY1,iX2,iY1,col,where);
  LineWhere(iX1,iY2,iX2,iY2,col,where);
  LineWhere(iX1,iY1,iX1,iY2,col,where);
  LineWhere(iX2,iY1,iX2,iY2,col,where);
end;





(*á*************************   IMAGENES   *********************************)





procedure GetImagen(iXini,iYini,iXfin,iYfin:integer; var Imagen:tImagen);
var
 iX,iY:integer;
 iMaxX,iMaxY:integer;
 w,wSeg,wOfs:word;
 lTamX,lTamY,lSize:longint;

begin
iMaxX:=GetMaxX;
iMaxY:=GetMaxY;

with Imagen do
  begin
    TamanoX:=iXfin-iXini+1;
    TamanoY:=iYfin-iYini+1;

    lTamX:=TamanoX;
    lTamY:=TamanoY;
    lSize:=lTamX*lTamY;
    if lSize>65528 then exit; {error}

    GetMem(MapaBits,lSize);
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=iYini to iYfin do
      for iX:=iXini to iXfin do
        begin
          if (iX>=iMaxX) or (iY>=iMaxY)
          then mem[wSeg:wOfs+w]:=0
          else mem[wSeg:wOfs+w]:=GetPixel(iX,iY);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure GetImagen*)





procedure GetImagenWhere(iXini,iYini,iXfin,iYfin:integer; var Imagen:tImagen;
                         where:word);
var
 iX,iY:integer;
 iMaxX,iMaxY:integer;
 w,wSeg,wOfs:word;
 lTamX,lTamY,lSize:longint;

begin
iMaxX:=320;
iMaxY:=200;

with Imagen do
  begin
    TamanoX:=iXfin-iXini+1;
    TamanoY:=iYfin-iYini+1;

    lTamX:=TamanoX;
    lTamY:=TamanoY;
    lSize:=lTamX*lTamY;
    if lSize>65528 then exit; {error}

    GetMem(MapaBits,lSize);
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=iYini to iYfin do
      for iX:=iXini to iXfin do
        begin
          if (iX>=iMaxX) or (iY>=iMaxY)
          then mem[wSeg:wOfs+w]:=0
          else mem[wSeg:wOfs+w]:=GetPixelWhere(iX,iY,where);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure GetImagenWhere*)





function GetPixelImagen(iX,iY:integer; Imagen:tImagen):byte;
{Empieza en 0,0}
var
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=iY*TamanoX+iX-1; {FUNCIONA???}
    GetPixelImagen:=mem[wSeg:wOfs+w];
  end; (*with Imagen*)
end; (*procedure GetPixelImagen*)





procedure GetImagenImagen(iXini,iYini,iXfin,iYfin:integer; var Hasta:tImagen;
                          var Desde:tImagen);
var
 iX,iY:integer;
 iMaxX,iMaxY:integer;
 w,wSeg,wOfs:word;
 lTamX,lTamY,lSize:longint;

begin
iMaxX:=GetMaxX;
iMaxY:=GetMaxY;

with Hasta do
  begin
    TamanoX:=iXfin-iXini+1;
    TamanoY:=iYfin-iYini+1;

    lTamX:=TamanoX;
    lTamY:=TamanoY;
    lSize:=lTamX*lTamY;
    if lSize>65528 then exit; {error}

    GetMem(MapaBits,lSize);
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=iYini to iYfin do
      for iX:=iXini to iXfin do
        begin
          if (iX>=Desde.TamanoX) or (iY>=Desde.TamanoY)
          then mem[wSeg:wOfs+w]:=0
          else mem[wSeg:wOfs+w]:=GetPixelImagen(iX,iY,Desde);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure GetImagenImagen*)





procedure FreeImagen(var Imagen:tImagen);
var
 lTamX,lTamY,lSize:longint;

begin
with Imagen do
  begin
    lTamX:=TamanoX;
    lTamY:=TamanoY;
    lSize:=lTamX*lTamY;
    FreeMem(MapaBits,lSize);
    TamanoX:=0;
    TamanoY:=0;
  end; (*with Imagen*)
end; (*procedure FreeImagen*)





procedure PutImagen(Imagen:tImagen);
{La pone en 0,0}
var
 iX,iY:integer;
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=0 to TamanoY-1 do
      for iX:=0 to TamanoX-1 do
        begin
          PutPixel(iX,iY,mem[wSeg:wOfs+w]);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagen*)





procedure PutImagenXY(iXini,iYini:integer; Imagen:tImagen);
var
 iX,iY:integer;
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=iYini to iYini+TamanoY-1 do
      for iX:=iXini to iXini+TamanoX-1 do
        begin
          PutPixel(iX,iY,mem[wSeg:wOfs+w]);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXY*)





procedure PutImagenXYWhere(iXini,iYini:integer; Imagen:tImagen; where:word);
var
 iX,iY:integer;
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=iYini to iYini+TamanoY-1 do
      for iX:=iXini to iXini+TamanoX-1 do
        begin
          PutPixelWhere(iX,iY,mem[wSeg:wOfs+w],where);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYWhere*)





procedure PutImagenXYXY(iX,iY,iXini,iYini,iXfin,iYfin:integer; Imagen:tImagen);
{coloca en iX,iY un trozo de la imagen dado por iXini,iYini - iXfin,iYfin}
var
 x,y:integer;
 ImagenX,ImagenY:integer; {diferencia entre iX y iXini}
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    ImagenX:=iXini-iX;
    ImagenY:=iYini-iY;

    for y:=iY to iY+iYfin-iYini do
      for x:=iX to iX+iXfin-iXini do
        begin
          w:=(y+ImagenY)*TamanoX+(x+ImagenX);
          PutPixel(x,y,mem[wSeg:wOfs+w]);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYXY*)





procedure PutImagenXYXYWhere(iX,iY,iXini,iYini,iXfin,iYfin:integer;
                             Imagen:tImagen; where:word);
{coloca en iX,iY un trozo de la imagen dado por iXini,iYini - iXfin,iYfin}
var
 x,y:integer;
 ImagenX,ImagenY:integer; {diferencia entre iX y iXini}
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    ImagenX:=iXini-iX;
    ImagenY:=iYini-iY;

    for y:=iY to iY+iYfin-iYini do
      for x:=iX to iX+iXfin-iXini do
        begin
          w:=(y+ImagenY)*TamanoX+(x+ImagenX);
          PutPixelWhere(x,y,mem[wSeg:wOfs+w],where);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYXYWhere*)





procedure PutImagenXYTam(iX,iY,iXini,iYini,iTamX,iTamY:integer; Imagen:tImagen);
{coloca en iX,iY un trozo de la imagen dado por iXini - iXini+iTamX}
var
 x,y:integer;
 ImagenX,ImagenY:integer; {diferencia entre iX y iXini}
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    ImagenX:=iXini-iX;
    ImagenY:=iYini-iY;

    for y:=iY to iY+iTamY-1 do
      for x:=iX to iX+iTamX-1 do
        begin
          w:=(y+ImagenY)*TamanoX+(x+ImagenX);
          PutPixel(x,y,mem[wSeg:wOfs+w]);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYTam*)





procedure PutImagenXYTamWhere(iX,iY,iXini,iYini,iTamX,iTamY:integer;
                             Imagen:tImagen; where:word);
{coloca en iX,iY un trozo de la imagen dado por iXini - iXini+iTamX}
{ESPECIAL PARA IMAGENES REPETITIVAS}
var
 x,y:integer;             {punto actual en pantalla}
 ImagenX,ImagenY:integer; {punto actual de la imagen}
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    ImagenX:=iXini;
    ImagenY:=iYini;
    for y:=iY to iY+iTamY-1 do
      begin
        for x:=iX to iX+iTamX-1 do
          begin
            w:=ImagenY*TamanoX+ImagenX;
            PutPixelWhere(x,y,mem[wSeg:wOfs+w],where);
            inc(ImagenX);
            if ImagenX>TamanoX-1
            then ImagenX:=0;
          end;
        ImagenX:=iXini;
        inc(ImagenY);
        if ImagenY>TamanoY-1
        then ImagenY:=0;
      end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYTamWhere*)





procedure PutImagenTxt(Imagen:tImagen);
var
 iX,iY:integer;
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=1 to TamanoY do
      for iX:=1 to TamanoX do
        begin
          gotoXY(iX*4,iY);
          write(mem[wSeg:wOfs+w]);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenTxt*)





procedure PutImagenBig(Imagen:tImagen; iRadio:integer);
var
 iX,iY:integer;
 w,wSeg,wOfs:word;


  procedure PutPixelBig(iX,iY,iRadio,iColor:integer);
  var
   x,y:integer;
  begin
  for x:=iX to iX+iRadio-1 do
    for y:=iY to iY+iRadio-1 do
      PutPixel(x,y,iColor);
  end; (*procedure PutPixelBig*)


begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=0 to TamanoY-1 do
      for iX:=0 to TamanoX-1 do
        begin
          PutPixelBig(iX*iRadio,iY*iRadio,iRadio,mem[wSeg:wOfs+w]);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenBig*)





procedure PutImagenXYBig(iX,iY:integer; Imagen:tImagen; iRadio:integer);
var
 x,y:integer;
 w,wSeg,wOfs:word;


  procedure PutPixelBig(iX,iY,iRadio,iColor:integer);
  var
   x,y:integer;
  begin
  for x:=iX to iX+iRadio-1 do
    for y:=iY to iY+iRadio-1 do
      PutPixel(x,y,iColor);
  end; (*procedure PutPixelBig*)


begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for y:=0 to TamanoY-1 do
      for x:=0 to TamanoX-1 do
        begin
          PutPixelBig(x*iRadio+iX,y*iRadio+iY,iRadio,mem[wSeg:wOfs+w]);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYBig*)





procedure PutImagenSin(Imagen:tImagen; iSin:integer);
var
 iX,iY:integer;
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=0 to TamanoY-1 do
      for iX:=0 to TamanoX-1 do
        begin
          if mem[wSeg:wOfs+w]<>iSin
          then PutPixel(iX,iY,mem[wSeg:wOfs+w]);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenSin*)





procedure PutImagenXYSin(iXini,iYini:integer; Imagen:tImagen; iSin:integer);
var
 iX,iY:integer;
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=iYini to iYini+TamanoY-1 do
      for iX:=iXini to iXini+TamanoX-1 do
        begin
          if mem[wSeg:wOfs+w]<>iSin
          then PutPixel(iX,iY,mem[wSeg:wOfs+w]);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYSin*)





procedure PutImagenXYSinWhere(iXini,iYini:integer; Imagen:tImagen;
                              iSin:integer; where:word);
var
 iX,iY:integer;
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=iYini to iYini+TamanoY-1 do
      for iX:=iXini to iXini+TamanoX-1 do
        begin
          if mem[wSeg:wOfs+w]<>iSin
          then PutPixelWhere(iX,iY,mem[wSeg:wOfs+w],where);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYSinWhere*)





procedure PutImagenXYSinWhere320(iXini,iYini:integer; Imagen:tImagen;
                                 iSin:integer; where:word);
var
 iX,iY:integer;
 w,wSeg,wOfs:word;

begin
with Imagen do
  begin
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);

    w:=0;
    for iY:=iYini to iYini+TamanoY-1 do
      for iX:=iXini to iXini+TamanoX-1 do
        begin
          if (iX>=0) and (iX<320) and (iY>=0) and (iY<200) and
             (mem[wSeg:wOfs+w]<>iSin) then
            PutPixelWhere(iX,iY,mem[wSeg:wOfs+w],where);
          inc(w);
        end;
  end; (*with Imagen*)
end; (*procedure PutImagenXYSinWhere320*)





(*á**********************   INICIAR MODO GRAFICO   ************************)





procedure IniciaSVGA256(iModo:integer; sPath:string; var iError:integer);
{IniciaSVGA256(yModo,'c:\bgi',iError);}
{ 0 -  320*200*256 }
{ 1 -  640*400*256 }
{ 2 -  640*480*256 }
{ 3 -  800*600*256 }
{ 4 - 1024*768*256 }

CONST
 Nuevo ='Svga256';
VAR
 iDriver,iNuevoDrv:integer;


  {$F+}
  FUNCTION Compatible:INTEGER;
  CONST
   Comprueba=TRUE;
   Defecto=3;

  BEGIN
  IF Comprueba
    THEN Compatible:=GrError
    ELSE Compatible:=Defecto;
  END; (*Compatible*)
  {$F-}


BEGIN
iNuevoDrv:=InstallUserDriver(Nuevo,@Compatible);

iError:=GraphResult;
if iError<>GrOK then
  begin
   iError:=99;
   Exit;
  end;

{IF GraphResult <> GrOK THEN
  BEGIN
    Writeln('ERROR DE INSTALACI¢N DE ',Nuevo);
    Halt(1);
  END;}


iDriver:=Detect;
InitGraph(iNuevoDrv,iModo,sPath);

iError:=GraphResult;

{iCodigoError:= GraphResult;
IF iCodigoError <> GrOK THEN
  BEGIN
    WRITELN('ERROR DE INICIALIZACI¢N: ', GraphErrorMsg(iCodigoError));
    readln;
    {HALT(1);}
    {Exit;
  END;}

end; (*procedure IniciaSVGA256*)





(*á*************************   DIBUJA INFO   ******************************)





procedure WritePaleta(Paleta:tPaleta; sPath:string);
{Escribe en 4 columnas y 2 pantallas, la paleta ordenada
pero los colores con que escribe son los de la paleta actual
para que quede normal hacer antes SetPaleta(paleta)}

var
 iI:integer;
 yI:byte;
 PaletaAux:tPaleta;
 iError:integer;

begin
GetPaleta(PaletaAux);
IniciaSVGA256(1,sPath,iError);
SetPaleta(PaletaAux);
iI:=0;

for yI:=1 to 40 do {40}
  begin
    SetColor(iI);
    GraphTextXY(10,yI*10,iI);
    GraphTextXY(40,yI*10,Paleta[iI].r);
    GraphTextXY(60,yI*10,Paleta[iI].g);
    GraphTextXY(80,yI*10,Paleta[iI].b);
    iI:=iI+1
  end;

for yI:=1 to 40 do {80}
  begin
    SetColor(iI);
    GraphTextXY(150,yI*10,iI);
    GraphTextXY(180,yI*10,Paleta[iI].r);
    GraphTextXY(200,yI*10,Paleta[iI].g);
    GraphTextXY(220,yI*10,Paleta[iI].b);
    iI:=iI+1
  end;

for yI:=1 to 40 do {120}
  begin
    SetColor(iI);
    GraphTextXY(310,yI*10,iI);
    GraphTextXY(340,yI*10,Paleta[iI].r);
    GraphTextXY(360,yI*10,Paleta[iI].g);
    GraphTextXY(380,yI*10,Paleta[iI].b);
    iI:=iI+1
  end;

for yI:=1 to 40 do {160}
  begin
    SetColor(iI);
    GraphTextXY(450,yI*10,iI);
    GraphTextXY(480,yI*10,Paleta[iI].r);
    GraphTextXY(500,yI*10,Paleta[iI].g);
    GraphTextXY(520,yI*10,Paleta[iI].b);
    iI:=iI+1
  end;

readln;


ClearViewPort;
for yI:=1 to 40 do {200}
  begin
    SetColor(iI);
    GraphTextXY(10,yI*10,iI);
    GraphTextXY(40,yI*10,Paleta[iI].r);
    GraphTextXY(60,yI*10,Paleta[iI].g);
    GraphTextXY(80,yI*10,Paleta[iI].b);
    iI:=iI+1
  end;

for yI:=1 to 40 do {240}
  begin
    SetColor(iI);
    GraphTextXY(150,yI*10,iI);
    GraphTextXY(180,yI*10,Paleta[iI].r);
    GraphTextXY(200,yI*10,Paleta[iI].g);
    GraphTextXY(220,yI*10,Paleta[iI].b);
    iI:=iI+1
  end;

for yI:=1 to 16 do {255}
  begin
    SetColor(iI);
    GraphTextXY(310,yI*10,iI);
    GraphTextXY(340,yI*10,Paleta[iI].r);
    GraphTextXY(360,yI*10,Paleta[iI].g);
    GraphTextXY(380,yI*10,Paleta[iI].b);
    iI:=iI+1
  end;

readln;

end; (*procedure WritePaleta*)





procedure DibujaMem;
begin
setcolor(0);
OutTextXY(10,GetMaxY-20,'€€€€€€€€'); {Borra lo escrito antes}
setcolor(15);
GraphTextXY(10,GetMaxY-20,MaxAvail);
end; (*procedure DibujaMem*)








begin

bProcedureWriteWhere:=true;

end.


