unit mer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Dialogs,
  ExtCtrls, Forms, Contnrs, uAux, att, XMLIntf, TypInfo, XMLDoc, Clipbrd, uMemoria, uTemplate;

const
  TamArSerial = 35;
  mVersao = versaoAtual;

type
  TModelo = class;
  TBase = class;

  TBaseEvent = procedure(BaseSender: TBase) of object;
  TBaseErro = procedure(BaseSender: TBase; Texto: string; tipoErro: integer) of object;
  TModeloOnLoadProgress = procedure(Porcentagem: Integer) of object;
  TModeloOnQuestion = procedure(TextoA, TextoB: string;topico_ajuda: integer; var ResultadoSugestao: Integer) of object;

  TResultIArray = array [0..TamArSerial] of Integer;

{$region 'Origem'}

  TOrigem = class(TGraphicControl)
  protected
    FModelo: TModelo;
  public
    property Modelo: TModelo read FModelo write FModelo;
    constructor Create(AOwner: TComponent); override;
  end;

  THintBalao = class(TOrigem)
  private
    FPosiSeta: integer;
    FTexto: String;
    FReferencia: TRect;
    FForca: Boolean;
    procedure SetPosiSeta(const Value: integer);
    procedure SetTexto(const Value: String);
    procedure SetReferencia(const Value: TRect);
  protected
    procedure Organize;
    Procedure Paint; override;
  published
    Property PosiSeta: integer read FPosiSeta write SetPosiSeta;
    Property Texto: String read FTexto write SetTexto;
    constructor Create(Aowner: TComponent);override;
    property Referencia: TRect read FReferencia write SetReferencia;
    Procedure Show(aPosicao: TRect; oTexto: String);
  end;

  TPonto = class(TOrigem)
  Private
    Down: TPoint;
    FDono: Tbase;
    FPosicao: Integer;
    EmLinha, EmColuna: TPonto;
    FRecuo: integer;
    procedure SetProsicao(const Value: Integer);
    procedure SetRecuo(const Value: integer);
  Protected
    isMouseDown: Boolean;
    procedure Paint;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    property Recuo: integer read FRecuo write SetRecuo;
  Public
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property Posicao: Integer Read FPosicao Write SetProsicao;//Posiciona o ponto em relação à sua base.
    constructor Create(AOwner: TComponent);override;
  end;

  TSeta = class(TOrigem)
  private
    Pai: TBase;
    Posicao: integer;
    Largura: integer;
  protected
    procedure Paint; override;
  public
    procedure Alinhe(aPosicao: integer);
    procedure Realinhe;
    constructor Create(AOwner: TComponent); override;
  end;

  TLinha = class(TOrigem)
  Private
    FisWeak, FAtualizando, FMovimentavel: boolean;
    FOrientacao, FLargura: integer;
    FInicio, FFim, down: TPoint;
    FonNovaOrientacao: TNotifyEvent;
    procedure SetisWeak(const Value: boolean);
    procedure SetOrientacao(const Value: integer);
    procedure SetFim(const Value: TPoint);
    procedure SetInicio(const Value: TPoint);
    procedure SetLargura(const Value: integer);
    procedure SetAtualizando(const Value: Boolean);
    procedure SetMovimentavel(const Value: Boolean);
    procedure SetonNovaOrientacao(const Value: TNotifyEvent);
  Protected
    IsMouseDown: Boolean;
    Property  onNovaOrientacao: TNotifyEvent read FonNovaOrientacao write SetonNovaOrientacao;

    procedure DblClick;override;
    procedure Paint;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  Public
    property OnMouseLeave;
    property OnMouseEnter;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    Property  Movimentavel: Boolean read FMovimentavel write SetMovimentavel;//esta linha pode ser arrastada?
    Property  Inicio: TPoint read FInicio write SetInicio;//Ponto de início da linha em relação ao TModelo
    Property  Fim: TPoint read FFim write SetFim;
    property  isWeak: boolean read FisWeak write SetisWeak;//Usado para tracar linha dupla em caso de entidade fraca
    property  Orientacao: integer read FOrientacao write SetOrientacao;//A linha pode ser traçada na horizontal ou vertical
    property  Largura: integer read FLargura write SetLargura;//se a linha estiver na horizontal, representa a altura do componente se não representa a largura
    property  Atualizando: Boolean read FAtualizando write SetAtualizando;
    constructor Create(AOwner: TComponent);override;
  end;

{$endregion}

  TCardinalidade = class;
  TLigacao = class(TComponent)
  Private
    FModelo: TModelo;
    LinhaA, LinhaB, LinhaMeio: TLinha; //as três linhas da base
    FE1, FE2, Pai, Ponta: TBase;
    PontoInicial1, PontoFinal1, PontoInicial2, PontoFinal2: TPoint;
    FOrientacao,
    PontoInicial, PontoFinal: integer;//Qual é o ponto [1..4] da entidade/relação (inicial ou final) a que esta ligação está ligada
    BaseInicial, BaseFinal: Tbase;
    FAtualizando: boolean;
    FMostraCardinalidade: boolean;
    FCard: TCardinalidade;
    FSuspendLineMove: boolean;
    function Get_Comando: TResultIArray;
    procedure Set_Comando(const Value: TResultIArray);
    procedure SetCard(const Value: TCardinalidade);
    Function GetCardinalidade: Integer;
    procedure SetModelo(const Value: TModelo);
    procedure SetE1(const Value: TBase);
    procedure SetE2(const Value: TBase);
    procedure SetOrientacao(const Value: integer);
    procedure SetAtualizando(const Value: boolean);
    procedure SetMostraCardinalidade(const Value: boolean);
    procedure SetCardinalidade(const value: integer);
    procedure SetSuspendLineMove(const Value: boolean);
    function GetFraca: boolean;
    procedure SetFraca(const Value: boolean);  //impede o redesenho da linha em uma movimentação
  Protected
    property Modelo: TModelo read FModelo write SetModelo;
    Procedure OnNovaHorientacao(Linha: TObject);
    procedure OnLinhaMouseDown(Linha: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    Procedure OnLinhaClick(Linha: TObject);
    Procedure PosicioneCardinalidade;
    Property SuspendLineMove: boolean read FSuspendLineMove write SetSuspendLineMove;
    Procedure to_xml(node: IXMLNode);
    Procedure Muda;
    Procedure OnLinhaMouseEnter(Linha: TObject);
    Procedure OnLinhaMouseLeave(Linha: TObject);
    Procedure OnLinhaMouseEvento(entrou: boolean);
  Public
    Function MePonto(Eu: TBase): integer;
    Function BasePertence(B: TBase): boolean;       //verifica se a ligação liga-se a
    Function Generate(lE1, lE2: TBase): Boolean;    //Liga duas bases com esta ligação
    constructor Create(AOwner: TComponent);override;
    Function Ative: boolean;
    Procedure AtiveLinha(L: TLinha; Ini, Fim: TPoint; ori: Integer);
    destructor Destroy;override;
    Property Card: TCardinalidade read FCard write SetCard;
    property _Comando: TResultIArray read Get_Comando write Set_Comando;
    Property Atualizando: boolean read FAtualizando write SetAtualizando;
    Property Orientacao: integer read FOrientacao write SetOrientacao;
    Property E1: TBase read FE1 write SetE1;        //Bases não necessariamente nesta ordem nesta ligação
    Property E2: TBase read FE2 write SetE2;        //
    Property Cardinalidade: Integer read GetCardinalidade write SetCardinalidade;
    Property MostraCardinalidade: boolean read FMostraCardinalidade write SetMostraCardinalidade;
    Property Fraca: boolean read GetFraca write SetFraca;
  end;

  TBase = class(TPaintBox)
  private
    FMovido: TRect;
    FOID: integer;//identificador único
    FLigacoes, FAtributos, FAnexos: TComponentList;//listas de controle
    Me : Tbase;
    This, Reenquadrou: Boolean;
    FModelo: TModelo;
    FNome: string; //caption
    Pontos: Array [1..4] of Tponto;
    FSelecionado: boolean;
    Down: TPoint;
    FOnMoved: TNotifyEvent;
    FAtualizando, Destruindo: Boolean;
    FObservacoes: String;
    FNula: Boolean;
    FDicionario: String;
    FAOcultos: TConjPAtt;
    Fassociacao: TBase;
    LastTamanhoOrigem: TPoint;
    FFuturo: string;
    procedure SetFuturo(const Value: string);
    function Get_AOcultos: string;
    procedure Set_AOcultos(const Value: string);
    procedure SetLigacoes(const Value: TComponentList);
    procedure SetNome(const Value: string);virtual;
    procedure SetSelecionado(const Value: boolean);virtual;
    procedure reposicione;virtual;//reposiciona os pontos de seleção à base
    procedure SetOnMoved(const Value: TNotifyEvent);
    procedure SetAtualizando(const Value: Boolean);virtual;
    Procedure Divida(Ponto, Qtd: integer);//reparte as distâncias entre as ligações de um base que estão em um determinado ponto em tamanhos iguais
    Procedure AtivePorPonto(P: integer);
    procedure SetObservacoes(const Value: String);
    procedure SetNula(const Value: Boolean);     //reativa/redesenha apenas a ligações da base que estão em um determinado ponto
    procedure SetDicionario(const Value: String);
    procedure SetFontColor(const Value: TColor);
    procedure SetFontStyles(const Value: TFontStyles);
    function GetColor: TColor;
    function GetFontStyles: TFontStyles;
    Procedure LiberarLinhas;virtual;
    procedure SetAOcultos(const Value: TConjPAtt);
    procedure Setassociacao(const Value: TBase);
  protected
    isMouseDown: Boolean;
    Encaixe: array [1..4] of TPoint;      //pontos para referencia de encaixe das ligações
    Function CanLiga(B: TBase): boolean;virtual;
    Procedure Liga(L: TLigacao);
    Function QuantosNestePonto(P: integer): integer; //quantas ligações fazem referencia/usam este pontos
    Procedure Realinhe;virtual;                   //reatia/redesenha todas as ligações
    Property Atualizando: Boolean read FAtualizando write SetAtualizando;
    Procedure reSetBounds;virtual;                //reposiciona a ligação em relação aos seus pontos (após o movimento de um deles)
    Property Selecionado: boolean read FSelecionado write SetSelecionado;
    procedure Paint;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    Procedure Movimente(aLeft, aTop, aWidth, aHeight: integer); virtual;//movimneta qualquer outra base que esteja anexada
    Procedure AtualizaEncaixes;virtual;   //gera os valores para os encaixes
    Property Nula: Boolean read FNula write SetNula;
    Procedure PrepareToAtive(L:TLigacao);virtual;
    procedure Click;override;
    procedure SendClick;virtual;//criada apenas para possibilitar o override no caso do evento click
    Procedure SendMouseMove;virtual;//
    Procedure AdjustSize;override;
    Procedure Ligacoesto_xml(var node: IXMLNode);virtual;
    Procedure to_xml(var node: IXMLNode);virtual;
    Procedure Muda;
    Procedure PinteImagem(Img, X, Y: Integer; Habilitada: boolean = true);
    Procedure LigacaoEventoDoMouse(entrou: boolean); virtual;
  public
    Procedure SelecionarAtributos;virtual;
    Procedure FonteChanged;virtual;
    Procedure Reenquadre; //Vê se esta base não está fora da área do Modelo
    Function AtributosOcultosToTexto: String;
    Procedure OrganizeAtributos;virtual;          //arruma e ordena os atributos
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property OnMoved: TNotifyEvent read FOnMoved write SetOnMoved;
    property Modelo: TModelo read FModelo write FModelo;
    property Anexos: TComponentList read FAnexos write FAnexos;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    Function NovoAtributo(oNome: String): Tbase; //adiciona atributo
    Function Anexar(B: Tbase): integer;
    Function DesAnexar(B: Tbase): integer;
    Procedure Repaint;override;
    property associacao: TBase read Fassociacao write Setassociacao;
    Function GetLigacao(LigadoCom: TBase): TLigacao;
    Procedure Load; virtual;
    Property Futuro: string read FFuturo write SetFuturo;
  published
    property Font;
    property Atributos: TComponentList read FAtributos write FAtributos;
    Property AOcultos: TConjPAtt read FAOcultos write SetAOcultos;
    property OID: integer Read FOID Write FOID;
    Property Observacoes: String read FObservacoes write SetObservacoes;
    Property Nome: string read FNome write SetNome;
    Property Dicionario: String read FDicionario write SetDicionario;
    Property FontColor: TColor read GetColor write SetFontColor;
    Property FontStyles: TFontStyles read GetFontStyles write SetFontStyles;
    Property Ligacoes: TComponentList read FLigacoes write SetLigacoes;
    Property _AOcultos: string read Get_AOcultos write Set_AOcultos;
  end;

  TSelecao = class(TOrigem)
  protected
    procedure Paint;override;
  end;

  TBaseTexto = class(TBase)
  private
    FTipo: Integer;
    FCor: TColor;
    FTamAuto: boolean;
    FTextAlin: Word;
    procedure SetTipo(const Value: Integer);
    procedure SetCor(const Value: TColor);
    procedure SetTamAuto(const Value: boolean);
    procedure SetTextAlin(const Value: Word);
  protected
    procedure Paint;override;
    Procedure to_xml(var node: IXMLNode);override;
    Property Cor: TColor read FCor write SetCor;
  Public
    constructor Create(AOwner: TComponent);override;
    Property Tipo: Integer read FTipo write SetTipo;
    Property TextAlin: Word read FTextAlin write SetTextAlin;
  Published
    Property TamAuto: boolean read FTamAuto write SetTamAuto;
  end;

  TTexto = class(TBaseTexto)
  Published
    Property Cor;
    Property Tipo;
    Property TextAlin;
  end;

  TCardinalidade = class(TBaseTexto)
  private
    FFixa: Boolean;
    FComando: TLigacao;
    FCardinalidade: Integer;
    FCorSel: TColor;
    _FComando: string;
    function Get_Comando: String;
    procedure Set_Comando(const Value: String);
    Function GetOrientacaoLinha: Integer;
    procedure SetOrientacaoLinha(const Value: Integer);
    procedure SetComando(const Value: TLigacao);
    procedure SetFixa(const Value: Boolean);
    function GetFraca: Boolean;
    procedure SetFraca(const Value: Boolean);
    procedure SetCardinalidade(const Value: Integer);
    procedure SetSelecionado(const Value: boolean);override;
  Protected
    Procedure to_xml(var node: IXMLNode);override;
    procedure Paint;override;
  Public
    Procedure Load; override;
    Procedure SelLine(sn: boolean);
    Procedure ToCardinalidade(C: Integer);
    constructor Create(AOwner: TComponent);override;
    Property Comando: TLigacao read FComando write SetComando;
  published
    Property OrientacaoLinha: Integer read GetOrientacaoLinha write SetOrientacaoLinha;
    Property Fixa: Boolean read FFixa write SetFixa;
    Property Fraca: Boolean read GetFraca write SetFraca;
    Property Cardinalidade: Integer read FCardinalidade write SetCardinalidade;
    property _Comando: String read Get_Comando write Set_Comando;
  end;

  TEspecializacao = class;
  TAutoRelacao = class;

  TBaseEntidade = class(TBase)
  Private
    FAutoRelacao: TAutoRelacao;
    _FAutoRelacao: Integer;
    function Get_AutoRelacao: Integer;
    function GetAutoRelacionado: boolean;
  protected
    procedure Paint;override;
    Procedure to_xml(var node: IXMLNode);override;
  public
    procedure Load; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    Function AutoRelacionar(Nome: String): boolean;
    Function DestruirAutoRelacao: Boolean;
    destructor Destroy;override;
  published
    Property AutoRelacionado: boolean read GetAutoRelacionado;
    property _AutoRelacao: integer read Get_AutoRelacao write _FAutoRelacao;
  end;

  TEntidade = class(TBaseEntidade)
  private
    Especializacoes: TComponentList;
    FOrigem: TEspecializacao;
    FOrigens: TList;
    F_Origens: string;
    F_Origem: Integer;
    function get_Origem: Integer;
    function get_Origens: string;//herança multipla
    function getEhEsp: boolean;
    procedure SetOrigem(const Value: TEspecializacao);
    function GetOrigem: TEspecializacao;
  Protected
    Function HaRestrita: Boolean;
    Procedure to_xml(var node: IXMLNode);override;
  Public
    procedure Load; override;
    Function Especialise(Tipo: Integer; Parcial: boolean = false): Boolean;
    Function CriarEsp: TEspecializacao;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    Function ConverteEspToRestrita(Pedinte: TBase): Boolean;//converter as especializações opcionais para uma única especialização restrita.
//      Function OpcionalizeEsp(Pedinte: TBase): Boolean;//converter a especialização restrita em várias especializações opcionais.
    Property Origem: TEspecializacao read GetOrigem write SetOrigem;
    Function ehHerancaMultipla: boolean;
    Procedure GetEntidadesDescendentes(aLista: TList);
  published
    Property Especializada: boolean read getEhEsp;
    property _Origens: string read get_Origens write F_Origens;
    property _Origem: Integer read get_Origem write F_Origem;
  end;

  TBaseRelacao = class(TBase)
  private
    FNaoPinteNome: boolean;
    function GetSetaDirecao: Integer;
    procedure SetDirecao(const Value: TSeta);
    procedure SetSetaDirecao(const Value: Integer);
    procedure SetNaoPinteNome(const Value: boolean);
  protected
    Regiao: HRGN;
    FDirecao: TSeta;
    procedure Paint;override;
    Procedure Realinhe;override;                   //reatia/redesenha todas as ligações
    Procedure to_xml(var node: IXMLNode);override;
    Procedure PrepareToAtive(Lg:TLigacao);override;
    Function isMine(P: TPoint): boolean;
    property Direcao: TSeta read FDirecao write SetDirecao;
  Public
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    Function Relacione(E: TBaseEntidade): boolean;virtual;
    constructor Create(AOwner: TComponent);override;
    Property NaoPinteNome: boolean read FNaoPinteNome write SetNaoPinteNome;
    Property SetaDirecao: Integer read GetSetaDirecao write SetSetaDirecao;
  end;

  TMaxRelacao = class(TBaseRelacao)
    Procedure GetEntidadtes(aLista: TList);
    Function QtdEntidadesLigadas: Integer;
  published
    Property SetaDirecao;
  end;

  TRelacao = class(TMaxRelacao) //(Component is TBaseRelacao) and not is TAutoRelacao
  Public
  end;

  TChildRelacao = class(TMaxRelacao) //(Component is TBaseRelacao) and not is TAutoRelacao
  protected
    Pai: TBase;
  end;

  TAutoRelacao = class(TBaseRelacao)
  Private
    MyPosi: Integer;
  protected
    Pai: TBaseEntidade;
    function  CanLiga(B: TBase): boolean;override;
    Function  Posi: Integer;virtual; //a que ponto da entidade se está ligado
    Procedure PrepareToAtive(Lg:TLigacao);override;
  Public
    procedure Load; override;
    Procedure NeedPaint;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    destructor Destroy;override;
  end;

  TEspecializacao = class(TBase)
  private
    MyPosi: Integer;
    FalsasBases: array [1..4] of TPoint;
    FEntidadeBase: TEntidade;
    FTipo: Integer;
    FParcial: Boolean;
    F_EntBase: Integer;
    function Get_EntBase: Integer;
    procedure SetEntidadeBase(const Value: TEntidade);
    procedure SetTipo(const Value: Integer);
    procedure SetParcial(const Value: Boolean);
    function getTipo: boolean;
  protected
    Usr_Conv_Opc: integer; //auxílio para conversão
    procedure Paint;override;
    function CanLiga(B: TBase): boolean;override;
    Function Posi: Integer; //se está para cima ou para baixo da entidade base
    Procedure Redesenhe(ALeft, ATop, AWidth, AHeight: Integer);overload;
    Procedure Redesenhe;overload;
    Procedure PrepareToAtive(L:TLigacao);override;
    Procedure to_xml(var node: IXMLNode);override;
  Public
    Procedure Load; override;
    Procedure Reconceitue;
    Function ConverteEspToRestrita: Boolean;//chama a entidade proprietária.
    Function OpcionalizeEsp: Boolean;//converter a especialização restrita em várias especializações opcionais.
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    Property EntidadeBase: TEntidade read FEntidadeBase write SetEntidadeBase;
    Function Adicione(E: TEntidade): boolean;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    Procedure NeedPaint;
    Procedure getChilds(aLista: TList);
  Published
    Property Tipo: Integer read FTipo write SetTipo;
    Property Parcial: Boolean read FParcial write SetParcial;
    Property Restrito: boolean read getTipo;
    property _EntBase: Integer read Get_EntBase write F_EntBase;
  end;

  TEntidadeAssoss = class(TBaseEntidade)
  private
    FRelacao: TChildRelacao;
    _FChildRelacao: integer;
    //_RelacaoNome, _RelecaoDicionario, _RelecaoObservacao: string;
    Function GetSetaDirecao: Integer;
    procedure SetSetaDirecao(const Value: Integer);
    function Get_ChildRelacao: integer;
    procedure SetRelacaoNome(const Value: String);
    procedure SetRelecaoDicionario(const Value: String);
    procedure SetRelecaoObservacao(const Value: String);
    function GetRelacaoNome: String;
    function GetRelecaoDicionario: String;
    function GetRelecaoObservacao: String;
    procedure SetAtualizando(const Value: Boolean);override;
  protected
    procedure Paint;override;
    procedure SendClick;override;//o override no caso do evento click
    Procedure SendMouseMove;override;//"
    Procedure to_xml(var node: IXMLNode);override;
  public
    procedure Load; override;
    Procedure OrganizeAtributos;override;          //arruma e ordena os atributos
    Property Relacao: TChildRelacao read FRelacao;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  Published
    Property RelacaoNome: String read GetRelacaoNome write SetRelacaoNome;
    Property RelecaoDicionario: String read GetRelecaoDicionario write SetRelecaoDicionario;
    Property RelecaoObservacao: String read GetRelecaoObservacao write SetRelecaoObservacao;
    property _ChildRelacao: integer read Get_ChildRelacao write _FChildRelacao;
    Property SetaDirecao: Integer read GetSetaDirecao write SetSetaDirecao;
  end;

  TBarraDeAtributos = class;
  TAtributo = class(TBase)
  private
    FOrientacao: Integer;
    FDono: TBase;
    FAltura: Integer;
    FMultivalorado: boolean;
    FIdentificador: Boolean;
    FTamAuto: boolean;
    FTipoDoValor: String;
    FDesvio: integer;
    FBarra: TBarraDeAtributos;
    FMaxCard, FMinCard: integer;
    IgnoreMult: boolean;
    _FDono: Integer;


    // Início TCC II - Puc (MG) - Daive Simões
    // Inclusão da nova propriedade de quantidade de campos a serem criados
    // para atributos multivalorados
    FQtdeMultivalorado : Integer;

    // complemento dos campos que o necessitam. Ex.: NUMERIC(14), VARCHAR(100)
    FComplemento       : string;
    // Fim TCC II


    function Get_Dono: Integer;
    procedure Set_Dono(const Value: Integer);
    procedure SetOrientacao(const Value: Integer);
    Function GetEhOpcional: Boolean;
    procedure SetDono(const Value: TBase);
    procedure SetAltura(const Value: Integer);
    procedure SetMultivalorado(const Value: boolean);
    procedure SetIdentificador(const Value: Boolean);
    procedure SetCardinalidade(const Value: Integer);
    procedure SetTamAuto(const Value: boolean);
    procedure SetTipoDoValor(const Value: String);
    function GetMultivalorado: boolean;
    function getComposto: boolean;
    procedure SetOpcional(const Value: boolean);
    procedure SetDesvio(const Value: integer);
    procedure SetBarra(const Value: TBarraDeAtributos);
    procedure SetForcaOrientacao(const Value: Integer);
    procedure SetMaxCard(const Value: integer);
    procedure SetMinCard(const Value: integer);

    // Início TCC II - Puc (MG) - Daive Simões
    // métodos de get e set das novas propriedades da classe
    procedure SetQtdeMultivalorado(const Value: integer);
    procedure SetComplemento      (const Value: string);
    // Fim TCC II

    function GetCardinalidade: Integer;
  protected
    Function Posi: Integer;
    procedure Paint;override;
    Procedure AtualizaEncaixes;override;
    procedure DblClick;override;
    Procedure Realinhe;override;                   //reatia/redesenha todas as ligações
    Procedure to_xml(var node: IXMLNode);override;
    Property Orientacao: Integer read FOrientacao write SetOrientacao;
  public
    Procedure Load; override;
    procedure SelecionarAtributos;override;
    Procedure OrganizeAtributos;override;
    Procedure Organize;
    constructor Create(AOwner: TComponent);overload; override;
    constructor Create(AOwner: TComponent; oDono: Tbase);reintroduce;overload;
    destructor Destroy;override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    Procedure getChilds(aLista: TList);
    Function CardStr:String;
    Function ConvCard: integer;
    Procedure MeSelecione;
    Property Dono: TBase read FDono write SetDono;
    Property Barra: TBarraDeAtributos read FBarra write SetBarra;
  Published
    Property Altura: Integer read FAltura write SetAltura;
    Property Identificador: Boolean read FIdentificador write SetIdentificador;
    Property Multivalorado: boolean read GetMultivalorado write SetMultivalorado;
    Property Cardinalidade: Integer read GetCardinalidade write SetCardinalidade;
    Property Composto: boolean read getComposto;
    Property TamAuto: boolean read FTamAuto write SetTamAuto;
    Property TipoDoValor: String read FTipoDoValor write SetTipoDoValor;
    Property Opcional: boolean read GetEhOpcional write SetOpcional;
    Property Desvio: integer read FDesvio write SetDesvio;
    Property ForcaOrientacao: Integer read FOrientacao write SetForcaOrientacao;
    Property MaxCard: integer read FMaxCard write SetMaxCard;
    Property MinCard: integer read FMinCard write SetMinCard;
    Property  _Dono: Integer read Get_Dono write Set_Dono;

    // Início TCC II - Puc (MG) - Daive Simões
    // nova propriedade para especificação no número de campos multivalorados
    // a serem criados
    Property QtdeMultivalorado: integer read FQtdeMultivalorado write SetQtdeMultivalorado;
    Property Complemento      : string  read FComplemento       write SetComplemento;
    // Fim TCC II
  end;

  TBarraDeAtributos = class(TBase)
  private
    FDono: TAtributo;
    _FDono: Integer;
    function Get_Dono: Integer;
    procedure Set_Dono(const Value: Integer);
    procedure SetDono(const Value: TAtributo);
  protected
    Procedure PrepareToAtive(L:TLigacao);override;
    procedure Paint;override;
    procedure SendClick;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    Procedure to_xml(var node: IXMLNode);override;
  Public
    Procedure Load; override;
    Procedure MeSelecione;
    Procedure OrganizeAtributos;override;
    Procedure posicione;
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; oDono: TAtributo); reintroduce; overload;
    Property Dono: TAtributo read FDono write SetDono;
  published
    Property  _Dono: Integer read Get_Dono write Set_Dono;
  end;

//Lógico
  TCampo = Class;
  TTabela = Class(TBase)
  private
    FIniCampos: integer;
    FCampos: TComponentList;
    FFimCampos: integer;
    F_Campos: string;
    FComplemento: string;
    FcOrdem: integer; 
    function GetChaves: string;
    procedure SetcOrdem(const Value: integer);
    procedure SetComplemento(const Value: string);
    function get_Campos: string;
    procedure SetIniCampos(const Value: integer);
    procedure SetCampos(const Value: TComponentList);
    function GetQtdCampos: integer;
    procedure SetFimCampos(const Value: integer);
    Procedure LiberarLinhas;override;
  protected
    Interferencia: integer; //cada vez que o usuário escolheu uma opção que impedia a exclusão da entidade/tabela (inc)
    Excluir: Boolean; //pelo menos uma vez o usuário disse para excluir esta relação.
    procedure Paint;override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    Procedure to_xml(var node: IXMLNode);override;
    Procedure PrepareParaTrocar(aOrigem: TCampo; oPonto: TPoint);
    Procedure PodeTrocar(aOrigem: TCampo; oPonto: TPoint);
    Property IniCampos: integer read FIniCampos write SetIniCampos;
    Property FimCampos: integer read FFimCampos write SetFimCampos;
  Public
    Procedure Load; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    Property Campos: TComponentList read FCampos write SetCampos;
    constructor Create(AOwner: TComponent);override;
    Procedure PosicioneCampos;
    Function AddCampo(oCampo: TCampo): TCampo;
    Procedure CampoRemovido(oCampo: TCampo);
    destructor Destroy;override;
    Function ImportarCampo(oCampo: TCampo): TCampo;
    Procedure ReleaseTable(aTabela: TTabela);
    Function CountLigToTabela(aTabela: TTabela): integer;
    Function GetTLChaves: Integer;

    // Início TCC II - Puc (MG) - Daive Simões
    // novo método para pesquisar se um determinado campo com o mesmo nome
    // já existe na lista de campos da tabela
    function jaExisteCampo(nomeAtributo: string): boolean;
    // Fim TCC II
  Published
    Property QtdCampos: integer read GetQtdCampos;
    property _Campos: string read get_Campos write F_Campos;
    property Complemento: string read FComplemento write SetComplemento;
    property Chaves: string read GetChaves;
    Property cOrdem: integer read FcOrdem write SetcOrdem;
  end;

  TCampo = Class(TBase)
  private
    FDono, FTabOri: TTabela;
    FCampoOrigem: TCampo;
    FIsKey: Boolean;
    FIsFKey: Boolean;
    FTipo: String;
    FApenasSeparador: boolean;
    FOverMe: Boolean;
    OldCr: Integer;
    FBkpFontColor: TColor;
    AOAss: TAtributoOculto;
    ValorInicialFKTabOrigem, ValorInicialFKCampoOrigem: Integer;
    _FDono: integer;
    F_TabOri: Integer;
    F_CampoOri: Integer;
    FComplemento: string;
    FddlOnDelete: integer;
    FddlOnUpdate: integer;

    FPrecisao: string;

    procedure SetddlOnDelete(const Value: integer);
    procedure SetddlOnUpdate(const Value: integer);
    procedure SetComplemento(const Value: string);
    function GetTipo: String;
    function Get_CampoOri: Integer;
    function GetCampoOrigem: Integer;
    procedure SetCampoOrigem(const Value: Integer);
    function Get_TabOri: Integer;
    function Get_Dono: Integer;
    procedure SetDono(const Value: TTabela);
    procedure SetIsKey(const Value: Boolean);
    procedure SetIsFKey(const Value: Boolean);
    procedure SetTipo(const Value: String);
    procedure SetSelecionado(const Value: boolean);override;
    procedure SetoIndex(const Value: integer);
    Function GetoIndex: integer;
    procedure SetApenasSeparador(const Value: boolean);
    procedure SetOverMe(const Value: Boolean);
    function GetTabOrigem: Integer;
    procedure SetTabOrigem(const Value: Integer);

    procedure SetPrecisao(const Value: string);
  protected
    UnMonved: boolean; //auxílio para conversão: não copiar para novas especializações campos que são originários de uma outra especialização da entidade
    _CampoKey: TCampo;
    procedure SetNome(const Value: string);override;
    procedure Paint;override;
    Procedure OrganizeSe(aLeft, aTop, aWidth: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    Procedure to_xml(var node: IXMLNode);override;
    procedure RealiseConversao;
  Public
    Procedure Load; override;
    Procedure FonteChanged;override;
    Property  Dono: TTabela read FDono write SetDono;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    Property  OverMe: Boolean read FOverMe write SetOverMe;
    Property TabelaDeOrigem: TTabela read FTabOri;
    Property CampoDeOrigem: TCampo read FCampoOrigem;
  Published
    Property Complemento: string read FComplemento write SetComplemento;
    Property ApenasSeparador: boolean read FApenasSeparador write SetApenasSeparador;
    Property IsKey: Boolean read FIsKey write SetIsKey;
    Property IsFKey: Boolean read FIsFKey write SetIsFKey;
    Property Tipo: String read GetTipo write SetTipo;
    Property oIndex: integer read GetoIndex write SetoIndex;
    Property TabOrigem: Integer read GetTabOrigem write SetTabOrigem;
    Property CampoOrigem: Integer read GetCampoOrigem write SetCampoOrigem;
    Property  _Dono: Integer read Get_Dono write _FDono;
    Property  _TabOri: Integer read Get_TabOri write F_TabOri;
    Property  _CampoOri: Integer read Get_CampoOri write F_CampoOri;
    Property ddlOnUpdate: integer read FddlOnUpdate write SetddlOnUpdate;
    Property ddlOnDelete: integer read FddlOnDelete write SetddlOnDelete;
    Property Precisao: string read FPrecisao write SetPrecisao;
  end;

  TLigaTabela = Class(TBaseRelacao)
  private
    FVisivel: boolean;
    procedure SetVisivel(const Value: boolean);
  protected
    Former: integer; //auxílio para conversão
    FPt1, FPt2: integer;
    procedure Paint; override;//pintura ao mudar os pontos da conexão das linhas
    function  CanLiga(B: TBase): boolean;override;
    Procedure reSetBounds;override;
    procedure SetSelecionado(const Value: boolean);override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    Procedure SendMouseMove;override;//
    procedure PrepareToAtive(Lg: TLigacao); override;
    procedure SetCard(Card00, Card01: Integer);
    procedure GetCard(out Card00, Card01: Integer);
    Procedure Destruindo_se;
    Function HasTable(aTabela: TTabela): boolean;
    Procedure LigacaoEventoDoMouse(entrou: boolean); override;
  public
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
      AHeight: Integer); override;
    Function Relacione(T: TTabela): boolean;reintroduce;
    constructor Create(AOwner: TComponent);override;
    Property Visivel: boolean read FVisivel write SetVisivel;
  published
    Property SetaDirecao;
  end;

  TModelo = class(TWinControl)
  Private
    FIDs: integer;
    Questoes: TStringList;
    FCanvas: TControlCanvas;
    FFerramenta, OldFerramenta: integer;
    FScrollPos, LoadProgress, FMClicado: TPoint;
    FMultSelecao: TComponentList;
    FSelecaoAntiga, FSelecionado, FUsrSelB, FUsrSelA: TBase;
    FClicado: TPoint;
    FNome, FArquivo: String;
    FOnSelect, FonBaseMouseMove: TBaseEvent;
    FonErro: TBaseErro;
    FQtdBase, FQtdRelacao, FQtdEntidade: Integer;
    FDXML: TXMLDocument;
    FNovo, Colando, Copiando, YesToAll, naoAvisado, NoChangeCursor: Boolean;
    FMudou, FDisableSelecao, isMouseDown: boolean;
    FModeloMudou: TNotifyEvent;
    FBaseHint: THintBalao;
    FOnLoadProgress: TModeloOnLoadProgress;
    FP100: integer;
    FQtdTabela: Integer;
    FonQuestao: TModeloOnQuestion;
    FListaDeTrabalho: TList;
    FVersao: String;
    FSelecionador: TSelecao;
    FRegiao: HRGN;
    FAutoSalvar: Boolean;
    FJa_XSL: string;
    FAutor: String;
    FObservacao: string;
    FstaLoading: boolean;
    FFliquer: Integer;
    FTipoDeModelo: integer;
    FConversao_LastLigaTab: TLigaTabela;//utilizado princialpamente na conversão para lógico, onde preciso criar uma relação e achar o ligatab.
    FTemplate: TMngTemplate;
    procedure SetTemplate(const Value: TMngTemplate);
    procedure SetTipoDeModelo(const Value: integer);
    procedure SetFliquer(const Value: Integer);
    procedure SetstaLoading(const Value: boolean);
    procedure SetAutor(const Value: String);
    procedure SetObservacao(const Value: string);
    procedure SetSelecionado(const Value: TBase);
    Procedure OnBaseMoved(base: TObject);
    Procedure AddSelect(B: Tbase);
    Procedure ClearSelect;
    procedure SetNome(const Value: String);
    procedure SetArquivo(const Value: String);
    procedure SetFerramenta(const Value: integer);
    procedure SetUsrSelA(const Value: TBase);
    procedure SetUsrSelB(const Value: TBase);
    procedure SetClicado(const Value: TPoint);
    procedure SetOnSelect(const Value: TBaseEvent);
    procedure SetonBaseMouseMove(const Value: TBaseEvent);
    procedure SetonErro(const Value: TBaseErro);
    Procedure AtualizeCursor;
    procedure CMBaseClick(var Message: TMessage); message CM_BASECLICK;
    procedure CMCardChange(var Message: TMessage); message CM_CARDCHANGE;
    procedure CMBaseMOVE(var Message: TMessage); message CM_BASEMOVE;
    procedure CMBaseExecOnSelect(var Message: TMessage); message CM_BASEEXECSEL;//possibilita a execução do evento onSelectbase pelo método postmessage
    procedure CMTabelaOrder(var Message: TMessage); message CM_TABELAORDER;
    procedure SetSelecaoAntiga(const Value: TBase);
    procedure SetDXML(const Value: TXMLDocument);
    procedure SetMudou(const Value: boolean);
    procedure SetModeloMudou(const Value: TNotifyEvent);
    procedure SetBaseHint(const Value: THintBalao);
    procedure SetScrollPos(const Value: TPoint);
    function  GetTotalSelecionado: integer;
    procedure SetOnLoadProgress(const Value: TModeloOnLoadProgress);
    procedure SetonQuestao(const Value: TModeloOnQuestion);
    procedure SetListaDeTrabalho(const Value: TList);
    procedure SetVersao(const Value: String);
    procedure SetSelecionador(const Value: TSelecao);
    procedure SetAutoSalvar(const Value: Boolean);
    procedure SetFJa_XSL(const Value: String);
    procedure ConversaoChangeAponta(Antes, Agora: TCampo);
    procedure ReadTemplate(Reader: TReader);
    procedure WriteTemplate(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    Procedure RepinteFKs(oKeyID: Integer);
    Procedure onEspDel(Esp: TEspecializacao);
    property Selecionador: TSelecao read FSelecionador write SetSelecionador;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    Procedure Movimente(Origem: Tbase; aLeft, aTop, aWidth, aHeight: integer); virtual;//movimneta qualquer outra base que esteja anexada

    Property  onBaseMouseMove: TBaseEvent read FonBaseMouseMove write SetonBaseMouseMove;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    Procedure BaseClick(Sender: Tbase);

    Procedure Popule(ori: TBase; dest: TComponentList; var repetidos: integer);
    Function  GeraXml: TStringList;
    Procedure DefaultXML;
    Function  BaseReconfigureByXML(Base: TBase; Node: IXMLNode): Boolean;
    Function  LigacaoReconfigureByXML(Ligacao: TLigacao; Node: IXMLNode): Boolean;
    Function  LoadAtributoByXML(Pai: Tbase; Node: IXMLNode): boolean;
    Function  LoadCampoByXML(Pai: Tbase; Node: IXMLNode): boolean;
    Function  LoadEntidadeByXML(Node: IXMLNode): boolean;
    Function  LoadTabelaByXML(Node: IXMLNode): boolean;
    Function  LoadLigacaoByXML(Node: IXMLNode): boolean;
    Function  LoadRelacaoByXML(Node: IXMLNode): boolean;
    Function  LoadChildRelLigByXML(Node: IXMLNode): boolean;
    Function  LoadEntAssByXML(Node: IXMLNode): boolean;
    Function  LoadTextoByXML(Node: IXMLNode): boolean;
    Function  LoadEspecializacaoByXML(Node: IXMLNode): boolean;
    Function  RealizeLigacoesByXml(Base: TBase; Node: IXMLNode): Boolean;
    Procedure ReestrutureColado(Colado: TBase);
    Procedure DoProgress;
    Function  GeraBaseNome(pre: string): String;
    Procedure Questione(TextoA: string; topico_ajuda: integer; var ResultadoSugestao: Integer);
    Function  ExportarTextos(oModelo: TModelo): boolean;
    Function  MegaExportarAtributos(oModelo: TModelo; E: TBase; T:TTabela): boolean;
//revisado até aqui.....
    Function  ExportarEntidades(oModelo: TModelo): boolean;
    Function  ExportarEntidadesHerancaMultipla(oModelo: TModelo): boolean;

    Function  ExportarLimparLixo(oModelo: TModelo): boolean;
    Function  ExportarAutoRelacionamento(oModelo: TModelo): boolean;
    Function  ExportarRelacoes(oModelo: TModelo): boolean;
    Function  ExportarEntAss(oModelo: TModelo): boolean;
    Function  ExportarAtributos(oModelo: TModelo): boolean;
    Function  ExportarEspecializacoes(oModelo: TModelo): boolean;
  Public
    Procedure GeraLog(Texto: string; emVermelho: boolean = false; negrito: boolean = false);
    Function TransformTo(novoTipo: integer): boolean;
    Function GetStrTipoDeModelo: string;
    Function GetIntTipoDeModelo(tipoStr: string): integer;

    Procedure Load;
    Procedure DesSelecione;
    Property staLoading: boolean read FstaLoading write SetstaLoading;
    Property  Fliquer: Integer read FFliquer write SetFliquer;
    Property  Versao: String read FVersao write SetVersao;
    Procedure ResetFontFromSelecao;

    Function  LoadFromXML: boolean;

    Property  BaseHint : THintBalao read FBaseHint write SetBaseHint;
    Procedure ProcesseBaseClick(Sender: Tbase; Tool: integer);
    Procedure EveryHideShowSelection(Exceto: Tbase; hs: boolean); //exceto usado para informar que o selecionado não sofrerá a modificação.
    Property  Nome: String read FNome write SetNome;
    Property  Arquivo: String read FArquivo write SetArquivo;
    Function  FindByName(Nome: String; Step: Integer = 0): TBase;
    Function  FindByID(Oid: Integer): TBase;
    Property  Canvas: TControlCanvas Read FCanvas Write FCanvas;
    Property  Selecionado: TBase read FSelecionado write SetSelecionado;
    Function  getNextId: Integer;

    Function  Add: TBase;
    //Function  NovoAtributo(lNome: string; Dono: TBase): TBase;
    constructor Create(AOwner: TComponent);override;

    Destructor  Destroy;override;
    Property  Ferramenta: integer read FFerramenta write SetFerramenta;
    Procedure EndOperation;
    Procedure RefreshSelecao;
    Property  UsrSelA: TBase read FUsrSelA write SetUsrSelA;
    Property  UsrSelB: TBase read FUsrSelB write SetUsrSelB;
    Property  Clicado: TPoint read FClicado write SetClicado;
    Property  onErro: TBaseErro read FonErro write SetonErro;
    Procedure Erro(Base: TBase; Msg: string; ErroTipo: Integer);
    Procedure AtualizaQtdItens;
    Property  QtdEntidade: Integer read FQtdEntidade;
    Property  QtdRelacao: Integer read FQtdRelacao;
    Property  QtdBase: Integer read FQtdBase;
    Property  QtdTabela: Integer read FQtdTabela;
    Function  PromoverAEntAss(R: TRelacao): boolean;
    Function  PromoverAEntidade(A: TAtributo): boolean;
    Property  SelecaoAntiga: TBase read FSelecaoAntiga write SetSelecaoAntiga;
    Function  MostraAtributoOculto(At: TAtributoOculto; b: TBase): boolean;
    Function  OcultarAtributo(A: TAtributo): boolean;
    Procedure ProcessKey(var Key: Word; Shift: TShiftState);
    Function  CalculeArea: TPoint;
    Function  Salvar(arq: string): boolean;overload;
    Function  Salvar: boolean;overload;
    Property  Novo: Boolean read FNovo;
    Function  Copiar: boolean;
    Function  Colar: Boolean;
    Property  Mudou: boolean read FMudou write SetMudou;
    Property  ModeloMudou: TNotifyEvent read FModeloMudou write SetModeloMudou;
    Property  DXML: TXMLDocument read FDXML write SetDXML;
    Property  ScrollPos: TPoint read FScrollPos write SetScrollPos;
    Property  TotalSelecionado: integer read GetTotalSelecionado;
    Function  PodeColar: Boolean;
    Property  OnLoadProgress: TModeloOnLoadProgress read FOnLoadProgress write SetOnLoadProgress;
    Property  PerCentLoaded: integer read FP100;
    Function  DeleteSelection: Boolean;
    Procedure GetItens(lLista: TGeralList; noCard: boolean = true);
    Property  AutoSalvar: Boolean read FAutoSalvar write SetAutoSalvar;
    Function  ExportarParaLogico(oModelo: TModelo): Boolean;
    Property  Xsl: String read FJa_XSL write SetFJa_XSL;

    Property  onQuestao: TModeloOnQuestion read FonQuestao write SetonQuestao;
    Property  ListaDeTrabalho: TList read FListaDeTrabalho write SetListaDeTrabalho;
    Procedure TabelasLigadas(lLista: TGeralList; T : TTabela);

    Property  OnSelect: TBaseEvent read FOnSelect write SetOnSelect;
    Procedure SelecioneSelecionadosAtributos;
    Function ModeloCarregando: boolean;
    property Template: TMngTemplate read FTemplate write SetTemplate;
    //Campos
    Procedure GeraLista(Lst: TStringList; tp: Integer);
 published
    property  TipoDeModelo: integer read FTipoDeModelo write SetTipoDeModelo;
    Property  Font;
    Property  Autor: String read FAutor write SetAutor;
    property  Observacao: string read FObservacao write SetObservacao;
  end;

  TVisual = Class(TPanel)
  private
    FModelo: TModelo;
    FModelos: TComponentList;
    FOnSelected: TBaseEvent;
    FonBaseMouseMove: TBaseEvent;
    FOnErro: TBaseErro;
    FDXML: TXMLDocument;
    FModeloMudou: TNotifyEvent;
    FOnLoadProgress: TModeloOnLoadProgress;
    FOnModeloQuestion: TModeloOnQuestion;
    FMemoria: TMemoria;
    FImgLisa: TImageList;
    procedure SetImgLisa(const Value: TImageList);
    procedure SetMemoria(const Value: TMemoria);
    procedure SetModelo(const Value: TModelo);
    procedure SetModelos(const Value: TComponentList);
    procedure SetOnSelected(const Value: TBaseEvent);
    procedure SetonBaseMouseMove(const Value: TBaseEvent);
    procedure SetOnErro(const Value: TBaseErro);
    procedure SetDXML(const Value: TXMLDocument);
    procedure SetModeloMudou(const Value: TNotifyEvent);
    procedure SetOnLoadProgress(const Value: TModeloOnLoadProgress);
    procedure SetOnModeloQuestion(const Value: TModeloOnQuestion);
  protected
    procedure Paint;override;
    Procedure CarregueCursor;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    Function  GeraNome(tipoModelo: Integer = 0): String;
    Procedure SetFocusByModelo;
    Function  LoadModeloByXML(arq, onErroNome: string; oModelo: TModelo): boolean;
    Function  LoadModeloByBin(arq, onErroNome: string; oModelo: TModelo): boolean;
    Procedure AskToDraw(oCanvas: TCanvas; X, Y, aImg: Integer; Habilitado: boolean);
  Public
    Writer:   TWriterMsg;
    property  OnKeyPress;
    Function  ModeloFindByArq(Arq: string): boolean;
    Function  gera(Arq: string; novo: boolean = true):TModelo;
    Function  LoadFromFile(arq, onErroNome: string; oModelo: TModelo): boolean;
    Function  SelecioneModelo(index: integer): TModelo;
    Function  Fecha: Boolean;
    Property  Modelos: TComponentList read FModelos write SetModelos;
    Property  Modelo: TModelo read FModelo write SetModelo;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    constructor Create(AOwner: TComponent);override;
    Destructor Destroy;override;
    Procedure GetModelos(lLista: TGeralList);overload;
    Procedure GetModelos(Lst: TStrings);overload;
    Function  QtdModeloNaoSalvo: Integer;
    Property  OnSelected: TBaseEvent read FOnSelected write SetOnSelected;
    Property  onBaseMouseMove: TBaseEvent read FonBaseMouseMove write SetonBaseMouseMove;
    Property  OnErro: TBaseErro read FOnErro write SetOnErro;
    Property  DXML: TXMLDocument read FDXML write SetDXML;
    Property  ModeloMudou: TNotifyEvent read FModeloMudou write SetModeloMudou;
    Property  OnLoadProgress: TModeloOnLoadProgress read FOnLoadProgress write SetOnLoadProgress;
    Function  JaEstaAberto(Arq: String): boolean;
    Function  ExportarParaLogico(oModelo: TModelo): TModelo;
    Property  OnModeloQuestion: TModeloOnQuestion read FOnModeloQuestion write SetOnModeloQuestion;
    Property  Memoria: TMemoria read FMemoria write SetMemoria;
    Property ImgLisa: TImageList read FImgLisa write SetImgLisa;
  end;

  function OrdenadorLeft(Item1, Item2: Pointer): Integer;
  function OrdenadorTop(Item1, Item2: Pointer): Integer;
  function OrdenadorLeftNegativo(Item1, Item2: Pointer): Integer;
  function OrdenadorTopNegativo(Item1, Item2: Pointer): Integer;
  function SerializeBaseList(BaseList: TList): string;
  function unSerializeBaseList(oModelo: TModelo; BaseStr: string; BaseList: TList): boolean;

implementation

uses Types, Math, StrUtils;

{$R cursor.RES}

{Minhas funçoes}

function OrdenadorLeft(Item1, Item2: Pointer): Integer;
  var L1, L2: TLigacao;
      B1, B2, Base: TBase;
begin
  Result := 0;
  L1 := TLigacao(Item1);
  L2 := TLigacao(Item2);
  if L1.E1.This then
  begin
    B1 := L1.E2;
    Base := L1.E1;
  end else
  begin
    B1 := L1.E1;
    Base := L1.E2;
  end;
  if L2.E1.This then B2 := L2.E2 else B2 := L2.E1;

  if (B1.Top >= Base.Top) and (B2.Top >= Base.Top) then
  begin
//    if B1.Left > B2.Left then Result := 1
//    else
//    if B1.Left = B2.Left then
//    begin
      if B1.Top < B2.Top then Result := -1;
      if B1.Top > B2.Top then Result := 1;
      if B1.Top = B2.Top then Result := 0;
//    end
//    else Result := -1;
  end
  else
  if (B1.Top < Base.Top) and (B2.Top < Base.Top) then
  begin
    if B1.Left > B2.Left then Result := -1
    else
    if B1.Left = B2.Left then
    begin
      if B1.Top < B2.Top then Result := 1;
      if B1.Top > B2.Top then Result := -1;
      if B1.Top = B2.Top then Result := 0;
    end
    else Result := 1;
  end
  else
  begin
    if B1.Top < Base.Top then Result := -1 else result := 1;
  end;
end;

function OrdenadorTop(Item1, Item2: Pointer): Integer;
  var L1, L2: TLigacao;
      B1, B2, Base: TBase;
begin
  Result := 0;
  L1 := TLigacao(Item1);
  L2 := TLigacao(Item2);
  if L1.E1.This then
  begin
    B1 := L1.E2;
    Base := L1.E1;
  end else
  begin
    B1 := L1.E1;
    Base := L1.E2;
  end;
  if L2.E1.This then B2 := L2.E2 else B2 := L2.E1;

  if (B1.Left >= Base.Left) and (B2.Left >= Base.Left) then
  begin
//    if B1.Top > B2.Top then Result := -1
//    else
//    if B1.Top = B2.Top then
//    begin
      if B1.Left < B2.Left then Result := -1;
      if B1.Left > B2.Left then Result := 1;
      if B1.Left = B2.Left then Result := 0;
//    end
//    else Result := 1;
  end
  else
  if (B1.Left < Base.Left) and (B2.Left < Base.Left) then
  begin
    if B1.Top > B2.Top then Result := 1
    else
    if B1.Top = B2.Top then
    begin
      if B1.Left < B2.Left then Result := 1;
      if B1.Left > B2.Left then Result := -1;
      if B1.Left = B2.Left then Result := 0;
    end
    else Result := -1;
  end
  else
  begin
    if B1.Left < Base.Left then Result := -1 else result := 1;
  end;
end;

function OrdenadorLeftNegativo(Item1, Item2: Pointer): Integer;
  var L1, L2: TLigacao;
      B1, B2, Base: TBase;
begin
  Result := 0;
  L1 := TLigacao(Item1);
  L2 := TLigacao(Item2);
  if L1.E1.This then
  begin
    B1 := L1.E2;
    Base := L1.E1;
  end else
  begin
    B1 := L1.E1;
    Base := L1.E2;
  end;
  if L2.E1.This then B2 := L2.E2 else B2 := L2.E1;

  if (B1.Top >= Base.Top) and (B2.Top >= Base.Top) then
  begin
//    if B1.Left > B2.Left then Result := -1
//    else
//    if B1.Left = B2.Left then
//    begin
      if B1.Top < B2.Top then Result := -1;
      if B1.Top > B2.Top then Result := 1;
      if B1.Top = B2.Top then Result := 0;
//    end
//    else Result := 1;
  end
  else
  if (B1.Top < Base.Top) and (B2.Top < Base.Top) then
  begin
    if B1.Left > B2.Left then Result := 1
    else
    if B1.Left = B2.Left then
    begin
      if B1.Top < B2.Top then Result := -1;
      if B1.Top > B2.Top then Result := 1;
      if B1.Top = B2.Top then Result := 0;
    end
    else Result := -1;
  end
  else
  begin
    if B1.Top < Base.Top then Result := -1 else result := 1;
  end;
end;

function OrdenadorTopNegativo(Item1, Item2: Pointer): Integer;
  var L1, L2: TLigacao;
      B1, B2, Base: TBase;
begin
  Result := 0;
  L1 := TLigacao(Item1);
  L2 := TLigacao(Item2);
  if L1.E1.This then
  begin
    B1 := L1.E2;
    Base := L1.E1;
  end else
  begin
    B1 := L1.E1;
    Base := L1.E2;
  end;
  if L2.E1.This then B2 := L2.E2 else B2 := L2.E1;

  if (B1.Left >= Base.Left) and (B2.Left >= Base.Left) then
  begin
//    if B1.Top > B2.Top then Result := 1
//    else
//    if B1.Top = B2.Top then
//    begin
      if B1.Left < B2.Left then Result := -1;
      if B1.Left > B2.Left then Result := 1;
      if B1.Left = B2.Left then Result := 0;
//    end
//    else Result := -1;
  end
  else
  if (B1.Left < Base.Left) and (B2.Left < Base.Left) then
  begin
    if B1.Top > B2.Top then Result := -1
    else
    if B1.Top = B2.Top then
    begin
      if B1.Left < B2.Left then Result := -1;
      if B1.Left > B2.Left then Result := 1;
      if B1.Left = B2.Left then Result := 0;
    end
    else Result := 1;
  end
  else
  begin
    if B1.Left < Base.Left then Result := -1 else result := 1;
  end;
end;

function SerializeBaseList(BaseList: TList): string;
  var i: integer;
begin
  Result := '';
  for I := 0 to BaseList.Count - 1 do Result := Result + IntToStr(TBase(BaseList[i]).OID) + '|';
end;

function unSerializeBaseList(oModelo: TModelo; BaseStr: string; BaseList: TList): boolean;
  var i : integer;
      V: string;
      p: integer;
begin
  V := BaseStr;
  p := Pos('|', V);
  while P <> 0 do
  begin
    i := StrToInt(Copy(V, 1, p -1));
    Delete(v, 1, p);
    BaseList.Add(oModelo.FindByID(i));
    p := Pos('|', V);
  end;
  Result := true;
end;

{ THintBalao }

constructor THintBalao.Create(Aowner: TComponent);
begin
  inherited;
  FPosiSeta := POSI_ABAIXO;
  Visible := false;
  Color := clYellow;
end;

procedure THintBalao.Organize;
  var i, w, h, l, t: integer;
      tmp, txt: string;
      const tam = 20;
begin
  with Referencia do
    if (Left + Top + Right + Bottom) = 0 then exit;

  if FForca then
  begin
    FForca := false;
    if PosiSeta = POSI_ACIMA then PosiSeta := POSI_ABAIXO else PosiSeta := POSI_ACIMA;
    exit;
  end;
  i := conta13(Texto);
  H := i * Canvas.TextHeight('H') + tam + 10;

  txt := Texto;
  w := 20;
  while (length(txt) > 0) do
  begin
    I := pos(#13, txt) + 1;
    if i > 1 then
    begin
      tmp := copy(txt, 1, I);
      txt := copy(txt, I, length(txt));
    end else
    begin
      tmp := txt;
      txt := '';
    end;
    if Canvas.TextWidth(tmp) > w then w := Canvas.TextWidth(tmp);
  end;
  w := w + 10;
  l := (Referencia.Right) - (w div 2) + 10;
  if PosiSeta = POSI_ABAIXO then
    t := Referencia.Top - h + 10 else
       t := Referencia.Bottom -10;
  if (t < 0) or ((T + H) > Modelo.Height) then
  begin
    if PosiSeta = POSI_ACIMA then PosiSeta := POSI_ABAIXO else PosiSeta := POSI_ACIMA;
    FForca := true;
    exit;
  end;
  SetBounds(L, T, W, H);
end;

procedure THintBalao.Paint;
  var rec: TRect;
      P: array [1..3] of TPoint;
  const tam = 20;
begin
  inherited;
  with Canvas do
  begin
    rec := GetClientRect;

    if PosiSeta = POSI_ABAIXO then
    begin
      rec.Bottom := rec.Bottom - tam;
      P[1] := Point((Width div 2), rec.Bottom -1);
      P[2] := Point(P[1].X + 20, rec.Bottom -1);
      P[3] := Point(P[1].X - 10, Height);
    end else
    begin
      rec.Top := rec.Top + tam;
      P[1] := Point((Width div 2), rec.Top);
      P[2] := Point(P[1].X + 20, rec.Top);
      P[3] := Point(P[1].X - 10, 0);
    end;
    Brush.Color := Color;
    Pen.Color := clBlack;
    Brush.Style := bsSolid;
    RoundRect(rec.Left, rec.Top, rec.Right, rec.Bottom, 5, 5);
    Rec.Top := rec.Top + 5;
    Rec.Left := rec.Left + 5;
    if P[3].X < 0 then P[3].X := 1;
    Polygon(P);
    Pen.Color := clYellow;
    MoveTo(P[1].X, P[1].Y);
    LineTo(P[2].X, P[2].Y);
    DrawText(Handle, PChar(Texto), -1, Rec, DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS);
  end;
end;

procedure THintBalao.SetPosiSeta(const Value: integer);
begin
  FPosiSeta := Value;
  Organize;
end;

procedure THintBalao.SetReferencia(const Value: TRect);
begin
  FReferencia := Value;
  Organize;
end;

procedure THintBalao.SetTexto(const Value: String);
begin
  FTexto := Value;
  Organize;
end;

procedure THintBalao.Show(aPosicao: TRect; oTexto: String);
begin
  if not Visible then Visible := true;
  Repaint;
  FReferencia := aPosicao;
  Texto := oTexto;
end;


{ base }

procedure TBase.AdjustSize;
begin
//
  if Assigned(Modelo) and Modelo.FDisableSelecao then exit;
//
  if (not Self.Destruindo) then inherited;
end;

function TBase.Anexar(B: Tbase): integer;
begin
  Muda;
  if FAnexos.IndexOf(B) < 0 then Result := FAnexos.Add(B) else Result := -1;
end;

function TBase.AtributosOcultosToTexto: String;
  var i: integer;
begin
  Result := '';
  for i:= 0 to AOcultos.AtributosOcultos.Count -1 do
  begin
    Result := Result + #13 +
              IfThen(AOcultos.AtributosOculto[i].Composto, '* ', '+ ') +
              AOcultos.AtributosOculto[i].Nome;
    if AOcultos.AtributosOculto[i].Multivalorado then
      Result := Result + ' ' + AOcultos.AtributosOculto[i].CardStr;
    Result := Result + ':' + AOcultos.AtributosOculto[i].Tipo;
  end;
  if Result <> '' then Result := 'Atributos Ocultos' + Result;
end;

procedure TBase.AtivePorPonto(P: integer);
  var i: integer;
      L: TLigacao;
begin
  if not Assigned(FLigacoes) then exit;
  for i := 0 to FLigacoes.Count -1 do
  begin
    L := TLigacao(FLigacoes[i]);
//    if ((L.BaseInicial = Self) and (L.PontoInicial = P)) or
//       ((L.BaseFinal = Self) and (L.PontoFinal = P)) then
    if L.MePonto(Self) = P then
    begin
      L.Ative;
    end;
  end;
end;

procedure TBase.AtualizaEncaixes;
begin
  Encaixe[1] := point(Left, Top + (Height div 2));
  Encaixe[2] := point(Left + (Width div 2), Top);
  Encaixe[3] := point(Left + Width, Top + (Height div 2));
  Encaixe[4] := point(Left + (Width div 2), Top + Height);
end;

function TBase.CanLiga(B: TBase): boolean;
  var i: Integer;
begin
  Result := true;
  for i := 0 to FLigacoes.Count -1 do
    if (FLigacoes[i] is TLigacao) and (Assigned(FLigacoes[i])) then
      if TLigacao(FLigacoes[i]).BasePertence(B) then Result := false;
end;

procedure TBase.Click;
begin
  inherited;
  SendClick;
end;

constructor TBase.Create(AOwner: TComponent);
  var i: integer;
begin
  inherited;
  FAtualizando := true;
  if AOwner is TModelo then
  begin
    Modelo := TModelo(AOwner);
    Parent := TModelo(AOwner);
    OID := TModelo(AOwner).getNextId;
    OnMoved := TModelo(AOwner).OnBaseMoved;
    Modelo.Mudou := True;
  end;
  for i := 1 to 4 do
  begin
    Pontos[i] := TPonto.Create(self);
  end;
  Width := 102;
  Me := self;
  Ligacoes := TComponentList.Create(false);
  FAnexos := TComponentList.Create(false);
  Atributos := TComponentList.Create(False);
  FAtualizando := false;
  Height := 66;
  Cursor := crHandPoint;

  // Inicio TCC II
  // retirado o negrito de todas as fontes dos objetos dos modelos conceitual e
  // logico para melhorar a aparencia
  FontStyles := [];
  // Fim TCC II

  FontColor := clBlack;
  AOcultos := TConjPAtt.Create(self);
end;

function TBase.DesAnexar(B: Tbase): integer;
begin
  Muda;
  Result := FAnexos.Remove(B);
end;

destructor TBase.destroy;
begin
  Destruindo := true;
  if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
  begin
    Modelo.Mudou := True;
    LiberarLinhas;
    FAtributos.OwnsObjects := true;
  end;
  FLigacoes.Free;
  FAtributos.Free;
  FAnexos.Free;
  FAOcultos.Free;
  inherited;
end;

procedure TBase.Divida(Ponto, Qtd: integer);
  var tam, i, cont, Ori: integer;
      L : TLigacao;
      tmp: TPoint;
begin
//Torca a ordem.... baseando-me na orientação: V =  (< Y), H = (< X)
  Self.This := true; //informa à procedure de ordenação quem está mandando ordenar.
  case ponto of
  1, 3:
    begin
      tam := Height div (qtd + 1);
      Ori := OrientacaoV;
      if ponto = 1 then
      begin
        FLigacoes.Sort(OrdenadorLeft); //caso já esteja ordenado um bug no ordenador do delphi faz com que a ordem seja invertido
        if (Self is TBaseEntidade) and TBaseEntidade(Self).AutoRelacionado then
          FLigacoes.Sort(OrdenadorLeft); //desenverter se preciso for.
      end else
      begin
        FLigacoes.Sort(OrdenadorLeftNegativo);
        if (Self is TBaseEntidade) and TBaseEntidade(Self).AutoRelacionado then
          FLigacoes.Sort(OrdenadorLeftNegativo);
      end;
    end;
    else begin
      tam := Width div (qtd + 1);
      Ori := OrientacaoH;
      if ponto = 4 then
      begin
        FLigacoes.Sort(OrdenadorTop);
        if (Self is TBaseEntidade) and TBaseEntidade(Self).AutoRelacionado then
          FLigacoes.Sort(OrdenadorTop);
      end else
      begin
        FLigacoes.Sort(OrdenadorTopNegativo);
        if (Self is TBaseEntidade) and TBaseEntidade(Self).AutoRelacionado then
          FLigacoes.Sort(OrdenadorTopNegativo);
      end;
    end;
  end;
  LastTamanhoOrigem := Point(tam, Ponto);
  cont := 1;
  Self.This := false; //volta ao estado normal

  for i := 0 to FLigacoes.Count -1 do
  begin
    if (FLigacoes[i] is TLigacao) and (Assigned(FLigacoes[i])) then
    begin
      L := (TLigacao(FLigacoes[i]));
//      if ((L.BaseInicial = Self) and (L.PontoInicial = Ponto)) or
//         ((L.BaseFinal = Self) and (L.PontoFinal = Ponto)) then
      if L.MePonto(Self) = Ponto then
      begin
        tmp := Encaixe[Ponto];
        if (Ori = OrientacaoV) then
          Encaixe[Ponto] := Point(Encaixe[Ponto].X, Top + (tam * cont))
        else
          Encaixe[Ponto] := Point(Left + (tam * cont), Encaixe[Ponto].Y);
        l.Ative;
        Encaixe[Ponto] := tmp;
        Inc(cont);
      end;
    end;
  end;
  LastTamanhoOrigem := Point(0, 0);
end;

function TBase.GetColor: TColor;
begin
  Result := Canvas.Font.Color;
end;

function TBase.GetFontStyles: TFontStyles;
begin
  Result := Canvas.Font.Style;
end;

procedure TBase.LiberarLinhas;
  var b1, b2: Tbase;
      del1, del2: boolean;
      L: TLigacao;
      i: integer;
begin
  for i := 0 to FAtributos.Count -1 do
    TBase(FAtributos[i]).Destruindo := true;

  while FLigacoes.Count > 0 do
  begin
    L := TLigacao(FLigacoes.Items[FLigacoes.Count -1]);
    b1 := L.E1;
    b2 := L.E2;
    del1 := b1.FLigacoes.OwnsObjects;
    del2 := b2.FLigacoes.OwnsObjects;
    b1.FLigacoes.OwnsObjects := False;
    b2.FLigacoes.OwnsObjects := False;
    b1.FLigacoes.Remove(L);
    b2.FLigacoes.Remove(L);
    FreeAndNil(L);
    b1.FLigacoes.OwnsObjects := del1;
    b2.FLigacoes.OwnsObjects := del2;
    if (b1 <> Self) then
    begin
      if not b1.Destruindo then
      b1.AdjustSize;
    end else
    begin
      if not b2.Destruindo then
      b2.AdjustSize;
    end;
  end;
end;

procedure TBase.Liga(L: TLigacao);
begin
  FLigacoes.Add(L);
//  Muda; //não há como ligar uma base sem que tenha se criado uma ligacão e se criou uma ligação o muda já foi chamado.
end;

procedure TBase.LigacaoEventoDoMouse(entrou: boolean);
begin

end;

procedure TBase.Ligacoesto_xml(var node: IXMLNode);
  var i: integer;
begin
  For i:= 0 to FLigacoes.Count -1 do
  begin
    if (TLigacao(FLigacoes[i]).Ponta = Self) then Continue;
    TLigacao(FLigacoes[i]).to_xml(node);
  end;
end;

procedure TBase.Load;
begin
  AOcultos.Load;
end;

procedure TBase.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if Nula then exit;
  if (ssCtrl in Shift) or (ssShift in Shift) then
  begin
    Modelo.AddSelect(Self);
  end
  else begin
    isMouseDown := True;
    down := Point(X, Y);
    if (Modelo.FMultSelecao.IndexOf(self) = -1) and (Modelo.Selecionado <> Self) then
    begin
      Modelo.Selecionado := Self;
      Modelo.ClearSelect;
    end;
    SetSelecionado(false);
    Modelo.EveryHideShowSelection(nil, false);
  end;
end;

procedure TBase.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Nula then exit;
  if isMouseDown then begin
    if ((X - Down.X) <> 0) or ((Y - Down.Y) <> 0) then
      SetBounds(Left + X - down.X, Top + Y - down.Y, Width, Height);
  end
  else SendMouseMove;
end;

procedure TBase.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if Nula then exit;
  if isMouseDown then
  begin
    isMouseDown := False;
    Reenquadre;
    BringToFront;
    Modelo.EveryHideShowSelection(nil, true);
    SetSelecionado(True);
    Modelo.EndOperation;
    if Reenquadrou then
    begin
      AdjustSize;
      Reenquadrou := false;
    end;
  end;
end;

procedure TBase.Movimente(aLeft, aTop, aWidth, aHeighT: integer);
  var i: integer;
      B: Tbase;
      bkp: boolean;
//      rec: TRect;
  Function NaoZero(a: integer; c: integer = 0): Integer;
  begin
    if a < C then Result := c else Result := a;
  end;
begin
  If not Assigned(FAnexos) then Exit;//Já foi devidamente "criado"?
  For i := 0 to FAnexos.Count -1 do
  begin
    //anexos: não será implementado nesta fase. Se mostra inútil e não será excluído do código apenas para um possível proveito futuro
    B := TBase(FAnexos[i]);
    if Assigned(B) and (Modelo.FMultSelecao.IndexOf(B) = -1) and (not (b.Selecionado and (Modelo.FMultSelecao.Count > 0))) then
    begin
      B.Selecionado := false;
      bkp := B.Atualizando;
      B.Atualizando := true;
      B.SetBounds(NaoZero(B.Left - aLeft), NaoZero(B.Top - aTop), B.Width, B.Height);
      B.Realinhe;
      Modelo.OnBaseMoved(B);
      B.Atualizando := bkp;
    end;
  end;
  FMovido := Rect(aLeft, aTop, aWidth, aHeight);

  if (not Nula) and (not Destruindo) then
    PostMessage(Modelo.Handle, CM_BASEMOVE, integer(Self), 0);
end;

procedure TBase.Muda;
begin
  if Assigned(Modelo) then Modelo.Mudou := true; //tem o teste porque logo que cria-se o componente ele altera o valor
end;

Function TBase.NovoAtributo(oNome: String): Tbase;
  var att: TAtributo;
begin
  Muda;
  att := TAtributo.Create(Modelo, self);
  att.Atualizando := true;
  att.Nome := oNome;
  att.TamAuto := true;
  att.Atualizando := false;
  att.SetBounds(Left + Width + 50, (Height div 2) + Top -(att.Altura div 2), att.Width, att.Height);
  Result := att;
end;

procedure TBase.OrganizeAtributos;
  var i, P, Distancia: integer;
      Totais: Array [1..4] of integer;
      A: TAtributo;
      L: TLigacao;
      PT: TPoint;
begin
  //achar o maior width
  Distancia := 16;
  A := nil;
  P := 0;
  for i:= 1 to 4 do Totais[i] := 0;
  for i := 0 to FAtributos.Count -1 do
  begin
    A := TAtributo(FAtributos[i]);
    L := TLigacao(A.FLigacoes[0]);
    P := L.MePonto(Self);
    Inc(Totais[p]);
    Distancia := max(A.Height, Distancia);
  end;
  //organizar atributos
  for i := 0 to FLigacoes.Count -1 do
  begin
    L := TLigacao(FLigacoes[i]);
    A := nil;
    if L.BaseInicial is TAtributo then
    begin
      A := TAtributo(L.BaseInicial);
      P := L.PontoFinal;
      PT := L.PontoFinal2;
    end else
    if L.BaseFinal is TAtributo then
    begin
      A := TAtributo(L.BaseFinal);
      P := L.PontoInicial;
      PT := L.PontoInicial1;
    end;
    if A = nil then Continue;
    if P = 1 then A.Orientacao := OrientacaoD else A.Orientacao := OrientacaoE;
    case P of
      3: begin
        A.SetBounds(Left + Width + 35, PT.Y - (A.Height div 2), A.Width, A.Height);
      end;
      1: begin
        A.SetBounds(Left - A.Width - 35, PT.Y - (A.Height div 2), A.Width, A.Height);
      end;
      2: begin
        A.SetBounds(PT.X, Top -(10 + Distancia * totais[p]), A.Width, A.Height);
      end;
      4: begin
        A.SetBounds(PT.X, Top + Height + (10 + Distancia * totais[p]), A.Width, A.Height);
      end;
    end;
    Totais[p] := Totais[p] -1;
    A.Reenquadre;
  end;
  //reativar recursividade em caso de att composto
  for i := 0 to FAtributos.Count -1 do
  begin
    A := TAtributo(FAtributos[i]);
    A.OrganizeAtributos;
  end;
  //refaz o ative geral
  if FAtributos.Count > 0 then A.Left := A.Left;
end;

procedure TBase.Paint;
  var i: integer;
      Rect: TRect;
      oNome: String;
begin
  if (Atualizando) then exit;
  inherited;
  with Canvas do
  begin
    Rect := GetClientRect;
    oNome := ControlaCaption(Canvas, self.Width -2, Nome);
    I := conta13(oNome) * TextHeight('W');
    with Rect do
    begin
      Top := ((Bottom + Top) - I) div 2;
      Bottom := Top + I;
      Right := Right - 2;
    end;
    Brush.Style := bsClear;
    DrawText(Handle, PChar(oNome), -1, Rect, DT_CENTER or DT_EXPANDTABS);
  end;
end;

procedure TBase.PinteImagem(Img, X, Y: Integer; Habilitada: boolean);
begin
  if Assigned(Modelo) then
    TVisual(Modelo.Owner).AskToDraw(Canvas, X, Y, Img, Habilitada);
end;

procedure TBase.PrepareToAtive(L: TLigacao);
begin

end;

function TBase.QuantosNestePonto(P: integer): integer;
  var i: Integer;
  L: TLigacao;
begin
  Result := 0;
  for i := 0 to FLigacoes.Count -1 do
  begin
    if (FLigacoes[i] is TLigacao) and (Assigned(FLigacoes[i])) then
    begin
      L := TLigacao(FLigacoes[i]);
//      if ((L.BaseInicial = Self) and (L.PontoInicial = P)) or
//         ((L.BaseFinal = Self) and (L.PontoFinal = P))
      if L.MePonto(Self) = P
      then Inc(Result);
    end;
  end;
end;

procedure TBase.Realinhe;
  var i: Integer;
  L : TLigacao;
begin
  for i := 0 to FLigacoes.Count -1 do
  begin
    if (FLigacoes[i] is TLigacao) then
    begin
      L := TLigacao(FLigacoes[i]);
      if Assigned(L) then
      begin
        L.SuspendLineMove := true;
        L.Ative;
        L.SuspendLineMove := False;
      end;
    end;
  end;
end;

procedure TBase.Reenquadre;
  var ALeft, ATop: Integer;
      bkp: boolean;
begin
  if not Assigned(Modelo) then exit;
  if Left < 0 then ALeft := 0 else ALeft := Left;
  if Top < 0 then ATop := 0 else ATop := Top;
  if (Left + Width) > Modelo.Width then ALeft := Modelo.Width -Width;
  if (Top + Height) > Modelo.Height then ATop := Modelo.Height -Height;
  if (ALeft <> Left) or (ATop <> Top) then
  begin
    bkp :=Atualizando;
    Atualizando := true;
    SetBounds(ALeft, ATop, Width, Height);
    Atualizando := bkp;
    reposicione;
    Reenquadrou := true;
  end;
end;

procedure TBase.reposicione;
  var i: integer;
begin
  if not Assigned(Pontos[1]) or nula then Exit;
  for i := 1 to 4 do Pontos[i].Posicao := i;
end;

procedure TBase.reSetBounds;
  var H, W: integer;
begin
  W := pontos[3].Left + pontos[1].Width + 3 -pontos[1].Left;
  H := pontos[3].Top + pontos[1].Height + 3 -pontos[1].Top;
  if (w < 10) or (H < 10) then
    reposicione
  else
    SetBounds(pontos[1].Left, pontos[1].Top, W, H);
  Reenquadre;
end;

procedure TBase.SendClick;
begin
  PostMessage(Modelo.Handle, CM_BASECLICK, integer(Self), 0);
end;

procedure TBase.SendMouseMove;
begin
  if Assigned(Modelo.onBaseMouseMove) then Modelo.onBaseMouseMove(Self);
end;

procedure TBase.SetAOcultos(const Value: TConjPAtt);
begin
  FAOcultos := Value;
end;

procedure TBase.SetAtualizando(const Value: Boolean);
begin
  FAtualizando := Value;
end;

procedure TBase.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
  var i, L, T, W, H: integer;
begin
  Muda;
  if Nula then
  begin
    inherited;
    AtualizaEncaixes;
    exit;
  end;
  L := 0;
  T := 0;
  W := 0;
  H := 0;
  if not Atualizando then
  begin
    L := Left - ALeft;
    T := Top - ATop;
    W := Width - AWidth;
    H := Height - AHeight;
    if Assigned(FLigacoes) then
      for i := 0 to FLigacoes.Count -1 do
        if (FLigacoes[i] is TLigacao) and (Assigned(FLigacoes[i])) then
          TLigacao(FLigacoes[i]).Atualizando := True;
  end;
  inherited;
  AtualizaEncaixes;
  if Atualizando then Exit;

  Movimente(L, T, W, H);

  if Assigned(FLigacoes) then Realinhe;

  if Assigned(FonMoved) then FOnMoved(self);
  if Assigned(FLigacoes) then
    for i := 0 to FLigacoes.Count -1 do
      if (FLigacoes[i] is TLigacao) and (Assigned(FLigacoes[i])) then
        TLigacao(FLigacoes[i]).Atualizando := false;
end;

procedure TBase.SetDicionario(const Value: String);
begin
  FDicionario := Value;
  Muda;
end;

procedure TBase.SetFontColor(const Value: TColor);
begin
  Font.Color := Value;
  Canvas.Font.Color := Value;
  Muda;
  Invalidate;
end;

procedure TBase.SetFontStyles(const Value: TFontStyles);
begin
  Font.Style := Value;
  Canvas.Font.Style := Value;
  Muda;
  Invalidate;
end;

procedure TBase.SetFuturo(const Value: string);
begin
  if (FFuturo <> Value) then
  begin
    FFuturo := Value;
    Muda;
  end;
end;

procedure TBase.SetLigacoes(const Value: TComponentList);
begin
  FLigacoes := Value;
end;

procedure TBase.SetNome(const Value: string);
begin
  FNome := Value;
  Muda;
  Invalidate;
end;

procedure TBase.SetNula(const Value: Boolean);
begin
  FNula := Value;
end;

procedure TBase.SetObservacoes(const Value: String);
begin
  FObservacoes := Value;
  Muda;
end;

procedure TBase.SetOnMoved(const Value: TNotifyEvent);
begin
  FOnMoved := Value;
end;

procedure TBase.SetSelecionado(const Value: boolean);
  var i: integer;
      bkp: boolean;
begin
  if FSelecionado = Value then exit;
  FSelecionado := Value;
  for i := 1 to 4 do
  begin
    bkp := Atualizando;
    Atualizando := true;
    Pontos[i].Visible := (FSelecionado and Visible);
    Pontos[i].Posicao := i;
    Pontos[i].BringToFront;
    Atualizando := bkp;
  end;
end;

procedure TBase.Set_AOcultos(const Value: string);
begin
  AOcultos._AOcultos := Value;
end;

procedure TBase.to_xml(var node: IXMLNode);
 var lnode, mNode: IXMLNode;
     i: integer;
begin
  node := node.AddChild(copy(ClassName, 2, length(ClassName) -1));
  node.Attributes['nome'] := Nome;
  node.Attributes['id'] := OID;

  //posicao e tamanho
  lnode := node.AddChild('Left');
  lnode.Attributes['Valor'] := Left;
  lnode := node.AddChild('Top');
  lnode.Attributes['Valor'] := Top;
  lnode := node.AddChild('Width');
  lnode.Attributes['Valor'] := Width;
  lnode := node.AddChild('Height');
  lnode.Attributes['Valor'] := Height;

  //fonte
  lnode := node.AddChild('Fonte');
  if (Modelo.Font.Name = Canvas.Font.Name) and
     (Modelo.Font.Size = Canvas.Font.Size) and
     (Modelo.Font.Color = Canvas.Font.Color) and
     (Modelo.Font.Style = Canvas.Font.Style) then
  begin
    lnode.Attributes['default'] := BoolToStr(true);
  end else
  begin
    lnode.Attributes['default'] := BoolToStr(false);
    mNode := lnode.AddChild('FonteNome');
    mNode.Attributes['Valor'] := Canvas.Font.Name;
    mNode := lnode.AddChild('FonteTamanho');
    mNode.Attributes['Valor'] := Canvas.Font.Size;
    mNode := lnode.AddChild('FonteEstilo');
    mNode.Attributes['Valor'] := SetToString(
                               GetPropInfo(Canvas.Font, 'Style'),
                               GetOrdProp(Canvas.Font,GetPropInfo(Canvas.Font, 'Style')),
                               true);
//    mNode.Attributes['Valor'] := GetEnumProp(Font, 'Style');
    mNode := lnode.AddChild('FonteCor');
    mNode.Attributes['Valor'] := Canvas.Font.Color;
  end;

  if (Modelo.TipoDeModelo = tpModeloConceitual) then
  begin
    //atributos
    lnode := node.AddChild('Atributos');
    for i := 0 to FAtributos.Count -1 do
    begin
       TAtributo(FAtributos[i]).to_xml(lNode);
      lnode := lnode.ParentNode;
    end;

    //Atributos ocultos
    lnode := node.AddChild('AtributosOcultos');
    FAOcultos.GeraXML(lnode);
  end;

  //dicionario de dados
  lnode := node.AddChild('Dicionario');
  lnode.Text := Dicionario; //StringReplace(Dicionario, #$D#$A, '||', [rfReplaceAll]);

  //Nula?
  lnode := node.AddChild('Nula');
  lnode.Attributes['Valor'] := BoolToStr(Nula);

  //Observação
  lnode := node.AddChild('Observacao');
  lnode.Text := Observacoes;

  //Futuro
  lnode := node.AddChild('Futuro');
  lnode.Text := Futuro;

  //anexos
  lnode := node.AddChild('Anexos');
  for i := 0 to FAnexos.Count -1 do
  begin
    mNode := lnode.AddChild('id');
    mNode.Attributes['valor'] := TBase(FAnexos[i]).OID;
  end;
end;

{ TModelo }

function TModelo.Add: TBase;
begin
  Result := nil;
  case Ferramenta of
    Tool_Del: Erro(nil, 'Clique no objeto que será excluído!', 0);

    Tool_Texto, Tool_TextoII:
    with TTexto.Create(self) do
    begin
      Nome := 'Obs.: ';
      SetBounds(Clicado.X, Clicado.Y, 150, 3 * Canvas.TextHeight('H'));
      Result := Me;
      Tipo := IfThen(Ferramenta = Tool_Texto, TextoTipoHint, TextoTipoBranco);
//      Cor := clGrayText;
    end;
    Tool_Entidade:
    with TEntidade.Create(self) do
    begin
      Nome := GeraBaseNome('Entidade');
      SetBounds(Clicado.X, Clicado.Y, Width, Height);
      Result := Me;
    end;
    Tool_Especializacao, Tool_EspecializacaoA, Tool_EspecializacaoB:
    if (UsrSelA <> nil) and (UsrSelA is TEntidade) then
    begin
      case Ferramenta of
      Tool_Especializacao:
        if TEntidade(UsrSelA).CriarEsp = nil then
          Erro(nil, 'Entidade já especializada de forma obrigatória!' + #13 +'Não foi possível criar uma nova especialização para a entidade selecionada.', 0);
      Tool_EspecializacaoA:
        if not TEntidade(UsrSelA).Especialise(EspRestrita) then
          Erro(nil, 'Entidade já especializada!' + #13 +'Não foi possível criar uma nova especialização para a entidade selecionada.', 0);
      Tool_EspecializacaoB:
        if not TEntidade(UsrSelA).Especialise(EspOpicional) then
          Erro(nil, 'Entidade já especializada de forma obrigatória!' + #13 +'Não foi possível criar uma nova especialização para a entidade selecionada.', 0);
      end;
    end else begin
      Erro(nil, 'Clique na entidade que será especializada!', 0);
    end;
    Tool_Relacionamento:
    with TRelacao.Create(self) do
    begin

      // Início TCC II - Puc (MG) - Daive Simões
      // Retirados os sinais de acentuação do identificador
      Nome := GeraBaseNome('Relacao');
      // Fim TCC II


      SetBounds(Clicado.X, Clicado.Y, Width, Height);
      Result := Me;
      if UsrSelA is TBaseEntidade then
        if not Relacione(TBaseEntidade(UsrSelA)) then
          Erro(nil, 'Erro ao relacionar a entidade "' + UsrSelA.Nome + '" com a ' +
           'entidade "'+ UsrSelA.Nome + '".', 0);
      if UsrSelB is TBaseEntidade then
        if not Relacione(TBaseEntidade(UsrSelB)) then
          Erro(nil, 'Erro ao relacionar a entidade "' + UsrSelA.Nome + '" com a ' +
           'entidade "'+ UsrSelA.Nome + '".', 0);
      AdjustSize;
    end;
    Tool_EntidadeAssoss:
    with TEntidadeAssoss.Create(self) do
    begin
      Nome := GeraBaseNome('EntAssoss');

      // Início TCC II - Puc (MG) - Daive Simões
      // Retirados os sinais de acentuação do identificador
      Relacao.Nome := GeraBaseNome('Relacao');
      // Fim TCC II

      SetBounds(Clicado.X, Clicado.Y, Width, Height);
      Result := Me;
      if UsrSelA is TBaseEntidade then
        if not Relacao.Relacione(TBaseEntidade(UsrSelA)) then
          Erro(nil, 'Erro ao relacionar a entidade "' + UsrSelA.Nome + '" com a ' +
           'entidade "'+ UsrSelA.Nome + '".', 0);
      if UsrSelB is TBaseEntidade then
        if not Relacao.Relacione(TBaseEntidade(UsrSelB)) then
          Erro(nil, 'Erro ao relacionar a entidade "' + UsrSelA.Nome + '" com a ' +
           'entidade "'+ UsrSelA.Nome + '".', 0);
    end;
    Tool_Atributo, Tool_AtributoComp, Tool_AtributoMult, Tool_AtributoOpc, Tool_AtributoID:
    begin
      if UsrSelA <> nil then
      begin
        Result := UsrSelA.NovoAtributo(GeraBaseNome('Atributo'));
//        if not (UsrSelA is TBaseRelacao) then UsrSelA.OrganizeAtributos;
      end else begin
        Erro(nil, 'Clique no objeto que receberá o atributo!', 0);
      end;
    end;
    Tool_AutoRel:
    begin
      if (UsrSelA <> nil) and (UsrSelA is TBaseEntidade) then
      begin
        if TBaseEntidade(UsrSelA).AutoRelacionar(GeraBaseNome('Auto')) then
          Result := TBaseEntidade(UsrSelA).FAutoRelacao
        else
          Erro(nil, 'Entidade seleciona já possui auto-relacionamento!', 0);
      end else
      begin
        Erro(nil, 'Você não clicou em uma entidade!', 0);
      end;
    end;

    Tool_Ligacao:
    begin
      if (UsrSelA is TMaxRelacao) and (UsrSelB is TBaseEntidade) then
      begin
        if not TMaxRelacao(UsrSelA).Relacione(TBaseEntidade(UsrSelB)) then
          Erro(nil, 'Operação não realizável!', 0);
      end
      else
      if (UsrSelB is TMaxRelacao) and (UsrSelA is TBaseEntidade) then
      begin
        if not TMaxRelacao(UsrSelB).Relacione(TBaseEntidade(UsrSelA)) then
          Erro(nil, 'Operação não realizável!', 0);
      end
      else
      if (UsrSelA is TEspecializacao) and (UsrSelB is TEntidade) then
      begin
        if not TEspecializacao(UsrSelA).Adicione(TEntidade(UsrSelB)) then
          Erro(nil, 'Operação não realizável. Cicliquicidade não admissível!', 0);
      end
      else
      if (UsrSelB is TEspecializacao) and (UsrSelA is TEntidade) then
      begin
        if not TEspecializacao(UsrSelB).Adicione(TEntidade(UsrSelA)) then
          Erro(nil, 'Operação não realizável!', 0);
      end
      else
      Erro(nil, 'Seleções incorretas!', 0);
    end;

//Lógico........................................................................
    Tool_LOGICO_Relacao:
    begin
      if UsrSelA is TCampo then UsrSelA := TCampo(UsrSelA).Dono;
      if UsrSelB is TCampo then UsrSelB := TCampo(UsrSelB).Dono;
      if (UsrSelA is TTabela) and (UsrSelB is TTabela) then
      begin
        FConversao_LastLigaTab := TLigaTabela.Create(self);
        with FConversao_LastLigaTab do
        begin
          Nome := GeraBaseNome(UsrSelA.Nome + '_' + UsrSelB.Nome);
          SetBounds(Clicado.X - (Me.Width div 2), Clicado.Y - (Me.Height div 2), Width, Height);
          Relacione(TTabela(UsrSelA));
          Relacione(TTabela(UsrSelB));
          Result := Me;
        end;
      end else
      Erro(nil, 'Seleções incorretas!', 0);
    end;

    Tool_LOGICO_Tabela:
    with TTabela.Create(self) do
    begin
      Nome := GeraBaseNome('Tabela');
      SetBounds(Clicado.X, Clicado.Y, Width, Height);
      Result := Me;
    end;

    Tool_LOGICO_campo, Tool_LOGICO_FK, Tool_LOGICO_K, Tool_LOGICO_Separador:
    if (UsrSelA is TCampo) or (UsrSelA is TTabela) then
    begin
      if UsrSelA is TCampo then UsrSelA := TCampo(UsrSelA).Dono;
      with TCampo.Create(self) do
      begin
        Nome := GeraBaseNome('Campo');
        FIsKey := (Ferramenta = Tool_LOGICO_K);
        FIsFKey := (Ferramenta = Tool_LOGICO_FK);
        if (Ferramenta = Tool_LOGICO_Separador) then ApenasSeparador := True;
        Result := TTabela(UsrSelA).AddCampo(TCampo(Me));
      end;
    end else begin
      Erro(nil, 'Clique na tabela que receberá o campo!', 0);
    end;
  end;
  if Result <> nil then
  begin
    Result.Reenquadre;
  end;
  if Assigned(UsrSelA) then UsrSelA.AdjustSize;
  if Assigned(UsrSelB) then UsrSelB.AdjustSize;
  AtualizaQtdItens;
end;

procedure TModelo.AddSelect(B: Tbase);
  var i: integer;
begin
  if (Selecionado is TCampo) or B.Nula then exit;
  I := FMultSelecao.IndexOf(B);
  if i > -1 then
  begin
    FMultSelecao.Delete(i);
    for i := 1 to 4 do
      B.Pontos[i].Color := clBlack;
    B.SetSelecionado(false);
  end
  else begin
    if (Assigned(Selecionado) and (Selecionado <> B)) then
    begin
      FMultSelecao.Add(B);
      for i := 1 to 4 do
        B.Pontos[i].Color := clGreen;
      B.SetSelecionado(True);
    end else Selecionado := B;
  end;
end;

procedure TModelo.ClearSelect;
  var i, j: integer;
      B: Tbase;
begin
  if FMultSelecao.Count = 0 then exit;
  for i := 0 to FMultSelecao.Count -1 do
  begin
    B := Tbase(FMultSelecao[i]);
    if Assigned(B) then
    begin
      for j := 1 to 4 do
        B.Pontos[j].Color := clBlack;
      B.SetSelecionado(false);
    end;
  end;
  FMultSelecao.Clear;
end;

//procedure TModelo.Click;
//begin
{  if Visible then TVisual(Owner).SetFocusByModelo;
  Selecionado := nil;
  ClearSelect;
  OldFerramenta := -1;
  if Ferramenta > 0 then
  begin
    Clicado := ScreenToClient(Mouse.CursorPos);
    Add;
    OldFerramenta := Ferramenta;
    Ferramenta := 0;
  end;
  inherited;}
//end;

constructor TModelo.Create(AOwner: TComponent);
begin
  inherited;
  Color := clWhite;
  FCanvas := TControlCanvas.Create;
  FCanvas.Control := Self;
  FMultSelecao := TComponentList.Create(False);
  Font.Style := [fsBold];
  Font.Color := clBlack;
  FBaseHint := THintBalao.Create(nil);
  FBaseHint.Parent := self;
  FBaseHint.Modelo := Self;
  FSelecionador := TSelecao.Create(nil);
  FSelecionador.Modelo := Self;
  FListaDeTrabalho := TList.Create;
  Questoes := TStringList.Create;
  Versao := mVersao;
  FTipoDeModelo := tpModeloConceitual;

  FSelecionador.Visible := false;
  FSelecionador.Parent := Self;
  FSelecionador.Color := Color;
  FSelecionador.Canvas.Pen.Color := clWhite;
  FSelecionador.Canvas.Pen.Mode := pmXor;
  FSelecionador.Canvas.Pen.Style := psDot;
  FTemplate := TMngTemplate.Create(nil);//Self);
end;

procedure TModelo.DesSelecione;
begin
  FSelecionado := nil;
  FSelecaoAntiga := nil;
end;

destructor TModelo.Destroy;
begin
  GeraLog('Fechamento do esquema "' + Nome + '"', false, true);
  FMultSelecao.Free;
  FListaDeTrabalho.Free;
  FCanvas.Free;
  Questoes.Free;
  FBaseHint.Free;
  FSelecionador.Free;
  FTemplate.Free;
  inherited;
end;

procedure TModelo.EndOperation;
begin
  if Assigned(FSelecionado) then FSelecionado.reposicione;
  PostMessage(Handle, CM_BASEEXECSEL, 0, 0);
//alterado!!!...
//  if Assigned(FOnSelect) then FOnSelect(FSelecionado);
end;

procedure TModelo.EveryHideShowSelection(Exceto: Tbase; hs: boolean);
  var i: integer;
      B: Tbase;
begin
//  if FMultSelecao.Count = 0 then Exit;
  For i := 0 to FMultSelecao.Count -1 do
  begin
    B := TBase(FMultSelecao[i]);
    if Assigned(B) and (B <> exceto) then
    begin
      B.Selecionado := hs;
    end;
  end;
  if Assigned(Selecionado) and (selecionado <> exceto) then
  begin
    Selecionado.Selecionado := hs;
  end;
end;

function TModelo.FindByName(Nome: String; Step: Integer): TBase;
  var i, j: Integer;
begin
  j := 0;
  Nome := AnsiUpperCase(Nome);
  Result := nil;
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TBase then
      if not (TBase(Components[i]).Nula) then
        if AnsiUpperCase(TBase(Components[i]).Nome) = Nome then
    begin
      inc(J);
      Result := TBase(Components[i]);
      if (J > Step) then Break else Result := nil;
    end;
  end;
end;

function TModelo.getNextId: Integer;
begin
  inc(FIDs);
  Result := FIDs;
end;

procedure TModelo.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
  var i: integer;
begin
  if isMouseDown then
  begin
    isMouseDown := false;
    FSelecionador.Visible := false;
    for i := 0 to ComponentCount -1 do
      if (Components[i] is TBase) and not ((Components[i] is TCampo)) then
    begin
      if RectInRegion(FRegiao, TBase(Components[i]).BoundsRect) then
        AddSelect(TBase(Components[i]));
    end;
  end;
  if (ssCtrl in Shift) and (OldFerramenta > 0) then
  begin
    Ferramenta := OldFerramenta;
    OldFerramenta := -1;
  end;
  inherited;
end;

procedure TModelo.Movimente(Origem: Tbase; aLeft, aTop, aWidth,
  aHeight: integer);
  var i: integer;
      B: Tbase;
      bkp: boolean;
  Function NaoZero(a: integer; c: integer = 0): Integer;
  begin
    if a < C then Result := c else Result := a;
  end;
begin
  if FMultSelecao.Count = 0 then Exit;
  if (FMultSelecao.IndexOf(Origem) = -1) and (Origem <> Selecionado) then exit;
  For i := 0 to FMultSelecao.Count -1 do
  begin
    B := TBase(FMultSelecao[i]);
    if Assigned(B) and (B <> Origem) then
    begin
      bkp := B.Atualizando;
      B.Atualizando := true;
      if (B is TAtributo) and (not TAtributo(B).AutoSize) then
      begin
        B.SetBounds(NaoZero(B.Left - aLeft), NaoZero(B.Top - aTop), B.Width, B.Height);
      end
      else
        B.SetBounds(NaoZero(B.Left - aLeft), NaoZero(B.Top - aTop), NaoZero(B.Width - aWidth, 10), NaoZero(B.Height - aHeight, 10));

      B.Realinhe;
      OnBaseMoved(B);
      B.Atualizando := bkp;
    end;
  end;
  if (Origem <> Selecionado) and Assigned(Selecionado) then
  begin
    B := Selecionado;
    bkp := B.Atualizando;
    B.Atualizando := true;
    if (B is TAtributo) and (not TAtributo(B).AutoSize) then
    begin
      B.SetBounds(NaoZero(B.Left - aLeft), NaoZero(B.Top - aTop), B.Width, B.Height);
    end
    else
      B.SetBounds(NaoZero(B.Left - aLeft), NaoZero(B.Top - aTop), NaoZero(B.Width - aWidth, 10), NaoZero(B.Height - aHeight, 10));
    B.Realinhe;
    OnBaseMoved(B);
    B.Atualizando := bkp;
  end;
end;

//function TModelo.NovoAtributo(lNome: string; Dono: TBase): TBase;
//begin
//  Result := nil;
//  if Assigned(Dono) then
//  begin
//    Result := Dono.NovoAtributo(lNome);
//  end;
//end;

procedure TModelo.OnBaseMoved(base: TObject);
  var i, j, tmp: Integer;
      B, Ver: TBase;
      L: TLigacao;
begin
  if not Assigned(base) then exit;
  B := Tbase(base);
  if (B is TCardinalidade) or (not Assigned(B.FLigacoes)) then exit;

  //............. if ((B is TBaseEntidade) or (B is TTabela)) and (B.FLigacoes.Count > 0) then não pinte as linhas
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TLigacao then
      if TLigacao(Components[i]).BasePertence(B) then
    begin
      L := TLigacao(Components[i]);
      if (B is TAutoRelacao) and (b.FLigacoes.IndexOf(L) = 1) then Continue;
      if L.E1 = B then Ver := L.E2 else Ver := L.E1;
      if (Ver is TBaseEntidade) or (Ver is TTabela) then
      begin
        for j := 1 to 4 do
        begin
          tmp := Ver.QuantosNestePonto(J);
          if tmp > 1 then
          begin
            ver.divida(j, tmp);
          end
          else ver.AtivePorPonto(J);
        end;
      end;
    end;
  end;
  if ((B is TBaseEntidade) or (B is TTabela)) and (B.FLigacoes.Count > 0) then
  begin
    //............pinte as linhas agora
    for j := 1 to 4 do
    begin
      tmp := B.QuantosNestePonto(J);
      if tmp > 1 then
      begin
        B.divida(j, tmp);
      end
      else B.AtivePorPonto(J);
    end;
  end;
end;

procedure TModelo.Erro(Base: TBase; Msg: string; ErroTipo: Integer);
begin
  GeraLog(Msg, (ErroTipo = 0), true);
  If Assigned(FonErro) then FonErro(Base, Msg, ErroTipo);
end;

procedure TModelo.RefreshSelecao;
begin
  if not Assigned(FSelecionado) then exit;
  Selecionado.Selecionado := false;
  Selecionado.Selecionado := True;
  EndOperation;
end;

procedure TModelo.RepinteFKs(oKeyID: Integer);
  var i: integer;
begin
  for i := 0 to ComponentCount -1 do
    if (Components[i] is TCampo) and (TCampo(Components[i]).IsFKey) then
      if TCampo(Components[i]).Get_CampoOri = oKeyID then
        TCampo(Components[i]).Invalidate;
end;

procedure TModelo.SelecioneSelecionadosAtributos;
  var i: integer;
      B: TBase;
begin
  I := 0;
  while i < FMultSelecao.Count do
  begin
    B := TBase(FMultSelecao[i]);
    if not (B is TAtributo) then B.SelecionarAtributos;
    inc(i);
  end;
  if Assigned(Selecionado) then Selecionado.SelecionarAtributos;
end;

procedure TModelo.SetArquivo(const Value: String);
  var tmp: string;
begin
  FArquivo := Value;
  if FArquivo <> '' then
  begin
    tmp := ExtractFileName(Value);
    Nome := copy(tmp, 1, length(tmp) - length(ExtractFileExt(tmp)));
  end;
end;

procedure TModelo.SetClicado(const Value: TPoint);
begin
  FClicado := Value;
end;

procedure TModelo.SetFerramenta(const Value: integer);
begin
  FFerramenta := Value;
  UsrSelA := nil;
  UsrSelB := nil;
  if Parent.Parent is TScrollBox then
  begin
    Clicado := Point(TScrollBox(Parent.Parent).HorzScrollBar.ScrollPos -20,
                     TScrollBox(Parent.Parent).VertScrollBar.ScrollPos -20);
  end;
  if not NoChangeCursor then
  begin
    case Ferramenta of
      Tool_AtributoComp, Tool_AtributoMult, Tool_AtributoOpc, Tool_AtributoID: Cursor := Tool_Atributo;
      Tool_LOGICO_campo, Tool_LOGICO_FK, Tool_LOGICO_K: Cursor := Tool_LOGICO_campo;
      else cursor := Ferramenta;
    end;
    AtualizeCursor;
  end;  
end;

procedure TModelo.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TModelo.SetObservacao(const Value: string);
begin
  FObservacao := Value;
  Mudou := true;
end;

procedure TModelo.SetonBaseMouseMove(const Value: TBaseEvent);
begin
  FonBaseMouseMove := Value;
end;

procedure TModelo.SetOnSelect(const Value: TBaseEvent);
begin
  FOnSelect := Value;
end;

procedure TModelo.SetSelecionado(const Value: TBase);
begin
  if FDisableSelecao then Exit;
  SelecaoAntiga := FSelecionado;
  if Assigned(FSelecionado) then
  begin
    FSelecionado.Selecionado := False;
  end;
  FSelecionado := Value;
  if Assigned(FSelecionado) then
  begin
    FSelecionado.Selecionado := true;
  end;
  PostMessage(Handle, CM_BASEEXECSEL, 0, 0);
end;

procedure TModelo.SetUsrSelA(const Value: TBase);
begin
  FUsrSelA := Value;
end;

procedure TModelo.SetUsrSelB(const Value: TBase);
begin
  FUsrSelB := Value;
end;

procedure TModelo.SetonErro(const Value: TBaseErro);
begin
  FonErro := Value;
end;

procedure TModelo.BaseClick(Sender: Tbase);
var B, R: Tbase;
    L: TLigacao;
begin
  if Visible then TVisual(Owner).SetFocusByModelo;
  if Ferramenta = 0 then
  begin
    Exit;
  end;
  case Ferramenta of
  Tool_AutoRel:
    begin
      if (Sender is TBaseEntidade) then
      begin
        UsrSelA := Sender;
        Add;
        OldFerramenta := Ferramenta;
        Ferramenta := 0;
      end else
      begin
         Erro(sender, 'O objeto destino não é uma Entidade. Por favor, selecione uma entidade!', 0);
         OldFerramenta := Ferramenta;
         Ferramenta := 0;
      end;
    end;
  Tool_Especializacao, Tool_EspecializacaoA, Tool_EspecializacaoB:
    begin
      if (Sender is TEntidade) then
      begin
        UsrSelA := Sender;
        Add;
        OldFerramenta := Ferramenta;
        Ferramenta := 0;
      end else
      begin
         Erro(sender, 'O objeto destino não é uma Entidade. Por favor, selecione uma entidade!', 0);
         OldFerramenta := Ferramenta;
         Ferramenta := 0;
      end;
    end;
   Tool_Atributo, Tool_AtributoComp, Tool_AtributoMult, Tool_AtributoOpc, Tool_AtributoID:
    begin
      if (Sender is TBaseEntidade) or (Sender is TBaseRelacao) or (Sender is TAtributo) then
      begin
        if Sender is TAtributo then
          UsrSelA := TAtributo(Sender).Barra
        else UsrSelA := Sender;
        R := UsrSelA;
        B := Add;
        case Ferramenta of
          Tool_AtributoComp:
          Begin
            FFerramenta := Tool_Atributo;
            //UsrSelA := B;
            BaseClick(B);
            //UsrSelA := B;
            FFerramenta := Tool_Atributo;
            BaseClick(B);
            UsrSelA := R;
          end;
          Tool_AtributoMult:
          begin
            TAtributo(B).Cardinalidade := 3;
            TAtributo(B).Multivalorado := True;
          end;
          Tool_AtributoOpc:
          begin
            TAtributo(B).Opcional := true;
          end;
          Tool_AtributoID: TAtributo(B).Identificador := true;
        end;

        if not (UsrSelA is TBaseRelacao) then UsrSelA.OrganizeAtributos;
//        if UsrSelA is TBarraDeAtributos then UsrSelA.OrganizeAtributos;
        OldFerramenta := Ferramenta;
        Ferramenta := 0;
      end else
      begin
         Erro(sender, 'Este objeto não pode possuir atributo', 0);
         OldFerramenta := Ferramenta;
         Ferramenta := 0;
      end;
    end;
  Tool_Ligacao:
    begin
      if UsrSelA = nil then
      begin
        UsrSelA := Sender;
        Cursor := Tool_Ligacao2;
        AtualizeCursor;
        exit;
      end;
      UsrSelB := Sender;
      if UsrSelB = UsrSelA then
      begin
        Erro(sender, 'Não é possível ligar um objeto a ele próprio!', 0);
        OldFerramenta := Ferramenta;
        Ferramenta := 0;
      end;
      if not ((UsrSelB is TBaseEntidade) or (UsrSelA is TBaseEntidade)) then
      begin
        Erro(sender, 'Você deve selecionar pelo menos uma entidade!', 0);
        OldFerramenta := Ferramenta;
        Ferramenta := 0;
      end;
      OldFerramenta := Ferramenta;
      if (UsrSelB is TBaseEntidade) and (UsrSelA is TBaseEntidade) then
      begin
        FFerramenta := Tool_Relacionamento;
        Clicado := Point(UsrSelA.Left - ((UsrSelA.Left - UsrSelb.Left) div 2),
                         UsrSelA.Top -  ((UsrSelA.Top - UsrSelb.Top) div 2));
      end;
      Add;
      Ferramenta := 0;
    end;
//
  Tool_LOGICO_Relacao:
    begin
      if UsrSelA = nil then
      begin
        if (Sender is TCampo) or (Sender is TTabela) then
        begin
          UsrSelA := Sender;
          Cursor := Tool_LOGICO_Relacao2;
          AtualizeCursor;
        end else
        begin
          Erro(sender, 'O objeto selecionado não é uma tabela!', 0);
          Ferramenta := 0;
        end;
        exit;
      end;
      UsrSelB := Sender;
      if UsrSelB = UsrSelA then
      begin
        Erro(sender, 'Não é possível ligar um objeto a ele próprio!', 0);
        Ferramenta := 0;
        exit;
      end;
      if ((UsrSelB is TCampo) or (UsrSelB is TTabela)) and
         ((UsrSelA is TCampo) or (UsrSelA is TTabela)) then
      begin
        Clicado := Point(((UsrSelA.Left + UsrSelA.Width + UsrSelb.Left) div 2),
                         ((UsrSelA.Top + UsrSelA.Height + UsrSelb.Top) div 2));
        UsrSelA := Add;
      end else
      begin
        Erro(sender, 'O objeto selecionado não é uma tabela!', 0);
      end;
      Ferramenta := 0;
    end;
//
  Tool_Del:
    begin
      if Sender = Selecionado then Selecionado := nil;
      if FMultSelecao.IndexOf(sender) > -1 then FMultSelecao.Remove(sender);
      if Sender is TCardinalidade then
      begin
        if (TCardinalidade(Sender).FComando.Pai is TMaxRelacao) or
           (TCardinalidade(Sender).FComando.Pai is TEspecializacao) then
        begin
          R := TBase(TCardinalidade(Sender).FComando.Pai);
          B := TBase(TCardinalidade(Sender).FComando.Ponta);
          L := TCardinalidade(Sender).FComando;
          if (r is TEspecializacao) then
          begin
            if L.BasePertence(TEspecializacao(R).EntidadeBase) then
            begin
              BaseClick(R);
              exit;
            end else
            begin
              if TEntidade(B).Origem = TEspecializacao(R) then
                TEntidade(B).Origem := nil
              else
                TEntidade(B).FOrigens.Remove(R);
            end;
          end;
          b.FLigacoes.Remove(L);
          R.FLigacoes.Remove(L);
          R.AdjustSize;
          B.AdjustSize;
          if r = Selecionado then Selecionado := r;
          Ferramenta := 0;
        end else
        if (TCardinalidade(Sender).FComando.Pai is TAtributo) or (TCardinalidade(Sender).FComando.Pai is TLigaTabela) then
        begin
          BaseClick(TBase(TCardinalidade(Sender).FComando.Pai));
          exit;
        end else Erro(sender, 'Objeto não pode ser excluído separadamente!', 0);
      end else
      begin
        FreeAndNil(Sender);
        Ferramenta := 0;
      end;
      AtualizaQtdItens;
    end;
  Tool_LOGICO_campo, Tool_LOGICO_FK, Tool_LOGICO_K, Tool_LOGICO_Separador:
    begin
      UsrSelA := Sender;
      add;
      Selecionado := UsrSelA;
      TTabela(UsrSelA).Invalidate;
      Ferramenta := 0;
    end;
  end;
end;

procedure TModelo.AtualizeCursor;
  var i: Integer;
begin
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TBase then
    begin
      if Ferramenta <> 0 then TBase(Components[i]).Cursor := Cursor
      else TBase(Components[i]).Cursor := crHandPoint;
    end;
  end;
end;

procedure TModelo.CMBaseClick(var Message: TMessage);
begin
  if Message.WParam <> 0 then BaseClick(TBase(Message.WParam));
end;

procedure TModelo.AtualizaQtdItens;
  var i: Integer;
begin
  FQtdBase := 0;
  FQtdEntidade := 0;
  FQtdRelacao := 0;
  FQtdTabela := 0;
  for i := 0 to ComponentCount -1 do
  begin
//    if Components[i] is TBaseEntidade then inc(FQtdEntidade); //17/05/07
//    if Components[i] is TMaxRelacao then inc(FQtdRelacao);
//    if Components[i] is TBase then inc(FQtdBase);
//    if Components[i] is TTabela then inc(FQtdTabela);
    if Components[i] is TBaseEntidade then inc(FQtdEntidade) else
      if Components[i] is TMaxRelacao then inc(FQtdRelacao) else
        if Components[i] is TTabela then inc(FQtdTabela);
    if Components[i] is TBase then inc(FQtdBase);
  end;
end;

procedure TModelo.Load;
  var i: Integer;
      B: TBase;
begin
  staLoading := true;
  DesSelecione;
  try
    FIDs := 0;
    for I := 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TBase) then
      begin
        B := TBase(Components[i]);
        B.Load;
        FIDs := Max(FIDs, B.FOID);
      end;
    end;
  finally
    staLoading := false;
    AtualizaQtdItens;
  end;
end;

procedure TModelo.ProcesseBaseClick(Sender: Tbase; Tool: integer);
begin
  Ferramenta := Tool;
  BaseClick(Sender);
  Ferramenta := Tool_Nothing;
end;

function TModelo.PromoverAEntAss(R: TRelacao): boolean;
  var EA: TEntidadeAssoss;
       I, Err: Integer;
       Lista: TComponentList;
       P: TPoint;
begin
  Result := false;
  if not Assigned(R) then Exit;
  Lista := TComponentList.Create(false);
  try
    Popule(R, Lista, Err);
    Err := 0;
    P := Point(R.Left, R.Top);
    if R = Selecionado then Selecionado := nil;
    if FMultSelecao.IndexOf(R) > -1 then FMultSelecao.Remove(R);

    EA := TEntidadeAssoss.Create(Self);
    EA.Relacao.Nome := R.Nome;
    EA.Nome := GeraBaseNome('EntAssoss');
    EA.Relacao.Dicionario := R.Dicionario;
    EA.Relacao.Observacoes := R.Observacoes;

    for i := 0 to R.FAtributos.Count -1 do
    begin
      EA.Relacao.FAtributos.Add(R.FAtributos[i]);
      TAtributo(R.FAtributos[i]).Dono := EA.Relacao;
    end;
    R.FAtributos.OwnsObjects := false;
    R.FAtributos.Clear;

    EA.Relacao.AOcultos.AtributosOcultos.Free;
    EA.Relacao.AOcultos.AtributosOcultos := R.AOcultos.AtributosOcultos;
    EA.Relacao.AOcultos.ReSetConjAtt(EA.Relacao.AOcultos);
    R.AOcultos.AtributosOcultos := TObjectList.Create(false);

    for i := 0 to EA.Relacao.AOcultos.AtributosOcultos.Count -1 do
    begin
      MostraAtributoOculto(TAtributoOculto(EA.Relacao.AOcultos.AtributosOcultos[i]),
                              EA.Relacao);
    end;
    EA.Relacao.AOcultos.AtributosOcultos.OwnsObjects := true;
    EA.Relacao.AOcultos.AtributosOcultos.Clear;
    EA.Relacao.AOcultos.AtributosOcultos.OwnsObjects := False;

    FreeAndNil(R);
    EA.Relacao.Atualizando := true;
    for i := 0 To Lista.Count -1 do
    begin
      if (Lista[i] is TBaseEntidade) then
        if not EA.Relacao.Relacione(TBaseEntidade(Lista[i])) then inc(Err);
    end;
    EA.Relacao.Atualizando := false;
    EA.SetBounds(P.X, P.Y, EA.Width, EA.Height);
    EA.Reenquadre;
    Result := true;
  finally
    Lista.Free;
    if not Result then FreeAndNil(EA);
  end;
  if Err > 0 then Erro(EA, 'Alguns relacionamentos não foram reconstituídos!', 1);
end;

procedure TModelo.Popule(ori: TBase; dest: TComponentList; var repetidos: integer);
  var i: integer;
      L: TLigacao;
begin
  repetidos := 0;
  if Assigned(ori) and Assigned(ori.FLigacoes) then
    for i := 0 to ori.FLigacoes.Count -1 do
  begin
    L := TLigacao(ori.FLigacoes[i]);
    if (dest.IndexOf(L.Ponta) = -1) then
      dest.Add(L.Ponta) else
        inc(repetidos);
  end;
end;

function TModelo.PromoverAEntidade(A: TAtributo): boolean;
  var R: TMaxRelacao;
      E : TEntidade;
      e_dono: TBaseEntidade;
      P: TPoint;
      i: integer;
      tmp: TAtributo;
begin
  Result := false;
  e_dono := nil;
  if not Assigned(A) or (not (Assigned(A.Dono))) or (A.Dono is TBarraDeAtributos) then Exit;
  try
    if A = Selecionado then Selecionado := nil;
    if FMultSelecao.IndexOf(A) > -1 then FMultSelecao.Remove(A);
    P.X := A.Left;
    P.Y := A.Top;
    if (A.Dono is TBaseEntidade) or (A.Dono is TAutoRelacao) then
    begin
      R := TRelacao.Create(Self);

      // Início TCC II - Puc (MG) - Daive Simões
      // Retirados os sinais de acentuação do identificador
      R.Nome := GeraBaseNome('Relacao');
      // Fim TCC II

      R.SetBounds(P.X, P.Y, R.Width, R.Height);
      e_dono := TBaseEntidade(A.Dono);
      if (A.Dono is TAutoRelacao) then e_dono := TAutoRelacao(A.Dono).Pai;
      e_dono.AdjustSize;
    end
    else
    begin
      R := TMaxRelacao(A.Dono);
      P.X := P.X - R.Width -50;
    end;
    E := TEntidade.Create(Self);
    E.Nome := A.Nome;
    E.SetBounds(P.X + R.Width + 50, P.Y, E.Width, E.Height);
    E.Dicionario := A.Dicionario;
    E.Observacoes := A.Observacoes;
    Result := R.Relacione(E);
    E.AOcultos.AtributosOcultos.Free;
    E.AOcultos.AtributosOcultos := A.AOcultos.AtributosOcultos;
    E.AOcultos.ReSetConjAtt(E.AOcultos);
    A.AOcultos.AtributosOcultos := TObjectList.Create(false);

    A.Barra.Atributos.OwnsObjects := false;
    For i := 0 to A.Barra.Atributos.Count -1 do
    begin
      E.Atributos.Add(A.Barra.Atributos[i]);
      tmp := TAtributo(A.Barra.Atributos[i]);
      tmp.FLigacoes.Clear;
      tmp.Dono := E;
    end;
    A.Barra.Atributos.Clear;
    FreeAndNil(A);
    if Assigned(e_dono) then Result := R.Relacione(e_dono);
    R.Reenquadre;
    E.Reenquadre;
    R.AdjustSize;
    E.AdjustSize;
    E.OrganizeAtributos;
  finally
    if not Result then
    begin
      if Assigned(R) and Assigned(e_dono) then FreeAndNil(R);//see criou a relação e_dono esta com valor
      if Assigned(E) then FreeAndNil(E);
    end;
  end;
end;

procedure TModelo.SetSelecaoAntiga(const Value: TBase);
begin
  FSelecaoAntiga := Value;
end;

function TModelo.ModeloCarregando: boolean;
begin
  Result := ((csReading in ComponentState) or FDisableSelecao);
end;

function TModelo.MostraAtributoOculto(At: TAtributoOculto;
  b: TBase): boolean;
  var tmp: TObjectList;
      i: integer;
      A: TAtributo;
begin
  Result := False;
  if not Assigned(b) or not Assigned(at) {or (b is TAtributo)} then Exit;
  if (at.GrupoDeAtributos <> b.AOcultos) or Assigned(at.Pai) then exit;

  if b is TAtributo then b := TAtributo(B).Barra;

  A := TAtributo(b.NovoAtributo(at.Nome));
  if at.Filhos.Count > 0 then
  begin
    tmp := at.Filhos;
    for i:= 0 to tmp.Count -1 do TAtributoOculto(tmp[i]).Pai := nil;
    at.Filhos := TObjectList.Create(false);
    A.AOcultos.AtributosOcultos.Free;
    A.AOcultos.AtributosOcultos := tmp;
    A.AOcultos.ReSetConjAtt(A.AOcultos);
  end;
  if at.LeftTop.X <> -1 then
  begin
    A.Left := at.LeftTop.X;
    A.Top := at.LeftTop.Y;
  end;
  A.MaxCard := At.MaxCard;
  A.MinCard := At.MinCard;
  A.TipoDoValor := at.Tipo;
  A.Identificador := at.Identificador;
  A.Multivalorado := at.Multivalorado;

  A.Dono.OrganizeAtributos;

  Result := true;
end;

function TModelo.OcultarAtributo(A: TAtributo): boolean;
  var b: TBase;
      patt: TAtributoOculto;
      tmp: TObjectList;
      i, ma, mi: integer;
begin
  Result := false;
  b := A.Dono;
  if (b is TChildRelacao) then
  begin
    Erro(A, 'Um atributo pertencente à um relacionamento' + #13 +
            'em uma entidade associativa não pode ser ocultado!', 1);
    exit;
  end;
  if b is TBarraDeAtributos then b := TBarraDeAtributos(B).Dono;
  mi := a.MinCard;
  ma := a.MaxCard;
  if not a.Multivalorado then Ma := 0;
  patt := b.AOcultos.NovoAtributo(A.Nome, a.TipoDoValor, Point(A.Left, A.Top), A.Identificador, Point(mi, ma));

  while A.Barra.Atributos.Count > 0 do
  begin
    //recursividade na ocultação
    OcultarAtributo(TAtributo(A.Barra.Atributos[A.Barra.Atributos.Count -1]));
  end;

  if A.AOcultos.AtributosOcultos.Count > 0 then
  begin
    tmp := A.AOcultos.AtributosOcultos;
    patt.Filhos.Free;
    patt.Filhos := tmp;
    patt.ReSetConjAtt(b.AOcultos);
    for i:= 0 to patt.Filhos.Count -1 do TAtributoOculto(patt.Filhos[i]).Pai := patt;
    A.AOcultos.AtributosOcultos := TObjectList.Create(false);
  end;
  if A = Selecionado then Selecionado := nil;
  if FMultSelecao.IndexOf(A) > -1 then FMultSelecao.Remove(A);
  FreeAndNil(A);
  B.OrganizeAtributos;
  Result := true;
end;

procedure TModelo.ProcessKey(var Key: Word; Shift: TShiftState);
  var B: TBase;
      I, n, L, T, W, H: integer;
begin
  if Selecionado = nil then exit;
  L := Selecionado.Left;
  T := Selecionado.Top;
  W := Selecionado.Width;
  H := Selecionado.Height;

  case key of
    VK_LEFT:
    begin
      L := L - 2;
      if (ssShift in Shift) or (ssCtrl in  Shift) then W := W + 2;
    end;
    VK_UP:
    begin
      T := T - 2;
      if (ssShift in Shift) or (ssCtrl in  Shift) then H := H + 2;
    end;
    VK_RIGHT :
    begin
      L := L + 2;
      if (ssShift in Shift) or (ssCtrl in  Shift) then W := W - 2;
    end;
    VK_DOWN:
    begin
      T := T + 2;
      if (ssShift in Shift) or (ssCtrl in  Shift) then H := H - 2;
    end;
    VK_DELETE:
    begin
      DeleteSelection;
      Key := 0;
    end;
  end;
  case key of
    VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN:
    begin
      if FMultSelecao.Count > 0 then
        EveryHideShowSelection(nil, false) else Selecionado.SetSelecionado(False);
      Selecionado.SetBounds(L, T, W, H);
      Selecionado.Reenquadre;
      if FMultSelecao.Count > 0 then EveryHideShowSelection(nil, true);
      Selecionado := Selecionado;
      key := 0;
    end;
  end;
  if Key = VK_TAB then
  begin
    if FMultSelecao.Count > 0 then exit;
    n := 1;
    if (ssShift in  Shift) then  n := -1;
    i := Selecionado.OID + n;
    B := FindByID(i);
    while (B = nil) or (not B.Visible) or (B is TBarraDeAtributos) or
    (B is TChildRelacao) do
    begin
      i := i + n;
      if i > FIDs then i := 0;
      if i < 0 then i := FIDs;
      B := FindByID(i);
    end;
    Selecionado := B;
    Key := 0;
  end;
end;

function TModelo.CalculeArea: TPoint;
  var P: TPoint;
      i: Integer;
      B : TBase;
begin
  Result.X := 0;
  Result.Y := 0;
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TBase then
    begin
      B := TBase(Components[i]);
      if b is TBarraDeAtributos then Continue;
      P := Point(B.Left + B.Width, B.Top + b.Height);
      if P.X > Result.X then Result.X := P.X;
      if P.Y > Result.Y then Result.Y := P.Y;
    end;
  end;
end;

function TModelo.GeraXml: TStringList;
  var i: integer;
      node : IXMLNode;
begin
  Result := nil;
  try
    if not Assigned(DXML) then exit;
    if Assigned(Parent) then
    begin
      FScrollPos := Point(TScrollingWinControl(Parent.Parent).HorzScrollBar.Position,
                        TScrollingWinControl(Parent.Parent).VertScrollBar.Position);
    end;
    DefaultXML;
    if not Copiando then
    begin
      node := MyParserFindNode(DXML.DocumentElement.ChildNodes[0], 'Template');
      if node <> nil then
        if not FTemplate.SalveToXML(node) then GeraLog('Template de conversão não foi salva no arquivo de modelo!', true);
    end;
    for i := 0 to ComponentCount -1 do
    begin
      if (TipoDeModelo = tpModeloConceitual) then
//conceitual
      begin
        if (Components[i] is TEntidade) then
         begin
          node := DXML.DocumentElement.ChildNodes[1];
          TEntidade(Components[i]).to_xml(node);
        end else
        if (Components[i] is TRelacao) then
        begin
          node := DXML.DocumentElement.ChildNodes[2];
          TRelacao(Components[i]).to_xml(Node);
        end else
        if (Components[i] is TEntidadeAssoss) then
        begin
          node := DXML.DocumentElement.ChildNodes[3];
          TEntidadeAssoss(Components[i]).to_xml(Node);
        end else
        if (Components[i] is TTexto) then
        begin
          node := DXML.DocumentElement.ChildNodes[4];
          TTexto(Components[i]).to_xml(node);
        end;
      end;
//lógico
      if (TipoDeModelo = tpModeloLogico) then
      begin
        if (Components[i] is TTabela) then
        begin
          node := DXML.DocumentElement.ChildNodes[1];
          TTabela(Components[i]).to_xml(node);
        end else
        if (Components[i] is TLigaTabela) then
        begin
          node := DXML.DocumentElement.ChildNodes[2];
          TLigaTabela(Components[i]).to_xml(node);
        end else
        if (Components[i] is TTexto) then
        begin
          node := DXML.DocumentElement.ChildNodes[3];
          TTexto(Components[i]).to_xml(node);
        end;
      end;
    end;
    Result := TStringList.Create;
    Result.AddStrings(DXML.XML);
    DXML.Active := False;
  except
    on exception do
    begin
      Result := nil;
      Erro(nil, 'Erro ao gerar o arquivo XML!', 0);
    end;
  end;
end;

procedure TModelo.SetDXML(const Value: TXMLDocument);
begin
  FDXML := Value;
end;

function TModelo.Salvar(arq: string): boolean;
  var Strs: TStringList;
      Mem: TMemoryStream;
      ext: string;
      myVersao: string[5];
begin
  Colando := false;
  Copiando := false;
  Result := false;
  ext := AnsiUpperCase(ExtractFileExt(arq));
  GeraLog('Salvado esquema ' + Nome  + ' em "' + arq + '"...', false, true);
  if ext = '.XML' then
  begin
    Strs := GeraXml;
    if Assigned(Strs) then
    begin
      try
        Strs.SaveToFile(arq);
        Strs.Free;
      except
        on EFcreateError do
        begin
          Erro(nil, 'Erro ao salvar o arquivo. Processo finalizado!' + #13 + 'Arquivo:' + '"' + arq + '"', 0);
          Exit;
        end;
      end;
    end;
  end else
  begin
    Mem := TMemoryStream.Create;
    myVersao := mVersao;
    Mem.SetSize(SizeOf(Self) + SizeOf(myVersao));
    Mem.WriteBuffer(myVersao, SizeOf(myVersao));

    Mem.WriteComponent(Self);
    try
      Mem.SaveToFile(arq);
      Mem.Free;
    except
      on EFcreateError do
      begin
        Erro(nil, 'Erro ao salvar o arquivo. Processo finalizado!' + #13 + 'Arquivo:' + '"' + arq + '"', 0);
        Exit;
      end;
    end;
  end;
  Mudou := False;
  FNovo := False;
  Arquivo := arq;
  Result := true;
  GeraLog('Esquema salvo em ' + arq, false, true);
  if Assigned(FModeloMudou) then FModeloMudou(Self);
end;

function TModelo.Salvar: boolean;
begin
  Result := false;
  if Arquivo <> '' then Result := Salvar(Arquivo) else
  Erro(nil, 'Informe o nome do arquivo!', 0);
end;

Function TModelo.Copiar: boolean;
  var node: IXMLNode;
      i, err, ac: integer;
begin
  Result := false;
  if Selecionado = nil then exit;
  DefaultXML;
  err := 0;
  ac := 0;
  Result := True;
  Copiando := true;
  if (Selecionado is TEntidade) then
  begin
    node := DXML.DocumentElement.ChildNodes[1];
    TEntidade(Selecionado).to_xml(node);
    inc(ac);
  end else
  if (Selecionado is TRelacao) then
  begin
    node := DXML.DocumentElement.ChildNodes[2];
    TRelacao(Selecionado).to_xml(node);
    inc(ac);
  end else
  if (Selecionado is TEntidadeAssoss) then
  begin
    node := DXML.DocumentElement.ChildNodes[3];
    TEntidadeAssoss(Selecionado).to_xml(node);
    inc(ac);
  end else
  if (Selecionado is TTexto) then
  begin
    if (TipoDeModelo = tpModeloLogico) then node := DXML.DocumentElement.ChildNodes[3];
    if (TipoDeModelo = tpModeloConceitual) then node := DXML.DocumentElement.ChildNodes[4];
    TTexto(Selecionado).to_xml(node);
    inc(ac);
  end else
  if (Selecionado is TTabela) then
  begin
    node := DXML.DocumentElement.ChildNodes[1];
    TTabela(Selecionado).to_xml(node);
    inc(ac);
  end else
  if not ((Selecionado is TCardinalidade) or (Selecionado is TAutoRelacao) or (Selecionado is TLigaTabela)) then inc(err);

  for i := 0 to FMultSelecao.Count -1 do
  begin
    if (FMultSelecao[i] is TEntidade) then
    begin
      node := DXML.DocumentElement.ChildNodes[1];
      TEntidade(FMultSelecao[i]).to_xml(node);
      inc(ac);
    end else
    if (FMultSelecao[i] is TRelacao) then
    begin
      node := DXML.DocumentElement.ChildNodes[2];
      TRelacao(FMultSelecao[i]).to_xml(node);
      inc(ac);
    end else
    if (FMultSelecao[i] is TEntidadeAssoss) then
    begin
      node := DXML.DocumentElement.ChildNodes[3];
      TEntidadeAssoss(FMultSelecao[i]).to_xml(node);
      inc(ac);
    end else
    if (FMultSelecao[i] is TTabela) then
    begin
      node := DXML.DocumentElement.ChildNodes[1];
      TTabela(FMultSelecao[i]).to_xml(node);
      inc(ac);
    end else
    if (FMultSelecao[i] is TTexto) then
    begin
      if (TipoDeModelo = tpModeloLogico) then node := DXML.DocumentElement.ChildNodes[3];
      if (TipoDeModelo = tpModeloConceitual) then node := DXML.DocumentElement.ChildNodes[4];
      TTexto(FMultSelecao[i]).to_xml(node);
      inc(ac);
    end else
    if not ((FMultSelecao[i] is TCardinalidade) or (FMultSelecao[i] is TAutoRelacao) or (FMultSelecao[i] is TLigaTabela)) then inc(err);
  end;
  if ac = 0 then
  begin
    Erro(Selecionado, 'Objeto(s) dependente(s) não pode(m) ser copiado(s) para a memória!', 0);
    Result := false;
  end;
  if (Err > 0) and (Ac <> 0) then
    Erro(nil, 'Pelo menos um objeto selecionado não foi copiado para a memória.' + #13 +
              'Objeto(s) dependente(s) não pode(m) ser copiado(s). Exemplo: Especialização!', 1);

  Copiando := false;
  if Result then Clipboard.AsText := DXML.XML.Text;
  DXML.Active := false;
end;

procedure TModelo.SetMudou(const Value: boolean);
begin
  if not FDisableSelecao and Value then Inc(FFliquer);
  if FMudou = Value then Exit;
  FMudou := Value;
  if Assigned(FModeloMudou) then ModeloMudou(Self);
end;

procedure TModelo.SetModeloMudou(const Value: TNotifyEvent);
begin
  FModeloMudou := Value;
end;

procedure TModelo.SetBaseHint(const Value: THintBalao);
begin
  FBaseHint := Value;
end;

function TModelo.LoadFromXML: boolean;
  var nodeEnt, nodeRel, nodeEntAss, nodeTex, nodeInf, nodeLogico, nodeRoot : IXMLNode;
      Str: String;
      i: integer;
  Procedure subErro(txt: string = '');
  begin
    if txt = '' then
      txt := 'Foi encontrada uma falha estrutural no arquivo carregado!' + #13 + 'Arquivo XML inválido.';
    Result := false;
    if Colando then txt := StringReplace(txt, 'arquivo carregado', 'conteúdo XML em memória', []);
    Erro(nil, txt, 0);
    LoadProgress := Point(0, 0);
    DoProgress;
    FDisableSelecao := false;
    Screen.Cursor := crDefault;
  end;
begin
  Result := true;
  Screen.Cursor := crHourGlass;
  try
    FDisableSelecao := true;
    if not Assigned(DXML) then exit;

    if not Colando then
    begin
      nodeRoot := DXML.DocumentElement.ChildNodes[0];
      nodeInf :=  nodeRoot.ChildNodes.FindNode('Posicao');
      FScrollPos := Point(nodeInf.Attributes['Left'], nodeInf.Attributes['Top']);
      LoadProgress.Y := nodeRoot.ChildNodes.FindNode('TotalItens').Attributes['Valor'];
      LoadProgress.X := 0;

      nodeInf := nodeRoot.ChildNodes.FindNode('Tipo');
      if Assigned(nodeInf) then
      begin
        Str := UpperCase(nodeInf.Attributes['Valor']);
        FTipoDeModelo := GetIntTipoDeModelo(Str);
      end;

      nodeInf := nodeRoot.ChildNodes.FindNode('Versao');
      if Assigned(nodeInf) then
      begin
        Versao := nodeInf.Attributes['Valor'];
        if Versao = '2.0.0' then
        begin
          Autor := nodeRoot.ChildNodes.FindNode('Autor').Attributes['Valor'];
          Observacao := nodeRoot.ChildNodes.FindNode('Observacao').Attributes['Valor'];
        end;
      end;

      if (TipoDeModelo = tpModeloLogico) then
      begin
        nodeInf := nodeRoot.ChildNodes.FindNode('Template');
        if Assigned(nodeInf) then
        begin
          if not FTemplate.LoadFromXML(nodeInf) then GeraLog('Erro ao carregar o template de conversão!', true);
        end;
      end;

      DoProgress;
    end else
    begin
      nodeRoot := DXML.DocumentElement.ChildNodes[0];
      nodeInf := nodeRoot.ChildNodes.FindNode('Tipo');
      if Assigned(nodeInf) then
      begin
        Str := UpperCase(nodeInf.Attributes['Valor']);
        if (GetStrTipoDeModelo <> Str) then
        begin
          Result := false;
          Erro(nil, 'Origens divergentes. Não é possível colar objetos oriundos de'#13'modelo lógico em um modelo conceitual ou vice-versa', 0);
          LoadProgress := Point(0, 0);
          DoProgress;
          FDisableSelecao := false;
          Screen.Cursor := crDefault;
          exit;
        end;
      end;
    end;

    //conceitual
    if (TipoDeModelo = tpModeloConceitual) then
    begin
      nodeEnt := DXML.DocumentElement.ChildNodes[1];
      if (nodeEnt.LocalName <> 'Entidades') or
        not LoadEntidadeByXML(nodeEnt) then
      begin
        subErro;
        exit;
      end;

      nodeEntAss := DXML.DocumentElement.ChildNodes[3];
      if (nodeEntAss.LocalName <> 'EntAssoss') or
        not LoadEntAssByXML(nodeEntAss) then
      begin
        subErro;
        exit;
      end;

      nodeRel := DXML.DocumentElement.ChildNodes[2];
      if (nodeRel.LocalName <> 'Relacoes') or
        not LoadRelacaoByXML(nodeRel) then
      begin
        subErro;
        exit;
      end;

      nodeTex := DXML.DocumentElement.ChildNodes[4];
      if (nodeTex.LocalName <> 'Texto') or
        not LoadTextoByXML(nodeTex) then
      begin
        subErro;
        exit;
      end;
    end;
    //lógico
    if (TipoDeModelo = tpModeloLogico) then
    begin
      nodeLogico := DXML.DocumentElement.ChildNodes[1];
      if (nodeLogico.LocalName <> 'Tabelas') or
        not LoadTabelaByXML(nodeLogico) then
      begin
        subErro;
        exit;
      end;

      nodeLogico := DXML.DocumentElement.ChildNodes[2];
      if (nodeLogico.LocalName <> 'LigacaoEntreTabelas') or
        not LoadLigacaoByXML(nodeLogico) then
      begin
        subErro;
        exit;
      end;

      nodeTex := DXML.DocumentElement.ChildNodes[3];
      if (nodeTex.LocalName <> 'Texto') or
        not LoadTextoByXML(nodeTex) then
      begin
        subErro;
        exit;
      end;
    end;

    DXML.Active := False;
    DXML.XML.Clear;
    FDisableSelecao := false;
    if not Colando then
    begin
//
      for i := 0 to ComponentCount -1 do
      begin
        if Components[i] is TBase then
          TBase(Components[i]).AdjustSize;
      end;
//
      if (TipoDeModelo = tpModeloLogico) then
        for i := 0 to ComponentCount -1 do
      begin
        if Components[i] is TCampo then
          if TCampo(Components[i]).IsFKey then
             TCampo(Components[i]).GetCampoOrigem;
      end;

      TScrollingWinControl(Parent.Parent).HorzScrollBar.Position := ScrollPos.X;
      TScrollingWinControl(Parent.Parent).VertScrollBar.Position := ScrollPos.Y;
      LoadProgress.Y := 0;
      LoadProgress.X := 0;
      DoProgress;
    end;
    Mudou := false;
  except
    on exception do
    begin
      LoadProgress := Point(0, 0);
      DoProgress;
      FDisableSelecao := false;
      Result := false;
      Erro(nil, 'Erro ao tentar ler dados XML!', 0);
    end;
  end;
  Screen.Cursor := crDefault;
end;

function TModelo.FindByID(Oid: Integer): TBase;
  var i: Integer;
begin
  Result := nil;
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TBase then
      if TBase(Components[i]).OID = Oid then
    begin
      Result := TBase(Components[i]);
      break;
    end;
  end;
end;

function TModelo.LoadEspecializacaoByXML(Node: IXMLNode): boolean;
  var lnode, nodesEsp, espNode, lig: IXMLNode;
      i, j, idEnt: integer;
      Ent: TEntidade;
      Esp : TEspecializacao;
begin
  Result := true;
  if Colando then Exit;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      idEnt := lnode.Attributes['id'];
      nodesEsp := MyParserFindNode(lnode, 'Especializacoes');
      if nodesEsp.Attributes['ehEsp'] then
      begin
        for j := 0 to nodesEsp.ChildNodes.Count -1 do
        begin
          espNode := nodesEsp.ChildNodes[j];
          Ent := TEntidade(FindByID(idEnt));
          Esp := Ent.CriarEsp;
          Result := BaseReconfigureByXML(Esp, espNode);
          if not Result then Break;
          Esp.Parcial := MyParserFindNode(espNode, 'Parcial').Attributes['Valor'];
          lig := MyParserFindNode(espNode, 'Ligacoes');
          Result := RealizeLigacoesByXml(Esp, lig);
          Esp.BringToFront;
        end;
        if not Result then Break;
      end;
//      AdjustSize;
    end;
  except
    Result := false;
  end;
end;

function TModelo.LoadEntAssByXML(Node: IXMLNode): boolean;
  var lnode, tmp, auto, lig: IXMLNode;
      i: integer;
begin
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      with TEntidadeAssoss.Create(Self) do
      begin
        Result := BaseReconfigureByXML(Me, lnode);
        if not Result then Break;
        auto := MyParserFindNode(lnode, 'AutoRelacoes');
        if auto.Attributes['AutoRelacionado'] = true then
        begin
          auto := auto.ChildNodes[0];
          AutoRelacionar(auto.Attributes['nome']);
          lig := MyParserFindNode(auto, 'Ligacoes');
          tmp := lig.ChildNodes[0];
          Result := LigacaoReconfigureByXML(TLigacao(FAutoRelacao.FLigacoes[0]), tmp);
          if not Result then Break;
          tmp := lig.ChildNodes[1];
          Result := LigacaoReconfigureByXML(TLigacao(FAutoRelacao.FLigacoes[1]), tmp);
          if not Result then Break;
          Result := BaseReconfigureByXML(FAutoRelacao, auto);
          if not Result then Break;
        end;
        lnode := MyParserFindNode(lnode, 'ChildRelacao');
        Result := BaseReconfigureByXML(Relacao, lnode);
        if not Result then Break;
//        lig := MyParserFindNode(lnode, 'Ligacoes');  //não porque nem todas as entidades ass. foram criadas
//        Result := RealizeLigacoesByXml(Relacao, lig);
        tmp := MyParserFindNode(lnode, 'SetaDirecao');
        if tmp <> nil then SetaDirecao := tmp.Attributes['Valor'];
        if AutoRelacionado then FAutoRelacao.AdjustSize;
        //AdjustSize;
      end;
    end;
    Result := LoadChildRelLigByXML(Node);
  except
    on Exception do Result := false;
  end;
end;

function TModelo.LoadEntidadeByXML(Node: IXMLNode): boolean;
  var lnode, tmp, auto, lig: IXMLNode;
      i: integer;
begin
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      with TEntidade.Create(Self) do
      begin
        Result := BaseReconfigureByXML(Me, lnode);
        if not Result then Break;
        auto := MyParserFindNode(lnode, 'AutoRelacoes');
        if auto.Attributes['AutoRelacionado'] = true then
        begin
          auto := auto.ChildNodes[0];
          result := AutoRelacionar(auto.Attributes['nome']);
          if not Result then Break;
          lig := MyParserFindNode(auto, 'Ligacoes');
          tmp := lig.ChildNodes[0];
          Result := LigacaoReconfigureByXML(TLigacao(FAutoRelacao.FLigacoes[0]), tmp);
          if not Result then Break;
          tmp := lig.ChildNodes[1];
          Result := LigacaoReconfigureByXML(TLigacao(FAutoRelacao.FLigacoes[1]), tmp);
          if not Result then Break;
          Result := BaseReconfigureByXML(FAutoRelacao, auto);
          if not Result then Break;
        end;
        if AutoRelacionado then FAutoRelacao.AdjustSize;
        //AdjustSize;
      end;
    end;
    Result := LoadEspecializacaoByXML(Node);
  except
    Result := false;
  end;
end;

function TModelo.LoadRelacaoByXML(Node: IXMLNode): boolean;
  var lnode, lig, tmp: IXMLNode;
      i: integer;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      with TRelacao.Create(Self) do
      begin
        Result := BaseReconfigureByXML(Me, lnode);
        if not Result then Break;
        tmp := MyParserFindNode(lnode, 'SetaDirecao');
        if tmp <> nil then SetaDirecao := tmp.Attributes['Valor'];
        lig := MyParserFindNode(lnode, 'Ligacoes');
        Result := RealizeLigacoesByXml(Me, lig);
        //AdjustSize;
      end;
    end;
  except
    Result := false;
  end;
end;

function TModelo.LoadTextoByXML(Node: IXMLNode): boolean;
  var lnode: IXMLNode;
      i: integer;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      with TTexto.Create(Self) do
      begin
        FTamAuto := MyParserFindNode(lnode, 'TamAuto').Attributes['Valor'];
        FCor := MyParserFindNode(lnode, 'Cor').Attributes['Valor'];
        FTipo := MyParserFindNode(lnode, 'Tipo').Attributes['Valor'];
        TextAlin := MyParserFindNode(lnode, 'TextAlin').Attributes['Valor'];
        Result := BaseReconfigureByXML(Me, lnode);
        if not Result then Break;
//        AdjustSize;
      end;
    end;
  except
    Result := false;
  end;
end;

procedure TModelo.ReestrutureColado(Colado: TBase);
begin
  Colado.SetBounds(Colado.Left + 5, Colado.Top + 5, Colado.Width, Colado.Height);
end;

function TModelo.BaseReconfigureByXML(Base: TBase; Node: IXMLNode): Boolean;
  var lnode : IXMLNode;
  ALeft, ATop, AWidth, AHeight: Integer;

  // Inicio TCC II
  iIndice: integer;
  sNome  : string;
  // fim TCC II
begin
  Result := true;
  with Base do
  try
    Atualizando := true;

    // Inicio TCC II
    // Obtem o nome do controle a ser utilizado para colar o objeto. Isso evitará
    // que o objeto seja inserido no modelo com o mesmo nome de outro objeto.
    iIndice := 1;
    sNome := node.Attributes['nome'];
    while (FindByName(sNome) <> nil) do begin
      sNome := node.Attributes['nome'] + '_' + IntToStr(iIndice);
      Inc(iIndice);
    end;  // while (FindByName(sNome)) do
    Nome := sNome;
    // Fim TCC II


    if not Colando then OID := node.Attributes['id'];
    aLeft := MyParserFindNode(node, 'Left').Attributes['Valor'];
    aTop := MyParserFindNode(node, 'Top').Attributes['Valor'];
    aHeight := MyParserFindNode(node, 'Height').Attributes['Valor'];
    aWidth := MyParserFindNode(node, 'Width').Attributes['Valor'];
    SetBounds(ALeft, ATop, AWidth, AHeight);

    //atributos ocultos
    if (TipoDeModelo = tpModeloConceitual) then
    begin
      lnode := MyParserFindNode(node, 'AtributosOcultos');
      if not AOcultos.LoadByXML(lnode) then Result := false
      else begin
        //Atributos...
        lnode := MyParserFindNode(node, 'Atributos');
        Atualizando := false;
        Result := LoadAtributoByXML(Base, lnode);
        Atualizando := true;
      end;
    end;

    if not Result then
    begin
      Erro(nil, 'Falha ao carregar objeto, conteúdo XML inválido para o sistema!', 0);
      exit;
    end;
    //anexos
    //anexos: não será implementado nesta fase. Se mostra inútil e não será excluído do código apenas para um possível proveito futuro
    lnode := MyParserFindNode(node, 'Fonte');
    if not lnode.Attributes['default'] then
    begin
      Font.Name := MyParserFindNode(lnode, 'FonteNome').Attributes['Valor'];
      Canvas.Font.Name := Font.Name;

      Font.Size := MyParserFindNode(lnode, 'FonteTamanho').Attributes['Valor'];
      Canvas.Font.Size := Font.Size;

      SetPropValue(Base.Font, 'Style',
            MyParserFindNode(lnode, 'FonteEstilo').Attributes['Valor']);
      Canvas.Font.Style := Font.Style;

      Font.Color := MyParserFindNode(lnode, 'FonteCor').Attributes['Valor'];
      Canvas.Font.Color := Font.Color;
    end;
    Dicionario := MyParserFindNode(node, 'Dicionario').Text;
    Nula := MyParserFindNode(node, 'Nula').Attributes['Valor'];
    Observacoes := MyParserFindNode(node, 'Observacao').Text;
    FIDs := Max(FIDs, OID);
    if Colando then ReestrutureColado(Me);

    if not Colando then
    begin
      GeraLog('Recriando objeto. Tipo: ' + Denominar(Base.ClassName) + ' Nome: "' + Base.Nome + '"');
    end;

    //03/05/2007
    lnode := MyParserFindNode(node, 'Futuro');
    if (lnode <> nil) and (lnode.NodeValue <> null) then Futuro := MyParserFindNode(node, 'Futuro').NodeValue;

    Atualizando := false;
    DoProgress;
  except
    on exception do
    begin
      Result := false;
      Erro(nil, 'Falha ao carregar objeto, conteúdo XML inválido para o sistema!', 0);
    end;
  end;
end;

procedure TModelo.CMBaseMOVE(var Message: TMessage);
  var b: TBase;
begin
  try
    B := TBase(Message.WParam);
    if Assigned(B) then
      Movimente(B, B.FMovido.Left, B.FMovido.Top, B.FMovido.Right, B.FMovido.Bottom);
  except
  end;
end;

procedure TModelo.CMCardChange(var Message: TMessage);
  var C1, C2: TCardinalidade;
      B: TBase;

begin
  if TipoDeModelo = tpModeloLogico then
  begin
    // que é o liga tab?
    C1 := TCardinalidade(Message.WParam);
    B := C1.Comando.E1;
    if not (B is TLigaTabela) then B := C1.Comando.E2;
    //liga tab = B

    //Quais as cards? C1 é a clicada!
    if TLigacao(B.Ligacoes[0]) = C1.Comando then
      C2 := TLigacao(B.Ligacoes[1]).Card
      else C2 := TLigacao(B.Ligacoes[0]).Card;

    if (C1.Cardinalidade > 2) and (C2.Cardinalidade > 2) then C2.FCardinalidade := C2.FCardinalidade -2;
  end;
end;

function TModelo.LoadAtributoByXML(Pai: TBase; Node: IXMLNode): boolean;
  var lnode, tmp, lig: IXMLNode;
      i: integer;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      with TAtributo(Pai.NovoAtributo(lnode.Attributes['nome'])) do
      begin
        TamAuto := MyParserFindNode(lnode, 'TamAuto').Attributes['Valor'];
        Result := BaseReconfigureByXML(Me, lnode);
        if not Result then Break;
        lig := MyParserFindNode(lnode, 'Ligacoes');
        tmp := lig.ChildNodes[0];
        Result := LigacaoReconfigureByXML(TLigacao(ME.FLigacoes[0]), tmp);
        if not Result then Break;
        Multivalorado := MyParserFindNode(lnode, 'Multivalorado').Attributes['Valor'];

        FMaxCard := MyParserFindNode(lnode, 'MaxCard').Attributes['Valor'];
        FMinCard := MyParserFindNode(lnode, 'MinCard').Attributes['Valor'];

        Identificador := MyParserFindNode(lnode, 'Identificador').Attributes['Valor'];
        TipoDoValor := MyParserFindNode(lnode, 'Tipo').Attributes['Valor'];
        Desvio := MyParserFindNode(lnode, 'Desvio').Attributes['Valor'];
        FOrientacao := MyParserFindNode(lnode, 'Orientacao').Attributes['Valor'];

        //AdjustSize;: Será feito pelo proprietário do atributo.
        tmp := MyParserFindNode(lnode, 'BarraDeAtributos');
        if tmp <> nil then
        begin
          Result := LoadAtributoByXML(Barra, tmp);
        end else
        begin
          Barra.OID := MyParserFindNode(lnode, 'BarraID').Attributes['Valor'];
          FIDs := Max(FIDs, Barra.OID);
        end;
      end;
    end;
  except
    Result := false;
  end;
end;

function TModelo.LigacaoReconfigureByXML(Ligacao: TLigacao; Node: IXMLNode): Boolean;
  var lnode: IXMLNode;
begin
  Result := true;
  with Ligacao do
  try
    Atualizando := true;
    lnode := MyParserFindNode(node, 'MostraCardinalidade');
    if lnode.Attributes['Valor'] then
    begin
      MostraCardinalidade := true;
      lnode := MyParserFindNode(node, 'Cardinalidades');
      lnode := MyParserFindNode(lnode, 'Cardinalidade');
      Result := BaseReconfigureByXML(Fcard, lnode);
      if not Result then Exit;
      FCard.TamAuto := MyParserFindNode(lnode, 'TamAuto').Attributes['Valor'];
      FCard.ToCardinalidade(MyParserFindNode(lnode, 'Card').Attributes['Valor']);
      FCard.Fixa := MyParserFindNode(lnode, 'Fixa').Attributes['Valor'];
      FCard.Atualizando := false;
//      FCard.Invalidate;
    end else
    begin
      if not Colando then
      begin
        FCard.OID := lnode.Attributes['Card_id'];
        FIDs := Max(FIDs, FCard.OID);
      end;
      MostraCardinalidade := False;
    end;
    FOrientacao := MyParserFindNode(node, 'Orientacao').Attributes['Valor'];
    Fraca := MyParserFindNode(node, 'Fraca').Attributes['Valor'];
    Atualizando := false;
  except
    Result := false;
  end;
end;

procedure TModelo.ReadTemplate(Reader: TReader);
begin
  FTemplate.Read(Reader);
end;

function TModelo.RealizeLigacoesByXml(Base: TBase; Node: IXMLNode): Boolean;
  var lnode: IXMLNode;
      i, idBase: integer;
      b: TBase;
      lg: TLigacao;
begin
  Result := true;
  if Colando then Exit;
  Result := false;
  if not ((Base is TBaseRelacao) or (Base is TEspecializacao)) then exit;
  try
    Result := true;
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      if (i = 0) and (Base is TEspecializacao) then
      begin
        lg := TLigacao(base.FLigacoes[0]);  //ligação já criada e ligada
        Result := LigacaoReconfigureByXML(lg, lnode);
        if not Result then Break;
        Continue;
      end;
      idBase := lnode.Attributes['Destino_ID'];
      b := FindByID(idBase);
      if (b = base) then Continue;
      if (Base is TBaseRelacao) then
      begin
        Result := TBaseRelacao(Base).Relacione(TBaseEntidade(B));
      end;
      if (Base is TEspecializacao) then
      begin
        Result := TEspecializacao(Base).Adicione(TEntidade(B));
      end;
      if not Result then
      begin
        Break;
      end;
      lg := TLigacao(base.FLigacoes[base.FLigacoes.Count -1]);  //ultima ligação inserida
      Result := LigacaoReconfigureByXML(lg, lnode);
      if not Result then Break;
    end;
  except
    Result := false;
  end;
end;

function TModelo.LoadChildRelLigByXML(Node: IXMLNode): boolean;
  var lnode, lig: IXMLNode;
      i, entId: integer;
      Rel: TBaseRelacao;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      lnode := MyParserFindNode(lnode, 'ChildRelacao');
      entId := lnode.Attributes['id'];
      Rel := TBaseRelacao(FindByID(entId));
      lig := MyParserFindNode(lnode, 'Ligacoes');
      Result := RealizeLigacoesByXml(Rel, lig);
    end;
  except
    Result := false;
  end;
end;

procedure TModelo.SetScrollPos(const Value: TPoint);
begin
  FScrollPos := Value;
end;

procedure TModelo.DefaultXML;
begin
    DXML.XML.Clear;
    with DXML do
    begin
      XML.Add('<?xml version="1.0" encoding="ISO-8859-1"?>');
      if FJa_XSL <> '' then XML.Add(FJa_XSL);
      XML.Add('<MER>');
      XML.Add('<Informacoes>');
      XML.Add('<Posicao Left="' + IntToStr(FScrollPos.X) + '" Top="' + IntToStr(FScrollPos.Y) + '" />');
      XML.Add('<TotalItens Valor="' + IntToStr(Self.ComponentCount -1) + '" />');
      XML.Add('<Tipo Valor="' + GetStrTipoDeModelo + '" />');
      XML.Add('<Versao Valor="' + VersaoAtual + '"/>');
      XML.Add('<Autor Valor="' + Autor + '"/>');
      XML.Add('<Observacao Valor="' + Observacao + '"/>');
      XML.Add('<Template/>');
      XML.Add('</Informacoes>');

      if (TipoDeModelo = tpModeloConceitual) then
      begin
        //1
        XML.Add('<Entidades>');
        XML.Add('</Entidades>');
        //2
        XML.Add('<Relacoes>');
        XML.Add('</Relacoes>');
        //3
        XML.Add('<EntAssoss>');
        XML.Add('</EntAssoss>');
      end;
      //Lógico
      if (TipoDeModelo = tpModeloLogico) then
      begin
        //1
        XML.Add('<Tabelas>');
        XML.Add('</Tabelas>');
        //2
        XML.Add('<LigacaoEntreTabelas>');
        XML.Add('</LigacaoEntreTabelas>');
      end;
  //4 conceitual 3// lógico
      XML.Add('<Texto>');
      XML.Add('</Texto>');

      XML.Add('</MER>');
      Active := true;
    end;
end;

procedure TModelo.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Template', ReadTemplate, WriteTemplate, Template.ComponentCount > 0);
end;

function TModelo.Colar: Boolean;
  var lastID, i, err: integer;
      B: TBase;
begin
  Result := False;
  lastID := FIDs;
  try
    if Clipboard.HasFormat(CF_TEXT) then
    begin
      DXML.XML.Clear;
      DXML.XML.Text := Clipboard.AsText;
      DXML.Active := true;
      Colando := true;
      Result := LoadFromXML;
      Colando := false;
    end;
  except
    Erro(nil, 'Erro ao copiar os dados da área de transferência!', 0);
    Exit;
  end;
  err := 0;
  if not Result then
  begin
    i := 0;
    while i < ComponentCount -1 do
    begin
      if (Components[i] is TBase) and
         (  (TBase(Components[i]).OID > lastID) and
            (  (Components[i] is TEntidade) or
               (Components[i] is TRelacao) or
               (Components[i] is TEntidadeAssoss) or
               (Components[i] is TTabela) or
               (Components[i] is TTexto)
         )  )
      then begin
        try
          B := TBase(Components[i]);
          FreeAndNil(B);
        except
          inc(err);
        end;
      end else inc(I);
    end;
  end;
  if err > 0 then
    Erro(nil, 'A operação de colar falhou e foram detectados erros na reversão do processo!' + #13 +
              'Sugere-se: Feche o esquema e edite seu código XML.', 1);
end;

procedure TModelo.ConversaoChangeAponta(Antes, Agora: TCampo);
  var i: integer;
begin
  for i := 0 to ComponentCount -1 do
    if (Components[i] is TCampo) and
      (TCampo(Components[i])._CampoKey = Antes) then TCampo(Components[i])._CampoKey := agora;
end;

function TModelo.GetStrTipoDeModelo: string;
begin
  case FTipoDeModelo of
    tpModeloConceitual: Result := tpStrModeloConceitual;
    tpModeloLogico: Result := tpStrModeloLogico;
    tpModeloFisico: Result := tpStrModeloFisico;
    tpModeloNormatizado: Result := tpStrModeloNormatizado;
    else Result := '';
  end;
end;

function TModelo.GetTotalSelecionado: integer;
begin
  Result := FMultSelecao.Count + IfThen(Selecionado <> nil, 1, 0);
end;

function TModelo.PodeColar: Boolean;
begin
  Result := Clipboard.HasFormat(CF_TEXT);
end;

procedure TModelo.DoProgress;
begin
  LoadProgress.X := ComponentCount -1;
  Fp100 := MulDiv(LoadProgress.X, 100, LoadProgress.Y);
  if Assigned(FOnLoadProgress) then FOnLoadProgress(Fp100);
end;

procedure TModelo.SetOnLoadProgress(const Value: TModeloOnLoadProgress);
begin
  FOnLoadProgress := Value;
end;

// Início TCC II - Puc (MG) - Daive Simões
// retirei o caracter "_" que separa o nome do componente do seu número
function TModelo.GeraBaseNome(pre: string): String;
  var i: integer;
      nomes: TStringList;
begin
  // Result := pre + '_1';
  Result := pre + '1';
  nomes := TStringList.Create;
  try
    for i := 0 to ComponentCount -1 do
      if Components[i] is TBase then nomes.Add(TBase(Components[i]).Nome);
    if nomes.Count = 0 then
    begin
      nomes.Free;
      exit;
    end;
    i := 1;
    //while nomes.IndexOf(pre + '_' + IntToStr(i)) <> -1 do inc(i);
    //  Result := pre + '_' + IntToStr(i);

    while nomes.IndexOf(pre + IntToStr(i)) <> -1 do inc(i);
      Result := pre + IntToStr(i);

  finally
    nomes.Free;
  end;
end;
// Fim TCC II

function TModelo.DeleteSelection: Boolean;
  var i: integer;
begin
  Result := false;
  if (Selecionado = nil) and (FMultSelecao.Count = 0) then exit;
  Result := True;
  try
    if Assigned(Selecionado) then
    begin
      ProcesseBaseClick(Selecionado, Tool_Del);
    end;
    i := 0;
    while i < FMultSelecao.Count do
    begin
      if Assigned(FMultSelecao[i]) then
      begin
        ProcesseBaseClick(TBase(FMultSelecao[i]), Tool_Del);
      end else inc(i);
    end;
  except
    Erro(nil, 'Não foi possível concluir a exclusão!', 1);
    Result := false;
  end;
end;

function TModelo.GetIntTipoDeModelo(tipoStr: string): integer;
begin
  Result := 0;
  if tipoStr = tpStrModeloConceitual then Result := tpModeloConceitual;
  if tipoStr = tpStrModeloLogico then Result := tpModeloLogico;
  if tipoStr = tpStrModeloNormatizado then Result := tpModeloNormatizado;
  if tipoStr = tpStrModeloFisico then Result := tpModeloFisico;
end;

procedure TModelo.GetItens(lLista: TGeralList; noCard: boolean);
  var i, j: Integer;
      B: TBase;
      C: TCampo;
begin
  lLista.Lista.Clear;
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TBase then
    begin
      if ((Components[i] is TCardinalidade) and noCard) or (Components[i] is TBarraDeAtributos) then Continue;
      B := TBase(Components[i]);
      if B is TChildRelacao then Continue;
      J := -1;
      if (B is TEntidade) then J := 4 else
      if (B is TAtributo) then J := 0 else
      if (B is TRelacao) then J := 8 else
      if (B is TEntidadeAssoss) then J := 7 else
      if (B is TAutoRelacao) then J := 1 else
      if (B is TEspecializacao) then J := 5 else
      if (B is TTexto) then J := 9;
      if (B is TTabela) then J := 21;
      if (B is TLigaTabela) then J := 22;
      if B is TCampo then
      begin
        C := TCampo(B);
        if C.ApenasSeparador then Continue;
        if C.IsKey then J := 20
          else
            if C.IsFKey then J := 24
              else
                J := 23;
      end;
      lLista.Add(B.Nome, J, B.OID, B);
    end;
  end;
  lLista.Ordene;
end;

function TModelo.LoadLigacaoByXML(Node: IXMLNode): boolean;
  var lnode, lig: IXMLNode;
      i: integer;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      FConversao_LastLigaTab := TLigaTabela.Create(Self);
      with FConversao_LastLigaTab do
      begin
        Result := BaseReconfigureByXML(Me, lnode);
        if not Result then Break;
        lig := MyParserFindNode(lnode, 'Ligacoes');
        Result := RealizeLigacoesByXml(Me, lig);
        //AdjustSize;
      end;
    end;
  except
    Result := false;
  end;
end;

function TModelo.LoadTabelaByXML(Node: IXMLNode): boolean;
  var lnode, onode: IXMLNode;
      i: integer;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      with TTabela.Create(Self) do
      begin
        Result := BaseReconfigureByXML(Me, lnode);
        if not Result then Break;
        Color := MyParserFindNode(lnode, 'Color').Attributes['Valor'];
        onode := MyParserFindNode(lnode, 'Complemento');
        if (Assigned(ONode)) then //novo modelo - versão atual
        begin
           Complemento := ONode.Attributes['Valor'];
           FcOrdem := MyParserFindNode(lnode, 'cOrdem').Attributes['Valor'];
        end;
        Result := LoadCampoByXML(Me, MyParserFindNode(lnode, 'Campos'));
        //AdjustSize;
      end;
    end;
  except
    Result := false;
  end;
end;

function TModelo.LoadCampoByXML(Pai: Tbase; Node: IXMLNode): boolean;
  var lnode, ONode: IXMLNode;
      i: integer;
begin
  Result := true;
  try
    for i := 0 to Node.ChildNodes.Count -1 do
    begin
      lnode := Node.ChildNodes[i];
      with TCampo.Create(Self) do
      begin
        FNome := lnode.Attributes['nome'];
        if not Colando then Me.FOID := lnode.Attributes['id'];
        FIDs := Max(FIDs, Me.OID);
        FApenasSeparador := StrToBool(MyParserFindNode(lnode, 'ApenasSeparador').Attributes['Valor']);
        onode := MyParserFindNode(lnode, 'Fonte');
        if (Assigned(ONode)) and  not onode.Attributes['default'] then
        begin
          Font.Name := MyParserFindNode(onode, 'FonteNome').Attributes['Valor'];
          Canvas.Font.Name := Font.Name;
          Font.Size := MyParserFindNode(onode, 'FonteTamanho').Attributes['Valor'];
          Canvas.Font.Size := Font.Size;
          SetPropValue(Me.Font, 'Style',
                MyParserFindNode(onode, 'FonteEstilo').Attributes['Valor']);
          Canvas.Font.Style := Font.Style;
          Font.Color := MyParserFindNode(onode, 'FonteCor').Attributes['Valor'];
          Canvas.Font.Color := Font.Color;
        end;
        if not ApenasSeparador then
        begin
          FIsKey := MyParserFindNode(lnode, 'IsKey').Attributes['Valor'];
          FIsFKey := MyParserFindNode(lnode, 'IsFKey').Attributes['Valor'];
          Tipo := MyParserFindNode(lnode, 'Tipo').Attributes['Valor'];
          ValorInicialFKTabOrigem := MyParserFindNode(lnode, 'TabOrigem').Attributes['Valor'];
          ONode := MyParserFindNode(lnode, 'CampoOrigem');
          if Assigned(ONode) then ValorInicialFKCampoOrigem := ONode.Attributes['Valor'];
        end else
        begin
          ApenasSeparador := True;
          FNome := lnode.Attributes['nome'];
        end;
        //03/05/2007
        onode := MyParserFindNode(lnode, 'Complemento');
        if (Assigned(ONode)) then //versão atual do modelo.
        begin
          FComplemento := ONode.Attributes['Valor'];
          FddlOnUpdate := MyParserFindNode(lnode, 'OnUpdate').Attributes['Valor'];
          FddlOnDelete := MyParserFindNode(lnode, 'OnDelete').Attributes['Valor'];
        end;
        //end.
        TTabela(Pai).AddCampo(TCampo(Me));
      end;
    end;
  except
    Result := false;
  end;
end;

Function TModelo.TransformTo(novoTipo: integer): boolean;
begin
  Result := false;
  if (FTipoDeModelo = novoTipo) or (QtdBase <> 0) then exit;
  FTipoDeModelo := novoTipo;
  FNome := TVisual(Owner).GeraNome(novoTipo);
  Result := true;
end;

procedure TModelo.WriteTemplate(Writer: TWriter);
begin
  FTemplate.Write(Writer);
end;

function TModelo.ExportarParaLogico(oModelo: TModelo): Boolean;
begin
  Result := true;
  NoChangeCursor := true;
  Screen.Cursor := crHourGlass;
  naoAvisado := false;
  GeraLog('Iniciando exportação...', false, True);
  try
    if (not ExportarEntidades(oModelo))
    or (not ExportarAtributos(oModelo))
    or (not ExportarAutoRelacionamento(oModelo))
    or (not ExportarEspecializacoes(oModelo))
    or (not ExportarEntidadesHerancaMultipla(oModelo))
    or (not ExportarRelacoes(oModelo))
    or (not ExportarEntAss(oModelo))
    or (not ExportarTextos(oModelo))
    or (not ExportarLimparLixo(oModelo))
    then
    begin
      onErro(nil, 'Operação finalizada pelo usuário!', 1);
    end;
  except
    onErro(nil, 'Erro no processo de conversão.'+#13+'Operação finalizada pelo sistema!', 0);
  end;
  GeraLog('Exportação finalizada', False, True);
  Screen.Cursor := crDefault;
  NoChangeCursor := false;
  YesToAll := false;
end;

function TModelo.ExportarEntidades(oModelo: TModelo): boolean;
  var i: Integer;
      E: TBaseEntidade;
      T: TTabela;
begin
  Result := true;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TBaseEntidade then
  begin
    E := TBaseEntidade(Components[i]);
    GeraLog('Exportando entidade "' + E.Nome + '"');
    oModelo.Ferramenta := Tool_LOGICO_Tabela;
    oModelo.Clicado := Point(E.Left, E.Top);
    T := TTabela(oModelo.Add);
    T.Nome := E.Nome;
    //T.Dicionario := E.Dicionario;
    T.associacao := E;
    E.associacao := T;
  end;
  oModelo.Ferramenta := Tool_Nothing;
end;

procedure TModelo.Questione(TextoA: string; topico_ajuda: integer;
  var ResultadoSugestao: Integer);
  var i, pre, j: integer;
begin
  if Assigned(FonQuestao) then
  begin
    if not YesToAll then
    begin
      i := Questoes.Add('Deste ponto em diante aceitar todas as sugestões.');
      for j := 0 to Questoes.Count -1 do
      begin
        if j > 26 then Break;
        Questoes[j] := char(65 + j) + ') - ' + Questoes[j];
      end;
      pre := ResultadoSugestao;
      FonQuestao(TextoA, Questoes.Text, topico_ajuda, ResultadoSugestao);
      if ResultadoSugestao = i then
      begin
        ResultadoSugestao := pre;
        YesToAll := true;
      end;
    end;
  end
  else ResultadoSugestao := -1;
end;

procedure TModelo.SetonQuestao(const Value: TModeloOnQuestion);
begin
  FonQuestao := Value;
end;

function TModelo.ExportarEspecializacoes(oModelo: TModelo): boolean;
  var i, j, l: Integer;
      E: TEspecializacao;
      T, TabelaP: TTabela;
      Desc: string;
      opc, Lopc: integer;
      C, NC: TCampo;
      Li: TLigacao;
      LigaTab: TLigaTabela;
      Ent: TEntidade;
      lnoToAll, lyesToAll: boolean;
begin
  Result := true;
  lyesToAll := false;
  lnoToAll := false;
//oredenar as especializações.........................

  ListaDeTrabalho.Clear;
  L := 0;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TEspecializacao then
  begin
    inc(L);
    E := TEspecializacao(Components[i]);
    E.Usr_Conv_Opc := -1;
    if (E.EntidadeBase.Origem = nil) then ListaDeTrabalho.Add(E);
  end;

  if (L > 0) and (ListaDeTrabalho.Count = 0) then
  begin
    Erro(nil, 'Referência circular na especialização/generalização de entidades!' + #13 +
         'Clique em OK para finalizar a conversão.', 1);
    Result := false;
    exit;
  end;

  for i := 0 to ListaDeTrabalho.Count -1 do
  begin
    E := TEspecializacao(ListaDeTrabalho[i]);
    E.getChilds(ListaDeTrabalho);
  end;

  for i := 0 to ListaDeTrabalho.Count -1 do
  begin
    E := TEspecializacao(ListaDeTrabalho[i]);
    Questoes.Clear;
    Questoes.Add('Uso de uma tabela para cada entidade');
    Questoes.Add('Uso de uma única tabela para toda hierarquia');
    if not E.Parcial then
      Questoes.Add('Uso de tabela apenas para entidade(s) especializada(s)');

    if E.FLigacoes.Count < 2 then Continue;
    GeraLog('Exportando especialização/generalização "' + E.Nome + '"');

    Desc := 'Especialização ' + '"' + E.Nome + '" ' + IfThen(E.Parcial, 'parcial', 'total') + ' e ' +
    IfThen(E.Restrito, 'exclusiva', 'opcional') + ' encontrada!' + #13 +
    'Partido de "' + E.EntidadeBase.Nome + '"' + #13 +
    'Observação: ' + IfThen(E.Observacoes <> '', E.Observacoes, '[Não há observações]');

    opc := IfThen(E.Parcial , 0, 1);
    TabelaP := TTabela(E.EntidadeBase.associacao);

//    if (TabelaP.Pre_opc <> -1) then
//      opc := TabelaP.Pre_opc
//    else
    Questione(Desc, aj_Especializacao, opc);
    if opc = 2 then
    begin
      if E.EntidadeBase.ehHerancaMultipla then
      begin
        Erro(nil, 'A tabela "' + TabelaP.Nome + '" possui herança múltipla e, por isso, não será excluída!', 1);
        opc := -1;
      end else
      for j := 0 to E.EntidadeBase.FLigacoes.Count -1 do
      begin
        if TLigacao(E.EntidadeBase.FLigacoes[j]).Pai is TMaxRelacao then
        begin
          Erro(nil, 'A tabela "' + TabelaP.Nome + '" possui pelo menos um relacionamento e' + #13 +
                    'Não poderá ser excluída.', 1);
          opc := -1;
          break;
        end;
      end;
      if opc = -1 then
      begin
        Questoes.Clear;
        Questoes.Add('Uso de uma tabela para cada entidade');
        Questoes.Add('Uso de uma única tabela para toda hierarquia');
        Desc := '[Refazer]: ' + Desc;
        opc := IfThen(E.Parcial , 0, 1);
        Questione(Desc, aj_Especializacao, opc);
      end;
    end;

    if (opc = -1) then
    begin
      Result := false;
      Break;
    end;
    E.Usr_Conv_Opc := opc;

    //A) - Uso de uma tabela para cada entidade
    if (opc = 0) then
    begin
      //pegar todas as tabelas da especialização exceto a principal (Entidade base)
      TabelaP.Interferencia := TabelaP.Interferencia + 1;
      for j := 1 to E.FLigacoes.Count -1 do
      begin
        Ent := TEntidade(TLigacao(E.FLigacoes[j]).Ponta);

        //se tem multiplas origens então já foi processado com uma tabela única
        if Ent.ehHerancaMultipla then Continue;

        T := TTabela(Ent.associacao);
        //A tabela não tem campos, então, deve ser excluída conf. pg 108.
        if (T.Campos.Count = 0) then
        begin
          Lopc := IfThen(lyesToAll, 3, 0);
          if (Lopc = 0) then Lopc := IfThen(lnoToAll, 2, 0);
          if (Lopc = 0) then
          begin
            Questoes.Clear;
            Questoes.Add('NÃO gerar tabela para a entidade (Heuser)');
            Questoes.Add('Gerar tabela para a entidade');
            Questoes.Add('NÃO gerar tabela para nenhuma entidade nestas condições (Heuser)');
            Questoes.Add('Gerar tabela para todas as entidade nestas condições');

            Desc := 'Entidade "' + Ent.Nome + '" especializada de ' + '"' + E.Nome + #13 +
            '" (Tipo: ' + IfThen(E.Parcial, 'parcial', 'total') + ' e ' +
            IfThen(E.Restrito, 'exclusiva', 'opcional') + ') não possui atributos!' + #13 +
            'Observação: ' + IfThen(Ent.Observacoes <> '', Ent.Observacoes, '[Não há observações]');
            Questione(Desc, aj_Especializacao, Lopc);
            if (Lopc = -1) then
            begin
              //cancelou: então sai.
              Result := false;
              exit;
            end;
            lyesToAll := (Lopc = 3);
            lnoToAll := (Lopc = 2);
          end;

          if (Lopc = 0) or (Lopc = 2) then
          begin
            //pegar os relacionamentos
            T.FLigacoes.OwnsObjects := false;
            while T.FLigacoes.Count > 0 do
            begin
              Li := TLigacao(T.FLigacoes[0]);
              T.FLigacoes.Remove(Li);
              TabelaP.Liga(Li);
              Li.Generate(Li.Pai, TabelaP);
            end;

            T.associacao.associacao := TabelaP;
            FreeAndNil(T);
            Continue;
          end;
        end;

        //para cada tabela, adicionar os campos chaves da tabela principal
        for L := 0 to TabelaP.Campos.Count -1 do
        begin
          C := TCampo(TabelaP.Campos[L]);
          if C.IsKey and (not C.UnMonved) then
          begin
            NC := T.ImportarCampo(C);
            NC._CampoKey := C;
            //05/11/2006
            //não mexer!
            NC.FIsKey := false;
            NC.FIsFKey := true;
            //? não sei porque desabilitei, deveria estar habilitado.
            // NC.FTabOri := TabelaP;
          end;
        end;

        //ligar as tabelas à tabela principal se a tabela principal for ser mantida
        //sempre a cardinalidade em relação a TabelaP é (0,n)
        oModelo.Ferramenta := Tool_LOGICO_Relacao;
        oModelo.UsrSelA := TabelaP;
        oModelo.BaseClick(T);
        //LigaTab := TLigaTabela(oModelo.FindByID(oModelo.FIDs -2));
        LigaTab := oModelo.FConversao_LastLigaTab;
        LigaTab.Former := TabelaP.OID;
        LigaTab.SetCard(1, 4);
//        TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := 4;
//        TLigacao(LigaTab.FLigacoes[0]).FCard.Cardinalidade := 1;
        oModelo.Ferramenta := Tool_Nothing;
      end;

    end
    else
    //B) - Uso de uma unica tabela para toda hierarquia
    if opc = 1 then
    begin
      //pegar todas as tabelas da especialização exceto a principal (Entidade base)
      TabelaP.Interferencia := TabelaP.Interferencia + 1;
      for j := 1 to E.FLigacoes.Count -1 do
      begin
        Ent := TEntidade(TLigacao(E.FLigacoes[j]).Ponta);

        //se tem multiplas origens então já foi processado e não será excluída
        if Ent.ehHerancaMultipla then
        begin
          Erro(nil, 'Herança múltipla encontrada!' + #13 + 'não será possível a mesclagem em uma única tabela.', 1);
          Continue;
        end;
        T := TTabela(Ent.associacao);

        //pegar os relacionamentos
        T.FLigacoes.OwnsObjects := false;
        while T.FLigacoes.Count > 0 do
        begin
          Li := TLigacao(T.FLigacoes[0]);
          T.FLigacoes.Remove(Li);
          TabelaP.Liga(Li);
          Li.Generate(Li.Pai, TabelaP);
        end;

        //pegar todos os campos da tabela e adicionar na tabela principal
        for L := 0 to T.Campos.Count -1 do
        begin
          C := TCampo(T.Campos[L]);
          NC := TabelaP.ImportarCampo(C);
          oModelo.ConversaoChangeAponta(C, NC);
          NC.UnMonved := true;
        end;

        // Inicio TCC II
        // Correção do problema de se conectar as duas tabelas com o sinal de '+'
        TabelaP.Nome := TabelaP.Nome + '_' + T.Nome;
        // Fim Inicio TCC II

        T.associacao.associacao := TabelaP;
        FreeAndNil(T);
      end;
    end else
    //C) Uso de tabela apenas para entidade(s) especializada(s)
    if (opc = 2) then
    begin
      //se for parcial não excluir.
      if E.Parcial then
        TabelaP.Interferencia := TabelaP.Interferencia + 1;
      for j := 1 to E.FLigacoes.Count -1 do
      begin
        Ent := TEntidade(TLigacao(E.FLigacoes[j]).Ponta);
        T := TTabela(Ent.associacao);
        //importar todos os campos da tabela principal.
        for L := 0 to TabelaP.Campos.Count -1 do
        begin
          C := TCampo(TabelaP.Campos[L]);
          if not C.UnMonved then
          begin
            NC := T.ImportarCampo(C);
//ver no futuro
            oModelo.ConversaoChangeAponta(C, NC);
          end;
        end;
      end;
      TabelaP.Excluir := true;
    end;
  end;
  ListaDeTrabalho.Clear;
end;

function TModelo.MegaExportarAtributos(oModelo: TModelo; E: TBase;
  T: TTabela): boolean;
  var j, L, tmpCard: Integer;
      NovaT: TTabela;
      A: TAtributo;
      AO: TAtributoOculto;
      Desc: string;
      opc: integer;
      LigaTab: TLigaTabela;

      // Início TCC II - Puc (MG) - Daive Simões
      iIndex: integer;
      sNome : string;
      // Fim TCC II

  // Início TCC II - Puc (MG) - Daive Simões
  // função que recupera o nome do campo a ser utilizado para criar o novo
  // campo na tabela
  function ObterNomeCampo(nomeAtributo: string; aT: TTabela): string;
  var iIndex: integer;
  begin
    // inicializa o retorno da função
    Result := nomeAtributo;

    // se o campo já existir na tabela, procurar por um próximo nome que não
    // exista ainda
    if (aT.jaExisteCampo(nomeAtributo)) then begin
      // inicializa o índice para atribuição ao nome do campo
      iIndex := 1;
      Result := nomeAtributo + IntToStr(iIndex);
      while (aT.jaExisteCampo(Result)) do begin
        Inc(iIndex);
        Result := nomeAtributo + IntToStr(iIndex);
      end;  // while (aT.jaExisteCampo(sNome)) do
    end;  // if (not aT.jaExisteCampo(oA.Nome)) then
  end;

  // procedimento responsável por criar um campo de chave primária na tabela
  // passada como parâmetro
  procedure CriarCampoPK(tabela: TTabela);
  var n: integer;
  begin
    with TCampo.Create(oModelo) do begin
      Nome        := ObterNomeCampo(Trim(tabela.Nome) + '_PK', tabela);
      Tipo        := 'INTEGER';
      Precisao    := EmptyStr;
      FIsKey      := True;
      FIsFKey     := False;
      Observacoes := EmptyStr;
      Dicionario  := EmptyStr;
      tabela.AddCampo(TCampo(Me));
      associacao  := tabela;
    end;  // with TCampo.Create(oModelo) do
  end;  // procedure CriarCampoPK

  // obtém o campo chave primária de uma tabela passada como parâmetro
  function ObterCampoPK(tabela: TTabela): TCampo;
  var campo : TCampo;
      iIndex: integer;
  begin
    // inicializa o retorno da função
    Result := nil;

    // se a tabela não existir, nada deve ser feito
    if (not Assigned(tabela)) then Exit;

    // itera pela lista de campos da tabela, procurando pela chave primária
    for iIndex := 0 to Pred(tabela.Campos.Count) do begin
      // obtém o campo corrente
      campo := TCampo(tabela.Campos[iIndex]);

      // encontrou a chave primária. Retornar o nome deste campo e interromper
      // o loop
      if (campo.IsKey) then begin
        Result := campo;
        Break;
      end;  // if (campo.IsKey) then
    end;  // for iIndex := 0 to Pred(tabela.Campos.Count) do begin
  end;  // function CampoPK

  // procedimento responsável por criar um campo de chave estrangeira na tabela
  // passada como parâmetro
  procedure CriarCampoFK(tabelaPai, tabela: TTabela);
  var campoPK: TCampo;
  begin
    // retorna o nome do campo chave primária da tabela
    campoPK := ObterCampoPK(tabelaPai);

    with TCampo.Create(oModelo) do begin
      Nome          := ObterNomeCampo(Trim(campoPK.Nome) + '_FK', tabela);
      Tipo          := campoPK.Tipo;
      Precisao      := EmptyStr;
      FIsKey        := False;
      FIsFKey       := True;
      Observacoes   := EmptyStr;
      Dicionario    := EmptyStr;
      tabela.AddCampo(TCampo(Me));
      associacao    := tabela;
      TabOrigem     := tabelaPai.OID;
      CampoOrigem   := campoPK.OID;
    end;  // with TCampo.Create(oModelo) do
  end;  // procedure CriarCampoPK
  // Fim TCC II

  procedure CriarCampoByAtributo(oA: TAtributo; aT: TTabela);overload;
    var n    : integer;
  begin
    for n:= 0 to at.Campos.Count -1 do
    begin
      if TCampo(at.Campos[n]).associacao = oA then exit;
    end;

    with TCampo.Create(oModelo) do begin
      // Início TCC II - Puc (MG) - Daive Simões
      // atribui o nome encontrado ao campo da tabela
      Nome     := ObterNomeCampo(oA.Nome, aT);
      Tipo     := oA.TipoDoValor;
      Precisao := oA.Complemento;
      // Fim TCC II

      FIsKey := oA.Identificador;
      FIsFKey := False;
      Observacoes := oA.Observacoes;
      Dicionario := oA.Dicionario;
      aT.AddCampo(TCampo(Me));
      associacao := aT;
    end;
  end;

  procedure CriarCampoByAtributo(oA: TAtributoOculto; aT: TTabela);overload;
    var n: integer;
  begin
    for n:= 0 to at.Campos.Count -1 do
    begin
      if TCampo(at.Campos[n]).AOAss = oA then exit;
    end;
    with TCampo.Create(oModelo) do
    begin
      // Início TCC II - Puc (MG) - Daive Simões
      // atribui o nome encontrado ao campo da tabela
      Nome := ObterNomeCampo(oA.Nome, aT);
      // Fim TCC II

      FIsKey := oA.Identificador;
      FIsFKey := False;
      Tipo := oA.Tipo;
      aT.AddCampo(TCampo(Me));
      AOAss := oA;
    end;
  end;
var criou: boolean;
    campoCriado: TCampo;
    tabelaCriada: TTabela;
begin
  Result := true;
  A := nil;//apenas para o compilador parar de encher o saco!
  if t.FCampos.Count > 99 then
  begin
    onErro(nil, 'Quantidade de campos ultrapassa o limite máximo para conversão.' + #13 +
                'Total de campos na tabela "' + T.Nome +' ": ' + IntToStr(T.FCampos.Count) + '.' + #13 +
                'A busca por novos campos será suspensa pelo sistema!', 0);
    Exit;
  end;

  criou := false;
  if E.Atributos.Count > 0 then GeraLog('Exportando atributos da entidade "' + E.Nome + '"');
  for j := 0 to E.Atributos.Count -1 do
  begin
    A := TAtributo(E.Atributos[j]);
    GeraLog('Exportando atributo "' + A.Nome + '"');
    ListaDeTrabalho.Clear;
    opc := 1;
    if ((A.Multivalorado) or (A.Composto)) and not ((A.Multivalorado) and (A.MaxCard = 1) and not A.Composto) then
    begin
      Desc := 'Atributo composto' + IfThen(A.Multivalorado, ' e multivalorado', '') + ' encontrado ' + #13 +
      'Atributo: ' + A.Nome + '. Entidade/Relação: ' + E.Nome + #13 +
      'Observação: ' + IfThen(A.Observacoes <> '', A.Observacoes, '[Não há observações]');
      opc := IfThen(A.MaxCard > 1, 0, 1);;
      Questoes.Clear;
      Questoes.Add('Criar uma tabela para acomodar os atributos');
      Questoes.Add('Incluir os atributos como campos na tabela "' + T.Nome + '"');
      Questione(Desc, aj_nothing, opc);
      if (opc = -1) then
      begin
        Result := false;
        exit;
      end;
      A.IgnoreMult := (opc = 0);
      A.getChilds(ListaDeTrabalho);
      if ListaDeTrabalho.Count > 50 then
      begin
        onErro(nil, 'Quantidade de atributos ultrapassa o limite máximo para conversão.' + #13 +
                'Total já calculado: ' + IntToStr(ListaDeTrabalho.Count) + '.' + #13 +
                'Busca por atributos referentes a "' + A.Nome + '" cancelada pelo sistema!', 0);
        ListaDeTrabalho.Clear;
        ListaDeTrabalho.Add(A);
      end;
    end else
    begin
      ListaDeTrabalho.Add(A);
      if A.Opcional then
      begin
        Desc := 'O atributo encontrado é opcional.' + #13 +
        'Atributo: ' + A.Nome + '. Entidade/Relação: ' + E.Nome + #13 +
        'Observação: ' + IfThen(A.Observacoes <> '', A.Observacoes, '[Não há observações]');
        Questoes.Clear;
        Questoes.Add('Criar uma tabela para acomodar o atributo');
        Questoes.Add('Incluir os atributos como campos na futura tabela "' + T.Nome + '"');
        Questione(Desc, aj_nothing, opc);
      end;
    end;
    if opc = 0 then
    begin
      oModelo.Ferramenta := Tool_LOGICO_Tabela;
      oModelo.Clicado := Point(A.Left + 50, A.Top);
      NovaT := TTabela(oModelo.Add);
      NovaT.Nome := A.Nome;
      NovaT.Reenquadre;
      NovaT.associacao := A;
      A.associacao := NovaT;

      oModelo.Ferramenta := Tool_LOGICO_Relacao;
      oModelo.UsrSelA := T;
      oModelo.BaseClick(NovaT);
      //LigaTab := TLigaTabela(oModelo.FindByID(oModelo.FIDs -2));
      LigaTab := oModelo.FConversao_LastLigaTab;
//      if A.Multivalorado then
//        TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := A.ConvCard
//          else TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := 1;
//      TLigacao(LigaTab.FLigacoes[0]).FCard.Cardinalidade := 1;
      if A.Multivalorado then tmpCard := A.ConvCard else tmpCard := 1;
      LigaTab.SetCard(1, tmpCard);

      oModelo.Ferramenta := Tool_Nothing;

      // Inicio TCC II
      // É atributo e criando uma nova tabela para colocar os campos
      if (A.Multivalorado or A.Composto) and (opc = 0) and (ListaDeTrabalho.Count > 0) then
        CriarCampoPK(NovaT);

      // armazena a tabela que acabou de ser criada se sinaliza essa criação
      tabelaCriada := NovaT;
      criou        := true;
      // Fim TCC II
    end else NovaT := T;

    for L:= 0 to ListaDeTrabalho.Count -1 do
    begin
      if (TObject(ListaDeTrabalho[L]) is TAtributo) then
        CriarCampoByAtributo(TAtributo(ListaDeTrabalho[L]), NovaT)
      else
        CriarCampoByAtributo(TAtributoOculto(ListaDeTrabalho[L]), NovaT);
    end;
  end;

  // Inicio TCC II
  // Cria o campo de chave secundária na nova tabela criada para abrigar os
  // campos multivalorados
  if (criou) then
    CriarCampoFK(T, tabelaCriada);
  // Fim TCC II

  if E.AOcultos.AtributosOcultos.Count > 0 then GeraLog('Exportando atributos ocultos da entidade "' + E.Nome + '"');
  for j := 0 to E.AOcultos.AtributosOcultos.Count -1 do
  begin
    AO := TAtributoOculto(E.AOcultos.AtributosOculto[j]);
    GeraLog('Exportando atributo oculto "' + Ao.Nome + '"');
    ListaDeTrabalho.Clear;
    opc := 1;
    if ((Ao.Multivalorado) or (Ao.Composto)) and not ((Ao.Multivalorado) and (Ao.MaxCard = 1) and not Ao.Composto) then
    begin
      Desc := 'Atributo oculto composto' + IfThen(AO.Multivalorado, ' e multivalorado', '') + ' encontrado ' + #13 +
      'Atributo: ' + Ao.Nome + '. Entidade/Relação: ' + E.Nome + #13 +
      'Observação: Atributo oculto';
      opc := IfThen(AO.Multivalorado, 0, 1);
      Questoes.Clear;
      Questoes.Add('Criar uma tabela para acomodar os atributos ocultos');
      Questoes.Add('Incluir todos os atributos como campos na tabela "' + T.Nome + '"');
      Questione(Desc, aj_nothing, opc);
      if (opc = -1) then
      begin
        Result := false;
        exit;
      end;
      AO.IgnoreMult := (opc = 0);
      AO.getChilds(ListaDeTrabalho);
      if ListaDeTrabalho.Count > 50 then
      begin
        onErro(nil, 'Quantidade de atributos ultrapassa o limite máximo para conversão.' + #13 +
                'Total já calculado: ' + IntToStr(ListaDeTrabalho.Count) + '.' + #13 +
                'Busca por atributos referentes a "' + Ao.Nome + '" cancelada pelo sistema!', 0);
        ListaDeTrabalho.Clear;
        ListaDeTrabalho.Add(AO);
      end;
    end else
    begin
      ListaDeTrabalho.Add(Ao);
      if (Ao.MinCard = 0) then
      begin
        Desc := 'O atributo encontrado é opcional.' + #13 +
        'Atributo: ' + Ao.Nome + '. Entidade/Relação: ' + E.Nome + #13 +
        'Observação: Atributo oculto';
        Questoes.Clear;
        Questoes.Add('Criar uma tabela para acomodar o atributo');
        Questoes.Add('Incluir os atributos como campos na futura tabela "' + T.Nome + '"');
        Questione(Desc, aj_nothing, opc);
      end;
    end;
    if opc = 0 then
    begin
      oModelo.Ferramenta := Tool_LOGICO_Tabela;
      oModelo.Clicado := Point(E.Left + E.Width + 50, E.Top);
      NovaT := TTabela(oModelo.Add);
      NovaT.Nome := Ao.Nome;
      NovaT.Reenquadre;
      oModelo.Ferramenta := Tool_LOGICO_Relacao;
      oModelo.UsrSelA := T;
      oModelo.BaseClick(NovaT);
//      LigaTab := TLigaTabela(oModelo.FindByID(oModelo.FIDs -2));
      LigaTab := oModelo.FConversao_LastLigaTab;
//      if Ao.Multivalorado then
//        TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := Ao.ConvCard
//          else TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := 1;
//      TLigacao(LigaTab.FLigacoes[0]).FCard.Cardinalidade := 1;

      if A.Multivalorado then tmpCard := A.ConvCard else tmpCard := 1;
      LigaTab.SetCard(1, tmpCard);

      oModelo.Ferramenta := Tool_Nothing;
      NovaT.Reenquadre;
    end else NovaT := T;
    for L:= 0 to ListaDeTrabalho.Count -1 do
    begin
      CriarCampoByAtributo(TAtributoOculto(ListaDeTrabalho[L]), NovaT);
    end;
  end;
end;

procedure TModelo.SetListaDeTrabalho(const Value: TList);
begin
  FListaDeTrabalho := Value;
end;

function TModelo.ExportarTextos(oModelo: TModelo): boolean;
  var i, j: Integer;
      ori, dest: TTexto;
begin
  Result := true;
  GeraLog('Exportando textos...');
  J := 0;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TTexto then
  begin
    ori := TTexto(Components[i]);
    dest := TTexto.Create(oModelo);
    dest.Cor := ori.Cor;
    dest.Tipo := ori.Tipo;
    dest.TextAlin := ori.TextAlin;
    dest.Observacoes := ori.Observacoes;
    dest.Nome := ori.Nome;
    dest.SetBounds(ori.left, ori.top, ori.width, ori.Height);
    inc(j);
  end;
  GeraLog('Textos exportados: ' + IntToStr(j));
end;

function TModelo.ExportarRelacoes(oModelo: TModelo): boolean;
  var i, j, L,tmp, MaxCard, opc, M: Integer;
      R: TMaxRelacao;
      Tab1, Tab2, ATab: TTabela;
      lLista: TComponentList;
      E_tmp, E_tmp2: TBaseEntidade;
      Fusao, TabProp, AdCol, noadd, todos_cad1: boolean;
      desc: string;
      C, NC: TCampo;
      Li: TLigacao;

  Procedure Rela(t1, t2: TTabela; card1, card2: integer);
  var LigaTab: TLigaTabela;
  begin
    oModelo.Ferramenta := Tool_LOGICO_Relacao;
    oModelo.UsrSelA := T1;
    oModelo.BaseClick(T2);
//    LigaTab := TLigaTabela(oModelo.FindByID(oModelo.FIDs -2));
    LigaTab := oModelo.FConversao_LastLigaTab;
    TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := card2;
    TLigacao(LigaTab.FLigacoes[0]).FCard.Cardinalidade := card1;
    oModelo.Ferramenta := Tool_Nothing;
  end;
  Function CriarTab: TTabela;
  begin
    oModelo.Ferramenta := Tool_LOGICO_Tabela;
    oModelo.Clicado := Point(R.Left, R.Top);
    Result := TTabela(oModelo.Add);
    Result.Nome := R.Nome;
    oModelo.Ferramenta := Tool_Nothing;
  end;
begin
  Result := true;
  lLista := TComponentList.Create(False);
  for i := 0 to ComponentCount -1 do
    if (Components[i] is TMaxRelacao) then
  begin
    lLista.Clear;
    R := TMaxRelacao(Components[i]);
    GeraLog('Exportando relacionamento "' + R.Nome + '"');
    R.associacao := nil;
    ListaDeTrabalho.Clear;
    R.GetEntidadtes(ListaDeTrabalho);
    if ListaDeTrabalho.Count < 2 then
    begin
      onErro(R, 'A relação "' + R.Nome + '" não foi bem formada' + #13 +
                'e será desconsiderada nesta conversão!', 1);
      Continue;
    end;

    //Pegar a maior cardinalidade e evitar duplos relacionamentos
    MaxCard := 1;
    for j := 0 to ListaDeTrabalho.Count -1 do
    begin
      E_tmp := TBaseEntidade(ListaDeTrabalho[j]);
      E_tmp.Tag := R.GetLigacao(E_tmp).Cardinalidade;
      noadd := false;
      for L := (J +1) to ListaDeTrabalho.Count -1 do
      begin
        E_tmp2 := TBaseEntidade(ListaDeTrabalho[L]);
        if E_tmp.associacao = E_tmp2.associacao then
        begin
          //estão ligados à mesma associação então eu apenas pego a maior cardinalidade.
          E_tmp.Tag := Max(R.GetLigacao(E_tmp2).Cardinalidade, E_tmp.Tag);
          noadd := true;
          Break;
        end;
      end;
      MaxCard := Max(MaxCard, E_tmp.Tag);
      if (not noadd) and (lLista.IndexOf(E_tmp) = (-1)) then
      begin
        lLista.Add(E_tmp);
      end;
    end;
    //As tabelas da relação foram mescladas a apenas uma tabela então:

    if lLista.Count < 2 then Continue;

    if lLista.Count > 2 then
    begin
      //ver se todos tem a cardinalidade [(1, 1) = 1]
      todos_cad1 := true;
      for j := 0 to R.FLigacoes.Count -1 do
      begin
        Li := TLigacao(R.FLigacoes[j]);
        if (Li.Ponta is TBaseEntidade) then
        begin
          if Li.Cardinalidade <> 1 then
          begin
            todos_cad1 := false;
            break;
          end;
        end;
      end;
      if todos_cad1 then
      begin
        E_tmp := TBaseEntidade(lLista[0]);
        Tab1 := TTabela(E_tmp.associacao);
        for L := 1 to lLista.Count -1 do
        begin
          E_tmp2 := TBaseEntidade(lLista[L]);
          Tab2 := TTabela(E_tmp2.associacao);
          for M := 0 to Tab2.Campos.Count -1 do
          begin
            C := TCampo(Tab2.Campos[M]);
            NC := Tab1.ImportarCampo(C);
            oModelo.ConversaoChangeAponta(C, NC);
          end;
          Tab2.FLigacoes.OwnsObjects := false;
          while Tab2.FLigacoes.Count > 0 do
          begin
            Li := TLigacao(Tab2.FLigacoes[0]);
            Tab2.FLigacoes.Remove(Li);
            Tab1.Liga(Li);
            Li.Generate(Li.Pai, Tab1);
          end;
          Tab1.Nome := Tab1.Nome + '+' + Tab2.Nome;
          Tab2.associacao.associacao := Tab1;
          FreeAndNil(Tab2);
        end;
        Result := MegaExportarAtributos(oModelo, R, Tab1);
        if not Result then exit;
        R.associacao := Tab1;
      end else //not todos card 1
      begin
        Tab1 := CriarTab;
        Result := MegaExportarAtributos(oModelo, R, Tab1);
        if not Result then exit;
        for j := 0 to lLista.Count -1 do
        begin
          Tab2 := TTabela(TBaseEntidade(lLista[j]).associacao);
          Rela(Tab1, Tab2, MaxCard, lLista[j].Tag);
          for L := 0 to Tab2.Campos.Count -1 do
          begin
            C := TCampo(Tab2.Campos[L]);
//--importação parcial
            if C.IsKey then Tab1.ImportarCampo(C);
          end;
        end;
        R.associacao := Tab1;
      end;
    end else
    if lLista.Count = 2 then
    begin
      //para facilitar as comparações a tag de e1 é sempre menor ou igual a de e2
      IF lLista[0].Tag < lLista[1].Tag then
      begin
        E_tmp := TBaseEntidade(lLista[0]);
        E_tmp2 := TBaseEntidade(lLista[1]);
      end else
      begin
        E_tmp := TBaseEntidade(lLista[1]);
        E_tmp2 := TBaseEntidade(lLista[0]);
      end;
      Fusao := False;
      TabProp := False;
      AdCol := false;
      Desc := 'Relacionamento ' + aCardinalidade[E_tmp.tag] + '<-->' + aCardinalidade[E_tmp2.tag] + ' encontrado!' + #13 +
      'Entre: "' + E_tmp.Nome + '" e "' + E_tmp2.Nome + '".' + #13 +
      'Observação: ' + IfThen(R.Observacoes <> '', R.Observacoes, '[Não há observações]');

      //Tudo:
      if ((E_tmp.Tag = 1) and (E_tmp2.Tag > 2))
      then begin
        AdCol := true;
      end else
      if ((E_tmp.Tag = 1) and (E_tmp2.Tag = 1)) then
      begin
        Fusao := true;
      end else
      if ((E_tmp.Tag = 1) and (E_tmp2.Tag = 2)) then
      begin
        Questoes.Clear;
        Questoes.Add('Adicionar a(s) chave(s) da tabela de menor cardinalidade à outra tabela.');
        Questoes.Add('Fundir as tabelas "' + E_tmp.associacao.Nome + '" e "' + E_tmp2.associacao.Nome + '".');
        opc := 1;
        Questione(desc, aj_Relacionamento, opc);
        if opc = 1 then Fusao := true else
          if opc = 0 then AdCol := true else
          begin
            Result := false;
            exit;
          end;
      end else
      if (E_tmp.Tag > 2) then TabProp := true;

      //Fusão ou adição de coluna
      if Fusao then
      begin
        Tab2 := TTabela(E_tmp.associacao);
        Tab1 := TTabela(E_tmp2.associacao);
        for L := 0 to Tab2.Campos.Count -1 do
        begin
          C := TCampo(Tab2.Campos[L]);
          NC := Tab1.ImportarCampo(C);
          oModelo.ConversaoChangeAponta(C, NC);
        end;
        R.associacao := Tab1;
        Tab2.FLigacoes.OwnsObjects := false;
        while Tab2.FLigacoes.Count > 0 do
        begin
          Li := TLigacao(Tab2.FLigacoes[0]);
          Tab2.FLigacoes.Remove(Li);
          Tab1.Liga(Li);
          Li.Generate(Li.Pai, Tab1);
        end;
        Tab1.Nome := Tab1.Nome + '+' + Tab2.Nome;
        Result := MegaExportarAtributos(oModelo, R, Tab1);
        if not Result then exit;
        Tab2.associacao.associacao := Tab1;
        FreeAndNil(Tab2);
      end else //not fusão

      //tabela próp. ou adição de col.
      if ((E_tmp.Tag = 2) and (E_tmp2.Tag > 1)) or AdCol
      then begin
        opc := 0;
        if not AdCol then
        begin
          Questoes.Clear;
          if E_tmp2.Tag = 2 then
          begin
            Questoes.Add('Adicionar a(s) chave(s) de "' + E_tmp2.Nome + '" à "' + E_tmp.Nome + '".');
            Questoes.Add('Adicionar a(s) chave(s) de "' + E_tmp.Nome + '" à "' + E_tmp2.Nome + '".');
          end else
            Questoes.Add('Adicionar a(s) chave(s) da tabela de menor card. à tabela de maior card.');
          Questoes.Add('Criar uma tabela para o relacionamento.');
          Questione(desc, aj_Relacionamento, opc);
          if opc = -1 then
          begin
            Result := false;
            exit;
          end;
        end;
        if (opc = 0) or ((opc = 1) and (E_tmp2.Tag = 2))  then
        begin
          Tab1 := TTabela(E_tmp.associacao);
          Tab2 := TTabela(E_tmp2.associacao);

          if (E_tmp2.Tag = 2) and (not AdCol) then
          begin
            if opc = 1 then
            begin
              Tab1 := TTabela(E_tmp2.associacao);
              Tab2 := TTabela(E_tmp.associacao);
            end;
          end;

          for L := 0 to Tab1.Campos.Count -1 do
          begin
            C := TCampo(Tab1.Campos[L]);
            if C.IsKey then
            begin
              NC := Tab2.ImportarCampo(C);
              NC.IsFKey := true;
              //FKey e Key eram exclusivos. Agora não é mais, então:
              //tive que incluir a mudança abaixo.
              NC.IsKey := false;
              //-----
              NC._CampoKey := C;
            end;
          end;
          Tab1 := TTabela(E_tmp.associacao);
          Tab2 := TTabela(E_tmp2.associacao);
          Rela(Tab1, Tab2, E_tmp.Tag, E_tmp2.Tag);
          if (R.Atributos.Count > 0) or (R.AOcultos.AtributosOcultos.Count > 0) then
          begin
            Questoes.Clear;
            Questoes.Add('Mover os atributos do relacionamento para a tabela "' + E_tmp.associacao.Nome + '".');
            Questoes.Add('Mover os atributos do relacionamento para a tabela "' + E_tmp2.associacao.Nome + '".');
            tmp := opc;
            if (E_tmp.Tag < 3) and (E_tmp2.Tag < 3) then
              Questione(desc, aj_Relacionamento, tmp);
            if tmp = 0 then
            begin
              Tab1 := TTabela(E_tmp.associacao);
            end
            else begin
              if tmp = 1 then
                Tab1 := TTabela(E_tmp2.associacao)
              else begin
                Result := false;
                Exit;
              end;
            end;
            Result := MegaExportarAtributos(oModelo, R, Tab1);
            if not Result then exit;
          end;
          R.associacao := Tab1;
        end else
        begin
          if opc = 1 then TabProp := true else
          begin
            Result := false;
            exit;
          end;
        end;
      end;
      if TabProp then
      begin
        Tab1 := TTabela(E_tmp.associacao);
        Tab2 := TTabela(E_tmp2.associacao);
        ATab := CriarTab;
        Result := MegaExportarAtributos(oModelo, R, aTab);
        if not Result then exit;
        R.associacao := ATab;
        Rela(Tab1, ATab, 1, E_tmp.Tag);
        Rela(Tab2, ATab, 1, E_tmp2.Tag);
        for L := 0 to Tab1.Campos.Count -1 do
        begin
          C := TCampo(Tab1.Campos[L]);
          if C.IsKey then
          begin
            NC := ATab.ImportarCampo(C);
            NC.IsFKey := true;
            NC._CampoKey := C;
            //FKey e Key eram exclusivos. Agora não é mais, então:
            //tive que incluir a mudança abaixo.
            NC.IsKey := false;
            //-----
          end;
        end;
        for L := 0 to Tab2.Campos.Count -1 do
        begin
          C := TCampo(Tab2.Campos[L]);
          if C.IsKey then
          begin
            NC := ATab.ImportarCampo(C);
            NC.IsFKey := true;
            NC._CampoKey := C;
            //FKey e Key eram exclusivos. Agora não é mais, então:
            //tive que incluir a mudança abaixo.
            NC.IsKey := false;
            //-----
          end;
        end;
      end;
    end;
  end;
  lLista.Free;
end;

function TModelo.ExportarAtributos(oModelo: TModelo): boolean;
var i: Integer;
      E: TBaseEntidade;
      T: TTabela;
begin
  Result := true;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TBaseEntidade then
  begin
    E := TBaseEntidade(Components[i]);
    T := TTabela(E.associacao);
    Result := MegaExportarAtributos(oModelo, E, T);
    if not Result then Break;
  end;
end;

function TModelo.ExportarEntAss(oModelo: TModelo): boolean;
var   i, L: Integer;
      E: TEntidadeAssoss;
      T, T2: TTabela;
      Li: TLigacao;
      C, NC: TCampo;
begin
  Result := true;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TEntidadeAssoss then
  begin
    E := TEntidadeAssoss(Components[i]);
    GeraLog('Exportando entidade associativa "' + E.Nome + '"');
    T2 := TTabela(E.associacao);
    if Assigned(E.Relacao.associacao) then
    begin
      T := TTabela(E.Relacao.associacao);
      for L := 0 to T2.Campos.Count -1 do
      begin
        C := TCampo(T2.Campos[L]);
        NC := T.ImportarCampo(C);
//        NC.associacao := C.associacao;
        oModelo.ConversaoChangeAponta(C, NC);
      end;
      T2.FLigacoes.OwnsObjects := false;
      while T2.FLigacoes.Count > 0 do
      begin
        Li := TLigacao(T2.FLigacoes[0]);
        T2.FLigacoes.Remove(Li);
        T.Liga(Li);
        Li.Generate(Li.Pai, T);
      end;

      // TCC II - Puc (MG) - Daive Simões
      // Retirado o sinal de "+" que era colocado entre as entidades e a entidade
      // associativa. Esse sinal de "+" causava erro ao tentar executa a SQL gerada
      // pelo modelo físico.
      T.Nome := T.Nome + '_' + T2.Nome;
      // Fim TCC II

      T2.associacao.associacao := nil;
      FreeAndNil(T2);
    end;
  end;
end;

function TModelo.ExportarAutoRelacionamento(oModelo: TModelo): boolean;
var   i, j, tmp1, tmp2, Card1, Card2, opc: Integer;
      E: TAutoRelacao;
      T, T2: TTabela;
      C: TCampo;
      ligaTab: TLigaTabela;
      AdCol: Boolean;

  Procedure CriarCampoByAtributo(oC: TCampo; aT: TTabela);
  begin
    with TCampo.Create(oModelo) do
    begin
      Nome := 'possui_' + oC.Nome;
      Tipo := oC.Tipo;
      Observacoes := oC.Observacoes;
      Dicionario := oC.Dicionario;
      aT.AddCampo(TCampo(Me));
//      associacao := aT;
    end;
  end;

begin
  Result := true;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TAutoRelacao then
  begin
    E := TAutoRelacao(Components[i]);
    GeraLog('Exportando auto-relacionamento "' + E.Nome + '"');
    T := TTabela(E.Pai.associacao);
    if Assigned(T) then
    begin
      tmp1 := TLigacao(E.FLigacoes[0]).Cardinalidade;
      tmp2 := TLigacao(E.FLigacoes[1]).Cardinalidade;
      Card2 := Max(tmp1, tmp2);
      Card1 := Min(tmp1, tmp2);
//      AdCol := False;
      if (Card2 = 1) then
      begin
        AdCol := True;
      end else
      if (Card1 > 2) then
      begin
        AdCol := False;
      end else
      begin
        Questoes.Clear;
        Questoes.Add('Criar relacionamento recursivo em "' + T.Nome + '".');
        Questoes.Add('Criar uma tabela para o auto-relacionamento.');
        opc := IfThen((Card2 = 2), 0, 1);
        Questione(
                  'Auto-relacionamento com cardinalidade ' +
                  aCardinalidade[Card1] + ' e ' + aCardinalidade[Card2] +
                  ' encontrado!' + #13 +
                  'Entre: "' + T.Nome + '" e "' + E.Nome + '".' + #13 +
                  'Observação: ' + IfThen(E.Observacoes <> '', E.Observacoes, '[Não há observações]'),
                  aj_nothing,opc);
        AdCol := (opc = 0);
        if opc = -1 then
        begin
          Result := false;
          exit;
        end;
      end;

      if AdCol then
      begin
        for j := 0 to T.Campos.Count -1 do
        begin
          C := TCampo(T.Campos[j]);
          if C.IsKey then CriarCampoByAtributo(C, T);
        end;
        T2 := T;
      end else
      begin
        oModelo.Ferramenta := Tool_LOGICO_Tabela;
        oModelo.Clicado := Point(E.Left, E.Top);
        T2 := TTabela(oModelo.Add);
        T2.Nome := E.Nome;
        T2.associacao := E;
        E.associacao := T2;
        oModelo.Ferramenta := Tool_LOGICO_Relacao;
        oModelo.UsrSelA := T;
        oModelo.BaseClick(T2);
//        LigaTab := TLigaTabela(oModelo.FindByID(oModelo.FIDs -2));
        LigaTab := oModelo.FConversao_LastLigaTab;
        LigaTab.SetCard(Card1, Card2);
//        TLigacao(LigaTab.FLigacoes[0]).FCard.Cardinalidade := Card1;
//        TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := Card2;
        oModelo.Ferramenta := Tool_Nothing;
        for j := 0 to T.Campos.Count -1 do
        begin
          C := TCampo(T.Campos[j]);
          if C.IsKey then
          begin
            T2.ImportarCampo(C).IsKey := false;
            CriarCampoByAtributo(C, T2);
          end;
        end;
      end;
      Result := MegaExportarAtributos(oModelo, E, T2);
      if not Result then Break;
    end;
  end;
end;

procedure TModelo.SetVersao(const Value: String);
begin
  FVersao := Value;
end;

procedure TModelo.TabelasLigadas(lLista: TGeralList; T : TTabela);
  var i: Integer;
      lT: TLigaTabela;
      L, L2: TLigacao;
      aT: TTabela;
begin
  lLista.Lista.Clear;
  ListaDeTrabalho.Clear;
  for i := 0 to T.FLigacoes.Count -1 do
  begin
    L := TLigacao(T.FLigacoes[i]);
    lT := TLigaTabela(L.Pai);
    if lT.FLigacoes.IndexOf(L) = 1 then
      L2 := TLigacao(lT.FLigacoes[0])
    else
      L2 := TLigacao(lT.FLigacoes[1]);
    if Not Assigned(L2) then Continue;
    aT := TTabela(L2.Ponta);
    if ListaDeTrabalho.IndexOf(aT) = -1 then
    begin
      lLista.Add(aT.Nome, aT.OID, 0);
      ListaDeTrabalho.Add(aT);
    end;
  end;
  // a própria para auto-relacionamento.
  lLista.Add(T.Nome, T.OID, 0);
  lLista.Ordene;
end;

procedure TModelo.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
//
  if Visible then TVisual(Owner).SetFocusByModelo;
  if not((ssCtrl in Shift) or (ssShift in Shift)) then
  begin
    Selecionado := nil;
    ClearSelect;
  end;
  FRegiao := 0;
  OldFerramenta := -1;
  if Ferramenta > 0 then
  begin
    Clicado := ScreenToClient(Mouse.CursorPos);
    Add;
    OldFerramenta := Ferramenta;
    Ferramenta := 0;
    inherited;
    exit; //não continue.
  end;
//
  FMClicado := Point(X, Y);
  isMouseDown := true;
  FSelecionador.SetBounds(0, 0, 1, 1);
  FSelecionador.BringToFront;
  FSelecionador.Visible := true;
  inherited;
end;

procedure TModelo.MouseMove(Shift: TShiftState; X, Y: Integer);
  var Pt: Array[1..4] of TPoint;
  ALeft, ATop, AWidth, AHeight: Integer;
begin
  if isMouseDown then
  begin
    Pt[1] := FMClicado;
    Pt[2] := Point(X, FMClicado.Y);
    Pt[3] := Point(X, Y);
    Pt[4] := Point(FMClicado.X, y);
    FRegiao := CreatePolygonRgn(Pt, 4, WINDING);
    FSelecionador.Visible := true;
    ALeft := FMClicado.X;
    ATop  := FMClicado.Y;
    aWidth := X -FMClicado.X;
    AHeight  := Y -FMClicado.Y;
    if (AWidth < 0) or (AHeight < 0) then
    begin
      ALeft := X;
      ATop  := Y;
      aWidth := FMClicado.X -X;
      AHeight:= FMClicado.Y -Y;
    end;
    FSelecionador.SetBounds(ALeft, ATop, AWidth, AHeight);
  end;
  inherited;
end;

procedure TModelo.SetSelecionador(const Value: TSelecao);
begin
  FSelecionador := Value;
end;

procedure TModelo.SetstaLoading(const Value: boolean);
begin
  FstaLoading := Value;
end;

procedure TModelo.SetTemplate(const Value: TMngTemplate);
begin
  FTemplate := Value;
end;

procedure TModelo.SetTipoDeModelo(const Value: integer);
begin
  if (FTipoDeModelo <> Value) then
  begin
    TransformTo(Value);
  end;
end;

function TModelo.ExportarEntidadesHerancaMultipla(
  oModelo: TModelo): boolean;
  var i, j: Integer;
      E: TEntidade;
      T1, T2: TTabela;
      LigaTab: TLigaTabela;

  Procedure Rela(aT1, aT2: TTabela);
  var L: integer;
      C, NC: TCampo;
  begin
    oModelo.Ferramenta := Tool_LOGICO_Relacao;
    oModelo.UsrSelA := aT1;
    oModelo.BaseClick(aT2);
    //LigaTab := TLigaTabela(oModelo.FindByID(oModelo.FIDs -2));
    LigaTab := oModelo.FConversao_LastLigaTab;
    TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := 1;
    TLigacao(LigaTab.FLigacoes[0]).FCard.Cardinalidade := 3;
    oModelo.Ferramenta := Tool_Nothing;
    for L := 0 to aT2.Campos.Count -1 do
    begin
//----------------não repedir os campos já importados.......
      C := TCampo(aT2.Campos[L]);
      if C.IsKey then
      begin
        NC := aT1.ImportarCampo(C);
        //?por que não continua sendo key?
        //05/11/2006 - não mudar - verificado o porque!
        NC.FIsKey := false;
        NC.FIsFKey := true;
        NC._CampoKey := C;
      end;
    end;
  end;
begin
  Result := true;
  ListaDeTrabalho.Clear;
  for i := 0 to ComponentCount -1 do
    if Components[i] is TEntidade then
  begin
    E := TEntidade(Components[i]);
    if not E.ehHerancaMultipla then Continue;
    GeraLog('Reestruturando entidade originada de herança múltipla "' + E.Nome + '"');
    T1 := TTabela(E.associacao);
    T2 := TTabela(E.Forigem.EntidadeBase.associacao);
    if (Assigned(T2)) then
    begin
      Rela(T1, T2);
      ListaDeTrabalho.Add(T2);
    end;
    for j := 0 to E.Forigens.Count -1 do
    begin
      T2 := TTabela(TEspecializacao(E.Forigens[j]).EntidadeBase.associacao);
      if (not Assigned(T2)) or (ListaDeTrabalho.IndexOf(T2) > -1) then Continue;
      Rela(T1, T2);
      ListaDeTrabalho.Add(T2);
    end;
  end;
end;

procedure TModelo.onEspDel(Esp: TEspecializacao);
  var i: Integer;
      E: TEntidade;
begin
  for i := 0 to ComponentCount -1 do
    if Components[i] is TEntidade then
  begin
    E := TEntidade(Components[i]);
    if E.FOrigens.Count > 0 then E.FOrigens.Remove(Esp);
    if E.FOrigem = Esp then E.Origem := nil;
  end;
end;

procedure TModelo.GeraLista(Lst: TStringList; tp: Integer);
  var i:Integer;
    C: TCampo;
    T: TTabela;
    tmp: string;
begin
  if tp = fisicoTpCamposNome then
  begin
    for I := 0 to ComponentCount - 1 do
      if Components[i] is TCampo then
    begin
      C := TCampo(Components[i]);
      if (not C.ApenasSeparador) then
      begin
        // Inicio TCC II
        // monta o nome do campo que contenha a string ( )
        tmp := C.Nome;
        if (pos('( )', C.Nome) <> 0) then
          tmp := copy(C.Nome, 1, pos('(', C.Nome)) + C.Precisao + ')';
        // Fim TCC II

        if Lst.IndexOf(tmp) < 0 then
        begin
          Lst.Add(tmp);
        end;
      end;
    end;
  end else
  if tp = fisicoTpCamposTipo then
  begin
    for I := 0 to ComponentCount - 1 do
      if Components[i] is TCampo then
    begin
      C := TCampo(Components[i]);
      if (not C.ApenasSeparador) then
      begin
        // Inicio TCC II
        // monta o nome do campo que contenha a string ( )
        tmp := C.Tipo;
        if (pos('( )', C.Tipo) <> 0) then
          tmp := copy(C.Tipo, 1, pos('(', C.Tipo)) + C.Precisao + ')';
        // Fim TCC II

        if Lst.IndexOf(tmp) < 0 then
        begin
          Lst.Add(tmp);
        end;
      end;
    end;
  end else
  if tp = fisicoTpCamposCoplemento then
  begin
    for I := 0 to ComponentCount - 1 do
      if Components[i] is TCampo then
    begin
      C := TCampo(Components[i]);
      if (not C.ApenasSeparador) then
      begin
        tmp := C.Complemento;
        if Lst.IndexOf(tmp) < 0 then
        begin
          Lst.Add(tmp);
        end;
      end;
    end;
  end else
  if tp = fisicoTpTabelaCoplemento then
  begin
    for I := 0 to ComponentCount - 1 do
      if Components[i] is TTabela then
    begin
      T := TTabela(Components[i]);
      tmp := T.Complemento;
      if Lst.IndexOf(tmp) < 0 then
      begin
        Lst.Add(tmp);
      end;
    end;
  end;
end;

procedure TModelo.GeraLog(Texto: string; emVermelho, negrito: boolean);
begin
  TVisual(Owner).Writer.write(Texto, emVermelho, negrito);
end;

procedure TModelo.SetAutor(const Value: String);
begin
  FAutor := Value;
  Mudou := true;
end;

procedure TModelo.SetAutoSalvar(const Value: Boolean);
begin
  FAutoSalvar := Value;
end;

procedure TModelo.ResetFontFromSelecao;
  var i: integer;
      B: Tbase;
begin
  if FMultSelecao.Count = 0 then Exit;
  For i := 0 to FMultSelecao.Count -1 do
  begin
    B := TBase(FMultSelecao[i]);
    if Assigned(B) then
    begin
      B.Font.Assign(Selecionado.Font);
      B.Canvas.Font.Assign(Selecionado.Font);
      B.FonteChanged;
      if (B is TEntidadeAssoss) then
      begin
        TEntidadeAssoss(B).Relacao.Font.Assign(Selecionado.Font);
        TEntidadeAssoss(B).Relacao.Canvas.Font.Assign(Selecionado.Font);
      end;
    end;
  end;
end;

function TModelo.ExportarLimparLixo(oModelo: TModelo): boolean;
  var i, j, L, card1, card2: Integer;
  T, TT1, TT2: TTabela;
  LT: TLigaTabela;
  L1, L2: TLigacao;
  Procedure Rela(t1, t2: TTabela; card1, card2: integer);
  var LigaTab: TLigaTabela;
  begin
    oModelo.Ferramenta := Tool_LOGICO_Relacao;
    oModelo.UsrSelA := T1;
    oModelo.BaseClick(T2);
//    LigaTab := TLigaTabela(oModelo.FindByID(oModelo.FIDs -2));
    LigaTab := oModelo.FConversao_LastLigaTab;
    TLigacao(LigaTab.FLigacoes[1]).FCard.Cardinalidade := card2;
    TLigacao(LigaTab.FLigacoes[0]).FCard.Cardinalidade := card1;
    oModelo.Ferramenta := Tool_Nothing;
  end;
begin
  Result := true;
  i := 0;

  // Inicio TCC II
  // O loop abaixo não estava chegando ao final dos componentes existentes no modelo
  // porque a cláusula de verificação do loop estava errada com apenas o sinal de
  // menor "<".
  while (i <= oModelo.ComponentCount - 1) do begin
  // Fim TCC II

    if (oModelo.Components[i] is TCampo) then
    begin
      TCampo(oModelo.Components[i]).RealiseConversao;
      inc(I);
      Continue;
    end;
    if (oModelo.Components[i] is TTabela) and
       TTabela(oModelo.Components[i]).Excluir then
    begin
      T := TTabela(oModelo.Components[i]);
      for j := 0 to T.FLigacoes.Count -1 do
      begin
        L1 := TLigacao(T.FLigacoes[j]);
        LT := TLigaTabela(L1.Pai);
        if LT.Former = T.OID then
        begin
          Continue;
        end;
        if LT.FLigacoes.IndexOf(L1) = 0 then L2 := TLigacao(LT.FLigacoes[1]) else
          L2 := TLigacao(LT.FLigacoes[0]);
        TT1 := TTabela(L2.Ponta);
        card1 := L2.FCard.Cardinalidade;
        card2 := L1.FCard.Cardinalidade;
        ListaDeTrabalho.Clear;
        TEntidade(T.associacao).GetEntidadesDescendentes(ListaDeTrabalho);
        for L := 0 to ListaDeTrabalho.Count -1 do
        begin
          TT2 := TTabela(TEntidade(ListaDeTrabalho[L]).associacao);
          if TT2 = T then Continue;
          Rela(TT1, TT2, card1, card2);
        end;
      end;
//-------- a tabela está sendo destruída aqui. Não precisa pensar nos campos. Tratado anteriormente.
      if T.Interferencia = 0 then FreeAndNil(T) else inc(i);
    end else inc(i);
  end;
end;

procedure TModelo.SetFJa_XSL(const Value: String);
begin
  if Value = FJa_XSL then exit;
  FJa_XSL := Value;
  Mudou := true;
end;

procedure TModelo.SetFliquer(const Value: Integer);
begin
  FFliquer := Value;
end;

procedure TModelo.CMTabelaOrder(var Message: TMessage);
  var i, j, acao, vz: integer;
      T, Ori: TTabela;
      strAcao: string;
begin
  acao := Message.LParam;
  if acao = 0 then Exit;
  Ori := TTabela(Message.WParam);
  if acao = -1 then //excluído a tabela
  begin
    for I := 0 to ComponentCount - 1 do
      if Components[i] is TTabela then
    begin
      T := TTabela(Components[i]);
      if T.cOrdem > Ori.cOrdem then T.FcOrdem := T.FcOrdem -1;
    end;
  end else
  begin
    Questoes.clear;
    for i := 1 to QtdTabela do Questoes.Add(IntToStr(i)); //quais são as posições válidas
    for i := 0 to ComponentCount - 1 do  //quais já estão ocupadas
      if Components[i] is TTabela then
    begin
      T := TTabela(Components[i]);
      vz := Questoes.IndexOf(IntToStr(T.cOrdem));
      if vz > -1 then Questoes[vz] := '';
    end;
    strAcao := Questoes.Text;
    vz := 0;
    if Questoes.IndexOf(IntToStr(acao)) = -1 then //troca por um que já está ocupada?
    begin
      for I := 0 to ComponentCount - 1 do  //quem ocupa
        if Components[i] is TTabela then
      begin
        T := TTabela(Components[i]);
        if T.cOrdem = acao then
        begin
          if Ori.cOrdem = 0 then
          begin
            for j := 0 to Questoes.Count -1 do
              if Questoes[j] <> '' then //primeiro vazio
            begin
              vz := j + 1;
              break;
            end;
          end else vz := Ori.cOrdem;
          T.FcOrdem := vz; //pré-troca
          break;
        end;
      end;
    end;
    Questoes.clear;
  end;
end;

procedure TModelo.CMBaseExecOnSelect(var Message: TMessage);
begin
  if Assigned(FOnSelect) then FOnSelect(FSelecionado);
end;

{ TBaseEntidade }

function TBaseEntidade.AutoRelacionar(Nome: String): boolean;
  var bkp: boolean;
begin
  Result := false;
  if (not Assigned(FAutoRelacao)) then
  begin
    Muda;
    FAutoRelacao := TAutoRelacao.Create(Modelo);
    Result := FAutoRelacao.Relacione(Self) and FAutoRelacao.Relacione(Self);
    FAutoRelacao.Nome := nome;
    FAutoRelacao.Pai := Self;
    FAutoRelacao.SetBounds(Left + Width + 30, Top + (Height div 6), {Width - (Width div 3)} 2 * (Height - (Height div 3)), Height - (Height div 3));
    FAutoRelacao.Reenquadre;
    if not Result then FreeAndNil(FAutoRelacao);

    if Modelo.FMultSelecao.Count = 0 then
      Modelo.Selecionado := FAutoRelacao;

    bkp := Atualizando;
    Atualizando := true;
    AdjustSize;
    Atualizando := bkp;
  end;
end;

destructor TBaseEntidade.destroy;
begin
  if Assigned(FAutoRelacao) then
    if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
      FreeAndNil(FAutoRelacao);
  inherited;
end;

function TBaseEntidade.DestruirAutoRelacao: Boolean;
begin
  Result := false;
  if Assigned(FAutoRelacao) then
  begin
    Muda;
    FAutoRelacao.Free;
    FAutoRelacao := nil;
  end;
end;

function TBaseEntidade.GetAutoRelacionado: boolean;
begin
  Result := Assigned(FAutoRelacao);
end;

function TBaseEntidade.Get_AutoRelacao: Integer;
begin
  if FAutoRelacao = nil then Result := -1 else Result := FAutoRelacao.OID;
end;

procedure TBaseEntidade.Load;
begin
  inherited;
  if _FAutoRelacao <> -1 then
  begin
    FAutoRelacao := TAutoRelacao(Modelo.FindByID(_FAutoRelacao));
    FAutoRelacao.Pai := Self;
  end;
end;

procedure TBaseEntidade.Paint;
begin
  if (Atualizando) then exit;
  with canvas do
  begin
    Pen.Style:=psSolid;
    Pen.Color := TColor(-5);
    MoveTo(0, 0);
    LineTo(0, height-3);
    LineTo(width-3, height-3);
    LineTo(width-3, 0);
    LineTo(0, 0);
    Pen.Style:=psSolid;
    Pen.Color:=$00707070;
    MoveTo(width-2, 0);
    LineTo(width-2, height-2);
    LineTo(0, height-2);
    Pen.Color:=$00B3B3B3;
    MoveTo(width-1, 0);
    LineTo(width-1, height-1);
    LineTo(0, height-1);
//    Pen.Color:=$00C66931;
//    Pen.Color:=$00363636;
//    Pen.Color:=$00D0D0D0;
  end;
  inherited;
end;

procedure TBaseEntidade.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if Assigned(FAutoRelacao) then FAutoRelacao.NeedPaint;
end;

procedure TBaseEntidade.to_xml(var node: IXMLNode);
  var lnode: IXMLNode;
begin
  inherited to_xml(node);
  lnode := node.AddChild('AutoRelacoes');
  lnode.Attributes['AutoRelacionado'] := BoolToStr(AutoRelacionado);
  if AutoRelacionado then FAutoRelacao.to_xml(lnode);
end;

{ TPonto }

constructor TPonto.Create(AOwner: TComponent);
begin
  inherited;
  Recuo := 3;
  Visible := false;
  Width := 6;
  Height := 6;
  Color := clBlack;
  FPosicao := 0;
  if AOwner is TBase then
//  begin
//    Parent := TBase(AOwner).Modelo;
    FDono := Tbase(AOwner);
//  end;
  Cursor := crHandPoint;
end;

procedure TPonto.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  isMouseDown := True;
  down := Point(X, Y);
  FDono.Modelo.EveryHideShowSelection(FDono, false);
end;

procedure TPonto.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if isMouseDown then
  begin
    SetBounds(Left + X - down.X, Top + Y - down.Y, Width, Height);
    EmLinha.Top := Top;
    EmColuna.Left := Left;
    FDono.reSetBounds;
  end;
end;

procedure TPonto.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  isMouseDown := False;
  if Top < 0 then Top := 0;
  If Left < 0 then Left := 0;
  FDono.Modelo.EndOperation;
  FDono.Modelo.EveryHideShowSelection(FDono, True);
  inherited;
end;

procedure TPonto.paint;
begin
  if not Assigned(FDono) or (Posicao = 0) then Exit;
  if FDono.Atualizando then exit;
  //inherited;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(rect(0, 0, width, height));
end;

procedure TPonto.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (ALeft = Left) and (ATop = Top) and (AWidth = Width) and (AHeight = Height) then exit;
  inherited;
end;

procedure TPonto.SetProsicao(const Value: Integer);
begin
  FPosicao := Value;
//  if Visible then
  case Value of
  1:begin
      SetBounds(FDono.Left, FDono.Top, Width, Height);
      EmLinha := FDono.Pontos[2];
      EmColuna := FDono.Pontos[4];
      Cursor := crSizeNWSE;
    end;
  2:begin
      SetBounds(FDono.Width - Width + FDono.Left -Recuo, FDono.Top, Width, Height);
      EmLinha := FDono.Pontos[1];
      EmColuna := FDono.Pontos[3];
      Cursor := crSizeNESW;
    end;
  3:begin
      SetBounds(FDono.Width - Width + FDono.Left -Recuo, FDono.Height - Height + FDono.Top -Recuo, Width, Height);
      EmLinha := FDono.Pontos[4];
      EmColuna := FDono.Pontos[2];
      Cursor := crSizeNWSE;
    end;
  4:begin
      SetBounds(FDono.Left, FDono.Height - Height + FDono.Top -Recuo, Width, Height);
      EmLinha := FDono.Pontos[3];
      EmColuna := FDono.Pontos[1];
      Cursor := crSizeNESW;
    end;
  end;
end;

procedure TPonto.SetRecuo(const Value: integer);
begin
  FRecuo := Value;
end;

{ TBaseRelacao }

constructor TBaseRelacao.Create(AOwner: TComponent);
begin
  inherited;
  FLigacoes.OwnsObjects := true;
  Height := 51;
  Direcao := TSeta.Create(Self);
end;

function TBaseRelacao.GetSetaDirecao: Integer;
begin
  Result := Direcao.Posicao;
end;

function TBaseRelacao.isMine(P: TPoint): boolean;
begin
  P := ScreenToClient(P);
  Result := PtInRegion(Regiao, P.X, P.Y);
end;

procedure TBaseRelacao.Paint;
  var L, C, H, W: integer;
begin
  if (Atualizando) then exit;
  H := Height;
  W := Width;
  C := (Width div 2);
  L := (Height div 2);
  with canvas do
  begin
    Pen.Style:=psSolid;
    Pen.Color := clBlack;
    MoveTo(C, 0);
    LineTo(W -1, L -1);
    LineTo(C -1, h -1);
    LineTo(0, L);
    LineTo(C, 0);
    Pen.Color:=$00B3B3B3;
    MoveTo(W, L);
    LineTo(C, h);
  end;
  if not NaoPinteNome then
    inherited;
end;

procedure TBaseRelacao.PrepareToAtive(Lg: TLigacao);
  var des, atDes: integer;
  function arruma(C, L: integer; Linha, sobe: boolean): integer;
    var ss: integer;
  begin
    ss := IfThen(sobe, 1, -1);
    while not PtInRegion(Regiao, C - Left, L - Top) do
    begin
      if Linha then L := L + ss else C := C + ss;
      if (C - Left < 0) or (C - Left > Width) or (L - Top < 0) or (L - Top > Height) then break; //seguran;a.
    end;
    Result := IfThen(Linha, L, C);
  end;
begin
  inherited;
  AtualizaEncaixes;
  if Regiao = 0 then Exit;
  if lg.Pai is TAtributo then
  begin
//    if Lg.BaseInicial = Self then des := lg.PontoInicial else des := lg.PontoFinal;
    des := Lg.MePonto(Self);
    atdes := TAtributo(Lg.Pai).Desvio;
    case des of
    1: begin
      Encaixe[1].Y := Encaixe[1].Y - atDes;
      Encaixe[1].X := arruma(Encaixe[1].X, Encaixe[1].Y, false, true);
    end;
    2: begin
      Encaixe[2].X := Encaixe[2].X + atDes;
      Encaixe[2].Y := arruma(Encaixe[2].X, Encaixe[2].Y, true, true);
    end;
    3: begin
      Encaixe[3].Y := Encaixe[3].Y + atDes;
      Encaixe[3].X := arruma(Encaixe[3].X, Encaixe[3].Y, false, false);
    end;
    4: begin
      Encaixe[4].X := Encaixe[4].X + atDes;
      Encaixe[4].Y := arruma(Encaixe[4].X, Encaixe[4].Y, true, false);
    end;
    end;
    if des > 0 then
      if (Encaixe[des].X < Left) or (Encaixe[des].X > left + Width) or
      (Encaixe[des].Y < Top) or (Encaixe[des].Y > Top + Height) then AtualizaEncaixes;
  end;
end;

procedure TBaseRelacao.Realinhe;
  var i: Integer;
  L : TLigacao;
begin
  for i := 0 to FLigacoes.Count -1 do
  begin
    if (FLigacoes[i] is TLigacao) then
    begin
      L := TLigacao(FLigacoes[i]);
      if Assigned(L) then
      begin
        if (L.Ponta is TBaseEntidade) then L.SuspendLineMove := true;
        L.Ative;
        L.SuspendLineMove := False;
      end;
    end;
  end;
end;

function TBaseRelacao.Relacione(E: TBaseEntidade): boolean;
  var L : TLigacao;
begin
  Result := false;
  if Assigned(E) then
  begin
    if E is TEntidadeAssoss then
      if TEntidadeAssoss(E).Relacao = Self then Exit;
    if CanLiga(E) then
    begin
      L := TLigacao.Create(Modelo);
      E.Liga(L);
      Result := L.Generate(Self, E);
      FLigacoes.Add(L);
      L.MostraCardinalidade := true;
      L.FCard.ToCardinalidade(4);
    end;
  end;
end;

procedure TBaseRelacao.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
  var Pt: Array[1..4] of TPoint;
begin
  inherited;
  Pt[1] := Point(0, Height div 2);
  Pt[2] := Point(Width div 2, 0);
  Pt[3] := Point(Width, Height div 2);
  Pt[4] := Point(Width div 2, Height);
  Regiao := CreatePolygonRgn(Pt, 4, WINDING);
  if (Assigned(Direcao)) then Direcao.Realinhe;
end;

procedure TBaseRelacao.SetDirecao(const Value: TSeta);
begin
  FDirecao := Value;
end;

procedure TBaseRelacao.SetNaoPinteNome(const Value: boolean);
begin
  FNaoPinteNome := Value;
end;

procedure TBaseRelacao.SetSetaDirecao(const Value: Integer);
  var sn: Boolean;
begin
  if Assigned(FDirecao) then
  begin
    sn := Direcao.Posicao <> Value;
    Direcao.Alinhe(Value);
    if sn and (Direcao.Posicao <> Value) then Muda;
  end;
end;

procedure TBaseRelacao.to_xml(var node: IXMLNode);
  var lnode: IXMLNode;
begin
  inherited to_xml(node);
  lnode := node.AddChild('SetaDirecao');
  lnode.Attributes['Valor'] := GetSetaDirecao;
  lnode := node.AddChild('Ligacoes');
  if not((Modelo.Copiando) and (Self is TRelacao)) then
    LigacoesTo_xml(lnode);
end;

{ TLinha }

procedure TLinha.CMMouseEnter(var Message: TMessage);
begin
  inherited;
end;

procedure TLinha.CMMouseLeave(var Message: TMessage);
begin
  inherited;
end;

constructor TLinha.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TLigacao then Modelo := TLigacao(AOwner).Modelo;
  Parent := Modelo;
  FLargura := 5;
  Movimentavel := true;
  Color := clBlack;
  Cursor := crHandPoint;
end;

procedure TLinha.dblClick;
begin
  if Assigned(FonNovaOrientacao) then FonNovaOrientacao(self);
  inherited;
end;

procedure TLinha.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  isMouseDown := True;
  down := Point(X, Y);
end;

procedure TLinha.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if isMouseDown and Movimentavel then begin
    Inicio := Point(Inicio.X + X - down.X, Inicio.Y + Y - down.Y);
    Fim := Point(Fim.X + X - down.X, Fim.Y + Y - down.Y);
  end;
end;

procedure TLinha.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  isMouseDown := False;
end;

procedure TLinha.paint;
begin
  if (Atualizando) then Exit;
  With canvas do
  begin
    Pen.Style := psSolid;
    if Orientacao = OrientacaoV then
    begin
      if Height > 4 then
      begin
        Pen.Color := clWhite;
        MoveTo(2, 2);
        LineTo(2, Height -2);
        MoveTo(4, 2);
        LineTo(4, Height -2);
        Pen.Color := Color;
      end;
      MoveTo(3, 0);
      LineTo(3, Height);
      if isWeak then
      begin
        if Height > 4 then
        begin
          Pen.Color := clWhite;
          MoveTo(1, 2);
          LineTo(1, Height -2);
          Pen.Color := Color;
        end;
        MoveTo(2, 0);
        LineTo(2, Height);
        MoveTo(4, 0);
        LineTo(4, Height);
      end;
    end;
    if Orientacao = OrientacaoH then
    begin
      if Width > 4 then
      begin
        Pen.Color := clWhite;
        MoveTo(2, 2);
        LineTo(Width -2, 2);
        MoveTo(2, 4);
        LineTo(Width -2, 4);
        Pen.Color := Color;
      end;
      MoveTo(0, 3);
      LineTo(Width, 3);
      if isWeak then
      begin
        if Width > 4 then
        begin
          Pen.Color := clWhite;
          MoveTo(2, 1);
          LineTo(Width -2, 1);
          Pen.Color := Color;
        end;
        MoveTo(0, 2);
        LineTo(Width, 2);
        MoveTo(0, 4);
        LineTo(Width, 4);
      end;
    end;
  end;
end;

procedure TLinha.SetAtualizando(const Value: Boolean);
begin
  FAtualizando := Value;
  if not FAtualizando then Repaint;
end;

procedure TLinha.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (ALeft <> Left) or (ATop <> Top) or (AWidth <> Width) or (AHeight <> Height) then
    inherited;
end;

procedure TLinha.SetFim(const Value: TPoint);
begin
  FFim := Value;
  SetOrientacao(Orientacao);
end;

procedure TLinha.SetInicio(const Value: TPoint);
begin
  FInicio := Value;
  if FInicio.Y < 0 then
  begin
    FFim.Y := FFim.Y + (FInicio.Y * -1);
    FInicio.Y := 0;
  end;
  If FInicio.X < 0 then
  begin
    FFim.X := FFim.X + (FInicio.X * -1);
    FInicio.X := 0;
  end;
  SetOrientacao(Orientacao);
end;

procedure TLinha.SetisWeak(const Value: boolean);
begin
  FisWeak := Value;
  Invalidate;
end;

procedure TLinha.SetLargura(const Value: integer);
begin
  FLargura := Value;
  SetOrientacao(Orientacao);
end;

//procedure TLinha.SetModelo(const Value: TModelo);
//begin
//  FModelo := Value;
//end;

procedure TLinha.SetMovimentavel(const Value: Boolean);
begin
  FMovimentavel := Value;
end;

procedure TLinha.SetonNovaOrientacao(const Value: TNotifyEvent);
begin
  FonNovaOrientacao := Value;
end;

procedure TLinha.SetOrientacao(const Value: integer);
begin
  FOrientacao := Value;
  if Orientacao = OrientacaoV then
  begin
    SetBounds(Inicio.X, Inicio.Y, Largura, Fim.Y - Inicio.Y);
  end;
  if Orientacao = OrientacaoH then
  begin
    SetBounds(Inicio.X, Inicio.Y, Fim.X - Inicio.X, Largura);
  end;
end;

{ TLigacao }

procedure TLigacao.AtiveLinha(L: TLinha; Ini, Fim: TPoint; ori: Integer);
  var tmp: TPoint;
begin
  if (Ini.X > Fim.X) or (Ini.Y > Fim.Y) then
  begin
    tmp := Ini;
    Ini := Fim;
    Fim := tmp;
  end;
  if SuspendLineMove then exit;
  L.Orientacao := Ori;
  L.Inicio := Ini;
  L.Fim := fim;
  L.Visible := true;
end;

function TLigacao.Ative: boolean;
  var TMP: TBase;
  pE1, pE2: Integer;
  ja: Boolean;
//      auto: TAutoRelacao;
  const distancia = 20;
  Procedure Mapa(p1, p2: integer);
  begin
    BaseInicial := E1;
    BaseFinal := E2;
    PontoInicial := p1;
    PontoFinal := p2;
    PosicioneCardinalidade;
  end;
begin
  LinhaA.Visible := false;
  LinhaB.Visible := false;
  LinhaMeio.Visible := false;
  Result := false;
  if Assigned(E1) and Assigned(E2) then
  begin
    Result := true;
    E1.PrepareToAtive(self);
    E2.PrepareToAtive(self);
    if ((E1.Encaixe[3].X < (E2.Left - distancia)) and (E1.Encaixe[4].Y < (E2.Top - distancia))) or
       ((E2.Encaixe[3].X < (E1.Left - distancia)) and (E2.Encaixe[4].Y < (E1.Top - distancia))) then
    begin
      if (E2.Encaixe[2].X < (E1.Left - distancia)) and (E2.Encaixe[4].Y < (E1.Top - distancia))
      then begin
        tmp := E1;
        E1 := E2;
        E2 := TMP;
      end;
      if Orientacao = OrientacaoV then
      begin
        PontoInicial1 := E1.Encaixe[4];
        PontoFinal1 := Point(PontoInicial1.X, E2.Encaixe[1].Y);
        PontoInicial2 := PontoFinal1;
        PontoFinal2 := E2.Encaixe[1];
        AtiveLinha(LinhaA, Point(PontoInicial1.X -3, PontoInicial1.Y), Point(PontoFinal1.X -3, PontoFinal1.Y), OrientacaoV);
        AtiveLinha(LinhaB, Point(PontoInicial2.X, PontoInicial2.Y -3), Point(PontoFinal2.X, PontoFinal2.Y -3), OrientacaoH);
        Mapa(4, 1);
      end
      else
      begin
        PontoInicial1 := E1.Encaixe[3];
        PontoFinal1 := Point(E2.Encaixe[2].X, PontoInicial1.Y);
        PontoInicial2 := PontoFinal1;
        PontoFinal2 := E2.Encaixe[2];
        AtiveLinha(LinhaA, Point(PontoInicial1.X, PontoInicial1.Y -3), Point(PontoFinal1.X, PontoFinal1.Y -3), OrientacaoH);
        AtiveLinha(LinhaB, Point(PontoInicial2.X -3, PontoInicial2.Y), Point(PontoFinal2.X -3, PontoFinal2.Y), OrientacaoV);
        Mapa(3, 2);
      end;
      exit;
    end;

    if ((E1.Encaixe[3].X < (E2.Left - distancia)) and (E2.Encaixe[4].Y < (E1.Top - distancia))) or
       ((E2.Encaixe[3].X < (E1.Left - distancia)) and (E1.Encaixe[4].Y < (E2.Top - distancia))) then
    begin
      if (E2.Encaixe[3].X < (E1.Left - distancia)) and (E1.Encaixe[4].Y < (E2.Top - distancia))
      then begin
        tmp := E1;
        E1 := E2;
        E2 := TMP;
      end;
      if Orientacao = OrientacaoH then
      begin
        PontoInicial1 := Point(E1.Encaixe[2].X, E2.Encaixe[1].Y);
        PontoFinal1 := E1.Encaixe[2];
        PontoInicial2 := PontoInicial1;
        PontoFinal2 := E2.Encaixe[1];
        AtiveLinha(LinhaA, Point(PontoInicial1.X -3, PontoInicial1.Y), Point(PontoFinal1.X -3, PontoFinal1.Y), OrientacaoV);
        AtiveLinha(LinhaB, Point(PontoInicial2.X, PontoInicial2.Y -3), Point(PontoFinal2.X, PontoFinal2.Y -3), OrientacaoH);
        Mapa(2, 1);
      end
      else
      begin
        PontoInicial1 := E1.Encaixe[3];
        PontoFinal1 := Point(E2.Encaixe[4].X, PontoInicial1.Y);
        PontoInicial2 := E2.Encaixe[4];
        PontoFinal2 := PontoFinal1;
        AtiveLinha(LinhaA, Point(PontoInicial1.X, PontoInicial1.Y -3), Point(PontoFinal1.X + 1, PontoFinal1.Y -3), OrientacaoH);
        AtiveLinha(LinhaB, Point(PontoInicial2.X -3, PontoInicial2.Y), Point(PontoFinal2.X -3, PontoFinal2.Y + 1), OrientacaoV);
        Mapa(3, 4);
      end;
      exit;
    end;

    if ((E1.Top + E1.Height) < (E2.Top -4)) or
       ((E2.Top + E2.Height) < (E1.Top -4)) then
    begin
      if (E2.Top + E2.Height) < (E1.Top -4)
      then begin
        tmp := E1;
        E1 := E2;
        E2 := TMP;
      end;
      PontoInicial1 := E1.Encaixe[4];
      PontoFinal1 := Point(PontoInicial1.X, E2.Top - ((E2.Top - E1.Encaixe[4].Y) div 2));
      PontoInicial2 := Point(E2.Encaixe[2].X, PontoFinal1.Y);
      PontoFinal2 := E2.Encaixe[2];
      AtiveLinha(LinhaA, Point(PontoInicial1.X -3, PontoInicial1.Y), Point(PontoFinal1.X -3, PontoFinal1.Y), OrientacaoV);
      AtiveLinha(LinhaB, Point(PontoInicial2.X -3, PontoInicial2.Y), Point(PontoFinal2.X -3, PontoFinal2.Y + 1), OrientacaoV);
      AtiveLinha(LinhaMeio, Point(PontoFinal1.X, PontoFinal1.Y -3), Point(PontoInicial2.X, PontoInicial2.Y -3), OrientacaoH);
      Mapa(4, 2);
      exit;
    end;

    if ((E1.Left + E1.Width) < (E2.Left -4)) or
       ((E2.Left + E2.Width) < (E1.Left -4)) then
    begin
      if (E2.Left + E2.Width) < (E1.Left -4)
      then begin
        tmp := E1;
        E1 := E2;
        E2 := TMP;
      end;
      PontoInicial1 := E1.Encaixe[3];
      PontoFinal1 := Point(E2.Left - ((E2.Left - E1.Encaixe[3].X) div 2) , PontoInicial1.Y);
      PontoInicial2 := Point(PontoFinal1.X, E2.Encaixe[1].Y);
      PontoFinal2 := E2.Encaixe[1];
      AtiveLinha(LinhaA, Point(PontoInicial1.X, PontoInicial1.Y -3), Point(PontoFinal1.X, PontoFinal1.Y -3), OrientacaoH);
      AtiveLinha(LinhaB, Point(PontoInicial2.X, PontoInicial2.Y -3), Point(PontoFinal2.X, PontoFinal2.Y -3), OrientacaoH);
      AtiveLinha(LinhaMeio, Point(PontoFinal1.X - 3, PontoFinal1.Y), Point(PontoInicial2.X - 3, PontoInicial2.Y), OrientacaoV);
      Mapa(3, 1);
      exit;
    end;

    if Orientacao = OrientacaoH then
    begin
      if E1.Left <= E2.Left then
      begin
        pE1 := 3;
        if E1.Top <= E2.Top then pE2 := 2 else pE2 := 4;
      end else
      begin
        pE1 := 1;
        if E1.Top <= E2.Top then pE2 := 2 else pE2 := 4;
      end;
      PontoInicial1 := E1.Encaixe[pE1];
      PontoFinal1 := Point(E2.Encaixe[pE2].X, PontoInicial1.Y);
      PontoInicial2 := PontoFinal1;
      PontoFinal2 := E2.Encaixe[pE2];
      AtiveLinha(LinhaA, Point(PontoInicial1.X, PontoInicial1.Y -3), Point(PontoFinal1.X, PontoFinal1.Y -3), OrientacaoH);
      AtiveLinha(LinhaB, Point(PontoInicial2.X -3, PontoInicial2.Y), Point(PontoFinal2.X -3, PontoFinal2.Y), OrientacaoV);
      Mapa(pE1, pE2);
    end else
    begin
      if E1.Left <= E2.Left then
      begin
        pE2 := 1;
        if E1.Top <= E2.Top then pE1 := 4 else pE1 := 2;
      end else
      begin
        pE2 := 3;
        if E1.Top <= E2.Top then pE1 := 4 else pE1 := 2;
      end;
      PontoInicial1 := E1.Encaixe[pE1];
      PontoFinal1 := Point(E2.Encaixe[pE2].X, PontoInicial1.Y);
      PontoInicial2 := PontoFinal1;
      PontoFinal2 := E2.Encaixe[pE2];
      AtiveLinha(LinhaA, Point(PontoInicial1.X, PontoInicial1.Y -3), Point(PontoFinal1.X, PontoFinal1.Y -3), OrientacaoH);
      AtiveLinha(LinhaB, Point(PontoInicial2.X -3, PontoInicial2.Y), Point(PontoFinal2.X -3, PontoFinal2.Y), OrientacaoV);
      Mapa(pE1, pE2);
    end;
  end;
end;

constructor TLigacao.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TBase then Modelo := TBase(AOwner).Modelo;
  if AOwner is TModelo then Modelo := TModelo(AOwner);
  LinhaA := TLinha.Create(Self);
  LinhaA.Movimentavel := false;
  LinhaB := TLinha.Create(Self);
  LinhaB.Movimentavel := false;
  LinhaA.Visible := false;
  LinhaB.Visible := false;
  LinhaMeio := TLinha.Create(Self);
  LinhaMeio.Movimentavel := false;
  LinhaMeio.Visible := false;
  FOrientacao := OrientacaoV;
  LinhaA.onNovaOrientacao := OnNovaHorientacao;
  LinhaB.onNovaOrientacao := OnNovaHorientacao;
  LinhaMeio.onNovaOrientacao := OnNovaHorientacao;
  LinhaA.OnClick := OnLinhaClick;
  LinhaB.OnClick := OnLinhaClick;
  LinhaMeio.OnClick := OnLinhaClick;
  LinhaA.OnMouseDown := OnLinhaMouseDown;
  LinhaB.OnMouseDown := OnLinhaMouseDown;
  LinhaMeio.OnMouseDown := OnLinhaMouseDown;
  if (not Modelo.staLoading) then
  begin
    Card := TCardinalidade.Create(Modelo);
    Card.Comando := Self;
    Card.Visible := false;
  end;
  LinhaA.OnMouseEnter := OnLinhaMouseEnter;
  LinhaB.OnMouseEnter := OnLinhaMouseEnter;
  LinhaMeio.OnMouseEnter := OnLinhaMouseEnter;
  LinhaA.OnMouseLeave := OnLinhaMouseLeave;
  LinhaB.OnMouseLeave := OnLinhaMouseLeave;
  LinhaMeio.OnMouseLeave := OnLinhaMouseLeave;
end;

function TLigacao.Generate(lE1, lE2: TBase): Boolean;
begin
  E1 := lE1;
  E2 := lE2;
  Pai := E1;
  Ponta := E2;
  Result := Ative;
end;

procedure TLigacao.SetE1(const Value: TBase);
begin
  FE1 := Value;
//  Ative;
end;

procedure TLigacao.SetE2(const Value: TBase);
begin
  FE2 := Value;
//  Ative;
end;

procedure TLigacao.SetModelo(const Value: TModelo);
begin
  FModelo := Value;
end;

procedure TLigacao.SetOrientacao(const Value: integer);
begin
  FOrientacao := Value;
  Muda;
end;

procedure TLigacao.OnNovaHorientacao(Linha: TObject);
begin
  if not(Linha is TLinha) then exit;
  if Orientacao = OrientacaoH then Orientacao := OrientacaoV else Orientacao := OrientacaoH;
  Ative;
  E1.OnMoved(E1);
end;

destructor TLigacao.destroy;
begin
  if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
  begin
//    FreeAndNil(linhaA);
//    FreeAndNil(linhaB);
//    FreeAndNil(linhaMeio);
    if Assigned(FCard) then FreeAndNil(FCard);
  end;
  inherited;
end;

procedure TLigacao.SetAtualizando(const Value: boolean);
begin
  FAtualizando := Value;
  LinhaA.Atualizando := FAtualizando;
  LinhaB.Atualizando := FAtualizando;
  LinhaMeio.Atualizando := FAtualizando;
end;

function TLigacao.BasePertence(B: TBase): boolean;
begin
  Result := (B = FE1) or (B = FE2);
end;

procedure TLigacao.SetMostraCardinalidade(const Value: boolean);
begin
  if Value = FMostraCardinalidade then exit;
  FMostraCardinalidade := Value;
  if Value then
    if not Assigned(FCard) then
  begin
    FCard := TCardinalidade.Create(Modelo);
    FCard.Comando := Self;
    PosicioneCardinalidade;
  end;
  FCard.Visible := true;
end;

procedure TLigacao.SetCard(const Value: TCardinalidade);
begin
  FCard := Value;
end;

procedure TLigacao.SetCardinalidade(const value :Integer);
begin
  if GetCardinalidade = Value then exit;
  Muda;
  MostraCardinalidade := (Value > 0) and (Value < 5);
  if Assigned(FCard) then FCard.ToCardinalidade(Value);
  PosicioneCardinalidade;
end;

procedure TLigacao.PosicioneCardinalidade;
  var ET: TBase;
      P, aLeft, aTop: Integer;
      bkp: Boolean;
begin
  if (not MostraCardinalidade) or (not Assigned(Fcard)) then exit;
  if FCard.Fixa then Exit;
  if (Modelo.FMultSelecao.Count > 0) and ((Modelo.Selecionado = FCard) or (Modelo.FMultSelecao.IndexOf(FCard) > -1)) then exit;

  if (BaseInicial is TBaseEntidade) or (BaseFinal is TBaseEntidade) or
     (BaseInicial is TTabela) or (BaseFinal is TTabela) then
  begin
    if (BaseInicial is TBaseEntidade) or (BaseInicial is TTabela) then
    begin
      ET := BaseInicial;
      P := PontoInicial;
    end
    else
    begin
      ET := BaseFinal;
      P := PontoFinal;
    end;
//    if (not Assigned(ET)) or (P = 0) then Exit;
    if (FCard.Modelo.FMultSelecao.IndexOf(FCard) > -1) or
       (FCard.Selecionado and (FCard.Modelo.FMultSelecao.Count > 0)) then exit;
    aLeft := ET.encaixe[p].X;
    aTop := ET.encaixe[p].Y - FCard.Height + 5;
    case p of
      1: aLeft := aLeft - FCard.Width + 2;
      2: aTop := aTop;
      4: aTop := aTop + FCard.Height -4;
    end;
    bkp := FCard.Selecionado;
    FCard.Selecionado := false;
    FCard.Atualizando := true;
    FCard.SetBounds(aLeft, aTop, FCard.Width, FCard.Height);
    FCard.Atualizando := False;
    FCard.Selecionado := bkp;
  end;
end;

procedure TLigacao.SetSuspendLineMove(const Value: boolean);
begin
  FSuspendLineMove := Value;
end;

procedure TLigacao.Set_Comando(const Value: TResultIArray);
  var b: Boolean;
begin
  FOrientacao := Value[0];
  FAtualizando := false;
  FE1 := Modelo.FindByID(Value[1]);
  FE2 := Modelo.FindByID(Value[2]);

  if Value[7] = Value[2] then
  begin
    Pai := E1;
    Ponta := E2;
  end else
  begin
    Pai := E2;
    Ponta := E1;
  end;

  Pai.FLigacoes.Add(Self);
  Ponta.FLigacoes.Add(Self);
  BaseInicial := FE1;
  BaseFinal := FE1;

  FMostraCardinalidade := Boolean(Value[3]);
  B := boolean(Value[4]);

  LinhaA.FisWeak := B;
  LinhaB.FisWeak := B;
  LinhaMeio.FisWeak := B;

  B := Boolean(Value[5]);
  LinhaA.FMovimentavel := B;
  LinhaB.FMovimentavel := B;
  LinhaMeio.FMovimentavel := B;

  LinhaA.FLargura := Value[6];
  LinhaB.FLargura := Value[6];
  LinhaMeio.FLargura := Value[6];

  LinhaA.FInicio.X := Value[11];
  LinhaA.FInicio.Y := Value[12];
  LinhaA.FFim.X := Value[13];
  LinhaA.FFim.Y := Value[14];

  LinhaB.FInicio.X := Value[15];
  LinhaB.FInicio.Y := Value[16];
  LinhaB.FFim.X := Value[17];
  LinhaB.FFim.Y := Value[18];

  LinhaMeio.FInicio.X := Value[19];
  LinhaMeio.FInicio.Y := Value[20];
  LinhaMeio.FFim.X := Value[21];
  LinhaMeio.FFim.Y  := Value[22];

  PontoInicial1.X := Value[23];
  PontoInicial1.Y := Value[24];
  PontoInicial2.X := Value[25];
  PontoInicial2.Y := Value[26];
  PontoFinal1.X := Value[27];
  PontoFinal1.Y := Value[28];
  PontoFinal2.X := Value[29];
  PontoFinal2.Y := Value[30];
  PontoInicial := Value[31];
  PontoFinal := Value[32];

  LinhaA.Visible := Boolean(Value[33]);
  LinhaB.Visible := Boolean(Value[34]);
  LinhaMeio.Visible := Boolean(Value[35]);

  LinhaA.Orientacao := Value[8];
  LinhaB.Orientacao := Value[9];
  LinhaMeio.Orientacao := Value[10];
end;

procedure TLigacao.OnLinhaClick(Linha: TObject);
begin
  if Assigned(FCard) then
  begin
    PostMessage(Modelo.Handle, CM_BASECLICK, integer(FCard), 0);
  end;
end;

procedure TLigacao.OnLinhaMouseDown(Linha: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var BToSel: TBase;
begin
  if not Assigned(FCard) or (not FCard.Visible) then BToSel := Pai else BToSel := FCard;
  if (ssCtrl in Shift) or (ssShift in Shift) then
  begin
    Modelo.AddSelect(BToSel);
  end
  else begin
    if (Modelo.FMultSelecao.IndexOf(BToSel) = -1) and (Modelo.Selecionado <> BToSel) then
    begin
      Modelo.Selecionado := BToSel;
      Modelo.ClearSelect;
    end;
  end;
end;

procedure TLigacao.OnLinhaMouseEnter(Linha: TObject);
begin
  OnLinhaMouseEvento(True);
end;

procedure TLigacao.OnLinhaMouseEvento(entrou: boolean);
begin
  if Assigned(Pai) then Pai.LigacaoEventoDoMouse(entrou);
end;

procedure TLigacao.OnLinhaMouseLeave(Linha: TObject);
begin
  OnLinhaMouseEvento(false);
end;

function TLigacao.GetFraca: boolean;
begin
  Result := LinhaA.isWeak;
end;

function TLigacao.Get_Comando: TResultIArray;
begin
//  SetLength(Result, 18);
  Result[0] := Orientacao;
  Result[1] := E1.OID;
  Result[2] := E2.OID;
  BaseInicial := E1;
  BaseFinal := E2;

  Result[3] := Integer(MostraCardinalidade);
  Result[4] := Integer(Fraca);
  Result[5] := Integer(LinhaA.Movimentavel);
  Result[6] := LinhaA.Largura;
  Result[7] := Ponta.OID;

  Result[8] := LinhaA.Orientacao;
  Result[9] := LinhaB.Orientacao;
  Result[10] := LinhaMeio.Orientacao;

  Result[11] := LinhaA.FInicio.X;
  Result[12] := LinhaA.FInicio.Y;
  Result[13] := LinhaA.FFim.X;
  Result[14] := LinhaA.FFim.Y;

  Result[15] := LinhaB.FInicio.X;
  Result[16] := LinhaB.FInicio.Y;
  Result[17] := LinhaB.FFim.X;
  Result[18] := LinhaB.FFim.Y;

  Result[19] := LinhaMeio.FInicio.X;
  Result[20] := LinhaMeio.FInicio.Y;
  Result[21] := LinhaMeio.FFim.X;
  Result[22] := LinhaMeio.FFim.Y;

  Result[23] := PontoInicial1.X;
  Result[24] := PontoInicial1.Y;
  Result[25] := PontoInicial2.X;
  Result[26] := PontoInicial2.Y;
  Result[27] := PontoFinal1.X;
  Result[28] := PontoFinal1.Y;
  Result[29] := PontoFinal2.X;
  Result[30] := PontoFinal2.Y;
  Result[31] := PontoInicial;
  Result[32] := PontoFinal;

  Result[33] := Integer(LinhaA.Visible);
  Result[34] := Integer(LinhaB.Visible);
  Result[35] := Integer(LinhaMeio.Visible);

end;

procedure TLigacao.SetFraca(const Value: boolean);
begin
  if (LinhaA.isWeak <> Value) then Muda;
  LinhaA.isWeak := Value;
  LinhaB.isWeak := Value;
  LinhaMeio.isWeak := Value;
end;

procedure TLigacao.to_xml(node: IXMLNode);
 var lnode: IXMLNode;
begin
  node := node.AddChild('Ligacao');
  node.Attributes['Destino_ID'] := Ponta.OID;
  lnode := node.AddChild('MostraCardinalidade');
  lnode.Attributes['Valor'] := BoolToStr(MostraCardinalidade);
  lnode.Attributes['Card_id'] := FCard.OID;
  lnode := node.AddChild('Cardinalidades');
  lnode.Attributes['Cardinalidade'] := Cardinalidade;
  if MostraCardinalidade then FCard.to_xml(lnode);
  lnode := node.AddChild('Orientacao');
  lnode.Attributes['Valor'] := Orientacao;
  lnode := node.AddChild('Fraca');
  lnode.Attributes['Valor'] := BoolToStr(Fraca);
end;

function TLigacao.MePonto(Eu: TBase): integer;
begin
  Result := IfThen(BaseInicial = Eu, PontoInicial, PontoFinal);
end;

procedure TLigacao.Muda;
begin
  Modelo.Mudou := true;
end;

function TLigacao.GetCardinalidade: Integer;
begin
  Result := 0;
  if Assigned(FCard) then Result := FCard.Cardinalidade;
end;

{ TEntidadeAssoss }

constructor TEntidadeAssoss.Create(AOwner: TComponent);
begin
  inherited;
  if not (csReading in Modelo.ComponentState) then
  begin
    FRelacao := TChildRelacao.Create(Modelo);
    FRelacao.SendToBack;

    // Início TCC II - Puc (MG) - Daive Simões
    // Retirados os sinais de pontuação do nome base da entidade associativa
    FRelacao.Nome := Modelo.GeraBaseNome('Relacao');
    // Fim TCC II

    FRelacao.Pai := self;
  end;
  Width := Width + (Width div 4);
end;

destructor TEntidadeAssoss.destroy;
begin
  if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
  begin
    FreeAndNil(FRelacao);
  end;
  inherited;
end;

function TEntidadeAssoss.GetRelacaoNome: String;
begin
  Result := Relacao.Nome;
end;

function TEntidadeAssoss.GetRelecaoDicionario: String;
begin
  Result := Relacao.Dicionario;
end;

function TEntidadeAssoss.GetRelecaoObservacao: String;
begin
  Result := Relacao.Observacoes;
end;

function TEntidadeAssoss.GetSetaDirecao: Integer;
begin
  Result := Relacao.SetaDirecao;
end;

function TEntidadeAssoss.Get_ChildRelacao: integer;
begin
  if Relacao <> nil then Result := Relacao.OID else Result := -1;
end;

procedure TEntidadeAssoss.Load;
begin
  inherited;
  FRelacao := TChildRelacao(Modelo.FindByID(_FChildRelacao));
//  FRelacao.Nome := _RelacaoNome;
//  FRelacao.Dicionario := _RelecaoDicionario;
//  FRelacao.Observacoes := _RelecaoObservacao;
  FRelacao.SendToBack;
  FRelacao.Pai := self;
//  FRelacao.SetaDirecao := _SetaDirecao;
end;

procedure TEntidadeAssoss.OrganizeAtributos;
begin
  inherited;
  Relacao.OrganizeAtributos;
end;

procedure TEntidadeAssoss.Paint;
  var Rect: TRect;
      oNome: String;
begin
  if (Atualizando) then exit;
  with canvas do
  begin
    Pen.Style:=psSolid;
    Pen.Color := TColor(-5);
    MoveTo(0, 0);
    LineTo(0, height-3);
    LineTo(width-3, height-3);
    LineTo(width-3, 0);
    LineTo(0, 0);
    Pen.Style:=psSolid;
    Pen.Color:=$00707070;
    MoveTo(width-2, 0);
    LineTo(width-2, height-2);
    LineTo(0, height-2);
    Pen.Color:=$00B3B3B3;
    MoveTo(width-1, 0);
    LineTo(width-1, height-1);
    LineTo(0, height-1);

    Rect := GetClientRect;
    Rect.Top := Rect.Top + 1;

    oNome := ControlaCaption(Canvas, self.Width -4, Nome);

    Rect.Bottom := conta13(oNome) * TextHeight('W') + 1;
    Rect.Right := Rect.Right - 4;
    Brush.Style := bsClear;
    DrawText(Handle, PChar(oNome), -1, Rect, DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS);
  end;
end;

procedure TEntidadeAssoss.SendClick;
begin
  if Assigned(Modelo.onBaseMouseMove) then
    if Relacao.isMine(Mouse.CursorPos)
    and (Modelo.Ferramenta in [Tool_Atributo, Tool_AtributoComp,
                               Tool_AtributoMult, Tool_AtributoOpc,
                               Tool_AtributoID, Tool_Ligacao, Tool_Ligacao2]) then
  begin
    PostMessage(Modelo.Handle, CM_BASECLICK, integer(FRelacao), 0);
  end
  else begin
    PostMessage(Modelo.Handle, CM_BASECLICK, integer(Self), 0);
  end;
end;

procedure TEntidadeAssoss.SendMouseMove;
begin
  if Assigned(Modelo.onBaseMouseMove) then
    if Relacao.isMine(Mouse.CursorPos) then
      Modelo.onBaseMouseMove(FRelacao)
    else
      Modelo.onBaseMouseMove(Self);
end;

procedure TEntidadeAssoss.SetAtualizando(const Value: Boolean);
begin
  inherited;
  if Assigned(Relacao) then Relacao.Atualizando := Atualizando;
end;

procedure TEntidadeAssoss.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
  var Rect: TRect;
begin
  inherited;
  if Assigned(FRelacao) then
  begin
    Rect := ClientRect;
    InflateRect(Rect, -15, -15);
    FRelacao.SetBounds(Rect.Left + Left, Rect.Top + Top, Rect.Right -15, Rect.Bottom -15);
  end;
end;

procedure TEntidadeAssoss.SetRelacaoNome(const Value: String);
begin
  if Relacao <> nil then Relacao.Nome := Value;
end;

procedure TEntidadeAssoss.SetRelecaoDicionario(const Value: String);
begin
  if Relacao <> nil then Relacao.Dicionario := Value;
end;

procedure TEntidadeAssoss.SetRelecaoObservacao(const Value: String);
begin
  if Relacao <> nil then Relacao.Observacoes := Value;
end;

procedure TEntidadeAssoss.SetSetaDirecao(const Value: Integer);
begin
  if Relacao <> nil then Relacao.SetaDirecao := Value;
end;

procedure TEntidadeAssoss.to_xml(var node: IXMLNode);
begin
  inherited to_xml(node);
  Relacao.to_xml(node);
end;

{ TAutoRelacao }

function TAutoRelacao.CanLiga(B: TBase): boolean;
  var i, J: Integer;
begin
  J := 0;
  Result := true;
  for i := 0 to FLigacoes.Count -1 do
    if (FLigacoes[i] is TLigacao) and (Assigned(FLigacoes[i])) then
      if TLigacao(FLigacoes[i]).BasePertence(B) then
      begin
        inc(J);
        if j > 1 then Result := false;
      end;
end;

procedure TAutoRelacao.PrepareToAtive(Lg: TLigacao);
  var T, nVl, P : integer;
      L1, L2: TLigacao;
  function Menor: TLigacao;
  begin
    if L1.Ponta.FLigacoes.IndexOf(L1) < L1.Ponta.FLigacoes.IndexOf(L2) then
      Result := L1 else Result := L2;
  end;
  function triagulo: integer;
    var aa, A, B: integer;
    C, X: Real;
  begin
    if (MyPosi = 1) or (MyPosi = 3) then
    begin
      B := Height div 2;
      A := Width div 2;
    end else
    begin
      A := Height div 2;
      B := Width div 2;
    end;
    C := sqrt((A * A) + (B * B));
    aa := nVl;
    x := (C * aa) / B;
    Result := TRUNC(sqrt((x*x)-(aa*aa)));
  end;
begin
  inherited;
  if not Assigned(FLigacoes) then Exit;
  nVl := Lg.Ponta.LastTamanhoOrigem.X div 2;
  P := Lg.Ponta.LastTamanhoOrigem.Y;
  if nvl = 0 then exit;
  AtualizaEncaixes;
  if (FLigacoes.IndexOf(Lg) > 1) or (FLigacoes.Count < 2) then exit;
  L1 := TLigacao(FLigacoes[0]);
  L2 := TLigacao(FLigacoes[1]);
  if (MyPosi = 1) or (MyPosi = 3) then
  begin
    if (nVl * 2) > Height then nVl := Height div 2;
  end else
  begin
    if (nVl * 2) > Width then nVl := Width div 2;
  end;
  T := triagulo;
  if Menor = Lg then nvl := -nvl;
  if QuantosNestePonto(MyPosi) > 1 then
  case MyPosi of
  1:
    begin
      if p = 4 then nVl := -nVl;
      Encaixe[MyPosi].Y := Encaixe[MyPosi].Y + nVl;
      Encaixe[MyPosi].X := T + Left;
    end;
  3:
    begin
      if p = 2 then nVl := -nVl;
      Encaixe[MyPosi].Y := Encaixe[MyPosi].Y + nVl;
      Encaixe[MyPosi].X := Left + Width - T;
    end;
  2:
    begin
      if p = 3 then nVl := -nVl;
      Encaixe[MyPosi].X := Encaixe[MyPosi].X + nVl;
      Encaixe[MyPosi].Y := Top + T;
    end;
  4:
    begin
      if p = 1 then nVl := -nVl;
      Encaixe[MyPosi].X := Encaixe[MyPosi].X + nVl;
      Encaixe[MyPosi].Y := Top + Height - T;
    end;
  end;
end;

procedure TAutoRelacao.NeedPaint;
begin
  if MyPosi <> Posi then
  begin
    MyPosi := Posi;
  end;
end;

function TAutoRelacao.Posi: Integer;
begin
  Result := 0;
  if (Assigned(FLigacoes)) and (FLigacoes.Count > 0) then
    Result := TLigacao(FLigacoes[0]).MePonto(Self);
end;

procedure TAutoRelacao.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if Assigned(FLigacoes) and (FLigacoes.Count > 1) then
  begin
    NeedPaint;
  end;
end;

destructor TAutoRelacao.destroy;
begin
  if Assigned(FLigacoes) and (FLigacoes.Count > 0) then
    TBaseEntidade(TLigacao(FLigacoes[0]).Ponta).FAutoRelacao := nil;
  inherited;
end;

procedure TAutoRelacao.Load;
begin
  inherited;
end;

{ TAtributo }

procedure TAtributo.AtualizaEncaixes;
begin
  Inherited;
  if Orientacao = OrientacaoD then
  begin
    Encaixe[1] := Encaixe[3];
    Encaixe[2] := Encaixe[3];
    Encaixe[4] := Encaixe[3];
  end
  else
  begin
    Encaixe[2] := Encaixe[1];
    Encaixe[3] := Encaixe[1];
    Encaixe[4] := Encaixe[1];
  end;
end;

constructor TAtributo.Create(AOwner: TComponent);
begin
  inherited;
  FLigacoes.OwnsObjects := true;
  FAltura := 16;
  FMaxCard := 1;
  FMinCard := 1;

  // Início TCC II - Puc (MG) - Daive Simões
  // inicializa o tipo do atributo como sendo VARCHAR
  FTipoDoValor       := 'VARCHAR( )';

  // Inicializa a quantidade padrão de campos a serem criados para atributos
  // multivalorados
  FQtdeMultivalorado := 5;
  FComplemento       := '10';
  // Fim TCC II


  if not (csReading in Modelo.ComponentState) then
    FBarra := TBarraDeAtributos.Create(Modelo, Self);
  FOrientacao := OrientacaoE;
  FDesvio := 10;
end;

constructor TAtributo.Create(AOwner: TComponent; oDono: Tbase);
begin
  Create(AOwner);
  Dono := oDono;
  if Assigned(FDono) then FDono.FAtributos.Add(Self);
end;

procedure TAtributo.dblClick;
begin
  inherited;
  Identificador := not Identificador;
end;

procedure TAtributo.Organize;
var aHeight, aWidth: integer;
    bkp: boolean;
begin
  if (Selecionado and (Modelo.FMultSelecao.Count > 0))
    or (Modelo.FMultSelecao.IndexOf(Self) > -1) then exit;
  bkp := Selecionado;
  Selecionado := False;
  if Canvas.TextHeight('H') < Altura then aHeight := Altura else aHeight := Canvas.TextHeight('H');
  aWidth := aHeight + 8 + Canvas.TextWidth(Nome) + 3;
  if Multivalorado then aWidth := aWidth + Canvas.TextWidth(' ' + CardStr);
  SetBounds(Left, Top, aWidth, aHeight);
  OrganizeAtributos;
  Selecionado := bkp;
end;

procedure TAtributo.Paint;
  var rect: TRect;
      I, P, Meio, Ponto : integer;
      tmp: string;
      cor: TColor;
begin
  if not Assigned(Barra) then exit;

  if TamAuto then SetTamAuto(true);
  Ponto := Posi;
  if (Ponto = 1) Then Orientacao := OrientacaoE;
  if (Ponto = 3) Then Orientacao := OrientacaoD;
  if (Atualizando) then exit;
  with canvas do
  begin
    tmp := Nome;
    if Multivalorado then tmp := tmp + ' ' + CardStr;
    Pen.Style:=psSolid;
    Pen.Color := TColor(-5);
    Rect := GetClientRect;
    I := TextHeight('W');
    with Rect do
    begin
      Left := Height + 5;
      Top := (((Bottom + Top) - I) div 2) - 1;
      Bottom := Top + I;
    end;
    P := Height -3;
    Meio := ((P -1) div 2) + 2;
    Brush.Color := $00963636;
    if Identificador then Brush.Style := bsSolid else Brush.Style:= bsClear;
    if Orientacao = OrientacaoE then
    begin
      MoveTo(0, Meio);
      LineTo(5, Meio);
      Ellipse(5, 0, P + 5, P);
      if (Barra.Atributos.Count > 0) then
        Rectangle(Width -4, (Height -4) div 2, Width, (Height +4) div 2);
      Brush.Style := bsClear;
      DrawText(Handle, PChar(tmp), -1, Rect, DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS);
      I := 0;
    end
    else
    begin
      Rect.left := 0;
      rect.Right := rect.Right - (P + 8);
      MoveTo(Width -5, Meio);
      LineTo(Width, Meio);
      Ellipse(Width - (P + 5), 0, Width -5, P);
      if (Barra.Atributos.Count > 0) then
        Rectangle(0, (Height -4) div 2, 4, (Height +4) div 2);
      Brush.Style := bsClear;
      DrawText(Handle, PChar(tmp), -1, Rect, DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS);
      I := Width - TextWidth('*');
    end;
    if Composto then
    begin
      cor := Font.Color;
      Font.Color := clBlue;
      TextOut(I, 0, '*');
      Font.Color := cor;
    end;
  end;
end;

function TAtributo.Posi: Integer;
begin
  Result := 0;
  if Assigned(FLigacoes) and (FLigacoes.Count > 0) then
    Result := TLigacao(FLigacoes[0]).MePonto(Self);
end;

procedure TAtributo.SetAltura(const Value: Integer);
begin
  FAltura := Value;
end;

procedure TAtributo.SetTamAuto(const Value: boolean);
  var aHeight, aWidth, aLeft: integer;
begin
  if (FTamAuto <> Value) then Muda;
  FTamAuto := Value;
  if not Value then exit;
  if Canvas.TextHeight('H') < Altura then aHeight := Altura else aHeight := Canvas.TextHeight('H');
  aWidth := aHeight + 8 + Canvas.TextWidth(Nome) + 3;
  if Multivalorado then aWidth := aWidth + Canvas.TextWidth(' ' + CardStr);
  if (aWidth <> Width) or (aHeight <> Height) then
  begin
    aLeft := Left;
    if Orientacao = OrientacaoD then aLeft := aLeft - (aWidth - Width);
    SetBounds(aLeft, Top, aWidth, aHeight);
    reposicione;
  end;
end;

procedure TAtributo.SetCardinalidade(const Value: Integer);
begin
  if (Value > 0) and (Value < 5) then
  begin
    case Value of
      1, 2: MaxCard := 1;
      else MaxCard := 21;
    end;
    case Value of
      1, 3: MinCard := 1;
      else MinCard := 0;
    end;
  end;
end;

procedure TAtributo.SetDono(const Value: TBase);
  var L : TLigacao;
begin
  if Assigned(FDono) then LiberarLinhas; //FLigacoes.Delete(0);
  FDono := Value;
  if Assigned(FDono) then
  begin
    L := TLigacao.Create(Modelo);
    if CanLiga(FDono) then
    begin
      FDono.Liga(L);
      L.Generate(Self, FDono);
      FLigacoes.Add(L);
    end
    else FreeAndNil(L);
  end;
end;

procedure TAtributo.SetIdentificador(const Value: Boolean);
begin
  if (FIdentificador <> Value) then Muda;
  FIdentificador := Value;
  Invalidate;
end;

procedure TAtributo.SetMultivalorado(const Value: boolean);
begin
  if (FMultivalorado <> Value) then Muda;
  FMultivalorado := Value;
  if Value then Cardinalidade := 3 else
  begin
    FMaxCard := 1;
    FMinCard := 1;
  end;
  if TamAuto then SetTamAuto(true) else Invalidate;
end;

procedure TAtributo.SetOrientacao(const Value: Integer);
begin
  if Modelo.FDisableSelecao then exit;
  if FOrientacao = Value then Exit;
  Muda;
  FOrientacao := Value;
  AtualizaEncaixes;
  if Assigned(Barra) then Barra.posicione;
  Repaint;
  //Invalidate;
end;

procedure TAtributo.Realinhe;
  var L: TLigacao;
begin
  if FLigacoes.Count > 0 then
  begin
    L := TLigacao(FLigacoes[0]);
    if Assigned(L) and not (L.Ponta is TBaseEntidade) then L.Ative else
    begin
      L.SuspendLineMove := true;
      L.Ative;
      L.SuspendLineMove := False;
    end;
  end;
end;

destructor TAtributo.destroy;
begin
  if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
  begin
    if Assigned(FDono) and (not FDono.Destruindo) then
    begin
      FDono.FAtributos.Remove(Self);
      //FDono.OrganizeAtributos;
    end;
    FBarra.Free;
  end;
  inherited;
end;

procedure TAtributo.SetTipoDoValor(const Value: String);
begin
  if (FTipoDoValor <> Value) then Muda;
  FTipoDoValor := Value;
end;

procedure TAtributo.Set_Dono(const Value: Integer);
begin
  _FDono := Value;
end;

function TAtributo.GetMultivalorado: boolean;
begin
  Result := FMultivalorado;
end;

function TAtributo.Get_Dono: Integer;
begin
  if Assigned(FDono) then Result := FDono.OID else Result := -1;
end;

procedure TAtributo.Load;
begin
  inherited;
  FDono := Modelo.FindByID(_FDono);
  if Assigned(FDono) then FDono.FAtributos.Add(Self);
  Invalidate;
end;

function TAtributo.getComposto: boolean;
begin
  Result := (AOcultos.AtributosOcultos.Count > 0) OR (Barra.Atributos.Count > 0);
end;

procedure TAtributo.SetOpcional(const Value: boolean);
begin
  if (Opcional <> Value) then Muda;
  if Value then
  begin
    MinCard := 0;
//    FMultivalorado := true;
  end else
  begin
    MinCard := 1;
//    FMultivalorado := false;
  end;
//  if Value and (not Modelo.FDisableSelecao) then Modelo.Erro(self, 'Analise a possibilidade do uso de especialização!', 1);
end;

procedure TAtributo.to_xml(var node: IXMLNode);
 var lnode: IXMLNode;
begin
  inherited to_xml(node);
//  lnode := node.AddChild('Card');
//  lnode.Attributes['Valor'] := Cardinalidade;

  lnode := node.AddChild('MaxCard');
  lnode.Attributes['Valor'] := MaxCard;
  lnode := node.AddChild('MinCard');
  lnode.Attributes['Valor'] := MinCard;

  lnode := node.AddChild('Composto');
  lnode.Attributes['Valor'] := BoolToStr(Composto);
  lnode := node.AddChild('Identificador');
  lnode.Attributes['Valor'] := BoolToStr(Identificador);
  lnode := node.AddChild('Tipo');
  lnode.Attributes['Valor'] := TipoDoValor;

  lnode := node.AddChild('Multivalorado');
  lnode.Attributes['Valor'] := BoolToStr(Multivalorado);

//  lnode := node.AddChild('Opcional');//desnecessário
//  lnode.Attributes['Valor'] := BoolToStr(Opcional);

  lnode := node.AddChild('Orientacao');
  lnode.Attributes['Valor'] := Orientacao;
  lnode := node.AddChild('TamAuto');
  lnode.Attributes['Valor'] := BoolToStr(TamAuto);
  lnode := node.AddChild('Desvio');
  lnode.Attributes['Valor'] := Desvio;

  if Barra.Atributos.Count > 0 then
  begin
    lnode := node.AddChild('BarraDeAtributos');
    Barra.to_xml(lnode);
  end else
  begin
    lnode := node.AddChild('BarraID');
    lnode.Attributes['Valor'] := Barra.OID;
  end;

  lnode := node.AddChild('Ligacoes');
  LigacoesTo_xml(lnode);
end;

procedure TAtributo.SetDesvio(const Value: integer);
begin
  FDesvio := Value;
  AdjustSize;
end;

procedure TAtributo.SetBarra(const Value: TBarraDeAtributos);
begin
  FBarra := Value;
end;

procedure TAtributo.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if Assigned(Barra) then
  begin
    Barra.posicione;
    Barra.Invalidate;
  end;  
end;

procedure TAtributo.OrganizeAtributos;
begin
  Barra.OrganizeAtributos;
end;

function TAtributo.GetEhOpcional: Boolean;
begin
  Result := (MinCard = 0) and Multivalorado;
end;

procedure TAtributo.SetForcaOrientacao(const Value: Integer);
begin
  FOrientacao := Value;
  AdjustSize;
  if FOrientacao <> Value then AdjustSize;
end;

procedure TAtributo.getChilds(aLista: TList);
  var i, j, tmp: integer;
      A: TAtributo;
begin
  if aLista.Count > 50 then exit;

  if Multivalorado then
  begin
    tmp := MaxCard;
    if tmp = 21 then
    begin

      // Início TCC II - Puc (MG) - Daive Simões
      // obtém a quantidade de campos especificados pelo usuário no momento
      // da definição do modelo conceitual
      tmp := FQtdeMultivalorado;
      // Fim TCC II

      if (not Modelo.YesToAll) and (not Modelo.naoAvisado) then
      begin
        Modelo.naoAvisado := true;

        // Início TCC II - Puc (MG) - Daive Simões
        // retirada a mensagem de alerta ao usuário
        // Modelo.onErro(nil, 'Serão gerados apenas 5 campos na tabela de destino referente ao atributo ' + Nome + '!', 1);
        // Fim TCC II
      end;
    end;
  end else tmp := 1;

  if IgnoreMult then tmp := 1;

  for j := 1 to tmp do
  begin
    if Composto then
    begin
      for i:= 0 to Barra.FAtributos.Count -1 do
      begin
        A := TAtributo(Barra.FAtributos[i]);
        A.getChilds(aLista);
        A.FAOcultos.getChilds(aLista);
      end;
    end
    else aLista.Add(Self);
  end;
end;

procedure TAtributo.SetMaxCard(const Value: integer);
begin
  if (Value > 0) and (Value < 22) then
  begin
    if (FMaxCard <> Value) then Muda else Exit;
    FMaxCard := Value;
    if (FMaxCard = 1) and (FMinCard = 1) then FMultivalorado := false;
    Invalidate;
  end;
end;

procedure TAtributo.SetMinCard(const Value: integer);
begin
  if (Value > -1) and (Value < 2) then
  begin
    if (FMinCard <> Value) then Muda else Exit;
    FMinCard := Value;
    if (FMaxCard = 1) and (FMinCard = 1) then FMultivalorado := false;
    Invalidate;
  end;
end;

// Início TCC II - Puc (MG) - Daive Simões
// encapsulamento de escrita da propriedade "QtdeMultivalorado"
procedure TAtributo.SetQtdeMultivalorado(const Value: integer);
begin
  FQtdeMultivalorado := Value;
end;

// encapsulamento de escrita da propriedade "Complemento"
procedure TAtributo.SetComplemento(const Value: string);
begin
  FComplemento := Value;
end;
// Fim TCC II

function TAtributo.GetCardinalidade: Integer;
begin
  Result := ConvCard;
end;

function TAtributo.CardStr: String;
begin
  Result := '(' + IntToStr(MinCard) + ',' + IfThen(MaxCard > 20, 'n',IntToStr(MaxCard)) + ')';
end;

function TAtributo.ConvCard: integer;
  var n: boolean;
begin
  n := (MaxCard > 1);
  if MinCard = 0 then
  begin
    if n then Result := 4 else Result := 2;
  end else
    if n then Result := 3 else Result := 1;
end;

procedure TAtributo.MeSelecione;
begin
  Modelo.AddSelect(Self);
  if Barra.Atributos.Count > 0 then Barra.MeSelecione;
end;

procedure TAtributo.SelecionarAtributos;
begin
  MeSelecione;
end;

{ TBaseTexto }

constructor TBaseTexto.Create(AOwner: TComponent);
begin
  inherited;
  FCor := clSkyBlue; //5558000;//$00FD6931;
  FTamAuto := true;
  FTextAlin := 0; //garantia
end;

procedure TBaseTexto.Paint;
var Rect : TRect;
    F: integer;
    C: Cardinal;
begin
  if (Atualizando) then exit;
  with canvas do
  begin
    Pen.Style:=psSolid;
    Pen.Color := $00363636;
    Brush.Style := bsSolid;
    if tipo = TextoTipoBox then
    begin
      Pen.Color:=$00B3B3B3;
      Brush.Color := $00B3B3B3;
      Rectangle(2,2, Width -1, Height -1);
      Pen.Color := $00363636;
      Brush.Color := Cor;
      Rectangle(0,0, Width -3, Height -3);
    end;
    F := 0;
    if tipo = TextoTipoHint then
    begin
      if (Width < 15) or (Height < 15) then F := 5 else F := 15;
      Pen.Color:=$00B3B3B3;
      Brush.Color := $00B3B3B3;
      RoundRect(0,0, Width -1, Height -1, F -5, F -5);
      Pen.Color := $00363636;
      Brush.Color := Cor;
      RoundRect(0,0, Width -3, Height -3, F -5, F -5);
      F := 2;
    end;
    Brush.Style := bsClear;
    Rect := GetClientRect;
    with Rect do
    begin
      Top := Top + 2;
      Left := Left + 5;
      Right := Right - (5 + F);
      Bottom := Bottom - (5 + F);
    end;
    Brush.Style := bsClear;
    case TextAlin of
      TextoAlinDir: C := DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS;
      TextoAlinCen: C := DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS;
      else C := DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS;
    end;
    DrawText(Handle, PChar(Nome), -1, Rect, C);
    if TamAuto then
    begin
      DrawText(Handle, PChar(Nome), -1, Rect, C or DT_CALCRECT);
      F := Rect.Bottom + 5 + F; //+5 por causa do -5 e + F por cause do -F
      if F <> Height then
      begin
        Height := F;
        reposicione;
      end;
    end;
  end;
end;

procedure TBaseTexto.SetTamAuto(const Value: boolean);
begin
  if (FTamAuto <> Value) then Muda;
  FTamAuto := Value;
  if FTamAuto then
  begin
    Height := Canvas.TextHeight('H') * conta13(Nome) + 7;
    reposicione;
  end;
end;

procedure TBaseTexto.SetCor(const Value: TColor);
begin
  if (FCor <> Value) then Muda;
  FCor := Value;
  Repaint;
end;

procedure TBaseTexto.SetTipo(const Value: Integer);
begin
  if FTipo = Value then exit;
  Muda;
  FTipo := Value;
  Repaint;
end;

procedure TBaseTexto.to_xml(var node: IXMLNode);
 var lnode: IXMLNode;
begin
  inherited to_xml(node);
  lnode := node.AddChild('Cor');
  lnode.Attributes['Valor'] := Cor;
  lnode := node.AddChild('TamAuto');
  lnode.Attributes['Valor'] := BoolToStr(TamAuto);
  lnode := node.AddChild('Tipo');
  lnode.Attributes['Valor'] := Tipo;
  lnode := node.AddChild('TextAlin');
  lnode.Attributes['Valor'] := TextAlin;
end;

procedure TBaseTexto.SetTextAlin(const Value: Word);
begin
  if (FTextAlin <> Value) then Muda;
  FTextAlin := Value;
  Repaint;
end;

{ TEspecializacao }

constructor TEspecializacao.Create(AOwner: TComponent);
begin
  Atualizando := true;
  inherited;
  FLigacoes.OwnsObjects := True;
  MyPosi := 1;
  FTipo := EspOpicional;
  Canvas.Font.Style := [fsItalic] + [fsBold];
  Font.Style := [fsItalic] + [fsBold];
  Font.Color := 32896;
  Canvas.Font.Color := 32896;
  Width := 51;
  Atualizando := false;
  Height := 31;
end;

procedure TEspecializacao.Paint;
begin
  if (Atualizando) then exit;
  with canvas do
  begin
    Pen.Style:=psSolid;
    Pen.Color := TColor(-5);
    Pen.Width := 2;
    MoveTo(FalsasBases[1].X - Left, FalsasBases[1].Y - Top);
    LineTo(FalsasBases[2].X - Left, FalsasBases[2].Y - Top);
    LineTo(FalsasBases[3].X - Left, FalsasBases[3].Y - Top);
    LineTo(FalsasBases[1].X - Left, FalsasBases[1].Y - Top);
    if Parcial then
    begin
//      Brush.Style := bsClear;
      TextOut(Width - TextWidth('p')-7, (Height - TextHeight('p') -3) div 2, 'p');
    end;
  end;
end;

function TEspecializacao.Adicione(E: TEntidade): boolean;
  var L : TLigacao;
begin
  Result := false;
  if Assigned(E) and CanLiga(E) then
  begin
    if Assigned(EntidadeBase) and
      (EntidadeBase.Especializacoes.Count > 1) and
      (FLigacoes.Count > 1)
    then exit;
//    if (E.Origem <> nil) and (EntidadeBase <> nil) then exit;

    L := TLigacao.Create(Modelo);
    L.Orientacao := OrientacaoH;
    E.Liga(L);
    Result := L.Generate(Self, E);
    FLigacoes.Add(L);
    if not Assigned(EntidadeBase) then
    begin
      EntidadeBase := E;
    end else
    if (FLigacoes.Count > 2) then
    begin
      Tipo := EspRestrita;
      AdjustSize;
    end;
    if EntidadeBase <> E then
    begin
      E.Origem := Self;
    end;
    if not Modelo.FDisableSelecao then BringToFront;
    NeedPaint;
  end;
end;

procedure TEspecializacao.SetEntidadeBase(const Value: TEntidade);
begin
  FEntidadeBase := Value;
end;

function TEspecializacao.CanLiga(B: TBase): boolean;
 var i : integer;
 Ent, EntRes: TEntidade;
begin
  Result := True;
  for i := 0 to FLigacoes.Count - 1 do
    if TLigacao(FLigacoes[i]).BasePertence(B) then Result := False;
  if B = Self then Result := False;

  if (not Result) or (EntidadeBase = nil) then exit;
  Ent := EntidadeBase;
  EntRes := TEntidade(B);
  while (Ent.Origem <> nil) do
  begin
    Ent := Ent.Origem.EntidadeBase;
    if Ent = EntRes then
    begin
      Modelo.Erro(nil, 'Referência circular na construção da especialização/generalização!', 0);
      Result := false;
      Break;
    end;
  end;
end;

procedure TEspecializacao.SetTipo(const Value: Integer);
begin
  if Value = FTipo then Exit;
  if (Value = EspOpicional) and (FLigacoes.Count > 2) then exit;
  Muda;
  FTipo := Value;
end;

destructor TEspecializacao.destroy;
begin
  if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
  begin
    Modelo.onEspDel(Self);
    if Assigned(FEntidadeBase) and (not FEntidadeBase.Destruindo) then
    begin
      FEntidadeBase.Especializacoes.OwnsObjects := false;
      FEntidadeBase.Especializacoes.Remove(Self);
      FEntidadeBase.Especializacoes.OwnsObjects := true;
    end;
  end;
  inherited;
end;

procedure TEspecializacao.SetParcial(const Value: Boolean);
begin
  if (FParcial <> Value) then Muda;
  FParcial := Value;
  Invalidate;
end;

procedure TEspecializacao.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  Redesenhe(ALeft, ATop, AWidth, AHeight);
  inherited;
end;

function TEspecializacao.Posi: Integer;
begin
  Result := 0;
  If Not Assigned(EntidadeBase) then Exit;
  if Top < EntidadeBase.Top then
    Result := POSI_ACIMA else Result := POSI_ABAIXO;
end;

procedure TEspecializacao.Redesenhe(ALeft, ATop, AWidth, AHeight: Integer);
  var w, h, meio: integer;
begin
  if Assigned(FLigacoes) then Reconceitue;
  meio := aleft + ((aWidth-3) div 2);
  h := atop + (aHeight -3);
  w := aLeft + (aWidth -3);
  if Posi <> POSI_ACIMA then
  begin
    FalsasBases[2] := Point(meio, aTop);
    FalsasBases[4] := Point(meio, H);
    FalsasBases[1] := Point(aLeft, H);
    FalsasBases[3] := Point(W, H);
  end
  else
  begin
    FalsasBases[2] := Point(meio, H);
    FalsasBases[4] := Point(meio, aTop);
    FalsasBases[1] := Point(Left, aTop);
    FalsasBases[3] := Point(W, aTop);
  end;
end;

procedure TEspecializacao.NeedPaint;
begin
  if MyPosi <> Posi then
  begin
    MyPosi := Posi;
    AdjustSize;
    Repaint;
  end;
end;

function TEspecializacao.getTipo: boolean;
begin
  Result := (Tipo = EspRestrita);
end;

function TEspecializacao.Get_EntBase: Integer;
begin
  if FEntidadeBase <> nil then
    Result := FEntidadeBase.OID else Result := -1;
end;

procedure TEspecializacao.load;
begin
  inherited;
  FEntidadeBase := TEntidade(Modelo.FindByID(F_EntBase));
  FEntidadeBase.Especializacoes.Add(Self);
  Redesenhe;
end;

procedure TEspecializacao.Redesenhe;
begin
  Redesenhe(Left, Top, Width, Height);
end;

procedure TEspecializacao.PrepareToAtive(L: TLigacao);
  var i, oLeft: integer;
begin
  AtualizaEncaixes;
  if L.Ponta = EntidadeBase then
  begin
    for i := 1 to 4 do Encaixe[i] := FalsasBases[2];
    exit;
  end;
  oLeft := Left;
  if Assigned(EntidadeBase) then
  begin
    oLeft := EntidadeBase.Left;
  end;

  if (Tipo = EspOpicional) or (L.Ponta.Left = oLeft) then
  begin
    for i := 1 to 4 do Encaixe[i] := FalsasBases[4];
    exit;
  end;

  if (L.Ponta.Left < oLeft) then
    for i := 1 to 4 do Encaixe[i] := FalsasBases[1]
  else
    for i := 1 to 4 do Encaixe[i] := FalsasBases[3];
end;

procedure TEspecializacao.Reconceitue;
begin
//  if FLigacoes.Count < 3 then
//  begin
    Tipo := EspOpicional;//a property tipo já checa
//  end;
end;

procedure TEspecializacao.to_xml(var node: IXMLNode);
  var lnode: IXMLNode;
begin
  inherited to_xml(node);
  lnode := node.AddChild('Parcial');
  lnode.Attributes['Valor'] := BoolToStr(Parcial);
  lnode := node.AddChild('Ligacoes');
  LigacoesTo_xml(lnode);
end;

function TEspecializacao.ConverteEspToRestrita: Boolean;
begin
  Result := false;
  if EntidadeBase.HaRestrita then exit;
  Result := EntidadeBase.ConverteEspToRestrita(Self);
  AdjustSize;
end;

function TEspecializacao.OpcionalizeEsp: Boolean;
  var Entidades: TList;
      Ent: TEntidade;
      Esp: TEspecializacao;
      I: integer;
begin
  Result := false;
  if FLigacoes.Count < 3 then exit;
  Result := true;
  Entidades := TList.Create;
  i := 2;
  try
    while i < FLigacoes.Count do
    begin
      Entidades.Add(TLigacao(FLigacoes[i]).Ponta);
      FLigacoes.Remove(FLigacoes[i]);
    end;
    Tipo := EspOpicional;

    for i := 0 to Entidades.Count -1 do
    begin
      Esp := EntidadeBase.CriarEsp;
      Ent := TEntidade(Entidades[i]);
      Esp.SetBounds(Ent.Left + (ent.Width div 2) - (Width div 2), top, Width, Height);
      Esp.Adicione(Ent);
    end;
  finally
    Entidades.Free;
  end;  
  AdjustSize;
  Modelo.Selecionado := Self;
end;

procedure TEspecializacao.getChilds(aLista: TList);
  var i, j: integer;
  E: TEntidade;
  Esp: TEspecializacao;
begin
//v1.0
  for i := 1 to FLigacoes.Count -1 do
  begin
    E := TEntidade(TLigacao(FLigacoes[i]).Ponta);
    //pego as esp
    for j:= 0 to E.Especializacoes.Count -1 do
    begin
      Esp := TEspecializacao(E.Especializacoes[j]);
      //achou novamente coloca-se por ultimo
      if aLista.IndexOf(Esp) > -1 then aLista.Remove(Esp);
      aLista.Add(Esp);

      Esp.getChilds(aLista);
    end;
  end;
end;

{ TVisual }

procedure TVisual.AskToDraw(oCanvas: TCanvas; X, Y, aImg: Integer;
  Habilitado: boolean);
begin
  FImgLisa.Draw(oCanvas, X, Y, aImg, Habilitado);
end;

procedure TVisual.CarregueCursor;
begin
  Screen.Cursors[0] := crDefault;
  Screen.Cursors[Tool_Entidade] := LoadCursor(HInstance, 'Entidade');
  Screen.Cursors[Tool_Relacionamento] := LoadCursor(HInstance, 'Relacao');
  Screen.Cursors[Tool_EntidadeAssoss] := LoadCursor(HInstance, 'EntAssoss');
  Screen.Cursors[Tool_Especializacao] := LoadCursor(HInstance, 'Especializacao');
  Screen.Cursors[Tool_Texto] := LoadCursor(HInstance, 'Texto');
  Screen.Cursors[Tool_TextoII] := LoadCursor(HInstance, 'TextoII');
  Screen.Cursors[Tool_Atributo] := LoadCursor(HInstance, 'Atributo');
  Screen.Cursors[Tool_AutoRel] := LoadCursor(HInstance, 'AutoRel');
  Screen.Cursors[Tool_Ligacao] := LoadCursor(HInstance, 'Ligacao');
  Screen.Cursors[Tool_Ligacao2] := LoadCursor(HInstance, 'Ligacao2');
  Screen.Cursors[Tool_del] := LoadCursor(HInstance, 'APAGAR');
  Screen.Cursors[Tool_EspecializacaoA] := LoadCursor(HInstance, 'EspecializacaoA');
  Screen.Cursors[Tool_EspecializacaoB] := LoadCursor(HInstance, 'EspecializacaoB');
  Screen.Cursors[Tool_LOGICO_Relacao] := LoadCursor(HInstance, 'LRELACAO');
  Screen.Cursors[Tool_LOGICO_Relacao2] := LoadCursor(HInstance, 'LRELACAO2');
  Screen.Cursors[Tool_LOGICO_campo] := LoadCursor(HInstance, 'LCAMPO');
  Screen.Cursors[Tool_LOGICO_Tabela] := LoadCursor(HInstance, 'LTABELA');
  Screen.Cursors[Tool_LOGICO_Separador] := LoadCursor(HInstance, 'SEPARADOR');
  Screen.Cursors[Tool_Trabalho_Campo] := LoadCursor(HInstance, 'TRABALHO_TABELA');
end;

procedure TVisual.CNKeyDown(var Message: TWMKeyDown);
  var key: word;
      Chift: TShiftState;
begin
  key := Message.CharCode;
  Chift := KeyDataToShiftState(Message.KeyData);
  if Assigned(Modelo) then Modelo.ProcessKey(key, Chift);
//  if Key = 0 then Message.CharCode := 0;
  if key <> 0 then
    Inherited;
end;

constructor TVisual.Create(AOwner: TComponent);
begin
  inherited;
  Color := $00707070;
  SetBounds(Left, Top, 4000 + 40, 2000 + 40);
  Caption := '';
  FModelos:= TComponentList.Create(False);
  CarregueCursor;
  Memoria := TMemoria.Create(self);
//  OnKeyDown := MKeyDown;
end;

destructor TVisual.Destroy;
begin
  FModelos.Free;
  inherited;
end;

function TVisual.ExportarParaLogico(oModelo: TModelo): TModelo;
begin
  Result := gera('');
  Result.TransformTo(tpModeloLogico);
  oModelo.ExportarParaLogico(Result);
end;

function TVisual.Fecha: Boolean;
  var i: integer;
begin
  Result := True;
  if not Assigned(FModelo) then Exit;
  i := FModelos.IndexOf(FModelo);
  if i > -1 then
  begin
    Modelo.Selecionado := nil;
    Modelo.ClearSelect;
    Memoria.DeleteModelo(FModelo);
    FreeAndNil(FModelo);
    if (i = FModelos.Count) and (FModelos.Count > 0) then dec(i);
    if i < FModelos.Count then
    begin
      Modelo := TModelo(FModelos[i]);
    end;
  end;
end;

function TVisual.gera(Arq: string; novo: boolean): TModelo;
  var tmp : string;
      Fechou: boolean;
begin
  try
    tmp := GeraNome;
    Result := TModelo.Create(self);
    Writer.write('Criação de novo esquema', false, false);
    FModelos.Add(Result);
    if novo or (Arq = '') then
    begin
      novo := true;
      Result.Nome := tmp;
      Result.FNovo := true;
    end
    else begin
      Result.Arquivo := Arq;
      Result.FNovo := False;
    end;
    Result.PopupMenu := PopupMenu;
    Result.OnSelect := FOnSelected;
    Result.onBaseMouseMove := onBaseMouseMove;
    Result.OnMouseMove := OnMouseMove;
    if Assigned(FModeloMudou) then Result.ModeloMudou := ModeloMudou;
    Result.DXML := DXML;
    if Assigned(fonErro) then Result.onErro := FOnErro;
    if Assigned(FOnLoadProgress) then Result.OnLoadProgress := OnLoadProgress;
    if Assigned(FOnModeloQuestion) then Result.onQuestao := FOnModeloQuestion;
  except
    on exception do FreeAndNil(Result);
  end;
  if assigned(Result) then
  begin
    Memoria.AddModelo(Result);
    Modelo := Result;
    Fechou := false;
    if (not novo) and (not LoadFromFile(arq, tmp, Result)) then
    begin
      Fecha;
      Fechou := true;
    end;
    if not Fechou then Memoria.ForcerFliquer;
  end;
end;

function TVisual.GeraNome(tipoModelo: Integer): String;
  var nomes: TStringList;
      i: integer;
      tmp: String;
begin
  case tipoModelo of
    tpModeloConceitual: tmp := tpStrModeloConceitual;
    tpModeloLogico: tmp := StringReplace(tpStrModeloLogico, 'Ó', 'O', []);
    tpModeloFisico: tmp := StringReplace(tpStrModeloFisico, 'Í', 'I', []);
    tpModeloNormatizado: tmp := tpStrModeloNormatizado;
    else tmp := '';
  end;
  tmp := tmp + '_';
  Result := tmp + '1';
  if FModelos.Count = 0 then exit;
  nomes := TStringList.Create;
  try
    i := 1;
    GetModelos(nomes);
    while nomes.IndexOf(tmp + IntToStr(i)) <> -1 do inc(i);
    Result := tmp + IntToStr(i);
  finally
    nomes.Free;
  end;
end;

procedure TVisual.GetModelos(lLista: TGeralList);
  var i: Integer;
begin
  lLista.Lista.Clear;
  for i := 0 to FModelos.Count -1 do
  begin
    lLista.Add(TModelo(FModelos[i]).Nome, 0, I);
  end;
//  lLista.Ordene;
end;

procedure TVisual.GetModelos(Lst: TStrings);
  var i: integer;
begin
  if not Assigned(Lst) then Exit;
  Lst.Clear;
  for i := 0 to FModelos.Count -1 do
  begin
    Lst.Add(TModelo(Modelos[i]).Nome);
  end;
end;


function TVisual.JaEstaAberto(Arq: String): boolean;
  var i: integer;
begin
  Result := false;
  for i := 0 to FModelos.Count -1 do
  begin
    if TModelo(Modelos[i]).Arquivo = Arq then
    begin
      Result := true;
      break;
    end;
  end;
end;

function TVisual.LoadFromFile(arq, onErroNome: string;
  oModelo: TModelo): boolean;
  var ext: string;
begin
  ext := ExtractFileExt(arq);
  ext := AnsiUpperCase(ext);
  if ext = '.XML' then
     Result := LoadModeloByXML(arq, onErroNome, oModelo) else
       Result := LoadModeloByBin(arq, onErroNome, oModelo);
end;

function TVisual.LoadModeloByBin(arq, onErroNome: string;
  oModelo: TModelo): boolean;
  var Mem: TMemoryStream;
      myVersao: string[5];
begin
  Writer.write('Abrindo arquivo "' + arq + '"...', false, false);
  oModelo.staLoading := True;
  Mem := TMemoryStream.Create;
  try
    oModelo.DestroyComponents;
    Mem.LoadFromFile(arq);
    Mem.ReadBuffer(myVersao, SizeOf(myVersao));
    oModelo.Versao := myVersao;
    Mem.ReadComponent(oModelo);
    oModelo.Load;
    Mem.Free;
  except
    Mem.Free;
    onErro(nil, 'Erro ao abrir o arquivo binário!', 0);
    oModelo.Nome := onErroNome;
    oModelo.FNovo := true;
    oModelo.Arquivo := '';
    oModelo.Mudou := false;
    oModelo.staLoading := false;
    Result := false;
    exit;
  end;
  Result := true;
  oModelo.FNovo := false;
  oModelo.Arquivo := arq;
  oModelo.Mudou := false;
  oModelo.FJa_XSL := '';
  Memoria.InitializeAtual;
  Writer.write('Fim do processo de abertura do arquivo "' + arq + '"', false, false);
end;

Function TVisual.LoadModeloByXML(arq, onErroNome: string; oModelo: TModelo): boolean;
  var tmp: string;
begin
  try
    oModelo.Colando := false;
    DXML.XML.Clear;
    DXML.LoadFromFile(arq);
    tmp := DXML.XML[1];
    DXML.Active := true;
    Writer.write('Abrindo arquivo "' + arq + '"...', false, false);
    Result := oModelo.LoadFromXML;
    if Result then
    begin
      oModelo.FNovo := false;
      oModelo.Arquivo := arq;
      oModelo.FJa_XSL := '';
      if pos('<?xml-stylesheet', tmp) > 0 then oModelo.FJa_XSL := tmp;
      oModelo.Fliquer := 0;
      Memoria.InitializeAtual;
      Memoria.Ativo.Add;
      oModelo.Mudou := false;
    end;
  except
    on exception do
    begin
      onErro(nil, 'Erro ao abrir o arquivo XML!', 0);
      oModelo.Nome := onErroNome;
      oModelo.FNovo := true;
      oModelo.Arquivo := '';
      oModelo.Mudou := false;
      Result := false;
    end;
  end;
  Writer.write('Fim do processo de abertura do arquivo "' + arq + '"', false, false);
end;

function TVisual.ModeloFindByArq(Arq: string): boolean;
  var i: Integer;
begin
  Result := False;
  for i := 0 to FModelos.Count -1 do
  begin
    if AnsiUpperCase(TModelo(FModelos[i]).Arquivo) = Arq then
    begin
      Result := true;
      break;
    end;
  end;
end;

procedure TVisual.Paint;
begin
  inherited;
  if not Assigned(FModelo) then Exit;
  with Canvas do begin
    Pen.Color := clBlack;
    Pen.Width := 2;
    MoveTo(18, 19);
    LineTo(Width -18, 19);
    LineTo(Width -18, Height -19);
    MoveTo(19, 18);
    LineTo(19, Height -18);
    LineTo(Width -19, Height -19);
    Pen.Width := 4;
    MoveTo(25, Height -17);
    LineTo(Width -17, Height -17);
    LineTo(Width -17, 25);
  end;
end;

function TVisual.QtdModeloNaoSalvo: Integer;
  var i: integer;
begin
  Result := 0;
  for i := 0 to FModelos.Count -1 do
  begin
    if TModelo(Modelos[i]).Mudou then Inc(Result);
  end;
end;

Function TVisual.SelecioneModelo(index: integer): TModelo;
begin
  Result := nil;
  if (Modelos.Count > index) and (index >= 0) then
  begin
    Modelo := TModelo(Modelos[index]);
    Result := Modelo;
  end;
end;

procedure TVisual.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  Modelo := FModelo;
end;

procedure TVisual.SetDXML(const Value: TXMLDocument);
begin
  FDXML := Value;
end;

procedure TVisual.SetFocusByModelo;
  var h, v: integer;
begin
  if (Parent is TScrollingWinControl) and (not Focused) then
  begin
    h := TScrollingWinControl(Parent).HorzScrollBar.Position;
    v := TScrollingWinControl(Parent).VertScrollBar.Position;
    if not Focused then SetFocus;
    TScrollingWinControl(Parent).HorzScrollBar.Position := H;
    TScrollingWinControl(Parent).VertScrollBar.Position := V;
  end;
end;

procedure TVisual.SetImgLisa(const Value: TImageList);
begin
  FImgLisa := Value;
end;

procedure TVisual.SetMemoria(const Value: TMemoria);
begin
  FMemoria := Value;
end;

procedure TVisual.SetModelo(const Value: TModelo);
begin
  if Assigned(FModelo) then
  begin
    Modelo.Visible := false;
    Modelo.Parent := nil;
    FModelo.FScrollPos := Point(TScrollingWinControl(Parent).HorzScrollBar.Position,
                                TScrollingWinControl(Parent).VertScrollBar.Position);
  end;
  FModelo := Value;
  if not Assigned(FModelo)  then
  begin
    if Assigned(Memoria) then Memoria.Ativo := nil;
    Exit;
  end;
  with FModelo do begin
    Left := 20;
    Top := 20;
//    Width := 4094;//muito grande
//    Height := 2840;
    Width := 4000;
    Height := 2000;
    Parent := Self;
    FModelo.Visible := true;
    TScrollingWinControl(Self.Parent).HorzScrollBar.Position := FScrollPos.X;
    TScrollingWinControl(Self.Parent).VertScrollBar.Position := FScrollPos.Y;
  end;
  if Assigned(Memoria) then Memoria.AtivarByModelo(Modelo);
  Invalidate;
end;

procedure TVisual.SetModeloMudou(const Value: TNotifyEvent);
begin
  FModeloMudou := Value;
end;

procedure TVisual.SetModelos(const Value: TComponentList);
begin
  FModelos := Value;
end;

procedure TVisual.SetonBaseMouseMove(const Value: TBaseEvent);
begin
  FonBaseMouseMove := Value;
end;

procedure TVisual.SetOnErro(const Value: TBaseErro);
begin
  FOnErro := Value;
end;

procedure TVisual.SetOnLoadProgress(const Value: TModeloOnLoadProgress);
begin
  FOnLoadProgress := Value;
end;

procedure TVisual.SetOnModeloQuestion(const Value: TModeloOnQuestion);
begin
  FOnModeloQuestion := Value;
end;

procedure TVisual.SetOnSelected(const Value: TBaseEvent);
begin
  FOnSelected := Value;
end;

{ TCardinalidade }

constructor TCardinalidade.Create(AOwner: TComponent);
begin
  inherited;
  ToCardinalidade(4);
  FCorSel := clGreen;
end;

function TCardinalidade.GetFraca: Boolean;
begin
  Result := False;
  if Assigned(FComando) then
    Result := FComando.Fraca;
end;

function TCardinalidade.GetOrientacaoLinha: Integer;
begin
  Result := -1;
  if Assigned(FComando) then
    Result := FComando.Orientacao;
end;

function TCardinalidade.Get_Comando: String;
  var Ar: TResultIArray;
      i : integer;
begin
  Ar := Comando._Comando;
  Result := '';
  for I := 0 to TamArSerial do Result := Result + IntToStr(ar[i]) + '|';
end;

procedure TCardinalidade.Load;
  var Ar: TResultIArray;
      i : integer;
      V: string;
  Function GetI: integer;
    var p: integer;
  begin
    p := Pos('|', V);
    Result := StrToInt(Copy(V, 1, p -1));
    Delete(v, 1, p);
  end;
begin
  V := _FComando;
  FComando := TLigacao.Create(Modelo);
  for I := 0 to TamArSerial do ar[i] := GetI;
  FComando._Comando := Ar;
  FComando.FCard := Self;
end;

procedure TCardinalidade.Paint;
  var tmp: string;
      F: integer;
begin
//?
//  if (Comando = nil) or (Comando.Ponta = nil) then exit;
//?
  tmp := Nome;
  FNome := tmp + ' ' + aCardinalidade[cardinalidade];
  if Comando.Ponta.Left < Left then FNome := aCardinalidade[cardinalidade] + ' ' + tmp;
  if TamAuto then
  begin
    F := Canvas.TextWidth(FNome) + 10;
    if F <> Width then
    begin
      FNome := tmp;
      Width := F;
      FComando.Pai.AdjustSize;
      exit;
    end;
  end;
  inherited;
  FNome := tmp;
end;

procedure TCardinalidade.SelLine(sn: boolean);
  var aCor: TColor;
begin
  if sn then aCor := FCorSel else aCor := clBlack;
  if Assigned(FComando) then
    with Comando do
  begin
    LinhaA.Color := aCor;
    LinhaB.Color := aCor;
    LinhaMeio.Color := aCor;
//    if FComando.Pai is TLigaTabela then
//    begin
//      TLigaTabela(FComando.Pai).Visivel := sn;
//    end;
  end;
end;

procedure TCardinalidade.SetCardinalidade(const Value: Integer);
begin
  if (Value > 0) and (Value < 5) then
  begin
    if (FCardinalidade <> Value) then Muda;
    FCardinalidade := Value;
    if (not (csreading in Modelo.ComponentState)) and
        not (Modelo.staLoading) then
    begin
      if (FCardinalidade > 2) then
        sendMessage(Modelo.Handle, CM_CARDCHANGE, integer(Self), 0);
    end;
    Invalidate;
  end;
end;

procedure TCardinalidade.SetComando(const Value: TLigacao);
begin
  FComando := Value;
end;

procedure TCardinalidade.SetFixa(const Value: Boolean);
begin
  if (FFixa <> Value) then Muda;
  FFixa := Value;
  if Assigned(FComando) then FComando.PosicioneCardinalidade;
end;

procedure TCardinalidade.SetFraca(const Value: Boolean);
begin
  if Assigned(FComando) then
    FComando.Fraca := Value;
end;

procedure TCardinalidade.SetOrientacaoLinha(const Value: Integer);
begin
  if Assigned(FComando) then
  begin
    FComando.Orientacao := Value;
    FComando.Ponta.AdjustSize;
  end;
end;

procedure TCardinalidade.SetSelecionado(const Value: boolean);
begin
  inherited;
  SelLine(Value);
end;

procedure TCardinalidade.Set_Comando(const Value: String);
begin
  _FComando := Value;
end;

procedure TCardinalidade.ToCardinalidade(C: Integer);
  var tmp: string;
begin
  if (csreading in Modelo.ComponentState) then exit;
  if (C < 1) or (C > 4) then Exit;
  tmp := Nome + ' ' + aCardinalidade[c];
  FTipo := TextoTipoBranco;
  FCardinalidade := c;
  SetBounds(Left, Top, Canvas.TextWidth(tmp) + 10, Canvas.TextHeight('H') + 7);
end;

procedure TCardinalidade.to_xml(var node: IXMLNode);
 var lnode: IXMLNode;
begin
  inherited to_xml(node);
  lnode := node.AddChild('Card');
  lnode.Attributes['Valor'] := Cardinalidade;
  lnode := node.AddChild('Fixa');
  lnode.Attributes['Valor'] := BoolToStr(Fixa);
  lnode := node.AddChild('Ligacoes');
  LigacoesTo_xml(lnode);
end;

{ TEntidade }

function TEntidade.ConverteEspToRestrita(Pedinte: TBase): Boolean;
  var Entidades: TList;
      I, J: integer;
      Esp: TEspecializacao;
begin
  Result := false;
  Entidades := TList.Create;
  try
    for i:= 0 to Especializacoes.Count -1 do
    begin
      Esp := TEspecializacao(Especializacoes[i]);
      if (Esp <> TEspecializacao(Pedinte)) then
        for j := 0 to Esp.FLigacoes.Count -1 do
        begin
          if TLigacao(Esp.FLigacoes[j]).Ponta <> TBase(Self) then
          Entidades.Add(TLigacao(Esp.FLigacoes[j]).Ponta);
        end;
      //end;
    end;
    if Entidades.Count = 0 then exit;
    Result := true;
    Especializacoes.Extract(Pedinte);
    Especializacoes.Clear;
    Especializacoes.Add(Pedinte);
    for i:= 0 to Entidades.Count -1 do
    begin
      TEspecializacao(Pedinte).Adicione(TEntidade(Entidades[i]));
      Modelo.Selecionado := Pedinte;
    end;
  finally
    Entidades.Free;
  end;
end;

constructor TEntidade.Create(AOwner: TComponent);
begin
  inherited;
  Especializacoes := TComponentList.Create(true);
  Forigens := TList.Create;
end;

function TEntidade.CriarEsp: TEspecializacao;
  Const distancia = 105;
begin
  Result := nil;
  if HaRestrita then exit;
  Muda;
  Result := TEspecializacao.Create(Modelo);
  Result.Top := Top + Height + ((distancia - Result.Height -3) div 2);
  Result.Width := Result.Width div 2;
  Result.Left := Encaixe[4].X - ((Result.Width -3) div 2);
  Result.Tipo := EspOpicional;
  Result.Adicione(Self);
  Result.Nome := Modelo.GeraBaseNome('Esp');
  Especializacoes.Add(Result);
  if Modelo.FMultSelecao.Count = 0 then
    Modelo.Selecionado := Result;
end;


destructor TEntidade.destroy;
begin
  if (csDestroying in Modelo.ComponentState) or (Modelo.staLoading) then
      Especializacoes.OwnsObjects := false;
  Especializacoes.Free;
  Forigens.Free;
  inherited;
end;

function TEntidade.ehHerancaMultipla: boolean;
begin
  Result := false;
  if FOrigens.Count = 0 then exit;
  if (not Assigned(FOrigem)) and (FOrigens.Count > 0) then
  begin
    FOrigem := TEspecializacao(FOrigens[0]);
    FOrigens.Delete(0);
  end;
  Result := (FOrigens.Count > 0);
end;

function TEntidade.Especialise(Tipo: Integer; Parcial: boolean): Boolean;
  var E, F: TEntidade;
      Esp: TEspecializacao;
  Const distancia = 105;
begin
  Result := False;
  if (Tipo = EspRestrita) and (Especializada) then Exit;
  Esp := CriarEsp;
  if not Assigned(Esp) then Exit;
  E := TEntidade.Create(Modelo);
  E.Atualizando := true;
  E.Nome := Nome + '_A';
  E.Top := Top + Height + distancia;
  E.Atualizando := false;
  if Tipo = EspRestrita then
  begin
    Esp.Width := 2 * Esp.Width;
    Esp.Left := Encaixe[4].X - ((Esp.Width -3) div 2);
    E.Left := Left - (Width div 2) - (distancia div 2);
    if E.Left < 0 then E.Left := 0;
    F := TEntidade.Create(Modelo);
    F.Atualizando := true;
    F.Nome := Nome + '_B';
    F.Top := E.Top;
    F.Left := Left + (Width div 2) + (distancia div 2);
    Esp.Adicione(E);
    Esp.Adicione(F);
    F.Atualizando := false;
    F.Invalidate;
    F.Reenquadre;
  end
  else
  begin
    Esp.Adicione(E);
    E.Left := Left;
  end;
  E.Reenquadre;
  Esp.Reenquadre;
  Esp.BringToFront;
  if Modelo.FMultSelecao.Count = 0 then
    Modelo.Selecionado := Esp;
  Result := true;
end;

function TEntidade.getEhEsp: boolean;
begin
  Result := Especializacoes.Count > 0;
end;

procedure TEntidade.GetEntidadesDescendentes(aLista: TList);
  var i, j: integer;
      Esp: TEspecializacao;
      B: TBase;
begin
  for i := 0 to Especializacoes.Count -1 do
  begin
    Esp := TEspecializacao(Especializacoes[i]);
    if Esp.Usr_Conv_Opc <> 2 then Continue;
    for j := 1 to Esp.FLigacoes.Count -1 do
    begin
      B := TLigacao(Esp.FLigacoes[j]).Ponta;
      if B.associacao = associacao then TEntidade(B).GetEntidadesDescendentes(aLista)
      else if aLista.IndexOf(B) = -1 then aLista.Add(B);
    end;
  end;
end;

function TEntidade.GetOrigem: TEspecializacao;
begin
  ehHerancaMultipla;
  Result := FOrigem;
end;

function TEntidade.get_Origem: Integer;
begin
  if Assigned(FOrigem) then Result := FOrigem.OID else Result := -1;
end;

function TEntidade.get_Origens: string;
begin
  Result := SerializeBaseList(FOrigens);
end;

function TEntidade.HaRestrita: Boolean;
  var i: Integer;
begin
  Result := false;
  for i := 0 to Especializacoes.Count -1 do
    if TEspecializacao(Especializacoes[i]).Tipo = EspRestrita then
  begin
    Result := true;
  end;
end;

procedure TEntidade.Load;
begin
  inherited;
  unSerializeBaseList(Modelo, F_Origens, FOrigens);
  F_Origens := '';
  if F_Origem <> -1 then FOrigem := TEspecializacao(Modelo.FindByID(F_Origem));
end;

procedure TEntidade.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
  var i: integer;
begin
  inherited;
  if Assigned(Especializacoes) then
    for i := 0 to Especializacoes.Count -1 do
      TEspecializacao(Especializacoes[i]).NeedPaint;
end;

procedure TEntidade.SetOrigem(const Value: TEspecializacao);
begin
  if (FOrigem <> nil) and (Value <> nil) then Forigens.Add(FOrigem);
  FOrigem := Value;

  if (Forigens.Count > 0) and not Assigned(FOrigem) then
  begin
    if (Forigens.Count > 0) then
    begin
      FOrigem := TEspecializacao(Forigens[0]);
      Forigens.Delete(0);
    end;
  end;
end;

procedure TEntidade.to_xml(var node: IXMLNode);
  var lnode, oNode: IXMLNode;
      i: integer;
begin
  inherited to_xml(node);
  //espeicializações
  lnode := node.AddChild('Especializacoes');
  lnode.Attributes['ehEsp'] := BoolToStr(Especializada);
  if not Modelo.Copiando then
  for i := 0 to Especializacoes.Count -1 do
  begin
    oNode := lnode;
    TEspecializacao(Especializacoes[i]).to_xml(oNode);
  end;
end;

{ TBarraDeAtributos }

constructor TBarraDeAtributos.Create(AOwner: TComponent;
  oDono: TAtributo);
begin
  Create(AOwner);
  Dono := oDono;
  posicione;
end;

function TBarraDeAtributos.Get_Dono: Integer;
begin
  if Assigned(FDono) then Result := FDono.OID else Result := -1;
end;

procedure TBarraDeAtributos.Load;
begin
  inherited;
  FDono := TAtributo(Modelo.FindByID(_FDono));
  if Assigned(FDono) then FDono.Barra := Self;
end;

constructor TBarraDeAtributos.Create(AOwner: TComponent);
begin
  inherited;
  Nula := true;
end;

procedure TBarraDeAtributos.MeSelecione;
  var i: integer;
begin
  for i := 0 to FAtributos.Count -1 do
  begin
    TAtributo(FAtributos[i]).MeSelecione;
  end;
end;

procedure TBarraDeAtributos.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (ssCtrl in Shift) or (ssShift in Shift) then
  begin
    Modelo.AddSelect(Dono);
  end
  else begin
    if (Modelo.FMultSelecao.IndexOf(Dono) = -1) and (Modelo.Selecionado <> Dono) then
    begin
      Modelo.Selecionado := Dono;
      Modelo.ClearSelect;
    end;
  end;
end;

procedure TBarraDeAtributos.OrganizeAtributos;
  var i, w: integer;
      A: TAtributo;
begin
  if FAtributos.Count = 0 then Exit;
  posicione;
  for i := 0 to FAtributos.Count -1 do
  begin
    A := TAtributo(FAtributos[i]);
    A.Orientacao := Dono.Orientacao;
    if A.Orientacao = OrientacaoD then w := -(A.Width + 8) else w := 8;
    A.Left := Left + (Width div 2) + w;
    if FAtributos.Count > 1 then
      A.Top := Top + ((Height div (Atributos.Count -1))*i) - (A.Height div 2)
    else A.Top := Top - (A.Height div 2) + 1;
  end;
  for i := 0 to FAtributos.Count -1 do
  begin
    TAtributo(FAtributos[i]).OrganizeAtributos;
  end;
end;

procedure TBarraDeAtributos.Paint;
begin
  if (Atualizando) then exit;
  if FAtributos.Count < 2 then Exit;
  with Canvas do
  begin
    Pen.Color := clBlack;
    Pen.Width := 1;
    MoveTo((Width div 2), 0);
    LineTo((Width div 2), Height);

    MoveTo((Width div 2), (Height div 2));
    if Dono.Orientacao = OrientacaoD then
      LineTo(Width, ((Height) div 2))
    else LineTo(0, ((Height) div 2));
  end;
end;

procedure TBarraDeAtributos.posicione;
  var H, W, i: integer;
  B: TBase;
begin
  if not Assigned(Dono) then exit;
  if Dono.Orientacao <> OrientacaoD then
    w := Dono.Width -5 else w := -2;
  H := (Dono.Height * (Atributos.Count) + (Atributos.Count * 2)) -Dono.Height;
  if H < 0 then H := 2;
  SetBounds(dono.Left + W, dono.Top + (Dono.Height div 2) -(H div 2), 6, H);
  for i := 0 to FAtributos.Count -1 do
  begin
    B := TBase(FAtributos[i]);
    if not B.Selecionado then
      TLigacao(B.FLigacoes[0]).Ative;
  end;
end;

procedure TBarraDeAtributos.PrepareToAtive(L: TLigacao);
  var idx, calc: integer;
begin
  inherited;
  if FAtributos.Count < 2 then Exit;
  AtualizaEncaixes;
  idx := Atributos.IndexOf(L.Pai);
  if (idx = -1) then Exit;
  calc := (Height div (Atributos.Count -1)) * idx;
  for idx := 1 to 4 do
  begin
    Encaixe[idx].X := Left + (Width div 2);
    Encaixe[idx].Y := Top + calc;
  end;
end;

procedure TBarraDeAtributos.SendClick;
begin
//  inherited;
  PostMessage(Modelo.Handle, CM_BASECLICK, integer(Dono), 0);
end;

procedure TBarraDeAtributos.SetDono(const Value: TAtributo);
begin
  FDono := Value;
end;

procedure TBarraDeAtributos.Set_Dono(const Value: Integer);
begin
  _FDono := Value;
end;

procedure TBase.Repaint;
begin
//  inherited; //melhora a pintura na movimentação
  Invalidate;
end;

procedure TBarraDeAtributos.to_xml(var node: IXMLNode);
  var i: integer;
begin
  for i := 0 to FAtributos.Count -1 do
  begin
    TAtributo(FAtributos[i]).to_xml(Node);
    node := node.ParentNode;
  end;
end;

{ TTabela }

function TTabela.AddCampo(oCampo: TCampo): TCampo;
begin
  oCampo.Dono := Self;
  Campos.Add(oCampo);
  PosicioneCampos;
  Result := oCampo;
  Muda;
end;

procedure TTabela.CampoRemovido(oCampo: TCampo);
begin
  Campos.Remove(oCampo);
  Muda;
  PosicioneCampos;
  Invalidate;
end;

function TTabela.CountLigToTabela(aTabela: TTabela): integer;
  var Liga: TLigaTabela;
      L: TLigacao;
      i: integer;
begin
  //retorna quantas ligações partindo desta
  //tabela vai até a tabela aTabela.
  Result := 0;
  for i := 0 to FLigacoes.Count -1 do
  begin
    L := TLigacao(FLigacoes[i]);
    Liga := TLigaTabela(L.Pai);
    if Liga.HasTable(aTabela) then Result := Result + 1;
  end;
end;

constructor TTabela.Create(AOwner: TComponent);
begin
  inherited;
  FCampos := TComponentList.Create(false);
  Color := clMoneyGreen; //clSilver;
  Width := 180;
end;

destructor TTabela.destroy;
begin
  if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
  begin
    SendMessage(Modelo.Handle, CM_TABELAORDER, integer(Self), -1);
    FCampos.OwnsObjects := true;
  end;
  FCampos.Free;
  inherited;
end;

function TTabela.GetChaves: string;
  var i : Integer;
begin
  Result := '';
  for i := 0 to Campos.Count -1 do
  begin
    if TCampo(Campos[i]).IsKey then Result := Result + TCampo(Campos[i]).Nome + ',';
  end;
  if Length(Result) > 0 then Result[Length(Result)] := ' ';
  Result := Trim(Result);
end;

function TTabela.GetTLChaves: Integer;
  var i: Integer;
begin
  Result := 0;
  for i := 0 to Campos.Count -1 do
  begin
    if TCampo(Campos[i]).IsKey then Inc(Result);
  end;
end;

// Início TCC II - Puc (MG) - Daive Simões
// novo método para pesquisar se um determinado campo com o mesmo nome
// já existe na lista de campos da tabela
function TTabela.jaExisteCampo(nomeAtributo: string): boolean;
var iIndex: integer;
begin
  // inicializa o retorno do método
  Result := False;

  // itera pela lista de campos pesquisando por um campo com o mesmo nome do
  // que foi passado pelo parâmetro
  for iIndex := 0 to Pred(FCampos.Count) do begin
    // atualiza o retorno do método
    Result := (AnsiUppercase(TCampo(FCampos[iIndex]).Nome)) = AnsiUpperCase(nomeAtributo);

    // encontrou o primeiro campo com o mesmo nome, interromper o loop
    if (Result) then Break;
  end;
end;
// Fim TCC II

function TTabela.GetQtdCampos: integer;
  var i: integer;
begin
  Result := 0;
  for i := 0 to Campos.Count -1 do
  begin
    if not TCampo(Campos[i]).ApenasSeparador then Inc(Result);
  end;
end;

function TTabela.get_Campos: string;
begin
  Result := SerializeBaseList(FCampos);
end;

function TTabela.ImportarCampo(oCampo: TCampo): TCampo;
begin
  Result := nil;
  if oCampo.Dono = self then exit;
  try
    with TCampo.Create(Modelo) do
    begin
      _CampoKey := oCampo._CampoKey;
      Nome := oCampo.Nome;
      FIsKey := oCampo.IsKey;
      FIsFKey := oCampo.IsFKey;
      Tipo := oCampo.Tipo;

      // Inicio TCC II
      // Passa o tamanho do campo
      Precisao := oCampo.Precisao;
      // Fim TCC II

      Observacoes := oCampo.Observacoes;
      Dicionario := oCampo.Dicionario;
      if oCampo.ApenasSeparador then ApenasSeparador := True;
      Result := AddCampo(TCampo(Me));
    end;
  except
    Result := nil;
  end;
end;

procedure TTabela.LiberarLinhas;
  var Liga: Tbase;
      L: TLigacao;
begin
  while FLigacoes.Count > 0 do
  begin
    L := TLigacao(FLigacoes[FLigacoes.Count -1]);
    Liga := L.Pai;
    Liga.Free;
  end;
end;

procedure TTabela.Load;
begin
  inherited;
  unSerializeBaseList(Modelo, F_Campos, FCampos);
  F_Campos := '';
end;

procedure TTabela.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
  var i: integer;
begin
  inherited;
  for i := 0 to Campos.Count -1 do
  begin
    TCampo(Campos[i]).BringToFront;
  end;
end;

procedure TTabela.Paint;
var Rect : TRect;
    I: integer;
    oNome: String;
begin
  if (Atualizando) then exit;
  with canvas do
  begin
    Brush.Color := Color;
    Rect := GetClientRect;
    FillRect(Rect);
    Pen.Style:=psSolid;
    Pen.Color := TColor(-5);
    MoveTo(0, 0);
    LineTo(0, height-3);
    LineTo(width-3, height-3);
    LineTo(width-3, 0);
    LineTo(0, 0);
    Pen.Style:=psSolid;
    Pen.Color:=$00707070;
    MoveTo(width-2, 0);
    LineTo(width-2, height-2);
    LineTo(0, height-2);
    Pen.Color:=$00B3B3B3;
    MoveTo(width-1, 0);
    LineTo(width-1, height-1);
    LineTo(0, height-1);
    oNome := ControlaCaption(Canvas, self.Width -4, Nome);

    I := conta13(oNome) * TextHeight('W');
    with Rect do
    begin
      Top := 2;
      Bottom := Top + I;
      Right := Right - 2;
      IniCampos := Bottom + 3;
    end;
    Pen.Color := clBlack;
    MoveTo(1, IniCampos);
    LineTo(Width -3, IniCampos);
    MoveTo(1, FimCampos);
    LineTo(Width -3, FimCampos);
    DrawText(Handle, PChar(oNome), -1, Rect, DT_CENTER or DT_EXPANDTABS);
  end;
end;

procedure TTabela.PodeTrocar(aOrigem: TCampo; oPonto: TPoint);
  var i: integer;
      C: TCampo;
      P: TPoint;
      Ja: Boolean;
begin
  Ja := false;
  for i := 0 to Campos.Count -1 do
  begin
    C := TCampo(Campos[i]);
    P.X := oPonto.X - C.Left;
    P.Y := oPonto.Y - C.Top;
    if PtInRect(C.GetClientRect, P) and not (Ja) then
    begin
      C.OverMe := true;
      Ja := true;
    end else
    begin
      C.OverMe := false;
    end;
  end;
end;

procedure TTabela.PosicioneCampos;
  var i, prox: integer;
      C: TCampo;
      sn: Boolean;
begin
  if Modelo.staLoading then Exit;
  sn := Modelo.Mudou;
  Atualizando := true;
  prox := IniCampos + Top + 1;
  for i := 0 to Campos.Count -1 do
  begin
    C := TCampo(Campos[i]);
    C.OrganizeSe(Left, prox, Width -2);
    C.BringToFront;
    prox := prox + C.Height -1;
  end;
  FimCampos := prox -top + 1;
  if Height < (prox -Top + 9) then
  begin
    Height := (prox - Top + 9);
    if Selecionado then Modelo.Selecionado := Self;
  end;
  Atualizando := false;
  if not sn and Modelo.Mudou then
    Modelo.Mudou := false;
  Invalidate;
end;

procedure TTabela.PrepareParaTrocar(aOrigem: TCampo; oPonto: TPoint);
  var i: integer;
      C: TCampo;
      P: TPoint;
begin
  P.X := oPonto.X - Left;
  P.Y := oPonto.Y - Top;
  if not PtInRect(GetClientRect, P) then exit;
  for i := 0 to Campos.Count -1 do
  begin
    C := TCampo(Campos[i]);
    P.X := oPonto.X - C.Left;
    P.Y := oPonto.Y - C.Top;
    if PtInRect(C.GetClientRect, P) then
    begin
      Campos.Move(Campos.IndexOf(aOrigem), Campos.IndexOf(C));
      Muda;
      C.OverMe := false;
      PosicioneCampos;
      Modelo.Selecionado := Modelo.Selecionado;
      Break;
    end;
  end;
end;

procedure TTabela.ReleaseTable(aTabela: TTabela);
  var i: integer;
      C: TCampo;
begin
  //A tabela aTabela ou a última ligação com ela vai ser destruída, então
  //Os campos deverão ser informados do rompimento.
  for i := 0 to Campos.Count -1 do
  begin
    C := TCampo(Campos[i]);
    if C.TabelaDeOrigem = aTabela then C.SetTabOrigem(0);
  end;
end;

procedure TTabela.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if Assigned(FCampos) then PosicioneCampos;
end;

procedure TTabela.SetCampos(const Value: TComponentList);
begin
  FCampos := Value;
end;

procedure TTabela.SetcOrdem(const Value: integer);
begin
  if FcOrdem <> Value then
  begin
    if not Modelo.ModeloCarregando then
      SendMessage(Modelo.Handle, CM_TABELAORDER, integer(Self), Value);
    FcOrdem := Value;
    Muda;
  end;
end;

procedure TTabela.SetComplemento(const Value: string);
begin
  if FComplemento <> Value then
  begin
    FComplemento := Value;
    Muda;
  end;
end;

procedure TTabela.SetFimCampos(const Value: integer);
begin
  FFimCampos := Value;
end;

procedure TTabela.SetIniCampos(const Value: integer);
begin
  if Value <> FIniCampos then
  begin
    FIniCampos := Value;
    PosicioneCampos;
  end;
end;

procedure TTabela.to_xml(var node: IXMLNode);
   var i: integer;
       lnode, MNode: IXMLNode;
begin
  inherited;
  //Campos
  lnode := node.AddChild('Color');
  lnode.Attributes['Valor'] := Color;
  lnode := node.AddChild('Complemento');
  lnode.Attributes['Valor'] := Complemento;
  lnode := node.AddChild('cOrdem');
  lnode.Attributes['Valor'] := cOrdem;
  lnode := node.AddChild('Campos');
  for i := 0 to FCampos.Count -1 do
  begin
    Mnode := lnode;
    TCampo(FCampos[i]).to_xml(MNode);
  end;
end;

{ TCampo }

constructor TCampo.Create(AOwner: TComponent);
begin
  inherited;
  Nula := True;
  FTipo := 'Número(4)';
  ValorInicialFKTabOrigem := 0;
  ValorInicialFKCampoOrigem := 0;
end;

destructor TCampo.destroy;
begin
  if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
  begin
    Dono.CampoRemovido(Self);
  end;
  inherited;
end;

function TCampo.GetCampoOrigem: Integer;
begin
  if ValorInicialFKCampoOrigem <> 0 then
  begin
    if ValorInicialFKTabOrigem <> 0 then GetTabOrigem;
    SetCampoOrigem(ValorInicialFKCampoOrigem);
    ValorInicialFKCampoOrigem := 0;
  end;
  if Assigned(FCampoOrigem) and (Modelo.FindByID(FCampoOrigem.OID) <> nil) and (FCampoOrigem.IsKey) then Result := FCampoOrigem.OID
  else begin
    Result := 0;
    FCampoOrigem := nil;
  end;
end;

function TCampo.GetoIndex: integer;
begin
  if Assigned(FDono) then
    Result := Dono.Campos.IndexOf(Self) + 1 else Result := -1;
end;

procedure TCampo.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if (ssCtrl in Shift) or (ssShift in Shift) then exit;
  down := Point(X, Y);
  isMouseDown := true;
  Modelo.Selecionado := Self;
  Modelo.ClearSelect;
  OldCr := Screen.Cursor;
  Screen.Cursor := Tool_Trabalho_Campo;
end;

procedure TCampo.OrganizeSe(aLeft, aTop, aWidth: Integer);
  var aHeight: integer;
begin
//pronto para pintar imagem.
  aHeight := Max(Canvas.TextHeight('H') + 6, 18);
  if FNome = '' then aHeight := 8;
  if (ALeft <> Left) or (ATop <> Top) or (AWidth <> Width) or (AHeight <> Height) then
    SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TCampo.Paint;
var Rect : TRect;
    I: integer;
    LNome: String;
    auxTipo: string;
begin
  if (Atualizando) then exit;
  with Canvas do
  begin
    Rect := GetClientRect;
    I := conta13(Nome) * TextHeight('W');
    Brush.Style := bsClear;
    if ApenasSeparador then
    begin
      MoveTo(0,1);
      LineTo(Width, 1);
      MoveTo(0,Height -2);
      LineTo(Width, Height -2);
      with Rect do
      begin
        Top := ((Bottom + Top) - I) div 2;
        Bottom := Top + I;
        Right := Right - 2;
      end;
      if Nome <> '' then LNome := '<' + Nome + '>';
      DrawText(Handle, PChar(LNome), -1, Rect, DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS);
    end else
    begin
      Brush.Color := clWhite;

      // Início TCC II - Puc (MG) - Daive Simões
      // monta o tipo do campo
      auxTipo := tipo;
      if (Pos('( )', tipo) > 0) then
        auxTipo := Copy(Trim(tipo), 1, Pos('( )', tipo) - 1) + '(' + Precisao + ')';
      lNome := ControlaCaption(Canvas, Self.Width -2 -TextWidth('***'), Nome + ': ' + auxTipo);
      // Fim TCC II

      Pen.Style:=psSolid;
      Pen.Color := TColor(-5);
      Rectangle(Rect);
      with Rect do
      begin
        Top := 2 + 1;
        Bottom := Top + I;
        Right := Right - 2;
        Left := 22;
      end;
      if IsKey or IsFKey then
      begin
        Brush.Style := bsClear;
        Pen.Mode := pmXor;
        if IsKey and IsFKey then
          PinteImagem(Img_KeyAndFKey, 2, (Height - 16) div 2, true)
          else if IsKey then
            PinteImagem(img_key, 2, (Height - 16) div 2, true)
            else if IsFKey then
              PinteImagem(img_Fkey, 2, (Height - 16) div 2, true);

        Pen.Mode := pmCopy;
      end;
      Brush.Style := bsClear;
      DrawText(Handle, PChar(LNome), -1, Rect, DT_LEFT or DT_EXPANDTABS);
    end;
    if Selecionado then
    begin
      Brush.Style := bsSolid;
      Brush.Color := clGreen;
      Rectangle(1,1, 7, 7);
      Rectangle(1,Height -7, 7, Height -1);
      Rectangle(Width -7,1, Width-1, 7);
      Rectangle(Width- 7,Height -7, Width-1, Height -1);
    end;
  end;
end;

procedure TCampo.RealiseConversao;
begin
  try
    if Assigned(_CampoKey) then
    begin
      ValorInicialFKCampoOrigem := 0;
      FCampoOrigem := _CampoKey;
      FTabOri := _CampoKey.FDono;
    end;
  except
  end;
end;

procedure TCampo.SetDono(const Value: TTabela);
begin
  FDono := Value;
end;

procedure TCampo.SetoIndex(const Value: integer);
begin
  if (FDono = nil) then exit;
  if (Value -1) < Dono.Campos.Count then
  begin
    Muda;
    Dono.Campos.Move(oIndex -1, Value -1);
    Dono.PosicioneCampos;
  end;
end;

procedure TCampo.SetIsFKey(const Value: Boolean);
begin
  if FIsFKey <> Value then Muda else exit;
  FIsFKey := Value;
  //05/11/2006
  //if Value then FIsKey := false else FTabOri := nil;
  if not Value then FTabOri := nil;
  Invalidate;
end;

procedure TCampo.SetIsKey(const Value: Boolean);
begin
  if FIsKey <> Value then Muda else exit;
  FIsKey := Value;
  //05/11/2006
  //  if Value then IsFKey := false;
  Invalidate;
end;

procedure TCampo.SetNome(const Value: string);
  var n: string;
begin
  n := FNome;
  inherited;
  if ((n = '') and (FNome <> '')) or ((n <> '') and (FNome = '')) then
    if ApenasSeparador then
      if (Assigned(dono)) then Dono.PosicioneCampos;
end;

procedure TCampo.SetSelecionado(const Value: boolean);
begin
  FSelecionado := Value;
  Invalidate;
end;

procedure TCampo.SetTipo(const Value: String);
begin
  if FTipo <> Value then Muda else Exit;
  FTipo := Value;
  if (IsKey) and not ((csReading in Modelo.ComponentState) or
          Modelo.staLoading or Modelo.FDisableSelecao) then
  begin
    Modelo.RepinteFKs(Self.OID);
    //broad cast para repintar os fkeys deste campo!
  end;
  Invalidate;
end;

procedure TCampo.SetApenasSeparador(const Value: boolean);
begin
  FApenasSeparador := Value;
  if Value then
  begin
    Font.Style := [];
    Canvas.Font.Style := [];
    if not Modelo.staLoading then FNome := Modelo.GeraBaseNome('Separador');
  end;
end;

procedure TCampo.SetCampoOrigem(const Value: Integer);
  var B: TBase;
begin
  if Modelo.staLoading then Exit;
  B := Modelo.FindByID(Value);
  if assigned(B) and (TCampo(B).GetCampoOrigem = OID) then
  begin
    Modelo.Erro(Self, 'Referência circular de "' + Nome + '" para "' + b.Nome +'"!', 0);
    Exit; //referência circular
  end;

  if Assigned(FCampoOrigem) and (FCampoOrigem.OID <> Value) then Muda;
  if assigned(B) then  FCampoOrigem := TCampo(B) else FCampoOrigem := nil;
end;

procedure TCampo.SetComplemento(const Value: string);
begin
  if FComplemento <> Value then
  BEGIN
    FComplemento := Value;
    Muda;
  end;
end;

procedure TCampo.SetddlOnDelete(const Value: integer);
begin
  if FddlOnDelete <> Value then
  begin
    FddlOnDelete := Value;
    Muda;
  end;
end;

procedure TCampo.SetddlOnUpdate(const Value: integer);
begin
  if FddlOnUpdate <> Value then
  begin
    FddlOnUpdate := Value;
    Muda;
  end;
end;

procedure TBase.FonteChanged;
begin
  Invalidate;
end;

procedure TCampo.FonteChanged;
begin
  Dono.PosicioneCampos;
//  inherited;
end;

procedure TCampo.to_xml(var node: IXMLNode);
 var mNode: IXMLNode;
     T_O, C_O: integer;
begin
  inherited to_xml(node);
  mNode := node.AddChild('ApenasSeparador');
  mNode.Attributes['Valor'] := BoolToStr(ApenasSeparador);
  if not ApenasSeparador then
  begin
    mNode := node.AddChild('IsKey');
    mNode.Attributes['Valor'] := BoolToStr(IsKey);

    mNode := node.AddChild('IsFKey');
    mNode.Attributes['Valor'] := BoolToStr(IsFKey);

    mNode := node.AddChild('Tipo');
    mNode.Attributes['Valor'] := Tipo;

    T_O := TabOrigem;
    C_O := CampoOrigem;
    if Modelo.Copiando then
    begin
      T_O := 0;
      C_O := 0;
    end;

    mNode := node.AddChild('TabOrigem');
    mNode.Attributes['Valor'] := T_O;

    mNode := node.AddChild('CampoOrigem');
    mNode.Attributes['Valor'] := C_O;

    mNode := node.AddChild('Complemento');
    mNode.Attributes['Valor'] := Complemento;

    mNode := node.AddChild('OnUpdate');
    mNode.Attributes['Valor'] := ddlOnUpdate;
    mNode := node.AddChild('OnDelete');
    mNode.Attributes['Valor'] := ddlOnDelete;
  end;
end;

procedure TCampo.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if not isMouseDown then Exit;
  isMouseDown := false;
  Screen.Cursor := oldCr;
  if PtInRect(GetClientRect, Point(X, Y)) then
  begin
    Dono.PodeTrocar(Self, Point(X + Left, Y + Top));
    OverMe := false;
    exit;
  end;
  Dono.PrepareParaTrocar(Self, Point(X + Left, Y + Top));
end;

procedure TCampo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if isMouseDown and not (PtInRect(GetClientRect, Point(X, Y))) then
    Dono.PodeTrocar(Self, Point(X + Left, Y + Top));
end;

procedure TCampo.SetOverMe(const Value: Boolean);
begin
  if Value = FOverMe then Exit;
  FOverMe := Value;
  if Value then
  begin
    FBkpFontColor := Canvas.Font.Color;
    Canvas.Font.Color := IfThen(Canvas.Font.Color = clBlue, clYellow, clBlue);
    Invalidate;
  end else
  begin
    Canvas.Font.Color := FBkpFontColor;
    Invalidate;
  end;
end;

function TCampo.GetTabOrigem: Integer;
begin
  if ValorInicialFKTabOrigem <> 0 then
  begin
    SetTabOrigem(ValorInicialFKTabOrigem);
    ValorInicialFKTabOrigem := 0;
  end;
  if Assigned(FTabOri) AND (Modelo.FindByID(FTabOri.OID) <> nil) then Result := FTabOri.OID else
  begin
    Result := 0;
    FTabOri := nil;
    FCampoOrigem := nil;
  end;
end;

function TCampo.GetTipo: String;
begin
  if IsFKey then
  begin
    if GetCampoOrigem <> 0 then Result := FCampoOrigem.Tipo else Result := FTipo;
  end else Result := FTipo;
end;

function TCampo.Get_CampoOri: Integer;
begin
  if Assigned(FCampoOrigem) then Result := FCampoOrigem.OID else Result := -1;
end;

function TCampo.Get_Dono: Integer;
begin
  if Assigned(FDono) then Result := FDono.OID else Result := -1;
end;

function TCampo.Get_TabOri: Integer;
begin
  if Assigned(FTabOri) then Result :=  FTabOri.OID else Result := -1;
end;

procedure TCampo.Load;
begin
  inherited;
  FDono := TTabela(Modelo.FindByID(_FDono));
  if F_TabOri <> -1 then
  begin
    FTabOri := TTabela(Modelo.FindByID(F_TabOri));
    ValorInicialFKTabOrigem := 0;
  end;
  if F_CampoOri <> -1 then
  begin
    FCampoOrigem := TCampo(Modelo.FindByID(F_CampoOri));
    ValorInicialFKCampoOrigem := 0;
  end;
end;

procedure TCampo.SetTabOrigem(const Value: Integer);
  var B: TBase;
begin
  if Modelo.staLoading then Exit;
//  if (Value <> 0) or (Assigned(FTabOri) and (FTabOri.OID <> Value)) then Muda;
  if Value = 0 then B := nil else
    B := Modelo.FindByID(Value);
  if assigned(B) then
  begin
    if FTabOri <> TTabela(B) then
    begin
      FCampoOrigem := nil;
      Muda;
    end;
    FTabOri := TTabela(B);
  end else
  begin
    if FTabOri = nil then Muda;
    FTabOri := nil;
    FCampoOrigem := nil;
  end;
end;

procedure TCampo.SetPrecisao(const Value: string);
begin
  FPrecisao := Value;
end;

{ TLigaTabela }

function TLigaTabela.CanLiga(B: TBase): boolean;
  var i: Integer;
begin
  Result := true;
  for i := 0 to FLigacoes.Count -1 do
  begin
    if TLigacao(FLigacoes[i]).BasePertence(B) or (FLigacoes.Count > 1) then
    begin
      Result := false;
      exit;
    end;
  end;
end;

procedure TLigaTabela.CMMouseEnter(var Message: TMessage);
begin
  Visivel := true;
end;

procedure TLigaTabela.CMMouseLeave(var Message: TMessage);
begin
  Visivel := false;
end;

constructor TLigaTabela.Create(AOwner: TComponent);
  var i: integer;
begin
  inherited;
  NaoPinteNome := true;
  for i:= 1 to 4 do Pontos[I].Recuo := 0;
  SetBounds(Left, Top, 15, 15);
end;

destructor TLigaTabela.Destroy;
begin
  if (not (csDestroying in Modelo.ComponentState)) and (not Modelo.staLoading) then
  begin
    Destruindo_se;
  end;
  inherited;
end;

procedure TLigaTabela.Destruindo_se;
  var tab1, tab2: TTabela;
      tl: Integer;
begin
  //A ligação está sendo destruída, porém, o modelo não está!
  tab1 := TTabela(TLigacao(FLigacoes[0]).Ponta);
  tab2 := TTabela(TLigacao(FLigacoes[1]).Ponta);
  //uma das duas tableas está sendo destruída? sim:
  if tab1.Destruindo or tab2.Destruindo then
  begin
    if tab1.Destruindo then tab2.ReleaseTable(tab1);
    if tab2.Destruindo then tab1.ReleaseTable(tab2);
    exit;
  end;
  //:não - é apenas aligatabela
  tl := tab1.CountLigToTabela(tab2);
  if tl = 1 then //é apenas esta.
  begin
    tab1.ReleaseTable(tab2);
    tab2.ReleaseTable(tab1);
  end;
end;

procedure TLigaTabela.GetCard(out Card00, Card01: Integer);
begin
  Card00 := TLigacao(FLigacoes[0]).FCard.Cardinalidade;
  Card01 := TLigacao(FLigacoes[1]).FCard.Cardinalidade;
end;

function TLigaTabela.HasTable(aTabela: TTabela): boolean;
begin
  Result := TTabela(TLigacao(FLigacoes[0]).Ponta) = aTabela;
  if not Result then Result := TTabela(TLigacao(FLigacoes[1]).Ponta) = aTabela;
end;

procedure TLigaTabela.LigacaoEventoDoMouse(entrou: boolean);
begin
  Visivel := entrou;
end;

procedure TLigaTabela.Paint;
  var P1, P2, Tmp: Integer;
begin
  if Selecionado or Visivel then
    with canvas do
  begin
    Pen.Style:=psSolid;
    Pen.Color:=$00B3B3B3;
    Ellipse(0,0, Width, Height);
    Pen.Color := clBlack;
    Ellipse(0,0, Width-1, Height -1);
  end else
  if FLigacoes.Count > 1 then
    with Canvas do
  begin
    P1 := TLigacao(FLigacoes[0]).MePonto(Self);
    P2 := TLigacao(FLigacoes[1]).MePonto(Self);
    if p1 > p2 then
    begin
      tmp := P1; P1 := P2; P2 := tmp;
    end;
    case P1 of
      1: MoveTo(0, Height div 2);
      2: MoveTo(Width div 2, 0);
      3: MoveTo(Width, Height div 2);
      4: MoveTo(Width div 2, Height);
    end;
    LineTo(Width div 2, Height div 2);
    case P2 of
      1: LineTo(0, Height div 2);
      2: LineTo(Width div 2, 0);
      3: LineTo(Width, Height div 2);
      4: LineTo(Width div 2, Height);
    end;
    FPt1 := P1;
    FPt2 := P2;
  end;
end;

procedure TLigaTabela.PrepareToAtive(Lg: TLigacao);
  var c: integer;
begin
  inherited;
  C := Lg.MePonto(Self);
  if (C <> FPt1) and (C <> FPt2) then Invalidate;
end;

function TLigaTabela.Relacione(T: TTabela): boolean;
  var L : TLigacao;
begin
  Result := false;
  if Assigned(T) then
  begin
    if CanLiga(T) then
    begin
      L := TLigacao.Create(Modelo);
      T.Liga(L);
      Result := L.Generate(Self, T);
      FLigacoes.Add(L);
      L.MostraCardinalidade := true;
      L.FCard.ToCardinalidade(2);
    end;
  end;
end;

procedure TLigaTabela.reSetBounds;
begin
  reposicione;
//  inherited;
end;

procedure TLigaTabela.SendMouseMove;
begin
//  inherited;
end;

procedure TLigaTabela.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  AWidth := 15;
  AHeight := 15;
  inherited;
end;

procedure TLigaTabela.SetCard(Card00, Card01: Integer);
begin
  TLigacao(FLigacoes[0]).FCard.Cardinalidade := Card00;
  TLigacao(FLigacoes[1]).FCard.Cardinalidade := Card01;
end;

procedure TLigaTabela.SetSelecionado(const Value: boolean);
  var i: integer;
      C: TColor;
begin
  inherited;
  C := clGreen;
  if Value then C := clBlue;
  for i:= 0 to FLigacoes.Count -1 do
  begin
    TLigacao(FLigacoes[i]).FCard.FCorSel := C;
    TLigacao(FLigacoes[i]).FCard.SelLine(Value);
  end;
  BringToFront;
end;

procedure TLigaTabela.SetVisivel(const Value: boolean);
begin
  FVisivel := Value;
  Invalidate;
end;

procedure TBase.Setassociacao(const Value: TBase);
begin
  Fassociacao := Value;
end;

{ TBase }

function TBase.GetLigacao(LigadoCom: TBase): TLigacao;
  var i: integer;
begin
  Result := nil;
  if LigadoCom = Self then Exit;
  for i := 0 to FLigacoes.Count -1 do
  begin
    if TLigacao(FLigacoes[i]).BasePertence(LigadoCom) then
    begin
      Result := TLigacao(FLigacoes[i]);
      Break;
    end;
  end;
end;
function TBase.Get_AOcultos: string;
begin
  Result := AOcultos._AOcultos;
end;

procedure TBase.SelecionarAtributos;
  var i: integer;
begin
  for i := 0 to FAtributos.Count -1 do
  begin
    TAtributo(FAtributos[i]).MeSelecione;
  end;
end;

{ TMaxRelacao }

procedure TMaxRelacao.GetEntidadtes(aLista: TList);
  var i: integer;
begin
  for i := 0 to FLigacoes.Count -1 do
  begin
    if (TLigacao(FLigacoes[i]).Ponta is TBaseEntidade) then
       aLista.Add(TLigacao(FLigacoes[i]).Ponta);
  end;
end;

function TMaxRelacao.QtdEntidadesLigadas: Integer;
  var i: integer;
begin
  Result := 0;
  for i := 0 to FLigacoes.Count -1 do
  begin
    if TLigacao(FLigacoes[i]).Ponta is TEntidade then Inc(Result);
  end;
end;

{ TSelecao }

procedure TSelecao.Paint;
begin
  inherited;
  with Canvas do
  begin
    Brush.Style := bsClear;
    Rectangle(GetClientRect);
  end;
end;

{ TOrigem }

constructor TOrigem.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TBase then Modelo := TBase(AOwner).Modelo
    else
      if AOwner is TModelo then Modelo := TModelo(AOwner);
  Parent := Modelo;
end;

{ TSeta }

procedure TSeta.Alinhe(aPosicao: integer);
  var l, t, w, h: Word;
begin
  l := Left;
  t := Top;
  h := Height;
  w := Width;
  SendToBack;
  Posicao := aPosicao;
  case aPosicao of
    1, 2: begin
      SetBounds(Pai.Left - Largura - 2, Pai.Top, Largura, Pai.Height);
    end;
    3, 4: begin
      SetBounds(Pai.Left, Pai.Top - Largura -2, Pai.Width, Largura);
    end;
    5, 6: begin
      SetBounds(Pai.Left + Pai.Width + 2, Pai.Top, Largura, Pai.Height);
    end;
    7, 8: begin
      SetBounds(Pai.Left, Pai.Top + Pai.Height + 2, Pai.Width, Largura);
    end;
  end;
  if not ((l <> Left) or (t <> Top) or (h <> height) or (w <> width)) then Invalidate;
  if (Left < 0) or
     (Top < 0) or
     (Left + Width > Modelo.Width) or
     (Top + Height > Modelo.Height) or (aPosicao = 0)
  then Visible := false else Visible := True;
end;

constructor TSeta.Create(AOwner: TComponent);
begin
  inherited;
  //SetSubComponent(true);
  if AOwner is TBase then
    Pai := TBase(AOwner);
  Posicao := 0;
  Largura := 9;
end;

procedure TSeta.Paint;
  var W, H, L: Integer;
begin
  inherited;
  W := Width div 2 + 1;
  H := Height div 2 + 1;
  L := Largura div 2 + 1;
  with Canvas do
  begin
    case posicao of
//      1, 6: begin
//        MoveTo(W, 1);
//        LineTo(W, (Height div 3) - 1);
//      end;
//      2, 5: begin
//        MoveTo(W, 1 + (Height div 3));
//        LineTo(W, Height - 1);
//      end;
//      3, 8: begin
//        MoveTo(1 + (Width div 3), H);
//        LineTo(Width -1, H);
//      end;
//      4, 7: begin
//        MoveTo(1, H);
//        LineTo((Width div 3) -1, H);
//      end;
      1, 2, 5, 6: begin
        MoveTo(W, 1);
        LineTo(W, Height - 1);
      end;
      3, 4, 7, 8: begin
        MoveTo(1, H);
        LineTo(Width -1, H);
      end;
    end;
    case posicao of
      1, 6: begin
        MoveTo(W, 1);
        LineTo(1, L);
        LineTo(L, L -2);
        LineTo(Largura, L);
        LineTo(W, 1);
      end;
      2, 5: begin
        MoveTo(W, Height -1);
        LineTo(1, Height - L);
        LineTo(L, Height - L + 3);
        LineTo(Largura, Height - L);
        LineTo(W, Height - 1);
      end;
      3, 8: begin
        MoveTo(Width -1, H);
        LineTo(Width - L, 1);
        LineTo(Width - L + 3, H);
        LineTo(Width - L, Height);
        LineTo(Width -1, H);
      end;
      4, 7: begin
        MoveTo(1, H);
        LineTo(L, 1);
        LineTo(L - 2, H);
        LineTo(L, Height);
        LineTo(1, H);
      end;
    end;
  end;
end;

procedure TSeta.Realinhe;
begin
  if Posicao > 0 then Alinhe(Posicao);
end;

end.
