-- SCHEMA -----------------------------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS Estudo30SET;
USE Estudo30SET;

CREATE TABLE IF NOT EXISTS Cliente (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    cidade VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Pedido (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATE,
    total DECIMAL(15,2),
    id_cliente INT UNSIGNED,
    
    CONSTRAINT fk_ClientePedido FOREIGN KEY (id_cliente) REFERENCES Cliente (id)
		ON UPDATE CASCADE 
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS ItensPedido (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	produto VARCHAR(255),
    quantidade INT UNSIGNED,
    total_unitario DECIMAL(15,2),
    id_pedido INT UNSIGNED,
    
    CONSTRAINT fk_ItemPedido FOREIGN KEY (id_pedido) REFERENCES Pedido (id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- DATA -------------------------------------------------------------------------------------------------

INSERT INTO Cliente (id, nome, cidade) VALUES
(1, 'Ana Souza', 'São Paulo'),
(2, 'Bruno Lima', 'Rio de Janeiro'),
(3, 'Carla Mendes', 'Belo Horizonte'),
(4, 'Diego Alves', 'Curitiba'),
(5, 'Fernanda Costa', 'São Paulo'),
(6, 'Gustavo Pereira', 'Porto Alegre'),
(7, 'Helena Rocha', 'Recife'),
(8, 'Igor Martins', 'Salvador'),
(9, 'Juliana Silva', 'São Paulo'),
(10, 'Lucas Oliveira', 'Fortaleza');

INSERT INTO Pedido (id, id_cliente, data_pedido, total) VALUES
(1, 1, '2025-01-10', 150.00),
(2, 2, '2025-01-15', 350.00),
(3, 3, '2025-02-01', 200.00),
(4, 1, '2025-02-10', 90.00),
(5, 4, '2025-02-20', 500.00),
(6, 5, '2025-03-01', 120.00),
(7, 2, '2025-03-05', 700.00),
(8, 6, '2025-03-15', 80.00),
(9, 7, '2025-03-20', 300.00),
(10, 8, '2025-03-25', 1000.00),
(11, 1, '2025-04-01', 200.00),
(12, 1, '2025-04-10', 150.00),
(13, 1, '2025-04-15', 300.00),
(21, 2, '2025-04-05', 400.00),
(15, 2, '2025-04-20', 250.00),
(16, 2, '2025-04-25', 150.00),
(17, 3, '2025-05-01', 500.00),
(18, 3, '2025-05-10', 120.00),
(19, 4, '2025-05-15', 300.00),
(20, 4, '2025-05-20', 200.00),
(22, 1, '2025-06-01', 1000.00),
(23, 1, '2025-06-05', 1200.00),
(24, 2, '2025-06-02', 1500.00),
(25, 2, '2025-06-06', 1800.00),
(26, 3, '2025-06-03', 400.00),
(27, 3, '2025-06-10', 500.00),
(28, 3, '2025-06-15', 600.00);

INSERT INTO ItensPedido (id, id_pedido, produto, quantidade, total_unitario) VALUES
(1, 1, 'Mouse', 2, 50.00),
(2, 1, 'Teclado', 1, 50.00),
(3, 2, 'Monitor', 1, 350.00),
(4, 3, 'Headset', 2, 100.00),
(5, 4, 'Mousepad', 3, 30.00),
(6, 5, 'Notebook', 1, 500.00),
(7, 6, 'Cabo HDMI', 4, 30.00),
(8, 7, 'Cadeira Gamer', 1, 700.00),
(9, 8, 'Pen Drive', 2, 40.00),
(10, 9, 'Impressora', 1, 300.00);

INSERT INTO ItensPedido (id, produto, quantidade, total_unitario) VALUES
(12, 'Smartwatch', 2, 800.00),
(13, 'HD Externo', 1, 350.00),
(14, 'Webcam', 1, 200.00),
(15, 'Caixa de Som Bluetooth', 1, 300.00),
(16, 'Scanner', 1, 400.00),
(17, 'Roteador Wi-Fi', 1, 250.00),
(18, 'Carregador Portátil', 3, 150.00);


-- QUERY ------------------------------------------------------------------------------------------------

-- 1. Liste os nomes dos clientes e a soma do valor de todos os pedidos que cada um realizou.
SELECT c.nome AS "Nome do cliente", 
	SUM(p.total) AS "Total gasto"
FROM Cliente c
JOIN Pedido p ON c.id = p.id_Cliente
GROUP BY c.id;

-- 2. Mostre todos os clientes e seus respectivos pedidos, incluindo aqueles que não têm nenhum pedido
SELECT * FROM Cliente c
LEFT JOIN Pedido p ON c.id = p.id_Cliente;

-- 3. Exiba os produtos mais vendidos, mostrando o nome do produto e a quantidade total vendida, em ordem decrescente de vendas.
SELECT i.produto AS Produto,
	SUM(i.quantidade) AS "Exemplares Vendidos", 
	p.total AS "Total Arrecadado"
FROM ItensPedido i
JOIN Pedido p ON i.id_pedido = p.id
GROUP BY i.id
ORDER BY i.quantidade DESC;

-- 4. Traga a lista de clientes que realizaram mais de 3 pedidos no total.
SELECT c.nome AS "Nome Cliente",
	COUNT(p.id) AS TotalPedidos
FROM Cliente c
JOIN Pedido p on p.id_cliente = c.id
GROUP BY c.nome
HAVING TotalPedidos > 3
ORDER BY TotalPedidos DESC;

-- 5. Mostre a média do valor dos pedidos realizados em cada cidade dos clientes.
SELECT c.cidade AS Cidade, 
	CONCAT("R$",ROUND(AVG(p.total), 2)) AS "Média Arrecadada"
FROM Cliente c
JOIN Pedido p on p.id_cliente = c.id
GROUP BY Cidade
ORDER BY AVG(p.total) DESC;

-- 6. Liste todos os pedidos junto com o nome do cliente, mas organize a saída primeiro pela cidade e depois pela data do pedido.
SELECT p.id AS Numero_Pedido,
	c.nome AS Nome_Cliente,
    c.cidade AS Cidade
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id
ORDER BY c.cidade ASC, p.data_pedido ASC;

-- 7. Encontre os clientes que nunca compraram determinado produto específico (por exemplo: "Notebook").
SELECT c.nome AS Nome_Cliente
FROM Cliente c
WHERE c.id NOT IN (
	SELECT p.id_cliente FROM Pedido p
    JOIN itenspedido i ON i.id_pedido = p.id
    WHERE i.produto = 'Notebook'
);

-- 8. Mostre o maior pedido (em valor total) feito por cada cliente.
SELECT c.nome AS Cliente,
	MAX(p.total) as "Maior Pedido em Valor Total"
FROM Cliente c
JOIN Pedido p ON p.id_cliente = c.id
GROUP BY c.nome
ORDER BY MAX(p.total) DESC;

-- 9. Traga a lista de produtos que nunca foram vendidos.
SELECT i.produto AS "Produto nunca vendido"
FROM ItensPedido i
WHERE i.id_pedido IS NULL;

-- 10. Liste os clientes cujo gasto médio em pedidos seja superior ao gasto médio geral de todos os clientes.
SELECT c.nome AS "Nome Cliente",
	CONCAT("R$", ROUND(AVG(p.total), 2)) AS "Média gasta por cliente"
FROM Cliente c
NATURAL JOIN Pedido p
GROUP BY c.nome
HAVING AVG(p.total) > (SELECT AVG(total) FROM Pedido); 

-- 11. Liste os clientes cujo gasto médio em pedidos seja superior ao gasto médio geral de todos os clientes (bônus, retorne o gasto médio geral de todos os clientes).
SELECT c.nome AS "Nome Cliente",
	CONCAT("R$", ROUND(AVG(p.total), 2)) AS "Média gasta por cliente",
    (SELECT CONCAT("R$", ROUND(AVG(total), 2)) FROM Pedido) AS "Média Geral"
FROM Cliente c
NATURAL JOIN Pedido p
GROUP BY c.nome
HAVING AVG(p.total) > (SELECT AVG(total) FROM Pedido); 

-- 12. Traga todos os pedidos cujo total seja maior que o total médio de pedidos do mesmo cliente.
SELECT p.id AS "Numero Pedido",
	p.total AS "Total Gasto",
    c.nome AS "Nome Cliente"
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id
WHERE p.total > (
	SELECT AVG(total) 
    FROM Pedido
    WHERE id_cliente = p.id_cliente
)
ORDER BY p.id ASC;

-- 13 – Produtos que não foram comprados por clientes da cidade “São Paulo”
SELECT DISTINCT i.produto AS "Produtos não comprados em São Paulo"
FROM ItensPedido i
WHERE i.id_pedido IN (
    SELECT p.id
    FROM Pedido p
    JOIN Cliente c ON p.id_cliente = c.id
    WHERE c.cidade <> 'São Paulo'
)
AND i.produto NOT IN (
    SELECT i2.produto
    FROM ItensPedido i2
    JOIN Pedido p2 ON i2.id_pedido = p2.id
    JOIN Cliente c2 ON p2.id_cliente = c2.id
    WHERE c2.cidade = 'São Paulo'
);

-- 14. Clientes cujo maior pedido seja menor que o maior pedido geral
SELECT c.nome AS Cliente,
	MAX(p.total) AS "Maior Pedido"
FROM Cliente c
JOIN Pedido p ON p.id_cliente = c.id
GROUP BY c.nome
HAVING MAX(p.total) < (SELECT MAX(total) FROM Pedido)
ORDER BY MAX(p.total) DESC;

-- 15. Clientes cujo total de pedidos em um único mês seja maior que a média mensal de todos os clientes
SELECT c.nome AS Cliente,
    SUM(p.total) AS Total_Gasto_Junho_2025
FROM Cliente c
JOIN Pedido p ON p.id_cliente = c.id
WHERE p.data_pedido BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY c.nome
HAVING SUM(p.total) > (
    SELECT AVG(total) 
    FROM Pedido 
    WHERE data_pedido BETWEEN '2025-06-01' AND '2025-06-30'
);
