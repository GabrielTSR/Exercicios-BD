unit Inspector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  StdCtrls, Controls, Forms, ExtCtrls, Contnrs, TypInfo, BiLista, ajuda;

const
  IAltura = 18;

type
  TAjuda = class(TComponent)
  private
    FLoadedF: boolean;
    FLabelAjuda: TLabel;
    FHelpFile: TBiLista;
    procedure SetHelpFile(const Value: TBiLista);
    procedure SetLabelAjuda(const Value: TLabel);
    procedure SetLoadedF(const Value: boolean);
  public
    property HelpFile: TBiLista read FHelpFile write SetHelpFile;
    constructor Create(AOwner: TComponent); override;
    property LoadedF: boolean read FLoadedF write SetLoadedF;
    property LabelAjuda: TLabel read FLabelAjuda write SetLabelAjuda;
    procedure ShowHelp(Cod: string);
  end;

  TKind = (tpNulo, tpTitulo, tpTexto, tpNumero, tpCor, tpMenu, tpMenuReadOnly, tpReadOnly, tpEditor, tpEdtLstDrop);
  TInspector = class;

  TMeuBotao = class(TPanel)
  protected
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnKeyDown;
  end;

  TComboItem = record
    Texto: string;
    Valor: Variant;
  end;

  TComboMake = class(TObject)
  private
    FLargura, FTamanho: integer;
    procedure reSetLargura(const Value: integer);
  public
    Itens: Array of TComboItem;
    procedure Add(oTexto: string; oValor: variant);
    property Largura: integer read FLargura write reSetLargura;
    Function GetByVal(oValor: Variant): string;
    constructor Create; //override;
  end;

  TAbs = class(TGraphicControl)
  private
    FTipo: TKind;
    Pai: TInspector;
    Obj: TWinControl;
    FSelecionado: boolean;
    FComboIndex: Integer;
    FValor: string;
    FCaption: string;
    FProprit: string;
    FComboConversor: TComboMake;
    FMyIndex: integer;
    FCodAjuda: string;
    procedure SetCodAjuda(const Value: string);
    procedure SetMyIndex(const Value: integer);
    procedure SetComboConversor(const Value: TComboMake);
    procedure SetProprit(const Value: string);
    procedure SetTipo(const Value: TKind);
    procedure EditNummKeyPress(Sender: TObject; var Key: Char);
    procedure EditAllKeyPress(Sender: TObject; var Key: Char);
    procedure SetSelecionado(const Value: boolean);
    procedure SetCaption(const Value: string);
    procedure SetValor(const Value: string);
  protected
    procedure Paint; override;
    procedure Click; override;
    procedure Resize; override;
    procedure OnObjExit(Sender: TObject);
    procedure btnClick(Sender: TObject);
    Procedure ComboPrepare;
  public
    Procedure Generete(qtd: integer; booleano: boolean = false; ini: integer = 0; formato: string = '0');
    destructor Destroy; override;
    property ComboConversor : TComboMake read FComboConversor write SetComboConversor;
    property Valor: string read FValor write SetValor;
    property Caption: string read FCaption write SetCaption;
    property Proprit: string read FProprit write SetProprit;
    procedure Setar(aProprit, aCaption, oValor: string; oTipo: TKind = tpTexto; const oCodAjuda: string = '');
    procedure SetarBooleano(aProprit, aCaption: string; oValor: boolean; const oCodAjuda: string = '');
    procedure SetarROBooleano(aProprit, aCaption: string; oValor: boolean; const oCodAjuda: string = '');
    property Tipo: TKind read FTipo write SetTipo;
    Procedure SetAsTitulo(aCaption: string);
    constructor Create(AOwner: TComponent); override;
    Procedure Maker;
    Property MyIndex: integer read FMyIndex write SetMyIndex;
    property Selecionado: boolean read FSelecionado write SetSelecionado;
    Procedure JustAlterTipo(NovoTipo: TKind);
    Property CodAjuda: string read FCodAjuda write SetCodAjuda;
  end;

  TInspector = class(TScrollingWinControl)
  private
    FColorBox: TColorBox;
    FComboBox: TComboBox;
    FEdit: TEdit;
    Fitens: TComponentList;
    FTotalItens: Integer;
    FBase, OldB: TComponent;
    FBotao: TMeuBotao;
    FFirstSelecao: TAbs;
    FUltimoSetado: integer;
    FBaseMudou: boolean;
    FonBeginUpdateBase: TNotifyEvent;
    FonEndUpdateBase: TNotifyEvent;
    FEnviadorDeFocus: TWinControl;
    FAjuda: TAjuda;
    procedure SetAjuda(const Value: TAjuda);
    procedure SetEnviadorDeFocus(const Value: TWinControl);
    procedure SetonEndUpdateBase(const Value: TNotifyEvent);
    procedure SetonBeginUpdateBase(const Value: TNotifyEvent);
    procedure SetUltimoSetado(const Value: integer);
    procedure SetFirstSelecao(const Value: TAbs);
    procedure SetBotao(const Value: TMeuBotao);
    procedure SetBase(const Value: TComponent);
    procedure SetColorBox(const Value: TColorBox);
    procedure SetComboBox(const Value: TComboBox);
    procedure SetEdit(const Value: TEdit);
    function getItem(index: integer): TAbs;
    procedure Setitens(const Value: TComponentList);
    procedure SetTotalItens(const Value: Integer);
  protected
    Pan: TWinControl;
    FSelecionado: TAbs;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure Selecione(oAbs: TAbs);
    procedure objKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure forceProxSelecao(MaisMenos: integer);
    Function SetValor(oItem: TAbs): boolean;
    procedure HideItens(APartirde: integer = 0);
    Procedure ShowHelp;
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    property ColorBox: TColorBox read FColorBox write SetColorBox;
    property ComboBox: TComboBox read FComboBox write SetComboBox;
    property Edit: TEdit read FEdit write SetEdit;
    property itens: TComponentList read Fitens write Setitens;
    property item[index: integer]: TAbs read getItem; default;
    property TotalItens: Integer read FTotalItens write SetTotalItens;
    property Base: TComponent read FBase write SetBase;
    property Botao: TMeuBotao read FBotao write SetBotao;
    procedure ReciverKey(key: word);
    property FirstSelecao: TAbs read FFirstSelecao write SetFirstSelecao;
    property UltimoSetado: integer read FUltimoSetado write SetUltimoSetado;
    procedure Show;
    Function NextItem: TAbs;
    property BaseMudou: boolean read FBaseMudou;
    property onBeginUpdateBase: TNotifyEvent read FonBeginUpdateBase write SetonBeginUpdateBase;
    property onEndUpdateBase: TNotifyEvent read FonEndUpdateBase write SetonEndUpdateBase;
    property EnviadorDeFocus: TWinControl read FEnviadorDeFocus write SetEnviadorDeFocus;
    property Ajuda: TAjuda read FAjuda write SetAjuda;
  end;

implementation
uses uApp;

{ TInspector }
function TInspector.getItem(index: integer): TAbs;
begin
  Result := nil;
  if (index < fitens.Count) and (index > -1) then
  begin
    Result := TAbs(Fitens[index]);
  end;
end;

procedure TInspector.HideItens(APartirde: integer);
  var i: integer;
      oItem: TAbs;
begin
  for I := 0 to FTotalItens - 1 do
  begin
    oItem := TAbs(itens[i]);
    if i >= APartirde then oItem.Tipo := tpNulo;
    oItem.Maker;
    oItem.Top := IAltura * (TotalItens + 2);
  end;
end;

function TInspector.NextItem: TAbs;
begin
  Result := getItem(FUltimoSetado + 1);
end;

procedure TInspector.CNKeyDown(var Message: TWMKeyDown);
  var key: word;
begin
  key := Message.CharCode;
  if (key = 38) or (key = 40) then
  begin
    if key = 38 then forceProxSelecao(-1) else forceProxSelecao(1);
    //Key := 0;
  end;
  inherited;
end;

constructor TInspector.Create(AOwner: TComponent);
  var i: integer;
begin
  inherited;
  if AOwner is TWinControl then Parent := TWinControl(AOwner);
  TotalItens := 20;
  Pan := TWinControl.Create(Self);
  Pan.Parent := Self;
  Pan.Align := alTop;
  Pan.Height := TotalItens * IAltura;
  Fitens := TComponentList.Create(false);

  ColorBox := TColorBox.Create(Self);
  ColorBox.Parent := Pan;
  ColorBox.ItemHeight:=12;
  ColorBox.Ctl3D := false;
  ColorBox.Visible := false;

  ComboBox := TComboBox.Create(Self);
  ComboBox.Parent := Pan;
  ComboBox.ItemHeight := 12;
  ComboBox.Style := csOwnerDrawFixed;
  ComboBox.Visible := false;
  ComboBox.AutoComplete := false;

  Edit := TEdit.Create(Self);
  Edit.Parent := Pan;
  Edit.SetBounds((Width div 2) + 2, 1, (Width div 2) - 2, IAltura -1);
  Edit.Visible := false;
  Edit.ShowHint := True;
  Botao := TMeuBotao.Create(Self);
  Botao.Parent := Pan;
  Botao.Visible := false;
  Botao.ShowHint := True;
  Botao.Caption := '...';

  Edit.OnKeyDown := objKeyDown;
  ComboBox.OnKeyDown := objKeyDown;
  ColorBox.OnKeyDown := objKeyDown;
  Botao.OnKeyDown := objKeyDown;

  for i := 0 to TotalItens -1 do
  begin
    Fitens.Add(TAbs.Create(Self));
  end;
  TabStop := true;
  Ajuda := TAjuda.Create(Self);
end;

destructor TInspector.Destroy;
begin
  Fitens.Free;
  inherited;
end;

procedure TInspector.SetAjuda(const Value: TAjuda);
begin
  FAjuda := Value;
end;

procedure TInspector.SetBase(const Value: TComponent);
//  var res: TAbs; -- Habilite se quiser que o item permaneça selecionado em caso de reclique.
begin
  UltimoSetado := 0;
  if Assigned(FSelecionado) then FSelecionado.Selecionado := false;
  FFirstSelecao := nil;
  OldB := FBase;
  FBase := Value;
  FBaseMudou := (FBase <> OldB);
  ShowHelp;

//  res := FSelecionado;
  FSelecionado := nil;
//  if (not FBaseMudou) and (res <> nil) then res.Click;
  if FBase = nil then HideItens;
  Invalidate;
end;

procedure TInspector.SetBotao(const Value: TMeuBotao);
begin
  FBotao := Value;
end;

procedure TInspector.SetColorBox(const Value: TColorBox);
begin
  FColorBox := Value;
end;

procedure TInspector.SetComboBox(const Value: TComboBox);
begin
  FComboBox := Value;
end;

procedure TInspector.SetEdit(const Value: TEdit);
begin
  FEdit := Value;
end;

procedure TInspector.SetEnviadorDeFocus(const Value: TWinControl);
begin
  FEnviadorDeFocus := Value;
end;

procedure TInspector.SetFirstSelecao(const Value: TAbs);
begin
  FFirstSelecao := Value;
end;

procedure TInspector.Setitens(const Value: TComponentList);
begin
  Fitens := Value;
end;

procedure TInspector.SetonBeginUpdateBase(const Value: TNotifyEvent);
begin
  FonBeginUpdateBase := Value;
end;

procedure TInspector.SetonEndUpdateBase(const Value: TNotifyEvent);
begin
  FonEndUpdateBase := Value;
end;

{ TBase }

procedure TAbs.btnClick(Sender: TObject);
  var F: TForm;
      P: TPanel;
      B: TButton;
      M: TMemo;
begin
  Pai.Botao.Color := clBlue;
  F := TForm.Create(nil);
  try
    F.BorderStyle := bsSizeToolWin;
    F.Position := poMainFormCenter;
    F.Width := 350;
    F.Height := 200;
    F.Caption := 'Editor';
    P := TPanel.Create(F);
    with P do
    begin
      Align := alBottom;
      Height := 30;
      Caption := '';
    end;
    P.Parent := F;
    M := TMemo.Create(F);
    M.Parent := F;
    M.Align := alClient;

    M.Lines.Text := StringReplace(Valor, #13, #13#10, [rfReplaceAll]);

    M.TabOrder := 0;
    B := TButton.Create(F);
    with B do
    begin
      B.Parent := P;
      SetBounds(4, 4, 70, 22);
      Caption := 'Pronto';
      Default := True;
      ModalResult := 1;
      TabOrder := 0;
    end;
    B := TButton.Create(F);
    with B do
    begin
      B.Parent := P;
      SetBounds(79, 4, 70, 22);
      Cancel := True;
      Caption := 'Cancelar';
      ModalResult := 2;
      TabOrder := 1;
    end;
    if F.ShowModal = mrOk then
    begin
      Valor := StringReplace(M.Lines.Text, #13#10, #13, [rfReplaceAll]);
      Invalidate;
    end;
  finally
    F.Free;
  end;
  Pai.Botao.Color := clBtnFace;
end;

procedure TAbs.Click;
begin
  inherited;
  Selecionado := true;
end;

procedure TAbs.ComboPrepare;
var
  I: Integer;
begin
  Pai.ComboBox.Clear;
  for I := 0 to ComboConversor.Largura - 1 do
  begin
    Pai.ComboBox.Items.Add(ComboConversor.Itens[i].Texto);
  end;
end;

constructor TAbs.Create(AOwner: TComponent);
begin
  inherited;
  Pai := TInspector(AOwner);
  Parent := Pai.pan;
  Align := alTop;
  MyIndex := Pai.Fitens.Count;
  SetBounds(0, 0, 1, IAltura);
  Visible := false;
  FCaption := 'Item';
  FValor := '0';
  ComboConversor := TComboMake.Create;
end;

destructor TAbs.Destroy;
begin
  ComboConversor.Free;
  inherited;
end;

procedure TInspector.SetTotalItens(const Value: Integer);
begin
  FTotalItens := Value;
end;

procedure TInspector.SetUltimoSetado(const Value: integer);
begin
  FUltimoSetado := Value;
end;

function TInspector.SetValor(oItem: TAbs): boolean;
begin
  Result := true;
  if (oItem.Tipo = tpReadOnly) or (oItem.Tipo = tpMenuReadOnly) then exit;
  try
    if Assigned(onBeginUpdateBase) then FonBeginUpdateBase(Base);
    case oItem.Tipo of
      tpCor: SetPropValue(Base, oItem.Proprit, StringToColor(oItem.Valor));
      tpMenu: SetPropValue(Base, oItem.Proprit, oItem.ComboConversor.Itens[oItem.FComboIndex].Valor);
      else SetPropValue(Base, oItem.Proprit, oItem.Valor);
    end;
    if Assigned(onEndUpdateBase) then FonEndUpdateBase(Base);
  except
    on exception do
    begin
      if Assigned(onEndUpdateBase) then FonEndUpdateBase(nil);
      Result := false;
    end;
  end;
end;

procedure TInspector.Show;
begin
  if baseMudou then HideItens(UltimoSetado + 1);
end;

procedure TInspector.ShowHelp;
begin
  if not Ajuda.LoadedF then Exit;
  if (FSelecionado = nil) or (not FSelecionado.Selecionado) then Ajuda.ShowHelp('') else Ajuda.ShowHelp(FSelecionado.CodAjuda);
end;

procedure TAbs.EditAllKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    OnObjExit(nil);
  end;
  if key = #27 then
  begin
    (Sender as TEdit).Text := Valor;
//    (Sender as TEdit).SelectAll;
    if Assigned(Pai.EnviadorDeFocus) then Pai.EnviadorDeFocus.SetFocus;
    Pai.Selecione(nil);
    key := #0;
  end;
end;

procedure TAbs.EditNummKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    OnObjExit(nil);
  end;
  if key = #27 then
  begin
    (Sender as TEdit).Text := Valor;
//    (Sender as TEdit).SelectAll;
    key := #0;
    if Assigned(Pai.EnviadorDeFocus) then Pai.EnviadorDeFocus.SetFocus;
    Pai.Selecione(nil);
  end;
  if not (key in ['0'..'9', #8]) then key := #0;
end;

procedure TAbs.Generete(qtd: integer; booleano: boolean; ini: integer; formato: string);
  var i, j: integer;
begin
  if not Pai.BaseMudou then exit;
  ComboConversor.Largura := qtd;
  if booleano then
  begin
    ComboConversor.Add('Sim', 'True');
    ComboConversor.Add('Não', 'False');
  end else
  begin
    J := ini;
    for I := 0 to Qtd - 1 do
    begin
      ComboConversor.Add(FormatFloat(formato, j), J);
      inc(j);
    end;  
  end;
end;

procedure TAbs.JustAlterTipo(NovoTipo: TKind);
begin
  FTipo := NovoTipo;
end;

procedure TAbs.Maker;
begin
  case tipo of
    tpNulo: begin
      Visible := false;
      Selecionado := false;
    end;
    else begin
      Visible := true;
    end;
  end;
end;

procedure TAbs.OnObjExit(Sender: TObject);
begin
  if Obj is TEdit then Valor := TEdit(Obj).Text;
  if (Obj is TComboBox) then
  begin
    FComboIndex := TComboBox(Obj).ItemIndex;
    Valor := TComboBox(Obj).Text;
  end;
  if Obj is TColorBox then Valor := ColorToString(TColorBox(Obj).Selected);
end;

procedure TAbs.Paint;
  var Largura: integer;
      rec: TRect;
      Ctop, Cbac: TColor;
begin
  inherited;
  if Tipo = tpNulo then Exit;
  with canvas do
  begin
    Font.Style := [];
    Pen.Color := clBtnShadow;
    if Selecionado then
    begin
      Font.Style := Font.Style + [fsBold];
      Brush.Color := clBlue;
      Font.Color := clWhite;
      Ctop := clBtnShadow;
      Cbac := clBtnHighlight;
    end else
    begin
      Brush.Color := clBtnFace;
      Font.Color := clBlack;
      Cbac := clBtnShadow;
      Ctop := clBtnHighlight;
    end;
    Brush.Style := bsSolid;
    rec := Rect(0, 0, Width, Height);
    FillRect(rec);
    if (Selecionado) or (Tipo = tpTitulo) then
      Frame3D(Canvas, rec, Ctop, Cbac, 1);

    if Tipo = tpTitulo then
    begin
      Font.Style := Font.Style + [fsBold];
      Largura := Width;
      rec := Rect(2, 2, Largura -2, Height -2);
      DrawText(Canvas.Handle, Pchar(Caption), Length(Caption), rec, DT_CENTER or DT_EXPANDTABS);
    end else
    begin
      Largura := (Width div 2);
      rec := Rect(4, 2, Largura -2, Height -2);
      DrawText(Canvas.Handle, Pchar(Caption), Length(Caption), rec, DT_LEFT or DT_EXPANDTABS);
      if (not Selecionado) or (Tipo = tpEditor) then
      begin
        Brush.Color := clWhite;
        if (Tipo = tpEditor) and Selecionado then Brush.Color := clYellow;
        Font.Color := clBlack;
        rec := Rect(Largura, 0, Width -1, Height -1);
        FillRect(rec);
        rec := Rect(Largura + 4, 2, Width -2, Height -2);
        if (Tipo = tpReadOnly) or (Tipo = tpMenuReadOnly) then Font.Color := clGray;//Red;
        DrawText(Canvas.Handle, Pchar(Valor), Length(Valor), rec, DT_LEFT or DT_EXPANDTABS);
        Font.Color := clWindowText;
        MoveTo(0, Height -1);
        LineTo(Width -1, Height -1);
        LineTo(Width -1, 0);
      end;
    end;
  end;
end;

procedure TAbs.Resize;
begin
  inherited;
  if (Obj <> nil) and (Selecionado) then
    if not (Obj is TButton) then
      obj.SetBounds((Width div 2), obj.Top, (Width div 2), Height -1)
        else obj.SetBounds((Width - Height) - 2, Top + 1, Height, Height -3);
end;

procedure TAbs.Setar(aProprit, aCaption, oValor: string; oTipo: TKind = tpTexto; const oCodAjuda: string = '');
begin
  FCaption := aCaption;
  FProprit := aProprit;
  FValor := oValor;
  Tipo := oTipo;
  FCodAjuda := oCodAjuda;
end;

procedure TAbs.SetarBooleano(aProprit, aCaption: string; oValor: boolean; const oCodAjuda: string);
begin
  Generete(2, true);
  if oValor then
    Setar(aProprit, aCaption, 'Sim', tpMenu, oCodAjuda)
      else Setar(aProprit, aCaption, 'Não', tpMenu, oCodAjuda);
end;

procedure TAbs.SetarROBooleano(aProprit, aCaption: string; oValor: boolean; const oCodAjuda: string);
begin
  Generete(2, true);
  if oValor then
    Setar(aProprit, aCaption, 'Sim', tpMenuReadOnly, oCodAjuda)
      else Setar(aProprit, aCaption, 'Não', tpMenuReadOnly, oCodAjuda);
end;

procedure TAbs.SetAsTitulo(aCaption: string);
begin
  FProprit := 'T';
  FCaption := aCaption;
  Tipo := tpTitulo;
end;

procedure TAbs.SetCaption(const Value: string);
begin
  FCaption := Value;
  Invalidate;
end;

procedure TAbs.SetCodAjuda(const Value: string);
begin
  FCodAjuda := Value;
end;

procedure TAbs.SetComboConversor(const Value: TComboMake);
begin
  FComboConversor := Value;
end;

procedure TAbs.SetMyIndex(const Value: integer);
begin
  FMyIndex := Value;
end;

procedure TAbs.SetProprit(const Value: string);
begin
  FProprit := Value;
end;

procedure TAbs.SetSelecionado(const Value: boolean);
begin
  if (Tipo = tpTitulo) or (FSelecionado = Value) then exit;
  FSelecionado := Value;
  if Selecionado then
  begin
    Pai.Selecione(Self);
    Pai.Edit.OnKeyPress := nil;
    case tipo of
      tpTexto: begin
        Obj := Pai.Edit;
        Pai.Edit.OnKeyPress := EditAllKeyPress;
        //Pai.Edit.Enabled := true;
        Pai.Edit.ReadOnly := false;
        Pai.Edit.Font.Color := clWindowText;
      end;
      tpReadOnly: begin
        Obj := Pai.Edit;
        //Pai.Edit.Enabled := false;
        Pai.Edit.ReadOnly := True;
        Pai.Edit.Font.Color := clRed;
      end;
      tpNumero: begin
        Obj := Pai.Edit;
        Pai.Edit.OnKeyPress := EditNummKeyPress;
        //Pai.Edit.Enabled := true;
        Pai.Edit.ReadOnly := false;
        Pai.Edit.Font.Color := clWindowText;
      end;
      tpCor: Obj := Pai.ColorBox;
      tpMenu, tpMenuReadOnly, tpEdtLstDrop: begin
        Obj := Pai.ComboBox;
        ComboPrepare;
        if tipo = tpEdtLstDrop then
          Pai.ComboBox.Text := Valor
        else Pai.ComboBox.ItemIndex := Pai.ComboBox.Items.IndexOf(Valor);
        Pai.ComboBox.Enabled := (Tipo <> tpMenuReadOnly);
        if Tipo = tpEdtLstDrop then
          Pai.ComboBox.Style := csDropDown
            else Pai.ComboBox.Style := csOwnerDrawFixed;
      end;
      tpEditor: begin
        Obj := Pai.Botao;
        Pai.Botao.Hint := StringReplace(Valor, #13, #13#10, [rfReplaceAll]);
        Pai.Botao.OnClick := btnClick;
      end;
    end;
    if Obj = nil then Exit;
    Obj.Visible := True;
    Obj.BringToFront;
    if Obj is TEdit then
    begin
      TEdit(Obj).Text := Valor;
      TEdit(Obj).Hint := Valor;
      TEdit(Obj).OnExit := OnObjExit;
    end;
    if Obj is TComboBox then
    begin
      TComboBox(Obj).Text := Valor;
      TComboBox(Obj).OnExit := OnObjExit;
      TComboBox(Obj).OnSelect := OnObjExit;
      if Tipo = tpEdtLstDrop then
        Self.Height := TComboBox(Obj).Height + 1;
    end;
    if Obj is TColorBox then
    begin
      TColorBox(Obj).Selected := StringToColor(Valor);
      TColorBox(Obj).OnExit := OnObjExit;
      TColorBox(Obj).OnSelect := OnObjExit;
    end;
    if Obj = Pai.Botao then
    begin
      obj.SetBounds((Width - Height) - 2, Top + 1, Height, Height -3);
    end else
      obj.SetBounds((Width div 2), Top + 1, (Width div 2), Height -1);

    Pai.SetFocus;
    if Obj.Parent <> nil then
    SetFocus(Obj.Handle);
  end else
  begin
    if Assigned(Obj) then obj.Visible := false;
    if Self.Height <> IAltura then Self.Height := IAltura;
  end;
  Invalidate;
end;

procedure TAbs.SetTipo(const Value: TKind);
begin
//  if FTipo = Value then exit;
  FTipo := Value;
  Pai.UltimoSetado := MyIndex;
//  Maker;
//  Top := IAltura * (Pai.TotalItens + 2);
end;

procedure TInspector.Selecione(oAbs: TAbs);
begin
  if FSelecionado = oAbs then exit;
  if FSelecionado <> nil then FSelecionado.Selecionado := false;
  FSelecionado := oAbs;
  ShowHelp;
end;

procedure TAbs.SetValor(const Value: string);
  var oldV: string;
begin
  if FValor = Value then exit;
  oldV := FValor;
  FValor := Value;
  if (Tipo = tpMenu) and (FComboIndex = -1) then
  begin
    FValor := oldV;
    exit;
  end;
  if not Pai.SetValor(Self) then
  begin
    FValor := oldV;
    if Tipo = tpMenu then Pai.ComboBox.ItemIndex := Pai.ComboBox.Items.IndexOf(oldV);
  end;
end;

procedure TInspector.objKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 38) or (key = 40) then
  begin
    if (Sender is TComboBox) then
      if (Sender As TComboBox).DroppedDown then exit;
    if (Sender is TColorBox) then
      if (Sender As TColorBox).DroppedDown then exit;
    if key = 38 then forceProxSelecao(-1) else forceProxSelecao(1);
    key := 0;
  end;
end;

procedure TInspector.ReciverKey(key: word);
  var sel: TAbs;
      lparam: LongInt;
begin
  sel := nil;
  if FirstSelecao <> nil then Sel := FirstSelecao;
  if FSelecionado <> nil then Sel := FSelecionado;
  if (sel = nil) or ((sel.Tipo <> tpTexto) and (sel.Tipo <> tpNumero)) then Exit;
  sel.Click;
  Windows.SetFocus(sel.Obj.Handle);
  lparam := $00000001;
  PostMessage(sel.Obj.Handle, WM_CHAR, key, lparam );
  Application.ProcessMessages;
end;

procedure TInspector.forceProxSelecao(MaisMenos: integer);
  var i: integer;
      oItem: TAbs;
begin
//  if Fitens.Count = 0 then Exit;
  i := Fitens.IndexOf(FSelecionado);
  repeat
    i := i + MaisMenos;
    if (i < 0) or (i > Fitens.Count -1) then break;
    oItem := item[i];
    if (oItem.Tipo = tpTitulo) then Continue;
    if oItem.Tipo = tpNulo then break;
    oItem.Selecionado := true;
  until (oItem.Tipo <> tpTitulo);
end;

{ TComboMake }

procedure TComboMake.Add(oTexto: string; oValor: variant);
begin
  Itens[FTamanho].Texto := oTexto;
  Itens[FTamanho].Valor := oValor;
  inc(FTamanho);
end;

constructor TComboMake.Create;
begin
  inherited;
  SetLength(Itens, 1);
  FTamanho := 0;
end;

function TComboMake.GetByVal(oValor: Variant): string;
  var i: integer;
begin
  Result := '';
  for i := 0 to FLargura - 1 do
    if Itens[i].Valor = oValor then
  begin
    Result := Itens[i].Texto;
    break;
  end;
end;

procedure TComboMake.reSetLargura(const Value: integer);
begin
  SetLength(Itens, 0);
  FLargura := Value;
  SetLength(Itens, Value);
  FTamanho := 0;
end;

{ TMeuBotao }

procedure TMeuBotao.CNKeyDown(var Message: TWMKeyDown);
  var key: Word;
begin
  key := Message.CharCode;
  if (key = 38) or (key = 40) then
  begin
    if Assigned(OnKeyDown) then OnKeyDown(Self, key, []);
  end;
  if key = 13 then Click;
  inherited;
end;

constructor TMeuBotao.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TMeuBotao.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  Color := clBlue;
  BevelOuter := bvLowered;
  inherited;
end;

procedure TMeuBotao.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  Color := clBtnFace;
  BevelOuter := bvRaised;
  inherited;
end;

{ TAjuda }

constructor TAjuda.Create(AOwner: TComponent);
  var strs: TStringList;
begin
  inherited;
  FHelpFile := TBiLista.Create(Self);
  strs := TStringList.Create;
  strs.Text := uApp.brFmPrincipal.Conf.Ajuda;
  FHelpFile.LoadFrom(strs);
  LoadedF := True;
  Strs.free;
end;

procedure TAjuda.SetHelpFile(const Value: TBiLista);
begin
  FHelpFile := Value;
end;

procedure TAjuda.SetLabelAjuda(const Value: TLabel);
begin
  FLabelAjuda := Value;
  if Value <> nil then
  begin
    Value.Visible := false;
    Value.AlignWithMargins := true;
  end;
end;

procedure TAjuda.SetLoadedF(const Value: boolean);
begin
  FLoadedF := Value;
end;

procedure TAjuda.ShowHelp(Cod: string);
  var i: integer;
begin
  if Cod <> '' then i := FHelpFile.Index(Cod) else i := -1;
  if (i > -1) and (FHelpFile.Valor(i) <> '') then
  begin
    LabelAjuda.Caption := FHelpFile.Valor(i);
    LabelAjuda.Visible := true;
  end else LabelAjuda.Visible := false;
end;

end.
