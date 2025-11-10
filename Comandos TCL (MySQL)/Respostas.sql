-- -------------------------------------------------------------------
-- ----------------------- ATIVIDADE ---------------------------------
-- -------------------------------------------------------------------

-- Preparação:

-- - execute o script "sala-ddl.sql"
-- - após o banco criado, execute o script "sala-dml.sql"

-- Responda as questões abaixo, quando for discursiva, escreva em comentários

-- 1) O que você achou da forma como o banco foi populado (arquivo sala-dml.sql)?
-- R: Acredito com certeza que essa é uma das maneiras de popular um banco de dados, não a mais eficiente e nem de perto a mais segura. Usar um INSERT por linha sobrecarrega o sistema de transação, deixando o programa mais lento e caso aconteça algum erro, a possibilidade de reverter com ROLLBACK é nula.
--    Há formas melhores de ter feito esse preenchimento? Como?
-- R: Sim, a maneira mais básica de meplhorar esse preenchimento seria separar os dados inseridos da mesma tabela por vírgulas e não ter um INSERT para cada tupla.
--      Como melhorar esse script usando comandos TCL?
-- R: Para melhorar esse script com TCL precisaríamos apenas de alguns comandos. STAR TRANSACTION para padronizar a transação, os inserts, de preferência separados por vírgulas, e no final COMMIT para salvar as alterções feitas nessa transação, ou ROLLBACK caso não queira salvar os dados
--      Obs.: Essa questão é discursiva, não envie códigos nela.

-- 2) É mais comum buscar pessoas por documentos, crie um índice para CPF na tabela de Pessoa. (código de criação do índice)

CREATE INDEX idx_pessoa_cpf ON Pessoa(CPF);

-- 3) Em Avaliacao, há um campo TEXT, o campo ocorrencia, que contém ocorrências ocorridas durante as avaliações
-- a)   crie um FULLTEXT INDEX para esse campo, inclua o tipo_prova no índiceCREATE FULLTEXT INDEX idx_ocorrencia_prova ON Avaliacao(ocorrencia, tipo_prova);

CREATE FULLTEXT INDEX idx_ocorrencia ON Avaliacao(ocorrencia);

-- b)   faça uma busca por suspeitas de cola na P3 utilizando apenas o índice

SELECT * FROM Avaliacao
WHERE MATCH(ocorrencia) AGAINST ('+cola +P3' IN BOOLEAN MODE);

-- 4) Quais os benefícios e cuidados com a criação desses índices?

-- R: Entre os benefícios podemos começar com o mais óbvio, a velocidade de leitura é bem mais rápido ao usar índices, o banco vai direto ao ponto em vez de ler a tabela inteira. Além disso podemos citar também a possibilidade de fazer buscas em texto, buscas complexas em linguagem natural em campos TEXT.
-- Já sobre os cuidados podemos citar a lentidão na escrita, o maior uso de espaço e ressaltar a cuidado ao cria índices para que não sejam criados índices desnecessários.

-- 5) Crie uma VIEW que gere uma tabela virtual com os estudantes que estão regularmente matriculados e que não estão sob medidas disciplinares formais,
-- mas possuem registros de ocorrências durante avaliações.

CREATE VIEW Vw_Alunos_Com_Ocorrencias AS
SELECT 
    a.matricula, 
    p.nome, 
    p.CPF, 
    a.status
FROM Aluno a
JOIN Pessoa p ON a.pessoa_id = p.ID
JOIN Aluno_Turma at ON a.matricula = at.aluno_mat
JOIN Avaliacao av ON at.ID = av.aluno_turma_id
WHERE 
    a.status IN ('ativo', 'pendenteDocumentacao') 
    AND av.ocorrencia IS NOT NULL
-- Agrupa para mostrar cada aluno apenas uma vez
GROUP BY a.matricula, p.nome, p.CPF, a.status;

-- 6) Crie duas VIEWs, uma para apresentar os dados do professor (tabelas Professor e Pessoa) e outra para apresentar os dados dos alunos (tabelas Pessoa e Aluno).

CREATE VIEW Vw_Professores AS
SELECT 
    p.ID AS pessoa_id,
    p.nome,
    p.CPF,
    p.data_nascimento,
    p.end_cidade,
    prof.matricula,
    prof.ativo
FROM Pessoa p
JOIN Professor prof ON p.ID = prof.pessoa_id;

CREATE VIEW Vw_Alunos AS
SELECT 
    p.ID AS pessoa_id,
    p.nome,
    p.CPF,
    p.data_nascimento,
    p.end_cidade,
    a.matricula,
    a.status,
    a.dt_matricula
FROM Pessoa p
JOIN Aluno a ON p.ID = a.pessoa_id;


-- 7) Crie uma ROLE Secretaria, que terá permissão de acesso a todo o banco, mas não poderá excluir nenhum dado.

CREATE ROLE 'Secretaria';

GRANT SELECT, INSERT, UPDATE ON SalaDeAula.* TO 'Secretaria';

-- 8) Crie um usuário Maria, Maria é secretária acadêmica, atribua os acesso de Secretaria a Maria.

CREATE USER 'Maria'@'localhost' IDENTIFIED BY '000000';

GRANT 'Secretaria' TO 'Maria'@'localhost';

SET DEFAULT ROLE 'Secretaria' TO 'Maria'@'localhost';

-- 9) Crie uma TRIGGER que zere a nota de uma avaliação caso seja inserida com uma ocorrência que justifique isso.

DELIMITER $$
CREATE TRIGGER Trg_Avaliacao_Insert_Ocorrencia
BEFORE INSERT ON Avaliacao
FOR EACH ROW
BEGIN
    IF NEW.ocorrencia IS NOT NULL AND NEW.ocorrencia LIKE '%cola%' THEN
        SET NEW.nota = 0.0;
    END IF;
END$$
DELIMITER ;

-- 10) Crie uma TRIGGER que zere a nota de uma avaliação caso seja atualizada adicionando uma ocorrência que justifique isso.

DELIMITER $$
CREATE TRIGGER Trg_Avaliacao_Update_Ocorrencia
BEFORE UPDATE ON Avaliacao
FOR EACH ROW
BEGIN
    IF (NEW.ocorrencia IS NOT NULL AND NEW.ocorrencia LIKE '%cola%') AND NEW.nota > 0.0 THEN
        SET NEW.nota = 0.0;
    END IF;
END$$
DELIMITER ;

-- 11) Crie uma (ou mais) FUNCTION que calcule a nota final por disciplina e aluno.

DELIMITER $$
CREATE FUNCTION Fn_Calcula_Nota_Final(p_aluno_turma_id INT)
RETURNS DECIMAL(3,1)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_media DECIMAL(3,1);

    SELECT AVG(nota) INTO v_media
    FROM Avaliacao
    WHERE aluno_turma_id = p_aluno_turma_id
      AND tipo_prova IN ('P1', 'P2', 'P3', 'P4', 'P5');

    RETURN IFNULL(v_media, 0.0);
END$$
DELIMITER ;

-- 12) Crie uma PROCEDURE que, caso o aluno tenha 3 ou mais ocorrências, deverá ser suspenso, caso esteja suspenso e tenha 9 ou mais ocorrências, expulso.

DELIMITER $$
CREATE PROCEDURE Sp_Verifica_Status_Disciplinar(IN p_aluno_mat VARCHAR(10))
BEGIN
    DECLARE v_total_ocorrencias INT DEFAULT 0;
    DECLARE v_status_atual ENUM(
        'ativo', 'inativo', 'formado', 'suspenso', 'expulso', 
        'transferido', 'pendenteDocumentacao', 'cancelado'
    );

    -- 1. Pega o status atual do aluno
    SELECT status INTO v_status_atual
    FROM Aluno 
    WHERE matricula = p_aluno_mat;

    -- 2. Conta o total de ocorrências do aluno
    SELECT COUNT(av.ID) INTO v_total_ocorrencias
    FROM Aluno_Turma at
    JOIN Avaliacao av ON at.ID = av.aluno_turma_id
    WHERE at.aluno_mat = p_aluno_mat
      AND av.ocorrencia IS NOT NULL;

    -- 3. Aplica a lógica de suspensão/expulsão
    IF v_status_atual = 'suspenso' AND v_total_ocorrencias >= 9 THEN
        UPDATE Aluno SET status = 'expulso' WHERE matricula = p_aluno_mat;
        
    ELSEIF v_status_atual = 'ativo' AND v_total_ocorrencias >= 3 THEN
        UPDATE Aluno SET status = 'suspenso' WHERE matricula = p_aluno_mat;
        
    END IF;

END$$
DELIMITER ;

