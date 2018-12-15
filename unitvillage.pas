unit unitvillage;

{$mode objfpc}{$H+}

interface

uses UnitResources, UnitArea;

const
DONT_BUILD=-1;

type
  Mois = (janvier, fevrier, mars, avril, mai, juin, juillet, aout, septembre, octobre, novembre, decembre);
type
  personnage = record
    affectedArea : Integer;
    hasEaten : Boolean;
    busy : Integer;
    deathCounter : Integer;
  end;
type

  Village = record
    resources : resourceList;
    tour, annee : Integer;
    m : Mois;
    villagers : array of personnage; // Nombre villageois
    villagersNumber : Integer; // Capacité maximal du village
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

const
  BUILD_TIME = 2;

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
  for i:=0 to town.villagersNumber - 1 do // On parcours la liste des villagageois
  begin
    if town.villagers[i].busy = DONT_BUILD then // Si le villageois n'a pas de bâtiments à construire
    begin
      areaID := town.villagers[i].affectedArea; // On récupère l'identifiant de la zone attribuée au villageois
      if areaID <> NO_AREA then // Si il n'a pas de zone attribuée
        importResources(town.resources, areas[areaID].resources, 1); // On importe les resources de la zone
    end
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
        town.villagers[i].hasEaten := EATABLE_RESOURCES[j] <> POISSON;
        town.resources[EATABLE_RESOURCES[j]] := town.resources[EATABLE_RESOURCES[j]] - 1;
        town.villagers[i].deathcounter := 0;
        break;
      end;
    end;
  end
end;

procedure villagersUpdate(var town : Village; var areas : AreaRegistry);
var
  i: Integer;
begin
  for i := 0 to town.villagersNumber - 1 do // On parcour la liste des villageois
  begin
    if (town.villagers[i].busy <> DONT_BUILD) and town.villagers[i].hasEaten then // Si le viliageois a un bâtiment à construire et qu'il a mangé
      if town.villagers[i].busy >= BUILD_TIME - 1 then // Si le batiment a fini de se construire
      begin
        areas[town.villagers[i].affectedArea].enabled := true; // On active la zone
        town.villagers[i].affectedArea := NO_AREA; // On lui désatribu la zone
        town.villagers[i].busy := DONT_BUILD; // On indique qu'il ne construit rien
      end
      else
        town.villagers[i].busy := town.villagers[i].busy + 1;
  end
end;

{incrémente de un la variable tour, incrémente de un la variable mois si tour =3
et incrémente de un la variable année si mois = décembre}
procedure tourSuivant(var town : Village; var areas : AreaRegistry);
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

{ Si le villagois est entrain de construire, demander au joueur si veut annuler la construction}
procedure confirmBuildCanceling(var villager: personnage);
var
  menu: array of string;
begin
  if villager.busy <> DONT_BUILD then // Si le villageois est entraint de construire un bâtiment
  begin
    WriteLn('Ce villageois est entrain de construire un bâtiment.');
    WriteLn('Cette action va annuler la construction et les resources dépensées seront perdues.');
    WriteLn();
    WriteLn('Voulez-vous continuer ?');
    WriteLn();

    //Définition du menu
    SetLength(menu, 2);
    menu[0] := 'Oui';
    menu[1] := 'Non';

    if displayMenu(menu) = 0 then //Si le joueur à confirmer
    begin
      villager.busy := DONT_BUILD;
      villager.affectedArea := NO_AREA;
    end;


  end;
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

function selectVillager(var town : Village; var areas : AreaRegistry): Integer;
var
  i, choice, exit : Integer;
  menu : array of string;
  affectation, hasEaten : string;
var
  villager : Personnage;
begin
  exit := 0;
  SetLength(menu, town.villagersNumber + 1);
  for i := 0 to town.villagersNumber - 1 do
  begin
    villager := town.villagers[i];
    if villager.affectedArea = NO_AREA then
      affectation := 'Aucune'
    else
    begin
      affectation := areas.[villager.affectedArea].name;
      if villager.busy <> DONT_BUILD then
        affectation := affectation + ' [Construction :' + IntToStr(BUILD_TIME - villager.busy) + ' Tours restants]'
    end;

      if villager.hasEaten then
        hasEaten := ''
      else
        hasEaten := ' est malade';

    menu[i] := 'Villageois ' + IntToStr(i + 1) + ' Zone Affectée (' + affectation + ')' + hasEaten;
  end;
  menu[town.villagersNumber] := 'Retour';

  choice := displayMenu(menu);

  if choice <> town.villagersNumber then
    selectVillager := choice
  else
    selectVillager := -1;
end;

procedure manageVillagers(var town : Village; var areas : AreaRegistry);
var
  villagerID, exit : Integer;
begin
  exit := 0;
  repeat
    clearScreen;
    WriteLn(UTF8ToAnsi('========== Gérer les villageois =========='));
    WriteLn();

    villagerID := selectVillager(town, areas);

    if villagerID <> -1 then
      manageVillager(town.villagers[villagerID], areas)
    else
      exit := 1;

  until exit = 1;

end;



procedure build(var town : Village; var areas : AreaRegistry);
var
  buildableAreasIDs : NumberArray;
  i, choice, villagerID : Integer;
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

      WriteLn(UTF8ToAnsi('Choisez le bâtiment à construire:'));
      WriteLn();
      SetLength(menu, Length(buildableAreasIDs) + 2);
      for i := 0 to Length(buildableAreasIDs) - 1 do
      begin
        a := areas[buildableAreasIDs[i]];
        menu[i] := a.name + ' (Requis :' + getRequirementString(a.required) + ')';
      end;

      menu[Length(buildableAreasIDs)] := 'Maison supplémentaire (Requis: 50 de bois)';
      menu[Length(buildableAreasIDs) + 1] := 'Retour';
      choice := displayMenu(menu);
      if choice <> Length(buildableAreasIDs) + 1 then
      begin
        if hasEnoughResources(town.resources, areas[buildableAreasIDs[choice]].required) then
        begin

          WriteLn('Veuillez sélectionner un villageois à attribuer à la construction : ');
          WriteLn();

          villagerID := selectVillager(town, areas);

          if villagerID <> -1 then
          begin
            WriteLn;
            confirmBuildCanceling(town.villagers[villagerID]);
            WriteLn;
            town.villagers[villagerID].affectedArea := buildableAreasIDs[choice];
            town.villagers[villagerID].busy := 0;
          end;
        end
        else
        begin
          WriteLn();
          WriteLn('Vous avez pas asser de ressources pour construire cela.');
          WriteLn();
          SetLength(menu, 1);
          menu[0] := 'Retour';
          displayMenu(menu);
          s := true;
        end;
      end
  until s = true;
end;

function newPersonnage() : Personnage;
{créer un type personnage (record) avec une variable ID, une variable PV et une variable travail}
begin
  newPersonnage.affectedArea := NO_AREA;
  newPersonnage.hasEaten := true;
  newPersonnage.deathCounter := 0;
  newPersonnage.busy := DONT_BUILD; // Ne construit pas
end;

end.
