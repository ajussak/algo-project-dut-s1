program Main;

uses UniteMenus, VillageUnit, crt, screenhelper;

var
  town: Village;
  menuChoice, exit: Integer;
  cursorOrigin: tcrtcoord;
  menu:  array[0 .. 2] of string;
begin
  cursoroff;
  debutPartie(town);
  exit := 0;
  Repeat
        //Vider la console
        clearScreen();

        displayDate(town);
        displayStats(town);
        cursorOrigin := WhereY;

        menu[0] := 'Gérer les ouvriers';
        menu[1] := 'Dormir';
        menu[2] := 'Quitter le jeu';

        menuChoice := displayMenu(menu);
        case menuChoice of
        2: tourSuivant(town);
        3: exit := 1;
        end
  Until exit = 1;
end.
