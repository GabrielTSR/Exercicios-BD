unit fmodal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, uAux;

type
  TbrFmFModal = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    nome: TEdit;
    Label1: TLabel;
    multivalorado: TCheckBox;
    Identificador: TCheckBox;
    MinCard: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Tipo: TComboBox;
    Bevel1: TBevel;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    composto: TLabel;
    Pai: TComboBox;
    MaxCard: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure multivaloradoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    EmEdicao: LAttr;
    Procedure Monta;
    { Public declarations }
  end;

var
  brFmFModal: TbrFmFModal;

implementation

uses StrUtils;

{$R *.dfm}

procedure TbrFmFModal.Button2Click(Sender: TObject);
begin
  EmEdicao.Nome := nome.Text;
  EmEdicao.Tipo := Tipo.Text;
  if multivalorado.Checked then
  begin
    EmEdicao.Max := MaxCard.ItemIndex + 1;
    EmEdicao.Min := MinCard.ItemIndex;
  end
  else EmEdicao.Max := 0;
  EmEdicao.Multivalorado := multivalorado.Checked;
  EmEdicao.Identificador := Identificador.Checked;
end;

procedure TbrFmFModal.multivaloradoClick(Sender: TObject);
begin
  MaxCard.Enabled := multivalorado.Checked;
  MinCard.Enabled := multivalorado.Checked;
end;

procedure TbrFmFModal.FormCreate(Sender: TObject);
  var i: integer;
begin
  for i := 1 to 20 do MaxCard.Items.Add(FormatFloat('00', i));
  MaxCard.Items.Add('n');
  MaxCard.ItemIndex := 20;
end;

procedure TbrFmFModal.Monta;
begin
  nome.Text := EmEdicao.Nome;
  Tipo.Text := EmEdicao.Tipo;
  if EmEdicao.Max > 0 then
  begin
    MaxCard.ItemIndex := EmEdicao.Max -1;
    MinCard.ItemIndex := EmEdicao.Min;
  end
  else begin
    MaxCard.ItemIndex := 20;
    MinCard.ItemIndex := 1;
    MaxCard.Enabled := false;
    MinCard.Enabled := false;
  end;
  multivalorado.Checked := EmEdicao.Multivalorado;
  Identificador.Checked := EmEdicao.Identificador;
  composto.Caption := 'Composto: ' + IfThen(EmEdicao.Composto, 'Sim', 'Não');
end;

end.
