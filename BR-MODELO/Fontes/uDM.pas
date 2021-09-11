unit uDM;

interface

uses
  SysUtils, Classes, MER, ImgList, Controls,
  Dialogs, Graphics, printers, xmldom, XMLIntf, msxmldom, XMLDoc;

type
  TbrDM = class(TDataModule)
    img: TImageList;
    attImg: TImageList;
    PrinterSetup: TPrinterSetupDialog;
    PrintDialog: TPrintDialog;
    SaveDialog: TSaveDialog;
    XMLDoc: TXMLDocument;
    SavaModelo: TSaveDialog;
    OpenXML: TOpenDialog;
    SavaDic: TSaveDialog;
    OpenModelo: TOpenDialog;
    SaveXML: TSaveDialog;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    Visual: TVisual;
  end;

var
  brDM: TbrDM;
  
implementation

uses uApp, impressao, relatorio;

{$R *.dfm}

procedure TbrDM.DataModuleCreate(Sender: TObject);
begin
  brFmPrincipal.Inicio;
  SaveDialog.InitialDir := ExtractFilePath(ParamStr(0));
  OpenXML.InitialDir := SaveDialog.InitialDir;
  OpenModelo.InitialDir := SaveDialog.InitialDir;
  SavaDic.InitialDir := SaveDialog.InitialDir;
end;

end.
