unit relatorio;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes,Graphics, ExtCtrls, mer, Printers, uAux;

  type
  TImager = class(TComponent)
  private
    FImagem, FTmpImage: TImage;
    Fgrade: TPaintBox;
    FQtdPgVer: integer;
    FQtdPgHor, MaxW, MaxH, FTotalToPrn: integer;
    FTodaAreaDoModelo: Boolean;
    Modelo: TModelo;
    FPaginasPrn: TConjunto;
    FAtualPage: integer;
    procedure SetImagem(const Value: TImage);
    procedure Setgrade(const Value: TPaintBox);
    procedure SetQtdPgHor(const Value: integer);
    procedure SetQtdPgVer(const Value: integer);
    procedure SetTodaAreaDoModelo(const Value: Boolean);
    function GetPagina(index: integer): TBitmap;
    procedure SetPaginasPrn(const Value: TConjunto);
    procedure SetAtualPage(const Value: integer);
    procedure SetTotalToPrn(const Value: integer);
  public
    Property PaginasPrn: TConjunto read FPaginasPrn write SetPaginasPrn;
    Property Imagem: TImage read FImagem write SetImagem;
    Property grade: TPaintBox read Fgrade write Setgrade;
    Procedure make(M: TModelo);
    Procedure OnGPaint(Sender: Tobject);
    Property QtdPgHor: integer read FQtdPgHor write SetQtdPgHor;
    Property QtdPgVer: integer read FQtdPgVer write SetQtdPgVer;
    Property TodaAreaDoModelo: Boolean read FTodaAreaDoModelo write SetTodaAreaDoModelo;
    Procedure SetValores(QtdH, QtdV: integer);
    Procedure Remake;
    Function PaginaCount: integer;
    Property Pagina[index: integer]: TBitmap read GetPagina;
    Function SaveTOJpeg(Arq: String; Bmp: TBitmap = nil): boolean;
    //controlador de impressão
    Function BeforeFirstValidPage: boolean; //posicionador
    Function NextValidPage: TBitmap; //navegador
    Function PrirorValidPage: TBitmap; //navegador
    Property AtualPage: integer read FAtualPage write SetAtualPage; //número da página atual
    Property TotalToPrn: integer read FTotalToPrn write SetTotalToPrn;  //total de página a imprimir
    Function HasNext: boolean; //tem próximo ou ant..
    Function HasPriror: boolean; //''
    Function RealPage: TBitmap; //página imprimível
    Constructor Create(Aowner: TComponent);override;
    Procedure ZeraImgTmp;
  end;


implementation

uses uDM, math, jpeg, Types, Controls;

{ TImager }

function TImager.GetPagina(index: integer): TBitmap;
  var rec, recOri: TRect;
  w,i: integer;
  p: TPoint;
begin
  Result := nil;
  if not Assigned(FImagem) or (index >= PaginaCount) then exit;

  P.X := Modelo.Width;
  P.Y := Modelo.Height;
  with rec do
  begin
    Left := 0;
    Top := 0;
    Right := (P.X) div (QtdPgHor + IfThen(QtdPgHor = 0, 1, 0)); //ifthen impede uma divisão por zero;
    Bottom := (P.Y) div (QtdPgVer + IfThen(QtdPgHor = 0, 1, 0));
    w := 1;
    recOri := Rect(0, 0, Right, Bottom);
    for i := 1 to index do
    begin
      Left := Left + Right;
      inc(w);
      if w > QtdPgHor then
      begin
        w := 1;
        Top := Top + Bottom;
        Left := 0;
      end;
    end;
  end;
  rec.Right := rec.Left + rec.Right;
  rec.Bottom := rec.Top + rec.Bottom;
  try
    if (QtdPgHor = 1) and (QtdPgVer = 1) then
    begin
      Result := Imagem.Picture.Bitmap;
    end
    else begin
      FTmpImage.Picture.Bitmap.Width := recOri.Right;
      FTmpImage.Picture.Bitmap.Height := recOri.Bottom;
      with FTmpImage.Canvas do
      begin
        CopyMode := cmSrcCopy;
        CopyRect(recOri, Imagem.Canvas, Rec);
      end;
      Result := FTmpImage.Picture.Bitmap;
    end;
  except
    Result := nil;
    ZeraImgTmp;
  end;
end;

procedure TImager.make(M: TModelo);
  var P: TPoint;
begin
  Modelo := M;
  ZeraImgTmp;
  if not Assigned(Imagem) then exit;
  P := M.CalculeArea;

  MaxW := P.X;
  MaxH := P.Y;
  if not TodaAreaDoModelo then
  begin
    P.Y := P.Y + 5;
    P.X := P.X + 5;
  end
  else
  begin
    P.X := M.Width;
    P.Y := M.Height;
  end;
  if P.X > M.Width then P.X := M.Width;
  if P.Y > M.Height then P.Y := M.Height;

  Imagem.Picture.Bitmap.Height := P.Y;
  Imagem.Picture.Bitmap.Width := P.X;

  Imagem.Picture.Bitmap.Canvas.Lock;
  M.PaintTo(Imagem.Canvas.Handle, 0, 0);
  Imagem.Picture.Bitmap.Canvas.Unlock;
  grade.Invalidate;
end;

procedure TImager.OnGPaint(Sender: Tobject);
  var w, h, i, j, L, C, tl: integer;
     e1, e2: real;
begin
  PaginasPrn := [];
  if ((QtdPgHor = 0) and (QtdPgVer = 0)) then Exit;
  with grade.Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Color := grade.Color;
    Pen.Style := psDot;
    w := (Imagem.Width) div QtdPgHor;
    h := (Imagem.Height) div QtdPgVer;
    e1 := (Modelo.Width / Imagem.Width);
    e2 := (Modelo.Height / Imagem.Height);
    Brush.Color := clYellow + 20;
    Brush.Style := bsSolid;
    Pen.Style := psClear;
    Tl := 0;
    for j := 0 to QtdPgVer -1 do
    begin
      L := H * J;
      for i := 0 to QtdPgHor -1 do
      begin
        C := w * i;
        inc(tl);
        if (Ceil(C * e1) >= MaxW) or (Ceil(L * e2) >= MaxH) then
        begin
          Rectangle(Rect(c, l, w + c, H + l));
        end else PaginasPrn := PaginasPrn + [tl];
      end;
    end;
  end;
end;

function TImager.PaginaCount: integer;
begin
  Result := QtdPgHor * QtdPgVer;
end;

procedure TImager.Remake;
begin
  if Assigned(Modelo) then make(Modelo);
end;

procedure TImager.Setgrade(const Value: TPaintBox);
begin
  Fgrade := Value;
  if Assigned(Fgrade) then Fgrade.OnPaint := OnGPaint;
end;

procedure TImager.SetImagem(const Value: TImage);
begin
  FImagem := Value;
end;

procedure TImager.SetQtdPgHor(const Value: integer);
begin
  FQtdPgHor := Value;
end;

procedure TImager.SetQtdPgVer(const Value: integer);
begin
  FQtdPgVer := Value;
end;

procedure TImager.SetTodaAreaDoModelo(const Value: Boolean);
begin
  if Value = FTodaAreaDoModelo then exit;
  FTodaAreaDoModelo := Value;
  ReMake;
end;

procedure TImager.SetValores(QtdH, QtdV: integer);
begin
  if not Assigned(grade) then exit;
  QtdPgHor := QtdH;
  QtdPgVer := QtdV;
  grade.Invalidate;
end;

function TImager.SaveTOJpeg(Arq: String; Bmp: TBitmap = nil): boolean;
  var bkp: boolean;
begin
  Result := false;
  with TJPegImage.Create do
  begin
    try
      bkp := TodaAreaDoModelo;
      TodaAreaDoModelo := false;
      if not Assigned(Bmp) then Assign(Imagem.Picture.Bitmap) else
      Assign(Bmp);
      TodaAreaDoModelo := bkp;
      CompressionQuality := 100;
      SaveToFile(Arq);
      Result := true;
    finally
      Free;
    end;
  end;
end;

procedure TImager.SetPaginasPrn(const Value: TConjunto);
begin
  FPaginasPrn := Value;
end;

function TImager.BeforeFirstValidPage: boolean;
  var i: integer;
begin
  TotalToPrn := 0;
  for i := 1 to 30 do
  begin
    if (i in PaginasPrn) then
      inc(FTotalToPrn);
  end;
  AtualPage := 0;
  Result := TotalToPrn > 0;
end;

function TImager.NextValidPage: TBitmap;
begin
  Result := nil;
  if HasNext then
  begin
    inc(FAtualPage);
    Result := RealPage;
  end;
end;

procedure TImager.SetAtualPage(const Value: integer);
begin
  FAtualPage := Value;
end;

function TImager.HasNext: boolean;
begin
  Result := TotalToPrn > AtualPage;
end;

function TImager.HasPriror: boolean;
begin
  Result := AtualPage > 1;
end;

procedure TImager.SetTotalToPrn(const Value: integer);
begin
  FTotalToPrn := Value;
end;

function TImager.RealPage: TBitmap;
  var i, j: integer;
begin
  Result := nil;
  j := 0;
  for i := 1 to 30 do
  begin
    if i in PaginasPrn then inc(j);
    if j = AtualPage then
    begin
      Result := Pagina[i -1];
      break;
    end;
  end;
end;

function TImager.PrirorValidPage: TBitmap;
begin
  Result := nil;
  if HasPriror then
  begin
    dec(FAtualPage);
    Result := RealPage;
  end;
end;

constructor TImager.Create(Aowner: TComponent);
begin
  inherited;
  FTmpImage := TImage.Create(Self);
end;

procedure TImager.ZeraImgTmp;
begin
  FTmpImage.Picture.Bitmap.Width := 0;
  FTmpImage.Picture.Bitmap.Height := 0;
end;

end.
