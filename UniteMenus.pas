unit UniteMenus;

{$mode objfpc}{$H+}

interface
  uses GestionEcran, crt, keyboard;

  {Cette procedure va gérer la lecture de fichier, la positionnement du curseur, l'affichage du texte}
  procedure Menus();

  {Gestion des Inputs du clavier et réponse en fonction de la touche taper}
  procedure clavier();


implementation

{Cette procedure va gérer la lecture de fichier, la positionnement du curseur, l'affichage du texte}

  {Début procedure Menus}
  procedure Menus();
  var
     Stock : text; // Assiagnation fichier Var.
     i, j, x, y : Integer; // Var d'increment x2, coordonnées X,Y.
     nomMenus : array[1..10] of String; // Tableau qui contient les noms des Menus.

  begin
    assign(Stock, 'StockMenus.txt'); // Assiagnation fichier < - > Var.
    reset(Stock); // ouverture du fichier en lecture.

    i := 1; // Initialisation de la var d'increment.

    x := 20; // Var de la position en X.
    y := 20; // Var de la position en Y.

    while not eof(Stock) do
    begin
      readln(Stock, nomMenus[i]); // Lecture des infos à partir du fichier.
      i := i + 1; // Incrément de la var i.
    end;
    close(Stock); // Fermeture du fichier.

    effacerEcran(); // Effacement de la console.

    cursoroff; // Disable cursor.

    deplacerCurseurXY(x, y); // Positionnement du curseur.

    for j := 1  to length(nomMenus) do
     begin
      writeln(nomMenus[j]); // Ecriture sur la console des noms.
      deplacerCurseurXY(x, y+2); // Positionnement du curseur.
     end;

     clavier(); // Appel de la procedure 'clavier'.

   end;
   {Fin procedure Menus}

{Gestion des Inputs du clavier et réponse en fonction de la touche taper}

  {Début procedure Clavier}
  procedure clavier();
   Var
     K : TKeyEvent; // Déclaration de la var K de type TKeyEvent.

   begin
     InitKeyBoard; // Initialisation du clavier.

     Repeat
       K:=GetKeyEvent; // Attente de la pression d'une touche.
       K:=TranslateKeyEvent(K); // Transtypage TKeyEvent -> Integer.

       if K = 550 then // touche 550 = 'et commercial'.

          begin
           effacerEcran(); // Effacement de la console.
           writeln('LOL1'); // Effectuation de ce que voulez.
          end

       else if K = 898 then // touche 898 = 'é'.

              begin
                 effacerEcran(); // Effacement de la console.
                 writeln('LOL2'); // Effectuation de ce que voulez.
              end;

     Until K = 283 ; // Echap condition de sortie.
     exit // Sortie du programme
   end;
  {Fin procedure Clavier}

end.

