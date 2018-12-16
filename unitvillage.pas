unit unitvillage;

{$mode objfpc}{$H+}

interface

uses UnitResources, UnitArea;

const
  DONT_BUILD = -1;
  BUILD_TIME = 2;
  TIME_TO_DEATH = 3;
  MAX_VILLAGERS = 20;

type
  Mois = (janvier, fevrier, mars, avril, mai, juin, juillet, aout, septembre, octobre, novembre, decembre);

type
  weather = (fair, rain, storm, fog);

const
  WEATHER_NAMES : array[0..3] of string = ('Beau temps', 'Pluie', 'Orage', 'Brouillard');

type
  personnage = record
    affectedArea : Integer;
    // Zone affectée
    isSick : Boolean;
    // Est malade
    busy : Integer;
    // Avancement de construction d'un bâtiment
    deathCounter : Integer;
    // Compteur d'avant mort
    dead : Boolean;
    // Est mort
    name : string;
    // Son Nom
  end;
type

  Village = record
    resources : resourceList;
    // Ressources du village
    tour, annee : Integer;
    //Tour et année courante
    m : Mois;
    // Mois courant
    villagers : array of personnage;
    // Villageois
    villagersNumber : Integer;
    // Nombre de vallageois découverts
    currentWeather : weather;
    // Météo courante
    houses : Integer;
    //Nombre de maisons
  end;

  {Début de la nouvelle partie}
  procedure debutPartie(var town : Village);

  {Passe un tour}
  procedure tourSuivant(var town : Village; var areas : AreaRegistry);

  {Créer un nouveau personnage}
  function newPersonnage(var town : Village) : Personnage;

  {Afficher la date et la météo}
  procedure displayDate(var town : Village);

  {Menu de gestions des villageois}
  procedure manageVillagers(var town : Village; var areas : AreaRegistry);

  {Afficher les statistiques du village}
  procedure displayStats(var town : Village);

implementation

uses
  combat, unitmenus, sysutils, Utils, shop;

procedure randomWeather(var town : Village);
begin
  Randomize();
  town.currentWeather := weather(Random(Ord(High(weather))));
end;

procedure debutPartie(var town : Village);
var
  i : Integer;
{Initialise les variables de ressources}
Begin
  town.resources[BOIS] := 0;
  town.resources[POISSON] := 10;
  town.resources[VIANDE] := 10;
  town.resources[LAIT] := 10;
  town.resources[LEGUMES] := 10;
  town.resources[OBJETS_PRECIEUX] := 10;
  town.resources[METAUX] := 0;
  town.resources[PAIN] := 10;
  town.annee := 2177;
  town.m := avril;
  town.tour := 0;
  town.villagersNumber := 0;
  town.houses := 3;

  randomWeather(town);

  SetLength(town.villagers, MAX_VILLAGERS);

  for i := 0 to 2 do // Création des 3 premier villageois
  begin
    town.villagers[i] := newPersonnage(town);
  end;

end;


{Obtenir la liste des ID des villageois en vie.}
function getAliveVillagersID(var town : Village) : NumberArray;
var
  i, j : Integer;
begin
  j := 0;
  SetLength(getAliveVillagersID, town.villagersNumber); // On suppose la taille de départ
  for i := 0 to town.villagersNumber - 1 do // On parcours la liste des villageois
    if not town.villagers[i].dead then // Si il est pas mort
    begin
      getAliveVillagersID[j] := i; //On ajoute son ID dans la liste
      j := j + 1;
    end;
  SetLength(getAliveVillagersID, j); // Définition de la taille définitive du tableau
end;

{Afficher les statistiques du village}
procedure displayStats(var town : Village);
begin
  displayResourcesStats(town.resources); //Afficher les ressources du village.
  WriteLn('Nombre de maisons : ', town.houses, ' (' + IntToStr(town.houses - Length(getAliveVillagersID(town))) + ' disponibles)') //Afficher le nombre de maisons
end;


{Afficher la date et la météo}
procedure displayDate(var town : Village);
begin
  WriteLn(town.m, ' ', town.annee);
  WriteLn('Météo : ', WEATHER_NAMES[Ord(town.currentWeather)])
end;

{Application de l'alétoire et de applications des effets liés à la météo sur une liste de resources données
et retourne la liste modifièe}
function resourcesRandomAndWeather(var town : Village; var areaResouces : resourceList) : resourceList;
var
  rnt : resourceList;
  i : Integer;
begin

  //Application de l'aléatoire dans les resources à produire
  for i := 0 to Length(areaResouces) - 1 do
  begin
    Randomize();
    rnt[i] := Random(areaResouces[i]);
  end;

  //Applications des effets liés à la météo.
  case town.currentWeather of
    fair : rnt[LEGUMES] := round(rnt[LEGUMES] * 1.5);
    rain : rnt[BOIS] := round(rnt[BOIS] * 0.75);
    storm : rnt[LEGUMES] := round(rnt[LEGUMES] * 0.75);
    fog : rnt[POISSON] := round(rnt[POISSON] * 0.75);
  end;

  resourcesRandomAndWeather := rnt;
end;

{On importe les ressources des zone en fontion des zone attribuées}
procedure resourcesTurn(var town : Village; var areas : AreaRegistry);
var
  i, areaID : Integer;
  resources : resourceList;
  aliveVillagerIDs : NumberArray;
  villager : ^personnage;
begin
  aliveVillagerIDs := getAliveVillagersID(town); // On obtiens la liste des ID des villageois en vie.
  for i:=0 to Length(aliveVillagerIDs) - 1 do // On parcours la liste des villageois en vie
  begin
    villager := @town.villagers[aliveVillagerIDs[i]];
    if (villager^.busy = DONT_BUILD) and (not villager^.isSick) then // Si le villageois n'a pas de bâtiments à construire et il n'est pas malade
    begin
      areaID := villager^.affectedArea; // On récupère l'identifiant de la zone attribuée au villageois
      if areaID <> NO_AREA then // Si il n'a pas de zone attribuée
      begin
        resources := resourcesRandomAndWeather(town, areas[areaID].resources); // Obtiens la liste des resources à importer en prenant compte l'aléatoire et la météo.
        importResources(town.resources, resources, 1); // On importe les resources de la zone
      end;
    end
  end;
end;

{ Consommation de resources par les villageois }
procedure villagerConsume(var town : Village);
var
  i, j : Integer;
  aliveVillagerIDs : NumberArray;
  villager : ^personnage;
begin
  aliveVillagerIDs := getAliveVillagersID(town); // On obtiens la liste des ID des villageois en vie.
  for i:=0 to Length(aliveVillagerIDs) - 1 do // On parcours la liste des ID des villageois en vie.
  begin
    villager := @town.villagers[aliveVillagerIDs[i]]; // On récupère le villageois courant
    villager^.isSick := true; // Par défaut on dit qu'il est malade

    for j := 0 to Length(EATABLE_RESOURCES) - 1 do // On parcour la liste des ressources commestibles.
    begin
      if town.resources[EATABLE_RESOURCES[j]] > 0 then // Si la resource à l'indice j est disponible
      begin
        villager^.isSick := EATABLE_RESOURCES[j] = POISSON; // Le villageois est malade si il mange du poisson.
        town.resources[EATABLE_RESOURCES[j]] := town.resources[EATABLE_RESOURCES[j]] - 1; // La resource est consomée.
        if not villager^.isSick then // Si le villageois n'est pas malade.
          villager^.deathcounter := -1; // Réinitialisation du compteur d'avant mort.
        break; // Sort de la boucle des ressources.
      end;
    end;
  end
end;

{Vérifier si tout les villageois ne sont pas morts sinon afficher l'écran de de Game Over}
procedure checkGameOver(var town : Village);
var
  everyoneAlive : Boolean;
  i : Integer;
  menu : array of string;
begin
  if Length(getAliveVillagersID(town)) = 0 then //Si aucun villageois n'est vivant
  begin
    clearScreen(); //Vider la console

    displayFile('data/gameover.txt', 1, false); //Afficher le text du Game Over
    WriteLn();

    //Définition du menu
    SetLength(menu, 1);
    menu[0] := 'Quitter le jeu';

    displayMenu(menu); // Affichage de menu

    halt(0); //Quitter le programme;
  end;
end;

{Résultat de l'expédition}
procedure expeditionResult(var town : Village; var areas : AreaRegistry);
var
  i: Integer;
begin
  Randomize();
  if Random() <= 0.25 then // 25 % de chance
  begin
    for i := 0 to Length(areas) - 1 do
    begin
      if (areas[i].typeArea = discoverable) and (not areas[i].enabled) then //Si la zone est découvrable et n'est pas activée.
      begin
        areas[i].enabled := true;
        break;
      end
    end;
  end;
end;

{Fin du jeu}
procedure happyEnd();
var
  menu: array of string;
begin
  clearScreen(); // Vider la console
  displayFile('data/prsq_happy_end.txt', 1, false); // Afficher l'ecran de fin
  WriteLn();

  //Définition de l'ecran de fin
  SetLength(menu, 1);
  menu[0] := 'Quitter le jeu';

  displayMenu(menu); // Afficher le menu

  halt(0); //Quitter le programme

end;

{Mises à jour des villageois}
procedure villagersUpdate(var town : Village; var areas : AreaRegistry);
var
  i: Integer;
  aliveVillagerIDs : NumberArray;
  villager : ^personnage;
begin
  aliveVillagerIDs := getAliveVillagersID(town); // On obtiens la liste des ID des villageois en vie.
  for i := 0 to Length(aliveVillagerIDs) - 1  do // On parcour la liste des villageois en vie
  begin
    villager := @town.villagers[aliveVillagerIDs[i]]; // Obtenir le villageois

    if villager^.isSick then // Si le villageois est malade.
    begin
      villager^.deathCounter := villager^.deathCounter + 1; // Incrémenter le compteur d'avant mort
      if villager^.deathCounter = TIME_TO_DEATH then // Si le vilageois n'a pas été géri dans les temps.
      begin
        villager^.dead := true; // Le villageois est mort.
        checkGameOver(town); // Vérifier si tout les villageois sont morts, si oui, Game Over
      end;
    end
    else // Sinon
    begin
      if (villager^.busy <> DONT_BUILD) and (not villager^.isSick) then // Si le viliageois est occupé et qu'il n'est pas malade
        if villager^.busy >= BUILD_TIME - 1 then // Si le batiment a fini de se construire
      begin

        case villager^.affectedArea of
          HOUSE_FAKE_AREA: town.houses := town.houses + 1;
          EXPEDITION_FAKE_AREA: expeditionResult(town, areas);
          5: happyEnd(); // Si on construit le bâtiment à l'ID 5
          else
            areas[villager^.affectedArea].enabled := true;
        end;

        villager^.affectedArea := NO_AREA; // On lui désatribu la zone
        villager^.busy := DONT_BUILD; // On indique qu'il ne construit rien
      end
      else
          villager^.busy := town.villagers[i].busy + 1; // On avance la construction du bâtiment.
    end;
  end
end;

{Découvrir un nouveau vilageois}
procedure discorverNewVillager(var town : Village);
var
  newVillager : personnage;
  menu, menu2 : array of string;
  e : Boolean;
begin
  if (town.villagersNumber < MAX_VILLAGERS) then // Si le nombre de villageois max décrouvrable n'est pas atteint
  begin
    newVillager := newPersonnage(town); // Génération d'un nouveau vilageois

    //Définitions de menu
    SetLength(menu, 2);
    menu[0] := 'L''accueillir';
    menu[1] := 'Ne pas l''accueillir (Le laisser mourir)';

    SetLength(menu2, 1);
    menu2[0] := 'Retour';

    e := false;
    Repeat
      clearScreen(); // Vider la console

      displayFile('data/new_villager.txt', 1, false); // Afficher un texte depuis un fichier
      WriteLn('Il s''appelle ', newVillager.name);
      WriteLn();

      case displayMenu(menu) of //Affichage du menu et récupération du choix du joueur.
        0 : // Si il l'accueil
        begin
          if town.houses - Length(getAliveVillagersID(town)) <= 0 then // Si il y a assez de place dans le village
          begin
            WriteLn();
            WriteLn('Vous ne pouvez pas l''accueillir, vous n''avez pas assez de maisons disponible');
            WriteLn();
            displayMenu(menu2);
          end
          else
            e := true;
        end;
        1 :// Si il ne l'accueil pas
        begin
          newVillager.dead := true;
          e := true;
        end;
      end;
    Until e = true;


    town.villagers[town.villagersNumber - 1] := newVillager; // Ajouter le nouveau un villageois découvert en liste
  end;
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

  randomWeather(town); // Changement de météo
  villagerConsume(town); //Consomation des resources par les villageois
  villagersUpdate(town, areas); //Mettre à jours les villageois
  resourcesTurn(town, areas); //Production des resources par les villageois


  //Evenements aléatoires
  randomize;
  rand := Random;
  if rand <= 0.1 then // 10 % de chance
    combattre(town.villagersNumber) // Combat
  else if (rand > 0.1) AND (rand <= 0.2) then // 10 % de chance
    trade(town) // Marchand
  else if (rand > 0.2) AND (rand <= 0.25) then // 5 % de chance
    discorverNewVillager(town); // Un nouveau villageois
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
      villager.busy := DONT_BUILD; // Le joueur ne construit rien
      villager.affectedArea := NO_AREA; // Il n'a plus de zone affectuées.
    end;
  end;
end;

{Affecter une zone à un villageois}
procedure affectArea(var villager : Personnage; var areas : AreaRegistry);
var
  choice : Integer;
begin
  WriteLn;
  choice := availableAreaSelector(areas); // Ouvre un menu selection de zone et retourne l'ID de la zone sélectionée.

  if choice <> - 1 then // Si une zone bien été sélectionée.
    villager.affectedArea := choice; // On attribu la zone au villageois

end;

{Obtenir la liste des identifiants des zone bâtissables qui ne sont pas encore construites ou pas encore en cours de construcution}
function getBuildableAreas(var areas : AreaRegistry; var town : Village) : NumberArray;
var
  r : NumberArray; // Tableau contenant les identifiants des zones à retourner
  i, j, k : Integer;
  villageBuilds : Boolean;
  aliveVillagerIDs : NumberArray;
  villager : ^personnage;
begin
  j := 0;
  SetLength(r, Length(areas)); // Définitions du nombre maximum de zones pouvant être retourné.
  for i := 0 to Length(areas) - 1 do // Parcour de la liste des zones du jeu
  begin
    if (areas[i].typeArea = buildable) AND (not areas[i].enabled) then //Si la zone est bâtisable et n'est pas activée (Pas construite)
    begin
      villageBuilds := false; // On suppose qu'au villageois ne construit le bâtiment
      aliveVillagerIDs := getAliveVillagersID(town); // On obtient la liste des villageois en vie
      for k := 0 to Length(aliveVillagerIDs) - 1 do // On parcours la liste des villageois en vie
      begin
        villager := @town.villagers[k]; // On obtiens le villageois courrant
        if (villager^.busy <> DONT_BUILD) and (villager^.affectedArea = i) then // Si le villageois construit le bâtiments
        begin
          villageBuilds := true; // Un villageois construit le bâtiments.
          break; //On sort de la boucles des villageois en vie.
        end;
      end;
      if not villageBuilds then // Si il y a aucun villageois qui construit la
      begin
        r[j] := i;
        j := j + 1;
      end;
    end;
  end;
  SetLength(r, j); // On défini la taille finale du tableau grâce au nombre total de zones bâtissables trouvées.
  getBuildableAreas := r; //Retourner le tableau r
end;

{Menu de construction}
procedure build(var villager : personnage; var town : Village; var areas : AreaRegistry);
const
  HOUSE_PRICE = 50;
var
  buildableAreasIDs : NumberArray;
  i, choice : Integer;
  menu : array of string;
  a : area;
  requiredResources : resourceList;
begin
  WriteLn();

  buildableAreasIDs := getBuildableAreas(areas, town); // Obtenirs la liste des bâtiments batissables.

  SetLength(menu, Length(buildableAreasIDs) + 2);
  // Parcourir la liste des bâtiments batissables ou qui ne sont pas en cours de construction;
  for i := 0 to Length(buildableAreasIDs) - 1 do
  begin
    a := areas[buildableAreasIDs[i]];
    menu[i] := a.name + ' (Requis :' + getRequirementString(a.required) + ')';
  end;

  menu[Length(buildableAreasIDs)] := 'Maison supplémentaire (Requis: ' + IntToStr(HOUSE_PRICE) + 'x Bois)';
  menu[Length(buildableAreasIDs) + 1] := 'Retour';
  choice := displayMenu(menu);
  if choice <> Length(buildableAreasIDs) + 1 then // Si le choix n'est pas Retour
  begin

    if choice = Length(buildableAreasIDs) then // Si on construit une maison
    begin
      requiredResources := createResourcesList();
      requiredResources[BOIS] := HOUSE_PRICE;
    end // Sinon
    else
      requiredResources := areas[buildableAreasIDs[choice]].required;

    if hasEnoughResources(town.resources, requiredResources) then // Si on a assez de ressources
    begin
      WriteLn;
      confirmBuildCanceling(villager);
      WriteLn;

      if choice = Length(buildableAreasIDs) then // Si on construit une maison
        villager.affectedArea := HOUSE_FAKE_AREA
      else
        villager.affectedArea := buildableAreasIDs[choice];

      villager.busy := 0;
    end
    else
    begin
      WriteLn();
      WriteLn('Vous n''avez pas assez de ressources pour construire cela.');
      WriteLn();
      SetLength(menu, 1);
      menu[0] := 'Retour';
      displayMenu(menu);
    end;
  end;
end;



{Affiche le menu de gestion d'un villageois}
procedure manageVillager(var villager : Personnage; var town: Village; var areas : AreaRegistry);
var
  menu : array[0..3] of string;
begin
  WriteLn;

  //Définition du menu
  menu[0] := 'Affecter à une zone...';
  menu[1] := 'Construire...';
  menu[2] := 'Envoyer en expédition';
  menu[3] := 'Retour';

  case displayMenu(menu) of
    0 : affectArea(villager, areas); // Si le joueur à sélectionner le choix à l'index 0, affeter le villageois à une zone
    1 : build(villager, town, areas);
    2 :
    begin
      villager.busy := 0;
      villager.affectedArea := EXPEDITION_FAKE_AREA;
    end;
  end;
end;

{Menu de sélection de l'ID d'un villageois}
function selectVillagerID(var town : Village; var areas : AreaRegistry) : Integer;
var
  i, choice : Integer;
  menu : array of string;
  affectation, state : string;
  aliveVillagerIDs : NumberArray;
var
  villager : Personnage;
begin
  aliveVillagerIDs := getAliveVillagersID(town); // On obtiens la liste des ID des villageois en vie.
  SetLength(menu, Length(aliveVillagerIDs) + 1); // On définie la taille du menu;
  for i := 0 to Length(aliveVillagerIDs) - 1 do // On parcours la liste des villageois en vie.
  begin
    villager := town.villagers[aliveVillagerIDs[i]]; // On obtiens le villageois grace à son ID.
    if villager.affectedArea = NO_AREA then // Si le villageoi n'a pas de zone attribuée
      affectation := 'Aucune'
    else
    begin
      if villager.affectedArea < NO_AREA then //Si il est dans une zone spéciale (FAKE)
      begin
        case villager.affectedArea of
          HOUSE_FAKE_AREA : affectation := 'Maison';
          EXPEDITION_FAKE_AREA : affectation := 'Expédition [' + IntToStr(BUILD_TIME - villager.busy) + ' Tours restants]'
        end;
      end
      else
        affectation := areas[villager.affectedArea].name;
      if (villager.busy <> DONT_BUILD) and (villager.affectedArea <> EXPEDITION_FAKE_AREA) then // Si le villageois est entrain de construire un bâtiment et n'est pas en expédition
        affectation := affectation + ' [Construction :' + IntToStr(BUILD_TIME - villager.busy) + ' Tours restants]'
    end;

    if not villager.isSick then // Si le villageois n'est pas malade
      state := ''
      else
      state := ' | Est Malade | ' + IntToStr(TIME_TO_DEATH - villager.deathCounter) + ' tours avant la mort';

    menu[i] := villager.name + ' | Zone Affectée (' + affectation + ')' + state;
  end;
  menu[Length(aliveVillagerIDs)] := 'Retour';

  choice := displayMenu(menu); // On affiche le menu et récuềre le choix de l'utilisateur.

  if choice <> Length(aliveVillagerIDs) then // Si le joueur n'a pas sélectionner Retour
    selectVillagerID := choice // On retourne l'ID du villageois sélectionner
  else
    selectVillagerID := -1;
end;

{Menu de gestions des villageois}
procedure manageVillagers(var town : Village; var areas : AreaRegistry);
var
  villagerID, exit : Integer;
begin
  exit := 0;
  repeat
    clearScreen; // Vider la console
    WriteLn(UTF8ToAnsi('========== Gérer les villageois =========='));
    WriteLn();

    villagerID := selectVillagerID(town, areas); // On ouvre le menu de selection d'un villageois et on récupère son ID.

    if villagerID <> -1 then // Si un villageois est bien sélectioner
      manageVillager(town.villagers[villagerID], town, areas) // On ouvre le menu de gestion du villageois sélectionné.
    else
      exit := 1;

  until exit = 1;

end;

function newPersonnage(var town : Village) : Personnage;
{créer un type personnage (record) avec une variable ID, une variable PV et une variable travail}
begin

  town.villagersNumber := town.villagersNumber + 1;

  newPersonnage.affectedArea := NO_AREA;
  newPersonnage.isSick := false;
  newPersonnage.deathCounter := -1;
  newPersonnage.busy := DONT_BUILD; // Ne construit pas
  newPersonnage.name := getFileLine('data/villager.list', town.villagersNumber - 1);
  newPersonnage.dead := false;
end;

end.
