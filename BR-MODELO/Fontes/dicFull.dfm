object brFmDicFull: TbrFmDicFull
  Left = 264
  Top = 123
  BorderStyle = bsDialog
  Caption = 'Dicion'#225'rio de dados'
  ClientHeight = 475
  ClientWidth = 586
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Dicionario: TRichEdit
    Left = 25
    Top = 0
    Width = 561
    Height = 409
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitTop = 21
    ExplicitHeight = 435
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 456
    Width = 586
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 25
    Height = 409
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    ExplicitTop = 21
    ExplicitHeight = 435
  end
  object pnCommands: TPanel
    Left = 0
    Top = 409
    Width = 586
    Height = 47
    Align = alBottom
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    ExplicitTop = 356
    object btnSalvar: TButton
      Left = 252
      Top = 4
      Width = 106
      Height = 39
      Caption = 'Salvar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnImprimir: TButton
      Left = 364
      Top = 4
      Width = 106
      Height = 39
      Caption = 'Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnImprimirClick
    end
    object btnFechar: TButton
      Left = 476
      Top = 4
      Width = 106
      Height = 39
      Caption = 'Fechar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnFecharClick
    end
  end
  object ActionManager1: TActionManager
    Left = 496
    Top = 56
    StyleName = 'XP Style'
    object Fechar: TAction
      Caption = '&Fechar'
    end
    object Salvar: TAction
      Caption = 'Salvar'
    end
    object Imprimir: TAction
      Caption = 'Imprimir'
    end
  end
end
