unit editSel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Dialogs,
  ExtCtrls, Forms, Contnrs, StdCtrls, Grids, uAux, MER, TypInfo, ValEdit;

  Type

  //apoio especializado para controlar o combo no Main.
  TMainCombo = class(TComponent)
  private
    Fvalor: String;
    FCombo: TComboBox;
    procedure SetCombo(const Value: TComboBox);
  Public
    Posicao: TPoint;
    Edt: TValueListEditor;
    Property Combo: TComboBox read FCombo write SetCombo;
    Property valor: String read Fvalor;
    Procedure Prepare(C, L: integer);
    Procedure Reposicione;
    Procedure OnChange(Sender: TObject);
  end;

  //valores........................................................
  TCoverItem = Class(TObject) //um valor
  protected
    Valor_Str: string;  //quase um caption para os itens
    Valor_Int: integer; //valor inteiro
  public
    constructor Create(vl_str: string; vl_int: integer);
  end;

  TConversor = class(TObject)  //pode reunir um grupo de valores possíveis acessados por um índice
  private
    Fitens: TObjectList;
    FCaption: String;
    FTipo: Integer;
    FPropriedade: string;
    Findice: integer;
    FValor: string; //int, str, ou bol, desativado, apenas leitura
    procedure SetCaption(const Value: String);
    procedure SetTipo(const Value: Integer);
    procedure SetPropriedade(const Value: string);
    procedure Setindice(const Value: integer);
    procedure SetValor(const Value: string);
    function GetValor: string;
  public
    property itens: TObjectList read Fitens;
    property indice: integer read Findice write Setindice;
    Function add(vl_str: string; vl_int: integer): TCoverItem;
    Function valor_str(index: integer = -1): string; //através de um índice, acessa o caption
    Function valor_int(index: integer = -1): integer; //''
    Function valor_bol(index: integer = -1): boolean; //pelo fato do item ser vl_str, vl_int o cojunto vl_str, vl_bool é preojudicado, por isso esta função é usada para representar os casos booleanos
    Property Caption: String read FCaption write SetCaption;
    Property Propriedade: string read FPropriedade write SetPropriedade;
    Property Tipo: Integer read FTipo write SetTipo;
    constructor Create;
    Destructor Destroy;override;
    Property Valor: string read GetValor write SetValor;
  end;

  TControlador = class(TComponent) //todos os itens de uma deterinada base
  private
    Fitens: TObjectList;
    FBase: TBase;
    procedure SetBase(const Value: TBase);
    Function FindByCaption(cap: string): TConversor;
  public
    property Base: TBase read FBase write SetBase;
    property itens: TObjectList read Fitens;
    Function ItemValor(index: integer): String;
    Function ItemTipo(index: integer): integer;
    Procedure ItemValores(index: integer; res: TStrings);
    Function add(prop, cap: string; tipo: integer): TConversor;
    Function SetValor(Cap, Valor: string): string;overload;
    Function SetValor(Cap: string; index: integer): string;overload;
    Function SetValor(C: TConversor; Valor: string): string;overload;
    constructor Create(Aowner: TComponent);override;
    Destructor Destroy;override;
    Procedure MakeColorsItem(C: TConversor);
    Procedure MakeTabViz(C: TConversor; aLista: TGeralList);
  end;

implementation

{ TConversor }

function TConversor.add(vl_str: string; vl_int: integer): TCoverItem;
begin
  Result := TCoverItem.Create(vl_str, vl_int);
  if isInteger(Valor) then
  begin
    if Result.Valor_Int = StrToInt(Valor) then
    begin
      indice := Fitens.Count;
      Valor := vl_str;
    end;
  end;
  Fitens.Add(Result);
end;

constructor TConversor.Create;
begin
  inherited;
  Fitens := TObjectList.Create(true);
  indice := -1;
end;

destructor TConversor.Destroy;
begin
  Fitens.Free;
  inherited;
end;

function TConversor.GetValor: string;
begin
  Result := FValor;
end;

procedure TConversor.SetCaption(const Value: String);
begin
  FCaption := Value;
end;

procedure TConversor.Setindice(const Value: integer);
begin
  Findice := Value;
end;

procedure TConversor.SetPropriedade(const Value: string);
begin
  FPropriedade := Value;
end;

procedure TConversor.SetTipo(const Value: Integer);
begin
  FTipo := Value;
  itens.Clear;
  if FTipo = tipo_booleano then
  begin
    itens.Add(TCoverItem.Create('Sim', 1));
    itens.Add(TCoverItem.Create('Não', 0));
  end;
end;

procedure TConversor.SetValor(const Value: string);
  var i: integer;
begin
  FValor := Value;
  if tipo = tipo_booleano then
    if LowerCase(Value) = 'sim' then
      indice := 0 else indice := 1;

  if tipo = tipo_multiplos then
    for i:= 0 to itens.Count -1 do
      if TCoverItem(itens[i]).Valor_Str = Value then
  begin
    indice := i;
    break;
  end;
end;

function TConversor.valor_bol(index: integer): boolean;
begin
  Result := False;
  if index = -1 then index := indice;
  if index = -1 then
  begin
    Result := LowerCase(Valor) = 'sim';
  end
  else
  if (index < Fitens.Count) and (index > -1) then
  begin
    Result := TCoverItem(Fitens[index]).Valor_Int = 1;
  end;
end;

function TConversor.valor_int(index: integer): integer;
begin
  Result := -1;
  if index = -1 then index := indice;
  if index = -1 then
  begin
    if not TryStrToInt(Valor, Result) then Result := -1;
  end
  else
  if (index < Fitens.Count) and (index > -1) then
  begin
    Result := TCoverItem(Fitens[index]).Valor_Int;
  end;
end;

function TConversor.valor_str(index: integer): string;
begin
  Result := '';
  if index = -1 then index := indice;
  if index = -1 then
  begin
    Result := Valor;
  end
  else
  if (index < Fitens.Count) and (index > -1) then
  begin
    Result := TCoverItem(Fitens[index]).Valor_Str;
  end;
end;

{ TCoverItem }

constructor TCoverItem.Create(vl_str: string; vl_int: integer);
begin
  inherited Create;
  Valor_Str := vl_str;
  Valor_Int := vl_int;
end;

{ TControlador }

function TControlador.add(prop, cap: string; tipo: integer): TConversor;
  var tmp: string;
begin
  Result := TConversor.Create;
  Result.Caption := cap;
  Result.Tipo := tipo;
  Result.Propriedade := prop;
  if prop = '' then Result.valor := cap else
  begin
    tmp := GetPropValue(base, prop);
    if (tipo = tipo_booleano) or (tipo = tipo_leitura) then
    begin
      if (LowerCase(tmp) = 'true') then tmp := 'Sim' else
      if (LowerCase(tmp) = 'false') then tmp := 'Não';
    end;
    Result.valor := tmp;
  end;
  Fitens.Add(Result);
end;

constructor TControlador.Create(Aowner: TComponent);
begin
  inherited;
  Fitens := TObjectList.Create(true);
end;

destructor TControlador.Destroy;
begin
  Fitens.Free;
  inherited;
end;

function TControlador.FindByCaption(cap: string): TConversor;
  var i: integer;
begin
  Result := nil;
  for i:= 0 to itens.Count -1 do
  begin
    if TConversor(itens[i]).Caption = cap then Result := TConversor(itens[i]);
  end;
end;

function TControlador.ItemTipo(index: integer): integer;
begin
  Result := -1;
  dec(index);
  if (index < Fitens.Count) and (index > -1) then
  begin
    Result := TConversor(Fitens[index]).Tipo;
  end;
end;

function TControlador.ItemValor(index: integer): String;
begin
  Result := '';
  dec(index);
  if (index < Fitens.Count) and (index > -1) then
  begin
    Result := TConversor(Fitens[index]).Valor;
  end;
end;

procedure TControlador.ItemValores(index: integer; res: TStrings);
  var c: TConversor;
      i: integer;
begin
  res.Clear;
  dec(index);
  if (index < Fitens.Count) and (index > -1) then
  begin
    C := TConversor(Fitens[index]);
    for i := 0 to c.itens.Count -1 do
    begin
      res.Add(TCoverItem(c.itens[i]).Valor_Str);
    end;
  end;
end;

procedure TControlador.MakeColorsItem(C: TConversor);
begin
  with c do
  begin
    add('Preto', clBlack);
    add('Marrom', clMaroon);
    add('Verde', clGreen);
    add('Oliva', clOlive);
    add('Navy', clNavy);
    add('Púrpura', clPurple);
    add('Teal', clTeal);
    add('Sinza', clGray);
    add('Prata', clSilver);
    add('Vermelho', clRed);
    add('Limão', clLime);
    add('Amarelo', clYellow);
    add('Azul', clBlue);
    add('Fuchsia', clFuchsia);
    add('Aqua', clAqua);
    add('Branco', clWhite);
    add('Amarelo II', 5558000);
//    add('Texto padrão', clBtnText);
    add('Verde dolar', clMoneyGreen);
    add('Azul céu', clSkyBlue);
    add('Creme', clCream);
  end;
end;

procedure TControlador.MakeTabViz(C: TConversor; aLista: TGeralList);
  var i: integer;
begin
  with c do
  begin
    add('<nenhum>', 0);
    for i := 0 to aLista.Lista.Count -1 do add(aLista[i].Texto, aLista[i].Tag);
  end;
end;

procedure TControlador.SetBase(const Value: TBase);
begin
  FBase := Value;
  itens.Clear;
end;

function TControlador.SetValor(Cap, Valor: string): string;
  var c: TConversor;
begin
  Result := '';
  if not Assigned(Base) then Exit;
  c := FindByCaption(cap);
  if not Assigned(c) then exit;
  Result := SetValor(C, Valor);
end;

function TControlador.SetValor(Cap: string; index: integer): string;
  var c: TConversor;
begin
  Result := '';
  if not Assigned(Base) then Exit;
  c := FindByCaption(cap);
  if not Assigned(c) then exit;
  Result := SetValor(C, TCoverItem(c.itens[index]).Valor_Str);
end;

function TControlador.SetValor(C: TConversor; Valor: string): string;
  var tmp : string;
begin
  tmp := c.Valor;
  c.Valor := Valor;
  Result := c.valor;
  try
    if c.Tipo = tipo_multiplos then
    SetPropValue(Base, c.Propriedade, c.valor_int);
    if c.Tipo = tipo_simples then
    SetPropValue(Base, c.Propriedade, c.valor_str);
    if c.Tipo = tipo_booleano then
    SetPropValue(Base, c.Propriedade, c.valor_bol);
    Base.Reenquadre;
  except
    on exception do
    begin
      Result := tmp;
      Base.Modelo.erro(base, 'Erro ao alterar o valor da propriedade "' + c.Caption +
      '" do objeto!', 0);
    end;
  end;
end;
{ TMainEdit }

procedure TMainCombo.OnChange(Sender: TObject);
begin
  Edt.Cells[Posicao.X, Posicao.Y] := Combo.Text;
  Fvalor := Combo.Text;
  Edt.OnValidate(Edt, Posicao.X, Posicao.Y, '', Fvalor);
  Combo.ItemIndex := Combo.Items.IndexOf(Edt.Cells[Posicao.X, Posicao.Y]);
end;

procedure TMainCombo.Prepare(C, L: integer);
begin
  Posicao.X := C;
  Posicao.Y := L;
  Combo.ItemIndex := Combo.Items.IndexOf(Edt.Cells[C, L]);
  Combo.Visible := true;
  Reposicione;
end;

procedure TMainCombo.Reposicione;
  var rec: TRect;
begin
  if not Combo.Visible then exit;
  rec := edt.CellRect(Posicao.X, Posicao.Y);
  Combo.SetBounds(rec.Left + 2, rec.Top + 2, rec.Right -rec.Left, rec.Bottom -rec.Top);
end;

procedure TMainCombo.SetCombo(const Value: TComboBox);
begin
  FCombo := Value;
  If not Assigned(FCombo) then exit;
  FCombo.OnChange := OnChange;
  FCombo.Visible := false;
end;

end.
