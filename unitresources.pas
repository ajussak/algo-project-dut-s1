unit UnitResources;

{$mode objfpc}{$H+}

interface

type resourceList = record
    bois,poisson,viande,pain,lait,legumes,objetsPrecieux : Integer;
end;

procedure displayStats(var resources: resourceList);
function createResourcesList(): resourceList;
procedure importResources(var village: resourceList; var area: resourceList);
procedure weatherTurn(var village: resourceList; var weather: Integer);

implementation

procedure displayStats(var resources: resourceList);
begin
  WriteLn('====== Ressources ======');
  WriteLn('Bois : ', resources.bois);
  WriteLn('Poisson : ', resources.poisson);
  WriteLn('Viande : ', resources.viande);
  WriteLn('Pain : ', resources.pain);
  WriteLn('Lait : ', resources.lait);
  WriteLn('Legumes : ', resources.legumes);
  WriteLn('Objets Precieux : ', resources.objetsPrecieux);
  WriteLn;
end;

function createResourcesList(): resourceList;
var
  resources: resourceList;
begin
  resources.bois := 0;
  resources.poisson := 0;
  resources.viande := 0;
  resources.pain := 0;
  resources.lait := 0;
  resources.legumes := 0;
  resources.objetsPrecieux := 0;
  createResourcesList := resources;
end;

procedure importResources(var village: resourceList; var area: resourceList);
begin
  village.bois := village.bois + area.bois;
  village.poisson := village.poisson + area.poisson;
  village.viande := village.viande + area.viande;
  village.pain := village.pain + area.pain;
  village.lait := village.lait + area.lait;
  village.legumes := village.legumes + area.legumes;
  village.objetsPrecieux := village.objetsPrecieux + area.objetsPrecieux;
end;

procedure weatherTurn(var village: resourceList; var weather: Integer);
var
  weather: Integer;
begin
  weather:= random(3);
  case lap of 
    0 : weather := 0;
        village.legumes := round(village.legumes)*1.5;
    1 : weather := 1;
        village.bois := round(village.bois)*0.75;
    2 : weather := 2;
        village.legumes := round(village.legumes)*0.75;
    3 : weather := 3;
        village.poisson := round(village.poisson)*0.75;
end;

end.

