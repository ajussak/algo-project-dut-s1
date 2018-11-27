unit UniteMenus;

{$mode objfpc}{$H+}

interface
  uses keyboard, crt;

  function displayMenu(fileMenu: string): Integer;

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

  function displayMenu(fileMenu: string): Integer;
  var
    Stock : text;
    i, choice, key: Integer;
    tmp: string; // Variable temporaire
    cursorOrigin: tcrtcoord; //Sauvegarde de la position du curseur de la console
  begin
      assign(Stock, fileMenu); // Assiagnation fichier < - > Var.
      reset(Stock); // ouverture du fichier en lecture.

      i := 1; // Initialisation de la var d'increment.

      //Affichage de chaque ligne du fichier précédée par le numéro choix correspondant.
      while not eof(Stock) do
      begin
           readln(Stock, tmp);
           WriteLn('    ', i, '.', tmp);
           i := i + 1;
      end;

      close(Stock); // Fermeture du fichier.

      choice := 1;

      cursorOrigin := WhereY;//Sauvegarde la position du curseur de la console
      moveCursor(-i + 1, false); //Affichage du curseur du menu
;
      InitKeyBoard; //Initialisation de la capture du clavier
      key := TranslateKeyEvent(GetKeyEvent); //Attente et capture de l'appuis d'une touches
      while key <> 7181 do
      begin
           case key of
           33619745: //Si la touche UP est pressée
                  if choice - 1 >= 1 then
                     begin
                         choice := choice - 1;
                         moveCursor(-1, true); //Déplacer le curseur de la console d'un cran vers le bas
                     end;
           33619751: //Si la touche DOWN est pressée
                  if choice + 1 < i then
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

