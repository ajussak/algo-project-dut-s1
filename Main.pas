program Main;

uses UniteMenus, VillageUnit, crt, screenhelper, Utils, engine;

var
  menu:  array[0 .. 1] of string;
begin
  cursoroff;
  clearScreen();

  displayFile('data/title.txt', 1);

  menu[0] := 'Nouvelle partie';
  menu[1] := 'Quitter le jeu';
  case displayMenu(menu) of
  0: play();
  end;

  cursoron;
end.
