unit Utils;

{$mode objfpc}{$H+}

interface

uses crt;

procedure displayFile(filename: string; xPos: tcrtcoord);

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
end;

end.

