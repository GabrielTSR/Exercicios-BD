unit config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, StdCtrls, ExtCtrls, Buttons, Spin, filectrl;

type
  TbrFmCfg = class(TForm)
    Janela: TPanel;
    Panel4: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    SpinEdit1: TSpinEdit;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    dirLogico: TEdit;
    Label1: TLabel;
    sbSelecionarPastaLogico: TSpeedButton;
    Label3: TLabel;
    dirConceitual: TEdit;
    sbSelecionarPastaConceitual: TSpeedButton;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    tbRegistry: TTabSheet;
    Label6: TLabel;
    btnRegistrar: TButton;
    Label7: TLabel;
    Label8: TLabel;
    dirFisico: TEdit;
    sbSelecionarPastaFisico: TSpeedButton;
    procedure sbSelecionarPastaConceitualClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  brFmCfg: TbrFmCfg;

implementation

uses uApp, uDM, uRegistraExten;

{$R *.dfm}

// Inicio TCC II
procedure TbrFmCfg.btnRegistrarClick(Sender: TObject);
begin
  // se o usuário não confirmar, nada deve ser feito
  if (Application.MessageBox('Deseja associar a extensão brM aos arquivos do brModelo?'#13'[escreve no registro do sistema operacional]',
    'Associação de extensão de arquivo', MB_YESNO or MB_ICONQUESTION) <> mrYes) then Exit;

  try
    // registra a extensão no Windows Registry
    RegisterFileType('.brM', 'Arquivo do brModelo', 'extensão do arquivo do brModelo', ParamStr(0), 0, true)
  except
    on E:Exception do
      Application.MessageBox(PChar('Falha ao tentar registrar o brModelo no Windows Registry !!!' + #13#13 +
                                   'Descrição:' + #13 + '"' + E.Message + '".'), 'Erro', MB_OK + MB_ICONERROR);
  end;  // except
end;
// Fim TCC II

procedure TbrFmCfg.FormShow(Sender: TObject);
begin
  // Inicio TCC II
  // só habilita o botão de registro se o registro precisar ser realizado
  btnRegistrar.Enabled := not jaRegistrado('.brM');
  // Fim TCC II
end;

// Inicio TCC II
// método responsável por selecionar os diretórios de salvamento dos modelos
// da aplicação
procedure TbrFmCfg.sbSelecionarPastaConceitualClick(Sender: TObject);
var sDir: string;
begin
  // se não selecionar o diretório, nada deve ser feito
  if (not SelectDirectory('Selecione o Diretório', '', sDir)) then Exit;

  case (Sender as TSpeedButton).Tag of
    0 : dirConceitual.Text := sDir;
    1 : dirLogico.Text     := sDir;
    2 : dirFisico.Text     := sDir;
  end;  // case (Sender as TSpeedButton).Tag of
end;
// Fim TCC II

end.
