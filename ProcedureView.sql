use VendasBD
GO

---------------------------------------------------------------
--STORED PROCEDURE
---------------------------------------------------------------

---------------------------------------------------------------
--1)Criar uma Stored Procedure para cadastrar Clientes.
--Lembre-se que todo cliente é uma Pessoa
---------------------------------------------------------------

create procedure sp_cadCliente
(   --parâmetros recebidos
    @nomeCli    varchar(50), @cpfCli varchar (14), @sts    int,
    @renda      decimal(10,2)
)
as
begin 
    --insert tabela pessoas
    insert into Pessoas (nome, cpf, status)
    values (@nomeCli, @cpfCli, @sts)
    -- insert na tabela clientes, mas precisamos do id da Pessoa para cadastra i cliente
    insert into Clientes (idPessoa, renda, credito)
    values (@@IDENTITY , @renda, (@renda * 0.3)) -- recupero o id e relaciono com cliente

end

select * from Pessoas
go

select * from Clientes
go

--testar a procedure
exec sp_cadCliente 'Edinho', '121.223.455-88', 1, 400.00
go

---------------------------------------------------------------
--2)Criar uma Stored Procedure para cadastrar Vendedores.
--Lembre-se que todo cliente é uma Pessoa
---------------------------------------------------------------

create procedure sp_cadVendedor
(
    @nomeVend   varchar (50), @cpfVend      varchar (14),
    @sts        int,          @salarioVend  decimal (10,2)
)
as
begin 

--cadastrar os dados da Pessoa

insert into Pessoas (nome, cpf, status)
values (@nomeVend, @cpfVend, @sts)

--declarar uma variável para armazenar o id gerado para a tabela Pessoas

declare @idVend int 

--armazenar o id gerado para a tabela Pessoas na variável declarada

set @idVend = @@IDENTITY

--cadastrar os dados do Vendedor

insert into Vendedores (idPessoa, salario)
values (@idVend, @salarioVend)

end

--testar a procedure 
exec sp_cadVendedor 'Orlando', '111.666.777-88', 1, 25400.00
go

select * from Pessoas
go

select * from Vendedores
go

--------------------------------------------------------------
--3) Criar procedure para cadastrar novos produtos no estoque
--------------------------------------------------------------

create procedure sp_cadProduto
(
    @desc   varchar (100),  @qtd   int, @preco  decimal (10,2),@sts int
)
as 
begin 
    insert into Produtos (descricao, qtd, valor, status)
    values (@desc, @qtd, @preco, @sts)
end
go


--testar procedure
exec sp_cadProduto 'Garrafa Termica', 15, 120.00, 1
go


select * from Produtos
go
--------------------------------------------------------------
--4) Criar procedure para cadastrar novos pedidos 
--------------------------------------------------------------

create procedure sp_cadPedido
(
    @sts int, 
    @idVend int, 
    @cliId int

)

as
begin 

    insert into Itens_Pedidos (data, status, idVendedor, idCliente)
    values (getdate(), @sts, @idVend, @cliId)

end 
go 

--testar procedure
exec sp_cadPedido 1,12,11
exec sp_cadPedido 1,8,3
go

select * from Pedidos
go


-------------------------------------------------------------
---5) Criar uma procedure para cadastrar item do pedido
-------------------------------------------------------------

create procedure sp_cadItemPedido
(
    @idPed      int,
    @idProd     int,
    @qtdProd    int
)

as 
begin 

    --declarar uma variável para armazenar o valor do produto cadastrado
    --na tabela de Produtos para o produto que está sendo inserido no pedido

    declare @valorProd decimal (10,2)

    --consultar o valor do produto que está sendo inserido no Pedido
    select @valorProd = valor from Produtos where idProduto = @idProd

    --inserir o item do pedido na tabela Itens_Pedidos
    insert into Itens_Pedidos (idPedido, idProduto,qtd, valor)
    values (@idPed, @idProd, @qtdProd, @valorProd)

end

select * from Pedidos
go

select * from Itens_Pedidos
GO

--testar a procedure
exec sp_cadItemPedido 1,22,1
go

------------------------------------------------------------
--7) Criar uma procedure para dar baixa em estoque sempre
-- que um produto for vendido
------------------------------------------------------------

create procedure sp_baixarEstoque
(
    @idProduto  int,
    @qtdVendida int
)

as
begin 

    update Produtos set qtd = qtd - @qtdVendida
    where idProduto = @idProduto and qtd >= @qtdVendida
end 
go


select * from Produtos
go

---testar procedure

exec sp_baixarEstoque 3,10
exec sp_baixarEstoque 5, 5
go

------------------------------------------------------------
--8) Criar uma procedure para atualizar o estoque sempre
-- que um produto for comprado
------------------------------------------------------------
create procedure sp_atualizarEstoque
(
    @idProduto      int,
    @qtdComprada    int
)
as 
begin 
    if @qtdComprada > = 0
    update Produtos set qtd = qtd + @qtdComprada
    where idProduto = @idProduto

end 
go

select * from Produtos
go

--testar procedure
exec sp_atualizarEstoque 1,10
go

---View

-------------------------------------------------------------
---1) Criar uma view paea consultar os produtos cadastradis
-------------------------------------------------------------

create view v_produtos
as 

select * from Produtos
go 

--testar a view

select * from v_produtos
go


--------------------------------------------------------------------
--2)Alterar a view para consultar todos os produtos cadastrados
--------------------------------------------------------------------

alter view v_produtos
as
  select idProduto Cod_produto, descricao Produto, qtd Estoque, valor Preco,
    case status
      when 1 then 'Ativo'
      when 2 then 'Inativo'
      --when 3 then 'Cancelado'
      else 'Indisponível'
    end Situacao
  from Produtos
go

select * from v_produtos
go

select * from v_produtos order by Produto
go 

update Produtos set status = 3 where idProduto in (5, 7, 9)
go

update Produtos set status = 4 where idProduto in (8, 10, 12)
go
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
create view v_clientes
as
  select Pessoas.id Codigo_Cliente, Pessoas.nome Cliente, Pessoas.cpf CPF_Cliente, Clientes.renda Renda, Clientes.credito Credito,
  case Pessoas.status
        when 1 then 'Ativo'
        when 2 then 'Inativo'
        else        'Cancelado'
    end  'Situção'

    from Pessoas, Clientes
    where Pessoas.id = Clientes.idPessoa

go


--testar a view
select * from v_clientes
go

update Pessoas set status = 2 where id in (3,11)
go 
update Pessoas set status = null where id = 5
go 
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--4) Criar um view que consulte os dados de todas as pessoas que são vendedores
--------------------------------------------------------------------------------------------
create view v_vendedores
as
    select P.id Cod_Vend, P.nome Vendedor, P.cpf CPF_Vend, V.salario Salario,
    case P.status

        when 1 then 'Ativo'
        when 2 then 'Inativo'
        else        'Cancelado'
    end  Situção

        from Pessoas P, Vendedores V
        where P.id = V.idPessoa
go 

--testar a view
select * from v_vendedores
go

update Pessoas set status = 2       where id = 6
update Pessoas set status = null    where id = 12
go
--------------------------------------------------------------------------------------------
--5) Criar uma view para consultar todos os pedidos e trazer os dados dos clientes que 
-- fizeram o pedido, vendedores que cadastraram pedidos e dados dos pedidos.
--------------------------------------------------------------------------------------------

create view v_Pedidos
as 
    select  
    Pd.idPedido Codigo, Pd.data, Pd.valor,
    vC.Codigo_Cliente, vC.Cliente, vC.renda, vC.credito,
    vV.Cod_Vend, vV.Vendedor, vV.Salario,
    case status 
        when 1 then 'Andamento'
        when 2 then 'Finalizado'
        when 3 then 'Entregue'
        else        'Cancelado'
    end Situacao
    from Pedidos Pd, v_clientes vC, v_vendedores vV
    where Pd.idCliente = vC.Codigo_Cliente and Pd.idVendedor = vV.Cod_Vend

go

select * from v_Pedidos
go

select * from Pedidos
go



update Pedidos set status = 2 where idPedido = 2
go

update Pedidos set status = 3 where idPedido = 5 
go 

update Pedidos set status = null where idPedido = 6
go

--------------------------------------------------------------------------------------------
--6) Criar uma view para consultar todos os dados dos Itens dos Pedidos e trazendo os dados
-- dos Produtos desses Pedidos
--------------------------------------------------------------------------------------------
create view v_ItensPedido
as
    select IP.idPedido Cod_Pedido, IP.idProduto Cod_Prod, Pr.descricao Produto,
           IP.qtd Qtd_Vendida, IP.valor Valor_Pago,
           case Pr.status
                when 1 then 'Ativo'
                when 2 then 'Inativo'
                else        'Cancelado'
           end Situacao

    from Itens_Pedidos IP, Produtos Pr
    where IP.idProduto = Pr.idProduto
go

--testando a view
select * from v_ItensPedido
go

--------------------------------------------------------------------------------------------
--7)Alterar a View para consultar os dados dos Itens dos Pedidos e trazendo os dados dos
-- Produtos desses Pedidos
-- O objetivo é juntar os dados de tabelas Itens_Pedidos com view v_Produtos (join)
--------------------------------------------------------------------------------------------

alter view v_ItensPedido

as 
    select IP.idPedido No_Pedido, IP.qtd Qtd_Vendida,
    IP.valor Valor_Item, vP.Produto Produto,
    vP.Preco Preco, vp.Situacao
    from Itens_Pedidos IP, v_produtos vP
    where IP.idProduto = vp.Cod_produto
go 

select * from v_ItensPedido
go

--------------------------------------------------------------------------------------------
--8)Alterar a View para consultar os dados dos Itens dos Pedidos e trazendo os dados dos
-- Produtos desses Pedidos
-- Acrescentar uma coluna que traz o total do Item
-- O objetivo é juntar os dados de tabelas Itens_Pedidos com view v_Produtos (join)
--------------------------------------------------------------------------------------------

alter view v_ItensPedido

as 
    select IP.idPedido No_Pedido, IP.qtd Qtd_Vendida,
    IP.valor Valor_Item, (IP.qtd * IP.valor) Total_Item,vP.Produto Produto,
    vP.Preco Preco, vp.Situacao
    from Itens_Pedidos IP, v_produtos vP
    where IP.idProduto = vp.Cod_produto
go 

select * from v_ItensPedido
go
