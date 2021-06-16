unit pcx;


interface


uses imagen, graph;


type
tCabeceraPCX=record
               firma:byte; {cada casa tiene un numero reservado}
               version:byte; {5 la normal}
               compresion:byte;
               bitsPixel:byte; {N§ de bits por cada pixel}
               minX:word;
               minY:word;
               maxX:word;
               maxY:word;
               ppX:word; {resolucion por pulgada}
               ppY:word; {resolucion por pulgada}
               paleta16:array[0..15] of
                 record
                   R:byte;
                   G:byte;
                   B:byte;
                 end;
               reservado:byte;
               planos:byte;
               bytesLinea:word; {N§ de Puntos en cada Fila}
               paletaInfo:word;
               tamanoX:word; {No se usa mucho}
               tamanoY:word; {No se usa mucho}
               cero:array[0..54] of byte; {Reservados para futuras versiones}
             end; {TOTAL=129 bytes}

tColor256=record
            Puntos:array[1..256] of byte;
            Num:word; {de 0 a 256 puntos}
          end;


{ Pcx a pantalla }
procedure LoadPcx(sNombre,sPath:string; bLoadPal:boolean; var iError:integer);
procedure LoadPcxXY(sNombre,sPath:string; iX,iY:integer;
                    bLoadPal:boolean; var iError:integer);
procedure LoadPcxWhere(sNombre,sPath:string; bLoadPal:boolean; Where:word;
                       var iError:integer);
procedure LoadPcxXYWhere(sNombre,sPath:string; iX,iY:integer;
                         bLoadPal:boolean; Where:word; var iError:integer);
{ Pcx a imagen }
procedure LoadImagenPcx(sNombre,sPath:string; var Imagen:tImagen;
                        var iError:integer);
procedure LoadImagenPcxXY(sNombre,sPath:string; iXini,iYini,iXfin,iYfin:integer;
                          var Imagen:tImagen; var iError:integer);

{ Paletas }
procedure GetPalPcx(sNombre,sPath:string; var Paleta:tPaleta;
                    var iError:integer); {pone paleta del pcx en variable}
procedure PutPalPcx(Paleta:tPaleta; sNombre,sPath:string; var iError:integer);
  {pone variable en paleta del pcx}

{ Otras }
procedure GetCabeceraPCX(sNombre,sPath:string; var Cabecera:tCabeceraPCX;
                         var iError:integer);
procedure WriteCabeceraPCX(Cabecera:tCabeceraPCX);
procedure CopyPcx(sNombre1,sPath1,sNombre2,sPath2:string; Color1,Color2:integer;
                  bSobreEscribir:boolean; iError:integer); {Copia los ficheros}
procedure CopyColor256(sNombre1,sPath1,sNombre2,sPath2:string;
                       Color:tColor256; yPos:byte;
                       bSobreEscribir:boolean; iError:integer);
procedure GetColor256(sNombre,sPath:string; var Color:tColor256;
                      iError:integer);
procedure GetColor256Sin(sNombre,sPath:string; var Color:tColor256;
                         iSin,iError:integer);





implementation





procedure LoadPcx(sNombre,sPath:string; bLoadPal:boolean; var iError:integer);
var
 f:file;
 Cabecera:tCabeceraPCX;
 iTamanoX,iTamanoY:integer;
 PaletaPcx:tPaleta;
 loop1:integer;
 w:word;
 yByte:byte;
 yColor:byte;
 x,y:word;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;


if bLoadPal then
  begin
    Seek(f,FileSize(f)-768);
    BlockRead(f,PaletaPcx,768);
    for loop1:=0 to 255 do
      begin
        PaletaPcx[loop1].r:=PaletaPcx[loop1].r shr 2;
        PaletaPcx[loop1].g:=PaletaPcx[loop1].g shr 2;
        PaletaPcx[loop1].b:=PaletaPcx[loop1].b shr 2;
      end;
    SetPaleta(PaletaPcx);
  end;

seek(f,128);


x:=0;
y:=0;
while y<iTamanoY+1 do
  begin
    BlockRead(f,yByte,1);
    if yByte>192
    then
      begin {varios puntos comprimidos}
        BlockRead(f,yColor,1);
        for loop1:=193 to yByte do
          begin
            PutPixel(x,y,yColor);
            inc(x);
            if x=Cabecera.BytesLinea
            then
              begin
                x:=0;
                inc(y);
              end
          end
      end
    else
      begin {un punto}
        PutPixel(x,y,YByte);
        inc(x);
        if x=Cabecera.BytesLinea
        then
          begin
            x:=0;
            inc(y);
          end
      end
  end;

close(f);
end; (*LoadPcx*)





procedure LoadPcxXY(sNombre,sPath:string; iX,iY:integer;
                    bLoadPal:boolean; var iError:integer);
var
 f:file;
 Cabecera:tCabeceraPCX;
 iTamanoX,iTamanoY:integer;
 PaletaPcx:tPaleta;
 loop1:integer;
 w:word;
 yByte:byte;
 yColor:byte;
 x,y:word;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;


if bLoadPal then
  begin
    Seek(f,FileSize(f)-768);
    BlockRead(f,PaletaPcx,768);
    for loop1:=0 to 255 do
      begin
        PaletaPcx[loop1].r:=PaletaPcx[loop1].r shr 2;
        PaletaPcx[loop1].g:=PaletaPcx[loop1].g shr 2;
        PaletaPcx[loop1].b:=PaletaPcx[loop1].b shr 2;
      end;
    SetPaleta(PaletaPcx);
  end;

seek(f,128);


x:=iX;
y:=iY;
while y<iY+iTamanoY+1 do
  begin
    BlockRead(f,yByte,1);
    if yByte>192
    then
      begin {varios puntos comprimidos}
        BlockRead(f,yColor,1);
        for loop1:=193 to yByte do
          begin
            PutPixel(x,y,yColor);
            inc(x);
            if x=iX+Cabecera.BytesLinea
            then
              begin
                x:=iX;
                inc(y);
              end
          end
      end
    else
      begin {un punto}
        PutPixel(x,y,YByte);
        inc(x);
        if x=iX+Cabecera.BytesLinea
        then
          begin
            x:=iX;
            inc(y);
          end
      end
  end;

close(f);
end; (*LoadPcxXY*)





procedure LoadPcxWhere(sNombre,sPath:string; bLoadPal:boolean;
                       Where:word; var iError:integer);
var
 f:file;
 Cabecera:tCabeceraPCX;
 iTamanoX,iTamanoY:integer;
 PaletaPcx:tPaleta;
 loop1:integer;
 w:word;
 yByte:byte;
 yColor:byte;
 x,y:word;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;


if bLoadPal then
  begin
    Seek(f,FileSize(f)-768);
    BlockRead(f,PaletaPcx,768);
    for loop1:=0 to 255 do
      begin
        PaletaPcx[loop1].r:=PaletaPcx[loop1].r shr 2;
        PaletaPcx[loop1].g:=PaletaPcx[loop1].g shr 2;
        PaletaPcx[loop1].b:=PaletaPcx[loop1].b shr 2;
      end;
    SetPaleta(PaletaPcx);
  end;

seek(f,128);


x:=0;
y:=0;
while y<iTamanoY+1 do
  begin
    BlockRead(f,yByte,1);
    if yByte>192
    then
      begin {varios puntos comprimidos}
        BlockRead(f,yColor,1);
        for loop1:=193 to yByte do
          begin
            PutPixelWhere(x,y,yColor,where);
            inc(x);
            if x=Cabecera.BytesLinea
            then
              begin
                x:=0;
                inc(y);
              end
          end
      end
    else
      begin {un punto}
        PutPixelWhere(x,y,YByte,where);
        inc(x);
        if x=Cabecera.BytesLinea
        then
          begin
            x:=0;
            inc(y);
          end
      end
  end;

close(f);
end; (*LoadPcxWhere*)





procedure LoadPcxXYWhere(sNombre,sPath:string; iX,iY:integer;
                         bLoadPal:boolean; Where:word; var iError:integer);
var
 f:file;
 Cabecera:tCabeceraPCX;
 iTamanoX,iTamanoY:integer;
 PaletaPcx:tPaleta;
 loop1:integer;
 w:word;
 yByte:byte;
 yColor:byte;
 x,y:word;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;


if bLoadPal then
  begin
    Seek(f,FileSize(f)-768);
    BlockRead(f,PaletaPcx,768);
    for loop1:=0 to 255 do
      begin
        PaletaPcx[loop1].r:=PaletaPcx[loop1].r shr 2;
        PaletaPcx[loop1].g:=PaletaPcx[loop1].g shr 2;
        PaletaPcx[loop1].b:=PaletaPcx[loop1].b shr 2;
      end;
    SetPaleta(PaletaPcx);
  end;

seek(f,128);


x:=iX;
y:=iY;
while y<iY+iTamanoY+1 do
  begin
    BlockRead(f,yByte,1);
    if yByte>192
    then
      begin {varios puntos comprimidos}
        BlockRead(f,yColor,1);
        for loop1:=193 to yByte do
          begin
            PutPixelWhere(x,y,yColor,where);
            inc(x);
            if x=iX+Cabecera.BytesLinea
            then
              begin
                x:=iX;
                inc(y);
              end
          end
      end
    else
      begin {un punto}
        PutPixelWhere(x,y,YByte,where);
        inc(x);
        if x=iX+Cabecera.BytesLinea
        then
          begin
            x:=iX;
            inc(y);
          end
      end
  end;

close(f);
end; (*LoadPcxXYWhere*)





procedure LoadImagenPcx(sNombre,sPath:string; var Imagen:tImagen;
                        var iError:integer);
var
 f:file;
 Cabecera:tCabeceraPCX;
 loop1:integer;
 yByte,yColor:byte;
 w,wSeg,wOfs:word;
 lTamX,lTamY,lSize:longint;


begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}


seek(f,128);


with Imagen do
  begin
    TamanoX:=Cabecera.maxX-Cabecera.minX+1;
    TamanoY:=Cabecera.maxY-Cabecera.minY+1;


    lTamX:=TamanoX;
    lTamY:=TamanoY;
    lSize:=lTamX*lTamY;
    if lSize>65528 then exit; {error}

    GetMem(MapaBits,lSize);
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);


    w:=0;
    while w<=lSize do
      begin
        BlockRead(f,yByte,1);
        if yByte>192
        then
          begin {varios puntos comprimidos}
            BlockRead(f,yColor,1);
            for loop1:=193 to yByte do
              begin
                mem[wSeg:wOfs+w]:=yColor;
                inc(w);
              end;
          end
        else
          begin {un punto}
            mem[wSeg:wOfs+w]:=yByte;
            inc(w);
          end;

      end;
  end; (*with Imagen*)

close (f);
end; (*procedure LoadImagenPcx*)





procedure LoadImagenPcxXY(sNombre,sPath:string; iXini,iYini,iXfin,iYfin:integer;
                          var Imagen:tImagen; var iError:integer);
var
  f:file;
  Cabecera:tCabeceraPCX;
  iTamanoX,iTamanoY:integer;
  loop1:integer;
  yByte,yColor:byte;
  x,y:word;
  w,wSeg,wOfs:word;
  lTamX,lTamY,lSize:longint;


begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;


if (iXfin>iTamanoX) or (iYfin>iTamanoY) or (iXini<0) or (iYini<0)
then
  begin
    iError:=5; {tama¤o incorrecto}
    exit;
  end;


seek(f,128);


with Imagen do
  begin
    TamanoX:=iXfin-iXini+1;
    TamanoY:=iYfin-iYini+1;


    lTamX:=TamanoX;
    lTamY:=TamanoY;
    lSize:=lTamX*lTamY;
    if lSize>65528 then
      begin
        iError:=6;
        exit; {error}
      end;

    GetMem(MapaBits,lSize);
    wSeg:=seg(MapaBits^);
    wOfs:=ofs(MapaBits^);


    w:=0;
    x:=0;
    y:=0;
    while y<=iYfin do
      begin
        BlockRead(f,yByte,1);
        if yByte>192
        then
          begin {varios puntos comprimidos}
            BlockRead(f,yColor,1);
            for loop1:=193 to yByte do
              begin
                if (x<=iXfin) and (x>=iXini) and (y>=iYini)
                then
                  begin
                    mem[wSeg:wOfs+w]:=yColor;
                    inc(w);
                  end;

                inc(x);
                if x=Cabecera.BytesLinea
                then
                  begin
                    x:=0;
                    inc(y);
                  end;
              end;
          end
        else
          begin {un punto}
            if (x<=iXfin) and (x>=iXini) and (y>=iYini)
            then
              begin
                mem[wSeg:wOfs+w]:=yByte;
                inc(w);
              end;

            inc(x);
            if x=Cabecera.BytesLinea
            then
              begin
                x:=0;
                inc(y);
              end;
          end;

      end;
  end; (*with Imagen*)

close (f);
end; (*procedure LoadImagenPcxXY*)





Procedure GetPalPCX(sNombre,sPath:string; var Paleta:tPaleta;
                    var iError:integer);

var
 f:file;
 loop1:integer;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


Seek(f,FileSize(f)-768);
BlockRead(f,Paleta,768);
for loop1:=0 to 255 do
  begin
    Paleta[loop1].r:=Paleta[loop1].r shr 2;
    Paleta[loop1].g:=Paleta[loop1].g shr 2;
    Paleta[loop1].b:=Paleta[loop1].b shr 2;
  end;

close(f);
end; (*procedure GetPalPCX*)





Procedure PutPalPCX(Paleta:tPaleta; sNombre,sPath:string; var iError:integer);

var
 f:file;
 loop1:integer;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;

if FileSize(f)<768
then
  begin
    iError:=2; {formato invalido}
    exit;
  end;


for loop1:=0 to 255 do
  begin
    Paleta[loop1].r:=Paleta[loop1].r shl 2;
    Paleta[loop1].g:=Paleta[loop1].g shl 2;
    Paleta[loop1].b:=Paleta[loop1].b shl 2;
  end;

Seek(f,FileSize(f)-768);
BlockWrite(f,Paleta,768);

close(f);
end; (*procedure PutPalPCX*)





procedure GetCabeceraPCX(sNombre,sPath:string; var Cabecera:tCabeceraPCX;
                         var iError:integer);
var
 f:file;
 w:word;

begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0
then
  begin
    iError:=1; {no existe}
    exit;
  end;


BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}

close (f);
end; (*procedure GetCabeceraPCX*)





procedure WriteCabeceraPCX(Cabecera:tCabeceraPCX);
var
 Paleta:tPaleta;
 yI:byte;

begin
GetPaleta(Paleta);
SetColor(15);
GTWriteStringXY(1,1,'firma: ');
GTWriteRealXY(200,1,Cabecera.firma);
GTWriteStringXY(1,10,'version: ');
GTWriteRealXY(200,10,Cabecera.version);
GTWriteStringXY(1,20,'compresion: ');
GTWriteRealXY(200,20,Cabecera.compresion);
GTWriteStringXY(1,30,'bits por pixel: ');
GTWriteRealXY(200,30,Cabecera.bitspixel);
GTWriteStringXY(1,40,'Min x: ');
GTWriteRealXY(200,40,Cabecera.minX);
GTWriteStringXY(1,50,'Min y: ');
GTWriteRealXY(200,50,Cabecera.minY);
GTWriteStringXY(1,60,'Max x: ');
GTWriteRealXY(200,60,Cabecera.maxX);
GTWriteStringXY(1,70,'Max y: ');
GTWriteRealXY(200,70,Cabecera.maxY);
GTWriteStringXY(1,80,'ppX: ');
GTWriteRealXY(200,80,Cabecera.ppX);
GTWriteStringXY(1,90,'ppY: ');
GTWriteRealXY(200,90,Cabecera.ppY);
GTWriteStringXY(1,100,'paleta16[0].R: ');
GTWriteRealXY(200,100,Cabecera.paleta16[0].R);
GTWriteStringXY(1,110,'paleta16[15].R: ');
GTWriteRealXY(200,110,Cabecera.paleta16[15].R);
GTWriteStringXY(1,120,'Reseservado: ');
GTWriteRealXY(200,120,Cabecera.reservado);
GTWriteStringXY(1,130,'planos: ');
GTWriteRealXY(200,130,Cabecera.planos);
GTWriteStringXY(1,140,'bytes por linea: ');
GTWriteRealXY(200,140,Cabecera.byteslinea);
GTWriteStringXY(1,150,'paleta info: ');
GTWriteRealXY(200,150,Cabecera.paletainfo);
GTWriteStringXY(1,160,'tama¤o x: ');
GTWriteRealXY(200,160,Cabecera.tamanoX);
GTWriteStringXY(1,170,'tama¤o y:');
GTWriteRealXY(200,170,Cabecera.tamanoY);
GTWriteStringXY(1,180,'cero[0]: ');
GTWriteRealXY(200,180,Cabecera.cero[0]);
GTWriteStringXY(1,190,'cero[54]: ');
GTWriteRealXY(200,190,Cabecera.cero[54]);

end; (*procedure WriteCabeceraPCX*)





procedure CopyPcx(sNombre1,sPath1,sNombre2,sPath2:string; Color1,Color2:integer;
                  bSobreEscribir:boolean; iError:integer);
{cambia el Color1 del fichero sNombre1 por el Color2 y lo guarda en sNombre2}

var
 f1,f2:file;
 Cabecera:tCabeceraPCX;
 iTamanoX,iTamanoY:integer;
 PaletaPcx:tPaleta;
 loop1:integer;
 w:word;
 yByte:byte;
 yColor:byte;
 x,y:word;
 y193:byte;

begin
iError:=0;
if (sPath1<>'') and (copy(sPath1,length(sPath1),1)<>'\') then sPath1:=sPath1+'\';
if (sPath2<>'') and (copy(sPath2,length(sPath2),1)<>'\') then sPath2:=sPath2+'\';
if Extension(sNombre1)='' then sNombre1:=sNombre1+'.PCX';
if Extension(sNombre2)='' then sNombre2:=sNombre2+'.PCX';


assign(f1,sPath1+sNombre1);
{$I-}
reset(f1,1);
{$I+}
if IOResult<>0 then
  begin
    iError:=1; {f1 no existe}
    exit;
  end;


assign(f2,sPath2+sNombre2);
{$I-}
reset(f2,1);
{$I+}
if IOResult=0 then
  begin
    if bSobreEscribir then
      begin
        rewrite(f2,1);
        iError:=-1; {SobreEscribimos f2}
      end
    else
      begin
        iError:=4; {No SobreEscribimos f2}
        close(f1);
        exit;
      end;
  end
else rewrite(f2,1);



BlockRead(f1,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;

BlockWrite(f2,Cabecera,SizeOf(Cabecera),w); {escribe la cabecera}



seek(f1,128);
seek(f2,128);


y193:=193;
x:=0;
y:=0;
while y<iTamanoY+1 do
  begin
    BlockRead(f1,yByte,1);

    if yByte>192
    then
      begin {varios puntos comprimidos}
        BlockWrite(f2,yByte,1);

        BlockRead(f1,yColor,1);

        if yColor=Color1
        then BlockWrite(f2,Color2,1)
        else BlockWrite(f2,yColor,1);

        for loop1:=193 to yByte do
          begin
            inc(x);
            if x=Cabecera.BytesLinea
            then
              begin
                x:=0;
                inc(y);
              end
          end
      end
    else
      begin {un punto}
        if yByte=Color1
        then
          if Color2>192
          then
            begin
              BlockWrite(f2,y193,1);
              BlockWrite(f2,Color2,1);
            end
          else BlockWrite(f2,Color2,1)
        else BlockWrite(f2,yByte,1);

        inc(x);
        if x=Cabecera.BytesLinea
        then
          begin
            x:=0;
            inc(y);
          end
      end
  end;



while FilePos(f1)<FileSize(f1)-768 do
  begin
    BlockRead(f1,yByte,1);
    BlockWrite(f2,yByte,1);
  end;



Seek(f1,FileSize(f1)-768);
{Seek(f2,FileSize(f1)-768);}

BlockRead(f1,PaletaPcx,768);
BlockWrite(f2,PaletaPcx,768);



close(f1);
close(f2);
end; (*CopyPcx*)





procedure GetColor256(sNombre,sPath:string; var Color:tColor256;
                      iError:integer);
{devuelve una lista con los colores usados en la PCX}

var
 f:file;
 Cabecera:tCabeceraPCX;
 iTamanoX,iTamanoY:integer;
 PaletaPcx:tPaleta;
 loop1:integer;
 w:word;
 yByte:byte;
 yColor:byte;
 x,y:word;


  procedure GuardarPunto(var Color:tColor256; yPunto:byte);
  var
   i:integer;

  begin
  i:=1;
  while (Color.Puntos[i]<>yPunto) and (i<=Color.Num) do i:=i+1;

  if Color.Puntos[i]<>yPunto
  then
    begin
      inc(Color.Num);
      Color.Puntos[Color.Num]:=yPunto;
    end;

  end; (*GuardarPunto*)


begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';

assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0 then
  begin
    iError:=1; {f1 no existe}
    exit;
  end;



BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;


seek(f,128);


x:=0;
y:=0;
while y<iTamanoY+1 do
  begin
    BlockRead(f,yByte,1);

    if yByte>192
    then
      begin {varios puntos comprimidos}
        BlockRead(f,yColor,1);
        GuardarPunto(Color,yColor);

        for loop1:=193 to yByte do
          begin
            inc(x);
            if x=Cabecera.BytesLinea
            then
              begin
                x:=0;
                inc(y);
              end
          end
      end
    else
      begin {un punto}
        GuardarPunto(Color,yByte);

        inc(x);
        if x=Cabecera.BytesLinea
        then
          begin
            x:=0;
            inc(y);
          end
      end
  end;

close(f);
end; (*CopyPcx*)





procedure GetColor256Sin(sNombre,sPath:string; var Color:tColor256;
                         iSin,iError:integer);
{devuelve una lista con los colores usados en la PCX, ignora el color iSin}

var
 f:file;
 Cabecera:tCabeceraPCX;
 iTamanoX,iTamanoY:integer;
 PaletaPcx:tPaleta;
 loop1:integer;
 w:word;
 yByte:byte;
 yColor:byte;
 x,y:word;


  procedure GuardarColor256(var Color:tColor256; yPunto:byte);
  var
   i:integer;

  begin
  i:=1;
  while (Color.Puntos[i]<>yPunto) and (i<=Color.Num) do i:=i+1;

  if Color.Puntos[i]<>yPunto
  then
    begin
      inc(Color.Num);
      Color.Puntos[Color.Num]:=yPunto;
    end;

  end; (*GuardarColor256*)


begin
iError:=0;
if (sPath<>'') and (copy(sPath,length(sPath),1)<>'\') then sPath:=sPath+'\';
if Extension(sNombre)='' then sNombre:=sNombre+'.PCX';


assign(f,sPath+sNombre);
{$I-}
reset(f,1);
{$I+}
if IOResult<>0 then
  begin
    iError:=1; {f1 no existe}
    exit;
  end;



BlockRead(f,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;


seek(f,128);


x:=0;
y:=0;
while y<iTamanoY+1 do
  begin
    BlockRead(f,yByte,1);

    if yByte>192
    then
      begin {varios puntos comprimidos}
        BlockRead(f,yColor,1);
        if yColor<>iSin then GuardarColor256(Color,yColor);

        for loop1:=193 to yByte do
          begin
            inc(x);
            if x=Cabecera.BytesLinea
            then
              begin
                x:=0;
                inc(y);
              end
          end
      end
    else
      begin {un punto}
        if yByte<>iSin then GuardarColor256(Color,yByte);

        inc(x);
        if x=Cabecera.BytesLinea
        then
          begin
            x:=0;
            inc(y);
          end
      end
  end;

close(f);
end; (*CopyPcx*)





procedure CopyColor256(sNombre1,sPath1,sNombre2,sPath2:string;
                       Color:tColor256; yPos:byte;
                       bSobreEscribir:boolean; iError:integer);

{Coge los colores de Color256 (1..Num) y los pone en (yPos..yPos+Num)}
{yPos+Color256.Num debe ser menor que 256}

var
 f1,f2:file;
 Cabecera:tCabeceraPCX;
 iTamanoX,iTamanoY:integer;
 PaletaPcx:tPaleta;
 i,iPos,loop1:integer;
 w:word;
 yByte:byte;
 yColor:byte;
 x,y:word;
 y193:byte;


  function VerColor256(Color:tColor256; yPunto:byte):integer;
  var
   i:integer;

  begin
  i:=1;
  while (Color.Puntos[i]<>yPunto) and (i<=Color.Num) do i:=i+1;

  if Color.Puntos[i]<>yPunto
  then VerColor256:=-1
  else VerColor256:=i;

  end; (*VerColor256*)


begin
iError:=0;
if (sPath1<>'') and (copy(sPath1,length(sPath1),1)<>'\') then sPath1:=sPath1+'\';
if (sPath2<>'') and (copy(sPath2,length(sPath2),1)<>'\') then sPath2:=sPath2+'\';
if Extension(sNombre1)='' then sNombre1:=sNombre1+'.PCX';
if Extension(sNombre2)='' then sNombre2:=sNombre2+'.PCX';


if yPos+Color.Num>255 then
  begin
    iError:=5; {parametro incorrecto}
    exit;
  end;


assign(f1,sPath1+sNombre1);
{$I-}
reset(f1,1);
{$I+}
if IOResult<>0 then
  begin
    iError:=1; {f1 no existe}
    exit;
  end;


assign(f2,sPath2+sNombre2);
reset(f2,1);
if IOResult=0 then
  begin
    if bSobreEscribir then
      begin
        rewrite(f2,1);
        iError:=-1; {SobreEscribimos f2}
      end
    else
      begin
        iError:=4; {No SobreEscribimos f2}
        close(f1);
        exit;
      end;
  end
else rewrite(f2,1);



BlockRead(f1,Cabecera,SizeOf(Cabecera),w); {lee la cabecera}
with Cabecera do
  begin
    iTamanoX:=maxX-minX;
    iTamanoY:=maxY-minY;
  end;

BlockWrite(f2,Cabecera,SizeOf(Cabecera),w); {escribe la cabecera}


seek(f1,128);
seek(f2,128);


y193:=193;
x:=0;
y:=0;
while y<iTamanoY+1 do
  begin
    BlockRead(f1,yByte,1);

    if yByte>192
    then
      begin {varios puntos comprimidos}
        BlockWrite(f2,yByte,1);

        BlockRead(f1,yColor,1);

        i:=VerColor256(Color,yColor);
        iPos:=i+yPos-1;
        if i<>-1
        then BlockWrite(f2,iPos,1)
        else BlockWrite(f2,yColor,1);

        for loop1:=193 to yByte do
          begin
            inc(x);
            if x=Cabecera.BytesLinea
            then
              begin
                x:=0;
                inc(y);
              end
          end
      end
    else
      begin {un punto}
        i:=VerColor256(Color,yByte);
        iPos:=i+yPos-1;

        if i<>-1
        then
          if iPos>192
          then
            begin
              BlockWrite(f2,y193,1);
              BlockWrite(f2,iPos,1);
            end
          else BlockWrite(f2,iPos,1)
        else BlockWrite(f2,yByte,1);

        inc(x);
        if x=Cabecera.BytesLinea
        then
          begin
            x:=0;
            inc(y);
          end
      end
  end;



while FilePos(f1)<FileSize(f1)-768 do
  begin
    BlockRead(f1,yByte,1);
    BlockWrite(f2,yByte,1);
  end;



Seek(f1,FileSize(f1)-768);
{Seek(f2,FileSize(f1)-768);}

BlockRead(f1,PaletaPcx,768);

for y:=0 to 255 do
  begin
    i:=VerColor256(Color,y);
    iPos:=i+yPos-1;

    if i<>-1 then
      begin
        PaletaPcx[iPos].r:=PaletaPcx[y].r;
        PaletaPcx[iPos].g:=PaletaPcx[y].g;
        PaletaPcx[iPos].b:=PaletaPcx[y].b;
      end;
  end;

BlockWrite(f2,PaletaPcx,768);



close(f1);
close(f2);
end; (*CopyColor256*)





begin
end.


