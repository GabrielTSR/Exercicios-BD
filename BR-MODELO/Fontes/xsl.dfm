object brFmVisuXSLT: TbrFmVisuXSLT
  Left = 285
  Top = 152
  BorderStyle = bsDialog
  Caption = 'XSLT - Visualiza'#231#227'o de modelos l'#243'gicos'
  ClientHeight = 327
  ClientWidth = 588
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 23
    Width = 588
    Height = 304
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Gerar Visualiza'#231#227'o'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 580
        Height = 83
        Align = alTop
        Caption = 'Selecionar arquivo para visualiza'#231#227'o'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        object SpeedButton1: TSpeedButton
          Left = 439
          Top = 24
          Width = 23
          Height = 22
          Caption = '...'
          OnClick = SpeedButton1Click
        end
        object gera: TSpeedButton
          Left = 8
          Top = 51
          Width = 276
          Height = 22
          Caption = 'Incluir o XSL carregado no arquivo selecioando'
          OnClick = geraClick
        end
        object SpeedButton2: TSpeedButton
          Left = 396
          Top = 51
          Width = 66
          Height = 22
          Caption = 'Visualizar'
          Enabled = False
          OnClick = SpeedButton2Click
        end
        object arq: TEdit
          Left = 8
          Top = 24
          Width = 425
          Height = 21
          TabOrder = 0
          OnChange = arqChange
        end
      end
      object ver: TMemo
        Left = 0
        Top = 83
        Width = 580
        Height = 193
        Align = alClient
        Color = clSilver
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        Visible = False
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'XSL Carregado'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 299
      object xslEdt: TMemo
        Left = 0
        Top = 29
        Width = 580
        Height = 247
        Align = alClient
        Lines.Strings = (
          '<?xml version="1.0" encoding="ISO-8859-1"?>'
          '<!--N'#195'O PREPARADO PARA CONVERS'#195'O DE ESQUEMA CONCEITUAL-->'
          
            '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/' +
            'XSL/Transform">'
          '<xsl:strip-space elements="Tabela Campo"/>'
          '<xsl:template match="/">'
          '<html>'
          '<head>'
          '<title>Modelo convertido XSL</title>'
          '</head>'
          '<body>'
          
            '<P ALIGN="center" style="font-family: Verdana, Arial, Helvetica,' +
            ' sans-serif;font-size: 14px;font-weight: bold;">'
          'ESQUEMA L'#211'GICO'
          '<xsl:if test="MER/Informacoes/Tipo/@Valor = '#39'CONCEITUAL'#39'">'
          '<BR/><BR/>'
          
            '<xsl:text>N'#195'O PREPARADO PARA CONVERS'#195'O DE ESQUEMA CONCEITUAL</xs' +
            'l:text>'
          '</xsl:if> '
          '</P>'
          
            '<table width="80%" align="center" border="0" cellpadding="0" cel' +
            'lspacing="2" style="font-family: Verdana, Arial, Helvetica, sans' +
            '-serif;font-size: 12px;font-weight: bold;">'
          '<xsl:for-each select="MER/Tabelas/Tabela">'
          '<tr>'
          '<td>'
          '<xsl:value-of select="@nome"/>'
          '<xsl:text> (</xsl:text>'
          
            '<xsl:for-each select="./Campos/Campo[ApenasSeparador/@Valor = 0]' +
            '">'
          '<span style="font-weight:normal;">'
          '<xsl:if test="./IsKey/@Valor = -1">'
          '<xsl:attribute name="style">'
          
            '<xsl:text>font-weight:normal;text-decoration:underline</xsl:text' +
            '>'
          '</xsl:attribute>'
          '</xsl:if> '
          '<xsl:if test="./IsFKey/@Valor = -1">'
          '<xsl:attribute name="style">'
          '<xsl:text>font-weight:normal;text-decoration:overline</xsl:text>'
          '</xsl:attribute>'
          '</xsl:if> '
          '<xsl:value-of select="@nome"/>'
          '</span>'
          '<xsl:if test="position()!=last()">'
          '<xsl:text>, </xsl:text>'
          '</xsl:if>'
          '</xsl:for-each>'
          '<xsl:text>)</xsl:text>'
          '</td>'
          '</tr>'
          '</xsl:for-each>'
          '</table>'
          '</body>'
          '</html>'
          '</xsl:template>'
          '</xsl:stylesheet>')
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object ToolBar1: TToolBar
        Left = 0
        Top = 0
        Width = 580
        Height = 29
        ButtonHeight = 21
        ButtonWidth = 89
        Caption = 'ToolBar1'
        EdgeBorders = [ebTop, ebBottom]
        ShowCaptions = True
        TabOrder = 1
        object salvar: TToolButton
          Left = 0
          Top = 0
          Caption = 'Salvar altera'#231#245'es'
          ImageIndex = 1
          OnClick = salvarClick
        end
        object btnDefault: TToolButton
          Left = 89
          Top = 0
          Caption = 'Carregar default'
          ImageIndex = 2
          OnClick = btnDefaultClick
        end
      end
    end
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 588
    Height = 23
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 40
    Caption = 'ToolBar2'
    Flat = False
    ShowCaptions = True
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = 'Fechar'
      ImageIndex = 0
      OnClick = ToolButton1Click
    end
  end
end
