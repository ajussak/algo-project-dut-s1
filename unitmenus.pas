unit unitmenus;

{$mode objfpc}{$H+}

interface
  uses keyboard, crt;

  function displayMenu(entries: array of string): Integer;

implementation

  //Afficher le curseur du menu
  procedure moveCursor(yMove: Integer; deletePrev: Boolean);
  begin
      if deletePrev then //Si on veut suprimmer le cursur du menu précédement affiché.
      begin
          //Effacement du curseur du menu
          GotoXY(1, WhereY);
          Write('   ');
      end;

      //Affichage du nouveau curseur du menu.
      GotoXY(1, WhereY + yMove); ;
      Write('==>');
  end;

  function displayMenu(entries: array of string): Integer;
  var
    choice, key: Integer;
    line: string;
    cursorOrigin: tcrtcoord; //Sauvegarde de la position du curseur de la console
  begin
      //Affichage de chaque choix
      for line in entries do
           WriteLn('   ', line);

      choice := 0;

      cursorOrigin := WhereY;//Sauvegarde la position du curseur de la console
      moveCursor(-Length(entries), false); //Affichage du curseur du menu
;
      InitKeyBoard; //Initialisation de la capture du clavier
      key := TranslateKeyEvent(GetKeyEvent); //Attente et capture de l'appuis d'une touches
      while key <> 7181 do
      begin
           case key of
           33619745: //Si la touche UP est pressée
                  if choice - 1 >= 0 then
                     begin
                         choice := choice - 1;
                         moveCursor(-1, true); //Déplacer le curseur de la console d'un cran vers le bas
                     end;
           33619751: //Si la touche DOWN est pressée
                  if choice + 1 < Length(entries) then
                     begin
                         choice := choice + 1;
                         moveCursor(1, true); //Déplacer le curseur de la console d'un cran vers le haut
                     end;
           end;
           key := TranslateKeyEvent(GetKeyEvent); //Attente et capture de l'appuis d'une touche
      end;
      DoneKeyBoard; //Libération du clavier

      GotoXY(1, cursorOrigin); //Restauration de la position initiale du curseur de la console.

      displayMenu := choice; //Retour du choix de l'utilisateur
  end;

end.

