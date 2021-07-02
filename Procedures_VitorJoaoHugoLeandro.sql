--Trabalho realizado por Vítor Neto 68717, João Leal 68719, Hugo Anes 68571 e Leandro Coelho 68541--
--Procedures--

USE TABD_TP1
GO


CREATE PROCEDURE Eliminar_Restaurante_Fav
	 @id_Cliente integer,@id_Restaurante integer
as
set transaction isolation level repeatable read
begin transaction 
    delete from AdicionarRestFav
    where(id_Cliente=@id_Cliente and id_Restaurante=@id_Restaurante)
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
CREATE PROCEDURE Eliminar_Prato_Fav
	@id_Cliente integer,@id_Prato integer
as
set transaction isolation level repeatable read
begin transaction 
    delete from AdicionarPratoFav
    where(id_Client=@id_Cliente and id_Prato=@id_Prato)
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
CREATE PROCEDURE Eliminar_Pratos_Do_Dia_Restaurante
    @id_Restaurante integer, @id_Prato integer, @dia_da_semana varchar
as
set transaction isolation level repeatable read
begin transaction 
    delete from AdicionarPratoFav
    where(id_Prato=@id_Prato)
    delete from CriarPrato
    where(id_Restaurante=@id_Restaurante and dia_semana_prato=@dia_da_semana)
    delete from PratoDoDia
    where(id_Prato=@id_Prato)

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
--Procedures Necessários aos Utilizadores/Visitantes----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure Novo_Utilizador
	@id_Utilizador integer,@username varchar(50),@pass varchar(50), @email varchar(50),@tipo integer
as
set transaction isolation level read committed
	insert into Utilizador 
	values (@id_Utilizador,@username,@pass,@email,@tipo)
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Utilizador
    @id_Utilizador integer
as
set transaction isolation level read committed
begin transaction

	delete from BloquearUtilizador
    where (id_Utilizador=@id_Utilizador)
    delete from Utilizador
    where (id_Utilizador=@id_Utilizador)
    
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Utilizador
	@username varchar(50),@pass varchar(50),@email varchar(50), @tipo integer
as
set transaction isolation level read committed
begin transaction
	update Utilizador
	set Email=@email, pass=@pass,tipo=@tipo
	where Username=@username
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Procedures Necessários aos Clientes---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Restaurante_Especifico_Cliente
	@id_R integer
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	SELECT R.nome, R.morada, R.gps, R.telefone, R.dia_descanso, R.descricao, R.foto, R.hora_de_abertura, R.hora_de_fecho, R.tipo_entrega, R.tipo_local, R.tipo_takeaway
	FROM Restaurante R
	WHERE R.id_Restaurante = @id_R
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Todos_Restaurantes_Cliente
AS
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	SELECT * FROM Restaurante
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Novo_Cliente
	@nome varchar(20), @email varchar(50), @password varchar(50), @username varchar(50)
as
set transaction isolation level read committed
begin transaction 
	insert into Client
	values(@id_Cliente,'0')
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Cliente
	 @id_Cliente INTEGER, @nome varchar(50)
as
	set transaction isolation level read committed
	begin transaction
	update Client
	set  nome =@nome
	where id_Client = @id_Cliente

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Horario_Restaurantes
as
set transaction isolation level repeatable read
begin transaction 
	select R.nome as 'Nome',R.hora_de_abertura as 'Hora de Abertura',R.hora_de_fecho as 'Hora de Fecho',R.dia_descanso as 'Dia de Descanso'
	from Restaurante R
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Horario_Restaurante_Especifico
	@id_Restaurante integer
as
set transaction isolation level repeatable read
begin transaction 
	select R.nome as Nome, R.hora_de_abertura as 'Hora de Abertura',R.hora_de_fecho as 'Hora de Fecho',R.dia_descanso as 'Dia de Descanso'
	from Restaurante R
	where R.id_Restaurante=@id_Restaurante
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_RestaurantesFav--de certo cliente
	@Id_C integer
as
set transaction isolation level repeatable read
begin transaction 
	select R.nome,R.dia_descanso,R.telefone,R.tipo_takeaway,R.tipo_local,R.tipo_entrega,R.hora_de_abertura,R.hora_de_fecho,R.descricao,R.foto,R.validado
	from Restaurante R, AdicionarRestFav F
	where F.Id_Restaurante = R.id_Restaurante and Id_Cliente = F.Id_Cliente
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_PratosFav--de certo cliente
	@Id_C integer
as
set transaction isolation level repeatable read
begin transaction 
	select PD.nome,PD.descricao,PD.tipo_prato,PD.foto
	from AdicionarPratoFav PF, PratoDoDia PD
	where PF.id_Prato=PD.id_Prato and PF.id_Client=@Id_C;
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Adicionar_PratoFavorito
	@ID_C INTEGER,
	@ID_P INTEGER,
	@data datetime
AS
	INSERT INTO AdicionarPratoFav(id_Client,id_Prato,data_adicao)
	VALUES (@ID_C,@ID_P,GETDATE())
	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Adicionar_RestauranteFavorito
	@ID_C INTEGER,
	@ID_R INTEGER,
	@data datetime
AS
	INSERT INTO AdicionarRestFav(id_Cliente,id_Restaurante,data_adicao)
	VALUES (@ID_C,@ID_R,GETDATE())
	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Pratos_do_Dia
as
set transaction isolation level repeatable read
begin transaction 
	SELECT * FROM PratoDoDia
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Pratos_do_Dia_Restaurante
	@id_Restaurante integer
as
set transaction isolation level repeatable read
begin transaction 
	Select R.nome as Restaurante, PD.nome as Prato, PD.descricao as Descrição,PD.tipo_prato as Tipo
	from Restaurante R, PratoDoDia PD, CriarPrato CP
	where R.id_Restaurante=@id_Restaurante and PD.id_Prato=CP.id_Prato and R.id_Restaurante=CP.id_Restaurante
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Pratos
as
set transaction isolation level repeatable read
begin transaction 
	SELECT * FROM CriarPrato
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Pratos_Restaurante
	@id_Restaurante integer
as
set transaction isolation level repeatable read
begin transaction 
	SELECT R.nome as Nome, PD.nome as 'Prato do dia', PD.descricao as Descrição,PD.tipo_prato as Tipo, CP.preco as Preço,CP.dia_semana_prato as 'Dia da Semana'
	From Restaurante R, CriarPrato CP, PratoDoDia PD
	where R.id_Restaurante=@id_Restaurante and CP.id_Prato=PD.id_Prato
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Servicos_Rest_Especifico
	@id_Rest INTEGER
AS
	set transaction isolation level read committed
	begin transaction
	SELECT tipo_entrega, tipo_local, tipo_takeaway FROM Restaurante
	WHERE id_Restaurante = @id_Rest

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Servicos
	@tt BIT, @te BIT, @tl BIT
AS
	set transaction isolation level read committed
	begin transaction
	SELECT * FROM Restaurante
	WHERE tipo_entrega = @te OR tipo_local = @tl OR tipo_takeaway = @tt

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Localizacao_Rest_Especifico
	@id_Rest INTEGER
AS
	set transaction isolation level read committed
	begin transaction
	SELECT morada FROM Restaurante
	WHERE id_Restaurante = @id_Rest

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Localizacao_Rest
	@morada VARCHAR(50)
AS
	set transaction isolation level read committed
	begin transaction
	SELECT * FROM Restaurante
	WHERE morada = @morada

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Procedures Necessários aos Administradores--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Novo_Admin
	@id_Admin integer, @nome varchar(20)
as
set transaction isolation level read committed
begin transaction 
	insert into Administrador
	values(@id_Admin, @nome)
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Utilizador
    @id_Utilizador integer
as
set transaction isolation level read committed
begin transaction
    delete from BloquearUtilizador
    where(id_Utilizador=@id_Utilizador)
    delete from Utilizador
    where(id_Utilizador=@id_Utilizador)

    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Restaurante
    @id_Restaurante integer
as
set transaction isolation level read committed
begin transaction
    delete from AdicionarRestFav
    where(id_Restaurante=@id_Restaurante)
    delete from Restaurante
    where(id_Restaurante=@id_Restaurante)
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Admin
    @id_Admin integer
as
set transaction isolation level read committed
begin transaction
    delete from BloquearUtilizador
    where(id_Admin=@id_Admin)
    delete from Administrador
    where(id_Admin=@id_Admin)
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Cliente
    @id_Cliente integer
as
set transaction isolation level read committed
begin transaction
    delete from AdicionarPratoFav
    where(id_Client=@id_Cliente)
    delete from AdicionarRestFav
    where(id_Cliente=@id_Cliente)
    delete from Client
    where(id_Client=@id_Cliente)
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Confirmar_Email
	@id_Utilizador varchar(50)
as
set transaction isolation level read committed
begin transaction 
	update Client
	set Email_Confirmado=1
	where id_Client=@id_Utilizador
	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Admin
	 @nome varchar(50),@id_Admin integer
as
	set transaction isolation level read committed
	begin transaction
	update Administrador
	set nome=@nome
	where id_Admin=@id_Admin
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Bloquear_Utilizador
	@id_Admin integer, @id_Utilizador integer, @duracao integer, @motivo varchar
as
set transaction isolation level read committed
begin transaction 
	insert into BloquearUtilizador(id_Admin,id_Utilizador,duracao,motivo)
	values (@id_Admin,@id_Utilizador,@duracao,@motivo)
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Clientes
as
set transaction isolation level repeatable read
begin transaction 
	select * from Client
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Restaurantes_Admin
as
set transaction isolation level repeatable read
begin transaction 
	select * from Restaurante
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Clientes_Bloqueados
as
set transaction isolation level repeatable read
begin transaction 
	select C.nome as Nome, B.motivo as Motivo, B.duracao as Duração
	from Client C, BloquearUtilizador B
	where B.id_Utilizador=C.id_Client
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Restaurantes_Autorizados
as
set transaction isolation level repeatable read
begin transaction 
	select R.nome as Nome
	from Autorizar A, Restaurante R
	where A.id_Restaurante=R.id_Restaurante and R.validado=1
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Ver_Restaurantes_Nao_Autorizados
as
set transaction isolation level repeatable read
begin transaction 
    select R.nome as Nome
    from  Restaurante R
    where R.validado=0
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Procedures Necessários aos Restaurantes-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Criar_Prato
	@id_R integer, @id_P integer, @preco money, @dia_semana varchar(30), @apagado bit
as
set transaction isolation level read committed
begin transaction 
	insert into CriarPrato
	values (@id_R,@id_P,@preco,@dia_semana,'0')
	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Criar_Prato_Do_Dia
	@id_P integer, @nome varchar(25), @descricao varchar(200),@tipo_prato varchar(20),@foto varchar(300)
as
set transaction isolation level read committed
begin transaction 
	insert into PratoDoDia(id_Prato,nome,descricao,tipo_prato,foto)
	values (@id_P,@nome,@descricao,@tipo_prato,@foto)
	IF (@@ERROR <> 0) OR (@@ROWCOUNT = 0)
		GOTO ERRO
COMMIT
RETURN 1

ERRO:
	ROLLBACK
	RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Pratos_Restaurante
	@id_Restaurante integer, @id_Prato integer, @nome Varchar(50), @preco money,@dia_semana_prato varchar(50), @descricao varchar(250), @tipo_prato varchar(50)
as
set transaction isolation level repeatable read
begin transaction 
	update CriarPrato
	set id_Prato=@id_Prato,preco=@preco,dia_semana_prato=@dia_semana_prato 
	where id_Restaurante=@id_Restaurante
	update PratoDoDia
	set nome=@nome, descricao=@descricao, tipo_prato=@tipo_prato
	where id_Prato=@id_Prato
	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Pratos_Restaurante
    @id_Restaurante integer, @id_Prato integer
as
set transaction isolation level repeatable read
begin transaction 

	delete from AdicionarPratoFav
    where(id_Prato=@id_Prato)
    delete from CriarPrato
    where(id_Restaurante=@id_Restaurante and id_Prato=@id_Prato)
    delete from PratoDoDia
    where(id_Prato=@id_Prato)
    
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Eliminar_Pratos_Do_Dia_Restaurante
    @id_Restaurante integer, @id_Prato integer, @dia_da_semana varchar
as
set transaction isolation level repeatable read
begin transaction 
	
	delete from AdicionarPratoFav
    where(id_Prato=@id_Prato)
    delete from CriarPrato
    where(id_Restaurante=@id_Restaurante and dia_semana_prato=@dia_da_semana)
    delete from PratoDoDia
    where(id_Prato=@id_Prato)
  
    if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
    GOTO ERRO
    COMMIT
return 1
    ERRO:
        ROLLBACK
        RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Criar_Restaurante
	@id_Rest integer, @nome varchar(20), @morada VARCHAR(50), @gps VARCHAR(50), @telefone NUMERIC(9), @dia_desc VARCHAR(50), @tt BIT, @tl BIT, @te BIT, @hora_aber CHAR(5), @hora_fecho CHAR(5), @desc VARCHAR(250), @foto VARCHAR(300)
as
set transaction isolation level read committed
begin transaction 
	insert into Restaurante
	values(@id_Rest, @nome, 0, @morada, @gps, @telefone, @dia_desc, @tt, @tl, @te, @hora_aber, @hora_fecho, @desc, @foto)

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE Alterar_Restaurante
	 @id_Rest INTEGER, @nome varchar(50), @morada varchar(50), @gps VARCHAR(50), @telefone NUMERIC(9), @dia_desc VARCHAR(50), @tt BIT, @tl BIT, @te BIT, @hora_aber CHAR(5), @hora_fecho CHAR(5), @desc VARCHAR(250), @foto VARCHAR(300)
as
	set transaction isolation level read committed
	begin transaction
	update Restaurante
	set  nome = @nome, morada = @morada, gps = @gps, telefone = @telefone, dia_descanso = @dia_desc, tipo_takeaway = @tt, tipo_local = @tl, tipo_entrega = @te, hora_de_abertura = @hora_aber, hora_de_fecho = @hora_fecho, descricao = @desc, foto = @foto
	where id_Restaurante = @id_Rest

	if(@@ERROR <> 0) OR (@@ROWCOUNT = 0) 
	GOTO ERRO
	COMMIT
return 1
	ERRO:
		ROLLBACK
		RETURN -1
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------