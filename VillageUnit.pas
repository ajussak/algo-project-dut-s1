unit VillageUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type Mois = (janvier,fevrier,mars,avril,mai,juin,juillet,aout,septembre,octobre,novembre,decembre);
type Metier = (bucheron,constucteur,pecheur,explorateur,fermier,aucun,ferailleur);
type personnage = record
    PV : Integer;
    travail : Metier;
    ID : Integer;
    Nom : String;
    Prenom : String;
    XP : Integer;
    Niveau : Integer;
  end;
type Village = record
    bois,poisson,viande,pain,lait,legumes,composesScientifique,objetsPrecieux,tour,annee : Integer;
    m : Mois;

  end;
    {Début de la nouvelle partie}
procedure debutPartie(var town : Village);
    {Passe un tour}
procedure tourSuivant(var town : Village);
    {Créer un nouveau personnage}
function newPersonnage(ID : Integer; t : Metier):Personnage;
    {Affiche le role (métier) à l''écran}
function writeMetier( t: Metier):String;
    {Affiche les ressources disponibles à l''écran}
procedure displayStats(var town : Village);
    {Affiche la date à l''écran}
procedure displayDate(var town : Village);


implementation
var
  bois,poisson,viande,pain,lait,legumes,composesScientifique,objetsPrecieux,annee,tour : Integer;
  m : Mois;

procedure debutPartie(var town : Village);
{Initialise les variables de ressources}
Begin
  town.bois := 0;
  town.poisson := 10;
  town.viande := 10;
  town.pain := 10;
  town.lait := 10;
  town.legumes := 10;
  town.composesScientifique := 10;
  town.objetsPrecieux := 10;
  town.annee := 2177;
  town.m := avril;
  town.tour := 0;
end;

procedure displayStats(var town: Village);
begin
  WriteLn('====== Ressources ======');
  WriteLn('Bois : ', town.bois);
  WriteLn('Poisson : ', town.poisson);
  WriteLn('Viande : ', town.viande);
  WriteLn('Pain : ', town.pain);
  WriteLn('Lait : ', town.lait);
  WriteLn('Legumes : ', town.legumes);
  WriteLn('Composes Scientifique : ', town.composesScientifique);
  WriteLn('Objets Precieux : ', town.objetsPrecieux);
  WriteLn;
end;

procedure displayDate(var town : Village);
begin
  WriteLn(town.m, ' ', town.annee, ' Tour : ', town.tour);
end;

procedure tourSuivant(var town : Village);
{incrémente de un la variable tour, incrémente de un la variable mois si tour =3 
et incrémente de un la variable année si mois = décembre}
begin
  town.tour := town.tour +1;
  if town.tour = 3 then
  begin
    town.tour := 0;
    if town.m = decembre then
    begin
      town.m := janvier;
      town.annee := town.annee +1;
    end
    else
      town.m := succ(town.m);
  end;
end;

function newPersonnage(ID: Integer; t: Metier; nom,prenom: String):Personnage;
{créer un type personnage (record) avec une variable ID, une variable PV et une variable travail}
begin
  newPersonnage.travail := t;
  newPersonnage.ID := ID;
  newPersonnage.PV := 100;
  newPersonnage.Nom := nom;
  newPersonnage.Prenom := prenom;
  newPersonnage.XP := 0;
  newPersonnage.Niveau := 0;
end;

function writeMetier( t: Metier):String;
begin
  case t of
    bucheron : WriteLn(UnicodeCharToString('Bûcheron'));
    constucteur : WriteLn('Constructeur');
    pecheur : WriteLn(UnicodeCharToString('Pêcheur'));
    explorateur : WriteLn('Explorateur');
    fermier : WriteLn('Fermier');
    aucun : WriteLn('Aucun');
    ferailleur : WriteLn('Ferailleur');
  end;
end;

end.
