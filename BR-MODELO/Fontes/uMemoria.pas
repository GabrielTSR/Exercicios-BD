unit uMemoria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Contnrs, ExtCtrls;

const
  TempoRefresh = 9; //+1 = n.º segundos do intervalo entre cópias

type
  TCtlMem = class(TComponent)
  private
    FModelo: TComponent;
    FTotal: integer;
    FAtual: integer;
    FContador: Integer;
    FNoAdd: Boolean;
    FInicio: integer;
    procedure SetInicio(const Value: integer);
    procedure SetContador(const Value: Integer);
    procedure SetAtual(const Value: integer);
    procedure SetTotal(const Value: integer);
    procedure SetModelo(const Value: TComponent);
  public
    Memorias: array [0..19] of TMemoryStream;
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    property Modelo: TComponent read FModelo write SetModelo;
    property Atual: integer read FAtual write SetAtual;
    property Inicio: integer read FInicio write SetInicio;
    property Total: integer read FTotal write SetTotal;
    Function PodeRefazer: boolean;
    Function PodeDesfazer: boolean;
    Procedure Add(Forcar: boolean = false);
    Function Desfazer: Boolean;
    Function Refazer: Boolean;
    Property Contador: Integer read FContador write SetContador;
    Function StrQtdDesfazer: String;
    Function StrQtdRefazer: String;
    Procedure Inicialize;
  end;

  TMemoria = class(TComponent)
  private
    FTimer: TTimer;
    FModelos: TComponentList;
    FMemorias: TComponentList;
    FAtivo: TCtlMem;
    function GetHabilitado: boolean;
    procedure SetHabilitado(const Value: boolean);
    procedure SetAtivo(const Value: TCtlMem);
    procedure SetMemorias(const Value: TComponentList);
    procedure SetModelos(const Value: TComponentList);
    Property Modelos: TComponentList read FModelos write SetModelos;
    Property Memorias: TComponentList read FMemorias write SetMemorias;
    Procedure OnTimer(Sender: TObject);
  public
    property Ativo: TCtlMem read FAtivo write SetAtivo;
    Procedure AtivarByModelo(oModelo: TComponent);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Procedure DeleteModelo(oModelo: TComponent);
    Procedure AddModelo(oModelo: TComponent);
    Function GetMemByModelo(oModelo: TComponent): TCtlMem;
    Function PodeRefazer: boolean;
    Function PodeDesfazer: boolean;
    Function Desfazer: Boolean;
    Function Refazer: Boolean;
    Procedure ForcerFliquer;
    Property Habilitar: boolean read GetHabilitado write SetHabilitado;
    Function StrQtdDesfazer: String;
    Function StrQtdRefazer: String;
    Procedure InitializeAtual;
  end;

implementation

uses MER;

{ TCtlMem }

procedure TCtlMem.Add(Forcar: boolean);
  var idx: integer;
      aMemoria: TMemoryStream;
      oModelo: TModelo;
begin
  if FNoAdd then exit;
  if Assigned(FModelo) then oModelo := TModelo(FModelo) else exit;
  if (oModelo.Fliquer <> FAtual) or Forcar then
  begin
    Inc(FAtual);
    if (FAtual - FInicio) > 19 then inc(FInicio);

    idx := (FAtual mod 20);
    if not Assigned(Memorias[idx]) then
      Memorias[idx]:= TMemoryStream.Create;
    aMemoria := Memorias[idx];
    aMemoria.Clear;
    aMemoria.SetSize(SizeOf(oModelo));
    aMemoria.WriteComponent(oModelo);
    aMemoria.Seek(0,0);
//    if FAtual <> FTotal then
//    begin
//      for I := (FAtual +1) to (FTotal) do
//      begin
//        idx := (i mod 20);
////        if Assigned(Memorias[idx]) then Memorias[idx].Free;
//      end;
//    end;
    FTotal := FAtual;
    oModelo.Fliquer := FAtual;
    Contador := 0;
  end;
end;

constructor TCtlMem.Create(AOwner: TComponent);
begin
  inherited;
  Total := -1;
  Atual := -1;
end;

function TCtlMem.Desfazer: Boolean;
  var idx: integer;
  oModelo: TModelo;
begin
  Result := PodeDesfazer;
  if not Result then Exit;
  oModelo := TModelo(FModelo);
  if oModelo.Fliquer <> FAtual then Add;
  FNoAdd := true;
  dec(FAtual);
  idx := ((FAtual) mod 20);
  oModelo.staLoading := True;
  oModelo.DestroyComponents;
  Memorias[idx].ReadComponent(oModelo);
  Memorias[idx].Seek(0,0);
  oModelo.Load;
  oModelo.Fliquer := FAtual;
  FContador := 0;
  oModelo.onSelect(nil);
  FNoAdd := false;
end;

destructor TCtlMem.Destroy;
  var i: Integer;
begin
  for I := 0 to 19 do
    if Assigned(Memorias[i]) then
      Memorias[i].Free;
  inherited;
end;

procedure TCtlMem.Inicialize;
begin
  FTotal := -1;
  FAtual := -1;
  FInicio := 0;
end;

function TCtlMem.PodeDesfazer: boolean;
begin
  Result := Assigned(FModelo) and ((Atual > Inicio) or ((Atual = Inicio) and (TModelo(FModelo).Fliquer <> Atual)));
end;

function TCtlMem.PodeRefazer: boolean;
begin
  Result := (Atual < Total) and Assigned(FModelo) and (TModelo(FModelo).Fliquer = Atual);
end;

function TCtlMem.Refazer: Boolean;
  var idx: integer;
  oModelo: TModelo;
begin
  Result := PodeRefazer;
  if not Result then Exit;
  FNoAdd := true;
  oModelo := TModelo(FModelo);
  inc(FAtual);
  idx := ((FAtual) mod 20);
  oModelo.staLoading := True;
  oModelo.DestroyComponents;
  Memorias[idx].ReadComponent(oModelo);
  Memorias[idx].Seek(0, 0);
  oModelo.Load;
  oModelo.Fliquer := Atual;
  FContador := 0;
  oModelo.onSelect(nil);
  FNoAdd := false;
end;

procedure TCtlMem.SetAtual(const Value: integer);
begin
  FAtual := Value;
end;

procedure TCtlMem.SetContador(const Value: Integer);
begin
  FContador := Value;
end;

procedure TCtlMem.SetInicio(const Value: integer);
begin
  FInicio := Value;
end;

procedure TCtlMem.SetTotal(const Value: integer);
begin
  FTotal := Value;
end;

function TCtlMem.StrQtdDesfazer: String;
begin
  Result := IntToStr(Atual - Inicio);
end;

function TCtlMem.StrQtdRefazer: String;
begin
  Result := IntToStr(Total - Atual);
end;

procedure TCtlMem.SetModelo(const Value: TComponent);
begin
  FModelo := Value;
end;

{ TMemoria }

procedure TMemoria.AddModelo(oModelo: TComponent);
  var M: TCtlMem;
begin
  Modelos.Add(oModelo);
  M := TCtlMem.Create(Self);
  M.Modelo := oModelo;
  Memorias.Add(M);
end;

procedure TMemoria.AtivarByModelo(oModelo: TComponent);
begin
  Ativo := GetMemByModelo(oModelo);
end;

constructor TMemoria.Create(AOwner: TComponent);
begin
  inherited;
  Memorias := TComponentList.Create(True);
  Modelos := TComponentList.Create(false);
  FTimer := TTimer.Create(Self);
  FTimer.Interval := 1000;
  FTimer.OnTimer := OnTimer;
  FTimer.Enabled := false;
end;

procedure TMemoria.DeleteModelo(oModelo: TComponent);
  var i : Integer;
begin
  i := Modelos.IndexOf(oModelo);
  if i > -1 then
  begin
    Modelos.Delete(i);
    Memorias.Delete(i);
  end;
end;

function TMemoria.Desfazer: Boolean;
begin
  Result := PodeDesfazer;
  if Result then Ativo.Desfazer;
end;

destructor TMemoria.Destroy;
begin
  FModelos.Free;
  FMemorias.Free;
  inherited;
end;

procedure TMemoria.ForcerFliquer;
begin
  if Assigned(Ativo) then
  begin
    Ativo.Add(True);
  end;
end;

function TMemoria.GetHabilitado: boolean;
begin
  Result := FTimer.Enabled;
end;

function TMemoria.GetMemByModelo(oModelo: TComponent): TCtlMem;
  var i: integer;
      M: TCtlMem;
begin
  Result := nil;
  for I := 0 to Memorias.Count - 1 do
  begin
    M := TCtlMem(Memorias[i]);
    if M.Modelo = oModelo then
    begin
      Result := M;
      Break;
    end;
  end;
end;

procedure TMemoria.InitializeAtual;
begin
  if Assigned(Ativo) then Ativo.Inicialize;
end;

procedure TMemoria.OnTimer(Sender: TObject);
  var i: integer;
      M: TCtlMem;
begin
  for I := 0 to Memorias.Count - 1 do
  begin
    M := TCtlMem(Memorias[i]);
    M.Contador := M.Contador + 1;
    if (M.Contador > TempoRefresh) and (Ativo = M) then M.Add;
  end;
end;

function TMemoria.PodeDesfazer: boolean;
begin
  Result := Assigned(Ativo) and Ativo.PodeDesfazer;
end;

function TMemoria.PodeRefazer: boolean;
begin
  Result := Assigned(Ativo) and Ativo.PodeRefazer;
end;

function TMemoria.Refazer: Boolean;
begin
  Result := PodeRefazer;
  if Result then Ativo.Refazer;
end;

procedure TMemoria.SetAtivo(const Value: TCtlMem);
begin
  FAtivo := Value;
end;

procedure TMemoria.SetHabilitado(const Value: boolean);
begin
  FTimer.Enabled := Value;
end;

procedure TMemoria.SetMemorias(const Value: TComponentList);
begin
  FMemorias := Value;
end;

procedure TMemoria.SetModelos(const Value: TComponentList);
begin
  FModelos := Value;
end;

function TMemoria.StrQtdDesfazer: String;
begin
  Result := '0';
  if (Ativo <> nil) then Result := Ativo.StrQtdDesfazer;
  if Result = '-1' then Result := '0';
end;

function TMemoria.StrQtdRefazer: String;
begin
  Result := '0';
  if (Ativo <> nil) then Result := Ativo.StrQtdRefazer;
end;

end.
