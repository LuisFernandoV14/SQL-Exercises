-- Index
-- --------------------------------------------------------------
create index idx_nome on Pessoa (nome);
-- --------------------------------------------------------------
create index idx_endereco on Pessoa (end_cidade, end_bairro);
-- --------------------------------------------------------------
create index idx_aluno_fk on Aluno (pessoa_id);
create index idx_professor_fk on Professor (pessoa_id);
-- --------------------------------------------------------------
create unique index idx_materia_unica on Materia (aluno_mat, curso_cod);
-- --------------------------------------------------------------
drop index idx_nome on Pessoa;
drop index idx_endereco on Pessoa;
-- --------------------------------------------------------------
-- Views
-- --------------------------------------------------------------
CREATE OR REPLACE VIEW vw_matricula_status_aluno AS
    SELECT 
        matricula, status
    FROM
        aluno;
-- --------------------------------------------------------------
CREATE OR REPLACE VIEW vw_matricula_status_aluno AS
    SELECT 
        matricula, status
    FROM
        aluno
    WHERE
        status = 'ativo';
-- --------------------------------------------------------------
CREATE OR REPLACE VIEW vw_endereco_completo AS
    SELECT 
        end_logradouro AS Logradouro,
        end_numero AS Numero,
        end_bairro AS Bairro,
        end_cidade AS Cidade,
        end_uf_sigla AS UF,
        end_complemento AS Complemento
    FROM
        Pessoa;
-- --------------------------------------------------------------
CREATE OR REPLACE VIEW vw_alunos_nomes AS
    SELECT 
        p.nome AS Nome,
        a.status AS Status,
        a.dt_matricula AS 'Data matrícula'
    FROM
        Pessoa p
            JOIN
        Aluno a ON p.id = a.pessoa_id;
-- --------------------------------------------------------------
CREATE OR REPLACE VIEW vw_professores_nomes AS
    SELECT 
        pe.nome AS Nome,
        pr.matricula AS Matricula,
        pr.ativo AS Status
    FROM
        Pessoa pe
            JOIN
        Professor pr ON pe.id = pr.pessoa_id;
-- --------------------------------------------------------------
CREATE OR REPLACE VIEW vw_alunos_cursos AS
    SELECT 
        p.nome AS Nome,
        a.matricula AS Matricula,
        c.curso_cod AS 'Código do Curso',
        c.dt_inicio AS 'Data de Início'
    FROM
        Pessoa p
            JOIN
        Aluno a ON p.id = a.pessoa_id
            JOIN
        Aluno_Curso c ON a.matricula = c.aluno_mat;
-- --------------------------------------------------------------
create or replace view vw_turmas_completas as
select t.codigo as "Código de Turma",
	c.nome as "Curso",
	pe.nome as "Professor da turma",
    t.ano_semestre as Semestre
from Turma t 
join Curso c on t.curso_cod = c.codigo
join Professor pr on t.professor_mat = pr.matricula
join Pessoa pe on pe.id = pr.pessoa_id;
-- --------------------------------------------------------------
create or replace view vw_nmr_turmas_professor as
select pr.matricula as "Matricula do Professor",
	pe.nome as "Nome do Professor",
	COUNT(t.codigo) as "Numero de Turmas"
from Professor pr 
join Pessoa pe on pr.pessoa_id = pe.id  
join Turma t on pr.matricula = t.professor_mat
group by pr.matricula;  
-- --------------------------------------------------------------
create or replace view vw_nmr_alunos_por_cidades as
select p.end_cidade as Cidade,
	COUNT(a.matricula) as "Número de alunos"
from Pessoa p
join Aluno a on p.id = a.pessoa_id
group by end_cidade;
-- --------------------------------------------------------------
-- Triggers
-- --------------------------------------------------------------
DELIMITER $$
create trigger after_insert_aluno
after insert on Aluno 
for each row
begin
	insert into aluno_log (aluno_id, acao, data) values (
		(select p.id from pessoa p where new.pessoa_id = p.id), 
		"INSERT", 
		curdate()
    ) ;
end$$
DELIMITER ;

insert into aluno (matricula, status, dt_matricula, pessoa_id) values ('14C2B0BH', 'ativo', curdate(), 2036); 
-- --------------------------------------------------------------
DELIMITER $$
create trigger tr_aluno_formado
after update on Aluno
for each row
begin
	if new.status = 'formado' and old.status <> 'formado' then
		update aluno_curso 
        set dt_fim = curdate() 
        where aluno_mat = new.matricula;
    end if;
end$$
DELIMITER ;

update Aluno set status = 'formado' where matricula = '01DQV1BK47';
-- --------------------------------------------------------------
DELIMITER $$
create trigger tr_impedir_prof_inativo
before insert on Turma
for each row
begin
	if new.professor_mat in (select p.matricula from Professor p where ativo = FALSE) then
		signal sqlstate '45000' 
			set MESSAGE_TEXT = "Professores inativos não podem ser atribuídos a uma turma.";
    end if;
end$$ 
DELIMITER ;

insert into Turma (codigo, ano_semestre, curso_cod, professor_mat) values ('T9MVIEI', '2025-1', 'COA6NS', 'AB0FLJSÇ');
-- --------------------------------------------------------------
DELIMITER $$
create trigger tr_impedir_avalicao_fora_de_turma
before insert on Avaliacao
for each row
begin
	if not exists ( select * from Aluno_Turma where id = new.aluno_turma_id) then 
		signal sqlstate '45000'
			set MESSAGE_TEXT = "A turma da avaliação não existe.";
	end if;
end$$
DELIMITER ;

insert into Avaliacao (aluno_turma_id, tipo_prova, nota) values (65416, 'P3', 30.5);
-- --------------------------------------------------------------
DELIMITER $$
create trigger tr_impedir_professor_duas_turmas_mesmo_semestre
before insert on Turma
for each row
begin
	if exists (
		select 1
        from Turma t 
        where t.professor_mat = new.professor_mat and t.ano_semestre = new.ano_semestre
        ) then 
			signal sqlstate '45000' 
				set message_text = "Um professor não pode ter duas turmas no mesmo semestre.";
    end if;
end$$
DELIMITER ;
-- --------------------------------------------------------------
DELIMITER $$
create trigger tr_impedir_aluno_com_prova_de_expulsao
before update on Aluno
for each row
begin
	if exists (
		select 1
        from Aluno
        join Aluno_Turma a on a.aluno_mat = old.matricula
        join Avaliacao v on v.aluno_turma_id = a.id
        ) and new.status = 'expulso' then
			signal sqlstate '45000'
				set MESSAGE_TEXT = "Um aluno não pode ser expulso se tiver uma avaliação pendente";
    end if;
end$$
DELIMITER ;

update aluno set status = 'expulso' where matricula = 'HYF7RK7P39';
-- --------------------------------------------------------------
DELIMITER $$
create trigger tr_impedir_troca_de_curso
before update on Turma
for each row
begin
	if old.curso_cod <> new.curso_cod and exists (
		select 1
        from Turma
        join Aluno_Turma on turma_cod = old.codigo
        ) then
			signal sqlstate '45000'
				set message_text = "Não é possível trocar o curso de uma turma com aluno matriculado.";
    end if;
end$$
DELIMITER ;
-- --------------------------------------------------------------
-- Functions
-- --------------------------------------------------------------
DELIMITER $$
create function calcularIdade (nasc DATE)
returns int 
deterministic
begin
	return TIMESTAMPDIFF(year, nasc, CURDATE());
end$$
DELIMITER ;

select calcularIdade(data_nascimento) as Idade from Pessoa;
-- --------------------------------------------------------------
DELIMITER $$
create function formatarNome (nome VARCHAR(255))
returns varchar(255)
deterministic
begin
	return concat("Nome da Pessoa: ", nome);
end $$
DELIMITER ;

select formatarNome(nome) as autoexplicativo from Pessoa;
-- --------------------------------------------------------------
DELIMITER $$
create function isAtivo (status VARCHAR(40))
returns tinyint
deterministic
begin
	if status = 'ativo' then
		return 1;
    else
		return 0;
    end if;
end $$
DELIMITER ;

select isAtivo(status) as "Ativo?" from Aluno;
-- --------------------------------------------------------------
DELIMITER $$
create function quantosCursosEstaMatriculado (matricula varchar(10))
returns int
not deterministic
reads sql data
begin
	declare qnt int;
    
    select count(*) 
    into qnt
    from aluno_curso c
    where c.aluno_mat = matricula;
    
    return qnt;
end $$
DELIMITER ;

select quantosCursosEstaMatriculado(matricula) from Aluno;
-- --------------------------------------------------------------
DELIMITER $$
create function mediaTurma ( id varchar(12))
returns decimal(3,1)
not deterministic 
reads sql data
begin
	return (select avg(ava.nota) from Avaliacao ava
    join aluno_turma alt on alt.id = ava.aluno_turma_id
    join turma tur on tur.codigo = alt.turma_cod
    where tur.codigo = id);
end $$
DELIMITER ;

drop function mediaTurma;
select mediaTurma(codigo) from Turma;
-- --------------------------------------------------------------
-- Procedures
-- --------------------------------------------------------------
DELIMITER $$
create procedure exibirAluno (in matricula varchar(10))
begin
	select * from aluno 
    join pessoa on pessoa.id = aluno.pessoa_id
    where aluno.matricula = matricula;
end$$
DELIMITER ;

call exibirAluno('01DQV1BK47');
-- --------------------------------------------------------------
DELIMITER $$
create procedure exibirAlunoEmCurso (in codigo varchar(10))
begin
	select * from aluno
    join aluno_curso on aluno.matricula = aluno_curso.aluno_mat
    join curso on curso.codigo = aluno_curso.curso_cod
    where curso.codigo = codigo;
end $$
DELIMITER ;

call exibirAlunoEmCurso('CBVAW2');
-- --------------------------------------------------------------
DELIMITER $$
create procedure contarProfessoresAtivos (out qnt int)
begin
	select count(*) into qnt from Professor p where p.ativo = TRUE;
end $$
DELIMITER ;


call contarProfessoresAtivos(@t);
select @t as "Professores ativos";
-- --------------------------------------------------------------
DELIMITER $$
create procedure incrementarNumero (inout x int)
begin
	set x = x + 1;
end $$
DELIMITER ;

set @x = 1;
call incrementarNumero(@x);
SELECT @x AS Numero;
-- --------------------------------------------------------------
    