unit UnitResources;

{$mode objfpc}{$H+}

interface

const BOIS = 0;
const POISSON = 1;
const VIANDE = 2;
const PAIN = 3;
const LAIT = 4;
const LEGUMES = 5;
const OBJETS_PRECIEUX = 6;
const EATABLE_RESOURCES: array[0 .. 4] of Integer = (PAIN, VIANDE, LAIT, LEGUMES, POISSON);

type resourceList = array[0 .. 6] of Integer;

procedure displayStats(var resources: resourceList);
function createResourcesList(): resourceList;
procedure importResources(var village: resourceList; var area: resourceList);

implementation

procedure displayStats(var resources: resourceList);
begin
  WriteLn('====== Ressources ======');
  WriteLn('Bois : ', resources[BOIS]);
  WriteLn('Poisson : ', resources[POISSON]);
  WriteLn('Viande : ', resources[VIANDE]);
  WriteLn('Pain : ', resources[PAIN]);
  WriteLn('Lait : ', resources[LAIT]);
  WriteLn('Legumes : ', resources[LEGUMES]);
  WriteLn('Objets Precieux : ', resources[OBJETS_PRECIEUX]);
  WriteLn;
end;

function createResourcesList(): resourceList;
var
  resources: resourceList;
begin
  resources[BOIS] := 0;
  resources[POISSON] := 0;
  resources[VIANDE] := 0;
  resources[PAIN] := 0;
  resources[LAIT] := 0;
  resources[LEGUMES] := 0;
  resources[OBJETS_PRECIEUX] := 0;
  createResourcesList := resources;
end;

function hasEnoughResources(var source: resourceList; var target: resourceList): Boolean;
var
  i: Integer;
begin
  hasEnoughResources := true;

  for i := 0 to Length(source) do
    if source[i] < target[i] then
    begin
      hasEnoughResources := false;
      exit;
    end;
end;


procedure importResources(var village: resourceList; var area: resourceList);
var
  i: Integer;
begin
  for i := 0 to Length(village) do
    village[i] := village[i] + area[i];
end;

end.

