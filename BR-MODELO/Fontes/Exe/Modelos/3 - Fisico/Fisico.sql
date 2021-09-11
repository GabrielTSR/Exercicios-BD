-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.



CREATE TABLE Pessoa (
CodPessoa VARCHAR PRIMARY KEY
)

CREATE TABLE Telefones (
Telefones_PK INTEGER PRIMARY KEY,
Telefones VARCHAR,
CodPessoa_FK VARCHAR,
FOREIGN KEY(CodPessoa_FK) REFERENCES Pessoa (CodPessoa)
)

