object brFmCfg: TbrFmCfg
  Left = 350
  Top = 210
  BorderStyle = bsDialog
  Caption = 'Configura'#231#245'es'
  ClientHeight = 318
  ClientWidth = 593
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Janela: TPanel
    Left = 0
    Top = 0
    Width = 593
    Height = 318
    Align = alClient
    BevelWidth = 3
    DragKind = dkDock
    TabOrder = 0
    object Panel4: TPanel
      Left = 3
      Top = 3
      Width = 587
      Height = 24
      Align = alTop
      BevelOuter = bvLowered
      BorderWidth = 1
      Caption = 'Configura'#231#245'es do sistema'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 3
      Top = 27
      Width = 587
      Height = 241
      ActivePage = TabSheet3
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TabWidth = 100
      object TabSheet2: TTabSheet
        Caption = 'Auto Salvamento'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ImageIndex = 1
        ParentFont = False
        ExplicitLeft = 3
        ExplicitTop = 25
        object Label2: TLabel
          Left = 8
          Top = 16
          Width = 301
          Height = 13
          Caption = 'Tempo para o salvamento autom'#225'tico do modelo (em minutos):'
        end
        object SpinEdit1: TSpinEdit
          Left = 312
          Top = 12
          Width = 49
          Height = 22
          MaxValue = 60
          MinValue = 1
          TabOrder = 0
          Value = 5
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Diret'#243'rios'
        ImageIndex = 2
        ExplicitHeight = 232
        object Label1: TLabel
          Left = 13
          Top = 66
          Width = 193
          Height = 13
          Caption = 'Diret'#243'rio para salvar os modelos l'#243'gicos:'
        end
        object sbSelecionarPastaLogico: TSpeedButton
          Tag = 1
          Left = 544
          Top = 82
          Width = 23
          Height = 22
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = sbSelecionarPastaConceitualClick
        end
        object Label3: TLabel
          Left = 13
          Top = 13
          Width = 214
          Height = 13
          Caption = 'Diret'#243'rio para salvar os modelos conceituais:'
        end
        object sbSelecionarPastaConceitual: TSpeedButton
          Left = 544
          Top = 29
          Width = 23
          Height = 22
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = sbSelecionarPastaConceitualClick
        end
        object Label8: TLabel
          Left = 13
          Top = 119
          Width = 190
          Height = 13
          Caption = 'Diret'#243'rio para salvar os modelos f'#237'sicos:'
        end
        object sbSelecionarPastaFisico: TSpeedButton
          Tag = 3
          Left = 544
          Top = 135
          Width = 23
          Height = 22
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = sbSelecionarPastaConceitualClick
        end
        object dirLogico: TEdit
          Left = 12
          Top = 83
          Width = 527
          Height = 21
          TabOrder = 1
        end
        object dirConceitual: TEdit
          Left = 12
          Top = 30
          Width = 527
          Height = 21
          TabOrder = 0
        end
        object dirFisico: TEdit
          Left = 12
          Top = 136
          Width = 527
          Height = 21
          TabOrder = 2
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Atributo oculto'
        ImageIndex = 3
        ExplicitHeight = 232
        object Label4: TLabel
          Left = 8
          Top = 32
          Width = 150
          Height = 13
          Caption = 'Obs: Apenas modelo conceitual'
        end
        object CheckBox1: TCheckBox
          Left = 8
          Top = 9
          Width = 409
          Height = 17
          Action = brFmPrincipal.mod_exibirHint
          TabOrder = 0
        end
      end
      object tbRegistry: TTabSheet
        Caption = '  Windows Registry '
        ImageIndex = 5
        ExplicitHeight = 232
        object Label6: TLabel
          Left = 6
          Top = 5
          Width = 513
          Height = 13
          Caption = 
            'Esta op'#231#227'o permite ao brModelo se registrar para abertura autom'#225 +
            'tica de arquivos com a extens'#227'o ".brM":'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 6
          Top = 117
          Width = 328
          Height = 13
          Caption = 
            '* A aplica'#231#227'o deve ser executada como privil'#233'gios de Administrad' +
            'or.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object btnRegistrar: TButton
          Left = 160
          Top = 56
          Width = 251
          Height = 25
          Caption = 'Registrar brModelo no Windows Registry'
          TabOrder = 0
          OnClick = btnRegistrarClick
        end
      end
    end
    object Panel2: TPanel
      Left = 3
      Top = 268
      Width = 587
      Height = 47
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      ExplicitTop = 269
      object Button1: TButton
        Left = 476
        Top = 3
        Width = 106
        Height = 39
        Caption = 'Cancelar'
        ModalResult = 2
        TabOrder = 0
      end
      object Button2: TButton
        Left = 364
        Top = 3
        Width = 106
        Height = 39
        Caption = 'Salvar'
        Default = True
        ModalResult = 1
        TabOrder = 1
      end
    end
  end
end
