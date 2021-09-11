unit dicFull;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, ToolWin, StdCtrls,
  ExtCtrls, System.Actions;

type
  TbrFmDicFull = class(TForm)
    Dicionario: TRichEdit;
    StatusBar1: TStatusBar;
    ActionManager1: TActionManager;
    Fechar: TAction;
    Salvar: TAction;
    Imprimir: TAction;
    Panel1: TPanel;
    pnCommands: TPanel;
    btnSalvar: TButton;
    btnImprimir: TButton;
    btnFechar: TButton;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure Maker;
    { Public declarations }
  end;

var
  brFmDicFull: TbrFmDicFull;

implementation

uses uDM, DateUtils, uAux, mer;

{$R *.dfm}

procedure TbrFmDicFull.btnSalvarClick(Sender: TObject);
begin
  // Inicio TCC II
  // se não houver modelos, nada deve ser feito
  if brDM.Visual.Modelos.Count = 0 then Exit;

  // salva o dicionário de dados
  with brDM.SavaDic do begin
    FileName := brDM.Visual.Modelo.Nome;
    if (Execute) then
      try
        // salva o dicionário de dados
        Dicionario.Lines.SaveToFile(FileName);
      except
        on E:Exception do
          Application.MessageBox(PChar('Falha ao salvar o dicionário !!!' + #13#13 +
                                       'Descrição:' + #13 + '"' + E.Message + '".'),
                                       'Erro', MB_OK + MB_ICONERROR);
      end;  // except
  end;
  // Fim TCC II
end;

procedure TbrFmDicFull.btnImprimirClick(Sender: TObject);
begin
  // Inicio TCC II
  // imprime o dicionario de dados
  if (brDM.PrintDialog.Execute) then Dicionario.Print('[Dicionário de dados]');
  // Fim TCC II
end;

procedure TbrFmDicFull.btnFecharClick(Sender: TObject);
begin
  // Inicio TCC II
  // fecha a janela
  Close;
  // Fim TCC II
end;

procedure TbrFmDicFull.Maker;
  var Lst: TGeralList;
      I: integer;
begin
  if brDM.Visual.Modelos.Count = 0 then Exit;
  Lst := TGeralList.Create(nil);
  Dicionario.Lines.Clear;
  try
    brDM.Visual.Modelo.GetItens(Lst);
    for i := 0 to Lst.Lista.Count -1 do
    begin
      Dicionario.SelAttributes.Color := clBlue;
      Dicionario.SelAttributes.Style := [FsBold];
      Dicionario.Lines.Add(FormatFloat('000', i + 1) + ' - ' + Denominar(Lst[i].Referencia.ClassName) + ': ' + Lst[i].Texto);

      Dicionario.SelStart := Length(Dicionario.Text) - Length(Lst[i].Texto) -2;
      Dicionario.SelLength := Length(Lst[i].Texto);
      Dicionario.SelAttributes.Color := clTeal;

      Dicionario.SelAttributes.Color := clBlack;
      Dicionario.SelAttributes.Style := [];
      if TBase(Lst[i].Referencia).Dicionario <> '' then
        Dicionario.Lines.Add(TBase(Lst[i].Referencia).Dicionario);
      Dicionario.Lines.Add('');
    end;
  finally
    Lst.Free;
  end;
end;

end.
