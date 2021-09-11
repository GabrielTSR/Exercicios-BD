object brFmShowFisico: TbrFmShowFisico
  Left = 0
  Top = 0
  Caption = 'Modelo F'#237'sico'
  ClientHeight = 393
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DDL: TRichEdit
    Left = 0
    Top = 0
    Width = 690
    Height = 327
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnChange = DDLChange
    OnKeyDown = DDLKeyDown
    OnSelectionChange = DDLSelectionChange
    ExplicitTop = 23
    ExplicitWidth = 595
    ExplicitHeight = 339
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 374
    Width = 690
    Height = 19
    Panels = <
      item
        Width = 65
      end
      item
        Width = 40
      end
      item
        Width = 40
      end
      item
        Width = 50
      end>
    ExplicitTop = 362
    ExplicitWidth = 595
  end
  object pnCommands: TPanel
    Left = 0
    Top = 327
    Width = 690
    Height = 47
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 341
    ExplicitWidth = 595
    object Button1: TButton
      Left = 467
      Top = 3
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
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 579
      Top = 3
      Width = 106
      Height = 39
      Caption = 'Fechar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object SaveSQL: TSaveDialog
    DefaultExt = 'sql'
    Filter = 'Script SQL|*.sql'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 536
    Top = 32
  end
end
