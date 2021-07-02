USE master
GO

CREATE DATABASE bd_banco
GO

USE bd_banco
GO

CREATE TABLE CodigoPostal(
	cod_postal	CHAR(8)		NOT NULL,
	localidade	VARCHAR(30)	NOT NULL,
	PRIMARY KEY(cod_postal)
)

CREATE TABLE Agencias(
	cod_agencia	INTEGER		NOT NULL,
	nome		VARCHAR(50)	NOT NULL,
	morada		VARCHAR(50)	NOT NULL,
	cod_postal	CHAR(8)		NOT NULL,
	telefone	CHAR(9)		NOT NULL,
	fax			CHAR(9)		NOT NULL,
	PRIMARY KEY(cod_agencia),
	FOREIGN KEY(cod_postal) REFERENCES CodigoPostal(cod_postal)
)

CREATE TABLE Clientes(
	cod_cliente			INTEGER		NOT NULL,
	nome				VARCHAR(50)	NOT NULL,
	morada				VARCHAR(50)	NOT NULL,
	cod_postal			CHAR(8)		NOT NULL,
	-- cc -> cartao cidadao
	cc_numero			CHAR(12)	NOT NULL,
	cc_data_nascimento	DATE		NOT NULL,
	cc_data_validade	DATE		NOT NULL,
	num_conta			CHAR(13)	NOT NULL,
	telemovel			CHAR(9)		NOT NULL,
	telefone			CHAR(9),
	PRIMARY KEY(cod_cliente),
	FOREIGN KEY(cod_postal) REFERENCES CodigoPostal(cod_postal)
)

CREATE TABLE Contas(
	cod_conta		INTEGER	NOT NULL,
	cod_agencia		INTEGER	NOT NULL,
	data_abertura	DATE	NOT NULL,
	saldo			MONEY	NOT NULL,
	PRIMARY KEY(cod_conta),
	FOREIGN KEY(cod_agencia) REFERENCES Agencias(cod_agencia)
)

CREATE TABLE Contas_Clientes(
	cod_conta	INTEGER	NOT NULL,
	cod_cliente	INTEGER	NOT NULL,
	PRIMARY KEY(cod_conta, cod_cliente),
	FOREIGN KEY(cod_conta) REFERENCES Contas(cod_conta),
	FOREIGN KEY(cod_cliente) REFERENCES Clientes(cod_cliente)
)

create login Administrador with password = '123'
create login Cliente with password = '123'
create login Caixa with password = '123'
create login Gerente with password = '123'

create user Administrador1 FOR LOGIN Administrador
create user Cliente1 FOR LOGIN Cliente
create user Caixa1 FOR LOGIN Caixa
create user Gerente1 FOR LOGIN Gerente

Create role Caixas
Create role Gerentes
Create role Administradores
Create role Clientes

Alter role Caixas add member Caixa1
Alter role Gerentes add member Gerente1
Alter role Administradores add member Administrador1
Alter role Clientes add member Cliente1

--Permissoes do cliente-- devido a ter keys interligadas entre tabelas

Grant Select to Cliente1
Deny Select to Cliente1

--Permissoes do caixa

Grant Select to Gerente1
Grant Update on Contas(saldo) to Caixa1

--Permissoes do gerente

grant insert on Clientes to Gerente1
grant insert on Contas to Gerente1
grant insert on Contas_Clientes to Gerente1
grant insert on CodigoPostal to Gerente1
grant insert on Agencias to Gerente1

--Permissoes do admin

grant select,insert,update, delete to Administrador1

alter role db_owner add member Administrador1

deny Select on Clientes to cliente1
Select * From  CodigoPostal
