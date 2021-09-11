object brFmtCfgFonte: TbrFmtCfgFonte
  Left = 350
  Top = 210
  BorderStyle = bsDialog
  Caption = 'Op'#231#245'es gerais'
  ClientHeight = 173
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Janela: TPanel
    Left = 0
    Top = 0
    Width = 338
    Height = 173
    Align = alClient
    BevelWidth = 2
    DragKind = dkDock
    TabOrder = 0
    object Panel4: TPanel
      Left = 2
      Top = 2
      Width = 334
      Height = 24
      Align = alTop
      BevelOuter = bvLowered
      BorderWidth = 1
      TabOrder = 0
    end
    object OpcoesGerais: TPageControl
      Left = 2
      Top = 26
      Width = 334
      Height = 145
      ActivePage = TabFont
      Align = alClient
      TabOrder = 1
      TabPosition = tpBottom
      OnChange = OpcoesGeraisChange
      object TabFont: TTabSheet
        Caption = 'Fonte'
        TabVisible = False
        object ToolBar3: TToolBar
          Left = 0
          Top = 0
          Width = 326
          Height = 25
          AutoSize = True
          ButtonHeight = 21
          ButtonWidth = 81
          Caption = 'ToolBar3'
          EdgeBorders = [ebLeft, ebTop, ebRight]
          Flat = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowCaptions = True
          TabOrder = 0
          object ToolButton1: TToolButton
            Left = 0
            Top = 2
            Action = Fonte
          end
          object NomeObj: TPanel
            Left = 81
            Top = 2
            Width = 225
            Height = 21
            BevelOuter = bvNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
          object ToolButton3: TToolButton
            Left = 0
            Top = 2
            Width = 8
            Caption = 'ToolButton3'
            ImageIndex = 1
            Wrap = True
            Style = tbsSeparator
          end
        end
        object ScrollBox1: TScrollBox
          Left = 0
          Top = 25
          Width = 326
          Height = 112
          Align = alClient
          Color = clSilver
          ParentColor = False
          TabOrder = 1
          object ef_font: TLabel
            Left = 0
            Top = 0
            Width = 322
            Height = 108
            Align = alClient
            Alignment = taCenter
            Caption = 'Fonte'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clSilver
            Font.Height = -32
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Transparent = True
            ExplicitWidth = 82
            ExplicitHeight = 37
          end
          object Font_style: TLabel
            Left = 5
            Top = 59
            Width = 13
            Height = 13
            Caption = 'xx'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Font_width: TLabel
            Left = 5
            Top = 32
            Width = 13
            Height = 13
            Caption = 'xx'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Font_name: TLabel
            Left = 5
            Top = 6
            Width = 13
            Height = 13
            Caption = 'xx'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object font_cor: TLabel
            Left = 5
            Top = 90
            Width = 75
            Height = 13
            Caption = 'Cor da fonte:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Pan: TPanel
            Left = 85
            Top = 89
            Width = 22
            Height = 15
            TabOrder = 0
          end
        end
      end
    end
  end
  object Button1: TButton
    Left = 258
    Top = 140
    Width = 71
    Height = 22
    Caption = 'Fechar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object FontDlg: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdEffects, fdApplyButton]
    OnApply = FontDlgApply
    Left = 298
    Top = 86
  end
  object ActionManager1: TActionManager
    Left = 262
    Top = 86
    StyleName = 'XP Style'
    object Fonte: TAction
      Caption = 'Alterar Fonte'
      OnExecute = FonteExecute
      OnUpdate = FonteUpdate
    end
  end
end
