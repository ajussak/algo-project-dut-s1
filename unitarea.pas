unit UnitArea;

{$mode objfpc}{$H+}

interface

uses UniteMenus, Utils;

type area = record
  name:string;
end;

type AreaRegistry = array of area;

procedure goToArea(var areas: AreaRegistry);
procedure registerAreas(var areas: AreaRegistry);

implementation

procedure goToArea(var areas: AreaRegistry);
var
  menu: array of string;
  i, choice, l: Integer;
begin
  l := Length(areas);

  WriteLn();
  WriteLn('Selectionner la zone à visiter : ');
  SetLength(menu, l + 1);
  for i:= 0 to Length(areas) do
      menu[i] := areas[i].name;
  menu[l] := 'Retour';
  choice := displayMenu(menu);
  WriteLn(choice);
  WriteLn(l);
  if choice <> l then
  begin
    clearScreen;
    displayFile('data/' + areas[choice].name + '.txt',1);
    readln;
  end;
end;

procedure registerAreas(var areas: AreaRegistry);
begin
  setLength(areas, 3);

  areas[0].name := 'Forêt';

  areas[1].name := 'IUT';

  areas[2].name := 'Lac'
end;

end.

