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
	
      INSERT INTO tblFilme (nome, duracao, dataLancamento, dataRelancamento, sinopse, nomeOriginal, fotoCapa, idClassificacao, qtde)
               # FORREST GUMP - O CONTADOR DE HISTÓRIAS
	  VALUES ('FORREST GUMP - O CONTADOR DE HISTÓRIAS', 
			  '02:20:00', 
              '1994-12-07', 
              null, 
              'Quarenta anos da história dos Estados Unidos, vistos pelos olhos de Forrest Gump (Tom Hanks), um rapaz com QI abaixo da média e boas intenções. Por obra do acaso, ele consegue participar de momentos cruciais, como a Guerra do Vietnã e Watergate, mas continua pensando no seu amor de infância, Jenny Curran.',
              'Forrest Gump', 
              'FORREST.jpg', 
              4,
              3),
              
              # À ESPERA DE UM MILAGRE
              ('À ESPERA DE UM MILAGRE', 
              '03:09:00', 
              '2000-03-10', 
              null,
              '1935, no corredor da morte de uma prisão sulista. Paul Edgecomb (Tom Hanks) é o chefe de guarda da prisão, que temJohn Coffey (Michael Clarke Duncan) como um de seus prisioneiros. Aos poucos, desenvolve-se entre eles uma relação incomum, baseada na descoberta de que o prisioneiro possui um dom mágico que é, ao mesmo tempo, misterioso e milagroso.',
              'The Green Mile', 
              'filme-o_rei_leao-capa.jpg', 
              4,
              4);
              
SELECT * FROM tblfilme;

#Tabela Filme Gênero
insert into tblFilmeGenero (idFilme, idGenero) values (1, 1),
													  (2, 2),
                                                      (3, 3),
                                                      (4, 4);
		
select * from tblFilmeGenero;

update tblFilme set duracao = '03:00:00' WHERE idFilme = 1;

#Delete
delete from tblGenero where idGenero = 1;

INSERT INTO tblsexo (nome) VALUES ('M'), ('F');

INSERT INTO tblnacionalidade(nome) VALUES ('Brasileiro'),( 'Estadunidense'),('sulafricano'),( 'albanês'),( 'alemão'),( 'argentino'),( 'australiano'),( 'austríaco'),( 'japonês');

INSERT INTO tblAtor(nome, nomeArtistico, dataNascimento, dataFalecimento, biografia, foto, idSexo) VALUES
#Um sonho de um liberdade
(
  'Bob Gunton',
  null,
  '1945-11-15',
  null,
  'ESTADO CIVIL
Atividade Ator
Nacionalidade Americano
Nascimento 15 de novembro de 1945
Idade 76 anos',
'bob.jpg',
1
),
(
  'MORGAN FREEMAN',
  null,
  '1937-06-01',
  null,
  'ESTADO CIVIL
Atividades Ator, Produtor de set, Produtor Executivo mais
Nacionalidade Americano
Nascimento 1 de junho de 1937 (Memphis, Tennesee, EUA)
Idade 84 anos',
'morganf.jpg',
1
);

INSERT INTO tblAtor(nome, nomeArtistico, dataNascimento, dataFalecimento, biografia, foto, idSexo) VALUES
#O rei leão
(
  'GARCIA JÚNIOR',
  null,
  '1967-03-02',
  null,
  null,
'garciajunior.jpg',
1
),
(
  'JORGEH RAMOS',
  null,
  '1941-02-03',
  '2014-12-01',
  'locutor, poeta, jornalista, pintor e dublador brasileiro. Conhecido por ser a voz mais famosa de trailers no Brasil e por seu bordão: sexta-feira nos cinemas, trabalhou em diversos estúdios do Rio de Janeiro.',
  'jorgehjunior.jpg',
  1
);

INSERT INTO tblAtor(nome, nomeArtistico, dataNascimento, dataFalecimento, biografia, foto, idSexo)
               # FORREST GUMP - O CONTADOR DE HISTÓRIAS
	  VALUES ('Thomas Jeffrey Hanks', 
			  'Tom Hanks', 
              '1956-07-09', 
              null, 
              'Tom Hanks iniciou a carreira no cinema aos 24 anos, com um papel no filme de baixo orçamento Trilha de Corpos. Logo migrou para a TV, onde estrelou por dois anos a série Bosom Buddies. Nela passou a trabalhar com comédia, algo com o qual não estava habituado, rendendo convites para pequenas participações nas séries Táxi, Caras & Caretas e Happy Days.',
              'fotoHanks.png', 
              1),
              ('Robin Virginia Gayle Wright', 
			  'Robin Wright Penn', 
              '1966-04-08', 
              null, 
              'Robin Wright nasceu em Dallas, Texas, filha de Gayle Gaston, uma vendedora de cosméticos, e Freddie Wright, funcionário de uma empresa farmacêutica. A atriz ficou famosa por seus papeis em House of Cards, Mulher-Maravilha, Corpo Fechado e Forrest Gump - O Contador de Histórias.Wright foi criada em San Diego, Califórnia.',
              'fotoRobin.png', 
              2);
              
INSERT INTO tblAtor(nome, nomeArtistico, dataNascimento, dataFalecimento, biografia, foto, idSexo)
               # À ESPERA DE UM MILAGRE
	  VALUES 
              ('MICHAEL CLARKE DUNCAN', 
			  'Michael Duncan', 
              '1957-12-10',
              '1957-09-03', 
              'Michael Clarke Duncan é conhecido pela atuação em À Espera de um Milagre, que lhe rendeu indicações ao Oscar e ao Globo de Ouro de Melhor Ator Coadjuvante. Fez sua estreia nos cinemas em 1995, com um papel não creditado em Sexta-Feira em Apuros. O primeiro trabalho de destaque viria três anos depois com Armageddon. Agradou tanto que Bruce Willis recomendou que Frank Darabont contratasse ele para À Espera de um Milagre, em 1999.Muitas vezes tratado como Big Mike, por causa da altura de 1,96 m, o ator se destacou ainda em Meu Vizinho Mafioso, Planeta dos Macacos, O Escorpião Rei e A Ilha. Participou também de três adaptações dos quadrinhos: O Demolidor, Sin City - A Cidade do Pecado e Lanterna Verde. Robert Rodriguez contava com o retorno dele para Sin City 2: A Dame to Kill For, algo que infelizmente não irá mais acontecer.Na TV, Clarke Duncan contou com participações em importantes seriados, como Um Maluco no Pedaço, Bones, Chuck e Two and a Half Men. Faleceu em setembro de 2012, aos 54 anos, após passar dois meses hospitalizado em Los Angeles.',
              'fotomichaelclarke.png', 
              1),
              ('DAVID MORSE', 
			  null, 
              '1957-10-11',
              null, 
              'David Morse é filho de Jacquelyn (professora) e de Charles Morse (encarregado de vendas). Tem três irmãs. Casou-se com Susan Duff a 19 de Junho de 1982. O casal teve três filhos e reside atualmente em Filadélfia, Pensilvânia.',
              'fotodavidmorse.png', 
              1);
              
INSERT INTO tbldiretor (nome, dataNascimento, nomeArtistico, biografia, foto, idSexo) VALUES
	#FORREST GUMP
	('Robert Lee Zemeckis', 
    '1952-05-14', 
    null, 
    'Especialista em efeitos especiais, Robert Zemeckis é um dos partidários dos filmes do também diretor Steven Spielberg, que já produziu vários de seus filmes; - Trabalhando geralmente com seu parceiro de roteiros Bob Gale, os primeiros filmes de Robert apresentou ao público seu talento para comédias tipo pastelão', 
    'fotoRobert.png', 
    '1');
    
INSERT INTO tbldiretor (nome, dataNascimento, nomeArtistico, biografia, foto, idSexo) VALUES
	#Um sonho de liberdade/A espera de um milagre
	('FRANK DARABONT', 
    '1959-01-28', 
    'Ardeth Bey', 
    '- É o autor dos roteiros de "A Hora do Pesadelo 3", "A Mosca 2" e "Frankenstein de Mary Shelley".
	 - Trabalhou como roteirista na série de TV norte-americana "O Jovem Indiana Jones"', 
    'frankdara.png', 
    '1');
    
INSERT INTO tbldiretor (nome, dataNascimento, nomeArtistico, biografia, foto, idSexo) VALUES
	#O rei leão
	('ROGER ALLERS', 
    '1949-06-29', 
    'null', 
    'Roger Allers é um diretor, roteirista, artista de storyboard, cartunista e dramaturgo americano. Ele é mais conhecido por co-dirigir o filme de animação tradicional de maior bilheteria na história, O Rei Leão da Walt Disney Animation Studios, e por escrever a adaptação da Broadway, O Rei Leão.', 
    'rogeraller.png', 
    '1');
    
    #tblFilmeAtor - Um sonho de liberdade
    INSERT INTO tblfilmeator (idFilme, idAtor) VALUES (1, 1), (1, 2);
    
    #tblFilmeAtor - O rei leão
    INSERT INTO tblfilmeator (idFilme, idAtor) VALUES (2, 3), (2, 4);
    
    #tblFilmeAtor - FORREST GUMP - O CONTADOR DE HISTÓRIAS
    INSERT INTO tblfilmeator (idFilme, idAtor) VALUES (3, 5), (3, 6);
    
    #tblFilmeAtor - À ESPERA DE UM MILAGRE
    INSERT INTO tblfilmeator (idFilme, idAtor) VALUES (4, 7), (4, 8);
    
    
    SELECT * FROM dbfilmesturmab.tbldiretornacionalidade;
    SELECT * FROM dbfilmesturmab.tblnacionalidade;
    SELECT * FROM dbfilmesturmab.tblDiretor;
    SELECT * FROM dbfilmesturmab.tblsexo;
    SELECT * FROM dbfilmesturmab.tblfilmeDiretor;
    SELECT * FROM dbfilmesturmab.tblfilme;
    SELECT * FROM dbfilmesturmab.tblator;
    SELECT * FROM dbfilmesturmab.tblestudio;
    SELECT * FROM dbfilmesturmab.tblRoteirista;
    
    INSERT INTO tbldiretornacionalidade (idDiretor, idNacionalidade) VALUES (1, 5),(2, 4),(3, 2);
    INSERT INTO tbldiretorSexo (idDiretor, idSexo) VALUES (1, 1),(2, 1),(3, 1);
    INSERT INTO tblFilmeDiretor (idDiretor, idFilme) VALUES (1, 3),(2, 4),(2, 1),(3, 2);
    INSERT INTO tblAtorsexo (idAtor, idSexo) VALUES (1, 1),(2, 1),(3, 1),(4, 1),(5, 1),(6, 2),(7, 1),(8, 1);
    
    INSERT INTO tblatornacionalidade (idAtor, idNacionalidade) VALUES (5, 2),(6, 2),(3, 2),(2, 2),(2, 1),(3, 1),(4, 1),(7, 2),(8, 2);
    
    INSERT INTO tblEstudio (nome) VALUES ('Columbia Pictures'),('Disney'),('Paramount'),('Warner Bros');
    INSERT INTO tblFilmeEstudio (idEstudio, idFilme) VALUES (1,1),(2,2),(3,3),(4,4);
    
    INSERT INTO tblroteirista (nome, foto) VALUES ('Stephen Edwin King', 'fotoSthephen'),('Jonathan Roberts', 'fotoJonathan'),('Winston Groom', 'fotoWinston'),('Frank Darabont', 'fotoFrank');
    INSERT INTO tblRoteiristaSexo (idRoteirista, idSexo) VALUES (1, 1),(2, 1),(3, 1),(4, 1);
    INSERT INTO tblRoteiristaNacionalidade (idRoteirista, idNacionalidade) VALUES (1, 2),(2, 2),(3, 2),(4, 5);
	INSERT INTO tblfilmeroteirista (idRoteirista, idFilme) VALUES (1, 1),(2, 2),(3, 3),(4, 4);
    
    