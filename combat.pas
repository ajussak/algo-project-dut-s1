unit combat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GestionEcran;

{rôle : gérer le système de combat entre un ou plusieurs villageois et un ou plusieurs adversaires}
procedure combattre(nbVill : Integer);

implementation
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

   advs : Array[1..6] of Integer; // tableau des numéros des pillars
   vill : Array[1..6] of Integer; // tableau des numeros des villageois

   sortie,
   fin_tour: Boolean;

   c : Char;

   res_combat : String;

begin
  nbAdvs := nbVill;
  tour := 0;
  sortie := false;
  fin_tour := false;
  cptKoA := 0;
  cptKoV := 0;


  writeln(nbVill, ' de vos villageois sont attaque par ', nbAdvs, ' pillar(s). Vous allez devoir vous battre !');

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
         else writeln('villageois ', i ,' K.O');
         end;

         for j:= 1 to nbAdvs do // attribut les pts a chacun des protagonistes dans la limite de leur nombre total
         begin
         if advs[j] > 0 then
          writeln('pillars ', j,' : ', advs[j])
         else writeln('pillars ', j ,' K.O');
         end;

          tour := tour+1;
          writeln('Continuer ? (o/n)');
          readln(c);
          case c of
            'o' : fin_tour := false;

            'n' :
            begin
            res_combat := 'Vous avez fuit le combat !';
            sortie := true;
            end

            else writeln('Resaisisez o OU n');
          end;



        while fin_tour = false do
        begin
             effacerEcran();

            coup := alea(40); // defnit le nombre de dégâts du coup porté

            if tour mod 2 > 0 then // ce sont les adversaires qui attaquent
            begin

              nVillageois := alea(nbVill); // chosit un villageois au hasard

            if vill[nVillageois] > 0 then
            begin
                vill[nVillageois] := vill[nVillageois] - coup;
                if vill[nVillageois] > 0 then
                  begin
                       writeln('le villageois ', nVillageois ,' est touche, il perd ', coup ,' point de vie. Il lui en reste ', vill[nVillageois] ,'.' );
                  end
                else
                begin
                   writeln('la guerre... La guerre... ne meurt jamais, mais pas les villageois ! Le villageois ', nVillageois ,' est touche, il est maintenant K.O.');
                   cptKoV := cptKoV+1;
                  if cptKoV = nbVill then
                    begin
                      res_combat := 'désole, mais les pillars ont ete plus fort que vous. Vous avez perdu';
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
                  writeln('le pillars ', nAdversaires ,' est touche, il perd ', coup ,' point de vie. Il lui en reste ', advs[nAdversaires] ,'.')
                else
                begin
                    writeln('Pas si resistant que ca, ces pillars ! Le pillars ', nAdversaires ,' est touche, il est maintenant K.O.');
                    cptKoA := cptKoA+1;
                    if cptKoA = nbAdvs then
                    begin
                      res_combat := 'Felicitations ! Vous avez vaincu tout les pillars !';
                      sortie := true;
                    end;
                end;
                 end;
                fin_tour := true;
              end;
            end;

         end;
      writeln(res_combat);
end;


end.


