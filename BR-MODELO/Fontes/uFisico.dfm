object brFmFisico: TbrFmFisico
  Left = 0
  Top = 0
  Caption = 'Implementa'#231#227'o (Modelo F'#237'sico)'
  ClientHeight = 361
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 342
    Width = 616
    Height = 19
    Panels = <>
  end
  object panBase: TScrollBox
    Left = 0
    Top = 0
    Width = 616
    Height = 295
    Align = alClient
    TabOrder = 1
    ExplicitTop = 23
    ExplicitHeight = 292
  end
  object Panel1: TPanel
    Left = 0
    Top = 295
    Width = 616
    Height = 47
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      616
      47)
    object btnCancelar: TButton
      Left = 506
      Top = 3
      Width = 106
      Height = 39
      Anchors = [akRight, akBottom]
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
    object btnConverter: TButton
      Left = 368
      Top = 3
      Width = 132
      Height = 39
      Anchors = [akRight, akBottom]
      Caption = 'Gerar Modelo F'#237'sico'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnConverterClick
    end
    object btnEditar: TButton
      Left = 5
      Top = 3
      Width = 156
      Height = 39
      Anchors = [akRight, akBottom]
      Caption = 'Editar Tipo Selecionado'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnEditarClick
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
      end>
    Images = brDM.img
    Left = 552
    Top = 56
    StyleName = 'XP Style'
    object fisi_converter: TAction
      Category = 'Convers'#227'o'
      Caption = 'Converter'
      ImageIndex = 47
      OnExecute = fisi_converterExecute
    end
    object fisi_fechar: TAction
      Category = 'Convers'#227'o'
      Caption = 'Fechar'
      ImageIndex = 37
      OnExecute = fisi_fecharExecute
    end
    object acEditar: TAction
      Category = 'Convers'#227'o'
      Caption = 'Editar'
    end
  end
end
