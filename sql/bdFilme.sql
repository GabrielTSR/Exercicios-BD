#Comentário
 /*
	Comentário em bloco
 */
 
 #Cria um database novo no BD
 create database dbFilmesTurmaB;
 
 #Permite visualizar os databases existentes no BD
 show databases;
 
#Permite apagar um database no BD
 #drop database dbFilmesTurmaB;
 
 #Seleciona o database a ser utilizado
 use dbFilmesTurmaB;

#Cria uma tabela e seus atributos
create table tblClassificacao(
	idClassificacao int not null auto_increment primary key,
    nome varchar(20) not null,
    unique index(idClassificacao)
);

#Permite visualizar as tabelas existentes no DB
show tables;

create table tblSexo(
	idSexo int not null auto_increment,
    nome varchar(10) not null,
    primary key(idSexo),
    unique index (idSexo)
);

#Permite visualizar a descrição da estrutura da tabela
desc tblSexo;

#Tabela Genero
create table tblGenero (
	idGenero int not null auto_increment primary key,
	nome varchar(30) not null,
	unique index(idGenero)
);

#Tabela de Estudio
create table tblEstudio (
	idEstudio int not null auto_increment primary key,
	nome varchar(50) not null,
	unique index(idEstudio)
);

#Tabela de nacionalidade
create table tblNacionalidade (
	idNacionalidade int not null auto_increment primary key,
	nome varchar(20) not null,
	unique index (idNacionalidade)
);

#Tabela de filme
create table tblFilme(
	idFilme int not null auto_increment primary key,
	nome varchar(80) not null,
	nomeOriginal varchar(80),
	duracao time not null,
	dataLancamento date not null,
	dataRelancamento date not null,
	sinopse text not null,
	fotoCapa varchar(80),
	idClassificacao int not null,
	constraint FK_Classificacao_Filme #Define um nome para o Relacionamento
	foreign key (idClassificacao) #Especifica quem será a FK nesta tabela
	references tblClassificacao (idClassificacao), #Especifica de qual tabela virá a PK
	unique index (idFilme)
);

#Tabela de Diretor
create table tblDiretor (
	idDiretor int not null auto_increment primary key,
	nome varchar(80) not null,
	dataNascimento date not null,
	nomeArtistico varchar (80),
	biografia text,
	foto varchar (80),
	idSexo int not null,
	constraint FK_Sexo_Diretor foreign key (idSexo) references tblSexo (idSexo),
	unique index (idDiretor)
);

#Tabela Filme Diretor

create table tblFilmeDiretor (
	idFilmeDiretor int not null auto_increment primary key,
	idFilme int not null,
    idDiretor int not null,
	constraint FK_Filme_FilmeDiretor
	foreign key (idFilme)
	references tblFilme (idFilme),

	#Relacionamento com Diretor
    constraint FK_Diretor_FilmeDiretor
    foreign key (idDiretor)
    references tblDiretor (idDiretor),
    
    unique index (idFilmeDiretor)
);

#Tabela Filme Estudio

create table tblFilmeEstudio (
	idFilmeEstudio int not null auto_increment primary key,
	idFilme int not null,
    idEstudio int not null,
	constraint FK_Filme_FilmeEstudio
	foreign key (idFilme)
	references tblFilme (idFilme),

	#Relacionamento com Diretor
    constraint FK_Estudio_FilmeEstudio
    foreign key (idEstudio)
    references tblEstudio (idEstudio),
    
    unique index (idFilmeEstudio)
);

 

#Tabela Ator
#COM MUITAS INFORMAÇÕES FALTANDO
create table tblAtor (
	idAtor int not null auto_increment primary key,
    nome varchar(80),
    nomeArtistico varchar(80),
    dataNascimento date not null,
    dataFalecimento date,
    biografia text,
    idSexo int not null,
    unique index (idAtor)
);

desc tblAtor;

create table tblFilmeGenero (
	idFilmeGenero int not null auto_increment primary key,
	idFilme int not null,
	idGenero int not null,
	constraint FK_Filme_FilmeGenero
		foreign key (idFilme)
		references tblFilme (idFilme),

	constraint FK_Genero_FilmeDiretor
		foreign key (idGenero)
		references tblGenero (idGenero),
		
		unique index (idFilmeGenero)
);

create table tblFilmeAtor (
	idFilmeAtor int not null auto_increment primary key,
	idFilme int not null,
	idAtor int not null,

	constraint FK_Filme_FilmeAtor
		foreign key (idFilme)
		references tblFilme (idFilme),

	constraint FK_Ator_FilmeAtor
		foreign key (idAtor)
		references tblAtor (idAtor),
		
		unique index (idFilmeAtor)
);

create table tblRoteirista (
	idRoteirista int not null auto_increment primary key,
    nome varchar(80),
    foto varchar(80)
);

create table tblFilmeRoteirista (
	idFilmeRoteirista int not null auto_increment primary key,
	idFilme int not null,
	idRoteirista int not null,

	constraint FK_Filme_FilmeRoteirista
		foreign key (idFilme)
		references tblFilme (idFilme),

	constraint FK_Roteirista_FilmeRoteirista
		foreign key (idRoteirista)
		references tblRoteirista (idRoteirista),
		
		unique index (idFilmeRoteirista)
);

create table tblRoteiristaNacionalidade (
	idRoteiristaNacionalidade int not null auto_increment primary key,
	idRoteirista int not null,
	idNacionalidade int not null,

	constraint FK_Roteirista_RoteiristaNacionalidade
		foreign key (idRoteirista)
		references tblRoteirista (idRoteirista),

	constraint FK_Nacionalidade_RoteiristaNacionalidade
		foreign key (idNacionalidade)
		references tblNacionalidade (idNacionalidade),
		
		unique index (idRoteiristaNacionalidade)
);

create table tblDiretorNacionalidade (
	idDiretorNacionalidade int not null auto_increment primary key,
	idNacionalidade int not null,
	idDiretor int not null,

	constraint FK_Nacionalidade_DiretorNacionalidade
		foreign key (idNacionalidade)
		references tblNacionalidade (idNacionalidade),

	constraint FK_Diretor_DiretorNacionalidade
		foreign key (idDiretor)
		references tblDiretor(idDiretor),
		
		unique index (idDiretorNacionalidade)
);


create table tblAtorNacionalidade (
	idAtorNacionalidade int not null auto_increment primary key,
	idAtor int not null,
	idNacionalidade int not null,

	constraint FK_Ator_AtorNacionalidade
		foreign key (idAtor)
		references tblAtor (idAtor),

	constraint FK_Nacionalidade_AtorNacionalidade
		foreign key (idNacionalidade)
		references tblNacionalidade (idNacionalidade),
		
		unique index (idAtorNacionalidade)
);

create table tblRoteiristaSexo (
	idRoteiristaSexo int not null auto_increment primary key,
	idRoteirista int not null,
	idSexo int not null,

	constraint FK_Roteirista_RoteiristaSexo
		foreign key (idRoteirista)
		references tblRoteirista (idRoteirista),

	constraint FK_Sexo_RoteiristaSexo
		foreign key (idSexo)
		references tblSexo (idSexo),
		
		unique index (idRoteiristaSexo)
);

create table tblAtorSexo (
	idAtorSexo int not null auto_increment primary key,
	idAtor int not null,
	idSexo int not null,

	constraint FK_Ator_AtorSexo
		foreign key (idAtor)
		references tblAtor (idAtor),

	constraint FK_Sexo_FilmeRoteiristaSexo
		foreign key (idSexo)
		references tblSexo (idSexo),
		
		unique index (idAtorSexo)
);

#Alterando a estrutura de uma tabela
#modify column - Permite alterar as propriedades de um atributo
alter table tblAtor modify column nome varchar(80) not null;
    
#Permite mudar a escrita e as propriedades de um atributo
alter table tblAtor change column dataNasc dataNascimento  date not null;


#Permite adicionar um novo atributo
alter table tblAtor add column foto varchar(80);

#Permite adicionar um relacionamento em uma tabela já existente
alter table tblAtor add constraint FK_Sexo_Ator foreign key (idSexo) references tblSexo (idSexo);

#Alterando unique index de tblFilme()
alter table tblFilme add unique index (idFilme, fotoCapa);

#Como deletar um atributo que também é uma chave estrangeira
#Drop foreign key - Permite apagar um relacionamento
alter table tblAtor drop foreign key FK_Sexo_Ator;
#Drop column - permite apagar um atributo
alter table tblAtor drop column idSexo;

#Recuperando o idSexo da tabela de ator
alter table tblAtor
add column idSexo int not null,
add constraint FK_Sexo_Ator foreign key (idSexo) references tblSexo(idSexo);

desc tblAtor;

#Apagar tabela
drop table tblAtor;

#INSERTS, UPDATES E DELETES

	#Insert de valores individuais
	insert into tblGenero (nome)
		values('Suspense');
	
    #Insert de múltiplos valores
    	insert into tblGenero(nome) values('Animação'),
										  ('Musical'),
                                          ('Policial'),
                                          ('Fantasia');
		
	select * from tblGenero;

#Tabela de classificação
insert into tblClassificacao (nome) values  ('+10'), 
											('+12'),
                                            ('+14'), 
                                            ('+16'), 
                                            ('+18'), 
                                            ('Livre');
                                            
select * from tblClassificacao;

#Tabela de Filme
INSERT INTO tblFilme (nome, duracao, dataLancamento, dataRelancamento, sinopse, nomeOriginal, fotoCapa, idClassificacao)
              
              # UM SONHO DE LIBERDADE
	  VALUES ('UM SONHO DE LIBERDADE', 
			  '02:20:00', 
              '1995-01-25', 
              null, 
              'Em 1946, Andy Dufresne (Tim Robbins), um jovem e bem sucedido banqueiro, tem a sua vida radicalmente modificada ao ser condenado por um crime que nunca cometeu, o homicídio de sua esposa e do amante dela. Ele é mandado para uma prisão que é o pesadelo de qualquer detento, a Penitenciária Estadual de Shawshank, no Maine. Lá ele irá cumprir a pena perpétua. Andy logo será apresentado a Warden Norton (Bob Gunton), o corrupto e cruel agente penitenciário, que usa a Bíblia como arma de controle e ao Capitão Byron Hadley (Clancy Brown) que trata os internos como animais. Andy faz amizade com Ellis Boyd Redding (Morgan Freeman), um prisioneiro que cumpre pena há 20 anos e controla o mercado negro da instituição.',
              'The Shawshank Redemption', 
              'filme-um_sonho_de_liberdade-capa.jpg', 
              4),
              
              # O REI LEÃO
              ('O REI LEÃO', 
              '01:29:00', 
              '1994-07-08', 
              '2011-10-26',
              'Clássico da Disney, a animação acompanha Mufasa (voz de James Earl Jones), o Rei Leão, e a rainha Sarabi (voz de Madge Sinclair), apresentando ao reino o herdeiro do trono, Simba (voz de Matthew Broderick). O recém-nascido recebe a bênção do sábio babuíno Rafiki (voz de Robert Guillaume), mas ao crescer é envolvido nas artimanhas de seu tio Scar (voz de Jeremy Irons), o invejoso e maquiavélico irmão de Mufasa, que planeja livrar-se do sobrinho e herdar o trono.',
              'The Lion King', 
              'filme-o_rei_leao-capa.jpg', 
              6);
              
SELECT * FROM tblfilme;

#Tabela Filme Gênero
insert into tblFilmeGenero (idFilme, idGenero) values (1, 1),
													  (2, 2),
                                                      (2, 3),
                                                      (2, 4);
		
select * from tblFilmeGenero;

update tblFilme set duracao = '03:00:00' WHERE idFilme = 1;

#Delete
delete from tblGenero where idGenero = 1;