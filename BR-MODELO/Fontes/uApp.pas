unit uApp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, mer, StdCtrls, Buttons, ToolWin, ActnMan, ActnCtrls,
  ActnMenus, ComCtrls, ActnList, XPStyleActnCtrls, Grids, ValEdit, Mask,
  uAux, Tabs, editSel, StdActns, Menus, Spin, Inspector, uFisico, uTemplate,
  Vcl.Ribbon, Vcl.RibbonLunaStyleActnCtrls, Vcl.RibbonActnMenus, GraphUtil,
  UIRibbon, UIRibbonForm, UIRibbonCommands, Vcl.PlatformDefaultStyleActnCtrls,
  System.Actions;

  // Inicio TCC II
  // Alteração do título da aplicação
  const appCaption = 'brModelo 3.0 ';
  // Fim TCC II

type
  TbrFmPrincipal = class(TUIRibbonForm)
    pnMain: TPanel;
    Splitter1: TSplitter;
    Status: TStatusBar;
    Juntador: TPanel;
    PaiScroller: TPanel;
    Opcoes: TPageControl;
    TabSheet1: TTabSheet;
    Splitter2: TSplitter;
    PanEditor: TPanel;
    PanHelp: TPanel;
    lbl_ajuda: TLabel;
    TabSheet2: TTabSheet;
    ToolBar4: TToolBar;
    ao_Novo: TToolButton;
    ao_Editar: TToolButton;
    ToolButton17: TToolButton;
    ao_Excluir: TToolButton;
    TreeAtt: TTreeView;
    ToolBar5: TToolBar;
    ao_exibir: TToolButton;
    pb: TPanel;
    SplitterFDP: TSplitter;
    Box: TScrollBox;
    baseme: TPanel;
    ToolBar3: TToolBar;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    Panel2: TPanel;
    ToolBar2: TToolBar;
    Util: TRichEdit;
    ActionManager: TActionManager;
    arq_novo: TAction;
    arq_abrir: TAction;
    arq_fechar: TAction;
    arq_Salvar: TAction;
    arq_salvarc: TAction;
    sis_sair: TAction;
    criar_Entidade: TAction;
    criar_relacionamento: TAction;
    criar_GerEsp: TAction;
    criar_multiRelacao: TAction;
    criar_texto: TAction;
    SavarDT: TAction;
    ReverterDT: TAction;
    criar_Cancelar: TAction;
    criar_atributo: TAction;
    criar_ligacao: TAction;
    criar_altorelacionamento: TAction;
    del_base: TAction;
    Criar: TAction;
    Del: TAction;
    Criar_espA: TAction;
    Criar_espB: TAction;
    promo_ea: TAction;
    promo_entidade: TAction;
    ao_Ocultar: TAction;
    ac_orgAtt: TAction;
    Imprimir: TAction;
    edt_copy: TAction;
    edt_cut: TAction;
    edt_paste: TAction;
    mod_exibirHint: TAction;
    criar_attOpc: TAction;
    criar_attMult: TAction;
    criar_attComp: TAction;
    criar_attID: TAction;
    editarDic: TAction;
    covToRest: TAction;
    convToOpc: TAction;
    dicFull: TAction;
    Sobre: TAction;
    LCriar_tabela: TAction;
    LCriar_Relacao: TAction;
    LCriar_campo: TAction;
    LCriar_Fk: TAction;
    LCriar_K: TAction;
    cfg: TAction;
    LCriar_separador: TAction;
    editarDicL: TAction;
    exp_Logico: TAction;
    NovoLogico: TAction;
    Criar_TextoII: TAction;
    verLogs: TAction;
    limpar_logs: TAction;
    salva_logs: TAction;
    autoSalvar: TAction;
    act1: TAction;
    act2: TAction;
    act3: TAction;
    act4: TAction;
    act5: TAction;
    xsl_maker: TAction;
    selAtt: TAction;
    addXSLT: TAction;
    edt_Desfazer: TAction;
    edt_Refazer: TAction;
    aj_site: TAction;
    GerarFisico: TAction;
    fisicoTemplate: TAction;
    modExportBMP: TAction;
    modExportJPG: TAction;
    Exibir_fonte: TAction;
    MenuModelos: TPopupMenu;
    teste1: TMenuItem;
    MenuObjetos: TPopupMenu;
    ModeloOpc: TPopupMenu;
    Ocultar1: TMenuItem;
    org1: TMenuItem;
    Selecionaratributos1: TMenuItem;
    GerarModeloLgico1: TMenuItem;
    GerarEsquemaFsico1: TMenuItem;
    N3: TMenuItem;
    Copiar1: TMenuItem;
    Recortar1: TMenuItem;
    Colar1: TMenuItem;
    N2: TMenuItem;
    EditarFonte1: TMenuItem;
    Excluirseleo1: TMenuItem;
    N1: TMenuItem;
    ImprimirExportar1: TMenuItem;
    Salvar1: TMenuItem;
    Fechar1: TMenuItem;
    Editartemplatedeconvero1: TMenuItem;
    TimerAutoSava: TTimer;
    procedure modExportBMPExecute(Sender: TObject);
    procedure fisicoTemplateExecute(Sender: TObject);
    procedure GerarFisicoExecute(Sender: TObject);
    procedure edt_RefazerHint(var HintStr: string; var CanShow: Boolean);
    procedure edt_DesfazerHint(var HintStr: string; var CanShow: Boolean);
    procedure edt_RefazerExecute(Sender: TObject);
    procedure edt_DesfazerExecute(Sender: TObject);
    procedure edt_DesfazerUpdate(Sender: TObject);
    procedure sis_sairExecute(Sender: TObject);
    procedure ScrollerClick(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure Exibir_fonteExecute(Sender: TObject);
    procedure Exibir_fonteUpdate(Sender: TObject);
    procedure CriarExecute(Sender: TObject);
    procedure DelExecute(Sender: TObject);
    procedure criar_CancelarUpdate(Sender: TObject);
    procedure CriarUpdate(Sender: TObject);
    procedure criar_ligacaoUpdate(Sender: TObject);
    procedure promo_eaExecute(Sender: TObject);
    procedure promo_entidadeExecute(Sender: TObject);
    procedure TreeAttClick(Sender: TObject);
    procedure ao_NovoClick(Sender: TObject);
    procedure ao_EditarClick(Sender: TObject);
    procedure ao_ExcluirClick(Sender: TObject);
    procedure ao_exibirClick(Sender: TObject);
    procedure ao_OcultarExecute(Sender: TObject);
    procedure ac_orgAttExecute(Sender: TObject);
    procedure ImprimirExecute(Sender: TObject);
    procedure arq_SalvarExecute(Sender: TObject);
    procedure arq_salvarcExecute(Sender: TObject);
    procedure edt_copyExecute(Sender: TObject);
    procedure edt_cutExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure arq_fecharExecute(Sender: TObject);
    procedure arq_fecharUpdate(Sender: TObject);
    procedure arq_novoExecute(Sender: TObject);

    procedure ModelosSelect(Sender: TObject);

    procedure Navega(Sender: TObject);
    procedure arq_abrirExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mod_exibirHintExecute(Sender: TObject);
    procedure edt_pasteExecute(Sender: TObject);
    procedure StatusDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure Todos_modelosExecute(Sender: TObject);
    procedure Todos_objetosExecute(Sender: TObject);
    procedure MenuObjetosPopup(Sender: TObject);
    procedure MenuModelosPopup(Sender: TObject);
    procedure editarDicExecute(Sender: TObject);
    procedure covToRestExecute(Sender: TObject);
    procedure convToOpcExecute(Sender: TObject);
    procedure dicFullExecute(Sender: TObject);
    procedure SobreExecute(Sender: TObject);
    procedure LCriar_campoUpdate(Sender: TObject);
    procedure LCriar_RelacaoUpdate(Sender: TObject);
    procedure criar_EntidadeUpdate(Sender: TObject);
    procedure editarDicUpdate(Sender: TObject);
    procedure exp_LogicoExecute(Sender: TObject);
    procedure NovoLogicoExecute(Sender: TObject);
    procedure exp_LogicoUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure verLogsExecute(Sender: TObject);
    procedure limpar_logsExecute(Sender: TObject);
    procedure salva_logsExecute(Sender: TObject);
    procedure BoxMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure BoxMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure autoSalvarExecute(Sender: TObject);
    procedure autoSalvarUpdate(Sender: TObject);
    procedure TimerAutoSavaTimer(Sender: TObject);
    procedure cfgExecute(Sender: TObject);
    procedure act1Execute(Sender: TObject);
    procedure act1Update(Sender: TObject);
    procedure xsl_makerExecute(Sender: TObject);
    procedure SplitterFDPCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure selAttExecute(Sender: TObject);
    procedure ModeloOpcPopup(Sender: TObject);
    procedure addXSLTExecute(Sender: TObject);
    procedure Ribbon1HelpButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    // Inicio TCC II
    // Definição dos tipos de dados para a interface da aplicação
    fCmdBoolSelecionado                  : TUICommandBoolean;
    fCmdActSelecionado                   : TUICommandAction;

    fCmdRefazer                          : TUICommandAction;
    fCmdDesfazer                         : TUICommandAction;
    fCmdAutoSalvar                       : TUICommandBoolean;
    fCmdDocRecentes                      : TUICommandRecentItems;
    fCmdExportarJPEG                     : TUICommandAction;
    fCmdExportarBMP                      : TUICommandAction;
    fCmdSiteBrModelo                     : TUICommandAction;
    fCmdSobre                            : TUICommandAction;
    fCmdConfiguracoes                    : TUICommandAction;
    fCmdSair                             : TUICommandAction;
    fCmdNovoConceitual                   : TUICommandAction;
    fCmdNovoLogico                       : TUICommandAction;
    fCmdAbrir                            : TUICommandAction;
    fCmdSalvar                           : TUICommandAction;
    fCmdSalvarComo                       : TUICommandAction;
    fCmdFechar                           : TUICommandAction;
    fCmdImprimir                         : TUICommandAction;
    fCmdImprimirMais                     : TUICommandAnchor;
    fCmdGerarDicionario                  : TUICommandAction;
    fCmdVisualizarXML                    : TUICommandAction;
    fCmdExibirLog                        : TUICommandBoolean;
    fCmdLimparLog                        : TUICommandAction;
    fCmdSalvarLog                        : TUICommandAction;
    fCmdColar                            : TUICommandAction;
    fCmdRecortar                         : TUICommandAction;
    fCmdCopiar                           : TUICommandAction;
    fCmdSelecionarFonte                  : TUICommandAction;
    fCmdCancelarConceitual               : TUICommandBoolean;
    fCmdEntidadeMais                     : TUICommandAnchor;
    fCmdCriarEntidade                    : TUICommandBoolean;
    fCmdCriarRelacao                     : TUICommandBoolean;
    fCmdCriarEntidadeAssociativa         : TUICommandBoolean;
    fCmdAtributoMais                     : TUICommandAnchor;
    fCmdCriarAtributo                    : TUICommandBoolean;
    fCmdCriarAtributoIdentificador       : TUICommandBoolean;
    fCmdCriarAtributoMultivalorado       : TUICommandBoolean;
    fCmdCriarAtributoComposto            : TUICommandBoolean;
    fCmdCriarAtributoOpcional            : TUICommandBoolean;
    fCmdEspecializacaoMais               : TUICommandAnchor;
    fCmdCriarEspecializacao              : TUICommandBoolean;
    fCmdCriarEspecializacaoExcEntidade   : TUICommandBoolean;
    fCmdCriarEspecializacaoNaoExcEntidade: TUICommandBoolean;
    fCmdAutoRelacionar                   : TUICommandBoolean;
    fCmdLigarObjetos                     : TUICommandBoolean;
    fCmdCriarObservacao                  : TUICommandBoolean;
    fCmdExcluirSelecionadoConceitual     : TUICommandAction;
    fCmdOperacoesConceitualMais          : TUICommandAnchor;
    fCmdOcultarAtributo                  : TUICommandAction;
    fCmdOrganizarAtributos               : TUICommandAction;
    fCmdSelecionarAtributo               : TUICommandAction;
    fCmdPromoverEntidadeAssociativa      : TUICommandAction;
    fCmdPromoverEntidade                 : TUICommandAction;
    fCmdConverterEspParaRestrita         : TUICommandAction;
    fCmdConverterEspParaOpcional         : TUICommandAction;
    fCmdDicionarioDadosObjConceitual     : TUICommandAction;
    fCmdGerarEsquemaLogico               : TUICommandAction;
    fCmdCancelarLogico                   : TUICommandBoolean;
    fCmdCriarTabela                      : TUICommandBoolean;
    fCmdCriarRelacionamento              : TUICommandBoolean;
    fCmdCriarCampo                       : TUICommandBoolean;
    fCmdCriarChavePrimaria               : TUICommandBoolean;
    fCmdCriarChaveEstrangeira            : TUICommandBoolean;
    fCmdCriarSeparadosCampos             : TUICommandBoolean;
    fCmdOperacoesLogicoMais              : TUICommandAnchor;
    fCmdDicionarioDadosObjLogico         : TUICommandAction;
    fCmdIncluirAlterarXLS                : TUICommandAction;
    fCmdEditarTemplateConversao          : TUICommandAction;
    fCmdGerarEsquemaFisico               : TUICommandAction;

    // métodos necessários para a interface da aplicação
    procedure UpdateRibbonControls;
    procedure RecentItemSelect(const Command: TUICommandRecentItems;
      const Verb: TUICommandVerb; const ItemIndex: Integer;
      const Properties: TUICommandExecutionProperties);

  strict protected
    procedure CommandCreated(const Sender: TUIRibbon; const Command: TUICommand); override;
    procedure RibbonLoaded; override;
  // Fim TCC II

  public
    Conf: TConfigura;
    Modelo: TModelo;
    SemModelo: boolean;
    //MngTemplate: TMngTemplate;
    Procedure OnSelecao(b: TBase);
    Procedure OnBaseMouseMove(base: TBase);
    Procedure OnModeloMudou(Sender: TObject);
    procedure VisualMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
    Procedure Inicio;
    Procedure RefreshCfg;
    Procedure Questao(TextoA, TextoB: string;topico_ajuda: integer; var ResultadoSugestao: Integer);
    Procedure onErro(BaseSender: TBase; Texto: string; tipoErro: integer);
    Procedure RealizeChecagem;
    Function QuerSalvarOModelo(M: TModelo; YtoA: boolean = false; jaYtoA: boolean = false; jaNtoA: boolean = false) : integer;
    Procedure AtiveModelo;
    Procedure OnLoadProgress(Porcentagem: Integer);
    Procedure BaseBeginUpdate(Sender: TObject);
    Procedure BaseEndUpdate(Sender: TObject);
    Procedure VisualKeyPress(Sender: TObject; var key: char);
    Procedure CrieNovoModelo(tipoModelo: integer);
  end;

var
  brFmPrincipal: TbrFmPrincipal;
  //controle
  pEditor: TInspector;
  BaseEisSelecionadaNestaUnit, OverB: TBase;

  Tabs: TTabImg;
  ListaDeObj, ListaDeMer: TGeralList;

  AjudaArquivos, ListaDeTrabalho: TStringList;

  // Inicio TCC II
  // Diretórios da aplicação
  sAppDir           : string;
  sModelsDir        : string;
  sConceptModelDir  : string;
  sLogicalModelDir  : string;
  sPhysicalModelDir : string;
  // Fim TCC II

const S = 'Sim para todos';

implementation

uses Types, DateUtils, TypInfo, uDM, Math, fmodal, att, impressao,
  StrUtils, dic, dicFull, CfgFonte, Questao, ajuda, config, XMLDoc,
  xsl, trocaXsl, dlg, uMemoria, uTemplFisico,
  RibbonMarkup, ufrmSobre;

{$R *.dfm}
{$R 'Ribbon\RibbonMarkup.res'}

const _MOD_CONCEITUAL = 0;
      _MOD_LOGICO     = 1;


procedure TbrFmPrincipal.RecentItemSelect(const Command: TUICommandRecentItems;
    const Verb: TUICommandVerb; const ItemIndex: Integer;
    const Properties: TUICommandExecutionProperties);

          // método que reabre o arquivo cujo path completo é passado como
          // parâmetro
          procedure Reabrir(fileName: string);
          var M: TModelo;
          begin
            // o arquivo não foi encontrado. Deve-se avisar o usuário e excluído
            // da lista de itens recentes
            if (not FileExists(fileName)) then begin
              // informa ao usuário
              if (Application.MessageBox(PChar('O arquivo "' + ExtractFileName(fileName) + ' não foi encontrado !!!' + #13#13 +
                                               'Excluir esse arquivo da lista de arquivos recentes ?'),
                                               'Confirmação', MB_YESNO + MB_ICONWARNING) = IDYES) then begin
                // exclui o arquivo na lista de arquivos recentes
                Command.Items.Delete(ItemIndex);

                // exclui o arquivo da lista de arquivos recentes da configuração
                //brfmCfg.arquivos.Items.Delete(ItemIndex);
                Conf.Arq[ItemIndex + 1] := EmptyStr;
              end;  // if (Application.MessageBox(PChar('O arquivo "' +  ...

              Exit;
            end;  // if (not FileExists(fileName)) then

            // reabre o arquivo da maneira correta dependendo da situação atual
            if (not SemModelo) and (Modelo.Novo) and (not Modelo.Mudou) then begin
              if (not brDM.Visual.LoadFromFile(FileName, Modelo.Nome, Modelo)) then begin
                brDM.Visual.Fecha;
                arq_novoExecute(Self);
              end else begin
                brDM.Visual.Modelo.Mudou := false;
              end;  // else ...  if (not brDM.Visual.LoadFromFile(FileName, Modelo.Nome, Modelo)) then ...
            end else begin
              M := brDM.Visual.gera(FileName, false);
              if (Assigned(M)) then begin
                Modelo := M;
              end;  // if (Assigned(M)) then
            end;  // else ... if (not SemModelo) and (Modelo.Novo) and (not Modelo.Mudou) then ...

            Modelo := brDM.Visual.Modelo;
            if Assigned(Modelo) then AtiveModelo;
          end;  // procedure Reabrir

var sFileName: string;
begin
  // obtém o nome do arquivo a ser aberto
  sFileName := IncludeTrailingPathDelimiter(
                 TUIRecentItem(Command.Items[ItemIndex]).Description) +
               TUIRecentItem(Command.Items[ItemIndex]).LabelText;

  // reabre o arquivo selecionado
  Reabrir(sFileName);
end;

// método responsável por criar e realizar o "link" dos comandos do
// framework de interface
procedure TbrFmPrincipal.CommandCreated(const Sender: TUIRibbon;
  const Command: TUICommand);
var iIndex: integer;
    docRecente: TUIRecentItem;
begin
  inherited;

  // inicializa o comando atualmente criado
  fCmdActSelecionado  := nil;
  fCmdBoolSelecionado := nil;

  case Command.CommandId of
    cmdHeaderDocumentosRecentes: begin
      fCmdDocRecentes := (Command as TUICommandRecentItems);
      fCmdDocRecentes.OnSelect := RecentItemSelect;

      // carrega a lista de documentos recentes no menu de aplicação
      for iIndex := 1 to 5 do
        if (Conf.Arq[iIndex] <> EmptyStr) then begin
          // instancia o item que representa o documento recente corrente na lista
          docRecente := TUIRecentItem.Create;
          docRecente.LabelText   := ExtractFileName(Conf.Arq[iIndex]);
          docRecente.Description := ExtractFilePath(Conf.Arq[iIndex]);

          // adiciona o item recente ao menu
          fCmdDocRecentes.Items.Add(docRecente);
        end;  // if (Conf.Arq[iIndex] <> EmptyStr) then
    end;  // cmdHeaderDocumentosRecentes

    cmdDesfazer: begin
      fCmdDesfazer := (Command as TUICommandAction);
      fCmdDesfazer.ActionLink.Action := edt_Desfazer;
    end;  // cmdDesfazer

    cmdRefazer: begin
      fCmdRefazer := (Command as TUICommandAction);
      fCmdRefazer.ActionLink.Action := edt_Refazer;
    end; // cmdRefazer

    cmdAutoSalvar: begin
      fCmdAutoSalvar := (Command as TUICommandBoolean);
      fCmdAutoSalvar.ActionLink.Action := autoSalvar;
    end;  // cmdAutoSalvar

    cmdExportarJPEG: begin
      fCmdExportarJPEG := (Command as TUICommandAction);
      fCmdExportarJPEG.ActionLink.Action := modExportJPG;
    end;  // cmdExportarJPEG

    cmdExportarBMP: begin
      fCmdExportarBMP := (Command as TUICommandAction);
      fCmdExportarBMP.ActionLink.Action := modExportBMP;
    end;  // cmdExportarJPEG

    cmdSiteBrModelo: begin
      fCmdSiteBrModelo := (Command as TUICommandAction);
      fCmdSiteBrModelo.ActionLink.Action := aj_site;
    end;  // cmdSiteBrModelo

    cmdSobre: begin
      fCmdSobre := (Command as TUICommandAction);
      fCmdSobre.ActionLink.Action := Sobre;
    end;  // cmdSobre

    cmdConfiguracoes: begin
      fCmdConfiguracoes := (Command as TUICommandAction);
      fCmdConfiguracoes.ActionLink.Action := cfg;
    end;  // cmdConfiguracoes

    cmdSair: begin
      fCmdSair := (Command as TUICommandAction);
      fCmdSair.ActionLink.Action := sis_sair;
    end;  // cmdSair

    cmdNovoConceitual: begin
      fCmdNovoConceitual := (Command as TUICommandAction);
      fCmdNovoConceitual.ActionLink.Action := arq_novo;
    end;  // cmdNovoConceitual

    cmdNovoLogico: begin
      fCmdNovoLogico := (Command as TUICommandAction);
      fCmdNovoLogico.ActionLink.Action := NovoLogico;
    end;  // cmdNovoLogico

    cmdAbrir: begin
      fCmdAbrir := (Command as TUICommandAction);
      fCmdAbrir.ActionLink.Action := arq_abrir;
    end;  // cmdAbrir

    cmdSalvar: begin
      fCmdSalvar := (Command as TUICommandAction);
      fCmdSalvar.ActionLink.Action := arq_Salvar;
    end;  // cmdSalvar

    cmdSalvarComo: begin
      fCmdSalvarComo := (Command as TUICommandAction);
      fCmdSalvarComo.ActionLink.Action := arq_salvarc;
    end;  // cmdSalvarComo

    cmdFechar: begin
      fCmdFechar := (Command as TUICommandAction);
      fCmdFechar.ActionLink.Action := arq_fechar;
    end;  // cmdFechar

    cmdImprimir: begin
      fCmdImprimir := (Command as TUICommandAction);
      fCmdImprimir.ActionLink.Action := Imprimir;
    end;  // cmdImprimir

    cmdImprimirMais: begin
      fCmdImprimirMais := (Command as TUICommandAnchor);
      fCmdImprimirMais.ActionLink.Action := Imprimir;
    end;  // cmdImprimirMais

    cmdGerarDicionario: begin
      fCmdGerarDicionario := (Command as TUICommandAction);
      fCmdGerarDicionario.ActionLink.Action := dicFull;
    end;  // cmdGerarDicionario

    cmdVisualizarXML: begin
      fCmdVisualizarXML := (Command as TUICommandAction);
      fCmdVisualizarXML.ActionLink.Action := xsl_maker;
    end;  // cmdVisualizarXML

    cmdExibirLog: begin
      fCmdExibirLog := (Command as TUICommandBoolean);
      fCmdExibirLog.ActionLink.Action := verLogs;
    end;  // cmdExibirLog

    cmdLimparLog: begin
      fCmdLimparLog := (Command as TUICommandAction);
      fCmdLimparLog.ActionLink.Action := limpar_logs;
    end;  // cmdLimparLog

    cmdSalvarLog: begin
      fCmdSalvarLog := (Command as TUICommandAction);
      fCmdSalvarLog.ActionLink.Action := salva_logs;
    end;  // cmdSalvarLog

    cmdColar: begin
      fCmdColar := (Command as TUICommandAction);
      fCmdColar.ActionLink.Action := edt_paste;
    end;  // cmdColar

    cmdRecortar: begin
      fCmdRecortar := (Command as TUICommandAction);
      fCmdRecortar.ActionLink.Action := edt_cut;
    end;  // cmdRecortar

    cmdCopiar: begin
      fCmdCopiar := (Command as TUICommandAction);
      fCmdCopiar.ActionLink.Action := edt_copy;
    end;  // cmdCopiar

    cmdSelecionarFonte: begin
      fCmdSelecionarFonte := (Command as TUICommandAction);
      fCmdSelecionarFonte.ActionLink.Action := Exibir_fonte;
    end;  // cmdSelecionarFonte

    cmdCancelarConceitual: begin
      fCmdCancelarConceitual := (Command as TUICommandBoolean);
      fCmdCancelarConceitual.Tag := Tool_Nothing;
      fCmdCancelarConceitual.ActionLink.Action := criar_Cancelar;

      // informa o comando criado
      fCmdBoolSelecionado := (Command as TUICommandBoolean);
    end;  // cmdCancelarConceitual

    cmdEntidadeMais: begin
      fCmdEntidadeMais := (Command as TUICommandAnchor);
    end;  // fCmdEntidadeMais

    cmdCriarEntidade: begin
      fCmdCriarEntidade := (Command as TUICommandBoolean);
      fCmdCriarEntidade.Tag := Tool_Entidade;
      fCmdCriarEntidade.ActionLink.Action := criar_Entidade;
    end;  // cmdCriarEntidade

    cmdCriarRelacao: begin
      fCmdCriarRelacao := (Command as TUICommandBoolean);
      fCmdCriarRelacao.Tag := Tool_Relacionamento;
      fCmdCriarRelacao.ActionLink.Action := criar_relacionamento;
    end;  // cmdCriarRelacao

    cmdCriarEntidadeAssociativa: begin
      fCmdCriarEntidadeAssociativa := (Command as TUICommandBoolean);
      fCmdCriarEntidadeAssociativa.Tag := Tool_EntidadeAssoss;
      fCmdCriarEntidadeAssociativa.ActionLink.Action := criar_multiRelacao;
    end;  // cmdCriarEntidadeAssociativa

    cmdAtributoMais: begin
      fCmdAtributoMais := (Command as TUICommandAnchor);
    end;  // fCmdAtributoMais

    cmdCriarAtributo: begin
      fCmdCriarAtributo := (Command as TUICommandBoolean);
      fCmdCriarAtributo.Tag := Tool_Atributo;
      fCmdCriarAtributo.ActionLink.Action := criar_atributo;
    end;  // cmdCriarAtributo

    cmdCriarAtributoIdentificador: begin
      fCmdCriarAtributoIdentificador := (Command as TUICommandBoolean);
      fCmdCriarAtributoIdentificador.Tag := Tool_AtributoID;
      fCmdCriarAtributoIdentificador.ActionLink.Action := criar_attID;
    end;  // cmdCriarAtributoIdentificador

    cmdCriarAtributoMultivalorado: begin
      fCmdCriarAtributoMultivalorado := (Command as TUICommandBoolean);
      fCmdCriarAtributoMultivalorado.Tag := Tool_AtributoMult;
      fCmdCriarAtributoMultivalorado.ActionLink.Action := criar_attMult;
    end;  // cmdCriarAtributoMultivalorado

    cmdCriarAtributoComposto: begin
      fCmdCriarAtributoComposto := (Command as TUICommandBoolean);
      fCmdCriarAtributoComposto.Tag := Tool_AtributoComp;
      fCmdCriarAtributoComposto.ActionLink.Action := criar_attComp;
    end;  // cmdCriarAtributoComposto

    cmdCriarAtributoOpcional: begin
      fCmdCriarAtributoOpcional := (Command as TUICommandBoolean);
      fCmdCriarAtributoOpcional.Tag := Tool_AtributoOpc;
      fCmdCriarAtributoOpcional.ActionLink.Action := criar_attOpc;
    end;  // cmdCriarAtributoOpcional

    cmdCriarEspecializacao: begin
      fCmdCriarEspecializacao := (Command as TUICommandBoolean);
      fCmdCriarEspecializacao.Tag := Tool_Especializacao;
      fCmdCriarEspecializacao.ActionLink.Action := criar_GerEsp;
    end;  // cmdCriarEspecializacao

    cmdEspecializacaoMais: begin
      fCmdEspecializacaoMais := (Command as TUICommandAnchor);
    end;  // cmdEspecializacaoMais

    cmdCriarEspecializacaoExcEntidade: begin
      fCmdCriarEspecializacaoExcEntidade := (Command as TUICommandBoolean);
      fCmdCriarEspecializacaoExcEntidade.Tag := Tool_EspecializacaoA;
      fCmdCriarEspecializacaoExcEntidade.ActionLink.Action := Criar_espA;
    end;  // cmdCriarEspecializacaoExcEntidade

    cmdCriarEspecializacaoNaoExcEntidade: begin
      fCmdCriarEspecializacaoNaoExcEntidade := (Command as TUICommandBoolean);
      fCmdCriarEspecializacaoNaoExcEntidade.Tag := Tool_EspecializacaoB;
      fCmdCriarEspecializacaoNaoExcEntidade.ActionLink.Action := Criar_espB;
    end;  // cmdCriarEspecializacaoNaoExcEntidade

    cmdAutoRelacionar: begin
      fCmdAutoRelacionar := (Command as TUICommandBoolean);
      fCmdAutoRelacionar.Tag := Tool_AutoRel;
      fCmdAutoRelacionar.ActionLink.Action := criar_altorelacionamento;
    end;  // cmdAutoRelacionar

    cmdLigarObjetos: begin
      fCmdLigarObjetos := (Command as TUICommandBoolean);
      fCmdLigarObjetos.Tag := Tool_Ligacao;
      fCmdLigarObjetos.ActionLink.Action := criar_ligacao;
    end;  // cmdLigarObjetos

    cmdCriarObservacao: begin
      fCmdCriarObservacao := (Command as TUICommandBoolean);
      fCmdCriarObservacao.Tag := Tool_Texto;
      fCmdCriarObservacao.ActionLink.Action := criar_texto;
    end;  // cmdCriarObservacao

    cmdExcluirSelecionadoConceitual: begin
      fCmdExcluirSelecionadoConceitual := (Command as TUICommandAction);
      fCmdExcluirSelecionadoConceitual.ActionLink.Action := Del;
    end;  // cmdExcluirSelecionadoConceitual

    cmdOperacoesConceitualMais: begin
      fCmdOperacoesConceitualMais := (Command as TUICommandAnchor);
    end;  // cmdOperacoesConceitualMais

    cmdOcultarAtributo: begin
      fCmdOcultarAtributo := (Command as TUICommandAction);
      fCmdOcultarAtributo.ActionLink.Action := ao_Ocultar;
    end;  // cmdOcultarAtributo

    cmdOrganizarAtributos: begin
      fCmdOrganizarAtributos := (Command as TUICommandAction);
      fCmdOrganizarAtributos.ActionLink.Action := ac_orgAtt;
    end;  // cmdOrganizarAtributos

    cmdSelecionarAtributo: begin
      fCmdSelecionarAtributo := (Command as TUICommandAction);
      fCmdSelecionarAtributo.ActionLink.Action := selAtt;
    end;  // cmdSelecionarAtributo

    cmdPromoverEntidadeAssociativa: begin
      fCmdPromoverEntidadeAssociativa := (Command as TUICommandAction);
      fCmdPromoverEntidadeAssociativa.ActionLink.Action := promo_ea;
    end;  // cmdPromoverEntidadeAssociativa

    cmdPromoverEntidade: begin
      fCmdPromoverEntidade := (Command as TUICommandAction);
      fCmdPromoverEntidade.ActionLink.Action := promo_entidade;
    end;  // cmdPromoverEntidade

    cmdConverterEspParaRestrita: begin
      fCmdConverterEspParaRestrita := (Command as TUICommandAction);
      fCmdConverterEspParaRestrita.ActionLink.Action := covToRest;
    end;  // cmdConverterEspParaRestrita

    cmdConverterEspParaOpcional: begin
      fCmdConverterEspParaOpcional := (Command as TUICommandAction);
      fCmdConverterEspParaOpcional.ActionLink.Action := convToOpc;
    end;  // cmdConverterEspParaOpcional

    cmdDicionarioDadosObjConceitual: begin
      fCmdDicionarioDadosObjConceitual := (Command as TUICommandAction);
      fCmdDicionarioDadosObjConceitual.ActionLink.Action := editarDic;
    end;  // cmdDicionarioDadosObjConceitual

    cmdGerarEsquemaLogico: begin
      fCmdGerarEsquemaLogico := (Command as TUICommandAction);
      fCmdGerarEsquemaLogico.ActionLink.Action := exp_Logico;
    end;  // cmdGerarEsquemaLogico

    cmdCancelarLogico: begin
      fCmdCancelarLogico := (Command as TUICommandBoolean);
      fCmdCancelarLogico.Tag := Tool_Nothing;
      fCmdCancelarLogico.ActionLink.Action := criar_Cancelar;

      // informa o comando criado
      fCmdBoolSelecionado := (Command as TUICommandBoolean);
    end;  // cmdCancelarLogico

    cmdCriarTabela: begin
      fCmdCriarTabela := (Command as TUICommandBoolean);
      fCmdCriarTabela.Tag := Tool_LOGICO_Tabela;
      fCmdCriarTabela.ActionLink.Action := LCriar_tabela;
    end;  // cmdCriarTabela

    cmdCriarRelacionamento: begin
      fCmdCriarRelacionamento := (Command as TUICommandBoolean);
      fCmdCriarRelacionamento.Tag := Tool_LOGICO_Relacao;
      fCmdCriarRelacionamento.ActionLink.Action := LCriar_Relacao;
    end;  // cmdCriarRelacionamento

    cmdCriarCampo: begin
      fCmdCriarCampo := (Command as TUICommandBoolean);
      fCmdCriarCampo.Tag := Tool_LOGICO_campo;
      fCmdCriarCampo.ActionLink.Action := LCriar_campo;
    end;  // cmdCriarCampo

    cmdCriarChavePrimaria: begin
      fCmdCriarChavePrimaria := (Command as TUICommandBoolean);
      fCmdCriarChavePrimaria.Tag := Tool_LOGICO_K;
      fCmdCriarChavePrimaria.ActionLink.Action := LCriar_K;
    end;  // cmdCriarChavePrimaria

    cmdCriarChaveEstrangeira: begin
      fCmdCriarChaveEstrangeira := (Command as TUICommandBoolean);
      fCmdCriarChaveEstrangeira.Tag := Tool_LOGICO_FK;
      fCmdCriarChaveEstrangeira.ActionLink.Action := LCriar_Fk;
    end;  // cmdCriarChaveEstrangeira

    cmdCriarSeparadosCampos: begin
      fCmdCriarSeparadosCampos := (Command as TUICommandBoolean);
      fCmdCriarSeparadosCampos.ActionLink.Action := LCriar_separador;
    end;  // cmdCriarSeparadosCampos

    cmdOperacoesLogicoMais: begin
      fCmdOperacoesLogicoMais := (Command as TUICommandAnchor);
    end;  // cmdOperacoesLogicoMais

    cmdDicionarioDadosObjLogico: begin
      fCmdDicionarioDadosObjLogico := (Command as TUICommandAction);
      fCmdDicionarioDadosObjLogico.ActionLink.Action := editarDicL;
    end;  // cmdDicionarioDadosObjLogico

    cmdIncluirAlterarXLS: begin
      fCmdIncluirAlterarXLS := (Command as TUICommandAction);
      fCmdIncluirAlterarXLS.ActionLink.Action := addXSLT;
    end;  // cmdIncluirAlterarXLS

    cmdEditarTemplateConversao: begin
      fCmdEditarTemplateConversao := (Command as TUICommandAction);
      fCmdEditarTemplateConversao.ActionLink.Action := fisicoTemplate;
    end;  // cmdEditarTemplateConversao

    cmdGerarEsquemaFisico: begin
      fCmdGerarEsquemaFisico := (Command as TUICommandAction);
      fCmdGerarEsquemaFisico.ActionLink.Action := GerarFisico;
    end;  // cmdGerarEsquemaFisico
  end;

  UpdateRibbonControls;
end;

// método responsável por informar que o framework de interface está carregado
// e pronto para ser utilizado
procedure TbrFmPrincipal.RibbonLoaded;
begin
  inherited;

  // truque para que os controles apareceram corretamente depois do
  // ribbon
  height := height - 1;
  height := height + 1;

  // seta a cor de fundo do richedit de log
  Util.Color := Ribbon.BackgroundColor;

  // seta a cor dos splitters
  Splitter1.Color   := $00FF4242;
  Splitter2.Color   := $00FF4242;
  SplitterFDP.Color := $00FF4242;

  // atualiza o status dos controles
  UpdateRibbonControls;
end;

// método responsável por atualizar o status dos controles ribbons da interface
procedure TbrFmPrincipal.UpdateRibbonControls;
begin
  Exit;

  // menu arquivo
  if (Assigned(fCmdSalvar         )) then fCmdSalvar.Enabled          :=  (not SemModelo);
  if (Assigned(fCmdSalvarComo     )) then fCmdSalvarComo.Enabled      :=  (not SemModelo);
  if (Assigned(fCmdFechar         )) then fCmdFechar.Enabled          :=  (not SemModelo);
  if (Assigned(fCmdImprimirMais   )) then fCmdImprimirMais.Enabled    :=  (not SemModelo);
  if (Assigned(fCmdImprimir       )) then fCmdImprimir.Enabled        :=  (not SemModelo);
  if (Assigned(fCmdGerarDicionario)) then fCmdGerarDicionario.Enabled :=  (not SemModelo);
  if (Assigned(fCmdExportarJPEG   )) then fCmdExportarJPEG.Enabled    :=  (not SemModelo);
  if (Assigned(fCmdExportarBMP    )) then fCmdExportarBMP.Enabled     :=  (not SemModelo);
  if (Assigned(fCmdDesfazer       )) then fCmdDesfazer.Enabled        :=  (not SemModelo) and (brDM.Visual.Memoria.PodeDesfazer);
  if (Assigned(fCmdRefazer        )) then fCmdRefazer.Enabled         :=  (not SemModelo) and (brDM.Visual.Memoria.PodeRefazer );

  // desabilita todos os controles, independente da guia, caso não exista modelo
  if (SemModelo) then begin
    // modelo conceitual
    if (Assigned(fCmdCancelarConceitual               )) then fCmdCancelarConceitual.Enabled                := False;
    if (Assigned(fCmdEntidadeMais                     )) then fCmdEntidadeMais.Enabled                      := False;
    if (Assigned(fCmdCriarEntidade                    )) then fCmdCriarEntidade.Enabled                     := False;
    if (Assigned(fCmdCriarRelacao                     )) then fCmdCriarRelacao.Enabled                      := False;
    if (Assigned(fCmdCriarEntidadeAssociativa         )) then fCmdCriarEntidadeAssociativa.Enabled          := False;
    if (Assigned(fCmdCriarEspecializacao              )) then fCmdCriarEspecializacao.Enabled               := False;
    if (Assigned(fCmdCriarEspecializacaoExcEntidade   )) then fCmdCriarEspecializacaoExcEntidade.Enabled    := False;
    if (Assigned(fCmdCriarEspecializacaoNaoExcEntidade)) then fCmdCriarEspecializacaoNaoExcEntidade.Enabled := False;
    if (Assigned(fCmdAtributoMais                     )) then fCmdAtributoMais.Enabled                      := False;
    if (Assigned(fCmdCriarAtributo                    )) then fCmdCriarAtributo.Enabled                     := False;
    if (Assigned(fCmdCriarAtributoIdentificador       )) then fCmdCriarAtributoIdentificador.Enabled        := False;
    if (Assigned(fCmdCriarAtributoMultivalorado       )) then fCmdCriarAtributoMultivalorado.Enabled        := False;
    if (Assigned(fCmdCriarAtributoComposto            )) then fCmdCriarAtributoComposto.Enabled             := False;
    if (Assigned(fCmdCriarAtributoOpcional            )) then fCmdCriarAtributoOpcional.Enabled             := False;
    if (Assigned(fCmdAutoRelacionar                   )) then fCmdAutoRelacionar.Enabled                    := False;
    if (Assigned(fCmdLigarObjetos                     )) then fCmdLigarObjetos.Enabled                      := False;
    if (Assigned(fCmdCriarObservacao                  )) then fCmdCriarObservacao.Enabled                   := False;
    if (Assigned(fCmdExcluirSelecionadoConceitual     )) then fCmdExcluirSelecionadoConceitual.Enabled      := False;
    if (Assigned(fCmdOperacoesConceitualMais          )) then fCmdOperacoesConceitualMais.Enabled           := False;
    if (Assigned(fCmdOcultarAtributo                  )) then fCmdOcultarAtributo.Enabled                   := False;
    if (Assigned(fCmdOrganizarAtributos               )) then fCmdOrganizarAtributos.Enabled                := False;
    if (Assigned(fCmdSelecionarAtributo               )) then fCmdSelecionarAtributo.Enabled                := False;
    if (Assigned(fCmdPromoverEntidadeAssociativa      )) then fCmdPromoverEntidadeAssociativa.Enabled       := False;
    if (Assigned(fCmdPromoverEntidade                 )) then fCmdPromoverEntidade.Enabled                  := False;
    if (Assigned(fCmdConverterEspParaRestrita         )) then fCmdConverterEspParaRestrita.Enabled          := False;
    if (Assigned(fCmdConverterEspParaOpcional         )) then fCmdConverterEspParaOpcional.Enabled          := False;
    if (Assigned(fCmdDicionarioDadosObjConceitual     )) then fCmdDicionarioDadosObjConceitual.Enabled      := False;
    if (Assigned(fCmdGerarEsquemaLogico               )) then fCmdGerarEsquemaLogico.Enabled                := False;

    // modelo lógico
    if (Assigned(fCmdCancelarLogico                   )) then fCmdCancelarLogico.Enabled                    := False;
    if (Assigned(fCmdCriarTabela                      )) then fCmdCriarTabela.Enabled                       := False;
    if (Assigned(fCmdCriarRelacionamento              )) then fCmdCriarRelacionamento.Enabled               := False;
    if (Assigned(fCmdCriarCampo                       )) then fCmdCriarCampo.Enabled                        := False;
    if (Assigned(fCmdCriarChavePrimaria               )) then fCmdCriarChavePrimaria.Enabled                := False;
    if (Assigned(fCmdCriarChaveEstrangeira            )) then fCmdCriarChaveEstrangeira.Enabled             := False;
    if (Assigned(fCmdCriarSeparadosCampos             )) then fCmdCriarSeparadosCampos.Enabled              := False;
    if (Assigned(fCmdOperacoesLogicoMais              )) then fCmdOperacoesLogicoMais.Enabled               := False;
    if (Assigned(fCmdDicionarioDadosObjLogico         )) then fCmdDicionarioDadosObjLogico.Enabled          := False;
    if (Assigned(fCmdIncluirAlterarXLS                )) then fCmdIncluirAlterarXLS.Enabled                 := False;
    if (Assigned(fCmdEditarTemplateConversao          )) then fCmdEditarTemplateConversao.Enabled           := False;
    if (Assigned(fCmdGerarEsquemaFisico               )) then fCmdGerarEsquemaFisico.Enabled                := False;

    // opções
    if (Assigned(fCmdColar                            )) then fCmdColar.Enabled                             := False;
    if (Assigned(fCmdCopiar                           )) then fCmdCopiar.Enabled                            := False;
    if (Assigned(fCmdRecortar                         )) then fCmdRecortar.Enabled                          := False;
  end;  // if (SemModelo) then
end;
// Fim TCC II

procedure TbrFmPrincipal.Inicio;
  var dir, arq: String;
      i: integer;
      strs: TStringList;

      docRecente: TUICollectionItem;
begin
  // Inicio TCC II
  // Obtém os diretórios da aplicação
  sAppDir           := ExtractFilePath(ParamStr(0));
  sModelsDir        := IncludeTrailingPathDelimiter(sAppDir   ) + 'Modelos';
  sConceptModelDir  := IncludeTrailingPathDelimiter(sModelsDir) + '1 - Conceitual';
  sLogicalModelDir  := IncludeTrailingPathDelimiter(sModelsDir) + '2 - Logico';
  sPhysicalModelDir := IncludeTrailingPathDelimiter(sModelsDir) + '3 - Fisico';

  // cria os diretórios de modelos, caso ainda nao exista
  ForceDirectories(sModelsDir);
  ForceDirectories(sConceptModelDir);
  ForceDirectories(sLogicalModelDir);
  ForceDirectories(sPhysicalModelDir);
  // Fim TCC II

  Conf := TConfigura.Create(self);
  Conf.Menu[1]       := act1;
  Conf.Menu[2]       := act2;
  Conf.Menu[3]       := act3;
  Conf.Menu[4]       := act4;
  Conf.Menu[5]       := act5;
  Conf.Tempo         := 5;
  Conf.dirLogico     := sLogicalModelDir;
  Conf.dirConceitual := sConceptModelDir;
  Conf.appDir        := sAppDir;
  Conf.cfgFile       := IncludeTrailingPathDelimiter(sAppDir) + 'Conf.chc';
  Conf.ExibirLog     := false;
  Conf.showLHint     := true;

  // carrega o arquivo de configurações
  if (FileExists(Conf.cfgFile)) then begin
    try
      brDM.XMLDoc.LoadFromFile(Conf.cfgFile);
      brDM.XMLDoc.Active := true;
      Conf.LoadFromXML(brDM.XMLDoc.DocumentElement.ChildNodes);
    except
      onErro(nil, 'Erro ao abrir o arquivo de configuração!', 0);
    end;
  end;  // if (FileExists(Conf.cfgFile)) then

  if (Conf.Ajuda = '') then begin
    strs := TStringList.Create;
    AutoHelp(strs);
    Conf.Ajuda := strs.Text;
    strs.Free;
  end;  // if (Conf.Ajuda = '') then

  verLogs.Checked := Conf.ExibirLog;
  verLogsExecute(nil);
  RefreshCfg;
  mod_exibirHint.Checked := Conf.showLHint;
  AjudaArquivos := TStringList.Create;
  AjudaLocal := AjudaArquivos;
  brDM.Visual := TVisual.Create(self);
  brDM.Visual.Parent := Box;
  brDM.Visual.OnSelected := onSelecao;
  brDM.Visual.OnModeloQuestion := Questao;
  brDM.Visual.onBaseMouseMove := OnBaseMouseMove;
  brDM.Visual.OnMouseMove := VisualMouseMove;
  brDM.Visual.OnErro := onErro;
  brDM.Visual.DXML := brDM.XMLDoc;
  brDM.Visual.ModeloMudou := OnModeloMudou;
  brDM.Visual.OnLoadProgress := OnLoadProgress;
  brDM.Visual.PopupMenu := ModeloOpc;
  brDM.Visual.Writer := TWriterMsg.Create(self);
  brDM.Visual.ImgLisa := brDM.img;
  Util.Lines.Clear;
  brDM.Visual.Writer.Writer := Util;

  pEditor := TInspector.Create(PanEditor);
  pEditor.Align := alClient;
  pEditor.onBeginUpdateBase := BaseBeginUpdate;
  pEditor.onEndUpdateBase := BaseEndUpdate;
  pEditor.EnviadorDeFocus := brDM.Visual;
  pEditor.Ajuda.LabelAjuda := lbl_ajuda;
  brDM.Visual.OnKeyPress := VisualKeyPress;

  Tabs := TTabImg.Create(Self);
  Tabs.Parent := PaiScroller;
  Tabs.OnTabClick := ScrollerClick;
  Tabs.Tabs.Add(TabSheet1.Caption);
  Tabs.Tabs.Add(TabSheet2.Caption);
  Tabs.TabIndex := 0;
  Tabs.Realinhe;

  criar_Entidade.Tag := Tool_Entidade;
  criar_relacionamento.Tag := Tool_Relacionamento;
  criar_GerEsp.Tag := Tool_Especializacao;
  Criar_espA.Tag := Tool_EspecializacaoA;
  Criar_espB.Tag := Tool_EspecializacaoB;
  criar_multiRelacao.Tag := Tool_EntidadeAssoss;
  criar_texto.Tag := Tool_Texto;
  criar_textoII.Tag := Tool_TextoII;
  criar_Cancelar.Tag := Tool_Nothing;

  criar_atributo.Tag := Tool_Atributo;
  criar_attOpc.Tag := Tool_AtributoOpc;
  criar_attMult.Tag := Tool_AtributoMult;
  criar_attComp.Tag := Tool_AtributoComp;
  criar_attID.Tag := Tool_AtributoID;

  criar_ligacao.Tag := Tool_Ligacao;
  criar_altorelacionamento.Tag := Tool_AutoRel;
  del_base.Tag := Tool_Del;

  LCriar_tabela.Tag := Tool_LOGICO_Tabela;
  LCriar_Relacao.Tag := Tool_LOGICO_Relacao;
  LCriar_campo.Tag := Tool_LOGICO_campo;
  LCriar_Fk.Tag := Tool_LOGICO_FK;
  LCriar_K.Tag := Tool_LOGICO_K;
  LCriar_separador.Tag := Tool_LOGICO_Separador;

  ListaDeObj := TGeralList.Create(Self);
  ListaDeMer := TGeralList.Create(Self);

  arq_novoExecute(Self);//criação do primeiro modelo
  ScrollerClick(nil);
  if ParamCount > 0 then
  begin
    arq := ParamStr(1);
    if not brDM.Visual.LoadFromFile(Arq, Modelo.Nome, Modelo) then
    begin
      brDM.Visual.Fecha;
      arq_novoExecute(Self);
    end else
    begin
      brDM.Visual.Modelo.Mudou := false;
    end;
    Modelo := brDM.Visual.Modelo;
    if not Assigned(Modelo) then exit;
    AtiveModelo;
  end;
  brDM.Visual.Memoria.Habilitar := true;
end;

procedure TbrFmPrincipal.sis_sairExecute(Sender: TObject);
begin
  close;
end;

procedure TbrFmPrincipal.ScrollerClick(Sender: TObject);
begin
  Opcoes.ActivePageIndex := Tabs.TabIndex;
end;

procedure TbrFmPrincipal.Splitter1Moved(Sender: TObject);
begin
  Tabs.Realinhe;
end;

procedure TbrFmPrincipal.Splitter1CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  Accept := NewSize > 30;
end;

procedure TbrFmPrincipal.OnSelecao(b: TBase);
  var itm: Inspector.TAbs;
      EA: TEntidadeAssoss;
      CA: TCardinalidade;
      AT: TAtributo;
      TP: TKind;
      ES: TEspecializacao;
      BR: TBaseRelacao;
      CM, CM2: TCampo;
      i, j, m: integer;
      TB: TTabela;
      TX: TTexto;
      tmp: string;

      // Início TCC II - Puc (MG) - Daive Simões
      iIndex: Integer;
      // Fim TCC II
begin
  TreeAtt.Items.Clear;
  if Modelo.Selecionado <> nil then Modelo.Selecionado.AOcultos.Popule(TreeAtt, nil);
  TreeAttClick(b);

  Modelo.BaseHint.Visible := false;
  OverB := nil;
  if (b = nil) and (Modelo <> nil) then
  begin
    With pEditor do begin
      pEditor.Base := Modelo;
      itm := item[0];
      tmp := AnsiLowerCase(Modelo.GetStrTipoDeModelo);
      tmp[1] := UpCase(tmp[1]);
      itm.Caption := 'Informações: Modelo ' + tmp;
      itm.Tipo := tpTitulo;
      item[1].Setar('Nome', 'Nome', Modelo.Nome, tpReadOnly, 'NOME MODELO');
      item[2].Setar('Versao','Versão', Modelo.versao, tpReadOnly);
      item[3].Setar('Autor','Autor(es)', Modelo.Autor, tpEditor);
      item[4].Setar('Observacao', 'Observações', Modelo.Observacao, tpEditor);
    end;
    pEditor.Show;
    RealizeChecagem;
    exit;
  end;

  pEditor.Base := b;
  if b = nil then  exit;
  With pEditor do begin
    item[0].SetAsTitulo('Edição: ' + Denominar(B.ClassName));//converter e pegar o nome amigável...
    item[1].Setar('Nome', 'Nome', b.Nome, tpTexto, 'NOME');
    item[2].Setar('Observacoes', 'Observação', b.Observacoes, tpEditor, 'OBS');
//    item[3].Setar('OID', 'ID', IntToStr(b.OID), tpReadOnly, 'ID');
    item[3].SetAsTitulo('Posição e Tamanho');
    item[4].Setar('Left', 'Esquerda (Left)', IntToStr(b.Left), tpNumero, 'ALINHAMENTOLT');
    item[5].Setar('Top', 'Acima (Top)', IntToStr(b.Top), tpNumero, 'ALINHAMENTOLT');
    item[6].Setar('Width', 'Largura (Width)', IntToStr(b.Width), tpNumero, 'ALINHAMENTOWH');
    item[7].Setar('Height', 'Altura (Height)', IntToStr(b.Height), tpNumero, 'ALINHAMENTOWH');
    pEditor.FirstSelecao := item[1];
  end;

  if b is TBaseEntidade then
    With pEditor do
  begin
    pEditor.NextItem.SetAsTitulo('Esquema');
    itm := pEditor.NextItem;
    itm.SetarROBooleano('AutoRelacionado', 'Auto relacionado', TBaseEntidade(b).AutoRelacionado, 'Auto Relacionado');
  end;

  if b is TEntidade then
    With pEditor do
  begin
    pEditor.NextItem.SetarROBooleano('Especializada', 'Especializada', TEntidade(b).Especializada, 'Especializada');
  end;

  if b is TEntidadeAssoss then
    With pEditor do
  begin
    EA := TEntidadeAssoss(b);
    pEditor.NextItem.SetAsTitulo('Relacionamento');
    pEditor.NextItem.Setar('RelacaoNome', '+Nome', EA.Nome, tpTexto, 'Ent. Ass. Relação: Nome');
    pEditor.NextItem.Setar('RelecaoDicionario', '+Dicionário', EA.Dicionario, tpTexto, 'Ent. Ass. Relação: Dicionario');
    pEditor.NextItem.Setar('RelecaoObservacao', '+Observação', EA.Observacoes, tpTexto, 'Ent. Ass. Relação: Observacao');
    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      itm.ComboConversor.Largura := 7;
      itm.ComboConversor.Add('Não mostrar', 0);
      itm.ComboConversor.Add('A) /\', 1);
      itm.ComboConversor.Add('A) \/', 2);
      //itm.ComboConversor.Add('A) >', 3);
      //itm.ComboConversor.Add('A) <', 4);
      itm.ComboConversor.Add('B) \/', 5);
      itm.ComboConversor.Add('B) /\', 6);
      itm.ComboConversor.Add('B) <', 7);
      itm.ComboConversor.Add('B) >', 8);
    end;
    itm.Setar('SetaDirecao', '+Direção', itm.ComboConversor.GetByVal(EA.SetaDirecao), tpMenu, 'RPOSISETA');
  end;

  if (b is TMaxRelacao) or (b is TLigaTabela) then
    With pEditor do
  begin
    BR := TBaseRelacao(b);
    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      itm.ComboConversor.Largura := 9;
      itm.ComboConversor.Add('Não mostrar', 0);
      itm.ComboConversor.Add('A) /\', 1);
      itm.ComboConversor.Add('A) \/', 2);
      itm.ComboConversor.Add('A) >', 3);
      itm.ComboConversor.Add('A) <', 4);
      itm.ComboConversor.Add('B) \/', 5);
      itm.ComboConversor.Add('B) /\', 6);
      itm.ComboConversor.Add('B) <', 7);
      itm.ComboConversor.Add('B) >', 8);
    end;
    itm.Setar('SetaDirecao', 'Direção', itm.ComboConversor.GetByVal(BR.SetaDirecao), tpMenu, 'RPOSISETA');
  end;

  if b is TCardinalidade then
    With pEditor do
  begin
    CA := TCardinalidade(b);
    item[1].Caption := 'Papel';
    item[1].CodAjuda := 'PAPEL';
    NextItem.SetarBooleano('Fixa', 'Fixar posição', CA.Fixa, 'Card. Fixar posição');

    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      itm.ComboConversor.Largura := 2;
      itm.ComboConversor.Add('H. Vert.', OrientacaoV);
      itm.ComboConversor.Add('H. Horz.', OrientacaoH);
    end;
    itm.Setar('OrientacaoLinha', 'Posição da Linha', itm.ComboConversor.GetByVal(CA.OrientacaoLinha), tpMenu, 'Card. Posição da Linha');

    pEditor.NextItem.SetarBooleano('TamAuto', 'Tamanho aut.', CA.TamAuto, 'Card. Tamanho aut.');
    pEditor.NextItem.SetAsTitulo('Esquema');
    if (Modelo.TipoDeModelo = tpModeloConceitual) then
      pEditor.NextItem.SetarBooleano('Fraca', 'Entidade fraca', CA.Fraca, 'Entidade fraca');
    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      itm.ComboConversor.Largura := 4;
      itm.ComboConversor.Add('(1,1)', 1);
      itm.ComboConversor.Add('(0,1)', 2);
      itm.ComboConversor.Add('(1,n)', 3);
      itm.ComboConversor.Add('(0,n)', 4);
    end;
    Itm.Setar('Cardinalidade', 'Cardinalidade', itm.ComboConversor.GetByVal(CA.Cardinalidade), tpMenu, 'Cardinalidade');
  end;

  if b is TAtributo then
    With pEditor do
  begin
    AT := TAtributo(b);
    pEditor.NextItem.SetarBooleano('TamAuto', 'Tamanho aut.', At.TamAuto, 'Atrib. tamanho aut.');
    if AT.Dono is TBaseRelacao then
    pEditor.NextItem.Setar('Desvio', 'Desvio', IntToStr(AT.Desvio), tpNumero, 'Atrib. Desvio');
    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      itm.ComboConversor.Largura := 2;
      itm.ComboConversor.Add('Direito', OrientacaoD);
      itm.ComboConversor.Add('Esquerdo', OrientacaoE);
    end;
    itm.Setar('ForcaOrientacao', 'Lado', itm.ComboConversor.GetByVal(AT.ForcaOrientacao), tpMenu, 'Posicionamento');
    pEditor.NextItem.SetAsTitulo('Esquema');

    pEditor.NextItem.SetarBooleano('Identificador', 'Identificador', AT.Identificador, 'Identificador');
    pEditor.NextItem.SetarBooleano('Opcional', 'Opcional', AT.Opcional, 'Opcional');
    pEditor.NextItem.SetarROBooleano('Composto', 'Composto', AT.Composto, 'Composto');
    pEditor.NextItem.SetarBooleano('Multivalorado', 'Multivalorado', AT.Multivalorado, 'Multivalorado');

    // acrescenta a quantidade de campos a serem criados para atributos multivalorados
    if (AT.Multivalorado) then
      TP := tpNumero
    else TP := tpReadOnly;
    pEditor.NextItem.Setar('QtdeMultivalorado', 'Qtde. Campos', IntToStr(AT.QtdeMultivalorado), TP, 'QtdeMultivalorado');


    itm := pEditor.NextItem;
    itm.Generete(2, false, 0, '0');
    if AT.Multivalorado then TP := tpMenu else TP := tpMenuReadOnly;
    itm.Setar('MinCard', 'Card. Mínima', itm.ComboConversor.GetByVal(AT.MinCard), tp, 'Card. Mínima');

    itm := pEditor.NextItem;
    itm.Generete(21, false, 0, '0');
    itm.ComboConversor.Itens[0].Texto := 'n';
    itm.ComboConversor.Itens[0].Valor := '21';
    itm.Setar('MaxCard', 'Card. Máxima', itm.ComboConversor.GetByVal(AT.MaxCard), tp, 'Card. Máxima');

    // Início TCC II - Puc (MG) - Daive Simões
    // Possibilitando que o usuário utilize os tipos de dados mais comuns
    itm := pEditor.NextItem;
    itm.ComboConversor.Largura := Conf.TiposDados.Total;  // quantidade de itens do combo

    // adiciona os tipos de dados ao combobox
    for iIndex := 0 to Pred(Conf.TiposDados.Total) do
      itm.ComboConversor.Add(Conf.TiposDados.Tipo[iIndex], Conf.TiposDados.Tipo[iIndex]);

    // seleciona o valor default para o tipo de dado.
    pEditor.NextItem.Setar('TipoDoValor', 'Tipo (opcional)', itm.ComboConversor.GetByVal(AT.TipoDoValor) , tpMenu, 'TipoDoValor');

    // existe a string "()" no tipo do dado. Habilitar a opção de qtde
    if (Pos('( )', AT.TipoDoValor) <> 0) then
      TP := tpTexto
    else TP := tpReadOnly;
    pEditor.NextItem.Setar('Complemento', 'Tamanho', AT.Complemento, TP, 'Complemento');
    // Fim TCC II
  end;

  if b is TEspecializacao then
    With pEditor do
  begin
    ES := TEspecializacao(b);
    pEditor.NextItem.SetAsTitulo('Esquema');
    pEditor.NextItem.SetarROBooleano('Restrito', 'Exclusiva', ES.Restrito, 'Exclusiva');
    pEditor.NextItem.SetarBooleano('Parcial', 'Esp. Parcial', ES.Parcial, 'Esp. Parcial');
  end;

  if b is TLigaTabela then
    With pEditor do
  begin
    item[6].JustAlterTipo(tpReadOnly);
    item[7].JustAlterTipo(tpReadOnly);
  end;

  if b is TCampo then
    With pEditor do
  begin
    CM := TCampo(b);
    itm := item[1];
    if pEditor.BaseMudou then
    begin
      Modelo.Template.GeraLista(ListaDeTrabalho, fisicoTpCamposNome);
      itm.ComboConversor.Largura := ListaDeTrabalho.Count;
      for I := 0 to ListaDeTrabalho.Count - 1 do
      begin
        itm.ComboConversor.Add(ListaDeTrabalho[i], ListaDeTrabalho[i]);
      end;
    end;
    itm.Setar('Nome', 'Nome', b.Nome, tpEdtLstDrop, 'NOME');

    itm := pEditor.NextItem;
    itm.Generete(CM.Dono.Campos.Count, false, 1, '00');
    itm.Setar('oIndex', 'Posição (Índice)', itm.ComboConversor.GetByVal(CM.oIndex), tpMenu, 'Posição (Índice)');
    pEditor.NextItem.SetAsTitulo('Esquema');
    item[4].JustAlterTipo(tpReadOnly);
    item[5].JustAlterTipo(tpReadOnly);
    item[6].JustAlterTipo(tpReadOnly);
    item[7].JustAlterTipo(tpReadOnly);
    if not CM.ApenasSeparador then
    begin
      pEditor.NextItem.SetarBooleano('isKey', 'Chave Primária', CM.IsKey, 'Chave Primária');
      pEditor.NextItem.SetarBooleano('isFKey', 'Chave Estrangeira', CM.IsFKey, 'Chave Estrangeira');
      if CM.IsFKey then
        pEditor.NextItem.Setar('Tipo', 'Tipo (Obrigatório)', CM.Tipo, tpReadOnly, 'Tipo')
      else begin
        // Início TCC II - Puc (MG) - Daive Simões
        // Possibilitando que o usuário utilize os tipos de dados mais comuns
        itm := pEditor.NextItem;
        itm.ComboConversor.Largura := Conf.TiposDados.Total;  // quantidade de itens do combo

        // adiciona os tipos de dados ao combobox
        for iIndex := 0 to Pred(Conf.TiposDados.Total) do
          itm.ComboConversor.Add(Conf.TiposDados.Tipo[iIndex], Conf.TiposDados.Tipo[iIndex]);

        // seleciona o valor default para o tipo de dado.
        pEditor.NextItem.Setar('Tipo', 'Tipo (Obrigatório)', CM.Tipo, tpEdtLstDrop, 'Tipo');

        // existe a string "()" no tipo do dado. Habilitar a opção de qtde
        if (Pos('( )', CM.Tipo) <> 0) then
          TP := tpTexto
        else TP := tpReadOnly;
        pEditor.NextItem.Setar('Precisao', 'Tamanho', CM.Precisao, TP, 'Precisao');
        // Fim TCC II
      end;

      pEditor.NextItem.SetAsTitulo('IR');
      if CM.IsFKey then
      begin
        Modelo.TabelasLigadas(ListaDeObj, CM.Dono);
        itm := pEditor.NextItem;
//        if pEditor.BaseMudou then
//        begin
        itm.ComboConversor.Largura := ListaDeObj.Lista.Count + 1;
        itm.ComboConversor.Add('<nenhum>', 0);
        for i := 0 to ListaDeObj.Lista.Count -1 do
         itm.ComboConversor.Add(ListaDeObj[i].Texto, ListaDeObj[i].Tag);
//        end;
        J := CM.TabOrigem;
        itm.Setar('TabOrigem', 'Tab. Origem', itm.ComboConversor.GetByVal(J), tpMenu, 'TabOrigem');

        itm := pEditor.NextItem;
        if J > 0 then
        begin
          m := 1;
          for i := 0 to CM.TabelaDeOrigem.Campos.Count -1 do
             if TCampo(CM.TabelaDeOrigem.Campos[i]).IsKey then inc(m);

          itm.ComboConversor.Largura := m;
          itm.ComboConversor.Add('<nenhum>', 0);
          for i := 0 to CM.TabelaDeOrigem.Campos.Count -1 do
          begin
            CM2 := TCampo(CM.TabelaDeOrigem.Campos[i]);
            if CM2.IsKey AND (CM2 <> CM) then
              itm.ComboConversor.Add(CM2.Nome, CM2.oID);
          end;
          itm.Setar('CampoOrigem', 'Campo Origem', itm.ComboConversor.GetByVal(CM.CampoOrigem), tpMenu, 'CampoOrigem');
        end else itm.Setar('CampoOrigem', 'Campo Origem', '<nenhum>', tpReadOnly, 'CampoOrigem');
        pEditor.NextItem.SetAsTitulo('DDL');

        itm := pEditor.NextItem;
        itm.ComboConversor.Largura := 5;
        for i := 0 to 4 do
         itm.ComboConversor.Add(DDLActionToStr(i), i);
        Itm.Setar('ddlOnUpdate', 'On Update', DDLActionToStr(CM.ddlOnUpdate), tpMenu, 'OnUpdate');

        itm := pEditor.NextItem;
        itm.ComboConversor.Largura := 5;
        for i := 0 to 4 do
         itm.ComboConversor.Add(DDLActionToStr(i), i);
        Itm.Setar('ddlOnDelete', 'On Delete', DDLActionToStr(CM.ddlOnDelete), tpMenu, 'OnDelete');

      end else
      begin
        pEditor.NextItem.Setar('TabOrigem', 'Tab. Origem', '<nenhum>', tpReadOnly, 'TabOrigem');
        pEditor.NextItem.Setar('CampoOrigem', 'Campo Origem', '<nenhum>', tpReadOnly, 'CampoOrigem');
        pEditor.NextItem.SetAsTitulo('DDL');
        pEditor.NextItem.Setar('ddlOnUpdate', 'On Update', DDLActionToStr(CM.ddlOnUpdate), tpReadOnly, 'OnUpdate');
        pEditor.NextItem.Setar('ddlOnDelecte', 'On Delete', DDLActionToStr(CM.ddlOnDelete), tpReadOnly, 'OnDelete');
      end;

      itm := pEditor.NextItem;
      if pEditor.BaseMudou then
      begin
        Modelo.Template.GeraLista(ListaDeTrabalho, fisicoTpCamposCoplemento);
        itm.ComboConversor.Largura := ListaDeTrabalho.Count;
        for I := 0 to ListaDeTrabalho.Count - 1 do
        begin
          itm.ComboConversor.Add(ListaDeTrabalho[i], ListaDeTrabalho[i]);
        end;
      end;
      itm.Setar('Complemento', 'Complemento', CM.Complemento, tpEdtLstDrop, 'TBComplemento');
      //pEditor.NextItem.Setar('Complemento', 'Complemento', CM.Complemento, tpTexto, 'CPComplemento');
    end;
  end;

  if b is TTabela then
    With pEditor do
  begin
    TB := TTabela(b);
    pEditor.NextItem.SetAsTitulo('Esquema');
    pEditor.NextItem.Setar('Color', 'Cor', ColorToString(TB.Color), tpCor, 'Cor');
    pEditor.NextItem.Setar('QtdCampos', 'Qtd. Campos', IntToStr(TB.QtdCampos), tpReadOnly, 'Qtd. Campos');
    pEditor.NextItem.SetAsTitulo('Integridade');
    pEditor.NextItem.Setar('Chaves', 'Chaves', '[' + TB.Chaves + ']', tpReadOnly, 'TBChaves');
    pEditor.NextItem.SetAsTitulo('DDL');
    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      itm.ComboConversor.Largura := Modelo.QtdTabela + 1;
      itm.ComboConversor.Add('Não Informado', 0);
      for I := 1 to Modelo.QtdTabela do
      begin
        itm.ComboConversor.Add(IntToStr(I), i);
      end;
    end;
    itm.Setar('cOrdem', 'Ordem Conversão', itm.ComboConversor.GetByVal(TB.cOrdem), tpMenu, 'TBcOrdem');
    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      Modelo.Template.GeraLista(ListaDeTrabalho, fisicoTpTabelaCoplemento);
      itm.ComboConversor.Largura := ListaDeTrabalho.Count;
      for I := 0 to ListaDeTrabalho.Count - 1 do
      begin
        itm.ComboConversor.Add(ListaDeTrabalho[i], ListaDeTrabalho[i]);
      end;
    end;
    itm.Setar('Complemento', 'Complemento', TB.Complemento, tpEdtLstDrop, 'TBComplemento');
  end;

  if b is TTexto then
    With pEditor do
  begin
    pEditor.FirstSelecao := nil;
    TX := TTexto(b);
    item[1].JustAlterTipo(tpEditor);
    item[1].Caption := 'Texto';
    item[1].CodAjuda := 'TEXTO TEXTO';
    pEditor.NextItem.SetarBooleano('TamAuto', 'Tamanho aut.', TX.TamAuto, 'Texto TamAuto');
    pEditor.NextItem.SetAsTitulo('Estilo');
    if TX.Tipo = TextoTipoBranco then TP := tpReadOnly else TP := tpCor;
    pEditor.NextItem.Setar('Cor', 'Cor', ColorToString(TX.Cor), tp, 'Texto Cor');

    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      itm.ComboConversor.Largura := 3;
      itm.ComboConversor.Add('Vazio', TextoTipoBranco);
      itm.ComboConversor.Add('Caixa', TextoTipoBox);
      itm.ComboConversor.Add('Hint', TextoTipoHint);
    end;
    itm.Setar('Tipo', 'Moldura', itm.ComboConversor.GetByVal(TX.Tipo), tpMenu, 'Moldura');
    itm := pEditor.NextItem;
    if pEditor.BaseMudou then
    begin
      itm.ComboConversor.Largura := 3;
      itm.ComboConversor.Add('Esquerda', TextoAlinEsq);
      itm.ComboConversor.Add('Centro', TextoAlinCen);
      itm.ComboConversor.Add('Direita', TextoAlinDir);
    end;
    itm.Setar('TextAlin', 'Alin. Texto', itm.ComboConversor.GetByVal(TX.TextAlin), tpMenu, 'Alin. Texto');
  end;
  pEditor.Show;
  RealizeChecagem;
end;

procedure TbrFmPrincipal.OnBaseMouseMove(base: TBase);
begin
  Status.Panels[3].Text := base.Nome;
  Status.Panels[5].Text := base.Observacoes;

  if (mod_exibirHint.Checked) and (base <> OverB) then
    if base.AOcultos.AtributosOcultos.Count > 0 then
      Modelo.BaseHint.Show(
        base.BoundsRect,
        base.AtributosOcultosToTexto);
  OverB := base;
end;

procedure TbrFmPrincipal.VisualKeyPress(Sender: TObject; var key: char);
begin
  if not (key in [#9, #13, #27])  then
  begin
    pEditor.ReciverKey(word(key));
    key := #0;
  end;
end;

procedure TbrFmPrincipal.VisualMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var P: TPoint;
begin
  if SemModelo then Exit;
  Status.Panels[3].Text := '';
  if Modelo.Ferramenta <> 0 then
  begin
    P := Modelo.ScreenToClient(Mouse.CursorPos);
    Status.Panels[1].Text := IntToStr(P.X);
    Status.Panels[2].Text := IntToStr(P.Y);
  end
  else
  begin
    Status.Panels[5].Text := '';
    Status.Panels[1].Text := '';
    Status.Panels[2].Text := '';
  end;
  Modelo.BaseHint.Visible := false;
  OverB := nil;
end;

procedure TbrFmPrincipal.Exibir_fonteExecute(Sender: TObject);
begin
  brFmtCfgFonte.OpcoesGerais.ActivePage := brFmtCfgFonte.TabFont;
  brFmtCfgFonte.OpcoesGeraisChange(sender);
  If not brFmtCfgFonte.Visible then brFmtCfgFonte.Show;
end;

procedure TbrFmPrincipal.Exibir_fonteUpdate(Sender: TObject);
begin
  if SemModelo then Exit;
  Exibir_fonte.Enabled := (Modelo.Selecionado <> nil);
end;

procedure TbrFmPrincipal.CriarExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if Modelo.Ferramenta <> TAction(Sender).Tag then
    Modelo.Ferramenta := TAction(Sender).Tag else
    Modelo.Ferramenta := Tool_Nothing;
end;

procedure TbrFmPrincipal.onErro(BaseSender: TBase; Texto: string;
  tipoErro: integer);
begin
  if tipoErro = 0 then
    Application.MessageBox(PChar(Texto), 'Erro na Operação', MB_OK or MB_ICONERROR)
  else
    Application.MessageBox(PChar(Texto), 'Aviso:', MB_OK or MB_ICONWARNING);
end;

procedure TbrFmPrincipal.DelExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  Modelo.DeleteSelection;
end;

procedure TbrFmPrincipal.criar_CancelarUpdate(Sender: TObject);
begin
  if SemModelo then Exit;
  (Sender as TAction).Enabled := Modelo.Ferramenta <> 0;
end;

procedure TbrFmPrincipal.CriarUpdate(Sender: TObject);
  var a: TAction;
begin
  if SemModelo then Exit;
  A := (Sender as TAction);
  if (A <> del_base) then
  begin
    if (A.Tag in
       [Tool_Especializacao, Tool_EspecializacaoA, Tool_EspecializacaoB, Tool_AutoRel])
    then A.Enabled := Modelo.QtdEntidade > 0 else A.Enabled := (Modelo.QtdBase > 0) and (Modelo.TipoDeModelo = tpModeloConceitual);
  end;
  del_base.Enabled := Modelo.QtdBase > 0;
  edt_copy.Enabled := Modelo.Selecionado <> nil;
  edt_cut.Enabled := edt_copy.Enabled;
  edt_paste.Enabled := Modelo.PodeColar;
  if (Modelo.Ferramenta = Tool_Nothing) then criar_Cancelar.Checked := true;
end;

procedure TbrFmPrincipal.criar_ligacaoUpdate(Sender: TObject);
begin
  if SemModelo then Exit;
  (Sender as TAction).Enabled := (Modelo.QtdEntidade > 1) or ((Modelo.QtdEntidade = 1) and (Modelo.QtdBase > 1));
end;

procedure TbrFmPrincipal.CrieNovoModelo(tipoModelo: integer);
begin
  Modelo := brDM.Visual.gera('');
  Modelo.TransformTo(tipoModelo);
  AtiveModelo;
end;

procedure TbrFmPrincipal.promo_eaExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado <> nil) and (Modelo.Selecionado is TRelacao) then
    if not Modelo.PromoverAEntAss(TRelacao(Modelo.Selecionado)) then
      onErro(nil, 'Não foi possível promover a relação à entidade associativa!', 0);
end;

procedure TbrFmPrincipal.promo_entidadeExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado <> nil) and (Modelo.Selecionado is TAtributo) then
    if not Modelo.PromoverAEntidade(TAtributo(Modelo.Selecionado)) then
      onErro(nil, 'Não foi possível promover o atributo à entidade!', 0);
end;

procedure TbrFmPrincipal.TreeAttClick(Sender: TObject);
  var PA: TAtributoOculto;
      Node: TTreeNode;
begin
  ao_Excluir.Enabled := false;
  ao_Editar.Enabled := false;
  ao_Novo.Enabled := false;
  ao_exibir.Enabled := false;
  if SemModelo then Exit;
  if (Modelo.Selecionado = nil) or (Modelo.Selecionado is TBaseTexto)  or (Modelo.Selecionado is TEspecializacao) then Exit;
  ao_Novo.Enabled := True;
  Node := TreeAtt.Selected;
  if not Assigned(Node) then exit;
  Pa := Modelo.Selecionado.AOcultos.FindByNode(node);
  if Assigned(Pa) then
  begin
    ao_Excluir.Enabled := True;
    ao_Editar.Enabled := True;
    if not Assigned(PA.Pai) {and not (Modelo.Selecionado is TAtributo)} then ao_exibir.Enabled := True;
  end;
end;

procedure TbrFmPrincipal.ao_NovoClick(Sender: TObject);
  var PA: TAtributoOculto;
      Node: TTreeNode;
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado = nil) or (Modelo.Selecionado is TBaseTexto)  or (Modelo.Selecionado is TEspecializacao) then Exit;
  Node := TreeAtt.Selected;
  Pa := nil;
  if Assigned(Node) then Pa := Modelo.Selecionado.AOcultos.FindByNode(node);
  if Assigned(Pa) then
  begin
    brFmFModal.Pai.ItemIndex := 0;
    brFmFModal.Pai.Enabled := true;
  end else
  begin
    brFmFModal.Pai.ItemIndex := 1;
    brFmFModal.Pai.Enabled := False;
  end;
  brFmFModal.EmEdicao.Nome := '';
  brFmFModal.EmEdicao.Tipo := '';
  brFmFModal.EmEdicao.Max := 0;
  brFmFModal.EmEdicao.Multivalorado := false;
  brFmFModal.EmEdicao.Identificador := false;
  brFmFModal.EmEdicao.Composto := false;
  brFmFModal.Monta;
  if (brFmFModal.ShowModal <> mrOk) then exit;
  if brFmFModal.nome.Text = '' then
  begin
    onErro(nil, 'Nome do atributo inválido!', 0);
    exit;
  end;
  if (Assigned(Pa) and (brFmFModal.Pai.ItemIndex = 0)) then
    Pa.NovoFilho(brFmFModal.EmEdicao.Nome,
                                           brFmFModal.EmEdicao.Tipo,
                                           Point(-1, -1),
                                           brFmFModal.EmEdicao.Identificador,
                                           Point(brFmFModal.EmEdicao.Min,brFmFModal.EmEdicao.Max)
                                           )
  else
    Modelo.Selecionado.AOcultos.NovoAtributo(brFmFModal.EmEdicao.Nome,
                                           brFmFModal.EmEdicao.Tipo,
                                           Point(-1, -1),
                                           brFmFModal.EmEdicao.Identificador,
                                           Point(brFmFModal.EmEdicao.Min,brFmFModal.EmEdicao.Max)
                                           );
  OnSelecao(Modelo.Selecionado);
end;

procedure TbrFmPrincipal.ao_EditarClick(Sender: TObject);
  var PA: TAtributoOculto;
      Node: TTreeNode;
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado = nil) or (Modelo.Selecionado is TBaseTexto)  or (Modelo.Selecionado is TEspecializacao) then Exit;
  Node := TreeAtt.Selected;
  Pa := nil;
  if Assigned(Node) then Pa := Modelo.Selecionado.AOcultos.FindByNode(node);
  if not Assigned(Pa) then
  begin
    onErro(nil, 'Selecione um atributo válido!', 0);
    exit;
  end else
  begin
    brFmFModal.Pai.ItemIndex := 1;
    brFmFModal.Pai.Enabled := false;
  end;
  brFmFModal.EmEdicao.Nome := pa.Nome;
  brFmFModal.EmEdicao.Tipo := pa.Tipo;
  if pa.Multivalorado then
  begin
    brFmFModal.EmEdicao.Max := pa.MaxCard;
    brFmFModal.EmEdicao.Min := pa.MinCard;
  end else brFmFModal.EmEdicao.Max := 0;
  brFmFModal.EmEdicao.Multivalorado := pa.Multivalorado;
  brFmFModal.EmEdicao.Identificador := pa.Identificador;
  brFmFModal.EmEdicao.Composto := pa.Composto;
  brFmFModal.Monta;

  if (brFmFModal.ShowModal <> mrOk) then exit;
  if brFmFModal.nome.Text = '' then
  begin
    onErro(nil, 'Nome do atributo inválido!', 0);
    exit;
  end;
  Pa.Nome := brFmFModal.EmEdicao.Nome;
  Pa.MaxCard := brFmFModal.EmEdicao.Max;
  Pa.MinCard := brFmFModal.EmEdicao.Min;
  PA.Identificador := brFmFModal.EmEdicao.Identificador;
  PA.Tipo := brFmFModal.EmEdicao.Tipo;
  OnSelecao(Modelo.Selecionado);
end;

procedure TbrFmPrincipal.ao_ExcluirClick(Sender: TObject);
  var PA: TAtributoOculto;
      Node: TTreeNode;
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado = nil) or (Modelo.Selecionado is TBaseTexto)  or (Modelo.Selecionado is TEspecializacao) then Exit;
  Node := TreeAtt.Selected;
  Pa := nil;
  if Assigned(Node) then Pa := Modelo.Selecionado.AOcultos.FindByNode(node);
  if not Assigned(Pa) then
  begin
    onErro(nil, 'Selecione um atributo válido!', 0);
    exit;
  end;
  if Application.MessageBox(pchar('Confirma a exclusão do atributo "' + Pa.Nome + '"?'),
                            'Atributo oculto',
                            MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON1) = mrYes then
  FreeAndNil(PA);
  OnSelecao(Modelo.Selecionado);
end;

procedure TbrFmPrincipal.ao_exibirClick(Sender: TObject);
  var PA: TAtributoOculto;
      Node: TTreeNode;
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado = nil) or (Modelo.Selecionado is TBaseTexto) or
     (Modelo.Selecionado is TEspecializacao) {or (Modelo.Selecionado is TAtributo)}
  then Exit;
  Node := TreeAtt.Selected;
  Pa := nil;
  if Assigned(Node) then Pa := Modelo.Selecionado.AOcultos.FindByNode(node);
  if (not Assigned(Pa)) or not (Pa.Pai = nil) then
  begin
    onErro(nil, 'Selecione um atributo válido!', 0);
    exit;
  end;

  if Modelo.MostraAtributoOculto(PA, Modelo.Selecionado) then FreeAndNil(PA);
  OnSelecao(Modelo.Selecionado);
end;

procedure TbrFmPrincipal.ao_OcultarExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado <> nil) and (Modelo.Selecionado is TAtributo) then
    if not Modelo.OcultarAtributo(TAtributo(Modelo.Selecionado)) then
      onErro(nil, 'Não foi possível ocultar o atributo!', 0);
end;

procedure TbrFmPrincipal.ac_orgAttExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado <> nil) and (Modelo.TipoDeModelo = tpModeloConceitual) then Modelo.Selecionado.OrganizeAtributos;
end;

procedure TbrFmPrincipal.RealizeChecagem;
begin
  if SemModelo then Exit;
  Del.Enabled := Modelo.Selecionado <> nil;
  ac_orgAtt.Enabled := (Del.Enabled) and (Modelo.Selecionado.Atributos.Count > 0) and not(Modelo.Selecionado is TBaseRelacao);
  selAtt.Enabled := (Del.Enabled) and ((Modelo.Selecionado.Atributos.Count > 0) or (Modelo.TotalSelecionado > 1)) and (Modelo.TipoDeModelo = tpModeloConceitual);
  ac_orgAtt.Enabled := (Modelo.TipoDeModelo = tpModeloConceitual) and (ac_orgAtt.Enabled);
  if (Modelo.Selecionado is TAtributo) then
    if TAtributo(Modelo.Selecionado).Barra.Atributos.Count > 0 then
    begin
      ac_orgAtt.Enabled := true;
      selAtt.Enabled := true;
    end;
  //end
  promo_ea.Enabled := (Modelo.Selecionado is TRelacao);
  promo_entidade.Enabled := ((Modelo.Selecionado is TAtributo) and not(TAtributo(Modelo.Selecionado).Dono is TBarraDeAtributos));
  ao_Ocultar.Enabled := (Modelo.Selecionado is TAtributo);
  covToRest.Enabled := (Modelo.Selecionado is TEspecializacao) and not (TEspecializacao(Modelo.Selecionado).Restrito);
  convToOpc.Enabled := (Modelo.Selecionado is TEspecializacao) and (TEspecializacao(Modelo.Selecionado).Restrito);
end;

procedure TbrFmPrincipal.ImprimirExecute(Sender: TObject);
 var bkp: Boolean;
begin
  if SemModelo then Exit;
  bkp := Modelo.Mudou;
  Modelo.EveryHideShowSelection(nil, false);
  Modelo.BaseHint.Visible := false;
  try
    brFmImpress.Maker.make(Modelo);
    brFmImpress.ShowModal;
  except
    onErro(nil, 'O Sistema Operacional não conseguiu gerar a página de impressão!', 0);
  end;
  Modelo.EveryHideShowSelection(nil, true);
  brFmImpress.Maker.Imagem.Picture := nil;
  Modelo.Mudou := bkp;
  Modelo.Invalidate;
end;

procedure TbrFmPrincipal.arq_SalvarExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if Modelo.Novo then
    arq_salvarcExecute(sender)
  else Modelo.Salvar;
end;

procedure TbrFmPrincipal.arq_salvarcExecute(Sender: TObject);
  var tmp: string;
begin
  // Inicio TCC II
  // seleciona a pasta de salvamento dos arquivos
  case Modelo.TipoDeModelo of
    tpModeloConceitual : brDM.SavaModelo.InitialDir := Conf.dirConceitual;
    tpModeloLogico     : brDM.SavaModelo.InitialDir := Conf.dirLogico;
    tpModeloFisico     : brDM.SavaModelo.InitialDir := Conf.dirFisico;

    else brDM.SavaModelo.InitialDir := sAppDir;
  end;  // case Modelo.TipoDeModelo of
  // Fim TCC II

  if Modelo.Arquivo <> '' then
  begin
    tmp := AnsiUpperCase(ExtractFileExt(Modelo.Arquivo));
    if (tmp = '.BRM') then brDM.SavaModelo.FilterIndex := 1
    else brDM.SavaModelo.FilterIndex := 2;
  end else brDM.SavaModelo.FilterIndex := 1;
//  if brDM.SavaModelo.FilterIndex = 1 then
//    brDM.SavaModelo.FileName := Modelo.Nome + '.brM' else brDM.SavaModelo.FileName := Modelo.Nome + '.xml';
  brDM.SavaModelo.FileName := Modelo.Nome;
  if SemModelo then Exit;
  with brDM.SavaModelo do begin
    if Execute then begin
      tmp := AnsiUpperCase(ExtractFileExt(FileName));
      //if (tmp <> '.BRM') and (tmp <> '.XML') then
      if FilterIndex = 1 then
        FileName := ChangeFileExt(FileName, '.brM')
      else FileName := ChangeFileExt(FileName, '.xml');
    end;  // if Execute then

    Modelo.Salvar(FileName);
  end;  // with brDM.SavaModelo do
end;

procedure TbrFmPrincipal.edt_copyExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if brDM.Visual.Focused then Modelo.Copiar;
end;

procedure TbrFmPrincipal.edt_cutExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if not brDM.Visual.Focused then Exit;
  if (Modelo.TotalSelecionado > 1) then
    onErro(nil, 'Apenas a primeira seleção será recortada, as demais serão copiadas!', 1);
  if Modelo.Copiar then
    Modelo.ProcesseBaseClick(Modelo.Selecionado, Tool_Del);
end;

procedure TbrFmPrincipal.edt_DesfazerExecute(Sender: TObject);
begin
  if not brDM.Visual.Memoria.Desfazer then
  Application.MessageBox('Impossível desfazer', 'Impossível desfazer', MB_OK or MB_ICONWARNING)
  else Modelo.Ferramenta := Tool_Nothing;
end;

procedure TbrFmPrincipal.edt_DesfazerHint(var HintStr: string; var CanShow: Boolean);
begin
  HintStr := 'Desfazer [' + brDM.Visual.Memoria.StrQtdDesfazer + ']';
end;

procedure TbrFmPrincipal.edt_DesfazerUpdate(Sender: TObject);
begin
  edt_Desfazer.Enabled := not SemModelo and brDM.Visual.Memoria.PodeDesfazer;
  edt_Refazer.Enabled := not SemModelo and brDM.Visual.Memoria.PodeRefazer;
end;

procedure TbrFmPrincipal.OnModeloMudou(Sender: TObject);
begin
  if SemModelo then Exit;
  Modelo := brDM.Visual.Modelo;
  Status.Panels[0].Text := IfThen(Modelo.Mudou, '[Mod]', '');
  Caption := appCaption + '- [' + Modelo.Nome + ']';
  if (Modelo.TipoDeModelo <> tpModeloConceitual) then
  begin
    Tabs.TabIndex := 0;
    Opcoes.ActivePageIndex := 0;
    Tabs.TabDisabled := [1];
  end else Tabs.TabDisabled := [];
end;

procedure TbrFmPrincipal.FormCreate(Sender: TObject);
begin
  ListaDeTrabalho := TStringList.Create;

  SemModelo := true;

  RegisterClass(TOrigem);
  RegisterClass(TPonto);
  RegisterClass(TLinha);
  RegisterClass(TLigacao);
  RegisterClass(TBase);
  RegisterClass(TEntidade);
  RegisterClass(THintBalao);
  RegisterClass(TConjPAtt);
  RegisterClass(TSelecao);
  RegisterClass(TBaseTexto);
  RegisterClass(TTexto);
  RegisterClass(TCardinalidade);
  RegisterClass(TBaseEntidade);
  RegisterClass(TBaseRelacao);
  RegisterClass(TMaxRelacao);
  RegisterClass(TRelacao);
  RegisterClass(TChildRelacao);
  RegisterClass(TAutoRelacao);
  RegisterClass(TEspecializacao);
  RegisterClass(TEntidadeAssoss);
  RegisterClass(TAtributo);
  RegisterClass(TBarraDeAtributos);
  RegisterClass(TModelo);
  RegisterClass(TTabela);
  RegisterClass(TLigaTabela);
  RegisterClass(TCampo);
//  RegisterClass(TGeralItem);
  RegisterClass(TGeralList);
  RegisterClass(TWriterMsg);
  RegisterClass(TMngTemplate);
  RegisterClass(TMngTemplateItem);
end;

procedure TbrFmPrincipal.arq_fecharExecute(Sender: TObject);
  var i: Integer;
begin
  if SemModelo then Exit;
  if QuerSalvarOModelo(Modelo) = mrCancel then exit;
  brDM.Visual.Fecha;

  Modelo := brDM.Visual.Modelo;
  Status.Panels[0].Text := '';
  if Assigned(Modelo) then
  begin
    AtiveModelo;
  end else
  begin
    Tabs.TabIndex := 0;
    Opcoes.ActivePageIndex := 0;
    Tabs.TabDisabled := [0,1];
    Caption := appCaption + '- []';
  end;

  if brDM.Visual.Modelos.Count = 0 then
  begin
    //autoSalvar.Checked := false;
    SemModelo := true;
    pEditor.Base := nil;
    brDM.Visual.Invalidate;


    {for i := 0 to ComponentCount -1 do
    begin
      if (Components[i] is TAction) and (Components[i].Tag <> -2) then
//         (Components[i].Name <> 'arq_novo') and
//         (Components[i].Name <> 'NovoLogico') and
//         (Components[i].Name <> 'sis_sair') and
//         (Components[i].Name <> 'Config') and
//         (Components[i].Name <> 'Sobre') and
////         (Components[i].Name <> 'mod_exibirHint') and
//         (Components[i].Name <> 'arq_abrir') then
      begin
        TAction(Components[i]).Enabled := false;
      end;
    end;}

    // atualiza o status dos controles
    UpdateRibbonControls;
  end;
end;

procedure TbrFmPrincipal.arq_fecharUpdate(Sender: TObject);
begin
  arq_fechar.Enabled := not SemModelo;
end;

procedure TbrFmPrincipal.arq_novoExecute(Sender: TObject);
begin
  CrieNovoModelo(tpModeloConceitual);

  Modelo.Ferramenta := 0;

  // seta o status das guias de ferramentas para o modelo conceitual
  Ribbon.SetApplicationModes([_MOD_CONCEITUAL]);

  // atualiza o status dos controles
  UpdateRibbonControls;
end;

procedure TbrFmPrincipal.ModelosSelect(Sender: TObject);
begin
  Modelo := brDM.Visual.SelecioneModelo((Sender as TMenuItem).Tag);


  Caption := appCaption + '- [' + Modelo.Nome + ']';
  if (Modelo.TipoDeModelo = tpModeloLogico) then
  begin
    Tabs.TabIndex := 0;
    Opcoes.ActivePageIndex := 0;
    Tabs.TabDisabled := [1];

    // seta o status da guia de modelo lógico
    Ribbon.SetApplicationModes([_MOD_LOGICO]);
  end else
  begin
    Tabs.TabDisabled := [];

    // seta o status da guia de modelo conceitual
    Ribbon.SetApplicationModes([_MOD_CONCEITUAL]);
  end;
  OnSelecao(Modelo.Selecionado);
end;

procedure TbrFmPrincipal.arq_abrirExecute(Sender: TObject);
  var M: TModelo;
begin
  // Inicio TCC II
  // Redireciona a janela de dialogo para abrir na pasta de modelos
  brDM.OpenModelo.InitialDir  := sModelsDir;
  // Fim TCC II

  brDM.OpenModelo.FilterIndex := 1;
  with brDM.OpenModelo do
    if Execute then
  begin
    if brDM.Visual.JaEstaAberto(FileName) then
    begin
      if Application.MessageBox('O arquivo selecionado já encontra-se aberto!' + #13 +
                                'Deseja abrir mais uma cópia?',
                                'Reabrir arquivo', MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) <> mrYes then exit;
    end;
    if not SemModelo and Modelo.Novo and not Modelo.Mudou then
    begin
      if not brDM.Visual.LoadFromFile(FileName, Modelo.Nome, Modelo) then
      begin
        brDM.Visual.Fecha;
        arq_novoExecute(Self);
      end else
      begin
        brDM.Visual.Modelo.Mudou := false;
      end;
    end else
    begin
      M := brDM.Visual.gera(FileName, false);
      if Assigned(M) then
      begin
        Modelo := M;
      end;
    end;
    Modelo := brDM.Visual.Modelo;
    if not Assigned(Modelo) then exit;
    AtiveModelo;
  end;
end;

Function TbrFmPrincipal.QuerSalvarOModelo(M: TModelo; YtoA: boolean;
  jaYtoA: boolean; jaNtoA: boolean): Integer;
  var tmp: TModelo;
begin
  Result := mrYes;
  if M.Mudou then
  begin
    if jaNtoA then Result := mrNoToAll else
    if jaYtoA then Result := mrYesToAll else
    begin
      if (YtoA) and (brDM.Visual.QtdModeloNaoSalvo > 1) then
        Result := brFmDlgSaveAll.Msg(M.Nome)
      else
        Result := brFmDlgSaveAll.Msg(M.Nome, false);
//        Application.MessageBox(PChar('Deseja salvar as alterações no esquema "' + M.Nome + '"?'), 'Salvar esquema',
//                               MB_YESNOCANCEL or MB_ICONQUESTION or MB_DEFBUTTON1);
    end;
    tmp := Modelo;
    Modelo := M;
    if (Result = mrYes) or (Result = mrYesToAll) then arq_SalvarExecute(nil);
    if (Modelo.Mudou) and ((Result = mrYes) or (Result = mrYesToAll)) then Result := mrCancel;
    Modelo := tmp;
  end;
end;

procedure TbrFmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  var mr: Word;
begin
  mr := mrNone;
  while brDM.Visual.Modelos.Count > 0 do
  begin
    Modelo := brDM.Visual.SelecioneModelo(brDM.Visual.Modelos.Count -1);
    mr := QuerSalvarOModelo(Modelo, true, (mr = mrYesToAll), (mr = mrNoToAll));
    if mr = mrCancel then
    begin
      CanClose := false;
      AtiveModelo;
      break;
    end;
    brDM.Visual.Fecha;
  end;
  if CanClose then
  begin
    brDM.XMLDoc.XML.Clear;
    with brDM.XMLDoc do
    begin
      XML.Add('<?xml version="1.0" encoding="ISO-8859-1"?>');
      XML.Add('<APP>');
      XML.Add('<CONFIGURACAO>');
      XML.Add('</CONFIGURACAO>');
      XML.Add('<AJUDA>');
      XML.Add('</AJUDA>');
      XML.Add('</APP>');
    end;
    try
      brDM.XMLDoc.Active := true;
      Conf.SaveToXml(brDM.XMLDoc.DocumentElement.ChildNodes);
      brDM.XMLDoc.SaveToFile(Conf.cfgFile);
    except
      onErro(nil, 'Não foi possível salvar o arquivo de configuração!' + #13 +
                  'Arquivo: ' + Conf.cfgFile, 0);
    end;
  end;
end;

procedure TbrFmPrincipal.modExportBMPExecute(Sender: TObject);
 var bkp: Boolean;
begin
  if SemModelo then Exit;
  bkp := Modelo.Mudou;
  Modelo.EveryHideShowSelection(nil, false);
  Modelo.BaseHint.Visible := false;
  try
    brFmImpress.Maker.make(Modelo);
    if (Sender as TComponent).Name = 'modExportBMP' then
      brFmImpress.ExBMPExecute(nil)
        else brFmImpress.ExMExecute(nil);
    //brFmImpress.ShowModal;
  except
    onErro(nil, 'O Sistema Operacional não conseguiu gerar a página de impressão/exportação!', 0);
  end;
  Modelo.EveryHideShowSelection(nil, true);
  brFmImpress.Maker.Imagem.Picture := nil;
  Modelo.Mudou := bkp;
  Modelo.Invalidate;
end;

procedure TbrFmPrincipal.mod_exibirHintExecute(Sender: TObject);
begin
//não é necessário código
end;

procedure TbrFmPrincipal.AtiveModelo;
  var i: integer;
begin
  SemModelo := false;
  Modelo.AtualizaQtdItens;
  Status.Panels[0].Text := IfThen(Modelo.Mudou, '[Mod]', '');
  for i := 0 to ComponentCount -1 do
  begin
    if (Components[i] is TAction) then
    begin
      TAction(Components[i]).Enabled := True;
    end;
  end;
  OnSelecao(Modelo.Selecionado);


  if (Modelo.TipoDeModelo = tpModeloLogico) then
  begin
    Tabs.TabIndex := 0;
    Opcoes.ActivePageIndex := 0;
    Tabs.TabDisabled := [1];
  end else Tabs.TabDisabled := [];

  if Modelo.Selecionado = nil then RealizeChecagem;
  Caption := appCaption + '- [' + Modelo.Nome + ']';
  //autoSalvar.Checked := Modelo.AutoSalvar;

  // Inicio TCC II
  // seta as guias corretas para cada tipo de modelo
  case Modelo.TipoDeModelo of
    tpModeloConceitual : Ribbon.SetApplicationModes([_MOD_CONCEITUAL]);
    tpModeloLogico     : Ribbon.SetApplicationModes([_MOD_LOGICO]);
  end;  // case Modelo.TipoDeModelo of
  // Fim TCC II
end;

procedure TbrFmPrincipal.edt_pasteExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if not brDM.Visual.Focused then Exit;
  Modelo.Colar;
end;

procedure TbrFmPrincipal.edt_RefazerExecute(Sender: TObject);
begin
  if not brDM.Visual.Memoria.Refazer then
  Application.MessageBox('Impossível refazer', 'Impossível refazer', MB_OK or MB_ICONWARNING)
  else Modelo.Ferramenta := Tool_Nothing;
end;

procedure TbrFmPrincipal.edt_RefazerHint(var HintStr: string; var CanShow: Boolean);
begin
  HintStr := 'Refazer [' + brDM.Visual.Memoria.StrQtdRefazer + ']';
end;

procedure TbrFmPrincipal.StatusDrawPanel(StatusBar: TStatusBar;  //gaugue onload MER.
  Panel: TStatusPanel; const Rect: TRect);
  var Rec, R: TRect;
      txt: String;
      P: integer;
begin
  txt := copy(Status.Panels[4].Text, 1, Length(Status.Panels[4].Text) -1);
  if (txt <> '') and (txt <> '-1') then
  begin
    P := StrToInt(txt);
    StatusBar.Canvas.Font.Style := [fsBold];
    StatusBar.Canvas.Brush.Color := clBlue;
    StatusBar.Canvas.Brush.Style := bsSolid;
    rec.Left := Rect.Left;
    rec.Top := Rect.Top +3;
    rec.Bottom := Rect.Bottom -3;
    rec.Right := Rect.Left + ((Rect.Right -Rect.Left) * P div 100);
    StatusBar.Canvas.FillRect(Rec);
    txt := Status.Panels[4].Text;
    R := Rect;
    StatusBar.Canvas.Brush.Style := bsClear;
    StatusBar.Canvas.Font.Color := clGray;
    DrawText(StatusBar.Canvas.Handle, PChar(Txt), -1, R, DT_CENTER or DT_EXPANDTABS);
  end;
end;

procedure TbrFmPrincipal.OnLoadProgress(Porcentagem: Integer);  //do modelo.
begin
  Status.Panels[4].Text := IntToStr(Porcentagem) + '%';
  Status.Repaint;
//  Update;
end;

procedure TbrFmPrincipal.Todos_modelosExecute(Sender: TObject);
begin
  if SemModelo then
    Application.MessageBox('Não há nenhum esquema aberto!', 'Esquemas', mb_Ok or MB_ICONEXCLAMATION)
  else
    Application.MessageBox(PChar('Esquema selecionado:' + #13 + Modelo.Nome + #13 + Modelo.Arquivo), 'Esquemas', mb_Ok or MB_ICONEXCLAMATION);
end;

procedure TbrFmPrincipal.Todos_objetosExecute(Sender: TObject);
begin
  Box.HorzScrollBar.Position := 0;
  Box.VertScrollBar.Position := 0;
end;

procedure TbrFmPrincipal.MenuObjetosPopup(Sender: TObject);
  var i: integer;
    M: TMenuItem;
    IT: TGeralItem;
begin
  MenuObjetos.Items.Clear;
  if SemModelo then Exit;
  Modelo.GetItens(ListaDeObj);
  for i := 0 to ListaDeObj.Lista.Count -1 do
  begin
    M := TMenuItem.Create(MenuObjetos);
    It := ListaDeObj[I];
    M.Caption := IT.Texto;
    M.Tag := IT.Index;
    M.ImageIndex := IT.Tag;
    M.OnClick := Navega;
    MenuObjetos.Items.Add(M);
  end;
end;

procedure TbrFmPrincipal.MenuModelosPopup(Sender: TObject);
  var i, j: integer;
    M: TMenuItem;
begin
  brDM.Visual.GetModelos(ListaDeMer);
  MenuModelos.Items.Clear;
  j := brDM.Visual.Modelos.IndexOf(Modelo);
  for i := 0 to ListaDeMer.Lista.Count -1 do
  begin
    M := TMenuItem.Create(MenuModelos);
    M.Caption := ListaDeMer[I].Texto;
    M.Tag := ListaDeMer[I].Index;
    M.OnClick := ModelosSelect;
    if (j = M.Tag) then M.ImageIndex := 1 else M.ImageIndex := 0;
    MenuModelos.Items.Add(M);
  end;
end;

procedure TbrFmPrincipal.Navega(Sender: TObject);
  var B: Tbase;
begin
  if SemModelo then Exit;
  B := Modelo.FindByID((Sender as TMenuItem).Tag);
  if not Assigned(B) then exit;
  Box.HorzScrollBar.Position := 20 + B.Left;
  Box.VertScrollBar.Position := 20 + B.Top;
  Modelo.Selecionado := B;
end;

procedure TbrFmPrincipal.editarDicExecute(Sender: TObject);
begin
  if SemModelo or (Modelo.Selecionado = nil) then Exit;
  if Modelo.Selecionado is TCampo then
    if TCampo(Modelo.Selecionado).ApenasSeparador then Exit;
//  if Modelo.ModeloLogico then Exit;
  brFmDic := TbrFmDic.Create(nil);
  brFmDic.Dicionario.Lines.Text := Modelo.Selecionado.Dicionario;
  brFmDic.nomeObj.Caption := Denominar(Modelo.Selecionado.ClassName) + ': ' + Modelo.Selecionado.Nome;
  if brFmDic.ShowModal = mrOk then
  begin
    Modelo.Selecionado.Dicionario := StringReplace(brFmDic.Dicionario.Lines.Text, #13#10, #13, [rfReplaceAll]);
  end;
  brFmDic.Free;
end;

procedure TbrFmPrincipal.covToRestExecute(Sender: TObject);
begin
  if SemModelo or not (Modelo.Selecionado is TEspecializacao) then Exit;
  if not TEspecializacao(Modelo.Selecionado).ConverteEspToRestrita then
  onErro(nil, 'Operação não realizável!', 0);
end;

procedure TbrFmPrincipal.convToOpcExecute(Sender: TObject);
begin
  if SemModelo or not (Modelo.Selecionado is TEspecializacao) then Exit;
  if not TEspecializacao(Modelo.Selecionado).OpcionalizeEsp then
  onErro(nil, 'Operação não realizável!', 0);
end;

procedure TbrFmPrincipal.dicFullExecute(Sender: TObject);
begin
  with TbrFmDicFull.Create(nil) do
  begin
    Maker;
    ShowModal;
    free;
  end;
end;

procedure TbrFmPrincipal.SobreExecute(Sender: TObject);
begin
  // Inicio TCC II
  // exibe os créditos da aplicação
  frmSobre := TfrmSobre.Create(nil);
  frmSobre.ShowModal;
  freeAndNil(frmSobre);
  // Fim TCC II
end;

procedure TbrFmPrincipal.LCriar_campoUpdate(Sender: TObject);
begin
  if SemModelo then Exit;
  (Sender as TAction).Enabled := Modelo.QtdTabela > 0;
end;

procedure TbrFmPrincipal.LCriar_RelacaoUpdate(Sender: TObject);
begin
  if SemModelo then Exit;
  (Sender as TAction).Enabled := Modelo.QtdTabela > 1;
end;

procedure TbrFmPrincipal.criar_EntidadeUpdate(Sender: TObject);
begin
  if SemModelo then Exit;
  LCriar_tabela.Enabled := (Modelo.TipoDeModelo = tpModeloLogico);
  if (Sender as TAction) <> LCriar_tabela then
  (Sender as TAction).Enabled := not LCriar_tabela.Enabled;
  addXSLT.Enabled := LCriar_tabela.Enabled;
  GerarFisico.Enabled := LCriar_tabela.Enabled;
  fisicoTemplate.Enabled := LCriar_tabela.Enabled;
end;

procedure TbrFmPrincipal.editarDicUpdate(Sender: TObject);
begin
  if SemModelo then Exit;
  editarDic.Enabled :=
    (Modelo.TipoDeModelo = tpModeloConceitual) and (Modelo.Selecionado <> nil) and not(Modelo.Selecionado is TTexto);
  editarDicL.Enabled :=
    (Modelo.TipoDeModelo = tpModeloLogico) and (Modelo.Selecionado <> nil) and not(Modelo.Selecionado is TTexto);
end;

procedure TbrFmPrincipal.exp_LogicoExecute(Sender: TObject);
begin
  Modelo := brDM.Visual.ExportarParaLogico(Modelo);
  AtiveModelo;
end;

procedure TbrFmPrincipal.NovoLogicoExecute(Sender: TObject);
begin
  CrieNovoModelo(tpModeloLogico);

  // Inicio TCC II
  // seta o status das guias de ferramentas para o modelo logico
  Ribbon.SetApplicationModes([_MOD_LOGICO]);

  // atualiza o status dos controles
  UpdateRibbonControls;
  // Fim TCC II
end;

procedure TbrFmPrincipal.exp_LogicoUpdate(Sender: TObject);
begin
  if SemModelo then exit;
  exp_Logico.Enabled := (Modelo.TipoDeModelo = tpModeloConceitual) and (Modelo.QtdBase > 0);
  mod_exibirHint.Enabled := (Modelo.TipoDeModelo = tpModeloConceitual);
end;

procedure TbrFmPrincipal.fisicoTemplateExecute(Sender: TObject);
begin
  if SemModelo then exit;
  with TbrFmTmplFisico.Create(Self) do
  begin
    ModeloAtivo := Modelo;
    ShowModal;
    Free;
  end;
  OnSelecao(nil);
  OnSelecao(Modelo.Selecionado);
end;

procedure TbrFmPrincipal.Questao(TextoA, TextoB: string; topico_ajuda: integer;
  var ResultadoSugestao: Integer);
  var res: Word;
begin
  res := mrNo;
  brFmQuestao.Ajuda := topico_ajuda;
  brFmQuestao.Texto2.Items.Text := TextoB;
  brFmQuestao.Texto2.Height := 25 * brFmQuestao.Texto2.Items.Count + 5;
  brFmQuestao.Texto2.ItemIndex := ResultadoSugestao;
  brFmQuestao.Texto1.Caption := TextoA;
  if brFmQuestao.ShowModal <> mrOk then
  begin
    while true do
    begin
      res := Application.MessageBox('Cancelar conversão?', 'Cancelar operação', MB_YESNO or MB_ICONQUESTION);
      if res = mrYes then break
        else
          if brFmQuestao.ShowModal = mrOk then break;
    end;
  end;
  if (res = mrYes) then
  begin
    ResultadoSugestao := -1;
    exit;
  end;
  ResultadoSugestao := brFmQuestao.Texto2.ItemIndex;
end;

procedure TbrFmPrincipal.FormDestroy(Sender: TObject);
  var i: integer;
begin
  try
    for i:= 0 to AjudaArquivos.Count -1 do
    begin
      DeleteFile(AjudaArquivos[I]);
    end;
    AjudaArquivos.Free;
  except
  end;
  ListaDeTrabalho.Free;
//  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
end;

procedure TbrFmPrincipal.FormShow(Sender: TObject);
begin
  // Inicio TCC II
  // maximiza a janela da aplicação
  WindowState := wsMaximized;
  // Fim TCC II
end;

procedure TbrFmPrincipal.GerarFisicoExecute(Sender: TObject);
begin
  Modelo.Template.ApureToConvert;
  with TbrFmFisico.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
  Modelo.Template.RessetToNormal;
  OnSelecao(nil);
  OnSelecao(Modelo.Selecionado);
end;

procedure TbrFmPrincipal.verLogsExecute(Sender: TObject);
begin
  Util.Visible := verLogs.Checked;
  Conf.ExibirLog := verLogs.Checked;
  if verLogs.Checked then SplitterFDP.Top := Util.Top -1;
end;

procedure TbrFmPrincipal.limpar_logsExecute(Sender: TObject);
begin
  Util.Clear;
end;

procedure TbrFmPrincipal.salva_logsExecute(Sender: TObject);
begin
  brDM.SavaDic.FileName := 'logs' + FormatDateTime('DD.MM.YYYY.hh.mm', now) + '.log';
  with brDM.SavaDic do
    if Execute then
  begin
    try
      Util.Lines.SaveToFile(FileName);
//      DM.Visual.Writer.write('Logs salvos em arquivo ['+ FileName +'].', false, true);
    except
      on exception do onErro(nil, 'Não foi possível salvar os logs em!' + #13 +
                             '[' + FileName + '].', 0);
    end;
  end;
end;

procedure TbrFmPrincipal.BaseBeginUpdate(Sender: TObject);
begin
  if (Sender is TModelo) then Exit;
  Modelo.EveryHideShowSelection(nil, false);
end;

procedure TbrFmPrincipal.BaseEndUpdate(Sender: TObject);
begin
  if (Sender is TModelo) then Exit;
  Modelo.EveryHideShowSelection(nil, true);
  Modelo.EndOperation;
  if (Sender = nil) then
    Modelo.erro(Modelo.Selecionado, 'Erro ao alterar o valor da propriedade do objeto!', 0);
end;

procedure TbrFmPrincipal.BoxMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
  var scrH, scrW, LargBar: Integer;
  pt: TPoint;
begin
  if PtInRect(BoundsRect, MousePos) and not(Handled) then
  with box do
  begin
    pt := Box.ClientToScreen(point(Box.Top + Box.Height, Box.Left + Box.Width));
    scrH := pt.X;
    scrW := pt.Y;
    LargBar := GetSystemMetrics(SM_CXVSCROLL);
    if (MousePos.X < (scrW - LargBar)) and
       ((MousePos.Y > (scrH - LargBar)) and (MousePos.Y < scrH)) then
      HorzScrollBar.Position := HorzScrollBar.Position + HorzScrollBar.Increment
    else
      VertScrollBar.Position := VertScrollBar.Position + VertScrollBar.Increment;
    Handled := true;
  end;
end;

procedure TbrFmPrincipal.BoxMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
  var scrH, scrW, LargBar: Integer;
  pt: TPoint;
begin
  if PtInRect(BoundsRect, MousePos) and not(Handled) then
  with box do
  begin
    pt := Box.ClientToScreen(point(Box.Top + Box.Height, Box.Left + Box.Width));
    scrH := pt.X;
    scrW := pt.Y;
    LargBar := GetSystemMetrics(SM_CXVSCROLL);
    if (MousePos.X < (scrW - LargBar)) and
       ((MousePos.Y > (scrH - LargBar)) and (MousePos.Y < scrH)) then
      HorzScrollBar.Position := HorzScrollBar.Position - HorzScrollBar.Increment
    else
      VertScrollBar.Position := VertScrollBar.Position - VertScrollBar.Increment;
    Handled := true;
  end;
end;

procedure TbrFmPrincipal.autoSalvarExecute(Sender: TObject);
begin
  if SemModelo then exit;
  if not Modelo.AutoSalvar then
  begin
    if Modelo.Novo then arq_salvarcExecute(Sender);
    Modelo.AutoSalvar := not Modelo.Novo;
  end else Modelo.AutoSalvar := false;
  autoSalvar.Checked := Modelo.AutoSalvar;
end;

procedure TbrFmPrincipal.autoSalvarUpdate(Sender: TObject);
begin
  if SemModelo then autoSalvar.Enabled := false else
  begin
    autoSalvar.Enabled := True;
    autoSalvar.Checked := Modelo.AutoSalvar;
  end;
end;

procedure TbrFmPrincipal.TimerAutoSavaTimer(Sender: TObject);
  var M: TModelo;
  i: integer;
begin
  for i := 0 to brDM.Visual.Modelos.Count -1 do
  begin
    M := TModelo(brDM.Visual.Modelos[i]);
    if M.AutoSalvar and M.Mudou and (not M.Salvar) then
    begin
      onErro(nil, 'Não foi possível salvar o esquema "' + M.Nome + '".' + #13 +
             'O auto-salvamento do esquema foi desativado.', 1);
      M.AutoSalvar := false;
    end;
  end;
end;

procedure TbrFmPrincipal.cfgExecute(Sender: TObject);
  var i: integer;
  oldH: boolean;
begin
  brFmCfg.PageControl1.ActivePageIndex := 0;

  // Inicio TCC II
  // verifica se os diretórios existem antes do carregamento
  if (not DirectoryExists(Conf.dirConceitual)) then Conf.dirConceitual := sConceptModelDir;
  if (not DirectoryExists(Conf.dirLogico    )) then Conf.dirLogico     := sLogicalModelDir;
  if (not DirectoryExists(Conf.dirFisico    )) then Conf.dirFisico     := sPhysicalModelDir;

  // carrega os diretórios de salvamento da aplicação
  brFmCfg.dirConceitual.Text := Conf.dirConceitual;
  brFmCfg.dirLogico.Text     := Conf.dirLogico;
  brFmCfg.dirFisico.text     := conf.dirFisico;
  // Fim TCC II

  brFmCfg.SpinEdit1.Value := Conf.Tempo;
  oldH := mod_exibirHint.Checked;
  if brFmCfg.ShowModal = mrOK then
  begin
    Conf.showLHint := mod_exibirHint.Checked;
    Conf.dirLogico := brFmCfg.dirLogico.Text;
    Conf.dirConceitual := brFmCfg.dirConceitual.Text;
    Conf.Tempo := brFmCfg.SpinEdit1.Value;
    RefreshCfg;
  end else mod_exibirHint.Checked := oldH;
end;

procedure TbrFmPrincipal.act1Execute(Sender: TObject);
  var fileName: String;
      M: TModelo;
begin
  fileName := (Sender as TAction).Hint;
  if not FileExists(fileName) then
  begin
    onErro(nil, 'Não foi possível encontrar o arquivo.' + #13 + 'Arquivo: ' + fileName, 0);
    exit;
  end;

  if not SemModelo and Modelo.Novo and not Modelo.Mudou then
  begin
    if not brDM.Visual.LoadFromFile(FileName, Modelo.Nome, Modelo) then
    begin
      brDM.Visual.Fecha;
      arq_novoExecute(Self);
    end else
    begin
      brDM.Visual.Modelo.Mudou := false;
    end;
  end else
  begin
    M := brDM.Visual.gera(FileName, false);
    if Assigned(M) then
    begin
      Modelo := M;
    end;
  end;
  Modelo := brDM.Visual.Modelo;
  if Assigned(Modelo) then AtiveModelo;
end;

procedure TbrFmPrincipal.act1Update(Sender: TObject);
  var A: TAction;
begin
  A := (Sender as TAction);
  A.Visible := (A.Caption <> '');
  A.Enabled := not brDM.Visual.ModeloFindByArq(A.Hint);
end;

procedure TbrFmPrincipal.RefreshCfg;
begin
  Conf.refreshArq;
  if TimerAutoSava.Interval <> (Conf.Tempo * 60000) then TimerAutoSava.Interval := (Conf.Tempo * 60000);
end;

procedure TbrFmPrincipal.Ribbon1HelpButtonClick(Sender: TObject);
begin
  // Início TCC II - Puc (MG) - Daive Simões
  // Inserindo a chamada à tela de Sobre no novo botão de Ajuda da aplicação
  SobreExecute(Sender);
  // Fim TCC II
end;

procedure TbrFmPrincipal.xsl_makerExecute(Sender: TObject);
begin
  brFmVisuXSLT := TbrFmVisuXSLT.Create(nil);
  brFmVisuXSLT.PageControl1.ActivePageIndex := 0;
  if (Modelo <> nil) and (FileExists(Modelo.Arquivo))
     and (AnsiUpperCase(ExtractFileExt(Modelo.Arquivo)) = '.XML')
       then brFmVisuXSLT.arq.Text := Modelo.Arquivo else brFmVisuXSLT.arq.Text := '';
  brFmVisuXSLT.showModal;
  brFmVisuXSLT.Free;
end;

procedure TbrFmPrincipal.SplitterFDPCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  Accept := (NewSize < 200) AND (NewSize > 15);
end;

procedure TbrFmPrincipal.selAttExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  if (Modelo.Selecionado <> nil) and (Modelo.TipoDeModelo = tpModeloConceitual) then Modelo.SelecioneSelecionadosAtributos;
end;

procedure TbrFmPrincipal.ModeloOpcPopup(Sender: TObject);
begin
  if SemModelo then Exit;
//  for i:= 3 to 4 do
//  begin
//    TMenuItem(ModeloOpc.Items[i]).Visible := (Modelo.TipoDeModelo = tpModeloConceitual);
//  end;
  TMenuItem(ModeloOpc.Items[0]).Visible := Modelo.Selecionado is TAtributo;
  TMenuItem(ModeloOpc.Items[1]).Visible := Modelo.Selecionado is TEntidade;
  TMenuItem(ModeloOpc.Items[2]).Visible := TMenuItem(ModeloOpc.Items[1]).Visible;
  TMenuItem(ModeloOpc.Items[3]).Visible := (Modelo.TipoDeModelo = tpModeloConceitual);
  TMenuItem(ModeloOpc.Items[4]).Visible := (Modelo.TipoDeModelo = tpModeloLogico);
end;

procedure TbrFmPrincipal.addXSLTExecute(Sender: TObject);
begin
  if SemModelo then Exit;
  brFmInsXSL := TbrFmInsXSL.Create(nil);
  brFmInsXSL.XSL.DefaultXsl := Modelo.Xsl;
  brFmInsXSL.ShowModal;
  Modelo.Xsl := brFmInsXSL.XSL.XSL;
  brFmInsXSL.Free;
end;

end.

