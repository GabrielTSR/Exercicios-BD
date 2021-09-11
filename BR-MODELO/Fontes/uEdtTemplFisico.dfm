object BrFmEdtTemplFisico: TBrFmEdtTemplFisico
  Left = 0
  Top = 0
  Caption = 'Editor'
  ClientHeight = 140
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 93
    Width = 382
    Height = 47
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 114
    DesignSize = (
      382
      47)
    object Button1: TButton
      Left = 157
      Top = 5
      Width = 106
      Height = 39
      Anchors = [akRight, akBottom]
      Caption = 'Salvar'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
    object Button2: TButton
      Left = 269
      Top = 5
      Width = 106
      Height = 39
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
    end
  end
  object Pg: TPageControl
    Left = 0
    Top = 0
    Width = 382
    Height = 93
    ActivePage = TabOutros
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 95
    object TabCampo: TTabSheet
      Caption = 'TabCampo'
      TabVisible = False
      ExplicitHeight = 110
      object Label1: TLabel
        Left = 13
        Top = 14
        Width = 37
        Height = 13
        Caption = 'Campo:'
      end
      object edtCampo: TEdit
        Left = 56
        Top = 11
        Width = 121
        Height = 21
        TabOrder = 0
      end
    end
    object TabOutros: TTabSheet
      Caption = 'TabOutros'
      ImageIndex = 1
      TabVisible = False
      ExplicitHeight = 85
      object lblDesc: TLabel
        Left = 13
        Top = 14
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Abstra'#231#227'o:'
      end
      object Label2: TLabel
        Left = 43
        Top = 41
        Width = 23
        Height = 13
        Alignment = taRightJustify
        Caption = 'DDL:'
      end
      object edtCampo1: TEdit
        Left = 72
        Top = 11
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object edtConvercao: TEdit
        Left = 72
        Top = 38
        Width = 299
        Height = 21
        TabOrder = 1
      end
    end
  end
end
