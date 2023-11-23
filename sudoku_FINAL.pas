program sudoku_pFINAL;

uses SysUtils, crt, DateUtils;

type
Tablero_Sudoku = array[1..9, 1..9] of Integer;


var
Sudoku: Tablero_Sudoku;

opcion_juego,opcion,i: integer;
usuario,cedula:string;
contiene_Letras:boolean;

procedure Imprimir_sudoku(const Sudoku: Tablero_Sudoku);
    var
    i, j: Integer;
  begin
                  for i := 1 to 9 do
                  begin
                  if (i = 1) or (i mod 3 = 1) then
                      Writeln('-----------------------');

                  for j := 1 to 9 do
                  begin
                  if (j = 1) or (j mod 3 = 1) then
                      Write('\ ');

                  if Sudoku[i, j] = 0 then
                      Write('  ')
                  else
                      Write(Sudoku[i, j], ' ');
                  end;
                  Writeln;
                  end;
              end;


function Numero_Valido(const Sudoku: Tablero_Sudoku; Fila, Columna, Numero: Integer): Boolean;
    var
        i, j, Inicio_Fila, Inicio_Columna: Integer;
  begin
              for i := 1 to 9 do
              begin
              if (Sudoku[Fila, i] = Numero) or (Sudoku[i, Columna] = Numero) then
                  Exit(False);
              end;

            Inicio_Fila := ((Fila - 1) div 3) * 3 + 1;
            Inicio_Columna := ((Columna - 1) div 3) * 3 + 1;

              for i := Inicio_Fila to Inicio_Fila + 2 do
              begin
              for j := Inicio_Columna to Inicio_Columna + 2 do
              begin
                  if Sudoku[i, j] = Numero then
                  Exit(False);
                  end;
              end;

          Exit(True);
          end;

function Resolver_Sudoku(var Sudoku: Tablero_Sudoku): Boolean;
var
    Fila, Columna, Numero: Integer;
begin
    for Fila := 1 to 9 do
    begin
    for Columna := 1 to 9 do
    begin
        if Sudoku[Fila, Columna] = 0 then
        begin
        for Numero := 1 to 9 do
        begin
            if Numero_Valido(Sudoku, Fila, Columna, Numero) then
            begin
            Sudoku[Fila, Columna] := Numero;
            if Resolver_Sudoku(Sudoku) then
                Exit(True);
            Sudoku[Fila, Columna] := 0;
            end;
        end;
        Exit(False);
        end;
    end;
    end;
Exit(True);
end;
Procedure Instrucciones;
Begin
	clrscr;
        writeln('================================================');
        Writeln('                    REGLAS                      ');
	writeln('================================================');
	writeln('Regla 1: Hay que completar las casillas vacias  ');
	Writeln('con numeros del 1 al 9.');
	writeln('************************************************');
	writeln('Regla 2: En una misma fila y columna no puedes ingresar');
	Writeln('numeros repetidos.');
	writeln('************************************************');
	writeln('Regla 3: En una misma recuadro de 3x3.');
	Writeln('no puede haber numeros repetidos.');
	writeln('************************************************');
	writeln('Regla 4: Solo existe una solucion.');
	writeln('************************************************');
	Writeln('');
	Writeln ('Presione cualquier tecla');
	readkey;
End;

procedure Menu(const Sudoku: Tablero_Sudoku);
begin
    gotoxy(1, 13);
    Writeln('-----------------------');
    gotoxy(1, 14);
    Writeln('  ----- SUDOKU -----');
    WriteLn('');
    gotoxy(1,1);
    Imprimir_Sudoku(Sudoku);
    gotoxy(1, 15);
    Writeln('-----------------------');
    gotoxy(1, 16);
    Writeln('1) Ingresar numero');
    gotoxy(1, 17);
    WriteLn('2) Borrar numero');
    gotoxy(1, 18);
    Writeln('3) Rendirse');
    gotoxy(1, 19);
    Writeln('4) Salir');
    gotoxy(1, 20);
    Writeln('-----------------------');
    gotoxy(27, 12);
    Writeln;
end;

procedure Numero_Ingresado(var Sudoku: Tablero_Sudoku);
var
    Fila, Columna, Numero: Integer;
begin
    Imprimir_Sudoku(Sudoku);
    gotoxy(1, 13);
    Writeln('-----------------------');
    gotoxy(1, 14);
    Write('Ingresa la fila (1-9): ');
    ReadLn(Fila);
    Writeln('-----------------------');
    Write('Ingresa la columna (1-9): ');
    ReadLn(Columna);
    Writeln('-----------------------');
    Write('Ingresa el numero (1-9): ');
    ReadLn(Numero);


    if Numero_Valido(Sudoku, Fila, Columna, Numero) then
    begin
    Sudoku[Fila, Columna] := Numero;
    clrscr;
    Writeln('Ingresado con exito.');
    Writeln('Sudoku actualizado....');
    Imprimir_Sudoku(Sudoku);
    end
    else
    begin
    Writeln('Numero Erroneo, Intenta nuevamente.');
    end;

    WriteLn;
    Write('Presiona cualquier tecla');
    ReadKey;
end;

procedure Pistas_Sudoku(var Sudoku: Tablero_Sudoku; Pistas: Integer);
var
    Fila, Columna, Numero, Pistas_Eliminadas, Total_Pistas: Integer;
    Pistas_Aleatorias: array[1..81] of Integer;                         
    i: Integer;
begin

    Resolver_Sudoku(Sudoku);
    Total_Pistas := 81;
    Pistas_Eliminadas := 0;

    for Fila := 1 to 9 do
    begin
    for Columna := 1 to 9 do
    begin
      Pistas_Aleatorias[Pistas_Eliminadas + 1] := (Fila - 1) * 9 + Columna;
        Pistas_Eliminadas := Pistas_Eliminadas + 1;
    end;
    end;

    for i := Total_Pistas downto 2 do
    begin
    Fila := Random(i) + 1;
    Columna := Random(i) + 1;

    Numero := Pistas_Aleatorias[i];
    Pistas_Aleatorias[i] := Pistas_Aleatorias[Fila];
    Pistas_Aleatorias[Fila] := Numero;
    end;

    for i := 1 to Pistas_Eliminadas - Pistas do
    begin
    Fila := (Pistas_Aleatorias[i] - 1) div 9 + 1;
    Columna := (Pistas_Aleatorias[i] - 1) mod 9 + 1;
    Sudoku[Fila, Columna] := 0;
    end;
end;

procedure Rendirse(var Sudoku: Tablero_Sudoku);
begin
    Writeln('Te has rendido. Generando solucion del Sudoku...');
    Writeln('Sudoku resuelto:');
    Resolver_Sudoku(Sudoku);
    Imprimir_Sudoku(Sudoku);
    Writeln('-----------------------');

    WriteLn;
    Write('Presiona cualquier tecla');
    ReadKey;
end;


procedure Ganador(var Sudoku: Tablero_Sudoku);
begin
    if Resolver_Sudoku(Sudoku) then
    begin
        clrscr;
        gotoxy(18, 11);
        Writeln('================= ---------- ===================');
        gotoxy(18, 12);
        WriteLn('Felecidades, logro completar el sudoku "ELMISTER"');
        gotoxy(18, 13);
        Writeln('================= GANADOR :D ===================');
        readkey;
    end;
end;


procedure Borrar_Numero(var Sudoku: Tablero_Sudoku);
var
    Fila, Columna: Integer;
begin
    Imprimir_Sudoku(Sudoku);
    gotoxy(1, 13);
    Writeln('-----------------------');
    Write('Ingresa la fila (1-9): ');
    ReadLn(Fila);
    Writeln('-----------------------');
    Write('Ingresa la columna (1-9): ');
    ReadLn(Columna);

    Sudoku[Fila, Columna] := 0;
    if Sudoku[Fila, Columna] = 0 then
    begin
        writeln(' ');
    end;
    WriteLn;
    Write('Presiona cualquier tecla');
    ReadKey;
end;


function Sudoku_Completo(const Sudoku: Tablero_Sudoku): Boolean;
var
    Fila, Columna: Integer;
begin
    for Fila := 1 to 9 do
    begin
    for Columna := 1 to 9 do
    begin
        if Sudoku[Fila, Columna] = 0 then
        Exit(False);
    end;
end;
    Sudoku_Completo := True;
end;

BEGIN

textcolor(green);
textbackground(white);
    clrscr;
        Writeln ('---------------------------------------------------');
        Writeln ('         BIENVENIDO AL SUDOKU  "ELMISTER"          ');
	Writeln ('---------------------------------------------------');

		Write ('Ingrese su nombre de usuario: ');
		Readln (usuario);
			if length(usuario) < 2 then
				repeat
					begin
					writeln('El nombre de usuario es demasiado corto');
					write('Porfavor ingreselo nuevamente:');
					readln(usuario);
					end;
				until length(usuario) > 2;
				
					
			
		
		  repeat
    write('ingrese su cedula: ');
    readln(cedula);

    contiene_Letras := False;

    for i := 1 to length(cedula) do
    begin
      if (cedula[i] in ['a'..'z', 'A'..'Z']) then
      begin
        contiene_Letras := True;
        break;
      end;
    end;

    if contiene_Letras then
      writeln('La cedula no puede contener letras. Por favor, ingrese nuevamente.');
      writeln('');
  until not contiene_Letras;
		clrscr;
		writeln ('Los datos ingresados son:');
		Writeln ('Nombre: ', usuario);
		writeln ('Cedula: ', cedula);
                Writeln ('Presione cualquier tecla para entrar al menu');
		readkey;
	repeat
	clrscr;

        gotoxy(30, 8);
        Writeln('       Bienvenido');
        gotoxy(30, 9);
        Writeln ('   Usuario: *', usuario,'*');
        gotoxy(30, 10);
        Writeln ('    ID: *', cedula,'*');
        gotoxy(30, 11);
        Writeln('-----------------------');
        gotoxy(30, 12);
        writeln ('          MENU      ');
        gotoxy(30, 13);
        Writeln('-----------------------');
        gotoxy(30, 14);
        writeln ('       1) JUGAR');
        writeln(' ');
        gotoxy(30, 15);
        Writeln ('       2) REGLAS');
        writeln(' ');
        gotoxy(30, 16);
        Writeln ('       3) SALIR');
        gotoxy(30, 17);
        Writeln('-----------------------');

	Readln (opcion_juego);
		case opcion_juego of
			1: begin
			    clrscr;
			    Randomize;
                Pistas_Sudoku(Sudoku,17);

                repeat
                ClrScr;
                Menu(Sudoku);
                gotoxy(1,21);
                Write('Selecciona una opcion: ');
                ReadLn(Opcion);
                ClrScr;

                case Opcion of
                1:begin
                    clrscr;
                    Numero_Ingresado(Sudoku);
                    if Sudoku_Completo(Sudoku) then
                    begin
                        Ganador(Sudoku);
                        Break;
                    end;
                    clrscr;
                end;
                2:begin
                    clrscr;
                    Borrar_Numero(Sudoku);
                end;
                3:begin
                    Rendirse(Sudoku);
                end;
    end;


            until Opcion = 4;
	end;
			2: begin
			    instrucciones;
			end;
			3: begin
                        textcolor(red);
                        clrscr;
                        gotoxy(29, 11);
			writeln ('Gracias por jugar :3');
                        readkey;
                        end;
		end;
	until opcion_juego = 3;
END.

