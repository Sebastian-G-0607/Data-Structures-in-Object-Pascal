program colaDePrioridad;

{$mode objfpc}

//Defininedo tipos
type
    //Puntero a nodo
    PNode = ^TNode;
    //Tipo nodo
    TNode = record
        data: Integer;
        next: PNode;
    end;

    //Puntero a lista simplemente enlazada
    PList = ^TList;
    //Tipo lista simplemente enlazada
    TList = object
    private
        size: Integer; //Atributo para el tamaño de la lista
        first: PNode; //Atributo para el primer nodo de la lista
    public
        procedure init; //Inicializa la lista
        function isEmpty: Boolean; //Verifica si la lista está vacía
        procedure pushFront(data: Integer); //Inserta un elemento al principio de la lista
        //Getters y setters
        function getSize: Integer;
    end;

    TArrayOfLists = object
    public
        arr: array[0..4] of PList;
        procedure init;
        procedure addTask(idTask: Integer);
        procedure printArray;
    end;

procedure TList.init;
begin
    Self.size := 0;
    Self.first := nil;
end;

function TList.getSize: Integer;
begin
    Result := Self.size;
end;

function TList.isEmpty: Boolean;
begin
    Result := Self.size = 0;
end;

procedure TList.pushFront(data: Integer);
var
    newNode: PNode;
begin
    //inicializo el nodo
    New(newNode);
    //Caso 1: lista vacía:
    if Self.getSize() = 0 then
    begin
        newNode^.data := data;
        newNode^.next := nil;
        Self.first := newNode;
    end
    else
    begin
        newNode^.data := data;
        newNode^.next := Self.first;
        Self.first := newNode;
    end;
end;

procedure TArrayOfLists.init;
var
    List0, List1, List2, List3, List4: PList;

begin
    //Inicia las listas y las añade a cada posición del arreglo
    New(List0);
    New(List1);
    New(List2);
    New(List3);
    New(List4);
    Self.arr[0] := List0;
    Self.arr[1] := List1;
    Self.arr[2] := List2;
    Self.arr[3] := List3;
    Self.arr[4] := List4;
end;

procedure TArrayOfLists.addTask(idTask: Integer);
var
    pos: Integer;
begin
    pos := idTask mod 5;
    Self.arr[pos]^.pushFront(idTask);
end;

procedure TArrayOfLists.printArray;
var
    i: Integer;
    actual: PNode;
begin
    for i := 0 to Length(Self.arr)-1 do
    begin
        actual := Self.arr[i]^.first;
        Writeln('Día ', i, ': ');
        while actual <> nil do
        begin
            Writeln(#9, 'Tarea ' ,actual^.data);
            actual := actual^.next;
        end;
    end;
end;

//main
var
    arreglo: TArrayOfLists;
    i: Integer;
begin
    arreglo.init;
    //Agrego tareas al arreglo de listas
    for i := 0 to 10 do
    begin
        arreglo.addTask(i);
    end;
    //Imprimo el arreglo de listas
    arreglo.printArray();
end.