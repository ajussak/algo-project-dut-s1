unit UnitArea;

{$mode objfpc}{$H+}

interface

uses UniteMenus, Utils, UnitResources;

type areaType = (base, buildable);
type NumberArray = array of Integer;

type area = record
  name:string;
  resources,
  required: resourceList;
  typeArea: areaType;
  enabled: Boolean;
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

  WriteLn;
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
    displayFile('data/' + areas[choice].name + '.txt',1, true);
  end;
end;

function getAvailableAreas(var areas: AreaRegistry): NumberArray;
var
  r: NumberArray;
  i, j: Integer;
begin
  j := 0;
  SetLength(r, Length(areas));
  for i := 0 to Length(areas) do
  begin
    if areas[i].enabled then
    begin
       r[j] := i;
       j := j + 1;
    end;
  end;
  SetLength(r, j + 1);
  getAvailableAreas := r;
end;

procedure registerAreas(var areas: AreaRegistry);
begin
  setLength(areas, 3);

  areas[0].name := 'Forêt';
  areas[0].resources := createResourcesList();
  areas[0].resources.bois := 5;
  areas[0].typeArea := base;
  areas[0].enabled := true;

  areas[1].name := 'IUT';
  areas[1].resources := createResourcesList();
  areas[1].resources.objetsPrecieux := 5;
  areas[1].typeArea := base;
  areas[1].enabled := true;

  areas[2].name := 'Lac';
  areas[2].resources := createResourcesList();
  areas[2].resources.poisson := 5;
  areas[2].typeArea := base;
  areas[2].enabled := true;

  areas[3].name := 'Ferme';
  areas[3].resources := createResourcesList();
  areas[3].resources.legumes := 5;
  areas[3].typeArea := buildable;
  areas[3].required := createResourcesList();
  areas[3].required.bois := 250;
  areas[3].enabled := false;
end;

end.

