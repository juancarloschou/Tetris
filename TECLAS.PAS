{$F+}
unit teclas;



interface


const
escScan:byte=$01;
backScan:byte=$0e;
ctrlScan:byte=$1d;
lshScan:byte=$2a;
capScan:byte=$3a;
f1Scan:byte=$3b;
f2Scan:byte=$3c;
f3Scan:byte=$3d;
f4Scan:byte=$3e;
f5Scan:byte=$3f;
f6Scan:byte=$40;
f7Scan:byte=$41;
f8Scan:byte=$42;
f9Scan:byte=$43;
f10Scan:byte=$44;
f11Scan:byte=87;
f12Scan:byte=88;
scrlScan:byte=$46;
tabScan:byte=$0f;
entScan:byte=$1c;
rshScan:byte=$36;
prtScan:byte=$37;
altScan:byte=$38;
iniScan:byte=$47;
upScan:byte=$48;
pgupScan:byte=$49;
minScan:byte=$4a;
leftScan:byte=$4b;
midScan:byte=$4c;
rightScan:byte=$4d;
plusScan:byte=$4e;
finScan:byte=$4f;
downScan:byte=$50;
pgdnScan:byte=$51;
insScan:byte=$52;
delScan:byte=$53;
numScan:byte=$45;

{El bloque de teclas mas a la derecha}
sieteScan:byte=71;
ochoScan:byte=72;
nueveScan:byte=73;
cuatroScan:byte=75;
cincoScan:byte=76;
seisScan:byte=77;
unoScan:byte=79;
dosScan:byte=80;
tresScan:byte=81;
ceroScan:byte=82;
puntoScan:byte=83;
divScan:byte=$35;
porScan:byte=$37;
masScan:byte=$4e;
menosScan:byte=$4a;



var
KeyDown,WasDown:array[0..127] of boolean;



procedure NewKeyInt;
procedure OldKeyInt;
procedure ClearWasDownArray;
procedure NewTimInt;
procedure OldTimInt;
procedure NewBrkInt;
procedure OldBrkInt;
function ScanOf(CharToScan:char):byte;
procedure TickWait(time:byte); {es una pausa}
function TeclaPulsada:boolean;
function VerWasDown:boolean;





implementation


uses dos;


var
pOldKbdInt,pOldTimInt,pOldBrkInt:pointer; {pointers to old interrupt routines}
ClokTick:byte; {counter to count clock "ticks"}



procedure sti;
inline($fb);   {STI: set interrupt flag}



procedure cli;
inline($fa);   {CLI: clear interrupt flag -- not used}



procedure CallOldInt(sub: pointer);

{calls old interrupt routine so that your programs don't deprive the computer
 of any vital functions -- kudos to Stephen O'Brien and "Turbo Pascal 6.0:
 The Complete Reference" for including this inline code on page 407}

begin
inline($9c/         {PUSHF}
       $ff/$5e/$06) {CALL DWORD PTR [BP+6]}
end;



procedure KbdInt; interrupt; {new keyboard handler}
begin
keydown[port[$60] mod 128]:=(port[$60]<128); {key is down if value of
                                              60h is less than 128 --
                                              record current status}
if port[$60]<128 then wasdown[port[$60]]:=true; {update WASDOWN if the
                                                 key is currently
                                                 depressed}
calloldint(pOldKbdInt);             {call old interrupt}
mem[$0040:$001a]:=mem[$0040:$001c]; {Clear keyboard buffer: the buffer
                                     is a ring buffer, where the computer
                                     keeps track of the location of the
                                     next character in the buffer end
                                     the final character in the buffer.
                                     To clear the buffer, set the two
                                     equal to each other.}
sti;
end;



procedure NewKeyInt; {set new keyboard interrupt}
var
 KeyCnt:byte;
begin
for keycnt:=0 to 127 do
  begin  {reset arrays to all "False"}
    keydown[KeyCnt]:=false;
    wasdown[KeyCnt]:=false
  end;
getintvec($09,pOldKbdInt);   {record location of old keyboard int}
setintvec($09,addr(KbdInt)); {this line installs the new interrupt}
sti;
end;



procedure OldKeyInt; {reset old interrupt}
begin
SetIntVec($09,pOldKbdInt);
sti;
end;



procedure ClearWasDownArray; {set all values in WASDOWN to "False"}
var
 y:byte;
begin
for y:=0 to 127 do WasDown[y]:=false;
end;



function ScanOf(CharToScan:char):byte;
{return scan code corresponding to a character}
var
 TempByte:byte;

begin
TempByte:=0;
case upcase(chartoscan) of
  '!','1','|':TempByte:=$02;
  '"','2','@':TempByte:=$03;
  'ú','3','#':TempByte:=$04;
  '$','4':TempByte:=$05;
  '%','5':TempByte:=$06;
  '&','6','ª':TempByte:=$07;
  '/','7':TempByte:=$08;
  '(','8':TempByte:=$09;
  ')','9':TempByte:=$0a;
  '=','0':TempByte:=$0b;
  '?','''':TempByte:=$0c;
  '¨','­':TempByte:=$0d;
  'A','a':TempByte:=$1e;
  'S','s':TempByte:=$1f;
  'D','d':TempByte:=$20;
  'F','f':TempByte:=$21;
  'G','g':TempByte:=$22;
  'H','h':TempByte:=$23;
  'J','j':TempByte:=$24;
  'K','k':TempByte:=$25;
  'L','l':TempByte:=$26;
  '¥','¤':TempByte:=$27;
  '{':TempByte:=$28;
  '§','¦','\':TempByte:=$29;
  ' ':TempByte:=$39;
  'Q','q':TempByte:=$10;
  'W','w':TempByte:=$11;
  'E','e':TempByte:=$12;
  'R','r':TempByte:=$13;
  'T','t':TempByte:=$14;
  'Y','y':TempByte:=$15;
  'U','u':TempByte:=$16;
  'I','i':TempByte:=$17;
  'O','o':TempByte:=$18;
  'P','p':TempByte:=$19;
  '[':TempByte:=$1a;
  ']','+','*':TempByte:=$1b;
  '}','€','‡':TempByte:=$2b;
  'Z','z':TempByte:=$2c;
  'X','x':TempByte:=$2d;
  'C','c':TempByte:=$2e;
  'V','v':TempByte:=$2f;
  'B','b':TempByte:=$30;
  'N','n':TempByte:=$31;
  'M','m':TempByte:=$32;
  ';',',':TempByte:=$33;
  ':','.':TempByte:=$34;
  '_','-':TempByte:=$35;
end; (*case*)

ScanOf:=TempByte;
end;



procedure TimInt; interrupt; {new timer interrupt}
begin
calloldint(pOldTimInt); {call old timer interrupt}
ClokTick:=ClokTick+1;   {update "tick" counter}
end;



procedure NewTimInt; {set up new timer interrupt}
begin
getintvec($1c,pOldTimInt);   {record location of old interrupt}
setintvec($1c,addr(TimInt)); {install new interrupt procedure}
ClokTick:=0;                 {set counter to 0}
sti;
end;



procedure OldTimInt; {reset old timer}
begin
setintvec($1c,pOldTimInt);
sti;
end;


procedure TickWait(time:byte);
{do nothing until counter reaches certain value}
begin
repeat
until ClokTick>=time;
ClokTick:=0; {reset counter}
end;



function TeclaPulsada:boolean;
{test if key has been struck}
begin
TeclaPulsada:=Port[$60]<$80;
end;



function VerWasDown:boolean; {mira si algun WasDown es cierto}
var
 bWasDown:boolean;
 y:byte;

begin
bWasDown:=false;
y:=0;
while (y<128) and not(bWasDown) do
  begin
    if WasDown[y] then bWasDown:=true;
    inc(y);
  end;
VerWasDown:=bWasDown;
end;



procedure BrkInt; interrupt; {new "Ctrl-Break" interrupt: does nothing}
begin
sti;
end;



procedure OldBrkInt; {reset old "Ctrl-Break" interrupt}
begin
setintvec($1b,pOldBrkInt);
sti;
end;



procedure NewBrkInt; {install new "Ctrl-Break" interrupt}
begin
getintvec($1b,pOldBrkInt);   {get old interrupt location}
setintvec($1b,addr(BrkInt)); {set up new interrupt procedure}
sti;
end;





begin
end.


