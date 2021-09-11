unit dlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TbrFmDlgSaveAll = class(TForm)
    msgCaption: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Panel1: TPanel;
    msgTxt: TMemo;
    Image1: TImage;
  private
    { Private declarations }
  public
    function Msg(Nome: string; MaisDeUm: boolean = true): TModalResult;
    { Public declarations }
  end;

var
  brFmDlgSaveAll: TbrFmDlgSaveAll;

implementation

{$R *.dfm}

{ TdlgSaveAll }

function TbrFmDlgSaveAll.Msg(Nome: string; MaisDeUm: boolean): TModalResult;
begin
  msgTxt.Text := 'Deseja salvar as alterações no esquema "' + Nome + '"?';
  Button3.Enabled := MaisDeUm;
  Button4.Enabled := MaisDeUm;
  Result := Self.ShowModal;
end;

end.
