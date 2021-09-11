unit uTemplFisico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, ExtCtrls, ActnList, ToolWin, ActnMan,
  ActnCtrls, XPStyleActnCtrls, FisicoMng, ImgList, ActnMenus, uTemplate, uAux, MER,
  System.Actions;

type
  TbrFmTmplFisico = class(TForm)
    Pg: TPageControl;
    ActionManager: TActionManager;
    acNovo: TAction;
    acEditar: TAction;
    acExcluir: TAction;
    Panel1: TPanel;
    btnFechar: TButton;
    TabCampos: TTabSheet;
    TabDominios: TTabSheet;
    TabCCampos: TTabSheet;
    TabCTab: TTabSheet;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    lvCampos: TListView;
    lvTipos: TListView;
    lvCCampos: TListView;
    lvCTab: TListView;
    ImgLst: TImageList;
    ToolBar5: TToolBar;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolBar2: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolBar3: TToolBar;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ActionMainMenuBar1: TActionMainMenuBar;
    Panel6: TPanel;
    Panel7: TPanel;
    arqImportar: TAction;
    arqExportar: TAction;
    acFechar: TAction;
    DDL: TTabSheet;
    PgDDL: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    edtDDLTabela_A: TEdit;
    edtDDLTabela_B: TEdit;
    edtDDLTabela_C: TEdit;
    edtDDLCampo: TEdit;
    Label5: TLabel;
    TabSheet3: TTabSheet;
    chkPkInDDL: TCheckBox;
    edtConstraintsNome: TEdit;
    rdNAONomerConst: TRadioButton;
    rdNomerConst: TRadioButton;
    chkFkInDDL: TCheckBox;
    Label2: TLabel;
    edtDDLTabela_Compl: TEdit;
    TabSheet4: TTabSheet;
    Label3: TLabel;
    edtSeparador: TEdit;
    Label4: TLabel;
    ddlAplicar: TAction;
    ToolBar4: TToolBar;
    ToolButton10: TToolButton;
    lvCuringas: TListView;
    procedure rdNAONomerConstClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ddlAplicarUpdate(Sender: TObject);
    procedure ddlAplicarExecute(Sender: TObject);
    procedure edtSeparadorChange(Sender: TObject);
    procedure chkPkInDDLClick(Sender: TObject);
    procedure rdNomerConstClick(Sender: TObject);
    procedure lvCamposDblClick(Sender: TObject);
    procedure arqExportarExecute(Sender: TObject);
    procedure arqImportarExecute(Sender: TObject);
    procedure acFecharExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure acNovoExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Mudou: boolean;
    MngTemplate: TMngTemplate;
    ModeloAtivo: TModelo;
    Procedure CarregueTemplate;
    Procedure NotifiqueModelo;
  end;

var
  brFmTmplFisico: TbrFmTmplFisico;

implementation

uses uEdtTemplFisico, uApp, uDM;

{$R *.dfm}

procedure TbrFmTmplFisico.acEditarExecute(Sender: TObject);
  var item: TMngTemplateItem;
      lv: TListView;
      gr: string;
      res: string;
      edt: TEdit;
begin
  BrFmEdtTemplFisico := TBrFmEdtTemplFisico.Create(self);
  BrFmEdtTemplFisico.Caption := BrFmEdtTemplFisico.Caption + ' [' + Pg.ActivePage.Caption + ']';
  edt := BrFmEdtTemplFisico.edtCampo1;
  BrFmEdtTemplFisico.Pg.ActivePage := BrFmEdtTemplFisico.TabOutros;
  case Pg.ActivePageIndex of
    fisicoTpCamposNome:
    begin
      lv := lvCampos;
      gr := fisicoCAMPOS;
      edt := BrFmEdtTemplFisico.edtCampo;
      BrFmEdtTemplFisico.Pg.ActivePage := BrFmEdtTemplFisico.TabCampo;
    end;
    fisicoTpCamposTipo:
    begin
      lv := lvTipos;
      gr := fisicoTIPOS;
    end;
    fisicoTpCamposCoplemento:
    begin
      lv := lvCCampos;
      gr := fisicoCOMPLEMENTO_CAMPOS;
    end;
    else // fisicoTpTabelaCoplemento:
    begin
      lv := lvCTab;
      gr := fisicoCOMPLEMENTO_TABELAS;
    end;
  end;
  if lv.Selected = nil then
  begin
    BrFmEdtTemplFisico.Free;
    Application.MessageBox('Não há nenhum item selecionado', 'Edição', MB_OK or MB_ICONWARNING);
    Exit;
  end;
  item := MngTemplate.FindCampo(lv.Selected.Caption, gr);
  edt.Text := item.Campo1;
  BrFmEdtTemplFisico.edtConvercao.Text := item.Campo2;
  if BrFmEdtTemplFisico.ShowModal = mrOk then
  begin
    if (edt.Text = '') then
    begin
      BrFmEdtTemplFisico.Free;
      Exit;
    end;
    if (edt.Text <> item.Campo1) and (MngTemplate.ExisteCampo(edt.Text, gr)) then
    begin
      Application.MessageBox('Já existe um outro "item" cadastrado com este nome!', PChar('Erro ao editar [' + Pg.ActivePage.Caption + ']'), MB_OK or MB_ICONERROR);
      BrFmEdtTemplFisico.Free;
      Exit;
    end;
    res := BrFmEdtTemplFisico.edtConvercao.Text;
    item.Campo1 := edt.Text;
    item.Campo2 := res;
    NotifiqueModelo;
    lv.Selected.Caption := edt.Text;
    lv.Selected.SubItems.Clear;
    lv.Selected.SubItems.Add(res);
    lv.Selected.ImageIndex := 8;
  end;
  BrFmEdtTemplFisico.Free;
end;

procedure TbrFmTmplFisico.acExcluirExecute(Sender: TObject);
  var item: TMngTemplateItem;
      lv: TListView;
begin
  case Pg.ActivePageIndex of
    fisicoTpCamposNome: lv := lvCampos;
    fisicoTpCamposTipo: lv := lvTipos;
    fisicoTpCamposCoplemento: lv := lvCCampos;
    else lv := lvCTab;
  end;
  if lv.Selected = nil then
  begin
    Application.MessageBox('Não há nenhum item selecionado', 'Exclusão', MB_OK or MB_ICONWARNING);
    Exit;
  end;
  if Application.MessageBox(
     pchar('Confirma a exclusão do item selecionado?'),
                            pchar(Pg.ActivePage.Caption),
                            MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) = mrYes then
  begin
    case Pg.ActivePageIndex of
      fisicoTpCamposNome:
      begin
        item := MngTemplate.FindCampo(lvCampos.Selected.Caption, fisicoCAMPOS);
        lvCampos.Items.Delete(lvCampos.Selected.Index);
      end;
      fisicoTpCamposTipo:
      begin
        item := MngTemplate.FindCampo(lvTipos.Selected.Caption, fisicoTIPOS);
        lvTipos.Items.Delete(lvTipos.Selected.Index);
      end;
      fisicoTpCamposCoplemento:
      begin
        item := MngTemplate.FindCampo(lvCCampos.Selected.Caption, fisicoCOMPLEMENTO_CAMPOS);
        lvCCampos.Items.Delete(lvCCampos.Selected.Index);
      end;
      else // fisicoTpTabelaCoplemento:
      begin
        item := MngTemplate.FindCampo(lvCTab.Selected.Caption, fisicoCOMPLEMENTO_TABELAS);
        lvCTab.Items.Delete(lvCTab.Selected.Index);
      end;
    end;
    item.Free;
    NotifiqueModelo;
  end;
end;

procedure TbrFmTmplFisico.acFecharExecute(Sender: TObject);
begin
  close;
end;

procedure TbrFmTmplFisico.acNovoExecute(Sender: TObject);
  var item: TMngTemplateItem;
      lv: TListView;
      gr: string;
      res: string;
      edt: TEdit;
begin
  BrFmEdtTemplFisico := TBrFmEdtTemplFisico.Create(self);
  BrFmEdtTemplFisico.Caption := BrFmEdtTemplFisico.Caption + ' [' + Pg.ActivePage.Caption + ']';
  edt := BrFmEdtTemplFisico.edtCampo1;
  BrFmEdtTemplFisico.Pg.ActivePage := BrFmEdtTemplFisico.TabOutros;
  case Pg.ActivePageIndex of
    fisicoTpCamposNome:
    begin
      lv := lvCampos;
      gr := fisicoCAMPOS;
      edt := BrFmEdtTemplFisico.edtCampo;
      BrFmEdtTemplFisico.Pg.ActivePage := BrFmEdtTemplFisico.TabCampo;
    end;
    fisicoTpCamposTipo:
    begin
      lv := lvTipos;
      gr := fisicoTIPOS;
    end;
    fisicoTpCamposCoplemento:
    begin
      lv := lvCCampos;
      gr := fisicoCOMPLEMENTO_CAMPOS;
    end;
    else // fisicoTpTabelaCoplemento:
    begin
      lv := lvCTab;
      gr := fisicoCOMPLEMENTO_TABELAS;
    end;
  end;
  if BrFmEdtTemplFisico.ShowModal = mrOk then
  begin
    if (edt.Text = '') then
    begin
      BrFmEdtTemplFisico.Free;
      Exit;
    end;
    res := BrFmEdtTemplFisico.edtConvercao.Text;
    if MngTemplate.ExisteCampo(edt.Text, gr) then
      Application.MessageBox('Já há um "item" cadastrado com este nome!', PChar('Erro ao cadastrar [' + Pg.ActivePage.Caption + ']'), MB_OK or MB_ICONERROR)
    else begin
      item := MngTemplate.Add(edt.Text, res, gr);
      NotifiqueModelo;
      with lv.Items.Add do
      begin
        Caption := item.Campo1;
        SubItems.Add(res);
        ImageIndex := 8;
      end;
    end;
  end;
  BrFmEdtTemplFisico.Free;
end;

procedure TbrFmTmplFisico.arqExportarExecute(Sender: TObject);
begin
  if (MngTemplate.Arq <> '') and (FileExists(MngTemplate.Arq)) then brDM.SaveXML.FileName := MngTemplate.Arq;
  with brDM.SaveXML do
    if Execute then
  begin
    if not MngTemplate.SalveToXML(FileName) then
    begin
      Application.MessageBox('Erro ao gravar o arquivo XML',
           'Falha na exportação da template', MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TbrFmTmplFisico.arqImportarExecute(Sender: TObject);
  var res: string;
begin
  if brDM.OpenXML.Execute then
  begin
    if Application.MessageBox('Confirma a substituição dos dados atuais pelos contidos no arquivo selecionado?',
    'Importar template de conversão', MB_YESNO or MB_DEFBUTTON1 or MB_ICONQUESTION) = mrYes then
    begin
      ModeloAtivo.Mudou := true;
      lvCampos.Items.Clear;
      lvTipos.Items.Clear;
      lvCCampos.Items.Clear;
      lvCTab.Items.Clear;
      res := MngTemplate.LoadFromXML(brDM.OpenXML.FileName);
      if res <> '' then
      begin
        Application.MessageBox(PChar('Erro ao abrir teplate. Erro: ' + res),
           'Falha na importação da template', MB_OK or MB_ICONERROR);
      end else
      begin
        CarregueTemplate;
      end;
    end;
  end;
end;

procedure TbrFmTmplFisico.CarregueTemplate;
  var i: Integer;
      itm: TMngTemplateItem;
  procedure lAdd(tli: TListView; it: TMngTemplateItem);
  begin
    with tli.Items.Add do
    begin
      Caption := it.Campo1;
      SubItems.Add(it.Campo2);
      ImageIndex := 8;
    end;
  end;
begin
  for I := 0 to MngTemplate.ComponentCount - 1 do
  begin
    itm := MngTemplate[i];
    if itm.Grupo = fisicoCAMPOS then lAdd(lvCampos, itm) else
    if itm.Grupo = fisicoTIPOS then lAdd(lvTipos, itm) else
    if itm.Grupo = fisicoCOMPLEMENTO_CAMPOS then lAdd(lvCCampos, itm) else
    if itm.Grupo = fisicoCOMPLEMENTO_TABELAS then lAdd(lvCTab, itm);
  end;
  edtDDLTabela_A.Text := MngTemplate.ddlCTab_A;
  edtDDLTabela_B.Text := MngTemplate.ddlCTab_B;
  edtDDLTabela_C.Text := MngTemplate.ddlCTab_C;
  edtDDLTabela_Compl.Text := MngTemplate.ddlCTab_Compl;
  edtDDLCampo.Text := MngTemplate.ddlCCamp;
  edtConstraintsNome.Text := MngTemplate.ddlCConst_Nome;
  edtSeparador.Text := MngTemplate.ddlSeparador;
  rdNomerConst.Checked := MngTemplate.ddlConst_Nomear;
  rdNAONomerConst.Checked := NOT MngTemplate.ddlConst_Nomear;
  edtConstraintsNome.Enabled := rdNomerConst.Checked;

  chkPkInDDL.Checked := MngTemplate.ddlPk_inTab;
  chkFkInDDL.Checked := MngTemplate.ddlFk_inTab;
  chkFkInDDL.Enabled := chkPkInDDL.Checked;
  
  Mudou := false;
end;

procedure TbrFmTmplFisico.chkPkInDDLClick(Sender: TObject);
begin
  Mudou := true;
  if not chkPkInDDL.Checked then
  begin
    chkFkInDDL.Checked := false;
    chkFkInDDL.Enabled := false;
  end else begin
    chkFkInDDL.Enabled := true;
  end;
end;

procedure TbrFmTmplFisico.ddlAplicarExecute(Sender: TObject);
begin
  MngTemplate.ddlCTab_A := edtDDLTabela_A.Text;
  MngTemplate.ddlCTab_B := edtDDLTabela_B.Text;
  MngTemplate.ddlCTab_C := edtDDLTabela_C.Text;
  MngTemplate.ddlCTab_Compl := edtDDLTabela_Compl.Text;
  MngTemplate.ddlCCamp := edtDDLCampo.Text;
  MngTemplate.ddlCConst_Nome := edtConstraintsNome.Text;
  MngTemplate.ddlSeparador := edtSeparador.Text;
  MngTemplate.ddlConst_Nomear:= rdNomerConst.Checked;
  MngTemplate.ddlPk_inTab := chkPkInDDL.Checked;
  MngTemplate.ddlFk_inTab := chkFkInDDL.Checked;
  NotifiqueModelo;
  Mudou := false;
end;

procedure TbrFmTmplFisico.ddlAplicarUpdate(Sender: TObject);
begin
  ddlAplicar.Enabled := Mudou;
end;

procedure TbrFmTmplFisico.edtSeparadorChange(Sender: TObject);
begin
  Mudou := true;
end;

procedure TbrFmTmplFisico.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Mudou then
  begin
    if Application.MessageBox('Houveram mudanças na aba DDL. Deseja manter as mudanças?',
      'DDL não aplicada', MB_YESNO or MB_DEFBUTTON1 or MB_ICONQUESTION) = mrYes then
    begin
      ddlAplicarExecute(Sender);
    end;
  end;
end;

procedure TbrFmTmplFisico.FormCreate(Sender: TObject);
begin
  ModeloAtivo := uApp.brFmPrincipal.Modelo;
  MngTemplate := ModeloAtivo.Template;
  MngTemplate.DXML := brDM.XMLDoc;
  Pg.ActivePageIndex := 1;
  PgDDL.ActivePageIndex := 0;
  CarregueTemplate;
  //Mudou := false; //no carregue
end;

procedure TbrFmTmplFisico.lvCamposDblClick(Sender: TObject);
begin
  acEditarExecute(Sender);
end;

procedure TbrFmTmplFisico.NotifiqueModelo;
begin
  ModeloAtivo.Mudou := true;
end;

procedure TbrFmTmplFisico.rdNAONomerConstClick(Sender: TObject);
begin
  Mudou := true;
  edtConstraintsNome.Enabled := rdNomerConst.Checked;
end;

procedure TbrFmTmplFisico.rdNomerConstClick(Sender: TObject);
begin
  Mudou := true;
  edtConstraintsNome.Enabled := rdNomerConst.Checked;
end;

end.
