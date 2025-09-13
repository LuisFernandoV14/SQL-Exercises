CREATE DATABASE IF NOT EXISTS simulação;
USE simulação;

CREATE TABLE Empregado (
	RG DECIMAL(7, 0) PRIMARY KEY,
    sexo VARCHAR(15),
    dt_nasc DATE,
    pnome VARCHAR(25),
    unome VARCHAR(25),
    rua VARCHAR(30),
    cidade VARCHAR(20),
    estado VARCHAR(20),
    salario DECIMAL(15, 2),
    supRG DECIMAL(7,0),
    dnum INT,
    
    CONSTRAINT fk_RGEmpregado FOREIGN KEY (supRG) 
		REFERENCES Empregado (RG)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Departamento (
    dnum INT PRIMARY KEY,
    dnome VARCHAR(50),
    dt_inicio DATE,
    gerRG DECIMAL(7, 0),
    
    CONSTRAINT fk_EmpregadoDepartamento FOREIGN KEY (gerRG)
        REFERENCES Empregado (RG)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

ALTER TABLE Empregado 
	ADD CONSTRAINT fk_DepartamentoEmpregado FOREIGN KEY (dnum)
			REFERENCES Departamento (dnum)
			ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE TABLE Projeto (
	pnum INT AUTO_INCREMENT PRIMARY KEY,
    pnome VARCHAR(255),
    localização VARCHAR(255),
    dnum INT,
    
    CONSTRAINT fk_DepartamentoProjeto FOREIGN KEY (dnum)
		REFERENCES Departamento (dnum)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Dependente (
	dep_nome VARCHAR(25),
    dep_sexo VARCHAR(15),
    dep_dt_nasc DATE,
    empRG DECIMAL(7,0),
    
    CONSTRAINT fk_DependenteEmpregado FOREIGN KEY (empRG)
		REFERENCES Empregado (RG)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Trabalha_em (
	RG DECIMAL(7,0),
    pnum INT,
    
    CONSTRAINT fk_EmpregadoProjeto FOREIGN KEY (RG)
		REFERENCES Empregado (RG)
        ON UPDATE CASCADE ON DELETE RESTRICT,
        
	CONSTRAINT fk_ProjetoAtual FOREIGN KEY (pnum)
		REFERENCES Projeto (pnum)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Localizacao (
	dnum INT, 
    
    CONSTRAINT fk_LocalizacaoDepartamento FOREIGN KEY (dnum)
		REFERENCES Departamento (dnum)
        ON UPDATE CASCADE ON DELETE CASCADE
);
