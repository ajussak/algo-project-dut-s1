unit Utils;

{$mode objfpc}{$H+}

interface

uses crt, UniteMenus;

procedure displayFile(filename: string; xPos: tcrtcoord; waitUser: Boolean);
procedure clearScreen();

implementation

procedure displayFile(filename: string; xPos: tcrtcoord; waitUser: Boolean);
var
  stock: text;
  ligne: string;
  menu: array of string;
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

  if waitUser then
  begin
    SetLength(menu, 1);
    menu[0] := 'Retour';
    WriteLn;
    displayMenu(menu);
  end;
end;

procedure clearScreen();
begin
  ClrScr;
  GotoXY(1,1);
end;

end.

