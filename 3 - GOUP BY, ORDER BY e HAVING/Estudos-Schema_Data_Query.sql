CREATE DATABASE IF NOT EXISTS Estudo;
USE Estudo;

-- Schema --------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Vendedores (
	id_vendedor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(255),
	departamento VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Clientes (
	id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(255),
    cidade VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Vendas (
	id_venda INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	id_vendedor INT UNSIGNED,
    id_cliente INT UNSIGNED,
    produto VARCHAR(255),
    valor DECIMAL(15,2),
    data_venda DATE,
    
    CONSTRAINT fk_vendaVendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedores (id_vendedor)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	CONSTRAINT fk_vendaCliente FOREIGN KEY (id_cliente) REFERENCES Clientes (id_cliente)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
);

-- Data ----------------------------------------------------------------------------------------------------
-- Inserindo vendedores
INSERT INTO Vendedores (nome, departamento) VALUES
('Ana', 'Eletrônicos'),
('João', 'Papelaria'),
('Carla', 'Eletrônicos'),
('Pedro', 'Roupas'),
('Marcos', 'Móveis');

-- Inserindo clientes
INSERT INTO Clientes (nome, cidade) VALUES
('Lucas', 'São Paulo'),
('Fernanda', 'Rio de Janeiro'),
('Rafael', 'Belo Horizonte'),
('Mariana', 'São Paulo'),
('Gabriel', 'Curitiba'),
('Juliana', 'Rio de Janeiro');

-- Inserindo vendas
INSERT INTO Vendas (id_vendedor, id_cliente, produto, valor, data_venda) VALUES
-- Janeiro
(1, 1, 'TV', 2000.00, '2025-01-05'),
(1, 2, 'Celular', 1500.00, '2025-01-06'),
(2, 1, 'Caneta', 5.00, '2025-01-06'),
(2, 3, 'Caderno', 15.00, '2025-01-07'),
(3, 4, 'Notebook', 3000.00, '2025-01-10'),
-- Fevereiro
(4, 5, 'Camisa', 100.00, '2025-02-02'),
(1, 6, 'Tablet', 1800.00, '2025-02-03'),
(3, 2, 'Headset', 500.00, '2025-02-05'),
(5, 3, 'Mesa', 700.00, '2025-02-07'),
(5, 1, 'Cadeira', 400.00, '2025-02-08'),
-- Março
(2, 6, 'Agenda', 25.00, '2025-03-01'),
(4, 4, 'Jaqueta', 250.00, '2025-03-05'),
(1, 5, 'Monitor', 1200.00, '2025-03-06'),
(3, 1, 'Impressora', 900.00, '2025-03-10'),
(5, 2, 'Sofá', 2500.00, '2025-03-12');

INSERT INTO Vendas (id_vendedor, id_cliente, produto, valor, data_venda) VALUES
-- Janeiro
(1, 4, 'Xbox', 1780.00, '2025-01-05');

-- Query ---------------------------------------------------------------------------------------------------
-- 1. Liste o nome do vendedor, o nome do cliente e o valor total vendido entre eles.
SELECT vdr.nome AS vendedor,
       cli.nome AS cliente,
       SUM(vnd.valor) AS total_vendido
FROM Vendas vnd
JOIN Vendedores vdr ON vnd.id_vendedor = vdr.id_vendedor
JOIN Clientes cli ON vnd.id_cliente = cli.id_cliente
GROUP BY vdr.nome, cli.nome
ORDER BY total_vendido DESC;

-- 2. Mostre o total de vendas por cidade dos clientes 
SELECT cli.cidade AS Cidade,
       SUM(vnd.valor) AS Total_Arrecadado
FROM Vendas vnd
JOIN Clientes cli ON vnd.id_cliente = cli.id_cliente
GROUP BY cli.cidade;

-- 3. Exiba a quantidade de produtos diferentes vendidos por cada vendedor.
SELECT vdr.nome AS Vendedor,
       COUNT(DISTINCT vnd.produto) AS Produtos_Diferentes
FROM Vendas vnd
JOIN Vendedores vdr ON vnd.id_vendedor = vdr.id_vendedor
GROUP BY vdr.nome
ORDER BY produtos_diferentes DESC;

-- 4. Liste os clientes que compraram de mais de um departamento diferente de vendedores.
SELECT cli.nome AS cliente,
       COUNT(DISTINCT vdr.departamento) AS departamentos_diferentes
FROM Clientes cli
JOIN Vendas vnd ON vnd.id_cliente = cli.id_cliente
JOIN Vendedores vdr ON vdr.id_vendedor = vnd.id_vendedor
GROUP BY cli.id_cliente
HAVING COUNT(DISTINCT vdr.departamento) > 1;

-- 5. Mostre os 3 clientes que mais gastaram em fevereiro de 2025, junto com o nome dos vendedores que realizaram as vendas.
SELECT cli.nome AS Cliente,
	   vdr.nome AS Vendedor,
	   SUM(vnd.valor) AS Total_Gasto_Em_Fevereiro_2025
FROM Clientes cli
JOIN Vendas vnd ON vnd.id_cliente = cli.id_cliente
JOIN Vendedores vdr ON vdr.id_vendedor = vnd.id_vendedor
WHERE vnd.data_venda > '2025-01-31' AND vnd.data_venda < '2025-03-01'
GROUP BY cli.id_cliente, vdr.id_vendedor
ORDER BY SUM(vnd.valor) DESC
LIMIT 3;
