program Main;

uses UniteMenus, VillageUnit, crt;

var
  town: Village;

begin
  cursoroff;
  debutPartie(town);
  WriteLn(town.pain);
  WriteLn(displayMenu('data/village.menu'));
end.
