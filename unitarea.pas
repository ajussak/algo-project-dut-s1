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
  i, choice: Integer;
begin
  clearScreen;
  SetLength(menu, Length(areas));
  for i:= 0 to Length(areas) do
      menu[i] := areas[i].name;
  choice := displayMenu(menu);
  clearScreen;
  displayFile('data/' + areas[choice].name + '.txt',1);
  readln;
end;

procedure registerAreas(var areas: AreaRegistry);
begin
  setLength(areas, 4);

  areas[0].name := 'Campement';

  areas[1].name := 'Forêt';

  areas[2].name := 'IUT';

  areas[3].name := 'Lac'
end;

end.

