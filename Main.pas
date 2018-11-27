program Main;

uses UniteMenus, VillageUnit, crt;

var
  town: Village;

begin
  cursoroff;
  debutPartie(town);
  WriteLn(town.pain);
  WriteLn(displayMenu('/home/adrien/bite.txt'));
end.
