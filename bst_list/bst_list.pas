program BST_List;

{$mode objfpc}

uses
    SysUtils;

//Defininedo tipos
type
    //list node definition
    TListNode = class
    private
        value: String;
        next: TListNode;
    public
        constructor Create(aValue: String);
    end;

    //list definition
    TList = class
    private
        head: TListNode;
    public
        constructor Create();
        procedure add(aValue: String);
        function print(): String;
        function getNombre(): String;
        function getApellido(): String;
    end;

    //bst node definition
    TNode = class
    private
        key: Integer;
        user: TList;
        left, right: TNode;
    public
        constructor Create(aKey: Integer; aUser: TList);
    end;
    //bst class
    TBST = class
    private
        root: TNode;
    public
        constructor Create();
        procedure insert(id: Integer; user: TList); overload;
        procedure insert(id: Integer; user: TList; parent: TNode); overload;
        procedure print(node: TNode);
        procedure GenDot(); overload;
        procedure GenDot(tmp: TNode); overload;
    end;

constructor TListNode.Create(aValue: String);
begin
    Self.value := aValue;
    Self.next := nil;
end;

constructor TList.Create();
begin
    Self.head := nil;
end;

procedure TList.add(aValue: String);
var
    newNode, current: TListNode;
begin
    newNode := TListNode.Create(aValue);
    if Self.head = nil then
    begin
        Self.head := newNode;
    end
    else
    begin
        // Find the last node
        current := Self.head;
        while current.next <> nil do
            current := current.next;
        current.next := newNode;
    end;
end;

function TList.print(): String;
begin
    Result := Self.head.value + ' ' + Self.head.next.value;
end;

function TList.getNombre(): String;
begin
    Result := Self.head.value;
end;

function TList.getApellido(): String;
begin
    if Self.head <> nil then
        Result := Self.head.next.value
    else
        Result := '';
end;

constructor TNode.Create(aKey: Integer; aUser: TList);
begin
    Self.key := aKey;
    Self.user := aUser;
    Self.left := nil;
    Self.right := nil;
end;

constructor TBST.Create();
begin
    Self.root := nil;
end;

procedure TBST.insert(id: Integer; user: TList; parent: TNode);
begin
    // id is smaller
    if id < parent.key then
    begin
        if parent.left <> nil then
        begin
            insert(id, user, parent.left)
        end
        else
        begin
            parent.left := TNode.Create(id, user);
        end;
    end
    // id is greater
    else
    begin
        if parent.right <> nil then
        begin
            insert(id, user, parent.right);
        end
        else
        begin
            parent.right := TNode.Create(id, user);
        end;
    end;
end;

procedure TBST.insert(id: Integer; user: TList);
begin
    if Self.root <> nil then
    begin
        insert(id, user, Self.root);
    end
    else
        Self.root := TNode.Create(id, user);
end;

procedure TBST.print(node: TNode);
begin
    // pre-order traversal
    if node <> nil then
        Writeln('ID: ' + IntToStr(node.key) + ' --- User: ' + node.user.print());
    if node.left <> nil then
        print(node.left);
    if node.right <> nil then
        print(node.right);
end;

procedure TBST.GenDot();
begin
    Writeln('graph BSTree {');
    Writeln('    node [shape=circle];');
    GenDot(self.root);
    Writeln('}');
end;

procedure TBST.GenDot(tmp: TNode);
begin
    if tmp <> nil then
    begin
        Writeln('   "nombre_', tmp.key, '"', '[shape=rectangle, label="', tmp.user.getNombre(), '"];');
        Writeln('   "apellido_', tmp.key, '"', '[shape=rectangle, label="', tmp.user.getApellido(), '"];');
        Writeln('   "', tmp.key, '" -- "nombre_', tmp.key, '" [dir=none, style=dashed];');
        Writeln('   "nombre_', tmp.key, '" -- "apellido_', tmp.key, '" [dir=none, style=dashed];');
        Writeln('   rank=same { "', tmp.key, '"; "nombre_', tmp.key, '"; "apellido_', tmp.key, '"; }');

        if tmp.left <> nil then
        begin
            Writeln('    "', tmp.key, '" -- "', tmp.left.key, '";'); 
        end;
        if tmp.right <> nil then 
        begin
            Writeln('    "', tmp.key, '" -- "', tmp.right.key, '";'); 
        end;
        GenDot(tmp.left);
        GenDot(tmp.right);
    end;
end;

//main
var
    user1, user2, user3, user4: TList;
    bst: TBST;

begin
    bst := TBST.Create(); //25, 5, 10, 41

    user1 := TList.Create();
    user1.add('Alice');
    user1.add('López');
    bst.insert(25, user1);

    user2 := TList.Create();
    user2.add('Bob');
    user2.add('Martínez');
    bst.insert(5, user2);

    user3 := TList.Create();
    user3.add('Charlie');
    user3.add('González');
    bst.insert(10, user3);

    user4 := TList.Create();
    user4.add('David');
    user4.add('Hernández');
    bst.insert(41, user4);

    bst.print(bst.root);
    bst.GenDot();
end.