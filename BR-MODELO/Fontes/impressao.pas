unit impressao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ToolWin, ActnMan, ActnCtrls, ActnMenus,
  ActnList, XPStyleActnCtrls, Buttons, StdCtrls, mer, relatorio, printers,
  System.Actions;

type
  TbrFmImpress = class(TForm)
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    Horizontal: TComboBox;
    Label1: TLabel;
    Vertical: TComboBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    ActionManager1: TActionManager;
    Visualizar: TAction;
    ConfImpress: TAction;
    Imprimir: TAction;
    Fechar: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    Image1: TImage;
    PaintBox1: TPaintBox;
    ExM: TAction;
    ExBMP: TAction;
    procedure ToolButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FecharExecute(Sender: TObject);
    procedure AreaSelect(Sender: TObject);
    procedure VisualizarExecute(Sender: TObject);
    procedure ConfImpressExecute(Sender: TObject);
    procedure ImprimirExecute(Sender: TObject);
    procedure ExMExecute(Sender: TObject);
    procedure ExBMPExecute(Sender: TObject);
  private
    FMaker: TImager;
    procedure SetMaker(const Value: TImager);
  public
    property Maker: TImager read FMaker write SetMaker;
    procedure DirectPrint(b: TBitmap);
  end;

var
  brFmImpress: TbrFmImpress;

implementation
uses math, Types, uDM, preview;
{$R *.dfm}

{ Timpr}
procedure TbrFmImpress.FormCreate(Sender: TObject);
begin
  Maker := TImager.Create(self);
  Maker.Imagem := Image1;
  Maker.grade := PaintBox1;
  Maker.QtdPgHor := 5;
  Maker.QtdPgVer := 3;
  PrintScale := poPrintToFit;
  Maker.TodaAreaDoModelo := true;
end;

procedure TbrFmImpress.FecharExecute(Sender: TObject);
begin
  close;
end;

procedure TbrFmImpress.AreaSelect(Sender: TObject);
begin
  Maker.SetValores(Horizontal.ItemIndex + 1, Vertical.ItemIndex + 1);
end;

procedure TbrFmImpress.VisualizarExecute(Sender: TObject);
begin
  if Maker.BeforeFirstValidPage then
  begin
    brFmForm_view := TbrFmForm_view.Create(nil);
    brFmForm_view.Maker := Maker;
    brFmForm_view.ProxClick(nil);
    brFmForm_view.Posicione;
    brFmForm_view.ShowModal;
    brFmForm_view.Free;
  end
  else Application.MessageBox('Não há dados para imprimir!', 'Aviso: Impressão', mb_Ok or MB_ICONWARNING);
end;

procedure TbrFmImpress.ConfImpressExecute(Sender: TObject);
begin
  brDM.PrinterSetup.Execute;
end;

procedure TbrFmImpress.ImprimirExecute(Sender: TObject);
  var Bmp : TBitmap;
begin
  if Printer.PrinterIndex = -1 then
  begin
    Application.MessageBox('Não há nenhuma impressora pronta para imprimir!', 'Aviso: Impressão', mb_Ok or MB_ICONWARNING);
    exit;
  end;
  with brFmImpress.Maker do
    if BeforeFirstValidPage then
  begin
    Screen.Cursor := crHourGlass;
    while HasNext do
    begin
      Bmp := NextValidPage;
      if Assigned(Bmp) then
      begin
        brFmImpress.DirectPrint(Bmp);
        Maker.ZeraImgTmp;
      end;
    end;
    Screen.Cursor := crDefault;
    Application.MessageBox('Relatório impresso!', 'Aviso: Impressão', mb_Ok or MB_ICONINFORMATION);
  end
  else Application.MessageBox('Não há dados para imprimir!', 'Aviso: Impressão', mb_Ok or MB_ICONWARNING);
end;

procedure TbrFmImpress.SetMaker(const Value: TImager);
begin
  FMaker := Value;
end;

procedure TbrFmImpress.ToolButton1Click(Sender: TObject);
begin
  close;
end;

procedure TbrFmImpress.DirectPrint(b: TBitmap);
  var
  Info: PBitmapInfo;
  InfoSize: DWORD;
  Image: Pointer;
  ImageSize: DWORD;
  Bits: HBITMAP;
  DIBWidth, DIBHeight: Longint;
  PrintWidth, PrintHeight: Longint;
begin
  Printer.BeginDoc;
  try
    Canvas.Lock;
    try
      with Printer, Canvas do
      begin
        Bits := b.Handle;
        GetDIBSizes(Bits, InfoSize, ImageSize);
        Info := AllocMem(InfoSize);
        try
          Image := AllocMem(ImageSize);
          try
            GetDIB(Bits, 0, Info^, Image^);
            with Info^.bmiHeader do
            begin
              DIBWidth := biWidth;
              DIBHeight := biHeight;
            end;
            case PrintScale of
              poProportional:
                begin
                  PrintWidth := MulDiv(DIBWidth, GetDeviceCaps(Handle,
                    LOGPIXELSX), PixelsPerInch);
                  PrintHeight := MulDiv(DIBHeight, GetDeviceCaps(Handle,
                    LOGPIXELSY), PixelsPerInch);
                end;
              poPrintToFit:
                begin
                  PrintWidth := MulDiv(DIBWidth, PageHeight, DIBHeight);
                  if PrintWidth < PageWidth then
                    PrintHeight := PageHeight
                  else
                  begin
                    PrintWidth := PageWidth;
                    PrintHeight := MulDiv(DIBHeight, PageWidth, DIBWidth);
                  end;
                end;
            else
              PrintWidth := DIBWidth;
              PrintHeight := DIBHeight;
            end;
            StretchDIBits(Canvas.Handle, 0, 0, PrintWidth, PrintHeight, 0, 0,
              DIBWidth, DIBHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
          finally
            FreeMem(Image, ImageSize);
          end;
        finally
          FreeMem(Info, InfoSize);
        end;
      end;
    finally
      Canvas.Unlock;
    end;
  finally
    Printer.EndDoc;
  end;
end;

procedure TbrFmImpress.ExMExecute(Sender: TObject);
begin
  brDM.SaveDialog.Filter := 'Imagem JPG/Jpeg|*.jpg';
  brDM.SaveDialog.DefaultExt := 'jpg';
  brDM.SaveDialog.FileName := '';
  with brDM.SaveDialog do
    if Execute then
  try
    Screen.Cursor := crHourGlass;
    Maker.SaveTOJpeg(FileName);
  except
    on exception do MessageDlg('Erro ao gravar, gerar ou converter o arquivo para jpg!' +
                               'Arquivo: ' + FileName, mtError, [mbOk], 0);
  end;
  Screen.Cursor := crDefault;
end;

procedure TbrFmImpress.ExBMPExecute(Sender: TObject);
  var bkp: boolean;
begin
  bkp := Maker.TodaAreaDoModelo;
  Maker.TodaAreaDoModelo := false;
  brDM.SaveDialog.Filter := 'Imagem BMP|*.bmp';
  brDM.SaveDialog.DefaultExt := 'bmp';
  brDM.SaveDialog.FileName := '';
  with brDM.SaveDialog do
    if Execute then
  try
    Maker.Imagem.Picture.Bitmap.SaveToFile(FileName);
  except
    on exception do MessageDlg('Erro ao gravar aquivo bitmap!' + #13 +
                               'Arquivo: ' + FileName, mtError, [mbOk], 0);
  end;
  Maker.TodaAreaDoModelo := bkp;
  Screen.Cursor := crDefault;
end;

end.
