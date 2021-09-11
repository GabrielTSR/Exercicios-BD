object Configuracao: TConfiguracao
  Left = 350
  Top = 210
  BorderStyle = bsDialog
  Caption = 'Op'#231#245'es gerais'
  ClientHeight = 197
  ClientWidth = 366
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
    Width = 366
    Height = 197
    Align = alClient
    BevelWidth = 2
    DragKind = dkDock
    TabOrder = 0
    object Panel4: TPanel
      Left = 2
      Top = 2
      Width = 362
      Height = 24
      Align = alTop
      BevelOuter = bvLowered
      BorderWidth = 1
      TabOrder = 0
    end
    object OpcoesGerais: TPageControl
      Left = 2
      Top = 26
      Width = 362
      Height = 169
      ActivePage = TabCFG
      Align = alClient
      TabOrder = 1
      TabPosition = tpBottom
      OnChange = OpcoesGeraisChange
      object TabCFG: TTabSheet
        Caption = 'Configura'#231#245'es'
        ImageIndex = 2
        TabVisible = False
        object CheckBox1: TCheckBox
          Left = 2
          Top = 7
          Width = 335
          Height = 17
          Action = Form1.mod_exibirHint
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object Button1: TButton
    Left = 287
    Top = 167
    Width = 71
    Height = 22
    Caption = 'Fechar'
    TabOrder = 1
    OnClick = Button1Click
  end
end
