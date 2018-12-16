unit Utils;

{$mode objfpc}{$H+}

interface

uses crt;

  procedure displayFile(filename: string; xPos: tcrtcoord; waitUser: Boolean);
  procedure clearScreen();
  function getFileLine(filename: string; ind: Integer): string;

implementation

uses
  unitmenus;

function getFileLine(filename: string; ind: Integer): string;
var
  stock: text;
  i: Integer;
  line: string;
begin
  assign(stock, filename); //Ouvrir le fichier
  reset(stock);
  for i := 0 to ind do
    readln(stock, line);
  getFileLine := line;
end;

{ Afficher le contenu d'un fichier à l'écran }
procedure displayFile(filename: string; xPos: tcrtcoord; waitUser: Boolean);
var
  stock: text;
  ligne : string;
  //Buffer
  menu : array of string; //Menu
begin
  assign(stock, filename); //Ouvrir le fichier
  reset(stock);
  while not eof(stock) do  //Tant que nous avons pas atteint la fin du fichier
  begin
    gotoXY(xPos, WhereY); //Positionnement du curseur sur l'axe X défini en paramètre
    readln(stock, ligne); //Lecture de ligne du fichier et mise en mémoire
    writeln(ligne); //Affichage de la ligne en mémoire
  end;
  close(Stock); //Fermeture du fichier

  if waitUser then //Si on doit attendre une action du joueur pour continuer
  begin
    //Définition du menu
    SetLength(menu, 1);
    menu[0] := 'Retour';

    WriteLn;
    displayMenu(menu); //Afficher le menu
  end;
end;

{ Vider la console }
procedure clearScreen();
begin
  ClrScr; //Vidage de la console
  GotoXY(1,1); //Postionnement du curseur
end;

end.

