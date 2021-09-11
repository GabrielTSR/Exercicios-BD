unit xsl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, ToolWin, XMLIntf;

type
  TbrFmVisuXSLT = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    xslEdt: TMemo;
    ToolBar1: TToolBar;
    salvar: TToolButton;
    btnDefault: TToolButton;
    GroupBox1: TGroupBox;
    arq: TEdit;
    SpeedButton1: TSpeedButton;
    gera: TSpeedButton;
    ver: TMemo;
    SpeedButton2: TSpeedButton;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure salvarClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure geraClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure arqChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  brFmVisuXSLT: TbrFmVisuXSLT;
  xslDefault: String;

implementation

uses uApp, uDM;

{$R *.dfm}

procedure TbrFmVisuXSLT.salvarClick(Sender: TObject);
begin
  try
    xslEdt.Lines.SaveToFile(brFmPrincipal.Conf.appDir + 'brModelo.xsl');
  except
    brFmPrincipal.onErro(nil, 'Não foi possível salvar o arquivo XSL!' + #13 +
          'Arquivo: ' + brFmPrincipal.Conf.appDir + 'brModelo.xsl', 0);
  end;
end;

procedure TbrFmVisuXSLT.btnDefaultClick(Sender: TObject);
begin
  ShowMessage('O XSL default está preparado para transformar apenas esquemas lógicos!');
  if xslEdt.Lines.Text <> xslDefault then
  begin
    xslEdt.Lines.Text := xslDefault;
    salvarClick(sender);
  end;
end;

procedure TbrFmVisuXSLT.FormCreate(Sender: TObject);
begin
  xslDefault := xslEdt.Lines.Text;
  if FileExists(brFmPrincipal.Conf.appDir + 'brModelo.xsl') then
  begin
    try
      xslEdt.Lines.LoadFromFile(brFmPrincipal.Conf.appDir + 'brModelo.xsl');
    except
      brFmPrincipal.onErro(nil, 'Não foi possível carregar o arquivo XSL!' + #13 +
          '[Arquivo: ' + brFmPrincipal.Conf.appDir + 'brModelo.xsl]' + #13 +
          'O sistema usará o XSL default.', 0);
    end;
  end;
end;

procedure TbrFmVisuXSLT.geraClick(Sender: TObject);
  var ch: string;
begin
  if not FileExists(arq.Text) then
  begin
    brFmPrincipal.onErro(nil, 'Você deve selecionar um arquivo de esquema válido.', 0);
    exit;
  end;
  brDM.XMLDoc.XML.Clear;
  try
    brDM.XMLDoc.XML.LoadFromFile(arq.Text);
    brDM.XMLDoc.Active := true;
    ch := brDM.XMLDoc.DocumentElement.ChildNodes[0].ChildNodes.FindNode('Tipo').Attributes['Valor'];
    brDM.XMLDoc.Active := false;
    if brDM.XMLDoc.XML.Count = 0 then
    begin
      raise EOutOfResources.Create('');
    end;
    if copy(brDM.XMLDoc.XML[1], 1, 16) = '<?xml-stylesheet' then
      brDM.XMLDoc.XML.Delete(1);
  except
    brFmPrincipal.onErro(nil, 'Erro ao manipular o arquivo. Documento XML inválido!', 0);
    exit;
  end;

  brDM.SaveXML.InitialDir := brFmPrincipal.Conf.appDir;
  with brDM.SaveXML do
    if Execute then
  begin
    ch := ExtractFileName(FileName);
    ch := copy(ch, 1, length(ch) - length(ExtractFileExt(ch)));
    brDM.XMLDoc.XML.Insert(1, '<?xml-stylesheet type="text/xsl" href="' + ch + '.xsl"?>');
    try
      brDM.XMLDoc.XML.SaveToFile(FileName);
      xslEdt.Lines.SaveToFile(ExtractFilePath(FileName) + ch + '.xsl');
      brDM.XMLDoc.XML.Clear;
    except
      on EFcreateError do
      begin
        brFmPrincipal.onErro(nil, 'Erro ao salvar os arquivos. Processo finalizado!', 0);
        exit;
      end;
    end;
    ShowMessage('Operação concluída com sucesso!');
  end;
end;

procedure TbrFmVisuXSLT.SpeedButton1Click(Sender: TObject);
begin
  with brDM.OpenXML do
    if Execute then
  begin
    arq.Text := FileName;
  end;
end;

procedure TbrFmVisuXSLT.SpeedButton2Click(Sender: TObject);
begin
  ver.Visible := true;
  if not FileExists(arq.Text) then
  begin
    Application.MessageBox('Arquivo não encontrado!', 'Aviso: Visualização', mb_Ok or MB_ICONWARNING);
    exit;
  end;
  try
    ver.Lines.LoadFromFile(arq.Text);
    SpeedButton2.Enabled := false;
  except
    brFmPrincipal.onErro(nil, 'Não foi possível carregar o arquivo!' + #13 +
        '[Arquivo: ' + arq.Text + ']', 0);
  end;
end;

procedure TbrFmVisuXSLT.ToolButton1Click(Sender: TObject);
begin
  close;
end;

procedure TbrFmVisuXSLT.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ver.Lines.Clear;
  ver.Visible := false;
end;

procedure TbrFmVisuXSLT.arqChange(Sender: TObject);
begin
  ver.Lines.Clear;
  ver.Visible := false;
  SpeedButton2.Enabled := true;
end;

end.
