program Main;

uses UniteMenus, VillageUnit, crt, Utils, UnitArea, UnitResources;

procedure play();
var
  menuChoice, exit: Integer;
  menu:  array[0 .. 4] of string; //Entrées du menu
  town: Village;
  areas: AreaRegistry;
begin
  registerAreas(areas); //Définitions des zones
  debutPartie(town); //Initialisation du village
  exit := 0;
  Repeat
        //Vider la console
        clearScreen();

        displayFile('data/Campement.txt', 1, false); //Afficher le texte descriptif du campement
        WriteLn;

        displayDate(town); //Affichage de la date dans le jeu
        displayStats(town.resources); //Affichage des resources du village

        //Définition du menu
        menu[0] := 'Gérer les villageois';
        menu[1] := 'Construire'
        menu[2] := 'Se rendre à ...';
        menu[3] := 'Dormir';
        menu[4] := 'Quitter le jeu';

        menuChoice := displayMenu(menu); //Affichage du menu et récupération du choix de l'utilisateur
        case menuChoice of
        0: manageVillagers(town, areas);
        1: goToArea(areas);
        2: tourSuivant(town, areas);
        3: exit := 1;
        end
  Until exit = 1;
end;

var
  menu:  array[0 .. 1] of string;
begin

  //Support de l'unicode sous Windows
  SetMultiByteConversionCodePage(CP_UTF8);
  SetMultiByteRTLFileSystemCodePage(CP_UTF8);

  cursoroff; //Désactivation du curseur de la console.
  clearScreen(); //Vidage de l'écran

  menu[0] := 'Nouvelle partie';
  menu[1] := 'Quitter le jeu';
  case displayMenu(menu) of
  0: play();
  end;

  cursoron; //Réactivation du curseur de la console.
end.
