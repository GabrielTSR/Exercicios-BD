unit uFisico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, XPStyleActnCtrls, ActnMan, ExtCtrls, ToolWin,
  ActnCtrls, ActnMenus, StdCtrls, FisicoMng, MER, uAux, Contnrs, System.Actions;//, BiLista;

type
  TbrFmFisico = class(TForm)
    ActionManager1: TActionManager;
    StatusBar1: TStatusBar;
    panBase: TScrollBox;
    fisi_fechar: TAction;
    fisi_converter: TAction;
    acEditar: TAction;
    Panel1: TPanel;
    btnCancelar: TButton;
    btnConverter: TButton;
    btnEditar: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure fisi_fecharExecute(Sender: TObject);
    procedure fisi_converterExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConverterClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    { Private declarations }
  public
    Mng: TMngFisico;
    Seq: Integer;
    TabelasJa: TStringList;
    Erro: boolean;
    LstNoFK: TList;
    procedure ItemDblClick(Sender: TObject);
    function GetTableCampos(Tab: TTabela): string;
    function DefaultCuringas(txt: string): string;
    Procedure IncSeq(txt: string);
    Function GetConvert(grp: string; cmp: string): string;
    Function GeraConstraintNome(nTabela, cmpEnv: string; tp: string): string;
    Function getFKforTabLst(Lst: TList; Tab: TTabela): string;
    Function GeraConstraints(Tab: TTabela; isPK: boolean): string;
    Function ProcesseImpossivelFK: string;
  end;

var
  brFmFisico: TbrFmFisico;

implementation

uses uDM, uApp, ShowFisico, uEdtTemplFisico, uTemplate;

{$R *.dfm}

procedure TbrFmFisico.btnConverterClick(Sender: TObject);
begin
  // Inicio TCC II
  // executa a conversão para o modelo físico
  fisi_converterExecute(Sender);
  // Fim TCC II
end;

procedure TbrFmFisico.btnEditarClick(Sender: TObject);
begin
  // Inicio TCC II
  // se não houver nada selecionado, nada deve ser feito
  if (not Assigned(Mng.Selecionado)) then begin
    Application.MessageBox('Um tipo de dados deve ser selecionado na lista !!!',
                           'Aviso', MB_OK + MB_ICONWARNING);
    Exit;
  end;  // if (not Assigned(Mng.Selecionado)) then

  // abre a janela de edição de tipos
  ItemDblClick(Mng.Selecionado);
  // Fim TCC II
end;

function TbrFmFisico.DefaultCuringas(txt: string): string;
begin
  Result := StringReplace(txt, '*$separador', Mng.MngT.ddlSeparador, [rfReplaceAll]);
  Result := StringReplace(Result, '*$\n', #$D#$A, [rfReplaceAll]);
  Inc(Seq);
  Result := StringReplace(Result, '*$num_seq', IntToStr(Seq), [rfReplaceAll]);
end;

procedure TbrFmFisico.fisi_converterExecute(Sender: TObject);
  var i: Integer;
      T: TTabela;
      tmp: string;
      Lst: TList;
      Gerado: TStringList;
  function findTableByOrdem(ordem: integer): TTabela;
    var i: Integer;
        res: TTabela;
  begin
    Result := nil;
    for i := 0 to brDM.Visual.Modelo.ComponentCount -1 do
      if brDM.Visual.Modelo.Components[i] is TTabela then
    begin
      res := TTabela(brDM.Visual.Modelo.Components[i]);
      if res.cOrdem = ordem then
      begin
        Result := res;
        Break;
      end;
    end;
  end;
  Function LNormatize(txt: string): string;
    var lltmp: string;
  begin
    Result := DefaultCuringas(txt);
    Result := StringReplace(Result, '*$nome_tabela', T.Nome, [rfReplaceAll]);
    if T.Complemento <> '' then
    begin
      lltmp := DefaultCuringas(GetConvert(fisicoCOMPLEMENTO_TABELAS, T.Complemento));
      lltmp := StringReplace(lltmp, '*$nome_tabela', T.Nome, [rfReplaceAll]);

      Result := StringReplace(Result, '*$compl_tabela', lltmp, [rfReplaceAll]);
    end else Result := StringReplace(Result, '*$compl_tabela', '', [rfReplaceAll]);
  end;
  Function LastVirg(txt: string): string;
    var i: Integer;
  begin
    for i := Length(txt) downto 1 do
      if txt[i] = ',' then
    begin
       Delete(txt, i, 1);
       break;
    end;
    Result := txt;
  end;
begin
  // Inicio TCC II
  // esconde a janela de conversão de tipos
  Hide;
  // Fim TCC II

  Erro := false;
  Gerado := TStringList.Create;
  Seq := 0;
  TabelasJa.Clear;
  LstNoFK.Clear;
  Gerado.Add('-- Geração de Modelo físico');
  Gerado.Add('-- Sql ANSI 2003 - brModelo.');
  Gerado.Add('');
  if brDM.Visual.Modelo.Autor <> '' then
    Gerado.Add('/* Por: ' + brDM.Visual.Modelo.Autor + '*/');
  if brDM.Visual.Modelo.Observacao <> '' then
    Gerado.Add('/* Observação: ' + brDM.Visual.Modelo.Observacao + '*/');
  Gerado.Add('');
  Gerado.Add('');
  Lst := TList.Create;
  //ordem de conversão.
  for I := 1 to brDM.Visual.Modelo.QtdTabela do
  begin
    T := findTableByOrdem(i);
    if T <> nil then Lst.Add(T);
  end;
  for i := 0 to brDM.Visual.Modelo.ComponentCount -1 do
    if brDM.Visual.Modelo.Components[i] is TTabela then
  begin
    T := TTabela(brDM.Visual.Modelo.Components[i]);
    if T.cOrdem = 0 then Lst.Add(T);
  end;

  for i := 0 to Lst.Count -1 do
  begin
    T := TTabela(Lst[i]);
    if TabelasJa.IndexOf(T.Nome) > -1 then
    begin
      brDM.Visual.Modelo.GeraLog('Erro: tabela "' + T.Nome + '": Nome duplicado (este erro compromete a integridade referencial)!', True, True);
      Gerado.Add('-- Erro: Nome de tabela duplicado (este erro compromete a integridade referencial)!');
      Erro := true;
    end;
    tmp := LNormatize(Mng.MngT.ddlCTab_A) + LNormatize(Mng.MngT.ddlCTab_B);
    tmp := tmp + #$D#$A + GetTableCampos(T) + #$D#$A;
    if T.Complemento <> '' then
    begin
      tmp := tmp + LNormatize(Mng.MngT.ddlCTab_Compl) + ',';
    end;
    tmp := tmp + LNormatize(Mng.MngT.ddlCTab_C);
    Gerado.Add(LastVirg(tmp));
    TabelasJa.Add(T.Nome);
  end;
  if (not Mng.MngT.ddlPk_inTab) then
  begin
    for i := 0 to Lst.Count -1 do
    begin
      T := TTabela(Lst[i]);
      tmp := GeraConstraints(T, true);
      if tmp <> '' then Gerado.Add(tmp);
    end;
  end;
  if (not Mng.MngT.ddlFk_inTab) or (not Mng.MngT.ddlPk_inTab) then
  begin
    for i := 0 to Lst.Count -1 do
    begin
      T := TTabela(Lst[i]);
      tmp := GeraConstraints(T, false);
      if tmp <> '' then Gerado.Add(tmp);
    end;
  end;
  tmp := ProcesseImpossivelFK;
  if tmp <> '' then Gerado.Add(tmp);
  Lst.Free;
  TabelasJa.Clear;
  TabelasJa.Add(Mng.MngT.ddlCTab_A);
  TabelasJa.Add(Mng.MngT.ddlCTab_B);
  TabelasJa.Add(Mng.MngT.ddlCTab_C);
  TabelasJa.Add(Mng.MngT.ddlCTab_Compl);
  TabelasJa.Add(Mng.MngT.ddlCCamp);
  TabelasJa.Add(Mng.MngT.ddlCConst_Nome);
  TabelasJa.Add(Mng.MngT.ddlSeparador);

  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$nome_tabela', '', [rfReplaceAll]);
  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$\n', '', [rfReplaceAll]);
  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$compl_tabela', '', [rfReplaceAll]);
  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$separador', '', [rfReplaceAll]);
  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$nome_campo', '', [rfReplaceAll]);
  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$tipo_campo', '', [rfReplaceAll]);
  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$compl_campo', '', [rfReplaceAll]);
  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$envol_campo', '', [rfReplaceAll]);
  TabelasJa.Text := StringReplace(TabelasJa.Text, '*$num_seq', '', [rfReplaceAll]);

  for I := 0 to Mng.MngT.ComponentCount - 1 do
  begin
    if Mng.MngT[i].Grupo = fisicoTIPOS then TabelasJa.Add(Mng.MngT[i].Campo2);
  end;

  brFmShowFisico := TbrFmShowFisico.Create(Self);
  brFmShowFisico.Erro := Erro;
  brFmShowFisico.ddl.Lines.Clear;
  brFmShowFisico.ddl.Lines.AddStrings(Gerado);
  Gerado.Free;
  brFmShowFisico.RW := TabelasJa;
  brFmShowFisico.ShowModal;
  brFmShowFisico.Free;

  // Inicio TCC II
  // fecha a janela de conversao de tipos
  Close;
  // Fim TCC II
end;

procedure TbrFmFisico.fisi_fecharExecute(Sender: TObject);
begin
  close;
end;

procedure TbrFmFisico.FormCreate(Sender: TObject);
begin
  Mng := TMngFisico.Create(panBase);
  Mng.MngT := brDM.Visual.Modelo.Template;
  Mng.ItemDblClick := ItemDblClick;
  Mng.Inicialize;
  TabelasJa := TStringList.Create;
  LstNoFK := TList.Create;
end;

procedure TbrFmFisico.FormDestroy(Sender: TObject);
begin
  TabelasJa.Free;
  LstNoFK.Free;
end;

function TbrFmFisico.GeraConstraintNome(nTabela, cmpEnv: string; tp: string): string;
begin
  if Mng.MngT.ddlConst_Nomear then
  begin
    cmpEnv := StringReplace(cmpEnv, ',', '_', [rfReplaceAll]);
    cmpEnv := StringReplace(cmpEnv, ' ', '_', [rfReplaceAll]);
    Result := DefaultCuringas(Mng.MngT.ddlCConst_Nome);
    Result := StringReplace(Result, '*$nome_tabela', nTabela, [rfReplaceAll]);
    Result := StringReplace(Result, '*$envol_campo', cmpEnv, [rfReplaceAll]);
    Result := ' CONSTRAINT ' + Result + tp + ' ';
  end else Result := ' ';
end;

function TbrFmFisico.GeraConstraints(Tab: TTabela; isPK: boolean): string;
  var i: Integer;
      C: TCampo;
      res, sep: string;
      fkCampos: TList;
begin
  Result := '';
  sep := DefaultCuringas(Mng.MngT.ddlSeparador);
  if isPK then
  begin
    for I := 0 to Tab.Campos.Count - 1 do
    begin
      C := TCampo(Tab.Campos[i]);
      if not (C.IsKey) then Continue;
      Result := 'ALTER TABLE ' + Tab.Nome + ' ADD' + GeraConstraintNome(Tab.Nome, Tab.Chaves, '_pk') + 'PRIMARY KEY(' + Tab.Chaves + ')' + sep;
      break;
    end;
    Exit;
  end;
  fkCampos := TList.Create;
  for I := 0 to Tab.Campos.Count - 1 do
  begin
    if TCampo(Tab.Campos[i]).IsFKey then
    fkCampos.Add(Tab.Campos[i]);
  end;
  while fkCampos.Count > 0 do
  begin
    C := TCampo(fkCampos[0]);
    if C.TabelaDeOrigem = nil then
    begin
      brDM.Visual.Modelo.GeraLog('Erro: tabela "' + Tab.Nome + '" campo "' + C.Nome + '": ' +
                                 'chave estrangeira não aponta para tabela de origem!', True, True);
      fkCampos.Delete(0);
      Erro := true;
      Continue;
    end;
    res := C.TabelaDeOrigem.Nome + ' (' + C.TabelaDeOrigem.Chaves + ')';
    if Result = '' then
       Result := 'ALTER TABLE ' + Tab.Nome + ' ADD' + GeraConstraintNome(Tab.Nome, Tab.Chaves, '_fk') + 'FOREIGN KEY(' +
              getFKforTabLst(fkCampos, Tab) + ') REFERENCES ' +
              res
    else
      Result := Result + #$D#$A + 'ALTER TABLE ' + Tab.Nome + ' ADD' + GeraConstraintNome(Tab.Nome, Tab.Chaves, '_fk') +
              'FOREIGN KEY(' + getFKforTabLst(fkCampos, Tab) + ') REFERENCES ' +
              res;
    if C.ddlOnUpdate <> tpNO_ACTION then
        Result := Result + ' ON UPDATE ' + DDLActionToStr(C.ddlOnUpdate);
    if C.ddlOnDelete <> tpNO_ACTION then
        Result := Result + ' ON DELETE ' + DDLActionToStr(C.ddlOnDelete);
    Result := Result + sep;
  end;
  fkCampos.Free;
end;

function TbrFmFisico.GetConvert(grp, cmp: string): string;
  var item: TMngTemplateItem;
begin
  item := Mng.MngT.FindCampo(cmp, grp);
  if item = nil then Result := cmp else
  begin
    Result := item.Campo2;
    if Result = '' then Result := cmp;
  end;
  if Result = '' then Result := '/*erro: ??*/';
end;

function TbrFmFisico.getFKforTabLst(Lst: TList; Tab: TTabela): string;
  var C, Cmp: TCampo;
      lstLocal, lstOrigem: TList;
      i, j: Integer;
      aOrigem: TTabela;
      strOrdenada: TStringList;
begin
  Cmp := TCampo(Lst[0]);
  if Cmp.TabelaDeOrigem.GetTLChaves = 1 then
  begin
    Lst.Delete(0);
    Result := Cmp.Nome;
  end else
  begin
    lstLocal := TList.Create;
    lstOrigem := TList.Create;
    aOrigem := Cmp.TabelaDeOrigem;
    strOrdenada := TStringList.Create;
    I := 0;
    While I < Lst.Count do
    begin
      C := TCampo(Lst[i]);
      if C.TabelaDeOrigem = aOrigem then
      begin
        lstLocal.Add(C);
        strOrdenada.Add('');
        Lst.Delete(i);
      end else inc(i);
    end;
    for I := 0 to Cmp.TabelaDeOrigem.Campos.Count - 1 do
    begin
      if TCampo(Cmp.TabelaDeOrigem.Campos[i]).IsKey then lstOrigem.Add(Cmp.TabelaDeOrigem.Campos[i]);
    end;
    if lstLocal.Count <> lstOrigem.Count then
    begin
      brDM.Visual.Modelo.GeraLog('Erro: tabela "' + Tab.Nome +
                                 '": Quantidade de campos "chave estrangeira" deve ser igual a quantidade de chave primária da tabela de origem!', True, True);
      Result := '/*erro: ??*/';
      Erro := true;

      lstLocal.Free;
      lstOrigem.Free;
      strOrdenada.Free;
      exit;
    end;
    I := 0;
    While I < lstLocal.Count do
    begin
      C := TCampo(lstLocal[i]);
      J := lstOrigem.IndexOf(C.CampoDeOrigem);
      if (C.CampoDeOrigem = nil) or (j = -1) then
      begin
        brDM.Visual.Modelo.GeraLog('Erro: tabela "' + Tab.Nome +
                                   '" campo "' + C.Nome + '" inconsistente.' +
                                   ' Não há um campo chave válido correspondente na tabela de origem!', True, True);
        Result := '/*erro: ??*/';
        Erro := true;
        lstLocal.Free;
        lstOrigem.Free;
        strOrdenada.Free;
        exit;
      end;
      strOrdenada[j] := C.Nome;
      lstLocal.Delete(i);
      lstOrigem.Delete(J);
    end;
    Result := StringReplace(strOrdenada.Text, #$D#$A, ',', [rfReplaceAll]);
    lstLocal.free;
    lstOrigem.free;
    strOrdenada.Free;
  end;
end;

function TbrFmFisico.GetTableCampos(Tab: TTabela): string;
  var i: Integer;
      C: TCampo;
      res, resKey, tmp: string;
      jaKey: boolean;
      fkCampos: TComponentList;
      JaCampo: TStringList;

      // Inicio TCC II
      sTipo: string;
      // Fim TCC II
begin
  res := '';
  resKey := '';
  Result := '';
  jaKey := false;
  JaCampo := TStringList.Create;
  for I := 0 to Tab.Campos.Count - 1 do
  begin
    C := TCampo(Tab.Campos[i]);
    if JaCampo.IndexOf(C.Nome) > -1 then
    begin
      res := '-- Erro: nome do campo duplicado nesta tabela!';
      if Result = '' then Result := res else Result := Result + #$D#$A + res;
    end else JaCampo.Add(C.Nome);
    res := DefaultCuringas(Mng.MngT.ddlCCamp);
    res := StringReplace(res, '*$nome_campo', C.Nome, [rfReplaceAll]);

    // Inicio TCC II
    // obtém o tipo correto
    sTipo := C.Tipo;
    if (pos('( )', C.Tipo) <> 0) then
      sTipo := copy(C.Tipo, 1, pos('(', C.Tipo)) + C.Precisao + ')';

    res := StringReplace(res, '*$tipo_campo', GetConvert(fisicoTIPOS, sTipo), [rfReplaceAll]);
    // Fim TCC II
    if C.Complemento <> '' then
    begin
      tmp := DefaultCuringas(GetConvert(fisicoCOMPLEMENTO_CAMPOS, C.Complemento));
      tmp := StringReplace(tmp, '*$nome_campo', C.Nome, [rfReplaceAll]);
      tmp := StringReplace(tmp, '*$nome_tabela', Tab.Nome, [rfReplaceAll]);

      res := StringReplace(res, '*$compl_campo', tmp, [rfReplaceAll])
    end else
      res := StringReplace(res, ' *$compl_campo', '', [rfReplaceAll]);
//////
    if Mng.MngT.ddlPk_inTab and C.IsKey then
    begin
      if (not Mng.MngT.ddlConst_Nomear) and (Tab.GetTLChaves = 1) then
      begin
        res := res + ' PRIMARY KEY';
        jaKey := true;
      end;
    end;
    if Result = '' then Result := res + ',' else Result := Result + #$D#$A + res + ',';
  end;
  //Pk
  if (not jaKey) and Mng.MngT.ddlPk_inTab then
  begin
    for I := 0 to Tab.Campos.Count - 1 do
    begin
      C := TCampo(Tab.Campos[i]);
      if not (C.IsKey) then Continue;
      Result := Result + #$D#$A + TrimLeft(GeraConstraintNome(Tab.Nome, Tab.Chaves, '_pk')) + 'PRIMARY KEY(' + Tab.Chaves + '),';
      break;
    end;
  end;
  if Mng.MngT.ddlFk_inTab and Mng.MngT.ddlPK_inTab then
  begin
    fkCampos := TComponentList.Create(false);
    for I := 0 to Tab.Campos.Count - 1 do
    begin
      if TCampo(Tab.Campos[i]).IsFKey then
      fkCampos.Add(Tab.Campos[i]);
    end;
    while fkCampos.Count > 0 do
    begin
      C := TCampo(fkCampos[0]);
      if C.TabelaDeOrigem = nil then
      begin
        brDM.Visual.Modelo.GeraLog('Erro: tabela "' + Tab.Nome + '" campo "' + C.Nome + '": ' +
                                   'chave estrangeira não aponta para tabela de origem!', True, True);
        Result := Result + '/*falha: chave estrangeira*/';
        Erro := true;
        fkCampos.Delete(0);
        Continue;
      end;
      if TabelasJa.IndexOf(C.TabelaDeOrigem.Nome) = -1 then
      begin
        LstNoFK.Add(C);
        fkCampos.Delete(0);
        Continue;
      end;
      res := C.TabelaDeOrigem.Nome + ' (' + C.TabelaDeOrigem.Chaves + ')';
      Result := Result + #$D#$A + TrimLeft(GeraConstraintNome(Tab.Nome, Tab.Chaves, '_fk')) + 'FOREIGN KEY(' +
                getFKforTabLst(fkCampos, Tab) + ') REFERENCES ' +
                res;
      if C.ddlOnUpdate <> tpNO_ACTION then
          Result := Result + ' ON UPDATE ' + DDLActionToStr(C.ddlOnUpdate);
      if C.ddlOnDelete <> tpNO_ACTION then
          Result := Result + ' ON DELETE ' + DDLActionToStr(C.ddlOnDelete);
      Result := Result + ',';
    end;
    fkCampos.Free;
  end;
  JaCampo.Free;
end;

procedure TbrFmFisico.IncSeq(txt: string);
begin
  if pos('*$seq_num', txt) > 0 then Inc(Seq);
end;

procedure TbrFmFisico.ItemDblClick(Sender: TObject);
  var item: TFisicoItem;
      res: string;
begin
  item := TFisicoItem(Sender);
  if item.Tipo <> tpTexto then Exit;

  BrFmEdtTemplFisico := TBrFmEdtTemplFisico.Create(self);
  BrFmEdtTemplFisico.Caption := BrFmEdtTemplFisico.Caption + ' [' + item.MngItem.Grupo + ']';
  BrFmEdtTemplFisico.edtCampo1.Enabled := false;
  BrFmEdtTemplFisico.Pg.ActivePage := BrFmEdtTemplFisico.TabOutros;
  BrFmEdtTemplFisico.edtCampo1.Text := item.MngItem.Campo1;
  BrFmEdtTemplFisico.edtConvercao.Text := item.MngItem.Campo2;
  if BrFmEdtTemplFisico.ShowModal = mrOk then
  begin
    if (BrFmEdtTemplFisico.edtCampo1.Text = '') then
    begin
      BrFmEdtTemplFisico.Free;
      Exit;
    end;
    res := BrFmEdtTemplFisico.edtConvercao.Text;
    if item.MngItem.Estatus = EITJustModelo then
      if item.MngItem.Campo2 <> res then
        item.MngItem.Estatus := EITNormal;
    item.MngItem.Campo2 := res;
    brDM.Visual.Modelo.Mudou := true;
    item.Refresh;
  end;
  BrFmEdtTemplFisico.Free;
end;

Function TbrFmFisico.ProcesseImpossivelFK: string;
  var c: TCampo;
      tab: TTabela;
      res: string;
begin
  Result := '';
  while LstNoFK.Count > 0 do
  begin
    C := TCampo(LstNoFK[0]);
    tab := C.Dono;
    if C.TabelaDeOrigem = nil then
    begin
      brDM.Visual.Modelo.GeraLog('Erro: tabela "' + Tab.Nome + '" campo "' + C.Nome + '": ' +
                                 'chave estrangeira não aponta para tabela de origem!', True, True);
      Result := Result + '/*falha: chave estrangeira*/';
      Erro := true;
      LstNoFK.Delete(0);
      Continue;
    end;
    res := C.TabelaDeOrigem.Nome + ' (' + C.TabelaDeOrigem.Chaves + ')';
    if Result = '' then
       Result := 'ALTER TABLE ' + Tab.Nome + ' ADD' + GeraConstraintNome(Tab.Nome, Tab.Chaves, '_fk') + 'FOREIGN KEY(' +
              getFKforTabLst(LstNoFK, Tab) + ') REFERENCES ' +
              res
    else
      Result := Result + #$D#$A + 'ALTER TABLE ' + Tab.Nome + ' ADD' + GeraConstraintNome(Tab.Nome, Tab.Chaves, '_fk') +
              'FOREIGN KEY(' + getFKforTabLst(LstNoFK, Tab) + ') REFERENCES ' +
              res;
    if C.ddlOnUpdate <> tpNO_ACTION then
        Result := Result + ' ON UPDATE ' + DDLActionToStr(C.ddlOnUpdate);
    if C.ddlOnDelete <> tpNO_ACTION then
        Result := Result + ' ON DELETE ' + DDLActionToStr(C.ddlOnDelete);
    Result := Result + DefaultCuringas(Mng.MngT.ddlSeparador);
  end;
end;

end.
