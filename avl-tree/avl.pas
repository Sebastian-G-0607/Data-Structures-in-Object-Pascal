program AVLTreeDemo;

{$mode objfpc}

uses
    Classes, SysUtils;

type
    TNode = class
        Value: Integer;
        Left, Right: TNode;
        Height: Integer;

        constructor Create(AValue: Integer);
    end;

    TAVLTree = class
        Root: TNode;

        procedure Add(AValue: Integer); overload;
        procedure Add(AValue: Integer; var tmp: TNode); overload;

        procedure Delete(AValue: Integer); overload;
        procedure Delete(AValue: Integer; var tmp: TNode); overload;

        function HeightOf(Node: TNode): Integer;
        function Max(A, B: Integer): Integer;

        function SRL(Node: TNode): TNode;
        function SRR(Node: TNode): TNode;
        function DRL(Node: TNode): TNode;
        function DRR(Node: TNode): TNode;

        function FindLeftmostRightChild(Node: TNode): TNode;
        function IsLeaf(Node: TNode): Boolean;

        procedure Preorder(Node: TNode);
        procedure Inorder(Node: TNode);
        procedure Postorder(Node: TNode);

        procedure Levelorder(Node: TNode);
        procedure GenDot(); overload;
        procedure GenDot(Node: TNode); overload;

        function Magic(Node: TNode): Integer;
    end;

{ TNode }

constructor TNode.Create(AValue: Integer);
begin
    Value := AValue;
    Left := nil;
    Right := nil;
    Height := 0;
end;

{ TAVLTree }

procedure TAVLTree.Add(AValue: Integer);
begin
    if Root <> nil then
        Add(AValue, Root)
    else
        Root := TNode.Create(AValue);
end;

procedure TAVLTree.Add(AValue: Integer; var tmp: TNode);
var
    d, i, m: Integer;
begin
    if tmp = nil then
        tmp := TNode.Create(AValue)
    else if AValue < tmp.Value then
    begin
        Add(AValue, tmp.Left);
        if (HeightOf(tmp.Left) - HeightOf(tmp.Right)) = 2 then
        begin
            if AValue < tmp.Left.Value then
                tmp := SRR(tmp)
            else
                tmp := DRR(tmp);
        end;
    end
    else if AValue > tmp.Value then
    begin
        Add(AValue, tmp.Right);
        if (HeightOf(tmp.Right) - HeightOf(tmp.Left)) = 2 then
        begin
            if AValue > tmp.Right.Value then
                tmp := SRL(tmp)
            else
                tmp := DRL(tmp);
        end;
    end;

    d := HeightOf(tmp.Right);
    i := HeightOf(tmp.Left);
    m := Max(d, i);
    tmp.Height := m + 1;
end;

procedure TAVLTree.Delete(AValue: Integer);
begin
    if Root <> nil then
        Delete(AValue, Root);
end;

procedure TAVLTree.Delete(AValue: Integer; var tmp: TNode);
var
    leftmost: TNode;
    tempValue: Integer;
    d, i, m: Integer;
begin
    if tmp = nil then
        Exit; // Nodo no encontrado

    if AValue < tmp.Value then
    begin
        Delete(AValue, tmp.Left);
    end
    else if AValue > tmp.Value then
    begin
        Delete(AValue, tmp.Right);
    end
    else
    begin
        // Nodo encontrado, aplicar algoritmo de eliminación
        if IsLeaf(tmp) then
        begin
            // Caso 1: Es hoja, eliminar directamente
            tmp.Free;
            tmp := nil;
            Exit;
        end
        else
        begin
            // Caso 2: No es hoja, buscar el nodo más a la derecha del subárbol izquierdo
            if tmp.Left <> nil then
            begin
                leftmost := FindLeftmostRightChild(tmp.Left);
                
                // Intercambiar valores
                tempValue := tmp.Value;
                tmp.Value := leftmost.Value;
                leftmost.Value := tempValue;
                
                // Eliminar el nodo que ahora contiene el valor original
                Delete(tempValue, tmp.Left);
            end
            else
            begin
                // Solo tiene hijo derecho
                leftmost := tmp;
                tmp := tmp.Right;
                leftmost.Free;
                Exit;
            end;
        end;
    end;

    // Recalcular altura y rebalancear después de la eliminación
    if tmp <> nil then
    begin
        d := HeightOf(tmp.Right);
        i := HeightOf(tmp.Left);
        m := Max(d, i);
        tmp.Height := m + 1;

        // Verificar balance y aplicar rotaciones si es necesario
        if (HeightOf(tmp.Left) - HeightOf(tmp.Right)) = 2 then
        begin
            if HeightOf(tmp.Left.Left) >= HeightOf(tmp.Left.Right) then
                tmp := SRR(tmp)
            else
                tmp := DRR(tmp);
        end
        else if (HeightOf(tmp.Right) - HeightOf(tmp.Left)) = 2 then
        begin
            if HeightOf(tmp.Right.Right) >= HeightOf(tmp.Right.Left) then
                tmp := SRL(tmp)
            else
                tmp := DRL(tmp);
        end;
    end;
end;

function TAVLTree.FindLeftmostRightChild(Node: TNode): TNode;
begin
    Result := Node;
    while Result.Right <> nil do
        Result := Result.Right;
end;

function TAVLTree.IsLeaf(Node: TNode): Boolean;
begin
    Result := (Node <> nil) and (Node.Left = nil) and (Node.Right = nil);
end;


function TAVLTree.HeightOf(Node: TNode): Integer;
begin
    if Node = nil then
        Exit(-1)
    else
        Exit(Node.Height);
end;

function TAVLTree.Max(A, B: Integer): Integer;
begin
    if A > B then
        Exit(A)
    else
        Exit(B);
end;

{
     --- CASE SRR ---                           
            z
           / \
          T1  y
             / \
            T2  x
               / \
              T3  T4

     --- CUANDO SE INSERTA SE VE ASÍ ---
            z
           /
          y
         /
        x
}

function TAVLTree.SRR(Node: TNode): TNode;
var
    Temp: TNode;
begin
    Temp := Node.Left;
    Node.Left := Temp.Right;
    Temp.Right := Node;

    Node.Height := Max(HeightOf(Node.Left), HeightOf(Node.Right)) + 1;
    Temp.Height := Max(HeightOf(Temp.Left), Node.Height) + 1;

    Result := Temp;
end;

{
     --- CASE SRL ---
            z
           / \
          y   T4
         / \
        x   T3
       / \
      T1  T2
}

function TAVLTree.SRL(Node: TNode): TNode;
var
    Temp: TNode;
begin
    Temp := Node.Right;
    Node.Right := Temp.Left;
    Temp.Left := Node;

    Node.Height := Max(HeightOf(Node.Left), HeightOf(Node.Right)) + 1;
    Temp.Height := Max(HeightOf(Temp.Right), Node.Height) + 1;

    Result := Temp;
end;

{
     --- CASE DRR ---
            z
           / \
          T1  y
             / \
            x   T4
           / \
          T2  T3
}

function TAVLTree.DRR(Node: TNode): TNode;
begin
    Node.Left := SRL(Node.Left);
    Result := SRR(Node);
end;

{
     --- CASE DRL ---
            z
           / \
          y   T4
         / \
        T1  x
           / \
          T2  T3
}

function TAVLTree.DRL(Node: TNode): TNode;
begin
    Node.Right := SRR(Node.Right);
    Result := SRL(Node);
end;

procedure TAVLTree.Preorder(Node: TNode);
begin
    if Node <> nil then
    begin
        Write(Node.Value, ' ');
        Preorder(Node.Left);
        Preorder(Node.Right);
    end;
end;

procedure TAVLTree.Inorder(Node: TNode);
begin
    if Node <> nil then
    begin
        Inorder(Node.Left);
        Write(Node.Value, ' ');
        Inorder(Node.Right);
    end;
end;

procedure TAVLTree.Postorder(Node: TNode);
begin
    if Node <> nil then
    begin
        Postorder(Node.Left);
        Postorder(Node.Right);
        Write(Node.Value, ' ');
    end;
end;

procedure TAVLTree.Levelorder(Node: TNode);
var
    queue: TList;
    curr: TNode;
begin
    if Node = nil then Exit;

    queue := TList.Create;
    try
        queue.Add(Node);

        while queue.Count > 0 do
        begin
            curr := TNode(queue[0]);
            queue.Delete(0);
            Write(curr.Value, ' ');

            if curr.Left <> nil then
                queue.Add(curr.Left);
            if curr.Right <> nil then
                queue.Add(curr.Right);
        end;
    finally
        queue.Free;
    end;
end;

procedure TAVLTree.GenDot();
begin
    Writeln('graph AVLTree {');
    Writeln('    node [shape=circle];');
    GenDot(root);
    Writeln('}');
end;

procedure TAVLTree.GenDot(Node: TNode);
begin
    if Node <> nil then
    begin
        if Node.Left <> nil then
            Writeln('    "', Node.Value, '" -- "', Node.Left.Value, '";');
        if Node.Right <> nil then
            Writeln('    "', Node.Value, '" -- "', Node.Right.Value, '";');
        GenDot(Node.Left);
        GenDot(Node.Right);
    end;
end;

function TAVLTree.Magic(Node: TNode): Integer;
begin
    if Node <> nil then
        Result := Node.Value + Magic(Node.Right) - Magic(Node.Left)
    else
        Result := 0;
end;

{ Main }

var
    AVL: TAVLTree;
begin
    AVL := TAVLTree.Create;
    try
        AVL.Add(5); AVL.Add(10); AVL.Add(15); AVL.Add(20);
        AVL.Add(25); AVL.Add(30); AVL.Add(35);

        Writeln('--- Árbol original ---');
        Write('Preorder: ');
        AVL.Preorder(AVL.Root); Writeln;

        Write('Inorder: ');
        AVL.Inorder(AVL.Root); Writeln;

        Write('Postorder: ');
        AVL.Postorder(AVL.Root); Writeln;

        Write('Levelorder: ');
        AVL.Levelorder(AVL.Root); Writeln;

        AVL.GenDot();

        Writeln;
        Writeln('--- Después de eliminar 10 ---');
        AVL.Delete(10);
        Write('Inorder: ');
        AVL.Inorder(AVL.Root); Writeln;

        AVL.GenDot();

        Writeln;
        Writeln('--- Después de eliminar 20 ---');
        AVL.Delete(20);
        Write('Inorder: ');
        AVL.Inorder(AVL.Root); Writeln;

        AVL.GenDot();

        Writeln;
        Write('DOT: ');
        Writeln;

        //Writeln('Altura: ', AVL.HeightOf(AVL.Root));
        //Writeln('Magic: ', AVL.Magic(AVL.Root));
    finally
        AVL.Free;
    end;
end.
