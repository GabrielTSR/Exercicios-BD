object brFmPrincipal: TbrFmPrincipal
  Left = 274
  Top = 100
  Caption = 'brModelo 3.0'
  ClientHeight = 536
  ClientWidth = 853
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 853
    Height = 536
    Align = alClient
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 642
      Top = 0
      Height = 517
      Align = alRight
      Color = 16728642
      ParentColor = False
      OnCanResize = Splitter1CanResize
      OnMoved = Splitter1Moved
      ExplicitLeft = 734
      ExplicitTop = -6
    end
    object Status: TStatusBar
      Left = 0
      Top = 517
      Width = 853
      Height = 19
      Panels = <
        item
          Width = 32
        end
        item
          Width = 40
        end
        item
          Width = 40
        end
        item
          Width = 200
        end
        item
          Style = psOwnerDraw
          Width = 60
        end
        item
          Width = 50
        end>
      OnDrawPanel = StatusDrawPanel
    end
    object Juntador: TPanel
      Left = 645
      Top = 0
      Width = 208
      Height = 517
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object PaiScroller: TPanel
        Left = 0
        Top = 0
        Width = 208
        Height = 24
        Align = alTop
        BevelOuter = bvLowered
        BorderWidth = 1
        TabOrder = 0
      end
      object Opcoes: TPageControl
        Left = 0
        Top = 24
        Width = 208
        Height = 493
        ActivePage = TabSheet1
        Align = alClient
        OwnerDraw = True
        Style = tsButtons
        TabOrder = 1
        object TabSheet1: TTabSheet
          Caption = 'Sele'#231#227'o'
          TabVisible = False
          object Splitter2: TSplitter
            Left = 0
            Top = 402
            Width = 200
            Height = 1
            Cursor = crVSplit
            Align = alBottom
            Color = 16728642
            MinSize = 15
            ParentColor = False
            OnCanResize = SplitterFDPCanResize
            ExplicitTop = 387
          end
          object PanEditor: TPanel
            Left = 0
            Top = 0
            Width = 200
            Height = 402
            Align = alClient
            BevelInner = bvRaised
            BevelOuter = bvLowered
            TabOrder = 0
            ExplicitHeight = 388
          end
          object PanHelp: TPanel
            Left = 0
            Top = 403
            Width = 200
            Height = 80
            Align = alBottom
            BevelInner = bvRaised
            BevelOuter = bvLowered
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsItalic]
            ParentFont = False
            TabOrder = 1
            object lbl_ajuda: TLabel
              Left = 2
              Top = 2
              Width = 196
              Height = 76
              Align = alClient
              Color = clBtnFace
              FocusControl = baseme
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              WordWrap = True
              ExplicitWidth = 3
              ExplicitHeight = 14
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Atr. ocultos'
          ImageIndex = 1
          TabVisible = False
          object ToolBar4: TToolBar
            Left = 0
            Top = 0
            Width = 200
            Height = 25
            AutoSize = True
            ButtonHeight = 21
            ButtonWidth = 44
            Caption = 'ToolBar4'
            EdgeBorders = [ebLeft, ebTop, ebRight]
            Flat = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ShowCaptions = True
            TabOrder = 0
            object ao_Novo: TToolButton
              Left = 0
              Top = 0
              Caption = 'Novo'
              ImageIndex = 0
              OnClick = ao_NovoClick
            end
            object ao_Editar: TToolButton
              Left = 44
              Top = 0
              Caption = 'Editar'
              ImageIndex = 2
              OnClick = ao_EditarClick
            end
            object ToolButton17: TToolButton
              Left = 88
              Top = 0
              Width = 8
              Caption = 'ToolButton17'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object ao_Excluir: TToolButton
              Left = 96
              Top = 0
              Caption = 'Excluir'
              ImageIndex = 1
              OnClick = ao_ExcluirClick
            end
          end
          object TreeAtt: TTreeView
            Left = 0
            Top = 50
            Width = 200
            Height = 433
            Align = alClient
            Images = brDM.attImg
            Indent = 19
            ReadOnly = True
            TabOrder = 1
            OnClick = TreeAttClick
          end
          object ToolBar5: TToolBar
            Left = 0
            Top = 25
            Width = 200
            Height = 25
            AutoSize = True
            ButtonHeight = 21
            ButtonWidth = 103
            Caption = 'ToolBar5'
            EdgeBorders = [ebLeft, ebRight, ebBottom]
            Flat = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ShowCaptions = True
            TabOrder = 2
            object ao_exibir: TToolButton
              Left = 0
              Top = 0
              Caption = 'Exibir no  modelo'
              ImageIndex = 0
              OnClick = ao_exibirClick
            end
          end
        end
      end
    end
    object pb: TPanel
      Left = 0
      Top = 0
      Width = 642
      Height = 517
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object SplitterFDP: TSplitter
        Left = 0
        Top = 477
        Width = 642
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        Color = clNavy
        MinSize = 15
        ParentColor = False
        OnCanResize = SplitterFDPCanResize
        ExplicitTop = 453
        ExplicitWidth = 558
      end
      object Box: TScrollBox
        Left = 0
        Top = 31
        Width = 642
        Height = 446
        HorzScrollBar.Smooth = True
        HorzScrollBar.Style = ssFlat
        VertScrollBar.Smooth = True
        VertScrollBar.Style = ssFlat
        Align = alClient
        TabOrder = 0
        OnMouseWheelDown = BoxMouseWheelDown
        OnMouseWheelUp = BoxMouseWheelUp
      end
      object baseme: TPanel
        Left = 0
        Top = 0
        Width = 642
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object ToolBar3: TToolBar
          Left = 313
          Top = 0
          Width = 329
          Height = 31
          Align = alClient
          AutoSize = True
          ButtonHeight = 29
          ButtonWidth = 92
          Caption = 'ToolBar3'
          EdgeBorders = [ebLeft, ebTop]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ShowCaptions = True
          TabOrder = 0
          object ToolButton14: TToolButton
            Left = 0
            Top = 0
            Caption = 'Modelos abertos'
            DropdownMenu = MenuModelos
            ImageIndex = 2
            Style = tbsDropDown
            OnClick = Todos_modelosExecute
          end
          object ToolButton15: TToolButton
            Left = 107
            Top = 0
            Caption = 'Localizar objeto'
            DropdownMenu = MenuObjetos
            ImageIndex = 2
            Style = tbsDropDown
            OnClick = Todos_objetosExecute
          end
        end
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 313
          Height = 31
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object ToolBar2: TToolBar
            Left = 0
            Top = 0
            Width = 313
            Height = 31
            Align = alLeft
            ButtonHeight = 38
            ButtonWidth = 39
            Caption = 'ToolBar2'
            EdgeBorders = [ebLeft, ebTop]
            Images = brDM.img
            TabOrder = 0
          end
        end
      end
      object Util: TRichEdit
        Left = 0
        Top = 480
        Width = 642
        Height = 37
        Align = alBottom
        Color = clInfoBk
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
        WordWrap = False
      end
    end
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = arq_abrir
          end
          item
            Action = arq_novo
            ShortCut = 16462
          end
          item
            Action = arq_novo
            Caption = 'N&ovo (Conceitual)'
            ShortCut = 16462
          end>
      end
      item
      end
      item
      end
      item
      end
      item
        Items = <
          item
            Caption = '&Sistema'
          end
          item
            Caption = 'Es&quema Conceitual'
          end
          item
            Caption = '&Esquema L'#243'gico'
          end>
      end
      item
        Items = <
          item
            Action = arq_novo
            Caption = '&Modelo Conceitual'
            ImageIndex = 29
            ShortCut = 16462
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = NovoLogico
            Caption = 'M&odelo L'#243'gico'
            ImageIndex = 28
            ShortCut = 16460
            CommandProperties.ButtonSize = bsLarge
          end>
      end
      item
        Items = <
          item
            Action = arq_abrir
            ImageIndex = 38
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = arq_Salvar
            ImageIndex = 39
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = arq_salvarc
            ImageIndex = 40
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = arq_fechar
            ImageIndex = 37
            CommandProperties.ButtonSize = bsLarge
          end>
      end
      item
        Items = <
          item
            Action = modExportJPG
            Caption = 'E&xportar para JPEG'
          end
          item
            Action = modExportBMP
            Caption = '&Exportar para Bitmap'
          end>
      end
      item
        Items = <
          item
            Action = Imprimir
            Caption = 'Im&primir'
            ImageIndex = 31
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = dicFull
            Caption = '&Gerar dicion'#225'rio do esquema'
            ImageIndex = 35
            ShortCut = 123
            CommandProperties.ButtonSize = bsLarge
          end>
      end
      item
        Items = <
          item
            Action = xsl_maker
            Caption = '&Visualizar Esquema XML com XSLT'
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = verLogs
            Caption = '&Exibir logs de opera'#231#245'es'
          end
          item
            Action = limpar_logs
            Caption = '&Limpar logs'
          end
          item
            Action = salva_logs
            Caption = '&Salvar logs'
          end>
      end
      item
        Items = <
          item
            Action = autoSalvar
            Caption = '&Auto Salvar'
            ImageIndex = 43
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = cfg
            Caption = '&Configura'#231#245'es'
            ImageIndex = 34
            CommandProperties.ButtonSize = bsLarge
          end>
      end
      item
        Items = <
          item
            ChangesAllowed = [caModify]
            Items = <
              item
                Caption = '&ActionClientItem0'
              end>
            Caption = '&ActionClientItem0'
            KeyTip = 'F'
          end>
        AutoSize = False
      end
      item
        AutoSize = False
      end
      item
        Items = <
          item
            Action = edt_Desfazer
            Caption = '&Desfazer'
            ImageIndex = 42
            ShortCut = 16474
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = edt_Refazer
            Caption = '&Refazer'
            ImageIndex = 41
            ShortCut = 16466
            CommandProperties.ButtonSize = bsLarge
          end>
      end
      item
        Items = <
          item
            Action = edt_copy
            ImageIndex = 14
            ShortCut = 16451
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = edt_cut
            ImageIndex = 13
            ShortCut = 16472
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = edt_paste
            ImageIndex = 15
            ShortCut = 16470
            CommandProperties.ButtonSize = bsLarge
          end>
      end
      item
        Items = <
          item
            Action = Exibir_fonte
            Caption = 'E&xibir fonte'
            ImageIndex = 27
            ShortCut = 16454
            CommandProperties.ButtonSize = bsLarge
          end>
      end
      item
      end
      item
        Visible = False
      end>
    Images = brDM.img
    Left = 203
    Top = 127
    StyleName = 'Platform Default'
    object arq_novo: TAction
      Tag = -2
      Category = 'Sistema'
      Caption = '&Novo (Conceitual)'
      Hint = 'Novo modelo conceitual'
      ImageIndex = 29
      ShortCut = 16462
      OnExecute = arq_novoExecute
    end
    object arq_abrir: TAction
      Tag = -2
      Category = 'Sistema'
      Caption = '&Abrir'
      Hint = 'Abrir modelo (L'#243'gico ou Conceitual)'
      ImageIndex = 38
      OnExecute = arq_abrirExecute
    end
    object arq_fechar: TAction
      Category = 'Sistema'
      Caption = '&Fechar'
      Hint = 'Fechar modelo'
      ImageIndex = 37
      OnExecute = arq_fecharExecute
      OnUpdate = arq_fecharUpdate
    end
    object arq_Salvar: TAction
      Category = 'Sistema'
      Caption = '&Salvar'
      Hint = 'Salvar modelo'
      ImageIndex = 39
      OnExecute = arq_SalvarExecute
    end
    object arq_salvarc: TAction
      Category = 'Sistema'
      Caption = 'Salvar &Como...'
      ImageIndex = 40
      OnExecute = arq_salvarcExecute
    end
    object sis_sair: TAction
      Tag = -2
      Category = 'Sistema'
      Caption = 'Sai&r'
      OnExecute = sis_sairExecute
    end
    object criar_Entidade: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Entidade'
      GroupIndex = 1
      Hint = 'Criar entidade'
      ImageIndex = 4
      OnExecute = CriarExecute
      OnUpdate = criar_EntidadeUpdate
    end
    object criar_relacionamento: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Relacionamento'
      GroupIndex = 1
      Hint = 'Criar rela'#231#227'o'
      ImageIndex = 8
      OnExecute = CriarExecute
      OnUpdate = criar_EntidadeUpdate
    end
    object criar_GerEsp: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Especializa'#231#227'o'
      GroupIndex = 1
      Hint = 'Especializa'#231#227'o'
      ImageIndex = 5
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object criar_multiRelacao: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Entidade Assossiativa'
      GroupIndex = 1
      Hint = 'Entidade Associativa'
      ImageIndex = 7
      OnExecute = CriarExecute
      OnUpdate = criar_EntidadeUpdate
    end
    object criar_texto: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Texto (Com moldura)'
      GroupIndex = 1
      Hint = 'Texto (Observa'#231#227'o)'
      ImageIndex = 9
      OnExecute = CriarExecute
    end
    object SavarDT: TAction
      Category = 'tabAction'
      Caption = 'Salvar'
    end
    object ReverterDT: TAction
      Category = 'tabAction'
      Caption = 'Cancelar'
    end
    object criar_Cancelar: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Cancelar'
      Checked = True
      GroupIndex = 1
      Hint = 'Cancelar'
      ImageIndex = 3
      OnExecute = CriarExecute
      OnUpdate = criar_CancelarUpdate
    end
    object criar_atributo: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Atributo'
      GroupIndex = 1
      Hint = 'Cria'#231#227'o de atributo'
      ImageIndex = 17
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object criar_ligacao: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Liga'#231#227'o'
      GroupIndex = 1
      Hint = 'Ligar objetos'
      ImageIndex = 6
      OnExecute = CriarExecute
      OnUpdate = criar_ligacaoUpdate
    end
    object criar_altorelacionamento: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Auto-Relacionar'
      GroupIndex = 1
      ImageIndex = 1
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object del_base: TAction
      AutoCheck = True
      Caption = 'Excluir'
      GroupIndex = 1
      Hint = 'Apagar'
      ImageIndex = 2
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object Criar: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Criar'
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object Del: TAction
      Caption = 'Excluir sele'#231#227'o'
      Hint = 'Excluir o objeto selecionado'
      ImageIndex = 10
      OnExecute = DelExecute
    end
    object Criar_espA: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Especializa'#231#227'o (A)'
      GroupIndex = 1
      Hint = 'Especializa'#231#227'o exclusiva com cria'#231#227'o de entidades'
      ImageIndex = 12
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object Criar_espB: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Especializa'#231#227'o (B)'
      GroupIndex = 1
      Hint = 'Especializa'#231#227'o n'#227'o-exclusiva com cria'#231#227'o de entidade'
      ImageIndex = 11
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object promo_ea: TAction
      Caption = 'Promover a Entidade Associativa'
      Enabled = False
      OnExecute = promo_eaExecute
    end
    object promo_entidade: TAction
      Caption = 'Promover a Entidade'
      Enabled = False
      OnExecute = promo_entidadeExecute
    end
    object ao_Ocultar: TAction
      Caption = 'Ocultar atributo'
      Enabled = False
      OnExecute = ao_OcultarExecute
    end
    object ac_orgAtt: TAction
      Caption = 'Organizar atributos'
      Enabled = False
      ShortCut = 16463
      OnExecute = ac_orgAttExecute
    end
    object Imprimir: TAction
      Category = 'Sistema'
      Caption = 'Im&primir...'
      Hint = 'Imprimir modelo'
      ImageIndex = 31
      OnExecute = ImprimirExecute
    end
    object edt_copy: TAction
      Category = 'Editar'
      Caption = '&Copiar'
      ShortCut = 16451
      OnExecute = edt_copyExecute
    end
    object edt_cut: TAction
      Category = 'Editar'
      Caption = '&Recortar'
      ShortCut = 16472
      OnExecute = edt_cutExecute
    end
    object edt_paste: TAction
      Category = 'Editar'
      Caption = 'C&olar'
      ShortCut = 16470
      OnExecute = edt_pasteExecute
    end
    object mod_exibirHint: TAction
      Tag = -2
      AutoCheck = True
      Caption = 
        'Ao mover do mouse sobre o objeto, mostrar o(s) atributo(s) ocult' +
        'o(s)'
      Hint = 'Mostrar HINT de atributo oculto no modelo conceitual'
      OnExecute = mod_exibirHintExecute
    end
    object criar_attOpc: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Atributo opcional'
      GroupIndex = 1
      ImageIndex = 16
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object criar_attMult: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Atributo multivalorado'
      GroupIndex = 1
      ImageIndex = 19
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object criar_attComp: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Atributo composto'
      GroupIndex = 1
      ImageIndex = 18
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object criar_attID: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Atributo identificador'
      GroupIndex = 1
      ImageIndex = 0
      OnExecute = CriarExecute
      OnUpdate = CriarUpdate
    end
    object editarDic: TAction
      Caption = 'Dicion'#225'rio de dados do objeto'
      ImageIndex = 26
      ShortCut = 16452
      OnExecute = editarDicExecute
      OnUpdate = editarDicUpdate
    end
    object covToRest: TAction
      Caption = 'Converter Esp. para restrita'
      Hint = 
        'Converter especializa'#231#245'es opcionais em uma especializa'#231#227'o restri' +
        'ta'
      OnExecute = covToRestExecute
    end
    object convToOpc: TAction
      Caption = 'Converter Esp. para opcional'
      Hint = 
        'Converter uma especializa'#231#227'o restrita em especializa'#231#245'es opciona' +
        'is'
      OnExecute = convToOpcExecute
    end
    object dicFull: TAction
      Category = 'Sistema'
      Caption = 'Gerar dicion'#225'rio do esquema'
      ImageIndex = 35
      ShortCut = 123
      OnExecute = dicFullExecute
    end
    object Sobre: TAction
      Tag = -2
      Category = 'Ajuda'
      Caption = '&Sobre...'
      OnExecute = SobreExecute
    end
    object LCriar_tabela: TAction
      Category = 'Esquema L'#243'gico'
      AutoCheck = True
      Caption = 'Criar Tabela'
      GroupIndex = 1
      Hint = 'Modelo l'#243'gico: Criar Tabela'
      ImageIndex = 21
      OnExecute = CriarExecute
      OnUpdate = criar_EntidadeUpdate
    end
    object LCriar_Relacao: TAction
      Category = 'Esquema L'#243'gico'
      AutoCheck = True
      Caption = 'Criar Relacionamento'
      GroupIndex = 1
      Hint = 'Modelo l'#243'gico: Criar Relacionamento'
      ImageIndex = 22
      OnExecute = CriarExecute
      OnUpdate = LCriar_RelacaoUpdate
    end
    object LCriar_campo: TAction
      Category = 'Esquema L'#243'gico'
      AutoCheck = True
      Caption = 'Criar Campo'
      GroupIndex = 1
      Hint = 'Criar Campo'
      ImageIndex = 23
      OnExecute = CriarExecute
      OnUpdate = LCriar_campoUpdate
    end
    object LCriar_Fk: TAction
      Category = 'Esquema L'#243'gico'
      AutoCheck = True
      Caption = 'Criar Campo Chave Est.'
      GroupIndex = 1
      Hint = 'Criar Campo Chave Estrangeira'
      ImageIndex = 24
      OnExecute = CriarExecute
      OnUpdate = LCriar_campoUpdate
    end
    object LCriar_K: TAction
      Category = 'Esquema L'#243'gico'
      AutoCheck = True
      Caption = 'Criar Campo Chave Pri.'
      GroupIndex = 1
      Hint = 'Criar Campo Chave Prim'#225'ria'
      ImageIndex = 20
      OnExecute = CriarExecute
      OnUpdate = LCriar_campoUpdate
    end
    object cfg: TAction
      Tag = -2
      Category = 'Sistema'
      Caption = 'Configura'#231#245'es...'
      ImageIndex = 34
      OnExecute = cfgExecute
    end
    object LCriar_separador: TAction
      Category = 'Esquema L'#243'gico'
      AutoCheck = True
      Caption = 'Criar Separador'
      GroupIndex = 1
      Hint = 'Criar um separador de campos'
      ImageIndex = 25
      OnExecute = CriarExecute
      OnUpdate = LCriar_campoUpdate
    end
    object editarDicL: TAction
      Category = 'Esquema L'#243'gico'
      Caption = 'Dicion'#225'rio de dados do objeto'
      ImageIndex = 26
      ShortCut = 16452
      OnExecute = editarDicExecute
      OnUpdate = editarDicUpdate
    end
    object exp_Logico: TAction
      Caption = 'Gerar Esquema L'#243'gico'
      Hint = 'Gera modelo l'#243'gico'
      ImageIndex = 35
      OnExecute = exp_LogicoExecute
      OnUpdate = exp_LogicoUpdate
    end
    object NovoLogico: TAction
      Tag = -2
      Category = 'Sistema'
      Caption = 'N&ovo (L'#243'gico)'
      Hint = 'Novo modelo l'#243'gico'
      ImageIndex = 28
      ShortCut = 16460
      OnExecute = NovoLogicoExecute
    end
    object Criar_TextoII: TAction
      Category = 'Criar'
      AutoCheck = True
      Caption = 'Texto (Sem moldura)'
      GroupIndex = 1
      Hint = 'Texto (Observa'#231#227'o)'
      ImageIndex = 27
      OnExecute = CriarExecute
    end
    object verLogs: TAction
      Tag = -2
      Category = 'Log de opera'#231#245'es'
      AutoCheck = True
      Caption = 'Exibir logs de opera'#231#245'es'
      Checked = True
      OnExecute = verLogsExecute
    end
    object limpar_logs: TAction
      Tag = -2
      Category = 'Log de opera'#231#245'es'
      Caption = 'Limpar logs'
      OnExecute = limpar_logsExecute
    end
    object salva_logs: TAction
      Tag = -2
      Category = 'Log de opera'#231#245'es'
      Caption = 'Salvar logs'
      OnExecute = salva_logsExecute
    end
    object autoSalvar: TAction
      Category = 'Sistema'
      Caption = 'Auto Salvar'
      Hint = 'Salvar o modelo automaticamente em tempos pr'#233' configurados'
      ImageIndex = 43
      OnExecute = autoSalvarExecute
      OnUpdate = autoSalvarUpdate
    end
    object act1: TAction
      Category = 'Reabrir'
      Caption = 'act1'
      Visible = False
      OnExecute = act1Execute
      OnUpdate = act1Update
    end
    object act2: TAction
      Category = 'Reabrir'
      Caption = 'act2'
      Visible = False
      OnExecute = act1Execute
      OnUpdate = act1Update
    end
    object act3: TAction
      Category = 'Reabrir'
      Caption = 'act3'
      Visible = False
      OnExecute = act1Execute
      OnUpdate = act1Update
    end
    object act4: TAction
      Category = 'Reabrir'
      Caption = 'act4'
      Visible = False
      OnExecute = act1Execute
      OnUpdate = act1Update
    end
    object act5: TAction
      Category = 'Reabrir'
      Caption = 'act5'
      Visible = False
      OnExecute = act1Execute
      OnUpdate = act1Update
    end
    object xsl_maker: TAction
      Category = 'Sistema'
      Caption = 'Visualizar Esquema XML com XSLT'
      Hint = 'Gera XSL para visualizar modelos'
      OnExecute = xsl_makerExecute
    end
    object selAtt: TAction
      Caption = 'Selecionar atributos'
      Hint = 'Seleciona todos os atributos de um objeto.'
      OnExecute = selAttExecute
    end
    object addXSLT: TAction
      Category = 'Esquema L'#243'gico'
      Caption = 'Incluir/alterar arq. formata'#231#227'o XSL'
      OnExecute = addXSLTExecute
      OnUpdate = criar_EntidadeUpdate
    end
    object edt_Desfazer: TAction
      Category = 'Editar'
      Caption = 'Desfazer'
      ImageIndex = 42
      ShortCut = 16474
      OnExecute = edt_DesfazerExecute
      OnHint = edt_DesfazerHint
    end
    object edt_Refazer: TAction
      Category = 'Editar'
      Caption = 'Refazer'
      ImageIndex = 41
      ShortCut = 16466
      OnExecute = edt_RefazerExecute
      OnHint = edt_RefazerHint
      OnUpdate = edt_DesfazerUpdate
    end
    object aj_site: TAction
      Category = 'Ajuda'
      Caption = 'Site do brModelo'
    end
    object GerarFisico: TAction
      Category = 'Esquema L'#243'gico'
      Caption = 'Gerar Esquema F'#237'sico'
      Enabled = False
      ImageIndex = 47
      OnExecute = GerarFisicoExecute
      OnUpdate = criar_EntidadeUpdate
    end
    object fisicoTemplate: TAction
      Category = 'Esquema L'#243'gico'
      Caption = 'Editar template de conver'#231#227'o'
      ImageIndex = 34
      OnExecute = fisicoTemplateExecute
      OnUpdate = criar_EntidadeUpdate
    end
    object modExportBMP: TAction
      Category = 'Exportar para imagem'
      Caption = 'Exportar para Bitmap'
      OnExecute = modExportBMPExecute
    end
    object modExportJPG: TAction
      Category = 'Exportar para imagem'
      Caption = 'Exportar para JPEG'
      OnExecute = modExportBMPExecute
    end
    object Exibir_fonte: TAction
      Category = 'Editar'
      Caption = 'Exibir fonte'
      ShortCut = 16454
      OnExecute = Exibir_fonteExecute
    end
  end
  object MenuModelos: TPopupMenu
    Images = brDM.attImg
    OnPopup = MenuModelosPopup
    Left = 203
    Top = 283
    object teste1: TMenuItem
      Caption = 'teste'
    end
  end
  object MenuObjetos: TPopupMenu
    Images = brDM.img
    OnPopup = MenuObjetosPopup
    Left = 203
    Top = 231
  end
  object ModeloOpc: TPopupMenu
    Images = brDM.img
    OnPopup = ModeloOpcPopup
    Left = 203
    Top = 335
    object Ocultar1: TMenuItem
      Action = ao_Ocultar
      Caption = 'Ocultar'
    end
    object org1: TMenuItem
      Action = ac_orgAtt
    end
    object Selecionaratributos1: TMenuItem
      Action = selAtt
    end
    object GerarModeloLgico1: TMenuItem
      Action = exp_Logico
    end
    object GerarEsquemaFsico1: TMenuItem
      Action = GerarFisico
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Copiar1: TMenuItem
      Action = edt_copy
    end
    object Recortar1: TMenuItem
      Action = edt_cut
    end
    object Colar1: TMenuItem
      Action = edt_paste
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object EditarFonte1: TMenuItem
      Caption = 'E&ditar Fonte'
      ShortCut = 16454
      OnClick = Exibir_fonteExecute
    end
    object Excluirseleo1: TMenuItem
      Action = Del
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ImprimirExportar1: TMenuItem
      Action = Imprimir
    end
    object Salvar1: TMenuItem
      Action = arq_Salvar
    end
    object Fechar1: TMenuItem
      Action = arq_fechar
    end
    object Editartemplatedeconvero1: TMenuItem
      Action = fisicoTemplate
    end
  end
  object TimerAutoSava: TTimer
    Interval = 300000
    OnTimer = TimerAutoSavaTimer
    Left = 203
    Top = 179
  end
end
