unit unitvillage;

{$mode objfpc}{$H+}

interface

uses UnitResources, UnitArea;

type
  Mois = (janvier, fevrier, mars, avril, mai, juin, juillet, aout, septembre, octobre, novembre, decembre);
type
  personnage = record
    affectedArea : Integer;
    hasEaten : Boolean;
  end;
type
  Village = record
    resources : resourceList;
    tour, annee : Integer;
    m : Mois;
    villagers : array of personnage;
    villagersNumber : Integer;
  end;

  {Début de la nouvelle partie}
  procedure debutPartie(var town : Village);

  {Passe un tour}
  procedure tourSuivant(var town : Village; var areas : AreaRegistry);

  {Créer un nouveau personnage}
  function newPersonnage() : Personnage;

  {Affiche la date à l''écran}
  procedure displayDate(var town : Village);

  {Afficher}
  procedure manageVillagers(var town : Village; var areas : AreaRegistry);

  procedure build(var town : Village; var areas : AreaRegistry);


implementation

uses
  combat, unitmenus, sysutils, Utils, marchandage;

procedure debutPartie(var town : Village);
var
  i : Integer;
{Initialise les variables de ressources}
Begin
  town.resources[BOIS] := 0;
  town.resources[POISSON] := 10;
  town.resources[VIANDE] := 10;
  town.resources[POISSON] := 10;
  town.resources[LAIT] := 10;
  town.resources[LEGUMES] := 10;
  town.resources[OBJETS_PRECIEUX] := 10;
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

procedure resourcesTurn(var town : Village; var areas : AreaRegistry);
var
  i, areaID : Integer;
begin
  for i:=0 to town.villagersNumber - 1 do
  begin
    areaID := town.villagers[i].affectedArea;
    if areaID <> -1 then
      importResources(town.resources, areas[areaID].resources);
  end;
end;

{ Consommation de resources par les villageois }
procedure villagerConsume(var town : Village);
var
  i, j : Integer;
begin
  for i:=0 to town.villagersNumber - 1 do
  begin
    town.villagers[i].hasEaten := false;

    for j := 0 to Length(EATABLE_RESOURCES) - 1 do
    begin
      if town.resources[EATABLE_RESOURCES[j]] > 0 then
      begin
        town.villagers[i].hasEaten := true;
        town.resources[EATABLE_RESOURCES[j]] := town.resources[EATABLE_RESOURCES[j]] - 1;
        exit;
      end;
    end;
  end
end;

procedure tourSuivant(var town : Village; var areas : AreaRegistry);
{incrémente de un la variable tour, incrémente de un la variable mois si tour =3 
et incrémente de un la variable année si mois = décembre}
var
  rand: Real;
begin
  town.tour := town.tour + 1;
  if town.tour = 3 then
  begin
    town.tour := 0;
    if town.m = decembre then
    begin
      town.m := janvier;
      town.annee := town.annee + 1;
    end
    else
      town.m := succ(town.m);
  end;

  villagerConsume(town); //Consomation des resources par les villageois
  resourcesTurn(town, areas); //Production des resources par les villageois


  //Evenements aléatoires
  randomize;
  rand := Random;
  if rand <= 0.1 then
    combattre(town.villagersNumber)
  else if (rand > 0.1) AND (rand <= 0.2) then
    commerce(town);
end;

procedure affectArea(var villager : Personnage; var areas : AreaRegistry);
var
  choice : Integer;
begin
  WriteLn;
  choice := availableAreaSelector(areas);

  if choice <> - 1 then
    villager.affectedArea := choice;

end;

procedure manageVillager(var villager : Personnage; var areas : AreaRegistry);
var
  menu : array[0..1] of string;
begin
  WriteLn;
  menu[0] := 'Affecter à une zone...';
  menu[1] := 'Retour';

  case displayMenu(menu) of
    0 : affectArea(villager, areas);
  end;
end;

procedure manageVillagers(var town : Village; var areas : AreaRegistry);
var
  i, choice, exit : Integer;
  menu : array of string;
  affectation, hasEaten : string;
var
  villager : Personnage;
begin
  exit := 0;
  SetLength(menu, town.villagersNumber + 1);
  repeat
    clearScreen;
    WriteLn(UTF8ToAnsi('========== Gérer les villageois =========='));
    WriteLn();

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

procedure build(var town : Village; var areas : AreaRegistry);
var
  buildableAreasIDs : NumberArray;
  i, choice : Integer;
  menu : array of string;
  a : area;
  s : Boolean;
begin
  s := false;
  repeat
    clearScreen();
    WriteLn('========== Construction ==========');
    WriteLn();

    displayStats(town.resources);

    buildableAreasIDs := getBuildableAreas(areas);

    if Length(buildableAreasIDs) > 0 then
    begin
      WriteLn(UTF8ToAnsi('Choisez le bâtiment à construire:'));
      WriteLn();
      SetLength(menu, Length(buildableAreasIDs) + 1);
      for i := 0 to Length(buildableAreasIDs) - 1 do
      begin
        a := areas[buildableAreasIDs[i]];
        menu[i] := a.name + ' (Requis :' + getRequirementString(a.required) + ')';
      end;
      menu[Length(buildableAreasIDs)] := 'Retour';
      choice := displayMenu(menu);
      if choice <> Length(buildableAreasIDs) then
      begin
        if hasEnoughResources(town.resources, areas[buildableAreasIDs[choice]].required) then
        begin
          withdrawResources(town.resources, areas[buildableAreasIDs[choice]].required);
          areas[buildableAreasIDs[choice]].enabled := true;
        end
        else
        begin
          WriteLn();
          WriteLn('Vous avez pas asser de ressources pour construire cela.');
          WriteLn();
          SetLength(menu, 1);
          menu[0] := 'Retour';
          displayMenu(menu);
        end;
      end
      else
        s := true;
    end
    else
    begin
      WriteLn(UTF8ToAnsi('Aucun bâtiment à construire disponible'));
      WriteLn();
      SetLength(menu, 1);
      menu[0] := 'Retour';
      displayMenu(menu);
      s := true;
    end;
  until s = true;
end;

function newPersonnage() : Personnage;
{créer un type personnage (record) avec une variable ID, une variable PV et une variable travail}
begin
;
  newPersonnage.affectedArea := -1;
  newPersonnage.hasEaten := true;
end;

end.
