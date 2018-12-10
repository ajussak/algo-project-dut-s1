unit VillageUnit;

{$mode objfpc}{$H+}

interface

uses UnitResources, Utils, sysutils, UniteMenus, UnitArea, combat;
type Mois = (janvier,fevrier,mars,avril,mai,juin,juillet,aout,septembre,octobre,novembre,decembre);
type personnage = record
    affectedArea : Integer;
    hasEaten: Boolean;
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
procedure tourSuivant(var town : Village; var areas: AreaRegistry);
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

procedure resourcesTurn(var town: Village; var areas: AreaRegistry);
var
  i, areaID: Integer;
begin
  for i:=0 to town.villagersNumber - 1 do
  begin
    areaID := town.villagers[i].affectedArea;
    if areaID <> -1 then
      importResources(town.resources, areas[areaID].resources);
  end;
end;

procedure villagerConsume(var town: Village);
var
  i: Integer;
begin
  for i:=0 to town.villagersNumber - 1 do
  begin
    town.villagers[i].hasEaten := true;

    if town.resources.pain > 0 then
      town.resources.pain := town.resources.pain - 1
    else
    begin
      if town.resources.legumes > 0 then
         town.resources.legumes := town.resources.legumes - 1
      else
      begin
        if town.resources.viande > 0 then
            town.resources.viande := town.resources.viande - 1
        else
        begin
          if town.resources.poisson > 0 then
             town.resources.poisson := town.resources.poisson - 1
          else
          begin
             if town.resources.lait > 0 then
                town.resources.lait := town.resources.lait - 1
             else
                town.villagers[i].hasEaten := false
          end
        end
      end
    end
  end
end;

procedure tourSuivant(var town : Village; var areas: AreaRegistry);
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

  villagerConsume(town); //Consomation des resources par les villageois
  resourcesTurn(town, areas); //Production des resources par les villageois


  //Evenements aléatoires
  randomize;
  if Random <= 0.1 then
     combattre(town.villagersNumber);

end;

procedure affectArea(var villager: Personnage; var areas: AreaRegistry);
var
   choice: Integer;
begin
  WriteLn;
  choice := areaSelector(areas);

  if choice <> - 1 then
     villager.affectedArea := choice;

end;

procedure manageVillager(var villager: Personnage; var areas: AreaRegistry);
var
  menu: array[0 .. 1] of string;
begin
  WriteLn;
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
  affectation, hasEaten: string;
  var villager: Personnage;
begin
  exit := 0;
  SetLength(menu, town.villagersNumber + 1);
  repeat
    clearScreen;
    WriteLn('Gérer les villageois');
    WriteLn;

    for i := 0 to town.villagersNumber - 1 do
    begin
      villager := town.villagers[i];
      if villager.affectedArea = -1 then
         affectation := 'Aucune'
      else
        affectation := areas.[villager.affectedArea].name;

      if villager.hasEaten then
         hasEaten := ''
      else
        hasEaten := ' N''a pas mangé';

      menu[i] := 'Villageois ' + IntToStr(i + 1) + ' Zone Affectée (' + affectation + ')' + hasEaten;
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
  newPersonnage.affectedArea := -1;
  newPersonnage.hasEaten := true;
end;

end.
