unit dic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, StdCtrls, ExtCtrls;

type
  TbrFmDic = class(TForm)
    nomeObj: TPanel;
    Dicionario: TMemo;
    Panel1: TPanel;
    alterarDic: TButton;
    Button2: TButton;
    procedure alterarDicClick(Sender: TObject);
    procedure ReverterDicClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  brFmDic: TbrFmDic;

implementation

{$R *.dfm}

procedure TbrFmDic.alterarDicClick(Sender: TObject);
begin
  ModalResult := mrOk;
  Close;
end;

procedure TbrFmDic.ReverterDicClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  close;
end;

end.

