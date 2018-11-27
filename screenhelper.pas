unit ScreenHelper;

{$mode objfpc}{$H+}

interface

uses crt;

procedure clearScreen();

implementation

procedure clearScreen();
begin
  ClrScr;
  GotoXY(1,1);
end;

end.

