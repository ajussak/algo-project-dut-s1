unit Engine;

{$mode objfpc}{$H+}

interface

uses UniteMenus, VillageUnit, crt, UnitArea, Utils, UnitResources;

type Game = record
  town: Village;
  areas: AreaRegistry;
end;

procedure play();

implementation

procedure play();
var
  jeu: Game;
  menuChoice, exit: Integer;
  menu:  array[0 .. 3] of string;
begin
  registerAreas(jeu.areas);
  debutPartie(jeu.town);
  exit := 0;
  Repeat
        //Vider la console
        clearScreen();

        displayFile('data/Campement.txt', 1, false);
        WriteLn;

        displayDate(jeu.town);
        displayStats(jeu.town.resources);

        menu[0] := 'Gérer les ouvriers';
        menu[1] := 'Se rendre à ...';
        menu[2] := 'Dormir';
        menu[3] := 'Quitter le jeu';

        menuChoice := displayMenu(menu);
        case menuChoice of
        1: goToArea(jeu.areas);
        2: tourSuivant(jeu.town);
        3: exit := 1;
        end
  Until exit = 1;
end;


end.

