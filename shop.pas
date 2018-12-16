unit shop;

{$mode objfpc}{$H+}{$GOTO ON}

interface
  uses sysutils, unitvillage, unitmenus, Utils, UnitResources;
  type
    Tableau_String = array of String;
  {
   Rôle :
     Cette procedure va gérer le marchand,
     il peut proposer en :
       - ressources :
           - Bois (50 U -> 1 Obj.P, 100 U -> 2 Obj.P, 150 U -> 3 Obj.P),
           - Métal (25 U -> 1 Obj.P, 50 U -> 2 Obj.P, 75 U -> 3 Obj.P).
       - nourriture :
           - Pain (entre 5 et 10 U -> 1 Obj.P),
           - Lait (entre 5 et 10 U -> 1 Obj.P).
  }
  procedure trade(var town: Village);
implementation
  {
   Rôle :
     Cette fonction va donner un preset aléatoire de marchandise proposé par le marchand.
     Les différents presets sont :
         - Bois, Pain;
         - Bois, Lait;
         - Metal, Pain;
         - Metal, Lait;
  }
  function aleaRessources() : Tableau_String;
  var
    menusChoixRessources_1, menusChoixRessources_2, menusChoixRessources_3, menusChoixRessources_4 : Tableau_String;
    choixPreset : Integer;
  begin
    SetLength(menusChoixRessources_1, 2);
    SetLength(menusChoixRessources_2, 2);
    SetLength(menusChoixRessources_3, 2);
    SetLength(menusChoixRessources_4, 2);

    menusChoixRessources_1[0]:=' 1: Bois';
    menusChoixRessources_1[1]:=' 2: Pain';
    menusChoixRessources_2[0]:=' 1: Bois';
    menusChoixRessources_2[1]:=' 2: Lait';
    menusChoixRessources_3[0]:=' 1: Metal';
    menusChoixRessources_3[1]:=' 2: Pain';
    menusChoixRessources_4[0]:=' 1: Metal';
    menusChoixRessources_4[1]:=' 2: Lait';

    Randomize;
    choixPreset := Random(4)+1;
    case choixPreset of
         1:aleaRessources := menusChoixRessources_1;
         2:aleaRessources := menusChoixRessources_2;
         3:aleaRessources := menusChoixRessources_3;
         4:aleaRessources := menusChoixRessources_4;
    end;
  end;

  {
   Rôle :
     Cette procedure va gérer le marchand,
     il peut proposer en :
       - ressources :
           - Bois (50 U -> 1 Obj.P, 100 U -> 2 Obj.P, 150 U -> 3 Obj.P),
           - Métal (25 U -> 1 Obj.P, 50 U -> 2 Obj.P, 75 U -> 3 Obj.P).
       - nourriture :
           - Pain (entre 5 et 10 U -> 1 Obj.P),
           - Lait (entre 5 et 10 U -> 1 Obj.P).
  }
  procedure trade(var town: Village);
  const
       // Valeur de réference de d'achat du bois.
       QTRESSOURCESB1 = '50';
       QTRESSOURCESB2 = '100';
       QTRESSOURCESB3 = '150';

       // Valeur de réference de d'achat du métal.
       QTRESSOURCESM1 = '25';
       QTRESSOURCESM2 = '50';
       QTRESSOURCESM3 = '75';
  var
    menusChoixRessources, menusChoixRessourcesQtBois, menusChoixRessourcesQtMetal: Tableau_String;
    resChoix, QtNourritureI: Integer;

    label MenusPrincipal;
  begin

    SetLength(menusChoixRessourcesQtBois, 4); // Ini de la taille de menusChoixRessourcesQtBois.
    SetLength(menusChoixRessourcesQtMetal, 4); // Ini de la taille de menusChoixRessourcesQtMetal.

    // Ini des val du tableau menusChoixRessourcesQtBois.
    menusChoixRessourcesQtBois[0] := ' 1: ' + QTRESSOURCESB1 + ' Bois = 1 Objet Précieux';
    menusChoixRessourcesQtBois[1] := ' 2: ' + QTRESSOURCESB2 + ' Bois = 2 Objets Précieux';
    menusChoixRessourcesQtBois[2] := ' 3: ' + QTRESSOURCESB3 + ' Bois = 3 Objets Précieux';

    // Ini des val du tableau menusChoixRessourcesQtMetal.
    menusChoixRessourcesQtMetal[0] := ' 1: ' + QTRESSOURCESM1 + ' Métal = 1 Objet Précieux';
    menusChoixRessourcesQtMetal[1] := ' 2: ' + QTRESSOURCESM2 + ' Métal =  = 2 Objets Précieux';
    menusChoixRessourcesQtMetal[2] := ' 3: ' + QTRESSOURCESM3 + ' Métal = 3 Objets Précieux';

    // Init des val du tableau menusChoixRessourcesQtMetal.
    menusChoixRessourcesQtMetal[0] := ' 1: ' + QTRESSOURCESM1 + ' Metal = 1 Objet Precieux';
    menusChoixRessourcesQtMetal[1] := ' 2: ' + QTRESSOURCESM2 + ' Metal =  = 2 Objet Precieux';
    menusChoixRessourcesQtMetal[2] := ' 3: ' + QTRESSOURCESM3 + ' Metal = 3 Objet Precieux';

    // Appel de aleaRessources().
    menusChoixRessources := aleaRessources();

    // Ini de la taille de menusChoixRessources.
    SetLength(menusChoixRessources, 3);
    menusChoixRessources[2] := ' 3: Partir';

    // Label de début de fonction.
    MenusPrincipal:

    // Clear Screen
    clearScreen();

    // Cond pour savoir si on a assez d'argent.
    if town.resources[OBJETS_PRECIEUX] <= 3 then
      begin
       writeln('Tu n''as pas assez d''objets precieux reviens plus tard');
       readln();
       exit
      end;

    // Conversation du Marchand.
    writeln('Bonjours étranger,');
    writeln('Je suis un marchand itinérant, de quoi as tu besoins ?');
    writeln(' ');

    // Menus choix ressources ou nourriture.
    resChoix := displayMenu(menusChoixRessources);

    // Action selon le menus précedent
    case resChoix of
         // Gestion de la vente des Ressources.
         0:begin
              writeln('Quelle quantité veux-tu ? ');
              if menusChoixRessources[0] = ' 1: Bois' then
                 begin
                   menusChoixRessourcesQtBois[3] := ' 4: Retour';
                   resChoix := displayMenu(menusChoixRessourcesQtBois);

                   case resChoix of
                        0:begin
                            town.resources[OBJETS_PRECIEUX] := town.resources[OBJETS_PRECIEUX] - 1;
                            town.resources[BOIS] := town.resources[BOIS] + StrToInt(QTRESSOURCESB1);
                            writeln('Vous avez reçus ', QTRESSOURCESB1, ' de Bois');
                            writeln('Il vous reste ', town.resources[OBJETS_PRECIEUX], ' Objets Précieux');
                            readln();
                            exit;
                          end;
                        1:begin
                            town.resources[OBJETS_PRECIEUX] := town.resources[OBJETS_PRECIEUX] - 2;
                            town.resources[BOIS] := town.resources[BOIS] + StrToInt(QTRESSOURCESB2);
                            writeln('Vous avez reçus ', QTRESSOURCESB2, ' de Bois');
                            writeln('Il vous reste ', town.resources[OBJETS_PRECIEUX], ' Objets Précieux');
                            readln();
                            exit;
                          end;
                        2:begin
                            town.resources[OBJETS_PRECIEUX] := town.resources[OBJETS_PRECIEUX] - 3;
                            town.resources[BOIS] := town.resources[BOIS] + StrToInt(QTRESSOURCESB3);
                            writeln('Vous avez reçus ', QTRESSOURCESB3, ' de Bois');
                            writeln('Il vous reste ', town.resources[OBJETS_PRECIEUX], ' Objets Précieux');
                            readln();
                            exit;
                          end;
                        3:goto menusPrincipal;
                   end;
                 end
              else if menusChoixRessources[0] = ' 1: Métal' then
                 begin
                   menusChoixRessourcesQtMetal[3] := ' 4: Retour';
                   resChoix := displayMenu(menusChoixRessourcesQtMetal);
                   case resChoix of
                        0:begin
                            town.resources[OBJETS_PRECIEUX] := town.resources[OBJETS_PRECIEUX] - 1;
                            //town.resources[METAL] := town.resources[METAL] + StrToInt(QTRESSOURCESM1);
                            writeln('Vous avez reçus ', QTRESSOURCESM1, ' de Métal');
                            writeln('Il vous reste ', town.resources[OBJETS_PRECIEUX], ' Objets Précieux');
                            readln();
                            exit;
                          end;
                        1:begin
                            town.resources[OBJETS_PRECIEUX] := town.resources[OBJETS_PRECIEUX] - 2;
                            //town.resources[METAL] := town.resources[METAL] + StrToInt(QTRESSOURCESM2);
                            writeln('Vous avez reçus ', QTRESSOURCESM2, ' de Métal');
                            writeln('Il vous reste ', town.resources[OBJETS_PRECIEUX], ' Objets Precieux');
                            readln();
                            exit;
                          end;
                        2:begin
                            town.resources[OBJETS_PRECIEUX] := town.resources[OBJETS_PRECIEUX] - 3;
                            //town.resources[METAL] := town.resources[METAL] + StrToInt(QTRESSOURCESM3);
                            writeln('Vous avez reçus ', QTRESSOURCESM3, ' de Métal');
                            writeln('Il vous reste ', town.resources[OBJETS_PRECIEUX], ' Objets Precieux');
                            readln();
                            exit;
                          end;
                        3:goto menusPrincipal;
                   end;
                 end;
           end;
         // Gestion de la vente de la Nourriture.
         1:begin
                Randomize;
                QtNourritureI := Random(5)+5;
                if menusChoixRessources[1] = ' 2: Pain' then
                  begin
                   town.resources[OBJETS_PRECIEUX] := town.resources[OBJETS_PRECIEUX] - 1;
                   town.resources[PAIN] := town.resources[PAIN] + QtNourritureI;
                   writeln('Vous avez reçus ', QtNourritureI, ' de Pain');
                   writeln('Il vous reste ', town.resources[OBJETS_PRECIEUX], ' Objets Précieux');
                   readln();
                   exit;
                  end
                else if menusChoixRessources[1] = ' 2: Lait' then
                  begin
                   town.resources[OBJETS_PRECIEUX] := town.resources[OBJETS_PRECIEUX] - 1;
                   town.resources[LAIT] := town.resources[LAIT] + QtNourritureI;
                   writeln('Vous avez reçus ', QtNourritureI, ' de Lait');
                   writeln('Il vous reste ', town.resources[OBJETS_PRECIEUX], ' Objets Précieux');
                   readln();
                   exit;
                  end;
           end;
         2:begin
                write('Au revoir étranger, c''était un réel plaisir de faire affaire avec toi');
                readln();
                exit;
           end;
    end;
  end;
end.
