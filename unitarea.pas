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
function areaSelector(var areas: AreaRegistry): Integer;

implementation

procedure goToArea(var areas: AreaRegistry);
var
  choice: Integer;
begin
  WriteLn;
  WriteLn('Selectionner la zone à visiter : ');
  choice := areaSelector(areas);
  if choice <> -1 then
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
  for i := 0 to Length(areas) - 1 do
  begin
    if areas[i].enabled then
    begin
       r[j] := i;
       j := j + 1;
    end;
  end;
  SetLength(r, j);
  getAvailableAreas := r;
end;

function areaSelector(var areas: AreaRegistry): Integer;
var
  menu: array of string;
  availbleAreas: NumberArray;
  i, choice: Integer;
begin
  availbleAreas := getAvailableAreas(areas);
  SetLength(menu, Length(availbleAreas) + 1);
  for i := 0 to Length(availbleAreas) - 1 do
    menu[i] := areas[availbleAreas[i]].name;
  menu[Length(availbleAreas)] := 'Retour';

  choice := displayMenu(menu);
  if choice <> Length(availbleAreas) then
     areaSelector := availbleAreas[choice]
  else
    areaSelector := -1;
end;

procedure registerAreas(var areas: AreaRegistry);
begin
  setLength(areas, 4);

  areas[0].name := 'Forêt';
  areas[0].resources := createResourcesList();
  areas[0].resources.bois := 5;
  areas[0].typeArea := base;
  areas[0].enabled := true;

  areas[1].name := 'IUT';
  areas[1].resources := createResourcesList();
  areas[1].resources.objetsPrecieux := 1;
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
  areas[3].enabled := true;
end;

end.

