unit preview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ToolWin, Printers, StdCtrls, relatorio, ImgList;

type
  TbrFmForm_view = class(TForm)
    ToolBar1: TToolBar;
    ctl: TPanel;
    Img: TImage;
    Fechar: TToolButton;
    Prox: TToolButton;
    Ant: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    Zoom: TComboBox;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Imgs: TImageList;
    img2: TImageList;
    procedure FecharClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ProxClick(Sender: TObject);
    procedure AntClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ZoomSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    Maker: TImager;
    Procedure Posicione;
    Procedure GetImage;
    { Public declarations }
  end;

var
  brFmForm_view: TbrFmForm_view;
  Ref: Real;

implementation
uses Math, impressao;
{$R *.dfm}

{ TForm4 }

procedure TbrFmForm_view.Posicione;
  var tmp: integer;
begin
  tmp := Ceil(Printer.PageWidth / 10.4 * Ref);
  ctl.SetBounds(
    IfThen((Width -15) > tmp, (Width - tmp -15) div 2, 15),
    15,
    TMP,
    Ceil(Printer.PageHeight / 10.4 * Ref)
  );
end;

procedure TbrFmForm_view.FecharClick(Sender: TObject);
begin
  close;
end;

procedure TbrFmForm_view.FormResize(Sender: TObject);
begin
  Posicione;
  Invalidate;
end;

procedure TbrFmForm_view.FormPaint(Sender: TObject);
begin
//borda da página
//  with Canvas do begin
//    Pen.Color := clBlack;
//    Pen.Width := 1;
//    MoveTo(ctl.Left - 1, ctl.Top -1);
//    LineTo(ctl.Left + ctl.Width + 2, ctl.Top -1);
//    MoveTo(ctl.Left - 1, ctl.Top -1);
//    LineTo(ctl.Left - 1, ctl.Top + ctl.Height + 1);
//    LineTo(ctl.Left + ctl.Width + 2,ctl.Top + ctl.Height + 1);
//    Pen.Width := 2;
//    MoveTo(ctl.Left + 3, ctl.Top + ctl.Height + 2);
//    LineTo(ctl.Left + ctl.Width + 2, ctl.Top + ctl.Height + 2);
//    LineTo(ctl.Left + ctl.Width + 2, ctl.Top);
//  end;
end;

procedure TbrFmForm_view.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then close;
end;

procedure TbrFmForm_view.ProxClick(Sender: TObject);
  var Bmp: TBitmap;
begin
  Bmp := Maker.NextValidPage;
  if (Bmp <> nil) and (Sender <> nil) then
  begin
    GetImage;
  end;
  Prox.Enabled := Maker.HasNext;
  Ant.Enabled := Maker.HasPriror;
  Edit1.Text := IntToStr(Maker.AtualPage) + ' de ' + IntToStr(Maker.TotalToPrn);
end;

procedure TbrFmForm_view.AntClick(Sender: TObject);
  var Bmp: TBitmap;
begin
  Bmp := Maker.PrirorValidPage;
  if Bmp <> nil then
  begin
    GetImage;
  end;
  Ant.Enabled := Maker.HasPriror;
  Prox.Enabled := Maker.HasNext;
  Edit1.Text := IntToStr(Maker.AtualPage) + ' de ' + IntToStr(Maker.TotalToPrn);
end;

procedure TbrFmForm_view.ToolButton1Click(Sender: TObject);
  var Bmp: TBitmap;
begin
  if Printer.PrinterIndex = -1 then
  begin
    Application.MessageBox('Não há nenhuma impressora pronta para imprimir!', 'Aviso: Impressão', mb_Ok or MB_ICONWARNING);
    exit;
  end;
  Bmp := Maker.RealPage;
  if (Bmp <> nil) then
  begin
    brFmImpress.DirectPrint(Bmp);
    Maker.ZeraImgTmp;
    Application.MessageBox('Página impressa!', 'Aviso: Impressão', mb_Ok or MB_ICONINFORMATION);
  end;
end;

procedure TbrFmForm_view.ZoomSelect(Sender: TObject);
  const zooms : array [0..12] of real = (0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5);
begin
  Ref := Zooms[Zoom.ItemIndex];
  Posicione;
  GetImage;
  Invalidate;
  Img.Repaint;
end;

procedure TbrFmForm_view.FormCreate(Sender: TObject);
begin
  Ref := 1;
end;

procedure TbrFmForm_view.GetImage;
var
  bmp: TBitmap;
  Info: PBitmapInfo;
  InfoSize: DWORD;
  Image: Pointer;
  ImageSize: DWORD;
  Bits: HBITMAP;
  DIBWidth, DIBHeight: Longint;
  PrintWidth, PrintHeight: Longint;
begin
  img.Picture.Bitmap.Width := 0;
  img.Picture.Bitmap.Height := 0;
  img.Picture.Bitmap.Width := img.Width;
  img.Picture.Bitmap.Height := img.Height;
  Bmp := Maker.RealPage;
  if Bmp <> nil then
  begin
    img.Canvas.Lock;
    try
      with img.Canvas do
      begin
        Bits := bmp.Handle;
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
            PrintWidth := MulDiv(DIBWidth, Img.Height, DIBHeight);
            if PrintWidth < img.Width then
               PrintHeight := img.Height
            else begin
              PrintWidth := img.Width;
              PrintHeight := MulDiv(DIBHeight, img.Width, DIBWidth);
            end;
            StretchDIBits(img.Picture.Bitmap.Canvas.Handle, 0, 0, PrintWidth, PrintHeight, 0, 0,
              DIBWidth, DIBHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
          finally
            FreeMem(Image, ImageSize);
          end;
        finally
          FreeMem(Info, InfoSize);
        end;
      end;
    finally
      img.Canvas.Unlock;
    end;
    img.Refresh;
    Maker.ZeraImgTmp;
  end;
end;

procedure TbrFmForm_view.FormShow(Sender: TObject);
begin
  GetImage;
  Invalidate;
end;

end.
