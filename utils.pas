unit Utils;

{$mode objfpc}{$H+}

interface

uses crt, UniteMenus;

procedure displayFile(filename: string; xPos: tcrtcoord; waitUser: Boolean);
procedure clearScreen();

implementation

procedure displayFile(filename: string; xPos: tcrtcoord; waitUser: Boolean);
var
  stock: text;
  ligne: string;
  menu: array of string;
begin
  assign(stock, filename); //Ouvrir le fichier
  reset(stock);
  while not eof(stock) do  //Tant que nous avons pas atteint la fin du fichier
  begin
    gotoXY(xPos, WhereY); //Positionnement du curseur sur l'axe X défini en paramètre
    readln(stock, ligne); //Lecture de ligne du fichier et mise en mémoire
    writeln(ligne); //Affichage de la ligne en mémoire
  end;
  close(Stock);

  if waitUser then //Si on doit attendre une action du joueur pour continuer
  begin
    //Définition du menu
    SetLength(menu, 1);
    menu[0] := 'Retour';
    WriteLn;
    displayMenu(menu); //Afficher le menu
  end;
end;

//Vider l'écran
procedure clearScreen();
begin
  ClrScr; //Vidage de la console
  GotoXY(1,1); //Postionnement du curseur
end;

end.

