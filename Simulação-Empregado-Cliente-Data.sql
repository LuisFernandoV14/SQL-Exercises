USE simulação;

-- Simula a inserção de 4 empregados 
INSERT INTO Empregado (RG, sexo, dt_nasc, pnome, unome, rua, cidade, estado, salario, supRG) VALUES
('1001', 'Masculino', '1985-04-12', 'Carlos', 'Silva', 'Rua A, 123', 'São Paulo', 'SP', 3500.00, NULL),
('1002', 'Feminino', '1990-09-22', 'Mariana', 'Oliveira', 'Av. Central, 456', 'Rio de Janeiro', 'RJ', 2800.00, '1001'),
('1003', 'Não Definido', '1995-01-15', 'João', 'Souza', 'Rua das Flores, 789', 'Belo Horizonte', 'MG', 2500.00, NULL),
('1004', 'Feminino', '1988-07-30', 'Ana', 'Costa', 'Rua das Palmeiras, 321', 'Curitiba', 'PR', 2200.00, '1003');

-- Simula a criação de 2 depatamentos
INSERT INTO Departamento (dnum, dnome, dt_inicio, gerRG) VALUES
('5', 'Sudoeste', '1990-04-15',  '1001'),
('4', 'Centroeste', '1990-05-20',  '1001');

-- Aloca os empregados nos departamentos
UPDATE Empregado
SET dnum = CASE 
				WHEN RG = '1001' THEN 5
				WHEN RG = '1002' THEN 5
				WHEN RG = '1003' THEN 4
				WHEN RG = '1004' THEN 4
           END 
WHERE RG IN ('1001', '1002', '1003', '1004');

SELECT DISTINCT * FROM EMPREGADO;