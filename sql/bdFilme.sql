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