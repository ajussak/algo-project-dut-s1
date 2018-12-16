unit UnitArea;

{$mode objfpc}{$H+}

interface

uses UnitResources;

const
NO_AREA = -1;
HOUSE_FAKE_AREA = -2;
EXPEDITION_FAKE_AREA = -3;

type areaType = (discoverable, buildable); //Types de zones (base = Accesible dès le debut, buildable = Bâtissable)
type NumberArray = array of Integer;

{Définition d'une zone}
type area = record
  name:string; //Nom
  resources, //Resources récoltés par villageoi par tour dans cette zone.
  required: resourceList; //Resources requise pour la construire
  typeArea: areaType; //Type de zone
  enabled: Boolean; //Zone activé (Vistable et attribuable à un villageois.
end;

{Liste de zones}
type AreaRegistry = array of area;

  {Lance un menu de sélection des zones activées et retourne l'ID de la zone sélectioné, si aucune zone n'est sélectionné la fonction retourne -1 (NO_AREA)}
  function availableAreaSelector(var areas: AreaRegistry): Integer;
  {Visiter une zone selectioné par un menu}
  procedure goToArea(var areas: AreaRegistry);
  {Enregistrement des différentes zones du jeu}
  procedure registerAreas(var areas: AreaRegistry);

implementation

uses
  Utils, unitmenus;

{Visiter une zone selectioné par un menu}
procedure goToArea(var areas: AreaRegistry);
var
  choice: Integer;
  eMenu : array of string;
begin
  WriteLn;
  WriteLn(UTF8ToAnsi('Sélectionnez la zone à visiter : '));

  choice := availableAreaSelector(areas); //Menu de sélection d'une zone accessible

  if choice <> NO_AREA then //Si une est sélectionée
  begin
    clearScreen; //Vider la consolse

    //Easter Egg
    if areas[choice].name = 'Ferme' then
    begin
      SetLength(eMenu, 2);

      WriteLn();
      eMenu[0] := 'S''adosser au mur.';
      eMenu[1] := 'Retour';

      displayFile('data/' + areas[choice].name + '.txt',1, false);

      if displayMenu(eMenu) = 0 then
      begin
        areas[choice].enabled := false;
        displayFile('data/nope.txt',1, true);
      end;
    end
    else
      displayFile('data/' + areas[choice].name + '.txt',1, true); //Afficher le fichier qui contient le texte descriptif de la zone sélectionée.
  end;
end;

{Obtenir la liste des identifiants des zone visitables et attribuables à villageois.}
function getAvailableAreas(var areas: AreaRegistry): NumberArray;
var
  r: NumberArray; // Tableau contenant les identifiants des zones à retourner
  i, j: Integer;
begin
  j := 0;
  SetLength(r, Length(areas));  // Définitions du nombre maximum de zones pouvant être retourné.
  for i := 0 to Length(areas) - 1 do // Parcour de la liste des zones du jeu
  begin
    if areas[i].enabled then
    begin
       r[j] := i; // On ajoute l'index (l'ID) de la zone dans le tableau r.
       j := j + 1;
    end;
  end;
  SetLength(r, j); // On défini la taille finale du tableau grâce au nombre total de zones bâtissables trouvées.
  getAvailableAreas := r; //Retourner le tableau r
end;

{Lance un menu de sélection des zones activées et retourne l'ID de la zone sélectioner, si aucune zone n'est sélectionné la fonction retourne -1 (NO_AREA)}
function availableAreaSelector(var areas: AreaRegistry): Integer;
var
  menu: array of string;
  availbleAreas: NumberArray;
  i, choice: Integer;
begin
  availbleAreas := getAvailableAreas(areas); // Obtient la liste des zones activées.
  SetLength(menu, Length(availbleAreas) + 1); // Définit le nombre de choix du menu

  //Ajoute dans le menu les noms des zones accessibles
  for i := 0 to Length(availbleAreas) - 1 do
    menu[i] := areas[availbleAreas[i]].name;

  //Ajoute l'option Retour
  menu[Length(availbleAreas)] := 'Retour';

  choice := displayMenu(menu); //Afficher le menu et récupère le choix

  if choice <> Length(availbleAreas) then //Si le choix est différent de Retour
    availableAreaSelector := availbleAreas[choice] //Retourne l'ID de la zone sélectionné
  else
    availableAreaSelector := NO_AREA;
end;

{Enregistrement des différentes zones du jeu}
procedure registerAreas(var areas: AreaRegistry);
begin
  setLength(areas, 6); // Initialisation le tableau des zone

  areas[0].name := 'Forêt';
  areas[0].resources := createResourcesList();
  areas[0].resources[BOIS] := 5;
  areas[0].typeArea := discoverable;
  areas[0].enabled := false;

  areas[1].name := 'IUT';
  areas[1].resources := createResourcesList();
  areas[1].resources[OBJETS_PRECIEUX] := 1;
  areas[1].typeArea := discoverable;
  areas[1].enabled := false;

  areas[2].name := 'Lac';
  areas[2].resources := createResourcesList();
  areas[2].resources[POISSON] := 2;
  areas[2].typeArea := discoverable;
  areas[2].enabled := false;

  areas[3].name := 'Ferme';
  areas[3].resources := createResourcesList();
  areas[3].resources[LEGUMES] := 2;
  areas[3].typeArea := buildable;
  areas[3].required := createResourcesList();
  areas[3].required[BOIS] := 250;
  areas[3].enabled := false;

  areas[4].name := 'Décharge';
  areas[4].resources := createResourcesList();
  areas[4].resources[METAUX] := 2;
  areas[4].typeArea := discoverable;
  areas[4].enabled := false;

  areas[5].name := 'D.Y.T. Liberty Prime';
  areas[5].typeArea := buildable;
  areas[5].required := createResourcesList();
  areas[5].required[BOIS] := 2500;
  areas[5].required[METAUX] := 750;
  areas[5].enabled := false;
end;

end.

