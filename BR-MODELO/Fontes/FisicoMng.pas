unit FisicoMng;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  StdCtrls, Controls, Forms, Contnrs, uTemplate, uAux, ExtCtrls;

const
  IAltura = 18;

type
  TMngFisico = class;
  TTipo = (tpNulo, tpTitulo, tpTexto);

  TFisicoItem = class(TGraphicControl)
  private
    FPai: TMngFisico;
    FSelecionado: boolean;
    FMngItem: TMngTemplateItem;
    FTipo: TTipo;
    FTituloIfIsIt: string;
    procedure SetTituloIfIsIt(const Value: string);
    procedure SetMngItem(const Value: TMngTemplateItem);
    procedure SetSelecionado(const Value: boolean);
    procedure SetTipo(const Value: TTipo);
  protected
    procedure Paint; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Tipo: TTipo read FTipo write SetTipo;
    property Selecionado: boolean read FSelecionado write SetSelecionado;
    property MngItem: TMngTemplateItem read FMngItem write SetMngItem;
    property TituloIfIsIt: string read FTituloIfIsIt write SetTituloIfIsIt;
    procedure Refresh;
    property OnDblClick;
  end;

  TMngFisico = class(TScrollingWinControl)
  private
    FFirstSelecao: TFisicoItem;
    FUltimoSetado: integer;
    FMng: TMngTemplate;
    FItemDblClick: TNotifyEvent;
    procedure SetItemDblClick(const Value: TNotifyEvent);
    function getItem(index: Integer): TFisicoItem;
    procedure SetMng(const Value: TMngTemplate);
    procedure SetUltimoSetado(const Value: integer);
    procedure SetFirstSelecao(const Value: TFisicoItem);
  protected
    FSelecionado: TFisicoItem;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure Selecione(oAbs: TFisicoItem);
    procedure forceProxSelecao(MaisMenos: integer);
    procedure Foque(oCtl: TControl);
  public
    property MngT: TMngTemplate read FMng write SetMng;
    property Item[index: Integer]: TFisicoItem read getItem; default;
    procedure Inicialize;
    constructor Create(AOwner: TComponent); override;
    procedure ReciverKey(key: word);
    property FirstSelecao: TFisicoItem read FFirstSelecao write SetFirstSelecao;
    property UltimoSetado: integer read FUltimoSetado write SetUltimoSetado;
    Function NextItem: TFisicoItem;
    function FindByGrupo(oGrupo: string): integer;
    property Selecionado: TFisicoItem read FSelecionado;
    property ItemDblClick: TNotifyEvent read FItemDblClick write SetItemDblClick;
  end;

implementation

{ TMngFisico }

procedure TMngFisico.Inicialize;
  var i: Integer;
      filho: TFisicoItem;
  Function Criar: TFisicoItem;
  begin
    Result := TFisicoItem.Create(Self);
    Result.OnDblClick := Self.ItemDblClick;
  end;
  Procedure popule(grp: string);
  var i: integer;
      it: TMngTemplateItem;
      ja: boolean;
  begin
    ja := false;
    for I := 0 to MngT.ComponentCount - 1 do
    begin
      it := MngT[i];
      if it.Grupo = grp then
      begin
        if not ja then
        begin
          filho := Criar;
          filho.Tipo := tpTitulo;
          filho.TituloIfIsIt := grp;
          ja := true;
        end;
        filho := Criar;
        filho.MngItem := it;
        filho.Tipo := tpTexto;
      end;
    end;
  end;
begin
  DestroyComponents;
//  popule(fisicoCAMPOS); //campos não
  popule(fisicoTIPOS);
  popule(fisicoCOMPLEMENTO_CAMPOS);
  popule(fisicoCOMPLEMENTO_TABELAS);
  Height := ComponentCount * IAltura;
  Invalidate;
end;

function TMngFisico.NextItem: TFisicoItem;
begin
  if (FUltimoSetado + 1) < ComponentCount then
    Result := getItem(FUltimoSetado + 1)
      else Result := nil;
end;

procedure TMngFisico.CNKeyDown(var Message: TWMKeyDown);
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

constructor TMngFisico.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TWinControl then Parent := TWinControl(AOwner);
  Align := alTop;
  Tabstop := true;
end;

function TMngFisico.FindByGrupo(oGrupo: string): integer;
  var i: Integer;
begin
  Result := -1;
  for I := 0 to ComponentCount - 1 do
  begin
    if item[I].MngItem.Grupo = oGrupo then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure TMngFisico.Foque(oCtl: TControl);
begin
//  if (Parent is TScrollingWinControl) then
//  begin
    SetFocus;
    TScrollingWinControl(Parent).ScrollInView(oCtl);
//  end;
end;

procedure TMngFisico.SetFirstSelecao(const Value: TFisicoItem);
begin
  FFirstSelecao := Value;
end;

procedure TMngFisico.SetItemDblClick(const Value: TNotifyEvent);
begin
  FItemDblClick := Value;
end;

procedure TMngFisico.SetMng(const Value: TMngTemplate);
begin
  FMng := Value;
end;

procedure TMngFisico.SetUltimoSetado(const Value: integer);
begin
  FUltimoSetado := Value;
end;

procedure TMngFisico.Selecione(oAbs: TFisicoItem);
begin
  if FSelecionado = oAbs then exit;
  if FSelecionado <> nil then
  begin
    FSelecionado.Selecionado := false;
  end;
  FSelecionado := oAbs;
end;

procedure TMngFisico.ReciverKey(key: word);
  var sel: TFisicoItem;
begin
  sel := nil;
  if FirstSelecao <> nil then Sel := FirstSelecao;
  if FSelecionado <> nil then Sel := FSelecionado;
  if (sel = nil) then Exit;
  sel.Click;
  Application.ProcessMessages;
end;

procedure TMngFisico.forceProxSelecao(MaisMenos: integer);
  var i: integer;
      oItem: TFisicoItem;
begin
  if ComponentCount = 0 then Exit;
  if FSelecionado <> nil then i := FSelecionado.ComponentIndex else i := -1;
  oItem := item[0];
  repeat
    i := i + MaisMenos;
    if (i < 0) then Foque(item[0]);
    if (i < 0) or (i > ComponentCount -1) then break;
    oItem := item[i];
    if (oItem.Tipo = tpTitulo) then Continue;
    if oItem.Tipo = tpNulo then break;
    oItem.Selecionado := true;
  until (oItem.Tipo <> tpTitulo);
end;

function TMngFisico.getItem(index: Integer): TFisicoItem;
begin
  Result := TFisicoItem(Components[index]);
end;

{ TFisicoItem }

procedure TFisicoItem.Click;
begin
  inherited;
  if Tipo = tpTexto then
    Selecionado := true;
end;

constructor TFisicoItem.Create(AOwner: TComponent);
begin
  inherited;
  FPai := TMngFisico(AOwner);
  Parent := FPai;
  Align := alTop;
  SetBounds(0, 0, 1, IAltura);
  ShowHint := true;
end;

procedure TFisicoItem.Paint;
  var rec: TRect;
      Ctop, Cbac: TColor;
      LargC1, LargC2: Integer;
  procedure drawTxt(txt: string; ini, WW: integer);
  begin
    rec := Rect(ini + 2, 2, ww -2, Height -2);
    DrawText(Canvas.Handle, Pchar(txt), Length(txt), rec, DT_LEFT or DT_EXPANDTABS);
  end;
begin
  inherited;
  if FTipo = tpNulo then Exit;
  LargC1 := Parent.Width div 3;
  LargC2 := Parent.Width - LargC1;
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
      if (FTipo = tpTitulo) then Brush.Color := clMoneyGreen
      else Brush.Color := clBtnFace;
      Font.Color := clBlack;
      Cbac := clBtnShadow;
      Ctop := clBtnHighlight;
    end;

    Brush.Style := bsSolid;
    rec := Rect(0, 0, Width, Height);
    FillRect(rec);
    if (Selecionado) or (FTipo = tpTitulo) then
      Frame3D(Canvas, rec, Ctop, Cbac, 1);

    if FTipo = tpTitulo then
    begin
      Font.Style := Font.Style + [fsBold];
      //drawTxt(TituloIfIsIt, 0, Width);
      rec := Rect(2, 2, Width -2, Height -2);
      DrawText(Canvas.Handle, Pchar(TituloIfIsIt), Length(TituloIfIsIt), rec, DT_CENTER or DT_EXPANDTABS);
    end else
    begin
      if MngItem.Estatus = EITNormal then
        Font.Style := Font.Style + [fsBold];
      drawTxt(MngItem.Campo1, 0, LargC1);
      if (not Selecionado) and (MngItem.Estatus <> EITNormalOffModelo) then
      begin
        Font.Style := Font.Style - [fsBold];
        Brush.Color := clWhite;
        Font.Color := clBlack;
        rec := Rect(LargC1, 0, Width - 1, Height -1);
        FillRect(rec);
      end;
      drawTxt(MngItem.Campo2, LargC1 + 4, LargC2);
      MoveTo(0, Height -1);
      LineTo(Width -1, Height -1);
      LineTo(Width -1, 0);
      MoveTo(LargC1, 0);
      LineTo(LargC1, Height -1);
    end;
  end;
end;

procedure TFisicoItem.Refresh;
begin
  Invalidate;
end;

procedure TFisicoItem.SetMngItem(const Value: TMngTemplateItem);
begin
  FMngItem := Value;
end;

procedure TFisicoItem.SetSelecionado(const Value: boolean);
begin
  FSelecionado := Value;
  if FSelecionado then
  begin
    FPai.Selecione(Self);
  end;
  Invalidate;
end;

procedure TFisicoItem.SetTipo(const Value: TTipo);
begin
  FTipo := Value;
end;

procedure TFisicoItem.SetTituloIfIsIt(const Value: string);
begin
  FTituloIfIsIt := Value;
end;

end.
