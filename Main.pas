program Main;

uses UniteMenus, VillageUnit, crt, Utils, UnitArea, UnitResources;

procedure play();
var
  menuChoice, exit: Integer;
  menu:  array[0 .. 3] of string;
  town: Village;
  areas: AreaRegistry;
begin
  registerAreas(areas);
  debutPartie(town);
  exit := 0;
  Repeat
        //Vider la console
        clearScreen();

        displayFile('data/Campement.txt', 1, false);
        WriteLn;

        displayDate(town);
        displayStats(town.resources);

        menu[0] := 'Gérer les villageois';
        menu[1] := 'Se rendre à ...';
        menu[2] := 'Dormir';
        menu[3] := 'Quitter le jeu';

        menuChoice := displayMenu(menu);
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

  cursoroff;
  clearScreen();

  menu[0] := 'Nouvelle partie';
  menu[1] := 'Quitter le jeu';
  case displayMenu(menu) of
  0: play();
  end;

  cursoron;
end.
