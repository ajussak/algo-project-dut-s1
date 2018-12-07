unit VillageUnit;

{$mode objfpc}{$H+}

interface

uses UnitResources, Utils, sysutils, UniteMenus, UnitArea;
type Mois = (janvier,fevrier,mars,avril,mai,juin,juillet,aout,septembre,octobre,novembre,decembre);
type personnage = record
    PV, affectedArea : Integer;
  end;
type Village = record
    resources: resourceList;
    tour, annee: Integer;
    m : Mois;
    villagers: array of personnage;
    villagersNumber: Integer;
  end;

    {Début de la nouvelle partie}
procedure debutPartie(var town : Village);
    {Passe un tour}
procedure tourSuivant(var town : Village);
    {Créer un nouveau personnage}
function newPersonnage():Personnage;
    {Affiche la date à l''écran}
procedure displayDate(var town : Village);

procedure manageVillagers(var town: Village; var areas: AreaRegistry);


implementation

procedure debutPartie(var town : Village);
var
  i: Integer;
{Initialise les variables de ressources}
Begin
  town.resources.bois := 0;
  town.resources.poisson := 10;
  town.resources.viande := 10;
  town.resources.pain := 10;
  town.resources.lait := 10;
  town.resources.legumes := 10;
  town.resources.objetsPrecieux := 10;
  town.annee := 2177;
  town.m := avril;
  town.tour := 0;
  town.villagersNumber := 3;

  SetLength(town.villagers, 20);

  for i := 0 to town.villagersNumber - 1 do
  begin
    town.villagers[i] := newPersonnage();
  end;

end;

procedure displayDate(var town : Village);
begin
  WriteLn(town.m, ' ', town.annee);
end;

procedure tourSuivant(var town : Village);
{incrémente de un la variable tour, incrémente de un la variable mois si tour =3 
et incrémente de un la variable année si mois = décembre}
begin
  town.tour := town.tour +1;
  if town.tour = 3 then
  begin
    town.tour := 0;
    if town.m = decembre then
    begin
      town.m := janvier;
      town.annee := town.annee +1;
    end
    else
      town.m := succ(town.m);
  end;
end;

procedure affectArea(var villager: Personnage; var areas: AreaRegistry);
var
   menu: array of string;
   i, choice: Integer;
begin
  setLength(menu, Length(areas)+1);
  for i := 0 to Length(areas) do
      menu[i] := areas[i].name;
  menu[Length(areas)] := 'Retour';

  choice := displayMenu(menu);

  if choice <> Length(areas) then
     villager.affectedArea := choice;

end;

procedure manageVillager(var villager: Personnage; var areas: AreaRegistry);
var
  menu: array[0 .. 1] of string;
begin
  menu[0] := 'Affecter à une zone...';
  menu[1] := 'Retour';

  case displayMenu(menu) of
  0: affectArea(villager, areas);
  end;
end;

procedure manageVillagers(var town: Village; var areas: AreaRegistry);
var
  i, choice, exit: Integer;
  menu: array of string;
  affectation: string;
  var villager: Personnage;
begin
  exit := 0;
  repeat
    clearScreen;
    SetLength(menu, town.villagersNumber + 1);
    for i := 0 to town.villagersNumber - 1 do
    begin
      villager := town.villagers[i];
      if villager.affectedArea = -1 then
         affectation := 'Aucune'
      else
        affectation := areas.[villager.affectedArea].name;

      menu[i] := 'Villageois ' + IntToStr(i + 1) + ' : Points de vie (' + IntToStr(villager.PV) + ') Zone Affectée (' + affectation + ')';
    end;
    menu[town.villagersNumber] := 'Retour';
    choice := displayMenu(menu);

    if choice <> town.villagersNumber then
      manageVillager(town.villagers[choice], areas)
    else
        exit := 1;

  until exit = 1;

end;

function newPersonnage():Personnage;
{créer un type personnage (record) avec une variable ID, une variable PV et une variable travail}
begin;
  newPersonnage.PV := 100;
  newPersonnage.affectedArea := -1;
end;

end.
