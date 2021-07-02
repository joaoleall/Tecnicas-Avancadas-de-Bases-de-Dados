--Trabalho realizado por Vítor Neto 68717, João Leal 68719, Hugo Anes 68571 e Leandro Coelho--
--Políticas de segurança e acesso a dados centralizados--
Use TABD_TP1
--Logins--
CREATE LOGIN Administrador WITH PASSWORD = '1'
CREATE LOGIN Client WITH PASSWORD = '1'
CREATE LOGIN Restaurante WITH PASSWORD = '1'
CREATE LOGIN Dono WITH PASSWORD = '1'

--Users--
CREATE USER Restaurante1 FOR LOGIN Restaurante
CREATE USER Administrador1 FOR LOGIN Administrador
CREATE USER Client1 FOR LOGIN Client
CREATE USER Dono FOR LOGIN Dono
CREATE USER Visitante WITHOUT LOGIN

--Roles--
CREATE ROLE Administradores
CREATE ROLE Clients
CREATE ROLE Restaurantes

--Adicionar membros a cada uma das roles--
ALTER ROLE Clients ADD MEMBER Client1
ALTER ROLE Administradores ADD MEMBER Administrador1
ALTER ROLE Restaurantes ADD MEMBER Restaurante1

--Atribuição de Permissões nas Tabelas

--Permissões para dono BD
GRANT SELECT, INSERT, UPDATE, DELETE TO Dono

--Permissões para os Restaurantes
GRANT SELECT ON Client to Restaurantes
GRANT SELECT, INSERT, UPDATE, DELETE ON CriarPrato to Restaurantes
GRANT SELECT, INSERT, UPDATE, DELETE ON PratoDoDia to Restaurantes
GRANT SELECT, INSERT, UPDATE ON Restaurante to Restaurantes
GRANT SELECT, INSERT, UPDATE ON Utilizador to Restaurantes

--Permissões para os Clients
GRANT SELECT ON Restaurante to Clients
GRANT SELECT ON CriarPrato to Clients
GRANT SELECT ON PratoDoDia to Clients
GRANT SELECT ON BloquearUtilizador to Clients
GRANT SELECT,INSERT,UPDATE ON Utilizador to Clients
GRANT SELECT,INSERT,UPDATE,DELETE ON AdicionarPratoFav to Clients
GRANT SELECT,INSERT,UPDATE,DELETE ON AdicionarRestFav to Clients
GRANT SELECT,INSERT,UPDATE ON Client to Clients

--Permissões para os Administradores
GRANT SELECT, INSERT, UPDATE, DELETE ON BloquearUtilizador to Administradores
GRANT SELECT, INSERT, UPDATE, DELETE ON Autorizar to Administradores
GRANT SELECT, DELETE ON Utilizador to Administradores
GRANT SELECT, DELETE ON Client to Administradores 
GRANT SELECT, INSERT, UPDATE ON Administrador to Administradores
GRANT SELECT, DELETE ON Restaurante to Administradores
GRANT SELECT on CriarPrato to Administradores
GRANT SELECT on PratoDoDia to Administradores

--Permissões para Visitante
GRANT SELECT ON Restaurante to Visitante
GRANT SELECT ON CriarPrato to Visitante
GRANT SELECT ON PratoDoDia to Visitante

--Procedures para Todos
GRANT EXECUTE On Novo_Utilizador to Visitante
GRANT EXECUTE On Alterar_Utilizador to Clients,Administradores,Restaurantes

--Procedures dos Clientes
GRANT EXECUTE On Ver_Restaurante_Especifico_Cliente to Clients
GRANT EXECUTE ON Ver_Horario_Restaurantes to Clients
GRANT EXECUTE On Ver_Todos_Restaurantes_Cliente to Clients
GRANT EXECUTE On Novo_Cliente to Clients
GRANT EXECUTE ON Ver_Horario_Restaurante_Especifico to Clients
GRANT EXECUTE On Alterar_Cliente to Clients
GRANT EXECUTE On Ver_RestaurantesFav to Clients
GRANT EXECUTE On Adicionar_PratoFavorito to Clients
GRANT EXECUTE On Adicionar_RestauranteFavorito to Clients
GRANT EXECUTE On Ver_Pratos_Do_Dia to Clients
GRANT EXECUTE On Ver_Pratos_Do_Dia_Restaurante to Clients
GRANT EXECUTE On Ver_Pratos to Clients
GRANT EXECUTE On Ver_Pratos_Restaurante to Clients
GRANT EXECUTE ON Ver_Servicos_Rest_Especifico to Clients
GRANT EXECUTE ON Ver_Servicos to Clients
GRANT EXECUTE ON Ver_Localizacao_Rest_Especifico to Clients
GRANT EXECUTE ON Ver_Localizacao_Rest to Clients

--Procedures dos Administradores
GRANT EXECUTE ON Novo_Admin TO Administradores
GRANT EXECUTE ON Confirmar_Email TO Administradores
GRANT EXECUTE ON Autorizar_Restaurante TO Administradores
GRANT EXECUTE ON Alterar_Admin TO Administradores
GRANT EXECUTE ON Bloquear_Utilizador TO Administradores
GRANT EXECUTE ON Ver_Clientes TO Administradores
GRANT EXECUTE ON Ver_Restaurantes_Admin TO Administradores
GRANT EXECUTE ON Ver_Clientes_Bloqueados TO Administradores
GRANT EXECUTE ON Ver_Restaurantes_Autorizados TO Administradores
GRANT EXECUTE ON Ver_Restaurantes_Nao_Autorizados TO Administradores

--Procedures dos Restaurantes
GRANT EXECUTE ON Criar_Prato_Do_Dia to Restaurantes
GRANT EXECUTE ON Criar_Prato to Restaurantes
GRANT EXECUTE ON Alterar_Pratos_Restaurante to Restaurantes
GRANT EXECUTE ON Eliminar_Pratos_Restaurante to Restaurantes	
GRANT EXECUTE ON Eliminar_Pratos_Do_Dia_Restaurante to Restaurantes
GRANT EXECUTE ON Criar_Restaurante to Restaurantes
GRANT EXECUTE ON Alterar_Restaurante to Restaurantes	