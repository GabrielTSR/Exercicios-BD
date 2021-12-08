#Select
/*
	select - especifica as colunas que serão visualizadas
    from - especifica as tabelas que serão utilizadasna consulta
    where - Especifica o critério de filtro
*/

use dbFilmesTurmaB;

#Permite visualizar todas as colunas e todos os registros de uma tabela (*)
select * from tblfilme;

select tblfilme.* from tblfilme;

#Permite visualizar colunas específicas da tabela
select tblFilme.nome, tblFilme.sinopse from tblFilme;

# as - Significa alias (permite criar
#						um apelido para o nome de uma
#						coluna ou de uma tabela)

select filme.nome as nomeFilme, filme.duracao, filme.sinopse from tblfilme as filme;

select  nome, 
		sinopse
        from tblfilme
        where  idFilme = 2;
    
/*
	like - busca a igualdade do valor
    like % no início, busca pelo término da string
    like % no final, busca pelo início da string
    like % % no inicio e no final, busca por qualquer parte da string
*/
    
select  nome, 
	sinopse
	from tblfilme
	where  nome like '%leão%';
    
#OPERAÇÕES DE COMPARAÇÃO
# >
# <
# <=
# >=
#<>   
#like --> Busca pela igualdade do valor
#like %var no inicio ---> Busca pelo o término da string
#like var% no fim --> Busca pelo o inicio da String
#like %var% no inicio e no fim --> busca por qualquer parte de string
    
/*OPERADORES LÓGICOS
	and
	or
	not
*/

select * from tblFilme;

alter table tblFilme
	add column qtde int;
    
    update tblFilme set qtde = 8 where idFilme = 2;
    
    #Selecionar filmes em que "quantidade" está entre 6 e 10
    select * from tblFilme where qtde >= 6 and qtde <= 10;
    
    #Selecionar filmes em que "quantidade" não está entre 6 e 10
    select * from tblFilme where qtde < 6 or qtde > 10;
    select * from tblFilme where not(qtde >= 6 and qtde <= 10);
   
   #Selecionando onde "quantidade" é igual a 2, 5, 8, ou 10
	SELECT * FROM tblfilme where qtde = 2 or
								 qtde = 5 or 
                                 qtde = 8 or 
                                 qtde = 10;
	#Permite buscar o mesmo atributo por vários valores, não precisando escrever o atributo várias vezes
    #OBS (só funciona com o operador lógico OR)
	SELECT * FROM tblFilme where qtde in (2,5,8,10);
    
    SELECT * FROM tblFilme where qtde not in (2,5,8,10);
                                 
    SELECT * FROM tblfilme;
    
    #between - retorna os dados em range (intervalo) de valores
     select * from tblFilme
              where qtde between 6 and 10;
              
	select * from tblFilme
              where qtde not between 6 and 10;
              
	#Ordenação de dados
    #order by asc - ordena de forma crescente
    #desc - ordena de forma decrescente
    select * from tblFilme order by nome asc;
    select * from tblFilme order by nome desc;
    
    select * from tblFilme order by nome asc, duracao desc;
    
/*
	limit --> Limitar a quantidade de respostas que o banco vai trazer a partir do seu script de select
*/

	select * from tblFilme limit 2;

	#Somente 1º registro da tabela
	select * from tblFilme order by idFilme asc limit 1;

	#Somente o último registro da tabela
	select * from tblFilme order by idFilme desc limit 1;

	#count - retorna a quantidade de itens no select
	select count(*) as qtdeFilmes from tblFilme;
    
	select count(nome) as qtdeFilmes, count(dataRelancamento) as qtdeFilmesRelancamento from tblFilme;
    
    select count(*) as qtdeClassificacao from tblFilme where idFilme = 4;
    
    
    #min retorna o menor valor do select
    #max retorna o maior valor do select
    select min(qtde) as qtdeMinima from tblFilme;
    select max(qtde) as qtdeMaxima from tblFilme;
    
    select sum(qtde) as somaQtdeFilmes from tblFilme;
    
    #avg Calcula média e retorna valor decimal. 
    #Round aredonda para um número inteiro
    select round(avg(qtde),1) as mediaQtdeFilmes from tblFilme;
    
    #concat() - permite realizar a concatenação de dados
    select concat('Filme: ', nome) as nomeFilme, nome,
    concat('O filme ', nome, ' tem duração de : ', duracao) as resultado
    from tblFilme;
    
    #concat_ws() - permite realizar a concatenação de dados, utilizando
    #um caracter de seperação entre os dados
    select concat_ws(' | ', nome, duracao, dataLancamento) as resultado from tblFilme;
    
    #locate() - retorna a posição da palavra ou caracter desejado
    select locate('rei', sinopse) as resultado, sinopse from tblFilme;
    
    #reverse - permite inverter o conteudo da coluna
    select reverse(nome) as resultado from tblFilme;
    
    #length ou char_length - retorna a quantidade de caracteres de uma coluna
    select length(nome) as qtde, 
				char_length(nome) as qtde2
					from tblFilme;
                    
#Insert() - Permite inserir um novo conteúdo dentro do texto de uma coluna
#insert(coluna, posição de início do novo conteúdo, qtde de caracteres que serão removidos, novo conteúdo que será inserido)
	select insert(sinopse, 5, 0, ' videolocadora ') as resultado
		from tblFilme;
        
        #Deixando em negrito a primeira ocorrência de "prisão"
        select insert(sinopse, locate('prisão', sinopse), length('prisão'), '<b>prisão</b>') as resultado
        from tblFilme;
        
#substr() --> Permite coletar um pedaço de um conteúdo 
	select substr(sinopse, 1, locate(',', sinopse)) as resultado
		from tblfilme;
        
#Ir até a vírgula, e mostrar um botão de saiba mais
	select concat(substr(sinopse, 1, locate(',', sinopse)), '<a href="pagina.php">saiba mais...</>') as resultado
		from tblfilme;
        
#replace() - permite localizar um conteúdo e substituir por outra coisa
	select replace(sinopse, 'prisão', '<b>prisão</b>') as resultado
        from tblFilme;
        
select * from tblFilme;

alter table tblFilme add column valor float;

update tblFilme set valor = '10.50' where idFilme = 4;

select nome, qtde, valor, round((qtde * valor), 2) as valorTotal 
from tblFilme;

#Retornar 10% de desconto
	select nome, 
    sinopse, 
    concat('R$ ', round(valor, 2)) as ValorOriginal, concat('R$ ', round((valor - (valor * 50)/100), 2)) as valorDesconto
    from tblFilme;
    
    
   #RELACIONAMENTO ENTRE TABELAS NO BD
    #FORMA 01 DE FAZER RELACIONAMENTO
    select tblFilme.nome as nomeFilme, 
			tblFilme.duracao, 
            tblFilme.dataLancamento,
			tblGenero.nome as nomeGenero 
            from tblFilme, tblGenero, tblFilmeGenero
            where tblFilme.idFilme = tblFilmeGenero.idFilme and
            tblGenero.idGenero = tblFilmeGenero.idGenero;
            
            
# FORMA 02 DE FAZER RELACIONAMENTO - (NO FROM)
# ESSA FORMA DE RELACIONAR, CRIA UMA PERFORMANCE (PROCESSAMENTO) MAIS RÁPIDO NA GERAÇÃO DO RESULTADO
# MAIS RÁPIDO NA GERAÇÃO DO RESULTADO

#INNER JOIN - RETORNA DADOS QUE FORAM RELACIONADOS ENTRE A TABELA DA ESQUERDA E QUE CONTÉM RELAÇÃO COM A TABELA DA DIREITA
	SELECT 
    tblFilme.nome AS nomeFilme,
    tblFilme.duracao,
    tblFilme.dataLancamento,
    tblGenero.nome AS nomeGenero
	FROM
    tblFilme
        INNER JOIN
    tblFilmeGenero ON tblFilme.idFilme = tblFilmeGenero.idFilme
        INNER JOIN
    tblGenero ON tblGenero.idGenero = tblFilmeGenero.idGenero;

#LEFT JOIN - RETORNA DADOS QUE FORAM RELACIONADOS ENTRE A TABELA DA ESQUERDA E QUE CONTÉM RELAÇÃO COM A TABELA
# DA DIREITA, PORÉM TAMBÉM RETORNA OS DADOS DA TABELA DA ESQUERDA QUE NÃO FORAM RELACIONADOS COM A TABELA DA DIREITA
select tblFilme.nome as nomeFilme, tblFilme.duracao,
       tblFilme.dataLancamento, tblGenero.nome as nomeGenero
from tblFilme left join tblFilmeGenero
	      on tblFilme.idFilme = tblFilmeGenero.idFilme
       left join tblGenero
		  on tblGenero.idGenero = tblFilmeGenero.idFilme
          order by nomeGenero;


#RIGHT JOIN

  select tblFilme.nome as nomeFilme, tblFilme.duracao,
       tblFilme.dataLancamento, tblGenero.nome as nomeGenero
from tblFilme right join tblFilmeGenero
	      on tblFilme.idFilme = tblFilmeGenero.idFilme
       right join tblGenero
		  on tblGenero.idGenero = tblFilmeGenero.idFilme
          order by nomeGenero;
          


# APLICANDO FULL JOIN NO MY SQL
# O FULL JOIN, PARA REPRESENTAR ESSE RESULTADO É NECESSÁRIO UTILIZAR
# O COMANDO UNION (O COMANDO UNION SERVE PARA UNIR DOIS OU MAIS
# SCRIPTS DE SELECT). CRIAMOS UMA SELECT APENAS COM O LEFT JOIN
# E UNIMOS COM OUTRO SELECT COM RIGHT JOIN

  select tblFilme.nome as nomeFilme, tblFilme.duracao,
       tblFilme.dataLancamento, tblGenero.nome as nomeGenero
from tblFilme right join tblFilmeGenero
	      on tblFilme.idFilme = tblFilmeGenero.idFilme
       right join tblGenero
		  on tblGenero.idGenero = tblFilmeGenero.idFilme
          
          union all
          
          select tblFilme.nome as nomeFilme, tblFilme.duracao,
       tblFilme.dataLancamento, tblGenero.nome as nomeGenero
from tblFilme left join tblFilmeGenero
	      on tblFilme.idFilme = tblFilmeGenero.idFilme
       left join tblGenero
		  on tblGenero.idGenero = tblFilmeGenero.idFilme
          order by nomeGenero;
          
# Selecionar:  ¯\_(ツ)_/¯
# => Nome do filme;
# => Nome original do filme;
# => Classificação;
# => Nome do gênero
# => Nome dos atores
# Critério de busca:
# => Atores nascidos a partir de 1965
# => Todos os dados ordenados de forma crescente

select * from tblator;

SELECT tblFilme.nome as nomeFilme,
		tblFilme.nomeOriginal as nomeOriginalFilme,
        tblClassificacao.nome as nomeClassificacao,
        tblGenero.nome as nomeGenero,
        tblAtor.nome as nomeAtor
        
        from tblClassificacao inner join tblFilme
			on tblClassificacao.idClassificacao = tblFilme.idClassificacao
            
		inner join tblFilmeGenero 
			on tblFilme.idFilme = tblFilmeGenero.idFilme
        
        inner join tblGenero
			on tblGenero.idGenero = tblFilmeGenero.idGenero
            
		inner join tblFilmeAtor
			on tblFilme.idFilme = tblFilmeAtor.idFilme
            
		inner join tblAtor
			on tblAtor.idAtor = tblFilmeAtor.idAtor
		
        #where year(tblAtor.dataNascimento) >= 1965
        order by nomeAtor asc;
        
        /*SELECT com o 
        nome do filme, 
        data de lançamento, 
        sinopse, 
        classificação, 
        gênero, 
        nome dos atores, 
        data nascimento dos atores, 
        nome do diretor, 
        nome do roteirista, 
        nacionalidade do ator
        Ordenado pelo nome do filme crescente,
        nome dos atores decrescente*/
        SELECT * FROM dbfilmesturmab.tblFilmeRoteirista;
        
        SELECT tblFilme.nome as nomeFilme,
		tblFilme.dataLancamento,
		tblFilme.sinopse,
        tblClassificacao.nome as nomeClassificacao,
        tblGenero.nome as nomeGenero,
        tblAtor.nome as nomeAtor,
        tblAtor.dataNascimento,
        tblDiretor.nome as nomeDiretor,
        tblRoteirista.nome as nomeRoteirista,
        tblNacionalidade.nome as nacionalidadeAtor
        
        from tblClassificacao inner join tblFilme
			on tblClassificacao.idClassificacao = tblFilme.idClassificacao
            
		inner join tblFilmeGenero 
			on tblFilme.idFilme = tblFilmeGenero.idFilme
        
        inner join tblGenero
			on tblGenero.idGenero = tblFilmeGenero.idGenero
            
		inner join tblFilmeAtor
			on tblFilme.idFilme = tblFilmeAtor.idFilme
            
		inner join tblAtor
			on tblAtor.idAtor = tblFilmeAtor.idAtor
            
		inner join tblFilmeDiretor
			on tblFilme.idFilme = tblFilmeDiretor.idFilme
            
		inner join tblDiretor
			on tblDiretor.idDiretor = tblFilmeDiretor.idDiretor
            
		inner join tblFilmeRoteirista
			on tblFilme.idFilme = tblFilmeRoteirista.idFilme
            
		inner join tblRoteirista
			on tblRoteirista.idRoteirista = tblFilmeRoteirista.idRoteirista
            
		inner join tblAtorNacionalidade
			on tblAtor.idAtor = tblAtorNacionalidade.idAtor
            
		inner join tblNacionalidade
			on tblNacionalidade.idNacionalidade = tblAtorNacionalidade.idNacionalidade
		
        order by nomeFilme asc, nomeAtor desc;
        
        #CRIANDO UMA VIEW NO BD
        # View - é uma tabela virtual criada com base em um select,
        # que já é pré processada pelo banco de dados, e permite dar uma resposta muito mais ágil
        # do que executar o script manualmente.
        
        create view vwListarFilme as
			SELECT tblFilme.nome as nomeFilme,
		tblFilme.dataLancamento,
		tblFilme.sinopse,
        tblClassificacao.nome as nomeClassificacao,
        tblGenero.nome as nomeGenero,
        tblAtor.nome as nomeAtor,
        tblAtor.dataNascimento,
        tblDiretor.nome as nomeDiretor,
        tblRoteirista.nome as nomeRoteirista,
        tblNacionalidade.nome as nacionalidadeAtor
        
        from tblClassificacao inner join tblFilme
			on tblClassificacao.idClassificacao = tblFilme.idClassificacao
            
		inner join tblFilmeGenero 
			on tblFilme.idFilme = tblFilmeGenero.idFilme
        
        inner join tblGenero
			on tblGenero.idGenero = tblFilmeGenero.idGenero
            
		inner join tblFilmeAtor
			on tblFilme.idFilme = tblFilmeAtor.idFilme
            
		inner join tblAtor
			on tblAtor.idAtor = tblFilmeAtor.idAtor
            
		inner join tblFilmeDiretor
			on tblFilme.idFilme = tblFilmeDiretor.idFilme
            
		inner join tblDiretor
			on tblDiretor.idDiretor = tblFilmeDiretor.idDiretor
            
		inner join tblFilmeRoteirista
			on tblFilme.idFilme = tblFilmeRoteirista.idFilme
            
		inner join tblRoteirista
			on tblRoteirista.idRoteirista = tblFilmeRoteirista.idRoteirista
            
		inner join tblAtorNacionalidade
			on tblAtor.idAtor = tblAtorNacionalidade.idAtor
            
		inner join tblNacionalidade
			on tblNacionalidade.idNacionalidade = tblAtorNacionalidade.idNacionalidade
		
        order by nomeFilme asc, nomeAtor desc;
        
        SELECT * from vwListarFilme;
        
        desc vwListarFilme;
        
        #PERMITE ALTERAR O CONTEÚDO DE UMA VIEW
		alter view vwListarFilme as
			SELECT tblFilme.nome as nomeFilme,
		tblFilme.dataLancamento,
		tblFilme.sinopse,
		tblClassificacao.nome as nomeClassificacao,
		tblGenero.nome as nomeGenero,
		tblAtor.nome as nomeAtor,
		tblAtor.dataNascimento,
		tblDiretor.nome as nomeDiretor,
		tblRoteirista.nome as nomeRoteirista,
		tblNacionalidade.nome as nacionalidadeAtor
		
		from tblClassificacao inner join tblFilme
			on tblClassificacao.idClassificacao = tblFilme.idClassificacao
			
		inner join tblFilmeGenero 
			on tblFilme.idFilme = tblFilmeGenero.idFilme
		
		inner join tblGenero
			on tblGenero.idGenero = tblFilmeGenero.idGenero
			
		inner join tblFilmeAtor
			on tblFilme.idFilme = tblFilmeAtor.idFilme
			
		inner join tblAtor
			on tblAtor.idAtor = tblFilmeAtor.idAtor
			
		inner join tblFilmeDiretor
			on tblFilme.idFilme = tblFilmeDiretor.idFilme
			
		inner join tblDiretor
			on tblDiretor.idDiretor = tblFilmeDiretor.idDiretor
			
		inner join tblFilmeRoteirista
			on tblFilme.idFilme = tblFilmeRoteirista.idFilme
			
		inner join tblRoteirista
			on tblRoteirista.idRoteirista = tblFilmeRoteirista.idRoteirista
			
		inner join tblAtorNacionalidade
			on tblAtor.idAtor = tblAtorNacionalidade.idAtor
			
		inner join tblNacionalidade
			on tblNacionalidade.idNacionalidade = tblAtorNacionalidade.idNacionalidade
		
		order by nomeFilme asc, nomeAtor desc;
		
		SELECT * from vwListarFilme;
		
		desc vwListarFilme;
        
        #DROP VIEW
        drop view vwListarFilme;