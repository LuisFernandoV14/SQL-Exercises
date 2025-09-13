-- Vou separar os arquivos em "Schema" (criação e modificação de tabelas), "Data" (inserção, deleção e etc) e "Queries" (consultas no banco de dados)

USE sistema_financeiro;

-- Primeiro, os endereços
INSERT INTO endereco (rua, numero, cidade, estado, cep)
VALUES 
('Av. Paulista', '1000', 'São Paulo', 'SP', '01310-100'),
('Rua das Flores', '250', 'Curitiba', 'PR', '80000-000'),
('Quixaba', '130', 'Xique Xique', 'BA', '75757-140');

-- Agências precisam de endereço
INSERT INTO agencia (nome_Agencia, endereco_Agencia)
VALUES 
('Agência Central SP', 1),
('Agência Curitiba Centro', 2);

-- Clientes (usando endereços já criados)
INSERT INTO cliente (nome, CPF, data_Nascimento, telefone, endereco)
VALUES
('Maria Silva', '12345678901', '1990-05-20', '11988887777', 1),
('João Souza', '98765432100', '1985-11-02', '41999998888', 2),
('Carlos Alberto', '34685412364', '1967-11-20', '74955471348', 3);

-- Dependentes (ligados aos clientes)
INSERT INTO dependente (nome, parentesco, data_Nascimento, id_Dependente)
VALUES
('Pedro Silva', 'Filho', '2015-04-10', 1),
('Ana Souza', 'Filha', '2010-09-25', 2);

-- Gerente (ligado a agência)
INSERT INTO gerente (id_Gerente, nome, CPF, telefone, id_Agencia)
VALUES
(1, 'Carlos Lima', '11223344556', '11977776666', 1);

-- Contas dos clientes
INSERT INTO conta (numero_Conta, saldo, data_Abertura, id_Cliente, tipo_Conta)
VALUES
('00012345', 1500.00, '2020-01-15', 1, 'corrente'), -- conta da Maria
('00067890', 2500.50, '2021-06-20', 2, 'poupança'), -- conta do João
('00021548', 750.00, '2000-12-31', 3, 'investimento'); -- conta do Carlos

-- Cartões (ligados às contas)
INSERT INTO cartao (numero_Cartao, validade, CVV, tipo_Cartao, id_Conta)
VALUES
('4111111111111111', '2027-12-31', '123', 'Crédito', 1),
('5500000000000004', '2026-05-31', '456', 'Débito', 2);

-- Especializações de conta:

-- Maria tem uma conta corrente
INSERT INTO corrente (id_Tipo, tarifa_mensal)
VALUES (1, 25.90);

-- João tem uma conta poupança
INSERT INTO poupança (id_Tipo, rendimento, data_Rendimento)
VALUES (2, 0.45, '2025-01-01');

-- Carlos tem um investimento
INSERT INTO investimento (id_Tipo, tipo_Investimento, valor_Aplicado)
VALUES (3, 'Tesouro Direto', 1000.00);
