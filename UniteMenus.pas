unit UniteMenus;

{$mode objfpc}{$H+}

interface
  uses keyboard, crt;

  function displayMenu(fileMenu: string): Integer;

implementation
  procedure moveCursor(yMove: Integer; deletePrev: Boolean);
  begin
      if deletePrev then
      begin
          GotoXY(1, WhereY);
          Write('   ');
      end;
      GotoXY(1, WhereY + yMove); ;
      Write('==>');
  end;

  function displayMenu(fileMenu: string): Integer;
  var
    Stock : text;
    i, choice, key: Integer;
    tmp: string;
    cursorOrigin: tcrtcoord;
  begin
      assign(Stock, fileMenu); // Assiagnation fichier < - > Var.
      reset(Stock); // ouverture du fichier en lecture.

      i := 1; // Initialisation de la var d'increment.

      while not eof(Stock) do
      begin
           readln(Stock, tmp);
           WriteLn('    ', i, '.', tmp); // Lecture des infos à partir du fichier.
           i := i + 1; // Incrément de la var i.
      end;
      close(Stock); // Fermeture du fichier.

      choice := 1;

      cursorOrigin := WhereY;

      moveCursor(-i + 1, false);
;
      InitKeyBoard;
      key := TranslateKeyEvent(GetKeyEvent);
      while key <> 7181 do
      begin
           case key of
           33619745:
                  if choice - 1 >= 1 then
                     begin
                         choice := choice - 1;
                         moveCursor(-1, true);
                     end;
           33619751:
                  if choice + 1 < i then
                     begin
                         choice := choice + 1;
                         moveCursor(1, true);
                     end;
           end;
           key := TranslateKeyEvent(GetKeyEvent);
      end;
      DoneKeyBoard;

      GotoXY(1, cursorOrigin);

      displayMenu := choice;
  end;

end.

