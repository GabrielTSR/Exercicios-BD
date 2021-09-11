unit BiLista;

interface

uses Windows, SysUtils, Classes, Contnrs;

type
  TArrStr = Array of String;
  TBiLista = class(TComponent)
  private
    FLoading: boolean;
    FCodigo: TArrStr;
    FValor: TArrStr;
    FFileName: string;
    FCaseSencitive: boolean;
    FHeader: string;
    function GetChave(index: integer): string;
    function GetConteudo(index: integer): string;
    procedure SetChave(index: integer; const Value: string);
    procedure SetConteudo(index: integer; const Value: string);
    procedure SetHeader(const Value: string);
    procedure SetCaseSencitive(const Value: boolean);
    procedure SetFileName(const Value: string);
    function Conchetes(oCodigo: string): string;
  public
    function Add(oCodigo, oValor: String): integer;
    function Del(oCodigo: String): boolean;overload;
    function Del(oIndex: Integer): boolean;overload;
    function Codigo(byIndex: Integer): string;
    function Index(byCodigo: string): integer;
    function Valor(byCodigo: string): string; overload;
    function Valor(byIndex: Integer): string; overload;
    function LoadFromFile(oFileName: string = ''): boolean;
    function SaveToFile(oFileName: string = ''): boolean;
    procedure WriteTo(aLista: TStrings);
    procedure LoadFrom(aLista: TStrings);
    procedure Clear;
    Function Count: integer;
    Function CleanCodigo(index: integer): string;
    property FileName: string read FFileName write SetFileName;
    property CaseSencitive: boolean read FCaseSencitive write SetCaseSencitive;
    property Header: string read FHeader write SetHeader;
    property Chave[index: integer]: string read GetChave write SetChave;
    property Conteudo[index : integer]: string read GetConteudo write SetConteudo;default;
  end;

implementation

{ TBiLista }

function TBiLista.Add(oCodigo, oValor: String): integer;
  var c: integer;
begin
  if not FLoading then oCodigo := Conchetes(oCodigo);
  if high(FCodigo) = -1 then c := 1 else c := high(FCodigo) + 2;
  SetLength(FCodigo, c);
  SetLength(FValor, c);
  FCodigo[high(FCodigo)] := oCodigo;
  FValor[high(FCodigo)] := oValor;
  Result := high(FValor);
end;

function TBiLista.CleanCodigo(index: integer): string;
begin
  try
    Result := copy(FCodigo[Index], 2, length(FCodigo[Index])-2);
  except
    Result := '';
  end;
end;

procedure TBiLista.Clear;
begin
  SetLength(FCodigo, 0);
  SetLength(FValor, 0);
end;

function TBiLista.Codigo(byIndex: Integer): string;
begin
  Result := FCodigo[byIndex];
end;

function TBiLista.Conchetes(oCodigo: string): string;
begin
//  if (Length(oCodigo) < 2) or (oCodigo[1] <> '[') then oCodigo := '[' + oCodigo + ']' ELSE
//  if (oCodigo[Length(oCodigo)] <> ']') then oCodigo := oCodigo + ']';
  Result := '[' + oCodigo + ']';
end;

function TBiLista.Count: integer;
begin
  Result := high(FValor) + 1;
end;

function TBiLista.Del(oIndex: Integer): boolean;
  var i: integer;
begin
  Result := false;
  if (oIndex < 0) or (oIndex > High(FValor)) then exit;
  for I := oIndex to High(FValor) - 1 do  //-i por que há um i + 1
  begin
    FValor[i] := FValor[i + 1];
    FCodigo[i] := FCodigo[i + 1];
  end;
  SetLength(FValor, High(FValor));
  SetLength(FCodigo, High(FCodigo));
  Result := true;
end;

function TBiLista.GetChave(index: integer): string;
begin
  Result := FCodigo[index];
end;

function TBiLista.GetConteudo(index: integer): string;
begin
  Result := FValor[index];
end;

function TBiLista.Del(oCodigo: String): boolean;
begin
  Result := Del(Index(oCodigo));
end;

function TBiLista.Index(byCodigo: string): integer;
  var i: Integer;
begin
  byCodigo := Conchetes(byCodigo);
  Result := -1;
  if not CaseSencitive then
  begin
    byCodigo := AnsiUpperCase(byCodigo);
    for I := 0 to High(FCodigo) do
    begin
      if AnsiUpperCase(FCodigo[i]) = byCodigo then
      begin
        Result := i;
        break;
      end;
    end;
  end else
  for I := 0 to High(FCodigo) do
  begin
    if FCodigo[i] = byCodigo then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure TBiLista.LoadFrom(aLista: TStrings);
  var i, J: Integer;
      Tmp: string;
begin
  FLoading := true;
  J := -1;
  for I := 0 to aLista.Count - 1 do
  begin
    Tmp := Trim(aLista[i]);
    if (Length(Tmp) > 0) and (Tmp[1] = '#') then
    begin
      if (Length(Tmp) > 1) and (Tmp[2] = '#') then
      begin
        if FHeader <> '' then FHeader := FHeader + #$D#$A + TMP else FHeader := TMP;
      end;
      Continue; //comentário
    end;
    if (Length(Tmp) > 0) and (Tmp[1] = '[') and (Tmp[Length(Tmp)] = ']') then //chave
    begin
      J := Add(tmp, '');
    end else
    if J > -1 then
    begin
      if FValor[J] <> '' then FValor[J] := FValor[J] + #$D#$A + TMP else FValor[J] := TMP;
    end;
  end;
  FLoading := false;
end;

function TBiLista.LoadFromFile(oFileName: string): boolean;
  var strs: TStringList;
begin
  if oFileName = '' then oFileName := FileName;
  Result := true;
  strs := TStringList.Create;
  try
    strs.LoadFromFile(oFileName);
    FileName := oFileName;
    LoadFrom(strs);
  except
    Result := false;
  end;
  strs.Free;
end;

function TBiLista.SaveToFile(oFileName: string): boolean;
  var strs: TStringList;
begin
  if oFileName = '' then oFileName := FileName;
  Result := true;
  strs := TStringList.Create;
  WriteTo(strs);
  try
    strs.SaveToFile(oFileName);
    FileName := oFileName;
  except
    Result := false;
  end;
  strs.Free;
end;

procedure TBiLista.SetCaseSencitive(const Value: boolean);
begin
  FCaseSencitive := Value;
end;

procedure TBiLista.SetChave(index: integer; const Value: string);
begin
  FCodigo[index] := Value;
end;

procedure TBiLista.SetConteudo(index: integer; const Value: string);
begin
  FValor[index] := Value;
end;

procedure TBiLista.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TBiLista.SetHeader(const Value: string);
begin
  FHeader := Value;
end;

function TBiLista.Valor(byIndex: Integer): string;
begin
  Result := FValor[byIndex];
end;

procedure TBiLista.WriteTo(aLista: TStrings);
  var i: Integer;
begin
  if Header <> '' then aLista.Add(Header);
  for I := 0 to High(FCodigo) do
  begin
    aLista.Add(FCodigo[i]);
    aLista.Add(FValor[i]);
  end;
end;

function TBiLista.Valor(byCodigo: string): string;
begin
  Result := FValor[Index(byCodigo)];
end;

end.
