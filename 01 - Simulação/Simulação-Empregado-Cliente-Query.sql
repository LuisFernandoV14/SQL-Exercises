USE simulação;

-- 1. Retornar empregados que trabalham no departamento 5
SELECT * FROM Empregado
WHERE dnum = 5;

-- 2. Retornar empregados com salário maior que 3000,00
SELECT * FROM Empregado
WHERE salario > 3000.00;

-- 3. Retornar empregados que trabalham no departamento 5 e com salário maior que 3000,00
SELECT * FROM Empregado
WHERE dnum = 5 AND salario > 3000.00;

-- 4. Retornar os empregados que trabalham no departamento 5 e tˆem sal´ario maior que 3000,00 ou que trabalham no departamento 4 e tˆem salário maior que 2000,00
SELECT * FROM Empregado
WHERE (dnum = 5 AND salario > 3000.00) 
OR (dnum = 4 AND salario > 2000.00);

-- 5. Retorne o primeiro nome e o sal´ario de cada empregado
SELECT pnome, salario FROM Empregado;

-- 6. Retorne o primeiro nome e o sal´ario dos empregados que trabalham no departamento 5
SELECT pnome, salario FROM Empregado
WHERE dnum = 5;

-- 7. Retorne o RG de todos os empregados que trabalham no departamento 5 ou supervisionam diretamente um empregado que trabalha no departamento 5
SELECT e.RG FROM Empregado e
LEFT JOIN Empregado s ON s.supRG = e.RG
WHERE e.dnum = 5 OR s.dnum = 5;

-- 8. Retorne os primeiros nomes de empregados que s˜ao iguais a nomes de dependentes
SELECT pnome FROM Empregado e
JOIN Dependente d
WHERE e.pnome = d.dep_nome;

-- 9. Retorne todas as combina¸c˜oes de primeiro nome de empregados e nome de dependentes
SELECT e.pnome AS Empregado, d.dep_nome AS Dependente
FROM Empregado e
CROSS JOIN Dependente d;

-- 10. Retorne os nomes dos empregados e de seus respectivos dependentes
SELECT e.pnome AS Primeiro_Nome, e.unome AS Último_Nome, d.dep_nome AS Dependente
FROM Empregado e
INNER JOIN Dependente d ON e.RG = d.empRG;

-- 11. Retorne o nome do gerente de cada departamento
SELECT CONCAT(e.pnome, ' ', e.unome) AS Nome_Gerente, d.dnum AS Numero_Departamento
FROM Departamento d
INNER JOIN Empregado e ON d.gerRG = e.RG;

-- 12. 


