unit trocaXsl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TXsl = class(TComponent)
  private
    Farq: string;
    FXsl: string;
    FDefaultXsl: string;
    procedure Setarq(const Value: string);
    procedure SetXsl(const Value: string);
    procedure SetDefaultXsl(const Value: string);
  public
    property DefaultXsl: string read FDefaultXsl write SetDefaultXsl;
    Property Xsl: string read FXsl write SetXsl;
    Property arq: string read Farq write Setarq;
  end;
  TbrFmInsXSL = class(TForm)
    GroupBox1: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    arq: TEdit;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    oxsl: TMemo;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure arqChange(Sender: TObject);
  private
    { Private declarations }
  public
    Xsl: TXsl;
    { Public declarations }
  end;

var
  brFmInsXSL: TbrFmInsXSL;

implementation

uses uDM;

{$R *.dfm}

{ TXsl }

procedure TXsl.Setarq(const Value: string);
begin
  if Value = FArq then Exit;
  Farq := Value;
  FXsl := '<?xml-stylesheet type="text/xsl" href="' + Farq + '"?>'
end;

procedure TXsl.SetDefaultXsl(const Value: string);
begin
  FDefaultXsl := Value;
  Xsl := Value;
end;

procedure TXsl.SetXsl(const Value: string);
  var tmp: string;
begin
  if Value = FXsl then exit;
  FXsl := Value;
  tmp := copy(FXsl, pos('href="', FXsl) + 4, length(FXsl));
  Farq := copy(tmp, 1, pos('"?>', tmp));
end;

procedure TbrFmInsXSL.SpeedButton2Click(Sender: TObject);
begin
  Xsl.Xsl := Xsl.DefaultXsl;
  close;
end;

procedure TbrFmInsXSL.FormCreate(Sender: TObject);
begin
  Xsl := TXsl.Create(self);
end;

procedure TbrFmInsXSL.SpeedButton4Click(Sender: TObject);
begin
  Xsl.Xsl := '';
  arq.Clear;
end;

procedure TbrFmInsXSL.SpeedButton5Click(Sender: TObject);
begin
  Xsl.arq := arq.Text;
  close;
end;

procedure TbrFmInsXSL.SpeedButton1Click(Sender: TObject);
  var f, d: string;
begin
  f := brDM.OpenXML.Filter;
  d := brDM.OpenXML.DefaultExt;
  brDM.OpenXML.Filter := 'Arquivo Xsl|*.xsl';
  brDM.OpenXML.DefaultExt := 'xsl';
  brDM.OpenXML.FileName := Xsl.arq;
  try
    with brDM.OpenXML do
      if Execute then
    begin
      arq.Text := FileName;
    end;
  except
  end;
  brDM.OpenXML.Filter := f;
  brDM.OpenXML.DefaultExt := d;
end;

procedure TbrFmInsXSL.FormShow(Sender: TObject);
begin
  oxsl.Text := Xsl.Xsl;
  arq.Text := Xsl.arq;
end;

procedure TbrFmInsXSL.arqChange(Sender: TObject);
begin
  if arq.Text = '' then oxsl.Text := '' else
    oxsl.Text := '<?xml-stylesheet type="text/xsl" href="' + arq.Text + '"?>'
end;

end.
