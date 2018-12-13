unit combat;

{$mode objfpc}{$H+}

interface

{rôle : gérer le système de combat entre un ou plusieurs villageois et un ou plusieurs adversaires}
procedure combattre(nbVill : Integer);

implementation

uses
  unitmenus, Utils;
function alea(nb : Integer) : Integer;
begin
  randomize();
  alea := random(nb)+1;
end;

{principe}
procedure combattre(nbVill : Integer);
var
   nbAdvs,
   nVillageois,
   nAdversaires,
   cptKoV,
   cptKoA,
   coup,
   i,
   j,
   tour: Integer;

   advs : Array[1..6] of Integer; // tableau des numéros des pillards
   vill : Array[1..6] of Integer; // tableau des numeros des villageois

   sortie,
   fin_tour: Boolean;

   c : Char;

   res_combat : String;
   menu: array[0 .. 1] of string;
   endMenu: array of string;
begin

  nbAdvs := nbVill;
  tour := 0;
  sortie := false;
  fin_tour := false;
  cptKoA := 0;
  cptKoV := 0;

  menu[0] := 'Oui';
  menu[1] := 'Non';

  setLength(endMenu, 1);
  endMenu[0] := 'Retour au village';

  clearScreen;

  writeln(nbVill, ' de vos villageois sont attaqués par ', nbAdvs, ' pillard(s). Vous allez devoir vous battre !');

  for i:= 1 to nbVill do // attribut les pts a chacun des protagonistes dans la limite de leur nombre total
  begin
    vill[i] := 100;
    advs[i] := 100;
  end;
    while sortie = false do
    begin

         for i:= 1 to nbVill do // attribut les pts a chacun des protagonistes dans la limite de leur nombre total
         begin

         if vill[i] > 0 then
         writeln('Villageois ', i,' : ', vill[i])
         else writeln('Villageois ', i ,' K.O');
         end;

         for j:= 1 to nbAdvs do // attribut les pts a chacun des protagonistes dans la limite de leur nombre total
         begin
         if advs[j] > 0 then
          writeln('pillards ', j,' : ', advs[j])
         else writeln('pillards ', j ,' K.O');
         end;

          tour := tour+1;

          writeln;
          writeln('Continuer ?'); //Demande à l'uitlisateur de continuer le combat
          case displayMenu(menu) of
            0 : fin_tour := false;

            1:
            begin
            res_combat := 'Vous avez fuit le combat !';
            sortie := true;
            end
          end;



        while (fin_tour = false) and (sortie = false) do
        begin
             clearScreen();

            coup := alea(30); // defnit le nombre de dégâts du coup porté

            if tour mod 2 > 0 then // ce sont les adversaires qui attaquent
            begin

              nVillageois := alea(nbVill); // chosit un villageois au hasard

            if vill[nVillageois] > 0 then
            begin
                vill[nVillageois] := vill[nVillageois] - coup;
                if vill[nVillageois] > 0 then
                  begin
                       writeln('Le villageois ', nVillageois ,' est touche, il perd ', coup ,' points de vie. Il lui en reste ', vill[nVillageois] ,'.' );
                  end
                else
                begin
                   writeln('La guerre... La guerre... ne meurt jamais, mais pas les villageois ! Le villageois ', nVillageois ,' est touché, il est maintenant K.O.');
                   cptKoV := cptKoV+1;
                  if cptKoV = nbVill then
                    begin
                      res_combat := 'Désolé, mais les pillards ont été plus fort que vous. Vous avez perdu';
                      sortie := true;
                    end;
                end;

                fin_tour := true;
              end;
            end
            else  // ce sont les adversaires qui attaquent
              begin
                nAdversaires := alea(nbAdvs); // chosit un villaegois au hasard
                  advs[nAdversaires] := advs[nAdversaires] - coup;
                if advs[nAdversaires] > 0 then
                 begin
                 if advs[nAdversaires] > 0 then
                  writeln('Le pillard ', nAdversaires ,' est touché, il perd ', coup ,' points de vie. Il lui en reste ', advs[nAdversaires] ,'.')
                else
                begin
                    writeln('Pas si résistant que ca, ces pillards ! Le pillard ', nAdversaires ,' est touché, il est maintenant K.O.');
                    cptKoA := cptKoA+1;
                    if cptKoA = nbAdvs then
                    begin
                      res_combat := 'Félicitations ! Vous avez vaincu tout les pillards !';
                      sortie := true;
                    end;
                end;
                 end;
                fin_tour := true;
              end;
            end;

         end;
    writeln;
    writeln(res_combat);
    displayMenu(endMenu);
end;


end.


