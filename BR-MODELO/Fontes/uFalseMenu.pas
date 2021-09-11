unit uFalseMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,Graphics, ExtCtrls,
  Printers, uAux, Contnrs, Forms;

  type

  TFMBar = class;

  TFMItem = class(TPaintBox)  //dependente.
  Private
    FPai: TFMBar;
    FIndex: integer;
    FOnItemClick: TNotifyEvent;
    procedure SetIndex(const Value: integer);
    procedure SetOnItemClick(const Value: TNotifyEvent);
  Protected
    procedure paint;override;
    procedure Click;override;
  Public
    constructor Create(AOwner: TComponent);override;
    property Index: integer read FIndex write SetIndex;
    Property OnItemClick: TNotifyEvent read FOnItemClick write SetOnItemClick;
  end;

  TFMBar = class(TScrollingWinControl)
  private
    FLista: TGeralListItem;
    FOnItemClick: TNotifyEvent;
    FItensMenu: TComponentList;
    procedure SetItensMenu(const Value: TComponentList);
    procedure SetLista(const Value: TGeralListItem);
    procedure SetOnItemClick(const Value: TNotifyEvent);
  Protected
  Public
    Property ItensMenu: TComponentList read FItensMenu write SetItensMenu;
    Property Lista: TGeralListItem read FLista write SetLista;
    Procedure Make;
    Property OnItemClick: TNotifyEvent read FOnItemClick write SetOnItemClick;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  end;

  TFalseMenu = class(TPanel)
  end;

implementation

uses Math, Types, Controls;

{ TFMItem }

procedure TFMItem.Click;
begin
//  inherited;
  If Assigned(FOnItemClick) then FOnItemClick(FPai.Lista[index].anexo);
end;

constructor TFMItem.Create(AOwner: TComponent);
begin
  inherited;
  FPai := TFMBar(AOwner);
end;

procedure TFMItem.paint;
  var Nome: string;
      Rect : TRect;
      I: integer;
begin
  inherited;
  Nome := FPai.Lista[index].Texto;
  with Canvas do
  begin
    Rect := GetClientRect;
    I := TextHeight('W');
    with Rect do
    begin
      Top := ((Bottom + Top) - I) div 2;
      Bottom := Top + I;
      Right := Right - 2;
      Left := 10;
    end;
    Brush.Style := bsClear;
    DrawText(Handle, PChar(Nome), -1, Rect, DT_LEFT);
  end;
end;

procedure TFMItem.SetIndex(const Value: integer);
begin
  FIndex := Value;
end;

procedure TFMItem.SetOnItemClick(const Value: TNotifyEvent);
begin
  FOnItemClick := Value;
end;

{ TFMBar }

constructor TFMBar.Create(AOwner: TComponent);
begin
  inherited;
  FItensMenu := TComponentList.Create(true);
  Lista := TGeralListItem.Create(Self);
  Brush.Style := bsClear;
end;

destructor TFMBar.Destroy;
begin
  FItensMenu.Free;
  inherited;
end;

procedure TFMBar.Make;
  var i: integer;
      FMI: TFMItem;
      lastTop: integer;
begin
  lastTop := 0;
  for i:= 0 to FLista.Lista.Count -1 do
  begin
    if FLista.Lista.Count > FItensMenu.Count then
    begin
      FMI := TFMItem.Create(Self);
      FMI.Index := FItensMenu.Count;
      if Assigned(FOnItemClick) then
        FMI.OnItemClick := OnItemClick;
      FMI.Parent := Self;
      FItensMenu.Add(FMI);
    end;
    TFMItem(FItensMenu[i]).SetBounds(0, lastTop, Width - 25, 20);
    lastTop := lastTop + 20 + 2;
  end;
end;

procedure TFMBar.SetItensMenu(const Value: TComponentList);
begin
  FItensMenu := Value;
end;

procedure TFMBar.SetLista(const Value: TGeralListItem);
begin
  FLista := Value;
end;

procedure TFMBar.SetOnItemClick(const Value: TNotifyEvent);
begin
  FOnItemClick := Value;
end;

end.
