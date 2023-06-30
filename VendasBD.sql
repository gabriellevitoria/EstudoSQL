---------- Criar banco de dados ----------
create database VendasBD
go

---------- Acessar banco de dados ----------

use VendasBD
go

---------- CRIAR AS TABELAS DO BANCO DE DADOS ----------

---------- Criar a tabela Pessoas ----------

create table Pessoas
(
	id int not null primary key identity,
	nome varchar (50) not null,
	cpf varchar (14) not null unique,
	status int null check(status in (1,2,3))
)
go

-------- Criar a tabela Clientes ----------

create table Clientes
(
	idPessoa int not null primary key,		
	renda decimal(10,2) not null, 
	credito decimal (10,2) not null,
	--- restrição
	check(renda >= 700.00),
	check(credito >= 100.00),
	---- definição da chave estrangeira ----
	foreign key (idPessoa) references Pessoas(id)
)
go

--------- Criar a tabela Vendedores ----------

create table Vendedores
(
	idPessoa int not null primary key,		
	salario decimal(10,2) not null, 
	--- restrição
	check(salario >= 1000.00),
	---- definição da chave estrangeira ----
	foreign key (idPessoa) references Pessoas(id)
)
go

---------- Criar a tabela Pedidos -----------

create table Pedidos 
(
	idPedido int not null primary key identity,
	data datetime not null,
	valor decimal(10,2) null,
	status int null check(status between 1 and 4),
	idVendedor int not null references Vendedores(idPessoa),
	idCliente int not null references Clientes (idPessoa)
)
go

---------- Criar a tabela Produtos ----------

create table Produtos 
(
	idProduto int not null primary key identity,
	descricao varchar(100) not null,
	qtd int null check(qtd >= 0),
	valor decimal(10,2) null check(valor > 0.0),
	status int null check(status in (1,2))
)
go


--------- Criar a tabela Itens_Pedidos ---------

create table Itens_Pedidos
(
	idPedido int not null,
	idProduto int not null,
	qtd int null,
	valor decimal(10,2) null,
	-- definir chave primária composta
	primary key (idPedido, idProduto),
	-- restrição
	check (qtd > 0),
	check (valor > 0.0),
	-- definir as chaves estrangeiras
	foreign key (idPedido) references Pedidos(idPedido),
	foreign key (idProduto) references Produtos(idProduto)
)
go


------------- CRIAÇÃO DO CRUD ------------------

------- Inserir dados na Tabela Pessoas --------

insert into Pessoas (nome, cpf, status)
values ('Gabriela Mori', '479.123.567-89', 1)
go

insert into Pessoas (nome, cpf, status)
values ('Adam Cavalcante', '770.303.100-39', 2),
	   ('Carlos Henrique', '777.333.145-89', 2),
	   ('Júlio Cesar', '167.554.268-07', 1),
	   ('Gabriel Vituri', '078.001.568-56', 1)

go

insert into Pessoas
values ('Ana Maria Braga', '125.578.564-78',3),
	   ('Rodrigo Faro', '457.543.215-06', 1),
	   ('Alexandre José', '555.465.789-04', 2),
	   ('Maura Frigo', '489.123.520-20',1),
	   ('Selena Gomes', '478.569.780.80', 3)

go

insert into Pessoas (nome, cpf)
values ('Yuki Isabelle Mori', '124.457.555-04'),
	   ('Rambo Cavalcante', '456.578.555-04')

go

select * from Pessoas
go

------- Inserir dados na Tabela Clientes --------

insert into Clientes (idPessoa, renda, credito)
values (1, 5500.00, 1250.00),
       (2, 5540.00, 1220.00),
	   (11, 8000.00, 2000.00),
	   (12, 8000.00, 2010.00)
go --

insert into Clientes (idPessoa, renda, credito)
values (8, 5500.00, 1450.00),
	   (9, 5400.00, 1000.00),
	   (10, 4500.00, 1500.00)
go

select * from Clientes
go

------- Inserir dados na Tabela Vendedores --------
insert into Vendedores (idPessoa, salario)
values (3, 1800.00),
	   (4, 1850.00),
	   (5, 1900.00),
	   (6, 1799.99),
	   (7, 1800.00)
go

select * from Vendedores
go	   

-------- Inserir dados na Tabela Produtos ---------
insert into Produtos (descricao, qtd, valor, status)
values ('Chocolate Caseiro', 200, 7.50, 1),
	   ('Brigadeiro Meio Amargo', 50, 3.00, 1),
	   ('Brownie', 100, 8.50, 2),
	   ('Chocolate Branco Caseiro', 200, 7.50, 2),
	   ('Cookie Meio Amargo', 100, 6.50, 1),
	   ('Cookie Tradicional', 100, 6.50, 1),
	   ('Cookie de Chocolate', 100, 6.50, 1),
	   ('Cookie de Doce de Leite', 100, 6.50, 1),
	   ('Bolo Red Velvet',20, 9.00, 1),
	   ('Croissant', 50, 9.00, 1),
	   ('Bolo de Coco', 20, 9.00, 2),
	   ('Soda Italiana', 500, 8.00, 1),
	   ('Café expresso', 500, 2.50, 1),
	   ('Capuccino', 500, 3.50, 2)
go

select * from Produtos
go

-------- Pedido 1 -------

insert into Pedidos (data, status, idCliente, idVendedor)
values (GETDATE(), 1, 1, 3)
go

-------- Pedido 2 -------

insert into Pedidos (data, status, idCliente, idVendedor)
values ('2023-3-1', 1, 2, 4)
go

-------- Pedido 3 até 7 -------

insert into Pedidos (data, status, idCliente, idVendedor)
values (getdate(), 2, 8, 5), 
('2023-28-2', 1, 10, 6), 
(getdate(), 2, 11, 7),
(getdate(), 1, 12, 5),
('2023-27-2', 1, 9, 7)
go

select * from Pedidos
go


------ Itens do Pedido 1 -----

insert into Itens_Pedidos (idPedido, idProduto, qtd, valor)
values (1, 2, 25, 3.00),
	   (1, 7, 5, 6.50),
	   (1, 3, 7, 8.50),
	   (1, 5, 15, 6.50)
go

------ Itens do Pedido 2 -----

insert into Itens_Pedidos (idPedido, idProduto, qtd, valor)
values (2, 1, 17, 7.50),
	   (2, 9, 3, 9.00),
	   (2, 10, 2, 9.00),
	   (2, 14, 1, 3.50)
go

------ Itens do Pedido 3 -----

insert into Itens_Pedidos (idPedido, idProduto, qtd, valor)
values (3, 2, 5, 3.00),
	   (3, 3, 7, 8.50),
	   (3, 4, 6, 7.50),
	   (3, 13, 2, 2.50)
go

------ Itens do Pedido 4 -----

insert into Itens_Pedidos (idPedido, idProduto, qtd, valor)
values (4, 4, 17, 7.50),
	   (4, 5, 3, 9.00),
	   (4, 6, 2, 9.00)
go

------ Itens do Pedido 5 -----

insert into Itens_Pedidos (idPedido, idProduto, qtd, valor)
values (5, 7, 8, 6.50),
	   (5, 8, 2, 6.50)
go

------ Itens do Pedido 6 -----

insert into Itens_Pedidos (idPedido, idProduto, qtd, valor)
values (6, 9, 9, 9.00),
	   (6, 4, 1, 7.50),
	   (6, 1, 3, 7.50)
go

------ Itens do Pedido 7 -----

insert into Itens_Pedidos (idPedido, idProduto, qtd, valor)
values (7, 3, 20, 8.50),
	   (7, 2, 4, 3.00),
	   (7, 1, 5, 7.50),
	   (7, 7, 6, 6.50)
go

select * from Itens_Pedidos
go

----------------- CRUD: READ ---------------------------
--SELECT: Consultar os dados da tabela--

----------------------------------------------------------------
-- Acessar banco de dados 
----------------------------------------------------------------

use VendasBDM
go
------------------------------------------------------------------
-- 1) Consultar o nome e cpf de todas as pessoas cadastradas 
------------------------------------------------------------------

select nome, cpf from Pessoas
go

----------------------------------------------------------------------
--2) Consultar a descrição, valor e quantidade de produtos cadastrados
-----------------------------------------------------------------------

select descricao,qtd, valor from Produtos
go

----------------------------------------------------------------------
--3) Consultar todos os dados das pessoas cadastradas
-----------------------------------------------------------------------

select * from Pessoas
go

----------------------------------------------------------------------
--4) Consultar todos os dados das Tabelas do Banco de dados
-----------------------------------------------------------------------

select * from Pessoas
go

select * from Clientes
go

select * from Vendedores
go

select * from Pedidos
go

select * from Itens_Pedidos
go


----------------------------------------------------------------------
--5) Consultar todos os dados dos Produtos com valor acima de 5.00
-----------------------------------------------------------------------

select * from Produtos
where valor > 5.00
go

----------------------------------------------------------------------
--6) Consultar todos os dados dos Produtos com status igual a 2 e
-- valor maior ou igual a 5.00
-----------------------------------------------------------------------

select * from Produtos
where status = 2 or valor >= 5.00
go

----------------------------------------------------------------------
--7) Consultar todos os dados dos Produtos com valor status a 2 e
-- valor maior ou igual a 5.00
-----------------------------------------------------------------------

select * from Produtos
where status = 2 and valor >= 5.00
go

----------------------------------------------------------------------
--8) Consultar todos os dados dos Produtos com a descrição = Brownie
-----------------------------------------------------------------------
select * from Produtos
where descricao = 'Brownie'
go

----------------------------------------------------------------------
--9) Consultar todos os dados dos Produtos com descrição que começa
-- com a letra b
-----------------------------------------------------------------------

select * from Produtos
where descricao like 'b%'
go

----------------------------------------------------------------------
--10) Consultar todos os dados dos Produtos com descrição que começa
-- com a letra b
-----------------------------------------------------------------------

select * from Produtos
where descricao like '%o'
go

----------------------------------------------------------------------
--11) Consultar todos os dados dos Produtos com descrição que tenha
-- a letra a 
-----------------------------------------------------------------------

select * from Produtos
where descricao like '%a%'
go

----------------------------------------------------------------------
--12) Consultar todos os dados dos Produtos com descrição que comece
-- com qualquer letra e tenha a letra A na sequência
-----------------------------------------------------------------------

select * from Produtos
where descricao like '%_a%'
go

----------------------------------------------------------------------
--13) Consultar todos os dados dos Produtos com descrição que comece
-- com qualquer letra, tenha qualquer letra na sequência e a terceira letra 
-- seja a letra O
-----------------------------------------------------------------------

select * from Produtos
where descricao like '__o%'

--14) iniciando a junção de tabelas vizualizando a quantidade de id das tabelas

select * from Pessoas
go

select * from Clientes 
go

select * from Pedidos
go

---------------------------------------------------------------------------
-- JUNÇÃO DE TABELAS
---------------------------------------------------------------------------

---------------------------------------------------------------------------
--14) Consultar o nome e o id do cliente, nome e data que o cliente fez o 
-- pedido.

--Juntar as tabelas Pessoas, Clientes e Pedidos

-- Ter a saída: nome e Id do cliente, número do pedido e a data que ele foi
--feito.

-- Usar os nomes das tabelas
---------------------------------------------------------------------------

select Pessoas.nome, Clientes.idPessoa, Pedidos.idPedido, Pedidos.data
from Pessoas, Clientes, Pedidos
where	Pessoas.id = Clientes.idPessoa
and		Clientes.idPessoa = Pedidos.idCliente
go


---------------------------------------------------------------------------
--15) Consultar o nome e o id do cliente, nome e data que o cliente fez o 
-- pedido.

--Juntar as tabelas Pessoas, Clientes e Pedidos

-- Ter a saída: nome e Id do cliente, número do pedido e a data que ele foi
--feito.

-- Usar os nomes das tabelas e renomear as colunas da tabela resultante
---------------------------------------------------------------------------

select Pessoas.nome Cliente, Clientes.idPessoa Nome_cliente,
	   Pedidos.idPedido 'Nome_Pedido', Pedidos.data [Data Pedido]
from   Pessoas, Clientes, Pedidos
where  Pessoas.id = Clientes.idPessoa
and    Clientes.idPessoa = Pedidos.idCliente
go


---------------------------------------------------------------------------
--16) Consultar o nome e o id do cliente, nome e data que o cliente fez o 
-- pedido.

--Juntar as tabelas Pessoas, Clientes e Pedidos

-- Ter a saída: nome e Id do cliente, número do pedido e a data que ele foi
--feito. Ordenado pelo Nome do Cliente, em ordem ascendente (A a Z)

-- Usar os nomes das tabelas e renomear as colunas da tabela resultante
---------------------------------------------------------------------------

select Pessoas.nome Cliente, Clientes.idPessoa Nome_cliente,
	   Pedidos.idPedido 'Nome_Pedido', Pedidos.data [Data Pedido]
from   Pessoas, Clientes, Pedidos
where  Pessoas.id = Clientes.idPessoa
and    Clientes.idPessoa = Pedidos.idCliente
order by Pessoas.nome ASC
go

---------------------------------------------------------------------------
--17) Consultar o nome e o id do cliente, nome e data que o cliente fez o 
-- pedido.

--Juntar as tabelas Pessoas, Clientes e Pedidos

-- Ter a saída: nome e Id do cliente, número do pedido e a data que ele foi
--feito. Ordenado pelo Nome do Cliente, em ordem descendente (Z a A)

-- Usar os nomes das tabelas e renomear as colunas da tabela resultante
---------------------------------------------------------------------------

select Pessoas.nome Cliente, Clientes.idPessoa Nome_cliente,
	   Pedidos.idPedido 'Nome_Pedido', Pedidos.data [Data Pedido]
from   Pessoas, Clientes, Pedidos
where  Pessoas.id = Clientes.idPessoa
and    Clientes.idPessoa = Pedidos.idCliente
order by Pessoas.nome DESC
go

---------------------------------------------------------------------------
--18) Consultar o nome e o id do cliente, nome e data que o cliente fez o 
-- pedido.

--Juntar as tabelas Pessoas, Clientes e Pedidos

-- Ter a saída: nome e Id do cliente, número do pedido e a data que ele foi
--feito. Ordenado pelo Nome do Cliente, em ordem ascenentes (A a Z)

-- Usar apelidos (alias) para os nomes das tabelas e renomear as colunas
--da tabela resultante
---------------------------------------------------------------------------

select P.nome Cliente, C.idPessoa No_Cliente, Pe.idPediso 'No.Pedido', Pe.data [Data Pedido]
from Pessoas as P, Clientes C, Pedidos Pe
where P.id = C.idPessoa and C.idPessoa = Pe.idCliente
order by P.nome
go

---------------------------------------------------------------------------
--19) Consultar o nome e o id do cliente, nome e data que o cliente fez o 
-- pedido.

--Juntar as tabelas Pessoas e Clientes. 

--Ter a saída: Todos os dados dos Clientes em ordem alfabética ( A a Z)

--Usar apelidos (alias) para os nomes das tabelas e renomear as colunas
--da tabla resultante
---------------------------------------------------------------------------

select P.id Codigo, P.nome Cliente, P.cpf CPF, P.status Situacao,
		C.renda Renda, C.credito Credito
from	Pessoas P, Clientes C
where P.id = C.Idpessoa
order by P.nome
go 

---------------------------------------------------------------------------
--20) Consultar todos os dados dos Vendedores. Lembre-se que todo Vendedor
-- é uma pessoa.

--Juntar as tabelas Pessoas e Vendedores

--Ter a saída: Todos os dados dos Vendedores em ordem alfabética (A a Z)

--Usar apelido (alias) para os nomes das tabelas e renomear as colunas da
--tabela resultante
--------------------------------------------------------------------------

select P.id Codigo, P.nome Vendedor, P.cpf CPF, P.status Situacao,
		V.salario Salario
from Pessoas P, Vendedores V
where P.id = V.idPessoa
order by P.nome
go

select P.id Codigo, P.nome Vendedor, P.cpf CPF,
		case P.status
		when 1 then 'ATIVO'
		when 2 then 'INATIVO'
		else 'CANCELADO'
	end Situacao,
		V.salario Salario
from Pessoas P, Vendedores V
where P.id = V.idPessoa
order by P.nome
go


---------------------------------------------------------------------------
--21) Consultar todos os dados dos Clientes. Lembre-se que todo Cliente é uma
--pessoa.

--Juntar as tabelas Pessoas e Clientes. 

--Ter a saída: Todos os dados dos Clientes em ordem alfabética ( A a Z)

--Trazer os dados do Cliente 3

--Usar apelidos (alias) para os nomes das tabelas e renomear as colunas
--da tabla resultante
---------------------------------------------------------------------------

select P.id Codigo, P.nome Cliente, P.cpf CPF, P.status Situacao, 
		C.renda Renda, C.credito Credito
from Pessoas P, Clientes C
where P.id = C.idPessoa and C.idPessoa = 3
go

---------------------------------------------------------------------------
--22) Consultar todos os dados dos Clientes. Lembre-se que todo Cliente é uma
--pessoa.

--Juntar as tabelas Pessoas e Clientes. 

--Ter a saída: Todos os dados dos Clientes

--Trazer os dados do Cliente com nome começando com a letra W

--Usar apelidos (alias) para os nomes das tabelas e renomear as colunas
--da tabla resultante
---------------------------------------------------------------------------

select P.id Codigo, P.nome Cliente, P.cpf CPF, P.status Situacao, 
		C.renda Renda, C.credito Credito
from Pessoas P, Clientes C
where P.id = C.idPessoa and P.nome like 'W%'
go

-----------------------------------------------------------------------------
--23)Consultar todos os dados dos Itens de Pedidos
--Saída: idPedido, idProduto, Descrição do Produto, quantidade comprada,
--valor pago no Pedido
--Objetivo é juntar as tabelas Produtos e Itens_Pedido usando apelidos (alias)
-- para as tabelas e renomear as colunas
-----------------------------------------------------------------------------

select Ip.idPedido 'No.Pedido' ,Ip.idProduto 'Código do Produto', Pr.descricao,
       Ip.qtd 'Qtd Vendida', Ip.valor 'Preço Iten'
from Produtos Pr, Itens_Pedidos Ip
where Pr.idProduto = Ip.idProduto
go

-----------------------------------------------------------------------------
--24)Consultar todos os dados dos Itens de Pedidos
--Saída: idPedido, idProduto, Descrição do Produto, quantidade comprada,
--valor pago no Pedido e o total pago de cada Item 
--Objetivo é juntar as tabelas Produtos e Itens_Pedido usando apelidos (alias)
-- para as tabelas e renomear as colunas
-----------------------------------------------------------------------------

select Ip.idPedido 'No.Pedido', Ip.idProduto 'Código do Produto', Pr.descricao Produto,
	   Ip.qtd 'Qtd Comprada' , Ip.valor 'Preço do Item',
	   (Ip.qtd * Ip.valor) 'Total Item'
from Produtos Pr, Itens_Pedidos Ip
where Pr.idProduto = Ip.idProduto
order by Ip.idPedido, Pr.descricao
go

-----------------------------------------------------------------------------
--25)Consultar todos os  itens do pedido que tiveram desconto na compra
--Saída: idPedido, idProduto, Descrição do Produto, Qtd Vendida, valor Pago
--Objetivo é juntar as tabelas, renomear colunas e usar apelidos (alias) para
-- as tabelas
-----------------------------------------------------------------------------

select Ip.idPedido 'No. Pedido' , Ip. idProduto ' Cdgo Produto' , Pr.descricao Produto,
	   Ip.qtd 'Qtd Vendida' , Ip.valor 'Preço Pago'
from Produtos Pr, Itens_Pedidos Ip
where Pr.idProduto = Ip.idPedido and Ip.valor < Pr.valor
go

-----------------------------------------------------------------------------
--26)Consultar todos os  itens do pedido que tiveram desconto na compra
--Saída: idPedido, idProduto, Descrição do Produto, Qtd Vendida, valor Pago
--Objetivo é juntar as tabelas, renomear colunas e usar apelidos (alias) para
-- as tabelas
-----------------------------------------------------------------------------

select Ip.idPedido 'No. Pedido' , Ip. idProduto ' Cdgo Produto' , Pr.descricao Produto,
	   Ip.qtd 'Qtd Vendida' , Ip.valor 'Preço Pago', Pr.valor 'Preço em Estoque'
from Produtos Pr, Itens_Pedidos Ip
where Pr.idProduto = Ip.idProduto and Ip.valor < Pr.valor
go




------------------------------------------------------------------------------------------------------------
--Consultar os dados dos Produtos com valores entre 5 e 20
----------------------------------------------------------------------------------------------------------

----Operadores relacionais
select * from Produtos where valor >= 5.00 and valor <= 20.00
go

---- Between
select * from Produtos where valor between 5.00 and 20.00
go

-- Consultar os dados dos Produtos com valores que não pertençam ao intervalo de Valores entre 5,00 e 20,00

-- operadores relacionais e lógicos
select * from Produtos where valor < 5.00 or valor > 20.00
go

-- not between
select * from Produtos where valor not between 5.00 and 20.00
go


-----------------------------------------------------------------------------
--28) Todos os dados dos clienntes cujo status seja 2 ou 3
-----------------------------------------------------------------------------

select P.id, P.nome, P.cpf, C.renda, C.credito
from Pessoas P, Clientes C
where P.id = C.idPessoa and (P.status = 2 or P.status = 3)
go

--in

select P.id, P.nome, P.cpf, C.renda, C.credito
from Pessoas P, Clientes C
where P.id = C.idPessoa and status in (2,3)
go


-----------------------------------------------------------------------------------
--Todos os dados dos clientes cujo os status seja 2 ou 3
-----------------------------------------------------------------------------------

--Operadores Relacionais

select P.id, P.nome, P.cpf, C.renda, C.credito
from Pessoas P, Clientes C
where P.id = C.idPessoa and (P.status <> 2 and P.status <> 3)
go

--not in
select P.id, P.nome, P.cpf, C.renda, C.credito
from Pessoas P, Clientes C
where P.id = C.idpessoa and status not in (2,3)
go



-----------------------------------------------------------------------------------
--32) todos os dados dos Clientes sujo status seja null
-----------------------------------------------------------------------------------

--Operadores relacionais

select P.id, P.nome, P.cpf, C.renda, C.credito
from Pessoas P, Clientes C
where P.id = C.idpessoa and status is  NULL
go

select P.id, P.nome, P.cpf, V.salario
from Pessoas P, Vendedores V
where P.id = V.idPessoa and status is  NULL


-----------------------------------------------------------------------------------
--33) todos os dados dos Clientes sujo status seja diferente de null
-----------------------------------------------------------------------------------

--is null

select P.id, P.nome, P.cpf, C.renda, C.credito
from Pessoas P, Clientes C
where P.id = C.idpessoa and status is not NULL
go


select P.id, P.nome, P.cpf, V.salario
from Pessoas P, Vendedores V
where P.id = V.idpessoa and status is not NULL
go


-----------------------------------------------------------------------------------
--34) Consultar o valor médio dos produtos cadastrados
-----------------------------------------------------------------------------------

-------Função AVG -> serve para calcular a média aritimética-----------------------

select avg(valor)Valor_medio from Produtos
go

-----------------------------------------------------------------------------------
--35) Consultar o maior valor dos produtos cadastrados
-----------------------------------------------------------------------------------

----Função MAX -> serve para  consultar o maior valor de uma coluna na tabela------

select max(valor) Valor_medio from Produtos
go

-----------------------------------------------------------------------------------
--35) Consultar o menor valor dos produtos cadastrados
-----------------------------------------------------------------------------------

----Função MIN -> serve para  consultar o menor valor de uma coluna na tabela------

select min(valor) Valor_medio from Produtos
go



-----------------------------------------------------------------------------------
--36) Consultar o valor total dos produtos cadastrados
-----------------------------------------------------------------------------------

----Função SUM------

select sum(qtd * valor) Total from Produtos
go

-----------------------------------------------------------------------------------
--37) Calcular o total do pedido com id = 2
-----------------------------------------------------------------------------------

select sum (qtd * valor) Total_Pedidos from Itens_Pedidos
where idPedido = 2
go

select * from Itens_Pedidos
where idPedido = 2
go

select * from Produtos
go


-----------------------------------------------------------------------------------
--38) Calcular o total do pedido com id = 2
-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
--39) Calcular o total do pedido com id = 2
-----------------------------------------------------------------------------------
select count (idProduto) Total_Pedido from Itens_Pedidos where idProduto = 1
go

-----------------------------------------------------------------------------------
--40)Consultar todos os produtos cadastrados com valor acima da média de preço
-----------------------------------------------------------------------------------

select * from  Produtos
where valor > (
				select avg (valor)
				from Produtos
				)
go

insert into Produtos (descricao, qtd, valor, status)
values ('HD 1tb ', 50, 362.00, 1),
	   ('TV 50', 25, 1540.00 , 1),
	   ('Notebook' , 10, 3500.00, 1),
	   ('Panela Eletrica' , 50, 560.00, 1)
go



-----------------------------------------------------------------------------------
--41) Consultar todos os produtos que estão em algum pedido e identificar em 
--quantos pedidos esse produto aparece
-----------------------------------------------------------------------------------
select idProduto, count (*) Total_Produtos from Itens_Pedidos
group by idProduto
go


-----------------------------------------------------------------------------------
--42) Consultar o total de cada pedido cadastrado
-----------------------------------------------------------------------------------

select * from Itens_Pedidos where idPedido = 1 --
go 

select sum(qtd * valor) Total_pedido from Itens_Pedidos
where idPedido = 1
go


select idPedido, sum(qtd * valor) Total_Pedidos from Itens_Pedidos
group by idPedido
go


-----------------------------UPDATE------------------------------------------------
-----------------------------------------------------------------------------------
--43) Alterar o status de todas as pessoas cadastradas para 1
-----------------------------------------------------------------------------------

update Pessoas set status = 1
go

select * from Pessoas
go


-----------------------------------------------------------------------------------
--44) Alterar os valores dos produtos dando um aumento de 5% para todos os produtos
--cadastrados
-----------------------------------------------------------------------------------

update Produtos set valor = valor + (valor * 0.05)
go

select * from Produtos
go

-----------------------------------------------------------------------------------
--45) Alterar os valores dos produtos dando desconto de 10% para todos os produtos
--cadastrados com status = 2
-----------------------------------------------------------------------------------

update Produtos set valor = valor * 0.09
where status = 2
go

select * from Produtos
where status = 2
go


-----------------------------------------------------------------------------------
--46) Alterar os valores dos produtos dando aumento de 5% para todos os produtos
--cadastrados com valor acima da média de preço do estoque
-----------------------------------------------------------------------------------

update Produtos set valor = valor * 1.05
where valor > (
				select avg(valor) from Produtos
				)
go

select * from Produtos
go



-----------------------------------------------------------------------------------
--47) Calcular o valor total do Pedido com id = 2 e atualizar esse valor na tabela
--de Pedidos
-----------------------------------------------------------------------------------

update Pedidos set valor = ( 
							select sum(qtd * valor) from Itens_Pedidos
							where idPedido = 2 --soma e atribui o valor
							)
where idPedido = 2
go

select * from Pedidos
go

-----------------------------------------------------------------------------------
--48)Atualizar o status dos produtos par o valor NULL, quando o produto não estiver
--em nenhum pódio
-----------------------------------------------------------------------------------


update Produtos set status = NULL
where idProduto not in (
						 select idProduto from Itens_Pedidos
						 group by idProduto
						)
go


select idPedido from Itens_Pedidos
go


-----------------------------------------------------------------------------------
-- CRUD -- DELETE
-----------------------------------------------------------------------------------

use VendasBD
go

------------------------------------------------------------------------------------
--49) Excluir produto com id = 4
------------------------------------------------------------------------------------

delete from Produtos where idProduto = 4
go


