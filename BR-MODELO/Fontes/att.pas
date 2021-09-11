unit att;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Contnrs, comCtrls, uAux, XMLIntf;

  type
    TConjPAtt = class;
    TAtributoOculto = class(TObject)
    Private
      FIdentificador, destruindo: boolean;
      FFilhos: TObjectList;
      FLeftTop: TPoint;
      FPai: TAtributoOculto;
      ConjPai: tconjPAtt;
      FNome: String;
      FTipo: String;
      FThisNode: TTreeNode;
      FMaxCard: integer;
      FMinCard: integer;
      function ehComposto: boolean;
      function GetFilho(index: integer): TAtributoOculto;
      procedure SetCardinalidade(const Value: integer);
      procedure SetFilhos(const Value: TObjectList);
      procedure SetIdentificador(const Value: boolean);
      procedure SetLeftTop(const Value: TPoint);
      procedure SetPai(const Value: TAtributoOculto);
      function ehMultivalorado: boolean;
      procedure SetNome(const Value: String);
      procedure SetTipo(const Value: String);
      procedure SetThisNode(const Value: TTreeNode);
      procedure SetMaxCard(const Value: integer);
      procedure SetMinCard(const Value: integer);
      function GetCardinalidade: integer;
    Public
      IgnoreMult: boolean;
      Function CardStr:String;
      Function ConvCard: integer;
      Property Multivalorado: boolean read ehMultivalorado;
      Property Pai: TAtributoOculto read FPai write SetPai;
      Property Filho[index: integer]: TAtributoOculto read GetFilho;
      Property Filhos: TObjectList read FFilhos write SetFilhos;
      Property LeftTop: TPoint read FLeftTop write SetLeftTop;
      Property Cardinalidade: integer read GetCardinalidade write SetCardinalidade;
      Property Identificador: boolean read FIdentificador write SetIdentificador;
      Property Composto: boolean read ehComposto;
      Property Nome: String read FNome write SetNome;
      Property Tipo: String read FTipo write SetTipo;
      Property ThisNode: TTreeNode read FThisNode write SetThisNode;
      Function NovoFilho(oNome, oTipo: string; oLeftTop: Tpoint; Ident: Boolean;Card: TPoint):TAtributoOculto;
      Constructor Create(oPai: TObject);
      Destructor Destroy; override;
      Procedure Popule(Tree: TTreeView; Node: TTreeNode);
      Function FindByNode(Node: TTreeNode): TAtributoOculto;
      Procedure ReSetConjAtt(conj: TConjPAtt);
      Property GrupoDeAtributos: tconjPAtt read ConjPai;
      Procedure GeraXML(node: IXMLNode);
      Function LoadByXML(node: IXMLNode): boolean;
      Procedure getChilds(aLista: TList);
      Property MaxCard: integer read FMaxCard write SetMaxCard;
      Property MinCard: integer read FMinCard write SetMinCard;
      Procedure Serialize(lst: TStringList; oNivel: integer);
      Procedure unSerialize(lst: TStringList; oNivel: integer);
    end;

    TConjPAtt = class(TComponent)
    private
      destruindo: boolean;
      FAtributosOcultos: TObjectList;
      F_APcultos: string;
      function get_AOcultos: string;
      function getAtr(index: integer): TAtributoOculto;
      procedure SetAtributosOcultos(const Value: TObjectList);
    Public
      Procedure getChilds(aLista: TList);
      Property AtributosOculto[index: integer]: TAtributoOculto read getAtr;
      Property AtributosOcultos: TObjectList read FAtributosOcultos write SetAtributosOcultos;
      Constructor Create(AOwner: TComponent);override;
      Destructor Destroy; override;
      Procedure Popule(Tree: TTreeView; Node: TTreeNode);
      Function NovoAtributo(oNome, oTipo: string; oLeftTop: Tpoint; Ident: Boolean;Card: TPoint):TAtributoOculto;
      Function FindByNode(Node: TTreeNode): TAtributoOculto;
      Procedure ReSetConjAtt(conj: TConjPAtt);
      Procedure GeraXML(node: IXMLNode);
      Function LoadByXML(node: IXMLNode): boolean;
      Procedure Load;
    published
      Property _AOcultos: string read get_AOcultos write F_APcultos;
    end;

implementation

uses Types;

{ TAtributoOculto }
constructor TAtributoOculto.Create(oPai: TObject);
begin
  inherited Create;
  if oPai is TAtributoOculto then Pai := TAtributoOculto(oPai);
//  if oPai is TConjPAtt then ConjPai := TConjPAtt(oPai);
  FFilhos := TObjectList.Create(False);
end;

destructor TAtributoOculto.Destroy;
begin
  destruindo := true;
  if Assigned(Pai) and not (Pai.destruindo) then Pai.FFilhos.Remove(self);
  if Assigned(ConjPai) and not (ConjPai.destruindo) then ConjPai.AtributosOcultos.Remove(self);
  FFilhos.OwnsObjects := true;
  FFilhos.Free;
  inherited;
end;

function TAtributoOculto.ehComposto: boolean;
begin
  Result := Filhos.Count > 0;
end;

function TAtributoOculto.ehMultivalorado: boolean;
begin
  Result := (MaxCard > 0);
end;

function TAtributoOculto.GetFilho(index: integer): TAtributoOculto;
begin
  Result := nil;
  if (index > -1) and (index < Filhos.Count) then Result := TAtributoOculto(Filhos[index]);
end;

function TAtributoOculto.NovoFilho(oNome, oTipo: string; oLeftTop: Tpoint; Ident: Boolean;
  Card: TPoint): TAtributoOculto;
begin
  Result := TAtributoOculto.Create(self);
  with Result do
  begin
    LeftTop := oLeftTop;
    Identificador := Ident;
    MaxCard := Card.Y;
    MinCard := Card.X;
    Nome := oNome;
    Tipo := oTipo;
    ConjPai := Self.ConjPai;
  end;
  FFilhos.Add(Result);
end;

procedure TAtributoOculto.Popule(Tree: TTreeView; Node: TTreeNode);
  var subNode: TTreeNode;
      tmp: string;
      i: integer;
begin
  if not Assigned(node) then
     Node := Tree.Items.AddChild(nil, Nome)
  else
     Node := Tree.Items.AddChild(node, Nome);
  Node.ImageIndex := 1;
  ThisNode := Node;
  subNode := Tree.Items.AddChild(node, 'Propriedades');
  if multivalorado then Tree.Items.AddChild(subNode, 'Cardinalidade: ' + CardStr);
  if Identificador then tmp := 'Sim' else tmp := 'Não';
  Tree.Items.AddChild(subNode, 'Identificador: ' +  tmp);
  Tree.Items.AddChild(subNode, 'Tipo: ' +  Tipo);
  if composto then
  begin
    subNode := Tree.Items.AddChild(node, 'Atributos');
    for i:= 0 to Filhos.Count -1 do Filho[i].Popule(Tree, subNode);
  end;
end;

procedure TAtributoOculto.Serialize(lst: TStringList; oNivel: integer);
  var res: string;
      i: integer;
begin
  res := IntToStr(oNivel) + '|' + IntToStr(LeftTop.X) + '|' + IntToStr(LeftTop.Y) + '|' +
         IntToStr(MaxCard) + '|' + IntToStr(MinCard) + '|' +
         BoolToStr(Identificador) + '|' + Tipo + '|' + Nome + '|';
  lst.Add(res);
  //Filhos
  if composto then
  begin
    for i := 0 to Filhos.Count -1 do
    begin
      Filho[i].Serialize(lst, oNivel + 1);
    end;
  end;
end;

procedure TAtributoOculto.SetCardinalidade(const Value: integer);
begin
  if (Value > 0) and (Value < 5) then
  begin
    case Value of
      1, 2: FMaxCard := 1;
      else FMaxCard := 21;
    end;
    case Value of
      1, 3: MinCard := 1;
      else MinCard := 0;
    end;
  end;
end;

procedure TAtributoOculto.SetFilhos(const Value: TObjectList);
begin
  FFilhos := Value;
end;

procedure TAtributoOculto.SetIdentificador(const Value: boolean);
begin
  FIdentificador := Value;
end;

procedure TAtributoOculto.SetLeftTop(const Value: TPoint);
begin
  FLeftTop := Value;
end;

procedure TAtributoOculto.SetThisNode(const Value: TTreeNode);
begin
  FThisNode := Value;
end;

procedure TAtributoOculto.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TAtributoOculto.SetPai(const Value: TAtributoOculto);
begin
  FPai := Value;
end;

procedure TAtributoOculto.SetTipo(const Value: String);
begin
  FTipo := Value;
end;

procedure TAtributoOculto.unSerialize(lst: TStringList; oNivel: integer);
  var NV, X, Y, MxCard, MnCard: integer;
      Ident: boolean;
      Tp, Nom: string;

      V: string;
      p: integer;
      Last: TAtributoOculto;
begin
  Last := nil;
  while lst.Count > 0 do
  begin
    V := LST[0];
    p := Pos('|', V);
    NV := StrToInt(Copy(V, 1, p -1));
    Delete(v, 1, p);
    if nv = oNivel then
    begin
      p := Pos('|', V);
      X := StrToInt(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      Y := StrToInt(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      MxCard := StrToInt(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      MnCard := StrToInt(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      Ident := StrToBool(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      Tp := Copy(V, 1, p -1);
      Delete(v, 1, p);

      p := Pos('|', V);
      Nom := Copy(V, 1, p -1);
      Delete(v, 1, p);

      Last := NovoFilho(Nom, Tp, Point(X, Y), Ident, Point(MnCard, MxCard));

      lst.Delete(0);
    end else
    begin
      if nv < oNivel then break else Last.unSerialize(lst, NV);
    end;
  end;
end;

function TAtributoOculto.FindByNode(Node: TTreeNode): TAtributoOculto;
var i: integer;
begin
  Result := nil;
  if Node = ThisNode then Result := Self
  else
  for i:= 0 to Filhos.Count -1 do
  begin
    Result := Filho[i].FindByNode(Node);
    if Assigned(Result) then Break;
  end;
end;

procedure TAtributoOculto.ReSetConjAtt(conj: TConjPAtt);
var i: integer;
begin
  ConjPai := conj;
  for i:= 0 to Filhos.Count -1 do
  begin
    Filho[i].ReSetConjAtt(conj);
  end;
end;

procedure TAtributoOculto.GeraXML(node: IXMLNode);
  var lnode: IXMLNode;
      i: integer;
begin
  node := node.AddChild(copy(ClassName, 2, length(ClassName) -1));
  node.Attributes['Nome'] := Nome;
  lnode := node.AddChild('LeftTop');
  lnode.Attributes['X'] := LeftTop.X;
  lnode.Attributes['Y'] := LeftTop.Y;

  lnode := node.AddChild('MaxCard');
  lnode.Attributes['Valor'] := MaxCard;
  lnode := node.AddChild('MinCard');
  lnode.Attributes['Valor'] := MinCard;

  lnode := node.AddChild('Composto');
  lnode.Attributes['Valor'] := BoolToStr(Composto);
  lnode := node.AddChild('Identificador');
  lnode.Attributes['Valor'] := BoolToStr(Identificador);
  lnode := node.AddChild('Tipo');
  lnode.Attributes['Valor'] := Tipo;

  //Filhos
  if composto then
  begin
    lnode := node.AddChild('Atributos');
    for i := 0 to Filhos.Count -1 do
    begin
      Filho[i].GeraXML(lNode);
    end;
  end;
end;

function TAtributoOculto.LoadByXML(node: IXMLNode): boolean;
  var lnode, tmp: IXMLNode;
      i: integer;

      oNome, oTipo: string;
      oLeftTop: Tpoint;
      Ident: Boolean;
      MaCard: integer;
      MiCard: integer;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      oNome := lnode.Attributes['Nome'];
      tmp := MyParserFindNode(lnode, 'LeftTop');
      oLeftTop := Point(tmp.Attributes['X'], tmp.Attributes['Y']);
//-------------ver comparação por deprecated
      MiCard := 1;
      MaCard := 1;
      if MyParserFindNode(lnode, 'MaxCard') <> nil then
      begin
        MaCard := MyParserFindNode(lnode, 'MaxCard').Attributes['Valor'];
        MiCard := MyParserFindNode(lnode, 'MinCard').Attributes['Valor'];
      end;

      Ident := MyParserFindNode(lnode, 'Identificador').Attributes['Valor'];
      oTipo := MyParserFindNode(lnode, 'Tipo').Attributes['Valor'];
      with NovoFilho(oNome, oTipo, oLeftTop, Ident, Point(MiCard, MaCard)) do
      begin
        if MyParserFindNode(lnode, 'Composto').Attributes['Valor']
          then Result := LoadByXML(MyParserFindNode(lnode, 'Atributos'));
      end;
      if not Result then Break;
    end;
  except
    Result := false;
  end;
end;

procedure TAtributoOculto.getChilds(aLista: TList);
  var i, j, tmp: integer;
begin
  if aLista.Count > 50 then exit;

  if Multivalorado then
  begin
    tmp := MaxCard;
    if tmp = 21 then tmp := 5;
  end else tmp := 1;

  if IgnoreMult then tmp := 1;

  for j := 1 to tmp do
  begin
    if Composto then
    begin
      for i:= 0 to Filhos.Count -1 do
        TAtributoOculto(Filhos[i]).getChilds(aLista);
    end
    else aLista.Add(Self);
  end;
end;

procedure TAtributoOculto.SetMaxCard(const Value: integer);
begin
  if (Value > 0) and (Value < 22) then
  begin
    FMaxCard := Value;
  end;
end;

procedure TAtributoOculto.SetMinCard(const Value: integer);
begin
  if (Value > -1) and (Value < 2) then
  begin
    FMinCard := Value;
  end;
end;

function TAtributoOculto.GetCardinalidade: integer;
begin
  Result := ConvCard;
end;

function TAtributoOculto.ConvCard: integer;
  var n: boolean;
begin
  n := (MaxCard > 1);
  if MinCard = 0 then
  begin
    if n then Result := 4 else Result := 2;
  end else
    if n then Result := 3 else Result := 1;
end;

function TAtributoOculto.CardStr: String;
  var tmp: string;
begin
  if MaxCard = 0 then
  begin
    Result := '';
    exit;
  end;
  if MaxCard > 20 then tmp := 'n' else tmp := IntToStr(MaxCard);
  Result := '(' + IntToStr(MinCard) + ',' + tmp + ')';
end;

{ TConjPAtt }

constructor TConjPAtt.Create(AOwner: TComponent);
begin
  inherited;
  FAtributosOcultos := TObjectList.Create(False);
end;

destructor TConjPAtt.Destroy;
begin
  destruindo := true;
  FAtributosOcultos.OwnsObjects := true;
  FAtributosOcultos.Free;
  inherited;
end;

function TConjPAtt.FindByNode(Node: TTreeNode): TAtributoOculto;
  var i: integer;
begin
  Result := nil;
  for i:= 0 to AtributosOcultos.Count -1 do
  begin
    Result := AtributosOculto[i].FindByNode(Node);
    if Assigned(Result) then Break;
  end;
end;

procedure TConjPAtt.GeraXML(node: IXMLNode);
  var i: integer;
begin
  for i:= 0 to AtributosOcultos.Count -1 do
  begin
    AtributosOculto[i].GeraXML(Node);
  end;
end;

function TConjPAtt.getAtr(index: integer): TAtributoOculto;
begin
  Result := nil;
  if (index > -1) and (index < AtributosOcultos.Count) then Result := TAtributoOculto(FAtributosOcultos[index]);
end;

procedure TConjPAtt.getChilds(aLista: TList);
  var i: integer;
begin
  if aLista.Count > 50 then exit;
  for i:= 0 to AtributosOcultos.Count -1 do
    TAtributoOculto(AtributosOcultos[i]).getChilds(aLista);
end;

function TConjPAtt.get_AOcultos: string;
  var lst: TStringList;
      i: integer;
begin
  if AtributosOcultos.Count = 0 then
  begin
    Result := '';
    exit;
  end;
  lst := TStringList.Create;
  for i:= 0 to AtributosOcultos.Count -1 do
  begin
    AtributosOculto[i].Serialize(lst, 0);
  end;
  Result := lst.Text;
  lst.Free;
end;

procedure TConjPAtt.Load;
  var lst: TStringList;
      NV, X, Y, MxCard, MnCard: integer;
      Ident: boolean;
      Tp, Nom: string;

      V: string;
      p: integer;
      Last: TAtributoOculto;
begin
  if F_APcultos = '' then Exit;

  lst := TStringList.Create;
  lst.Text := F_APcultos;
  F_APcultos := '';
  Last := nil;
  while lst.Count > 0 do
  begin
    V := LST[0];
    p := Pos('|', V);
    NV := StrToInt(Copy(V, 1, p -1));
    Delete(v, 1, p);
    if nv = 0 then
    begin
      p := Pos('|', V);
      X := StrToInt(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      Y := StrToInt(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      MxCard := StrToInt(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      MnCard := StrToInt(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      Ident := StrToBool(Copy(V, 1, p -1));
      Delete(v, 1, p);

      p := Pos('|', V);
      Tp := Copy(V, 1, p -1);
      Delete(v, 1, p);

      p := Pos('|', V);
      Nom := Copy(V, 1, p -1);
      Delete(v, 1, p);

      Last := NovoAtributo(Nom, Tp, Point(X, Y), Ident, Point(MnCard, MxCard));

      lst.Delete(0);
    end else Last.unSerialize(lst, NV);
  end;
  lst.Free;
end;

function TConjPAtt.LoadByXML(node: IXMLNode): boolean;
  var lnode, tmp: IXMLNode;
      i: integer;

      oNome, oTipo: string;
      oLeftTop: Tpoint;
      Ident: Boolean;
      MaCard: integer;
      MiCard: integer;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      oNome := lnode.Attributes['Nome'];
      tmp := MyParserFindNode(lnode, 'LeftTop');
      oLeftTop := Point(tmp.Attributes['X'], tmp.Attributes['Y']);

//-------------ver comparação por deprecated
      MiCard := 1;
      MaCard := 1;
      if MyParserFindNode(lnode, 'MaxCard') <> nil then
      begin
        MaCard := MyParserFindNode(lnode, 'MaxCard').Attributes['Valor'];
        MiCard := MyParserFindNode(lnode, 'MinCard').Attributes['Valor'];
      end;

      Ident := MyParserFindNode(lnode, 'Identificador').Attributes['Valor'];
      oTipo := MyParserFindNode(lnode, 'Tipo').Attributes['Valor'];
      with NovoAtributo(oNome, oTipo, oLeftTop, Ident, Point(MiCard, MaCard)) do
      begin
        if MyParserFindNode(lnode, 'Composto').Attributes['Valor']
          then Result := LoadByXML(MyParserFindNode(lnode, 'Atributos'));
      end;
      if not Result then Break;
    end;
  except
    Result := false;
  end;
end;

function TConjPAtt.NovoAtributo(oNome, oTipo: string; oLeftTop: Tpoint;
  Ident: Boolean; Card: TPoint): TAtributoOculto;
begin
  Result := TAtributoOculto.Create(self);
  with Result do
  begin
    LeftTop := oLeftTop;
    Identificador := Ident;
    MaxCard := Card.Y;
    MinCard := Card.X;
    Nome := oNome;
    Tipo := oTipo;
    ConjPai := Self;
  end;
  AtributosOcultos.Add(Result);
end;

procedure TConjPAtt.Popule(Tree: TTreeView; Node: TTreeNode);
  var  i: integer;
       oNode: TTreeNode;
begin
//  Tree.Items.Clear;
  if AtributosOcultos.Count = 0 then exit;
  oNode := Tree.Items.AddChildFirst(Node, 'Atributos:');
  for i:= 0 to AtributosOcultos.Count -1 do AtributosOculto[i].Popule(Tree, oNode);
end;

procedure TConjPAtt.ReSetConjAtt(conj: TConjPAtt);
  var i: integer;
begin
  for i:= 0 to FAtributosOcultos.Count -1 do
  begin
    AtributosOculto[i].ReSetConjAtt(conj);
  end;
end;

procedure TConjPAtt.SetAtributosOcultos(const Value: TObjectList);
begin
  FAtributosOcultos := Value;
end;

end.
