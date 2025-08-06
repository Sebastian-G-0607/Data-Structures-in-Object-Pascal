program colaDePrioridad;

{$mode objfpc}

//Defininedo tipos
type
    //Puntero a nodo
    PNode = ^TNode;
    //Tipo nodo
    TNode = record
        data: Integer;
        priority: Integer;
        previous: PNode;
        next: PNode;
    end;

    //Puntero a cola
    //El nodo próximo a salir es el first, el último en salir es last, a la cabeza -> first, a la cola -> last
    PPriorityQueue = ^TPriorityQueue;
    //Tipo cola
    TPriorityQueue = object
    private
        size: Integer; //Atributo para el tamaño de la cola
        first: PNode; //Atributo para el primer nodo de la cola
        last: PNode; //Atributo para el último nodo de la cola
    public
        procedure init; //Inicializa la cola de prioridad
        function isEmpty: Boolean; //Verifica si la cola está vacía
        procedure enqueue(data, priority: Integer); //Inserta un elemento en la cola
        //function dequeue: Integer; //Elimina y retorna el elemento con mayor prioridad
        procedure orderPriority;
        procedure printQueue;
        //Getters y setters
        function getSize: Integer;
    end;

//Métodos
procedure TPriorityQueue.init;
begin
    Self.size := 0;
    Self.first := nil;
    Self.last := nil;
end;

function TPriorityQueue.getSize: Integer;
begin
    Result := Self.size;
end;


function TPriorityQueue.isEmpty: Boolean;
begin
    Result := Self.size = 0;
end;

procedure TPriorityQueue.enqueue(data: Integer; priority: Integer);
var
    newNode: PNode;
begin
    //si la lista no está vacía
    if not Self.isEmpty() then
    begin
        //Inicializo el nodo
        New(newNode);
        newNode^.data := data;
        newNode^.priority := priority;
        newNode^.next := Self.last;
        newNode^.previous := nil;
        //El último nodo apunta al nuevo nodo
        Self.last^.previous := newNode;
        //Añado nodo a la lista y se convierte en el último
        Self.last := newNode;
        Self.size := Self.size + 1;
        //Dispose(newNode);
    end
    //si la lista está vacía
    else
    begin
        //Inicializo el nodo
        New(newNode);
        newNode^.data := data;
        newNode^.priority := priority;
        newNode^.previous := nil;
        newNode^.next := nil;
        //Añado nodo a la lista
        Self.first := newNode;
        Self.last := newNode;
        Self.size := Self.size + 1;
        //Dispose(newNode);
    end;
end;

procedure TPriorityQueue.printQueue();
var
    current: PNode;
begin
    //inicializo actual
    New(current);
    current := Self.first;
    //Recorro la lista:
    while current <> nil do
    begin
        Writeln(current^.data, ', ' ,current^.priority);
        current := current^.previous;
    end;
end;

procedure TPriorityQueue.orderPriority();
var
    i: Integer;
    actual, b, c, d: PNode;
begin
    actual := Self.first;
    //Caso donde solo hay un elemento
    if (Self.getSize() = 1) or (Self.isEmpty) then
    begin
        Exit;
    end

    //Caso donde hay dos elementos
    else if (Self.getSize() = 2) then
    begin
        if actual^.priority > actual^.previous^.priority then
        begin
            b := actual^.previous;
            //a.anterior = nulo
            actual^.previous := nil;
            //a.siguiente = b
            actual^.next := b;
            //b.siguiente = nulo
            b^.next := nil;
            //b.anterior = a
            b^.previous := actual;
            //Self.primero = b
            Self.first := b;
            //Self.ultimo = a
            Self.last := actual;
            Exit;
        end
        else
        begin
            Exit;
        end;
    end
    else
    begin
        for i := 0 to Self.size - 1 do
        begin
            actual := Self.first;
            while (actual^.previous <> nil) do
            begin
                //Si estoy intercambiando la cabeza (first)
                if actual = Self.first then
                begin
                    if actual^.priority > actual^.previous^.priority then
                    begin
                        //Guardo referencias
                        b := actual^.previous;
                        c := b^.previous;
                        //a.siguiente = b
                        actual^.next := b;
                        //a.anterior = c
                        actual^.previous := c;
                        //b.siguiente = nulo
                        b^.next := nil;
                        //b.anterior = a
                        b^.previous := actual;
                        //c.siguiente = a
                        c^.next := actual;
                        Self.first := b;
                    end
                    else
                    begin
                        actual := actual^.previous;
                    end;
                end
                //Si estoy intercambiando el último (last)
                else if actual^.previous = Self.last then
                begin
                    if actual^.priority > actual^.previous^.priority then
                    begin
                        //Guardo referencias
                        b := actual^.previous;
                        c := actual^.next;

                        //a.siguiente = b
                        actual^.next := b;
                        //a.anterior = nulo
                        actual^.previous := nil;
                        //b.siguiente = c
                        b^.next := c;
                        //b.anterior = a
                        b^.previous := actual;
                        //c.siguiente = a
                        c^.previous := b;
                        Self.last := actual;
                    end
                    else
                    begin
                        actual := actual^.previous;
                    end;
                end
                else
                begin
                    if actual^.priority > actual^.previous^.priority then
                    begin
                        //guardo referencias
                        c := actual^.next;
                        b := actual^.previous;
                        d := b^.previous;
                        //empiezo intercambios
                        actual^.next := b;
                        actual^.previous := d;
                        
                        b^.next := c;
                        b^.previous := actual;

                        c^.previous := b;
                        d^.next := actual;
                    end
                    else
                    begin
                        actual := actual^.previous
                    end;
                end;
            end;
        end;
    end;
end;

//main
var
    lista: TPriorityQueue;

begin
    lista.init;
    //lista.enqueue(valor, prioridad);
    lista.enqueue(1, 3);
    lista.enqueue(2, 2);
    lista.enqueue(3, 1);
    lista.enqueue(4, 3);
    lista.enqueue(5, 2);
    lista.enqueue(6, 1);
    Writeln('Desordenada');
    lista.printQueue();
    lista.orderPriority();
    Writeln('Ordenada');
    lista.printQueue();
end.