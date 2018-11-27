program Main;

uses UniteMenus, VillageUnit, crt, screenhelper;

var
  town: Village;
  menuChoice, exit: Integer;
  cursorOrigin: tcrtcoord;

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
        menuChoice := displayMenu('data/village.menu');
        case menuChoice of
        2: tourSuivant(town);
        3: exit := 1;
        end
  Until exit = 1;
end.
