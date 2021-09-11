unit uTemplate;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,  XMLIntf, XMLDoc, Contnrs;

type
  TEstatusITemplate = (EITNothing, EITNormal, EITNormalOffModelo, EITJustModelo);

  TMngTemplateItem = class(TComponent)
  private
    FEstatus: TEstatusITemplate;
    FCampo2: string;
    FCampo1: string;
    FGrupo: string;
    procedure SetCampo1(const Value: string);
    procedure SetCampo2(const Value: string);
    procedure SetGrupo(const Value: string);
    procedure SetEstatus(const Value: TEstatusITemplate);
  public
    constructor Create(AOwner: TComponent); override;
    procedure to_xml(oNode: IXMLNode);
    procedure LoadFromXML(oNode: IXMLNode);
  published
    property Campo1: string read FCampo1 write SetCampo1;
    property Campo2: string read FCampo2 write SetCampo2;
    property Grupo: string read FGrupo write SetGrupo;
    property Estatus: TEstatusITemplate read FEstatus write SetEstatus;
  end;

  TMngTemplate = class(TComponent)
  private
    FArq: string;
    FDXML: TXMLDocument;
    FddlCTab_A: string;
    FddlCCamp: string;
    FddlCTab_Compl: string;
    FddlCConst_Nome: string;
    FddlConst_Nomear: boolean;
    FddlCTab_B: string;
    FddlCTab_C: string;
    FddlPk_inTab: boolean;
    FddlFk_inTab: boolean;
    FddlSeparador: string;
    procedure SetddlSeparador(const Value: string);
    procedure SetddlFk_inTab(const Value: boolean);
    procedure SetddlPk_inTab(const Value: boolean);
    procedure SetddlCCamp(const Value: string);
    procedure SetddlCConst_Nome(const Value: string);
    procedure SetddlConst_Nomear(const Value: boolean);
    procedure SetddlCTab_A(const Value: string);
    procedure SetddlCTab_B(const Value: string);
    procedure SetddlCTab_C(const Value: string);
    procedure SetddlCTab_Compl(const Value: string);
    function getItem(index: Integer): TMngTemplateItem;
    procedure SetDXML(const Value: TXMLDocument);
    procedure SetArq(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    property Arq: string read FArq write SetArq;
    Function LoadFromXML(oArq: string = ''): string;overload;
    Function LoadFromXML(Node: IXMLNode): boolean;overload;
    Function SalveToXML(oArq: string = ''): boolean;overload;
    Function SalveToXML(Node: IXMLNode): boolean;overload;
    property DXML: TXMLDocument read FDXML write SetDXML;
    property Item[index: Integer]: TMngTemplateItem read getItem; default;
    Function Add(oCampo1, oCampo2, oGrupo: string): TMngTemplateItem;
    Procedure GeraLista(Lst: TStringList; tp: Integer);
    Procedure GeraNotInTemplate(Lst: TStringList; tp: Integer);
    Function ExisteCampo(oCampo, oGrupo: string): boolean;
    Function FindCampo(oCampo, oGrupo: string): TMngTemplateItem;
    procedure Read(Reader: TReader);
    procedure Write(Writer: TWriter);
    Procedure ApureToConvert;
    Procedure RessetToNormal;
    //DDL
    property ddlCTab_A: string read FddlCTab_A write SetddlCTab_A;
    property ddlCTab_B: string read FddlCTab_B write SetddlCTab_B;
    property ddlCTab_Compl: string read FddlCTab_Compl write SetddlCTab_Compl;
    property ddlCTab_C: string read FddlCTab_C write SetddlCTab_C;
    property ddlCCamp: string read FddlCCamp write SetddlCCamp;
    property ddlPk_inTab: boolean read FddlPk_inTab write SetddlPk_inTab;
    property ddlFk_inTab: boolean read FddlFk_inTab write SetddlFk_inTab;
    property ddlConst_Nomear: boolean read FddlConst_Nomear write SetddlConst_Nomear;
    property ddlCConst_Nome: string read FddlCConst_Nome write SetddlCConst_Nome;
    property ddlSeparador: string read FddlSeparador write SetddlSeparador;
  end;

implementation

uses uAux, uDM;

{ TMngTemplateItem }

constructor TMngTemplateItem.Create(AOwner: TComponent);
begin
  inherited;
//  SetSubComponent(true);
end;

procedure TMngTemplateItem.LoadFromXML(oNode: IXMLNode);
  function pegaValor(oCampo: string): string;
  begin
    Result := GetNodeValue(oNode, oCampo);
  end;
begin
  Campo1 := pegaValor('Campo1');
  Campo2 := pegaValor('Campo2');
end;

procedure TMngTemplateItem.SetCampo1(const Value: string);
begin
  FCampo1 := Value;
end;

procedure TMngTemplateItem.SetCampo2(const Value: string);
begin
  FCampo2 := Value;
end;

procedure TMngTemplateItem.SetEstatus(const Value: TEstatusITemplate);
begin
  FEstatus := Value;
end;

procedure TMngTemplateItem.SetGrupo(const Value: string);
begin
  FGrupo := Value;
end;

procedure TMngTemplateItem.to_xml(oNode: IXMLNode);
 var lnode: IXMLNode;
begin
  lnode := oNode.AddChild('Campo1');
  lnode.NodeValue := campo1;
  lnode := oNode.AddChild('Campo2');
  lnode.NodeValue := campo2;
//  lnode := oNode.AddChild('Grupo');
//  lnode.NodeValue := Grupo;
end;

{ TMngTemplate }

function TMngTemplate.Add(oCampo1, oCampo2,
  oGrupo: string): TMngTemplateItem;
  var tmpItem: TMngTemplateItem;
begin
  tmpItem := TMngTemplateItem.Create(Self);
  tmpItem.Campo1 := oCampo1;
  tmpItem.Campo2 := oCampo2;
  tmpItem.Grupo := oGrupo;
  Result := tmpItem;
end;

procedure TMngTemplate.ApureToConvert;
  var I: Integer;
      tmpItem: TMngTemplateItem;
      LstT, LstCC, LstCT :TStringList;
  Procedure altera(Lst: TStringList; IT: TMngTemplateItem);
  begin
    if Lst.IndexOf(IT.Campo1) = -1 then
      IT.Estatus := EITNormalOffModelo
        else Lst.Delete(Lst.IndexOf(IT.Campo1));
  end;
  procedure novos(Lst: TStringList; grp: string);
    var i: integer;
  begin
    for I := 0 to Lst.Count - 1 do
    begin
      if (Trim(Lst[i]) = '') then Continue;
      tmpItem := Add(Lst[i],Lst[i],grp);
      tmpItem.Estatus := EITJustModelo;
    end;
  end;
begin
  LstT := TStringList.Create;
  LstCC := TStringList.Create;
  LstCT := TStringList.Create;
  brDM.Visual.Modelo.GeraLista(LstT, fisicoTpCamposTipo);
  brDM.Visual.Modelo.GeraLista(LstCC, fisicoTpCamposCoplemento);
  brDM.Visual.Modelo.GeraLista(LstCT, fisicoTpTabelaCoplemento);
  for I := 0 to ComponentCount - 1 do
  begin
    tmpItem := TMngTemplateItem(Components[i]);
    tmpItem.Estatus := EITNormal;
    if (tmpItem.Grupo = fisicoTIPOS) then altera(LstT, tmpItem);
    if (tmpItem.Grupo = fisicoCOMPLEMENTO_CAMPOS) then altera(LstCC, tmpItem);
    if (tmpItem.Grupo = fisicoCOMPLEMENTO_TABELAS) then altera(LstCT, tmpItem);
  end;
  novos(LstT, fisicoTIPOS);
  novos(LstCC, fisicoCOMPLEMENTO_CAMPOS);
  novos(LstCT, fisicoCOMPLEMENTO_TABELAS);
  LstT.Free;
  LstCC.Free;
  LstCT.Free;
end;

constructor TMngTemplate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FddlCTab_A := 'CREATE TABLE *$nome_tabela';
  FddlCTab_B := ' (';
  FddlCTab_Compl := '*$compl_tabela';
  FddlCTab_C := ')*$separador*$\n';
  FddlCCamp := '*$nome_campo *$tipo_campo *$compl_campo';
  FddlCConst_Nome := '*$nome_tabela_*$envol_campo';
  FddlConst_Nomear := false;
  FddlPk_inTab := true;
  FddlFk_inTab := true;
  FddlSeparador := '';
end;

function TMngTemplate.ExisteCampo(oCampo, oGrupo: string): boolean;
  var I: Integer;
begin
  Result := false;
  for I := 0 to ComponentCount - 1 do
  begin
    if (Item[i].Grupo = oGrupo) then
      if Item[i].Campo1 = oCampo then
    begin
      Result := true;
      break;
    end;
  end;
end;

function TMngTemplate.FindCampo(oCampo, oGrupo: string): TMngTemplateItem;
  var I: Integer;
begin
  Result := nil;
  for I := 0 to ComponentCount - 1 do
  begin
    if (Item[i].Grupo = oGrupo) then
      if Item[i].Campo1 = oCampo then
    begin
      Result := Item[i];
      break;
    end;
  end;
end;

procedure TMngTemplate.GeraLista(Lst: TStringList; tp: Integer);
  var I: Integer;
      tmpItem: TMngTemplateItem;
//      tmpLst: TStringList;
      //tmp,
      grp: string;
begin
//  tmpLst := TStringList.Create; //lista em uppercase: evitar repetição.
//  tmpLst.Text := AnsiUpperCase(Lst.Text);
//  for I := 0 to ComponentCount - 1 do
//  begin
//    tmpItem := TMngTemplateItem(Components[i]);
//    if (tmpItem.Grupo = oGrupo) then
//    begin
//      tmp := AnsiUpperCase(tmpItem.Campo1);
//      if tmpLst.IndexOf(tmp) < 0 then
//      begin
//        Lst.Add(tmpItem.Campo1);
//        tmpLst.Add(tmp);
//      end;
//    end;
//  end;
//  tmpLst.Free;
  Lst.Clear;
  Lst.Add('');
  case tp of
    fisicoTpCamposNome: grp := fisicoCAMPOS;
    fisicoTpCamposTipo: grp := fisicoTIPOS;
    fisicoTpCamposCoplemento: grp := fisicoCOMPLEMENTO_CAMPOS;
    fisicoTpTabelaCoplemento: grp := fisicoCOMPLEMENTO_TABELAS;
  end;
  brDM.Visual.Modelo.GeraLista(Lst, tp);
  for I := 0 to ComponentCount - 1 do
  begin
    tmpItem := TMngTemplateItem(Components[i]);
    if (tmpItem.Grupo = grp) then
    begin
      if Lst.IndexOf(tmpItem.Campo1) = -1 then
      begin
        Lst.Add(tmpItem.Campo1);
      end;
    end;
  end;
  Lst.Sort;
end;

procedure TMngTemplate.GeraNotInTemplate(Lst: TStringList; tp: Integer);
  var I, idx: Integer;
      tmpItem: TMngTemplateItem;
      grp: string;
begin
  Lst.Clear;
  Lst.Add('');
  case tp of
    fisicoTpCamposNome: grp := fisicoCAMPOS;
    fisicoTpCamposTipo: grp := fisicoTIPOS;
    fisicoTpCamposCoplemento: grp := fisicoCOMPLEMENTO_CAMPOS;
    fisicoTpTabelaCoplemento: grp := fisicoCOMPLEMENTO_TABELAS;
  end;
  brDM.Visual.Modelo.GeraLista(Lst, tp);
  for I := 0 to ComponentCount - 1 do
  begin
    tmpItem := TMngTemplateItem(Components[i]);
    if (tmpItem.Grupo = grp) then
    begin
      idx := Lst.IndexOf(tmpItem.Campo1);
      if idx <> -1 then
      begin
        Lst.Delete(idx);
      end;
    end;
  end;
  Lst.Sort;
end;

function TMngTemplate.getItem(index: Integer): TMngTemplateItem;
begin
  Result := TMngTemplateItem(Components[index]);
end;

function TMngTemplate.LoadFromXML(Node: IXMLNode): boolean;
  var tmp: string;
      oNode, LNode: IXMLNode;
      J, I: Integer;
      tmpItem: TMngTemplateItem;
begin
  Result := true;
  try
    for J := 0 to Node.ChildNodes.Count - 1 do
    begin
      oNode := Node.ChildNodes[J];
      //tmp := oNode.NodeName;
      tmp := StringReplace(oNode.NodeName, '_', ' ', [rfReplaceAll]);
      if tmp = 'DDL' then
      begin
        ddlCTab_A := GetNodeValue(oNode, 'CTab_A');
        ddlCTab_B := GetNodeValue(oNode, 'CTab_B');
        ddlCTab_Compl := GetNodeValue(oNode, 'CTab_Compl');
        ddlCTab_C := GetNodeValue(oNode, 'CTab_C');
        ddlCCamp := GetNodeValue(oNode, 'CCamp');

        ddlPk_inTab := StrToBool(GetNodeValue(oNode, 'Pk_inTab'));
        ddlFk_inTab := StrToBool(GetNodeValue(oNode, 'Fk_inTab'));
        ddlConst_Nomear := StrToBool(GetNodeValue(oNode, 'Const_Nomear'));
        ddlCConst_Nome := GetNodeValue(oNode, 'CConst_Nome');
        ddlSeparador := GetNodeValue(oNode, 'Separador');
      end else
      for I := 0 to oNode.ChildNodes.Count - 1 do
      begin
        tmpItem := TMngTemplateItem.Create(Self);
        LNode := oNode.ChildNodes[I];
        tmpItem.LoadFromXML(LNode);
        tmpItem.Grupo := tmp;
        tmpItem.Estatus := EITNormal;
      end;
    end;
  except
    on exception do
    Begin
      Result := false;
    end;
  end;
end;

procedure TMngTemplate.Read(Reader: TReader);
  var i, tl: Integer;
      C1, C2, Gr: string;
begin
  tl := Reader.ReadVariant;
  Reader.ReadListBegin;
  for I := 0 to tl -1 do
  begin
    c1 := Reader.ReadString;
    c2 := Reader.ReadString;
    GR := Reader.ReadString;
    Add(C1, C2, GR);
  end;
  ddlCTab_A := Reader.ReadString;
  ddlCTab_B := Reader.ReadString;
  ddlCTab_Compl := Reader.ReadString;
  ddlCTab_C := Reader.ReadString;
  ddlCCamp := Reader.ReadString;
  ddlPk_inTab := Reader.ReadBoolean;
  ddlFk_inTab := Reader.ReadBoolean;
  ddlConst_Nomear := Reader.ReadBoolean;
  ddlCConst_Nome := Reader.ReadString;
  ddlSeparador := Reader.ReadString;
  Reader.ReadListEnd;
end;

procedure TMngTemplate.RessetToNormal;
  var I: Integer;
      tmpItem: TMngTemplateItem;
begin
  I := 0;
  while I < ComponentCount do
  begin
    tmpItem := TMngTemplateItem(Components[i]);
    if (tmpItem.Estatus = EITJustModelo) then tmpItem.Free
    else begin
      tmpItem.Estatus := EITNormal;
      Inc(i);
    end;
  end;
end;

function TMngTemplate.LoadFromXML(oArq: string): string;
  var tmp: string;
      Node, LNode: IXMLNode;
      J, I: Integer;
      tmpItem: TMngTemplateItem;
begin
  DestroyComponents;
  Result := '';
  try
    if oArq = '' then oArq := Arq;
    Arq := oArq;
    DXML.XML.Clear;
    DXML.LoadFromFile(arq);
    DXML.Active := true;
    for J := 0 to DXML.DocumentElement.ChildNodes.Count - 1 do
    begin
      Node := DXML.DocumentElement.ChildNodes[J];
      tmp := StringReplace(Node.NodeName, '_', ' ', [rfReplaceAll]);
      if tmp = 'DDL' then
      begin
        ddlCTab_A := GetNodeValue(Node, 'CTab_A');
        ddlCTab_B := GetNodeValue(Node, 'CTab_B');
        ddlCTab_Compl := GetNodeValue(Node, 'CTab_Compl');
        ddlCTab_C := GetNodeValue(Node, 'CTab_C');
        ddlCCamp := GetNodeValue(Node, 'CCamp');

        ddlPk_inTab := StrToBool(GetNodeValue(Node, 'Pk_inTab'));
        ddlFk_inTab := StrToBool(GetNodeValue(Node, 'Fk_inTab'));
        ddlConst_Nomear := StrToBool(GetNodeValue(Node, 'Const_Nomear'));
        ddlCConst_Nome := GetNodeValue(Node, 'CConst_Nome');
        ddlSeparador := GetNodeValue(Node, 'Separador');
      end else
      for I := 0 to Node.ChildNodes.Count - 1 do
      begin
        tmpItem := TMngTemplateItem.Create(Self);
        LNode := Node.ChildNodes[I];
        tmpItem.LoadFromXML(LNode);
        tmpItem.Grupo := tmp;
        tmpItem.Estatus := EITNormal;
      end;
    end;
  except
    on e : exception do
    Begin
      Result := e.Message;
      DestroyComponents;
    end;
  end;
end;

function TMngTemplate.SalveToXML(oArq: string): boolean;
  var Node, LNode: IXMLNode;
      I: Integer;
      tmpItem: TMngTemplateItem;
      grpcc, grpct: string;
begin
  Result := true;
  try
    if oArq = '' then oArq := Arq;
    Arq := oArq;
    DXML.XML.Clear;
    grpcc := StringReplace(fisicoCOMPLEMENTO_CAMPOS, ' ', '_', [rfReplaceAll]);
    grpct := StringReplace(fisicoCOMPLEMENTO_TABELAS, ' ', '_', [rfReplaceAll]);
    with DXML do
    begin
      XML.Add('<?xml version="1.0" encoding="ISO-8859-1"?>');
      XML.Add('<TEMPLATE>');
      XML.Add('<' + fisicoCAMPOS + '/>');
      XML.Add('<' + fisicoTIPOS + '/>');
      XML.Add('<' + grpcc + '/>');
      XML.Add('<' + grpct + '/>');
      XML.Add('<DDL/>');
      XML.Add('</TEMPLATE>');
    end;
    DXML.Active := true;
    for I := 0 to ComponentCount - 1 do
    begin
      tmpItem := TMngTemplateItem(Components[i]);
      if (tmpItem.Grupo = fisicoCAMPOS) then
        Node := DXML.DocumentElement.ChildNodes[0] else
      if (tmpItem.Grupo = fisicoTIPOS) then
        Node := DXML.DocumentElement.ChildNodes[1] else
      if (tmpItem.Grupo = fisicoCOMPLEMENTO_CAMPOS) then
        Node := DXML.DocumentElement.ChildNodes[2]
      else
        Node := DXML.DocumentElement.ChildNodes[3];
      LNode := Node.AddChild('ITEM');
      tmpItem.to_xml(LNode);
      tmpItem.Estatus := EITNormal;
    end;
    //ddl
    Node := DXML.DocumentElement.ChildNodes[4];
    LNode := Node.AddChild('CTab_A');
    LNode.NodeValue := ddlCTab_A;
    LNode := Node.AddChild('CTab_B');
    LNode.NodeValue := ddlCTab_B;
    LNode := Node.AddChild('CTab_Compl');
    LNode.NodeValue := ddlCTab_Compl;
    LNode := Node.AddChild('CTab_C');
    LNode.NodeValue := ddlCTab_C;
    LNode := Node.AddChild('CCamp');
    LNode.NodeValue := ddlCCamp;
    LNode := Node.AddChild('Pk_inTab');
    LNode.NodeValue := BoolToStr(ddlPk_inTab);
    LNode := Node.AddChild('Fk_inTab');
    LNode.NodeValue := BoolToStr(ddlFk_inTab);
    LNode := Node.AddChild('Const_Nomear');
    LNode.NodeValue := BoolToStr(ddlConst_Nomear);
    LNode := Node.AddChild('CConst_Nome');
    LNode.NodeValue := ddlCConst_Nome;
    LNode := Node.AddChild('Separador');
    LNode.NodeValue := ddlSeparador;
    DXML.SaveToFile(Arq);
  except
    on exception do
    Begin
      Result := false;
    end;
  end;
end;

function TMngTemplate.SalveToXML(Node: IXMLNode): boolean;
  var oNode, LNode, nodeCampo, nodeTipo, nodeCCampo, nodeCTabela: IXMLNode;
      I: Integer;
      tmpItem: TMngTemplateItem;
begin
  Result := true;
  nodeCampo := Node.AddChild(fisicoCAMPOS);
  nodeTipo := Node.AddChild(fisicoTIPOS);
  nodeCCampo := Node.AddChild(StringReplace(fisicoCOMPLEMENTO_CAMPOS, ' ', '_', [rfReplaceAll]));
  nodeCTabela := Node.AddChild(StringReplace(fisicoCOMPLEMENTO_TABELAS, ' ', '_', [rfReplaceAll]));

  try
    for I := 0 to ComponentCount - 1 do
    begin
      tmpItem := TMngTemplateItem(Components[i]);
      if (tmpItem.Grupo = fisicoCAMPOS) then
        oNode := nodeCampo else
      if (tmpItem.Grupo = fisicoTIPOS) then
        oNode := nodeTipo else
      if (tmpItem.Grupo = fisicoCOMPLEMENTO_CAMPOS) then
        oNode := nodeCCampo
      else
        oNode := nodeCTabela;
      LNode := oNode.AddChild('ITEM');
      tmpItem.to_xml(LNode);
      tmpItem.Estatus := EITNormal;
    end;
    //ddl
    Node := Node.AddChild('DDL');
    LNode := Node.AddChild('CTab_A');
    LNode.NodeValue := ddlCTab_A;
    LNode := Node.AddChild('CTab_B');
    LNode.NodeValue := ddlCTab_B;
    LNode := Node.AddChild('CTab_Compl');
    LNode.NodeValue := ddlCTab_Compl;
    LNode := Node.AddChild('CTab_C');
    LNode.NodeValue := ddlCTab_C;
    LNode := Node.AddChild('CCamp');
    LNode.NodeValue := ddlCCamp;
    LNode := Node.AddChild('Pk_inTab');
    LNode.NodeValue := BoolToStr(ddlPk_inTab);
    LNode := Node.AddChild('Fk_inTab');
    LNode.NodeValue := BoolToStr(ddlFk_inTab);
    LNode := Node.AddChild('Const_Nomear');
    LNode.NodeValue := BoolToStr(ddlConst_Nomear);
    LNode := Node.AddChild('CConst_Nome');
    LNode.NodeValue := ddlCConst_Nome;
    LNode := Node.AddChild('Separador');
    LNode.NodeValue := ddlSeparador;
  except
    on exception do
    Begin
      Result := false;
    end;
  end;
end;

procedure TMngTemplate.SetArq(const Value: string);
begin
  FArq := Value;
end;

procedure TMngTemplate.SetDXML(const Value: TXMLDocument);
begin
  FDXML := Value;
end;

procedure TMngTemplate.SetddlCCamp(const Value: string);
begin
  FddlCCamp := Value;
end;

procedure TMngTemplate.SetddlCConst_Nome(const Value: string);
begin
  FddlCConst_Nome := Value;
end;

procedure TMngTemplate.SetddlConst_Nomear(const Value: boolean);
begin
  FddlConst_Nomear := Value;
end;

procedure TMngTemplate.SetddlCTab_A(const Value: string);
begin
  FddlCTab_A := Value;
end;

procedure TMngTemplate.SetddlCTab_B(const Value: string);
begin
  FddlCTab_B := Value;
end;

procedure TMngTemplate.SetddlCTab_C(const Value: string);
begin
  FddlCTab_C := Value;
end;

procedure TMngTemplate.SetddlCTab_Compl(const Value: string);
begin
  FddlCTab_Compl := Value;
end;

procedure TMngTemplate.SetddlFk_inTab(const Value: boolean);
begin
  FddlFk_inTab := Value;
end;

procedure TMngTemplate.SetddlPk_inTab(const Value: boolean);
begin
  FddlPk_inTab := Value;
end;

procedure TMngTemplate.SetddlSeparador(const Value: string);
begin
  FddlSeparador := Value;
end;

procedure TMngTemplate.Write(Writer: TWriter);
  var i: Integer;
      tmpItem: TMngTemplateItem;
begin
  Writer.WriteVariant(ComponentCount);
  Writer.WriteListBegin;
  for I := 0 to ComponentCount - 1 do
  begin
    tmpItem := Item[i];
    Writer.WriteString(tmpItem.Campo1);
    Writer.WriteString(tmpItem.Campo2);
    Writer.WriteString(tmpItem.Grupo);
  end;
  Writer.WriteString(ddlCTab_A);
  Writer.WriteString(ddlCTab_B);
  Writer.WriteString(ddlCTab_Compl);
  Writer.WriteString(ddlCTab_C);
  Writer.WriteString(ddlCCamp);
  Writer.WriteBoolean(ddlPk_inTab);
  Writer.WriteBoolean(ddlFk_inTab);
  Writer.WriteBoolean(ddlConst_Nomear);
  Writer.WriteString(ddlCConst_Nome);
  Writer.WriteString(ddlSeparador);
  Writer.WriteListEnd;
end;

end.
