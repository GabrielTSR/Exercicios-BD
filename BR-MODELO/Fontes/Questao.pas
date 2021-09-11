unit Questao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TbrFmQuestao = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    btnAjuda: TButton;
    Button3: TButton;
    ScrollBox1: TScrollBox;
    Texto2: TRadioGroup;
    Panel2: TPanel;
    Texto1: TLabel;
    Image2: TImage;
    procedure btnAjudaClick(Sender: TObject);
  private
    FAjuda: integer;
    procedure SetAjuda(const Value: integer);
    { Private declarations }
  public
    Property Ajuda: integer read FAjuda write SetAjuda;
    { Public declarations }
  end;

var
  brFmQuestao: TbrFmQuestao;

implementation

uses ajuda;

{$R *.dfm}

procedure TbrFmQuestao.btnAjudaClick(Sender: TObject);
begin
  if Ajuda <> 0 then LoadAjuda(Ajuda) else ShowMessage('Ajuda indisponível para este tópico!');
end;

procedure TbrFmQuestao.SetAjuda(const Value: Integer);
begin
  FAjuda := Value;
  btnAjuda.Enabled := FAjuda <> 0;
end;

end.
