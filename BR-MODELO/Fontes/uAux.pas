unit uAux;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Dialogs,
  ExtCtrls, Forms, Contnrs, StdCtrls, comCtrls, XMLIntf, ActnList;

  const
    //MER
    VersaoAtual = '2.0.0';
    CM_BASECLICK = CM_BASE + 609;
    CM_BASEMOVE = CM_BASE + 610;
    CM_DELLINHA = CM_BASE + 611;
    CM_BASEEXECSEL = CM_BASE + 612;
    CM_CARDCHANGE = CM_BASE + 613;
    CM_TABELAORDER = CM_BASE + 614;
    OrientacaoV = 0;
    OrientacaoH = 1;
    OrientacaoD = 2;
    OrientacaoE = 3;
    TextoTipoHint = 1;
    TextoTipoBranco = 0;
    TextoTipoBox = 2;

    TextoAlinEsq = 0;
    TextoAlinDir = 2;
    TextoAlinCen = 1;

    EspRestrita = 0; //Tipo de especialização restrita
    EspOpicional = 1;
    POSI_ACIMA = 1;
    POSI_ABAIXO = 2;

    Tool_Nothing = 0;
    Tool_Entidade = 1;
    Tool_Relacionamento = 2;
    Tool_EntidadeAssoss = 3;
    Tool_Atributo = 4;
      Tool_AtributoComp = 41;
      Tool_AtributoMult = 42;
      Tool_AtributoOpc = 43;
      Tool_AtributoID = 44;
    Tool_Especializacao = 5;
    Tool_Texto = 6;
    Tool_TextoII = 61;
    Tool_Ligacao = 7;
    Tool_Ligacao2 = 10;
    Tool_AutoRel = 8;
    Tool_Del = 9;
    Tool_EspecializacaoA = 11;
    Tool_EspecializacaoB = 12;
    Tool_LOGICO_Relacao = 13;
    Tool_LOGICO_Relacao2 = 19;
    Tool_LOGICO_campo = 14;
    Tool_LOGICO_Tabela = 15;
    Tool_LOGICO_Separador = 18;

    Tool_LOGICO_FK = 16;
    Tool_LOGICO_K = 17;

    Tool_Trabalho_Campo = 20;
    tpModeloConceitual = 0;
    tpModeloLogico = 1;
    tpModeloNormatizado = 2;
    tpModeloFisico = 3;
    tpStrModeloConceitual = 'CONCEITUAL';
    tpStrModeloLogico = 'LÓGICO';
    tpStrModeloNormatizado = 'NORMATIZADO';
    tpStrModeloFisico = 'FÍSICO';

    aCardinalidade: array [1..4] of String[5] = ('(1,1)', '(0,1)', '(1,n)', '(0,n)');

    //TEMPLATE: Grupos
    fisicoCAMPOS = 'CAMPOS';
    fisicoTIPOS ='TIPOS';
    fisicoCOMPLEMENTO_CAMPOS = 'COMPLEMENTO CAMPOS';
    fisicoCOMPLEMENTO_TABELAS = 'COMPLEMENTO TABELAS';
    fisicoTpCamposNome = 0;
    fisicoTpCamposTipo = 1;
    fisicoTpCamposCoplemento = 2;
    fisicoTpTabelaCoplemento = 3;

    //APP
    tipo_multiplos = 0;
    tipo_simples = 1;
    tipo_booleano = 2;
    tipo_leitura = 3;

    Livro = 'Prof. Carlos Alberto Heuser' + #13 + '4ª Edição - Série Livros Didáticos - UFRJ';
    aj_Especializacao = 1;
    aj_Relacionamento = 2;
    aj_nothing = 0;
    //Imagens:
    Img_Key = 44;
    Img_FKey = 46;
    Img_KeyAndFKey = 45;

    //DDL Físico
    tpNO_ACTION = 0;
    tpRESTRICT = 1;
    tpSET_NULL = 2;
    tpSET_DEFAULT = 3;
    tpCASCADE = 4;


  Type
    TConjunto = set of 1..30;
    LAttr = Record
      Nome, Tipo: String;
      Identificador, Multivalorado, Composto: boolean;
      Max, Min: integer;
    end;

    TGeralItem = class
    Private
      FTexto: String;
      Findex: integer;
      FTag: Integer;
      FReferencia: TComponent;
      procedure SetTexto(const Value: String);
      procedure Setindex(const Value: integer);
      procedure SetTag(const Value: integer);
      procedure SetReferencia(const Value: TComponent);
    Public
      property Texto: String read FTexto write SetTexto;
      property Index: integer read Findex write Setindex;
      property Tag: Integer read FTag write SetTag;
      Property Referencia: TComponent read FReferencia write SetReferencia;
    end;

    TGeralList = class(TComponent)
    Private
      FLista: TObjectList;
      function getItem(index: integer): TGeralItem;
      procedure SetLista(const Value: TObjectList);
    Public
      property Lista: TObjectList read FLista write SetLista;
      procedure Ordene;
      property Item[Index: integer]: TGeralItem read getItem;default;
      Function Add(lTexto: string; lTag, lIndex: Integer; aRef: TComponent = nil): TGeralItem;
      Function FindByIndex(Index: integer): TGeralItem;
      constructor Create(Aowner: TComponent);override;
      destructor Destroy;override;
    end;

    TTabImg = class(TPaintBox)
    private
      FTabs: TStringList;
      FTabIndex, TabWidth: integer;
      FOnTabClick: TNotifyEvent;
      FTabDisabled: TConjunto;
      function GetQtdTabs: integer;
      procedure SetTabIndex(const Value: integer);
      procedure SetTabs(const Value: TStringList);
      procedure SetOnTabClick(const Value: TNotifyEvent);
      procedure SetTabDisabled(const Value: TConjunto);
    protected
      Procedure Paint; override;
      Procedure Click; override;
    Public
      Property TabDisabled: TConjunto read FTabDisabled write SetTabDisabled;
      Property TabIndex: integer read FTabIndex write SetTabIndex;
      Property QtdTads: integer read GetQtdTabs;
      Property Tabs: TStringList read FTabs write SetTabs;
      constructor Create(Aowner: TComponent);override;
      Destructor Destroy;override;
      Procedure Realinhe;
      Property OnTabClick: TNotifyEvent read FOnTabClick write SetOnTabClick;
    end;

    TWriterMsg = class(TComponent)
    public
      Writer: TRichEdit;
      procedure write(Texto: string; emVermelho: boolean = false; negrito: boolean = false);
    end;

    // TCC II - Puc (MG) - Daive Simões
    // classe que encapsula os tipos de dados disponíveis na aplicação para
    // criação de atributos
    TTiposDados = class
    private
      // campos privados da classe
      FCarregado  : Boolean;
      FNoTipos    : IXMLNode;
      FTipo       : string;
      FListaTipos : TStringList;

      // métodos de get e set das propriedades da classe
      function FGetCarregado: Boolean;
      function FGetTipo(iIndex: Integer): string;
      function FGetTotal    : integer;

    public
      // construtor e destrutor da classe
      constructor Create(nodePrincipal: IXMLNodeList);
      destructor Destroy; override;

      // métodos públicos da classe
      procedure Carregar;

      // propriedades públicas da classe
      property Carregado            : Boolean read FGetCarregado;
      property Tipo[iIndex: Integer]: string  read FGetTipo;
      property Total                : integer read FGetTotal;
    end;  // TTiposDados
    // Fim TCC II

    TConfigura = class(TComponent)
    private
      FTempo: word;
      FAjuda: string;
      procedure SetAjuda(const Value: string);
      procedure SetTempo(const Value: word);
    public
      Arq : array [1..5] of string;

      // TCC II - Puc (MG) - Daive Simões
      // Lista de tipos disponíveis para seleção de atributos
      TiposDados : TTiposDados;

      // Pasta de salvamento de arquivos do modelo logico
      dirFisico  : string;
      // Fim TCC II

      Menu : array [1..5] of TAction;
      dirLogico, dirConceitual, cfgFile, appDir: String;
      showLHint, ExibirLog: boolean;
      property Tempo: word read FTempo write SetTempo;
      Procedure LoadFromXML(nodePricipal: IXMLNodeList);
      Procedure SaveToXml(nodePrincipal: IXMLNodeList);
      Procedure refreshArq;
      Property Ajuda: string read FAjuda write SetAjuda;
    end;

  Function isInteger(S: string): boolean;
  Function conta13(str: string): integer;
  function MyParserFindNode(Pai: IXMLNode; tag: string; recursivo: boolean = false): IXMLNode;
  Function Denominar(nomeClasse: String): String;
  Function ControlaCaption(Canvas: TCanvas; W: integer; Texto: string): String;
  Function GetNodeValue(Node: IXMLNode; tag: string): string;
  Function DDLActionToStr(vl: Integer): string;

implementation

uses Math, Types;

// Início TCC II - Puc (MG) - Daive Simões
// construtor padrão da classe
constructor TTiposDados.Create(nodePrincipal: IXMLNodeList);
begin
  inherited Create;

  // inicializa os campos da classe
  FCarregado  := False;
  FNoTipos    := nodePrincipal[0];
  FTipo       := EmptyStr;
  FListaTipos := TStringList.Create;
end;

// encapsulamento de leitura da propriedade "Tipo"
function TTiposDados.FGetTipo(iIndex: Integer): string;
begin
  Result := FListaTipos[iIndex];
end;

// encapsulamento de leitura da propriedade "Total"
function TTiposDados.FGetTotal: integer;
begin
  Result := FListaTipos.Count;
end;

// encapsulamento de leitura da propriedade "Carregado"
function TTiposDados.FGetCarregado: Boolean;
begin
  Result := FCarregado;
end;

// método responsável por carregar os tipos de dados disponíveis no arquivo de
// configuração
procedure TTiposDados.Carregar;
var xmlNode: IXMLNode;
    oNode  : IXMLNode;
    iIndex : Integer;
begin
  xmlNode := MyParserFindNode(FNoTipos, 'Tipos');

  // itera pela lista de tipos do arquivo de configuração carregando-as na
  // lista interna na classe
  iIndex := 1;
  oNode  := MyParserFindNode(xmlNode, 'Tipo0' + IntToStr(iIndex));
  while (oNode <> nil) do begin
    // insere o tipo corrente na lista
    FListaTipos.Add(oNode.Attributes['Valor']);

    // próximo tipo da lista
    Inc(iIndex);
    oNode  := MyParserFindNode(xmlNode, 'Tipo0' + IntToStr(iIndex));
  end;  // while (oNode <> nil) do

  // seta a flag de sinalização do carregamento dos tipos
  FCarregado := (FListaTipos.Count > 0);
end;

// destrutor da classe
destructor TTiposDados.Destroy;
begin
  // destrói a lista de tipos
  FListaTipos.Clear;
  FreeAndNil(FListaTipos);

  // destroy da super-classe
  inherited Destroy;
end;

// Fim TCC II
function DDLActionToStr(vl: Integer): string;
begin
  case vl of
    tpNO_ACTION : Result := 'NO ACTION';
    tpRESTRICT : Result := 'RESTRICT';
    tpSET_NULL : Result := 'SET NULL';
    tpSET_DEFAULT : Result := 'SET DEFAULT';
    else result := 'CASCADE'; //tpCASCADE
  end;
end;

Function GetNodeValue(Node: IXMLNode; tag: string): string;
  var res: OleVariant;
begin
  res := MyParserFindNode(Node, tag).NodeValue;
  if res <> Null then Result := res else Result := '';
end;

Function ControlaCaption(Canvas: TCanvas; W: integer; Texto: string): String;
var tmp : integer;
begin
  Result := Texto;
  if Canvas.TextWidth(Result) <= W then exit;
  tmp := Canvas.TextWidth('...');
  Result := copy(Result, 1, length(Result) -4);
  while (Canvas.TextWidth(Result) + tmp) > W do
  begin
    Result := copy(Result, 1, length(Result) -1);
    if Result = '' then break;
  end;
  Result := Result + '...';
end;

Function Denominar(nomeClasse: String): String;
begin
  Result := '';
  if nomeClasse = 'TAtributo' then Result := 'Atributo';
  if nomeClasse = 'TAutoRelacao' then Result := 'Auto relacionamento';
  if nomeClasse = 'TEntidadeAssoss' then Result := 'Entidade associativa';
  if nomeClasse = 'TEntidade' then Result := 'Entidade';
  if nomeClasse = 'TEspecializacao' then Result := 'Especialização';
  if nomeClasse = 'TTexto' then Result := 'Observação';
  if nomeClasse = 'TRelacao' then Result := 'Relação';
  if nomeClasse = 'TCardinalidade' then Result := 'Cardinalidade';
  if nomeClasse = 'TCampo' then Result := 'Campo';
  if nomeClasse = 'TTabela' then Result := 'Tabela';
  if nomeClasse = 'TLigaTabela' then Result := 'Relacionamento';
end;

function MyParserFindNode(Pai: IXMLNode; tag: string; recursivo: boolean): IXMLNode;
  var i: integer;
      node: IXMLNode;
begin
//  Result := Pai.ChildNodes.FindNode(tag); Mais rápido
  Result := nil;
  for i := 0 to Pai.ChildNodes.Count -1 do
  begin
    node := Pai.ChildNodes[i];
    if node.LocalName = tag then
    begin
      Result := node;
      Break;
    end
    else if recursivo and (node.ChildNodes.Count > 0) then
    begin
      Result := MyParserFindNode(node, tag);
      if Result <> nil then Break;
    end;
  end;
end;

Function conta13(str: string): integer;
  var j: integer;
begin
  Result := 1;
  StringReplace(str, #13#10, #13, [rfReplaceAll]);
  StringReplace(str, #10, #13, [rfReplaceAll]);
  while (pos(#13, Str) > 0) do
  begin
    J := pos(#13, Str);
    Inc(Result);
    Str := Copy(Str, J + 1, length(Str) - J);
  end;
end;

Function isInteger(S: string): boolean;
  var i: Integer;
begin
  Result := True;
  for i := 1 to Length(S) do
  begin
    if not (s[i] in ['0'..'9']) then
    begin
      Result := false;
      Break;
    end;
  end;
end;

{ TTabImg }

procedure TTabImg.Click;
  var ini, j: integer;
  P: array [1..4] of TPoint;
  M: TPoint;
begin
  if FTabs.Count = 0 then exit;
  M := ScreenToClient(Mouse.CursorPos);
  ini := Width - Height -TabWidth;
  for j := FTabs.Count -1 downto 0 do
  begin
    P[1] := Point(ini, 0);
    P[2] := Point(ini + TabWidth - (Height div 2), 0);
    P[3] := Point(ini + TabWidth + (Height div 2), Height-1);
    P[4] := Point(ini, Height-1);
    if PtInRegion(CreatePolygonRgn(P, 4, WINDING), M.X, M.Y) then
    begin
      if j in TabDisabled then break;
      TabIndex := j;
      If Assigned(FOnTabClick) then FOnTabClick(Self);
      break;
    end;
    ini := ini - TabWidth;
  end;
  inherited;
end;

constructor TTabImg.Create(Aowner: TComponent);
begin
  inherited;
  FTabs := TStringList.Create;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clBtnFace;
  Font.Style := [fsBold];
  TabIndex := -1;
end;

destructor TTabImg.Destroy;
begin
  FTabs.Free;
  inherited;
end;

function TTabImg.GetQtdTabs: integer;
begin
  Result := FTabIndex;
end;

procedure TTabImg.Paint;
  var ini, j, iniSel, tmp: integer;
  P: array [1..4] of TPoint;
  Function TextoToTam(texto: string; tamanho: integer):String;
  begin
    while Canvas.TextWidth(texto) > tamanho do
    begin
      texto := copy(texto, 1, length(texto) -1);
      if texto = '' then Break;
    end;
    Result := texto;
  end;
begin
  inherited;
  //no futuro, se preciso, tratar a opção enabled.

  if FTabs.Count = 0 then exit;
  TabWidth := ((Width -Height -4) div FTabs.Count);
  ini := Width - Height -TabWidth;
  iniSel := -1;
  tmp := Height div 2;
  for j := FTabs.Count -1 downto 0 do
    with canvas do
  begin
    P[1] := Point(ini, 0);
    P[2] := Point(ini + TabWidth - tmp, 0);
    P[3] := Point(ini + TabWidth + tmp, Height-1);
    P[4] := Point(ini, Height-1);
    if j = TabIndex then iniSel := ini
    else begin
      Polygon(P);
      if (j in TabDisabled) then Font.Color := clBtnShadow else Font.Color := clBlack;
      TextOut(ini + 4, (Height - TextHeight('H')) div 2, TextoToTam(FTabs[j], TabWidth -Height));
    end;
    ini := ini - TabWidth;
  end;
  if (TabIndex in TabDisabled) then Canvas.Font.Color := clBtnShadow else Canvas.Font.Color := clBlack;
  if iniSel > -1 then
  begin
    ini := iniSel;
    P[1] := Point(ini, 0);
    P[2] := Point(ini + TabWidth - tmp, 0);
    P[3] := Point(ini + TabWidth + tmp, Height -1);
    P[4] := Point(ini, Height -1);
    with Canvas do
    begin
      MoveTo(0, Height -1);
      LineTo(Width, Height -1);
      Polygon(P);
      TextOut(ini + 4, (Height - TextHeight('H')) div 2, TextoToTam(FTabs[TabIndex], TabWidth -Height));
      Pen.Color := Color;
      MoveTo(ini + 1, Height -1);
      LineTo(ini + tabWidth + tmp, Height -1);
      Pen.Color := clBlack;
    end;
  end;
end;

procedure TTabImg.Realinhe;
begin
  if Assigned(Parent) then
  begin
    SetBounds(0, 3, Parent.Width, Parent.Height - 7);
  end;
end;

procedure TTabImg.SetOnTabClick(const Value: TNotifyEvent);
begin
  FOnTabClick := Value;
end;

procedure TTabImg.SetTabDisabled(const Value: TConjunto);
begin
  FTabDisabled := Value;
  Invalidate;
end;

procedure TTabImg.SetTabIndex(const Value: integer);
begin
  if Value > FTabs.Count -1 then Exit;
  FTabIndex := Value;
  Invalidate;
end;

procedure TTabImg.SetTabs(const Value: TStringList);
begin
  FTabs := Value;
end;

{ TGeralItem }

procedure TGeralItem.SetTag(const Value: integer);
begin
  FTag := Value;
end;

procedure TGeralItem.Setindex(const Value: integer);
begin
  Findex := Value;
end;

procedure TGeralItem.SetTexto(const Value: String);
begin
  FTexto := Value;
end;

{ TGeralListItem }

function TGeralList.Add(lTexto: string; lTag, lIndex: Integer; aRef: TComponent): TGeralItem;
  var it: TGeralItem;
begin
  it := TGeralItem.Create;
  with it do
  begin
    Texto := lTexto;
    index := lIndex;
    Tag := lTag;
    Referencia := aRef;
  end;
  FLista.Add(it);
  Result := it;
end;

constructor TGeralList.Create(Aowner: TComponent);
begin
  inherited;
  FLista := TObjectList.Create(true);
end;

destructor TGeralList.Destroy;
begin
  FLista.Free;
  inherited;
end;

function TGeralList.FindByIndex(Index: integer): TGeralItem;
  var i: integer;
begin
  Result := nil;
  for i := 0 to Lista.Count -1 do
  begin
    if TGeralItem(Lista[i]).index = Index then
    begin
      Result := TGeralItem(Lista[i]);
      break;
    end;
  end;
end;

function TGeralList.getItem(index: integer): TGeralItem;
begin
  Result := nil;
  if (index > -1) and (index < Lista.Count) then Result := TGeralItem(Lista[index]);
end;

procedure TGeralList.Ordene;
  var i, ini: integer;
  P1, P2, Menor: TGeralItem;
begin
  ini := 0;
  while ini < FLista.Count -1 do
  begin
    P1 := TGeralItem(FLista[ini]);
    Menor := P1;
    For i := ini + 1 to (FLista.Count -1) do
    begin
      P2 := TGeralItem(FLista[i]);
      if Menor.Texto > P2.Texto then Menor := P2;
    end;
    if Menor <> P1 then FLista.Exchange(FLista.IndexOf(Menor), ini);
    inc(ini);
  end;
end;

procedure TGeralList.SetLista(const Value: TObjectList);
begin
  FLista := Value;
end;

procedure TGeralItem.SetReferencia(const Value: TComponent);
begin
  FReferencia := Value;
end;

{ TWriterMsg }

procedure TWriterMsg.write(Texto: string; emVermelho, negrito: boolean);
begin
  Writer.SelAttributes.Color := clBlack;
  if negrito then Writer.SelAttributes.Style := [FsBold];
  Writer.Lines.Add(FormatDateTime('hh:mm:ss', Now) + ' - ' + Texto);
  if emVermelho then
  begin
    Writer.SelStart := Length(Writer.Text) - Length(Texto) -2;
    Writer.SelLength := Length(Texto);
    Writer.SelAttributes.Color := clRed;
  end;
  with Writer do
  begin
    SelStart := Length(Text);
    Perform(EM_SCROLLCARET, 0, 0);
  end;
end;

{ TConfigura }

procedure TConfigura.LoadFromXML(nodePricipal: IXMLNodeList);
  var node, lNode, oNode: IXMLNode;
  i: integer;
begin
  try
    node := nodePricipal[0];
    try
      lNode := MyParserFindNode(node, 'Arquivos');
      for i := 1 to 5 do
      begin
        oNode := MyParserFindNode(lNode, 'Arq0' + IntToStr(I));
        if oNode <> nil then Arq[i] := oNode.Attributes['Valor'] else Arq[i] := '';
      end;
      lNode         := MyParserFindNode(node, 'Configuracoes');
      dirLogico     := MyParserFindNode(lNode, 'dirLogico'    ).Attributes['Valor'];
      dirConceitual := MyParserFindNode(lNode, 'dirConceitual').Attributes['Valor'];

      // Inicio TCC II
      // carrega o diretório de modelos fisicos
      dirFisico     := MyParserFindNode(lNode, 'dirFisico'    ).Attributes['Valor'];
      // Fim TCC II

      showLHint     := MyParserFindNode(lNode, 'showLHint').Attributes['Valor'];
      Tempo         := MyParserFindNode(lNode, 'Tempo').Attributes['Valor'];
      if MyParserFindNode(lNode, 'ExibirLog') <> nil then
        ExibirLog := MyParserFindNode(lNode, 'ExibirLog').Attributes['Valor'];

      // Início TCC II - Puc (MG) - Daive Simões
      // instancia e carrega os tipos de dados
      TiposDados := TTiposDados.Create(nodePricipal);
      TiposDados.Carregar;
      // Fim TCC II

    except
      for i := 1 to 5 do
      begin
        Arq[i] := '';
      end;
      dirLogico := ExtractFilePath(ParamStr(0));
      dirConceitual := dirLogico;
      Tempo := 5;
      Application.MessageBox('Erro ao carregar as configurações', 'Erro: Configurações', mb_Ok or MB_ICONERROR);
    end;

    //Ajuda.
    try
      node := nodePricipal[1];
      lNode := MyParserFindNode(node, 'Flash');
      if lNode.NodeValue <> Null then Ajuda := lNode.NodeValue;
    except
    end;
  except
    Application.MessageBox('Erro ao carregar as configurações', 'Erro: Configurações', mb_Ok or MB_ICONERROR);
  end;
end;

procedure TConfigura.refreshArq;
  var i: integer;
begin
for i:= 1 to 5 do
  begin
    Menu[i].Hint := arq[i];
    Menu[i].Caption := ExtractFileName(arq[i]);
    Menu[i].Visible := arq[i] <> '';
  end;
end;

procedure TConfigura.SaveToXml(nodePrincipal: IXMLNodeList);
  var node, lNode, oNode: IXMLNode;
    i: integer;
begin
  node := nodePrincipal[0];
  lNode := node.AddChild('Configuracoes');
  oNode := lNode.AddChild('dirLogico');
  oNode.Attributes['Valor'] := dirLogico;
  oNode := lNode.AddChild('dirConceitual');
  oNode.Attributes['Valor'] := dirConceitual;

  // Inicio TCC II
  // grava no arquivo de configurações o nome do diretório de modelos físicos
  oNode := lNode.AddChild('dirFisico');
  oNode.Attributes['Valor'] := dirFisico;
  // Fim TCC II

  oNode := lNode.AddChild('showLHint');
  oNode.Attributes['Valor'] := showLHint;
  oNode := lNode.AddChild('Tempo');
  oNode.Attributes['Valor'] := Tempo;

  oNode := lNode.AddChild('ExibirLog');
  oNode.Attributes['Valor'] := ExibirLog;

  lNode := node.AddChild('Arquivos');
  for i := 1 to 5 do
  begin
    oNode := lNode.AddChild('Arq0' + IntToStr(i));
    oNode.Attributes['Valor'] := Arq[i];
  end;

  // Início TCC II - Puc (MG) - Daive Simões
  // escreve os tipos de volta ao arquivo de configurações
  lNode := node.AddChild('Tipos');
  for i := 0 to Pred(TiposDados.Total) do begin
    oNode := lNode.AddChild('Tipo0' + IntToStr(i + 1));
    oNode.Attributes['Valor'] := TiposDados.Tipo[i]
  end;  // for i := 0 to Pred(TiposDados.Total) do
  // Fim TCC II

  node := nodePrincipal[1];
  lNode := node.AddChild('Flash');
  lNode.NodeValue := Ajuda;
end;

procedure TConfigura.SetAjuda(const Value: string);
begin
  FAjuda := Value;
end;

procedure TConfigura.SetTempo(const Value: word);
begin
  FTempo := Value;
end;

end.
