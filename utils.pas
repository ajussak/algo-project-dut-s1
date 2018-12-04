unit Utils;

{$mode objfpc}{$H+}

interface

uses crt;

procedure displayFile(filename: string; xPos: tcrtcoord);
procedure clearScreen();

implementation

procedure displayFile(filename: string; xPos: tcrtcoord);
var
  stock: text;
  ligne: string;
begin
  assign(stock, filename);
  reset(stock);
  while not eof(stock) do
  begin
    gotoXY(xPos, WhereY);
    readln(stock, ligne);
    writeln(ligne);
  end;
  close(Stock);
end;

procedure clearScreen();
begin
  ClrScr;
  GotoXY(1,1);
end;

end.

