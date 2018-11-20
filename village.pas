unit Village;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type Mois = (janvier,fevrier,mars,avril,mai,juin,juillet,aout,septembre,octobre,novembre,decembre);
  type Metier = (bucheron,constucteur,pecheur,explorateur,fermier,aucun,pillard);
  type personnage = record
       PV : Integer;
       travail : Metier;
       ID : Integer;
  end;
  end;
  {Début de la nouvelle partie}
  procedure debutPartie(var bois,poisson,viande,pain,lait,legumes,composesScientifique,objetsPrecieux,annee,tour : Integer; m : Mois);
  {Passe un tour}
  procedure tourSuivant;
  {Créer un nouveau personnage}
  function newPersonnage(ID : Integer; t : Metier):Personnage;
  function writeMetier( t: Metier):String;

implementation
var
   bois,poisson,viande,pain,lait,legumes,composesScientifique,objetsPrecieux,annee,tour : Integer;
   m : Mois;
procedure debutPartie(var bois,poisson,viande,pain,lait,legumes,composesScientifique,objetsPrecieux,annee,tour : Integer; m : Mois);
Begin
  bois := 0;
  poisson := 10;
  viande := 10;
  pain := 10;
  lait := 10;
  legumes := 10;
  composesScientifique := 10;
  objetsPrecieux := 10;
  annee := 2177;
  m := avril;
  tour := 0;
end;
procedure tourSuivant;
Begin
  tour := tour +1;
  if tour = 3 then
  begin
     tour := 0;
     if m = decembre then
     begin
        m := janvier;
        annee := annee +1;
     end
     else
        m := succ(m);
  end;
end;
function newPersonnage( ID : Integer; t: Metier):Personnage;
begin
  newPersonnage.travail := t;
  newPersonnage.ID := ID;
  newPersonnage.PV := 100;
end;
function writeMetier( t: Metier):String;
begin
  case t of
    bucheron : WriteLn(UnicodeCharToString('Bûcheron'));
    constucteur : WriteLn('Constructeur');
    pecheur : WriteLn(UnicodeCharToString('Pêcheur'));
    explorateur : WriteLn('Explorateur');
    fermier : WriteLn('Fermier');
    aucun : WriteLn('Aucune');
    pillard : WriteLn('Pillard');
  end;
end;
end.
