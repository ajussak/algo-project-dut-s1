program Main;

uses UniteMenus, VillageUnit, crt, screenhelper, Utils;

procedure play();
var
  town: Village;
  menuChoice, exit: Integer;
  menu:  array[0 .. 2] of string;
begin
  debutPartie(town);
  exit := 0;
  Repeat
        //Vider la console
        clearScreen();

        displayDate(town);
        displayStats(town);

        menu[0] := 'Gérer les ouvriers';
        menu[1] := 'Dormir';
        menu[2] := 'Quitter le jeu';

        menuChoice := displayMenu(menu);
        case menuChoice of
        1: tourSuivant(town);
        2: exit := 1;
        end
  Until exit = 1;
end;


var
  menu:  array[0 .. 1] of string;
begin
  cursoroff;

  displayFile('data/title.txt', 0);

  menu[0] := 'Nouvelle partie';
  menu[1] := 'Quitter le jeu';
  case displayMenu(menu) of
  0: play();
  end;

  cursoron;
end.
