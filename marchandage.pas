unit Marchandage;

{$mode objfpc}{$H+}{$GOTO ON}

interface
  uses UniteMenus, VillageUnit, sysutils;
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
  procedure commerce(var town: Village);
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
  procedure commerce(var town: Village);
  var
    menusChoixRessources, menusChoixRessourcesQtBois, menusChoixRessourcesQtMetal: Tableau_String;
    QtNourritureS : String;
    resChoix, QtNourritureI: Integer;

    label MenusPrincipal;
  begin

    SetLength(menusChoixRessourcesQtBois, 4); // Ini de la taille de menusChoixRessourcesQtBois.
    SetLength(menusChoixRessourcesQtMetal, 4); // Ini de la taille de menusChoixRessourcesQtMetal.

    // Ini des val du tableau menusChoixRessourcesQtBois.
    menusChoixRessourcesQtBois[0] := ' 1: 50';
    menusChoixRessourcesQtBois[1] := ' 2: 100';
    menusChoixRessourcesQtBois[2] := ' 3: 150';

    // Ini des val du tableau menusChoixRessourcesQtMetal.
    menusChoixRessourcesQtMetal[0] := ' 1: 25';
    menusChoixRessourcesQtMetal[1] := ' 2: 50';
    menusChoixRessourcesQtMetal[2] := ' 3: 75';

    // Appel de aleaRessources().
    menusChoixRessources := aleaRessources();

    // Ini de la taille de menusChoixRessources.
    SetLength(menusChoixRessources, 3);
    menusChoixRessources[2] := ' 3: Partir';

    // Label de début de fonction.
    MenusPrincipal:

    // Cond pour savoir si on a assez d'argent.
    if town.resources.objetsPrecieux < 1 then
      begin
       writeln('Tu n''as pas assez d''objet precieux reviens plus tard');
       readln();
       exit
      end;

    // Conversation du Marchand.
    writeln('Bonjours etranger,');
    writeln('Je suis un marchand itinerant, de quoi as tu besoins ?');
    writeln(' ');

    // Menus choix ressources ou nourriture.
    resChoix := displayMenu(menusChoixRessources);

    // Action selon le menus précedent
    case resChoix of
         // Gestion de la vente des Ressources.
         0:begin
              if menusChoixRessources[0] = ' 1: Bois' then
                 begin
                   menusChoixRessourcesQtBois[3] := ' 4: Retour';
                   resChoix := displayMenu(menusChoixRessourcesQtBois);

                   case resChoix of
                        0:begin
                            town.resources.objetsPrecieux := town.resources.objetsPrecieux - 1;
                            town.resources.bois := town.resources.bois + 50;
                            goto menusPrincipal;
                          end;
                        1:begin
                            town.resources.objetsPrecieux := town.resources.objetsPrecieux - 2;
                            town.resources.bois := town.resources.bois + 100;
                            goto menusPrincipal;
                          end;
                        2:begin
                            town.resources.objetsPrecieux := town.resources.objetsPrecieux - 3;
                            town.resources.bois := town.resources.bois + 150;
                            goto menusPrincipal;
                          end;
                        3:goto menusPrincipal;
                   end;
                 end
              else if menusChoixRessources[0] = ' 1: Metal' then
                 begin
                   menusChoixRessourcesQtMetal[3] := ' 4: Retour';
                   resChoix := displayMenu(menusChoixRessourcesQtMetal);
                   case resChoix of
                        0:begin
                            town.resources.objetsPrecieux := town.resources.objetsPrecieux - 1;
                            //town.resources.bois := town.resources.metal + 25;
                            goto menusPrincipal;
                          end;
                        1:begin
                            town.resources.objetsPrecieux := town.resources.objetsPrecieux - 2;
                            //town.resources.bois := town.resources.metal + 50;
                            goto menusPrincipal;
                          end;
                        2:begin
                            town.resources.objetsPrecieux := town.resources.objetsPrecieux - 3;
                            //town.resources.bois := town.resources.metal + 75;
                            goto menusPrincipal;
                          end;
                        3:goto menusPrincipal;
                   end;
                 end;
           end;
         // Gestion de la vente de la Nourriture.
         1:begin
                Randomize;
                QtNourritureI := Random(5)+5;
                QtNourritureS := IntToStr(QtNourritureI);
                if menusChoixRessources[1] = ' 2: Pain' then
                  begin
                   town.resources.objetsPrecieux := town.resources.objetsPrecieux - 1;
                   town.resources.pain := town.resources.pain + QtNourritureI;
                   goto menusPrincipal;
                  end
                else if menusChoixRessources[1] = ' 2: Lait' then
                  begin
                   town.resources.objetsPrecieux := town.resources.objetsPrecieux - 1;
                   town.resources.lait := town.resources.lait + QtNourritureI;
                   goto menusPrincipal;
                  end;
           end;
         2:exit;
    end;
  end;
end.

