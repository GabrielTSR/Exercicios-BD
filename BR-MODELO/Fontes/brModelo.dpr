program brModelo;

uses
  Forms,
  SysUtils,
  uApp in 'uApp.pas' {brFmPrincipal},
  mer in 'mer.pas',
  uAux in 'uAux.pas',
  uDM in 'uDM.pas' {brDM: TDataModule},
  att in 'att.pas',
  fmodal in 'fmodal.pas' {brFmFModal},
  impressao in 'impressao.pas' {brFmImpress},
  relatorio in 'relatorio.pas',
  preview in 'preview.pas' {brFmForm_view},
  dic in 'dic.pas' {brFmDic},
  dicFull in 'dicFull.pas' {brFmDicFull},
  config in 'config.pas' {brFmCfg},
  CfgFonte in 'CfgFonte.pas' {brFmtCfgFonte},
  Questao in 'Questao.pas' {brFmQuestao},
  ajuda in 'ajuda.pas',
  xsl in 'xsl.pas' {brFmVisuXSLT},
  trocaXsl in 'trocaXsl.pas' {brFmInsXSL},
  dlg in 'dlg.pas' {brFmDlgSaveAll},
  uSobre in 'uSobre.pas' {brFmSobre},
  Inspector in 'Inspector.pas',
  uMemoria in 'uMemoria.pas',
  uRegistraExten in 'uRegistraExten.pas',
  BiLista in 'BiLista.pas',
  uFisico in 'uFisico.pas' {brFmFisico},
  FisicoMng in 'FisicoMng.pas',
  ShowFisico in 'ShowFisico.pas' {brFmShowFisico},
  uTemplFisico in 'uTemplFisico.pas' {brFmTmplFisico},
  uTemplate in 'uTemplate.pas',
  uEdtTemplFisico in 'uEdtTemplFisico.pas' {BrFmEdtTemplFisico},
  RibbonMarkup in 'Ribbon\RibbonMarkup.pas',
  ufrmSobre in 'ufrmSobre.pas' {frmSobre};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'brModelo 3.0';
  Application.CreateForm(TbrFmPrincipal, brFmPrincipal);
  Application.CreateForm(TbrFmCfg, brFmCfg);
  Application.CreateForm(TbrDM, brDM);
  Application.CreateForm(TbrFmFModal, brFmFModal);
  Application.CreateForm(TbrFmImpress, brFmImpress);
  Application.CreateForm(TbrFmtCfgFonte, brFmtCfgFonte);
  Application.CreateForm(TbrFmQuestao, brFmQuestao);
  Application.CreateForm(TbrFmDlgSaveAll, brFmDlgSaveAll);
  Application.Run;
end.
