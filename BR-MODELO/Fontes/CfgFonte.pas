unit CfgFonte;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, StdCtrls, ExtCtrls, uApp, ActnList,
  XPStyleActnCtrls, ActnMan, TypInfo, uDM, Buttons,  Tabs, uAux, System.Actions;

type
  TbrFmtCfgFonte = class(TForm)
    Janela: TPanel;
    Panel4: TPanel;
    OpcoesGerais: TPageControl;
    TabFont: TTabSheet;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    FontDlg: TFontDialog;
    ActionManager1: TActionManager;
    Fonte: TAction;
    ScrollBox1: TScrollBox;
    Font_style: TLabel;
    Font_width: TLabel;
    Font_name: TLabel;
    Pan: TPanel;
    font_cor: TLabel;
    Button1: TButton;
    ef_font: TLabel;
    NomeObj: TPanel;
    ToolButton3: TToolButton;
    procedure FontDlgApply(Sender: TObject; Wnd: HWND);
    procedure FonteExecute(Sender: TObject);
    procedure OpcoesGeraisChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FonteUpdate(Sender: TObject);
    procedure ScrollerClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    oldID: Integer;
  end;

var
  brFmtCfgFonte: TbrFmtCfgFonte;
  Scroller: TTabImg;

implementation

uses mer;

{$R *.dfm}

procedure TbrFmtCfgFonte.FontDlgApply(Sender: TObject; Wnd: HWND);
begin
  if brDM.Visual.Modelo.Selecionado <> nil then
    with brDM.Visual.Modelo do
  begin
    Font_name.Caption := 'Fonte: ' + FontDlg.Font.Name;
    Font_width.Caption := 'Tamanho: ' + IntToStr(FontDlg.Font.Size);
    Font_style.Caption := 'Estilo: ' +  SetToString(
                             GetPropInfo(FontDlg.Font, 'Style'),
                             GetOrdProp(FontDlg.Font,GetPropInfo(FontDlg.Font, 'Style')),
                             true);

    Selecionado.Font.Assign(FontDlg.Font);
    Selecionado.Canvas.Font.Assign(FontDlg.Font);
    Selecionado.FonteChanged;
    if (Selecionado is TEntidadeAssoss) then
    begin
      TEntidadeAssoss(Selecionado).Relacao.Font.Assign(FontDlg.Font);
      TEntidadeAssoss(Selecionado).Relacao.Canvas.Font.Assign(FontDlg.Font);
    end;
    Selecionado.Modelo.ResetFontFromSelecao;
    Pan.Color := FontDlg.Font.Color;
    Font_name.Font.Color := FontDlg.Font.Color;
    Font_width.Font.Color := FontDlg.Font.Color;
    Font_style.Font.Color := FontDlg.Font.Color;
  end;
end;

procedure TbrFmtCfgFonte.FonteExecute(Sender: TObject);
begin
  if brDM.Visual.Modelo.Selecionado <> nil then FontDlg.Font.Assign(brDM.Visual.Modelo.Selecionado.Font);
  with FontDlg do
    if Execute then
  begin
    FontDlgApply(sender, 0);
  end;
end;

procedure TbrFmtCfgFonte.OpcoesGeraisChange(Sender: TObject);
begin
  if OpcoesGerais.ActivePage = TabFont then
  begin
    if brDM.Visual.Modelo.Selecionado <> nil then
      with brDM.Visual.Modelo.Selecionado do
    begin
      oldID := brDM.Visual.Modelo.Selecionado.OID;
      Font_name.Caption := 'Fonte: ' + Font.Name;
      Font_width.Caption := 'Tamanho: ' + IntToStr(Font.Size);
      Font_style.Caption := 'Estilo: ' +  SetToString(
                             GetPropInfo(Font, 'Style'),
                             GetOrdProp(Font,GetPropInfo(Font, 'Style')),
                             true);
      Pan.Color := Font.Color;
      Font_name.Font.Color := Font.Color;
      Font_width.Font.Color := Font.Color;
      Font_style.Font.Color := Font.Color;
      font_cor.Font.Color := clBlack;
    end
    else
    begin
      oldID := -1;
      Font_name.Font.Color := clBtnFace;
      Font_width.Font.Color := clBtnFace;
      Font_style.Font.Color := clBtnFace;
      font_cor.Font.Color := clBtnFace;
      Pan.Color := clBtnFace;
      Font_name.Caption := 'Fonte: ';
      Font_width.Caption := 'Tamanho: ';
      Font_style.Caption := 'Estilo: ';
      Pan.Color := ScrollBox1.Color;
    end;
  end;
  if OpcoesGerais.ActivePageIndex <> Scroller.TabIndex then
  begin
    Scroller.TabIndex := OpcoesGerais.ActivePageIndex;
  end;
end;

procedure TbrFmtCfgFonte.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

procedure TbrFmtCfgFonte.FormCreate(Sender: TObject);
var i: integer;
begin
  oldID := -1;
  Scroller := TTabImg.Create(self);
  Scroller.OnTabClick := ScrollerClick;
  Scroller.Parent := Panel4;
  for i := 0 to OpcoesGerais.PageCount -1 do
  begin
    Scroller.Tabs.Add(OpcoesGerais.Pages[i].Caption);
  end;
  Scroller.TabIndex := 0;
  Scroller.Realinhe;
  ScrollerClick(Sender);
  ef_font.Font.Color := ef_font.Font.Color + 45;
  ef_font.Caption := #13 +  'Fonte';
end;

procedure TbrFmtCfgFonte.FormShow(Sender: TObject);
begin
  Scroller.Left := Panel4.Width - Scroller.Width - BorderWidth -2;
  if brDM.Visual.Modelo.Selecionado <> nil then
    NomeObj.Caption := 'Objeto: ' + Denominar(brDM.Visual.Modelo.Selecionado.ClassName) else
    NomeObj.Caption := '[Não selecionado]';
  OpcoesGeraisChange(Sender);
end;

procedure TbrFmtCfgFonte.FonteUpdate(Sender: TObject);
begin
  Fonte.Enabled := brDM.Visual.Modelo.Selecionado <> nil;
  if Fonte.Enabled and (brDM.Visual.Modelo.Selecionado.OID <> oldID) then OpcoesGeraisChange(sender);
end;

procedure TbrFmtCfgFonte.ScrollerClick(Sender: TObject);
begin
  OpcoesGerais.ActivePageIndex := Scroller.TabIndex;
end;

procedure TbrFmtCfgFonte.FormResize(Sender: TObject);
begin
  Scroller.Realinhe;
end;

procedure TbrFmtCfgFonte.Button1Click(Sender: TObject);
begin
  close;
end;

end.
