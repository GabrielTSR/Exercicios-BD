object brFmFModal: TbrFmFModal
  Left = 382
  Top = 260
  Caption = 'Inser'#231#227'o e Edi'#231#227'o de atributo oculto'
  ClientHeight = 195
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 356
    Height = 195
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Atributo'
      TabVisible = False
      object Bevel1: TBevel
        Left = 1
        Top = 63
        Width = 280
        Height = 52
        Shape = bsFrame
      end
      object Label1: TLabel
        Left = 2
        Top = 12
        Width = 31
        Height = 13
        Caption = 'Nome:'
      end
      object Label2: TLabel
        Left = 7
        Top = 92
        Width = 67
        Height = 13
        Caption = 'Cardinalidade:'
      end
      object Label3: TLabel
        Left = 1
        Top = 127
        Width = 24
        Height = 13
        Caption = 'Tipo:'
      end
      object composto: TLabel
        Left = 240
        Top = 32
        Width = 50
        Height = 13
        Caption = 'Composto:'
      end
      object Label4: TLabel
        Left = 90
        Top = 92
        Width = 20
        Height = 13
        Caption = 'Min:'
      end
      object Label5: TLabel
        Left = 177
        Top = 92
        Width = 23
        Height = 13
        Caption = 'Max:'
      end
      object nome: TEdit
        Left = 40
        Top = 8
        Width = 281
        Height = 21
        Color = clSilver
        TabOrder = 0
      end
      object multivalorado: TCheckBox
        Left = 6
        Top = 67
        Width = 97
        Height = 17
        Caption = 'Multivalorado'
        TabOrder = 1
        OnClick = multivaloradoClick
      end
      object Identificador: TCheckBox
        Left = 39
        Top = 31
        Width = 97
        Height = 17
        Caption = 'Identificador'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 2
      end
      object MinCard: TComboBox
        Left = 113
        Top = 88
        Width = 46
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemIndex = 1
        TabOrder = 3
        Text = '1'
        Items.Strings = (
          '0'
          '1')
      end
      object Tipo: TComboBox
        Left = 33
        Top = 122
        Width = 121
        Height = 21
        TabOrder = 4
        Items.Strings = (
          'Texto(1)'
          'N'#250'mero(1)'
          'Caracter'
          'Booleano'
          'Moeda')
      end
      object Panel1: TPanel
        Left = 0
        Top = 157
        Width = 348
        Height = 28
        Align = alBottom
        BevelOuter = bvLowered
        Color = clSilver
        TabOrder = 5
        object Button1: TButton
          Left = 190
          Top = 3
          Width = 75
          Height = 22
          Cancel = True
          Caption = 'Cancelar'
          ModalResult = 2
          TabOrder = 0
        end
        object Button2: TButton
          Left = 270
          Top = 3
          Width = 75
          Height = 22
          Caption = 'Pronto'
          Default = True
          ModalResult = 1
          TabOrder = 1
          OnClick = Button2Click
        end
        object Pai: TComboBox
          Left = 4
          Top = 4
          Width = 175
          Height = 21
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 2
          Text = 'Atributo oculto'
          Items.Strings = (
            'Composi'#231#227'o do atributo selecionado'
            'Atributo oculto')
        end
      end
      object MaxCard: TComboBox
        Left = 201
        Top = 88
        Width = 54
        Height = 21
        Style = csDropDownList
        Enabled = False
        TabOrder = 6
      end
    end
  end
end
