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
  const METAUX = 7;
  const EATABLE_RESOURCES: array[0 .. 4] of Integer = (PAIN, VIANDE, LAIT, LEGUMES, POISSON);
  const RESOURCES_STRING : array[0..7] of string = ('Bois', 'Poisson', 'Viande', 'Pain', 'Lait', 'Legumes', 'Objets Precieux', 'Meteaux');

  type resourceList = array[0 .. 7] of Integer;

  {Afficher la liste des ressources}
  procedure displayResourcesStats(var resources: resourceList);
  {Initialiser et retourner une liste de ressources.}
  function createResourcesList(): resourceList;
  {Additionner une liste de resources avec une autre}
  procedure importResources(var list1 : resourceList; var list2 : resourceList; modifier: Real);
  {Mettre la liste des ressources requise en ligne}
  function getRequirementString(resources : resourceList) : string;
  {Si les resources sont suffisantes}
  function hasEnoughResources(var source: resourceList; var target: resourceList): Boolean;

implementation

uses
  sysutils;

{Afficher la liste des ressources}
procedure displayResourcesStats(var resources: resourceList);
var
  i : Integer;
begin
  WriteLn('====== Ressources ======');

  for i := 0 to Length(resources) - 1 do
    WriteLn(RESOURCES_STRING[i], ' : ', resources[i]);
end;

{Mettre la liste des ressources requise en ligne}
function getRequirementString(resources : resourceList) : string;
var
  s : string;
  i : Integer;
begin
  s := '';

  for i := 0 to Length(resources) - 1 do //Parcourir la liste des ressources
    if resources[i] > 0 then // Si une resources est requise ( > 0)
      s := s + ' ' + IntToStr(resources[i]) + 'x ' + RESOURCES_STRING[i]; //Ajouter la quantité et le nom de la ressource dans la chaîne de caratères.

  getRequirementString := s;
end;

{Initialiser et retourner une liste de ressources.}
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
  resources[METAUX] := 0;
  createResourcesList := resources;
end;

{Si les resources sont suffisantes}
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

{Additionner une liste de resources avec une autre}
procedure importResources(var list1 : resourceList; var list2 : resourceList; modifier: Real);
var
  i: Integer;
begin
  for i := 0 to Length(list1) do
    list1[i] := list1[i] + Round(list2[i] * modifier);
end;

end.

