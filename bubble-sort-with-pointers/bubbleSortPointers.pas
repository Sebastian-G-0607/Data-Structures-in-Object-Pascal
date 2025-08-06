program bubbleSortPointers;

{$mode objfpc}

var
    //declaración del arreglo
    arr: array[0..4] of Integer;

    //variable para for
    i: Integer;

//procedimiento para realizar bubble sort usando punteros
procedure bubbleSortPointers(var arr: array of Integer);
var
    i, j, aux: Integer;
    PpointerI, PpointerJ: ^Integer;
begin
    for i := 0 to Length(arr) - 1 do
    begin
        for j := i + 1 to Length(arr) - 1 do
        begin
            PpointerI := @arr[i];
            PpointerJ := @arr[j];
            if PpointerI^ > PpointerJ^ then
            begin
                aux := PpointerI^;
                PpointerI^ := PpointerJ^;
                PpointerJ^ := aux;
            end;
        end;
    end;
end;

//main program
begin
    //inicialización del arreglo
    arr[0] := 12;
    arr[1] := 20;
    arr[2] := 3;
    arr[3] := 90;
    arr[4] := 1;

    //Mostrar el arreglo antes de ordenar
    WriteLn('Arreglo antes de ordenar:');
    for i := 0 to Length(arr) - 1 do
    begin
        Write(arr[i], ' ');
    end;
    WriteLn;

    //Llamada al procedimiento de ordenamiento
    bubbleSortPointers(arr);

    //Mostrar el arreglo después de ordenar
    WriteLn('Arreglo después de ordenar:');
    for i := 0 to Length(arr) - 1 do
    begin
        Write(arr[i], ' ');
    end;
    WriteLn;
end.