unit uRegistraExten;

interface

uses Registry, ShlObj, SysUtils, Windows;

procedure RegisterFileType(cMyExt, cMyFileType, cMyDescription,
  ExeName: string; IcoIndex: integer; DoUpdate: boolean = false);

function jaRegistrado(cMyExt: string): boolean;
function brExecute(exe: string): Boolean;

implementation
uses ShellApi;

function brExecute(exe: string): Boolean;
begin
  Result := ShellExecute(0,'open',PChar(exe),nil,nil, SW_SHOWNORMAL)> 31;
end;

function jaRegistrado(cMyExt: string): boolean;
var
  Reg: TRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Result := Reg.OpenKey(cMyExt, false);
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

procedure RegisterFileType(cMyExt, cMyFileType, cMyDescription,
  ExeName: string; IcoIndex: integer; DoUpdate: boolean = false);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    // 1) Atribui a extensão ao tipo de arquivo, criando
    //    a extensão se ela já não existir

    // Abre ou cria a chave HKCR\<cMyExt>
    Reg.OpenKey(cMyExt, True);
    // HKCR\.<cMyExt>\(Default)="<cMyFileType>"
    Reg.WriteString('', cMyFileType);
    Reg.CloseKey;

    // 2) Atribui a descrição do tipo de arquivo, criando
    //    o tipo de arquivo se ele já não existir

    // Abre ou cria a chave HKCR\<cMyFileType>
    Reg.OpenKey(cMyFileType, True);
    // HKCR\<cMyFileType>\(Default)="<cMyDescription>"
    Reg.WriteString('', cMyDescription);
    Reg.CloseKey;    // Now write the default icon for my file type

    // 3) Atribui o índice do ícone ao tipo de arquivo,
    //    criando a chave correspondente se ela já não existir

    // Abre ou cria a chave HKCR\<cMyFileType>\DefaultIcon
    Reg.OpenKey(cMyFileType + '\DefaultIcon', True);
    // HKCR\<cMyFileType>\DefaultIcon\
    // (Default)="<cExeName>,<IcoIndex>"
    Reg.WriteString('', ExeName + ',' + IntToStr(IcoIndex));
    Reg.CloseKey;

    // 4) Escreve o comando para a ação Abrir (Open) no Windows
    //    Explorer, criando a ação se ela já não existir

    // Abre ou cria a chave HKCR\<cMyFileType>\Shell\Open
    Reg.OpenKey(cMyFileType + '\Shell\Open', True);
    // HKCR\<cMyFileType>\Shell\Open\(Default)="&Open"
    Reg.WriteString('', '&Open');
    Reg.CloseKey;

    // 5) Define a aplicação que será usada para executar a ação,
    //    criando a chava correspondente se ela já não existir

    // Abre ou cria a chave HKCR\<cMyFileType>\Shell\Open\Command
    Reg.OpenKey(cMyFileType + '\Shell\Open\Command', True);
    // HKCR\<cMyFileType>\Shell\Open\Command\
    // (Default)=""<cExeName>" "%1""
    // Sua aplicação deve analisar os parâmetros de linha de comando
    // para saber qual o arquivo passado
    Reg.WriteString('', '"' + ExeName + '" "%1"');
    Reg.CloseKey;

    // Finalmente, se você quiser que o Windows Explorer
    // reconheça o tipo de arquivo imediatamente, basta
    // chamar a API SHChangeNotify.
    if DoUpdate then
      SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
  finally
    Reg.Free;
  end;
end;

end.

