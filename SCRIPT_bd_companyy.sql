-- Criar o esquema se não existir e usá-lo
CREATE SCHEMA IF NOT EXISTS azure_company;
USE azure_company;

-- Selecionar todas as restrições de tabela no esquema 'azure_company'
SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'azure_company';

-- Restrição atribuída a um domínio (comentado porque não está em uso)

-- Criar tabela de funcionários
CREATE TABLE IF NOT EXISTS employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR,
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL, 
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR,
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL,
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.0),
    CONSTRAINT pk_employee PRIMARY KEY (Ssn),
    CONSTRAINT fk_employee FOREIGN KEY (Super_ssn) REFERENCES employee(Ssn) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

-- Modificar a tabela de funcionários
ALTER TABLE employee MODIFY Dno INT NOT NULL DEFAULT 1;

-- Descrever a estrutura da tabela de funcionários
DESC employee;

-- Criar tabela de departamentos
CREATE TABLE IF NOT EXISTS department (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE, 
    Dept_create_date DATE,
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE (Dname),
    CONSTRAINT fk_dept FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn) ON UPDATE CASCADE
);

-- Modificar uma restrição de tabela (excluir e adicionar)

-- Descrever a estrutura da tabela de departamentos
DESC department;

-- Criar tabela de localizações do departamento
CREATE TABLE IF NOT EXISTS dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES department (Dnumber)
);

-- Alterar a tabela de localizações do departamento (excluir e adicionar restrição)
ALTER TABLE dept_locations DROP FOREIGN KEY fk_dept_locations;

ALTER TABLE dept_locations 
    ADD CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES department(Dnumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- Criar tabela de projetos
CREATE TABLE IF NOT EXISTS project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname),
    CONSTRAINT fk_project FOREIGN KEY (Dnum) REFERENCES department(Dnumber)
);

-- Criar tabela de trabalhos realizados
CREATE TABLE IF NOT EXISTS works_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL,
    PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_employee_works_on FOREIGN KEY (Essn) REFERENCES employee(Ssn),
    CONSTRAINT fk_project_works_on FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);

-- Descartar e recriar a tabela de dependentes
DROP TABLE IF EXISTS dependent;
CREATE TABLE IF NOT EXISTS dependent (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR,
    Bdate DATE,
    Relationship VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);

-- Mostrar todas as tabelas no banco de dados
SHOW TABLES;

-- Descrever a estrutura da tabela de dependentes
DESC dependent;
