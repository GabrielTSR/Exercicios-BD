unit uEdtTemplFisico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TBrFmEdtTemplFisico = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Pg: TPageControl;
    TabCampo: TTabSheet;
    TabOutros: TTabSheet;
    edtCampo: TEdit;
    Label1: TLabel;
    edtCampo1: TEdit;
    lblDesc: TLabel;
    Label2: TLabel;
    edtConvercao: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BrFmEdtTemplFisico: TBrFmEdtTemplFisico;

implementation

{$R *.dfm}

end.
