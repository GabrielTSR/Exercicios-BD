unit ShowFisico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ToolWin, ExtCtrls;

type
  TbrFmShowFisico = class(TForm)
    DDL: TRichEdit;
    StatusBar1: TStatusBar;
    SaveSQL: TSaveDialog;
    pnCommands: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DDLChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DDLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DDLSelectionChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FRW: TStringList;
    procedure SetRW(const Value: TStringList);
    { Private declarations }
  public
    Erro, Mudando : boolean;
    property RW: TStringList read FRW write SetRW;
    Function SalvarModelo: Boolean;
  end;

var
  brFmShowFisico: TbrFmShowFisico;

implementation

uses uApp;

{$R *.dfm}

procedure TbrFmShowFisico.Button1Click(Sender: TObject);
begin
  // Inicio TCC II
  // salva o modelo físico gerado
  SalvarModelo;
  // Fim TCC II
end;

procedure TbrFmShowFisico.Button2Click(Sender: TObject);
begin
  // Inicio TCC II
  // fecha a janela do modelo físico
  Close;
  // Fim TCC II
end;

procedure TbrFmShowFisico.DDLChange(Sender: TObject);
  var i, tmp, tam: Integer;
      StringaDaEvidenziare: string;
      Indice, LungTestoSorgente,
      LungTestoDaSostituire: Integer;
begin
  if RW = nil then Exit;
  if Mudando then Exit;
  Mudando := true;
  LockWindowUpdate(DDL.Handle);
  try
    tmp := DDL.SelStart;
    DDL.SelectAll;
    DDL.SelAttributes.Color := clWindowText;
    DDL.SelAttributes.Style := [fsBold];
    tam := DDL.SelLength;
    DDL.SelLength := 0;
    LungTestoSorgente := DDL.GetTextLen;
    for I := 0 to RW.Count - 1 do
    begin
      StringaDaEvidenziare := RW[i];
      LungTestoDaSostituire := Length(StringaDaEvidenziare);
      Indice := 0;
      repeat
        Indice := DDL.FindText(StringaDaEvidenziare, Indice, LungTestoSorgente, [stWholeWord, stMatchCase]);
        if Indice >= 0 then
        begin
          DDL.Perform(EM_SETSEL, Indice, Indice + LungTestoDaSostituire);
          DDL.SelAttributes.Color := clBlue;
          Inc(Indice, LungTestoDaSostituire);
        end;
      until Indice < 0;
    end;
    DDL.SelLength := 0;
    Indice := 0;
    repeat
      Indice := DDL.FindText('/*', Indice, LungTestoSorgente, []);
      LungTestoDaSostituire := 2 + DDL.FindText('*/', Indice + 2, LungTestoSorgente, []) - Indice;
      if (Indice >= 0) then
      begin
        if LungTestoDaSostituire < 0 then
        begin
          DDL.SelStart := Indice;
          DDL.SelLength := tam - (2 * Indice);
          LungTestoDaSostituire := DDL.SelLength;
        end else DDL.Perform(EM_SETSEL, Indice, Indice + LungTestoDaSostituire);
        DDL.SelAttributes.Color := clGreen;
        DDL.SelAttributes.Style := [fsItalic];
        Inc(Indice, LungTestoDaSostituire);
      end;
    until (Indice < 0);

    Indice := 0;
    repeat
      Indice := DDL.FindText('--', Indice, LungTestoSorgente, []);
      if Indice >= 0 then
      begin
        tam := Indice - SendMessage(DDL.Handle, EM_LINEINDEX, SendMessage(DDL.Handle, EM_LINEFROMCHAR, Indice, 0), 0);
        LungTestoDaSostituire := DDL.Perform(EM_LINELENGTH, Indice, -1) -tam;
        DDL.Perform(EM_SETSEL, Indice, Indice + LungTestoDaSostituire);
        DDL.SelAttributes.Color := clGreen;
        DDL.SelAttributes.Style := [fsItalic];
        Inc(Indice, LungTestoDaSostituire);
      end;
    until Indice < 0;

    DDL.SelStart := tmp;
  finally
    LockWindowUpdate(0);
  end;
  Mudando := false;
end;

procedure TbrFmShowFisico.DDLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if RW = nil then Exit;
  if (Shift = []) and (Key = VK_INSERT) then
    if StatusBar1.Panels[2].Text = 'ins' then
      StatusBar1.Panels[2].Text := 'ovr'
        else StatusBar1.Panels[2].Text := 'ins';
end;

procedure TbrFmShowFisico.DDLSelectionChange(Sender: TObject);
  var linha: integer;
begin
  if RW = nil then Exit;
  linha := SendMessage(DDL.Handle, EM_LINEFROMCHAR, DDL.SelStart, 0);
  StatusBar1.Panels[0].Text := FormatFloat('00',linha + 1) + ' de ' + FormatFloat('00', (SendMessage(DDL.Handle, EM_GETLINECOUNT, 0, 0)));
  StatusBar1.Panels[1].Text := FormatFloat('00', (DDL.SelStart - SendMessage(DDL.Handle, EM_LINEINDEX, linha, 0)) + 1);
end;

procedure TbrFmShowFisico.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
  var res: TModalResult;
begin
  if DDL.Modified then
  begin
    res := Application.MessageBox(PChar('Foram feitas alterações no modelo físico gerado. Deseja salvá-las?'), 'Salvar esquema físico',
                               MB_YESNOCANCEL or MB_ICONQUESTION or MB_DEFBUTTON1);
    if res = mrCancel then CanClose := false else
      if res = mrNo then CanClose := true else
        CanClose := SalvarModelo;
  end;

end;

procedure TbrFmShowFisico.FormCreate(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := 'ins';
  StatusBar1.Panels[2].Alignment := taCenter;
  StatusBar1.Panels[1].Alignment := taCenter;
  StatusBar1.Panels[0].Alignment := taCenter;
  Mudando := true;
end;

procedure TbrFmShowFisico.FormShow(Sender: TObject);
begin
  if Erro then
   Application.MessageBox('Verifique o log de conversão. Pelo menos uma inconsistência foi encontrada!', 'Falha(s) no processo de conversão', MB_ICONWARNING);
end;

function TbrFmShowFisico.SalvarModelo: Boolean;
begin
  // inicializa o retorno do método
  Result := False;

  with SaveSQL do begin
    // Inicio TCC II
    // seta a pasta de salvamento do modelo fisico
    InitialDir := sPhysicalModelDir;
    // Fim TCC II

    if Execute then
      try
        DDL.PlainText := True;
        DDL.Lines.SaveToFile(FileName);
        DDL.PlainText := False;
        DDL.Modified  := False;

        // retorno do método
        Result := True;
      except
        on E:Exception do
          Application.MessageBox(PChar('Falha ao salvar o Modelo Físico !!!' +
                                       'Descrição:' + #13 + '"' + E.Message + '".'),
                                       'Erro', MB_OK + MB_ICONERROR);
      end;  // except
  end;  // with SaveSQL do
end;

procedure TbrFmShowFisico.SetRW(const Value: TStringList);
  var i: Integer;
begin
  FRW := Value;
  FRW.Add('ALTER');
  FRW.Add('ADD');
  FRW.Add('FOREIGN');
  FRW.Add('KEY');
  FRW.Add('REFERENCES');
  FRW.Add('ON');
  FRW.Add('UPDATE');
  FRW.Add('SET');
  FRW.Add('NULL');
  FRW.Add('DELETE');
  FRW.Add('CASCADE');
  FRW.Add('RESTRICT');
  FRW.Add('ACTION');
  FRW.Add('DEFAULT');
  FRW.Delimiter := ' ';
  FRW.DelimitedText := StringReplace(FRw.Text, #$D#$A, ' ', [rfReplaceAll]);
//FRW.DelimitedText := StringReplace(FRw.Text, '(', ' ', [rfReplaceAll]);
//FRW.DelimitedText := StringReplace(FRw.Text, ')', ' ', [rfReplaceAll]);
  I := 0;
  while I < FRW.Count do
  begin
    if (FRW[i] = ')') or (FRW[i] = '(') or
       (FRW[i] = '[') or (FRW[i] = ']') or
       (FRW[i] = '}') or (FRW[i] = '{')
    then FRW.Delete(i) else inc(i);
  end;

  Mudando := false;
  DDLChange(nil);
  DDL.Modified := false;
end;

end.
