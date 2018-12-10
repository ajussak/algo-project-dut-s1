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
  const RESOURCES_STRING : array[0..6] of string = ('Bois', 'Poisson', 'Viande', 'Pain', 'Lait', 'Legumes', 'Objets Precieux');

  type resourceList = array[0 .. 6] of Integer;

  procedure displayStats(var resources: resourceList);
  function createResourcesList(): resourceList;
  procedure importResources(var village: resourceList; var area: resourceList);
  procedure withdrawResources(var village: resourceList; var area: resourceList);
  function getRequirementString(resources : resourceList) : string;
  function hasEnoughResources(var source: resourceList; var target: resourceList): Boolean;

implementation

uses
  sysutils;

procedure displayStats(var resources: resourceList);
var
  i : Integer;
begin
  WriteLn('====== Ressources ======');

  for i := 0 to Length(resources) - 1 do
    WriteLn(RESOURCES_STRING[i], ' : ', resources[i]);

  WriteLn;
end;

function getRequirementString(resources : resourceList) : string;
var
  s : string;
  i : Integer;
begin
  s := '';

  for i := 0 to Length(resources) - 1 do
    if resources[i] > 0 then
      s := s + ' ' + IntToStr(resources[i]) + 'x ' + RESOURCES_STRING[i];

  getRequirementString := s;
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

  for i := 0 to Length(source) - 1 do
    if source[i] < target[i] then
    begin
      hasEnoughResources := false;
      exit;
    end;
end;


procedure withdrawResources(var village: resourceList; var area: resourceList);
var
  i: Integer;
begin
  for i := 0 to Length(village) do
    village[i] := village[i] - area[i];
end;

procedure importResources(var village: resourceList; var area: resourceList);
var
  i: Integer;
begin
  for i := 0 to Length(village) do
    village[i] := village[i] + area[i];
end;

end.

