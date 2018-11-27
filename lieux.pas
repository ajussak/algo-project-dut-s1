unit lieux;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  place = (foret, lac, ferme, iut);  // nouveau type, definissant les lieux
  ressources = (bois, poissons, carottes, metaux); // nouveau type definissant les types de ressouces


  {Rôle : Pour un lieu donne le nombre de ressources et leur type}
  procedure recolte (lieu : place);

  {rôle : Pour un lieu donne le texte qui lui correspond}
  procedure txtL (lieu : place);

implementation

  {Principe : Le nombre de ressource récolté se trouve dans une constante. Si le lieu est
  foret, on recolte du bois, si le le lieu est lac on recolte des poissons... Ensuite on affiche le nombre
  et le type de ressouces obtenus}
  procedure recolte (lieu : place);
  var
    ress : ressources;
  const
    RESS_NB = 3;
  begin
     if lieu = foret then
         ress := bois
     else
       if lieu = lac then
          ress := poissons
       else
         if lieu = ferme then
            ress := carottes
         else
           if lieu = iut then
              ress := metaux;
     writeln(RESS_NB);
     writeln(ress);
  end;

  {Principe : ouvre un document différent en fonction du lieu donné en Entrée. Par exemple si c'est le lieu
  foret qui est demande, ouvre et affiche le fichier foret.txt et affiche son contenu jusqu'a la fin du dit
  fichier}
  procedure txtL (lieu : place);
  var
    f : TextFile;  // type specifique au fichier
    L: String;  // ligne(s) fichier
  Begin
     if lieu = foret then
         assign(f, 'foret.txt')  // chemin du fichier
     else
       if lieu = lac then
          assign(f, 'lac.txt')
       else
         if lieu = ferme then
            assign(f, 'ferme.txt')
         else
           if lieu = iut then
             assign(f, 'iut.txt');
     reset(f);

     while not eof(f) do   // eof() fonction pr determiner la fin d'un fichier
     begin
       readln(f,L); // lecture du fichier
       writeln(L);  // traitement du fichier, ici afficher les lignes du fichier
     end;
     CloseFile(f);
  end;



end.
