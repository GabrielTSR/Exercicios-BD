unit ajuda;

//  Padrão: Hard coded.
//  By: Cândido
//  Propósito: evitar a criação de arquivos na máquina do usuário.
//  Futuro: evitar!

interface
  uses Windows, Messages, SysUtils, Variants, Classes, Controls, Dialogs, shellApi;

var AjudaLocal: TStringList;

const

Ajudas: Array[1..2] of String = (
  '<html>' + #13 +
  '<head>' + #13 +
  '<title>Ajuda: Especialização</title>' + #13 +
  '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + #13 +
  '</head>' + #13 +
  '<body bgcolor="#FFFFFF" text="#000000">' + #13 +
  '<font face="Arial, Helvetica, sans-serif" size="2"><b>Vantagens da implanta&ccedil;&atilde;o ' + #13 +
  'com tabela &uacute;nica.</b></font> ' + #13 +
  '<p><font face="Arial, Helvetica, sans-serif" size="2">Todos os dados referentes ' + #13 +
  '  a uma ocorr&ecirc;ncia de entidade gen&eacute;rica, bem como os dados referentes ' + #13 +
  '  a ocorr&ecirc;ncias de sua especializa&ccedil;&atilde;o, est&atilde;o em uma ' + #13 +
  '  &uacute;nica linha. N&atilde;o h&aacute; necessidade de realizar jun&ccedil;&otilde;es ' + #13 +
  '  quando a aplica&ccedil;&atilde;o deseja obter dados referentes a uma ocorr&ecirc;ncia ' + #13 +
  '  de entidade gen&eacute;rica juntamente com uma ocorr&ecirc;ncia de entidade ' + #13 +
  '  especializada.</font></p>' + #13 +
  '<p><font face="Arial, Helvetica, sans-serif" size="2">A chave prim&aacute;ria ' + #13 +
  '  &eacute; armazenada uma &uacute;nica vez, ao contr&aacute;rio da alternativa ' + #13 +
  '  com m&uacute;ltiplas tabelas, na qual a chave prim&aacute;ria aparece tanto ' + #13 +
  '  na tabela referente &agrave; entidade gen&eacute;rica quanto na tabela referente ' + #13 +
  '  &agrave; entidade especializada<br>[Heuser 2003]</font></p>' + #13 +
  '<p><b><font face="Arial, Helvetica, sans-serif" size="2">Vantagens da implanta&ccedil;&atilde;o ' + #13 +
  '  com uma tabela por entidade especializada</font></b></p>' + #13 +
  '<p><font face="Arial, Helvetica, sans-serif" size="2">As colunas opcionais que ' + #13 +
  '  aparecem s&atilde;o apenas aquelas referentes a atributos que podem ser vazios ' + #13 +
  '  do ponto de vista da aplica&ccedil;&atilde;o. Na solu&ccedil;&atilde;o alternativa, ' + #13 +
  '  todas colunas referentes a atributos e relacionamentos das entidades especializadas ' + #13 +
  '  devem ser definidas como opcionais.</font></p>' + #13 +
  '<p><font face="Arial, Helvetica, sans-serif" size="2">O controle de colunas opcionais ' + #13 +
  '  passa a ser feito pela aplica&ccedil;&atilde;o com base no valor da coluna TIPO ' + #13 +
  '  e n&atilde;o pelo SGBD como ocorre na solu&ccedil;&atilde;o alternativa.<br>[Heuser 2003]<br>' + #13 +
  '  </font><font face="Arial, Helvetica, sans-serif" size="2"> </font> </p>' + #13 +
  '<p><b><font face="Arial, Helvetica, sans-serif" size="2">Desaconselho o uso de tabelas apenas para as especializações' + #13 +
  ' em caso de mais de uma entidade especializada</font></b></p>' + #13 +
  '<p><font face="Arial, Helvetica, sans-serif" size="2">Ao definir tabelas apenas para as especializações ' + #13 +
  '  cria-se redundância de dados já que grande parte das informações ' + #13 +
  '  aparecem em todas as tabelas da especialização e, por conta disso, não há como o SGBD controlar a integridade dos dados, o que deverá ser feito "à mão".<br>' +
  #13 + 'No caso de especialização parcial, está forma não poderá ser usada.<br>[Cândido 2005]' +
  #13 + '</font></p>' + #13 +
  '</body>' + #13 +
  '</html>'
  ,

  '<html>' + #13 +
  '<head>' + #13 +
  '<title>Ajuda: Relacionamento</title>' + #13 +
  '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + #13 +
  '<style type="text/css">' + #13 +
  '<!--' + #13 +
  '.txt {  font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold}' + #13 +
  '-->' + #13 +
  '</style>' + #13 +
  '</head>' + #13 +
  '' + #13 +
  '<body bgcolor="#FFFFFF" text="#000000" class="txt">' + #13 +
  '<table width="500" border="1" cellspacing="0" cellpadding="0" bordercolor="#333333" class="txt">' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td rowspan="2">TIPO DE RELACIONAMENTO</td>' + #13 +
  '    <td colspan="3">REGRA DE IMPLEMENTA&Ccedil;&Atilde;O</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td>Tabela pr&oacute;pria</td>' + #13 +
  '    <td>Adi&ccedil;&atilde;o coluna</td>' + #13 +
  '    <td>Fus&atilde;o tabelas</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td colspan="4">RELACIONAMENTOS 1:1</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(0,1)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(0,1)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(+/-)</td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(0,1)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(1,1)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '    <td>(+/-)</td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(1,1)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(1,1)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td colspan="4">RELACIONAMENTOS 1:N</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(0,1)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(0,N)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(+/-)</td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(0,1)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(1,N)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(+/-)</td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(1,1)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(0,N)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(1,1)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(1,N)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td colspan="4">RELACIONAMENTOS N:N</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(0,N)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(0,N)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(0,N)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(1,N)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr align="center"> ' + #13 +
  '    <td> ' + #13 +
  '      <table width="80%" border="0" cellspacing="0" cellpadding="0" class="txt">' + #13 +
  '        <tr> ' + #13 +
  '          <td width="42%"> ' + #13 +
  '            <div align="right">(1,N)</div>' + #13 +
  '          </td>' + #13 +
  '          <td width="16%"> ' + #13 +
  '            <hr>' + #13 +
  '          </td>' + #13 +
  '          <td width="42%">(1,N)</td>' + #13 +
  '        </tr>' + #13 +
  '      </table>' + #13 +
  '    </td>' + #13 +
  '    <td>(+)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '    <td>(-)</td>' + #13 +
  '  </tr>' + #13 +
  '</table>' + #13 +
  '<br>' + #13 +
  '<table width="500" border="1" cellspacing="0" cellpadding="0" bordercolor="#333333" class="txt">' + #13 +
  '  <tr> ' + #13 +
  '    <td width="50%" align="center">(+) Melhor Alternativa </td>' + #13 +
  '    <td width="50%" align="center">(+/-) Pode ser usado</td>' + #13 +
  '  </tr>' + #13 +
  '  <tr> ' + #13 +
  '    <td colspan="2">' + #13 +
  '      <div align="center">(-) N&atilde;o usar</div>' + #13 +
  '    </td>' + #13 +
  '  </tr>' + #13 +
  '  <tr> ' + #13 +
  '    <td colspan="2">' + #13 +
  '      <div align="center">Fonte: Livro Projeto de Banco de Dados, 4.ª Edição<br>Dr. Carlos A. Heuser<div>' + #13 +
  '    </td>' + #13 +
  '  </tr>' + #13 +
  '</table>' + #13 +
  '</body>' + #13 +
  '</html>'
  );

Procedure LoadAjuda(topico: Integer);
Procedure AutoHelp(Strs: TStringList);

implementation

uses uAux;

Procedure LoadAjuda(topico: Integer);
  var Ajuda: TStringList;
        tmp: String;
        PC: array [0..511] of Char;
begin
  Ajuda := TStringList.Create;
  tmp := ExtractFilePath(ParamStr(0)) + '\';
  if Pos('\\', tmp) > 0 then tmp := ExtractFilePath(ParamStr(0));

  try
    Ajuda.Text := Ajudas[topico];
    tmp := tmp + 'ajuda' + intToStr(topico) + '.htm';
    Ajuda.SaveToFile(tmp);
    ShellExecute(0, '', StrPCopy(PC, tmp), '', '', SW_NORMAL);
    if AjudaLocal.IndexOf(tmp) < 0 then AjudaLocal.Add(tmp);
  except
    MessageDlg('Erro ao gerar o arquivo de ajuda!', mtError, [mbOk], 0);
  end;
end;

Procedure AutoHelp(Strs: TStringList);
begin
  with Strs do
  begin
		add('##');
		add('## Carlos H. Cândido');
		add('## Ajuda rápida do sistema.');
		add('## ');
		add('[NOME MODELO]');
		add('[NOME]');
		add('Descrição/identificação do objeto.');
    add('[TEXTO TEXTO]');
    add('[PAPEL]');
		add('Descrição do papel da cardinalidade (descrição/observação).');
		add('[ALINHAMENTOLT]');
		add('Reposiciona o controle quanto a posição no modelo (esquerda ou direita).');
		add('[ALINHAMENTOWH]');
		add('Reposiciona o controle quanto a altura ou largura.');
		add('[OBS]');
		add('Algo importante a ser anotado para posterior observação.');
		add('[ID]');
		add('Identificador único do objeto no modelo.');
		add('[Auto Relacionado]');
		add('A entidade está auto relacionada');
		add('[Especializada]');
		add('A entidade está especializada');
		add('[Ent. Ass. Relação: Nome]');
		add('Nome do relacionamento contido na entidade associativa');
		add('[Ent. Ass. Relacão: Dicionario]');
		add('Dicionário de dados do relacionamento contido na entidade associativa');
		add('[Ent. Ass. Relação: Observacao]');
		add('Algo importante a ser anotado para posterior observação sobre o relacionamento contido na entidade associativa');
		add('[Card. Fixar posição]');
		add('Fixar posição: Se fixada, a cardinalidade não se moverá ao mover-se a entidade ou relacionamento ao qual ela esteja vinculada.');
		add('[Card. Posição da Linha]');
		add('Alinhamento da fixação da cardinalidade');
		add('[Card. Tamanho aut.]');
		add('Controle do tamanho do desenho da cardinalidade');
		add('[Entidade fraca]');
		add('Tipo de entidade');
		add('[Cardinalidade]');
		add('[Atrib. tamanho aut.]');
		add('Controle do tamanho do desenho do atributo');
		add('[Atrib. Desvio]');
		add('Desvia o encaixe da ligação do atributo ao relacionamento (desvio em pontos)');
		add('[Posicionamento]');
		add('Alinhamento da fixação do atributo');
		add('[Identificador]');
		add('O atributo pode ser identificador, Opcional, composto e/ou multivalorado');
		add('[Opcional]');
		add('O atributo pode ser identificador, Opcional, composto e/ou multivalorado');
		add('[Composto]');
		add('O atributo pode ser identificador, Opcional, composto e/ou multivalorado');
		add('[Multivalorado]');
		add('O atributo pode ser identificador, Opcional, composto e/ou multivalorado');
		add('[Card. Mínima]');
		add('Cardinalidade mínima do atributo.');
		add('Ex: (1, n), neste caso o "1"');
		add('[Card. Máxima]');
		add('Cardinalidade máxima do atributo.');
		add('Ex: (1, n), neste caso o "n"');
		add('[TipoDoValor]');
		add('Tipo do atributo, podendo ser por exemplo: Texto(n), Número(n), boleano e etc. (ou qualquer outro definido pelo usuário)');
		add('[Exclusiva]');
		add('Especialização exclusiva (onde A é B "ou" C) não exclusiva (A pode ser B e/ou C)');
		add('[Esp. Parcial]');
		add('Especialização parcial');
		add('[Chave Primária]');
		add('[Chave Estrangeira]');
		add('[Tipo]');
		add('Tipo de dado no modelo');
		add('[TabOrigem]');
		add('Integridade referencial: Tabela de origem do campo chave estrangeira.');
		add('[CampoOrigem]');
		add('Integridade referencial: Campo de origem da chave estrangeira.');
		add('[Posição (Índice)]');
		add('Ordenamento do campo dentro a tabela');
		add('[Cor]');
		add('[Qtd. Campos]');
		add('[Texto TamAuto]');
		add('[Texto Cor]');
		add('[Moldura]');
		add('Forma de desenho da moldura do texto.');
		add('[Alin. Texto]');
    add('[RPOSISETA]');
    add('Posiciona uma seta ao lado do relacionamento para enfatizar a melhor direção de leitura do diagrama');
    add('[TBComplemento]');
    add('Mineumônico de um complemento que, no futuro, poderá ser convertido em DDL para a futura tabela.');
    add('[CPComplemento]');
    add('Mineumônico de um complemento que, no futuro, poderá ser convertido em DDL para o futuro campo.');
    add('[TBChaves]');
    add('Chave(s) primária da tabela (nesta ordem).');
    add('[OnUpdate]');
    add('DDL ansi 2003: em caso de update na tabela pai, o que deverá acontecer.');
    add('[OnDelete]');
    add('DDL ansi 2003: em caso de exclusão na tabela pai, o que deverá acontecer.');
    add('[TBcOrdem]');
    add('Ordem de conversão da tabela para o modelo físico.');
    add('[QtdeMultivalorado]');
    add('QtdeMultivalorado.');
  end;
end;

end.
