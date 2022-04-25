/* Criação do usuário do PostgreSQL e fornecendo permissões */
CREATE ROLE joao WITH
	LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	REPLICATION
	CONNECTION LIMIT -1;

/* Criação do Banco de Dados */
CREATE DATABASE uvv
    WITH 
    OWNER = joao
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE uvv
    IS 'Tabela que armazena as tabelas criadas no pset.';

/* Criando o esquema do Banco de Dados e selecionando-o para o uso */ 
CREATE SCHEMA elmasri
    AUTHORIZATION joao;

ALTER USER joao
SET SEARCH_PATH TO elmasri, public;

/* Criação da tabela funcionario,tabela que armazena as informações dos funcionários. */

CREATE TABLE elmasri.funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(30),
                sexo CHAR(1),
                salario NUMERIC(10,2),
                cpf_supervisor CHAR(11),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT funcionario_pk PRIMARY KEY (cpf)
);

/* Adicionando comentários na tabela e nas tuplas da tabela funcionario */
COMMENT ON TABLE elmasri.funcionario IS 'Tabela que armazena as informações dos funcionários.';
COMMENT ON COLUMN elmasri.funcionario.cpf IS 'CPF do funcionário. Será a PK da tabela.';
COMMENT ON COLUMN elmasri.funcionario.primeiro_nome IS 'Primeiro nome do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.nome_meio IS 'Inicial do nome do meio.';
COMMENT ON COLUMN elmasri.funcionario.ultimo_nome IS 'Sobrenome do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.data_nascimento IS 'Data de nascimento do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.endereco IS 'Endereço do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.sexo IS 'Sexo do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.salario IS 'Salário do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.numero_departamento IS 'Número do departamento do funcionário.';

/* Criação da tabela dependente,tabela que armazena as informações dos dependentes dos funcionários. */
CREATE TABLE elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT dependente_pk PRIMARY KEY (cpf_funcionario, nome_dependente)
);

/* Adicionando comentários na tabela e nas tuplas da tabela dependente */
COMMENT ON TABLE elmasri.dependente IS 'Tabela que armazena as informações dos dependentes dos funcionários.';
COMMENT ON COLUMN elmasri.dependente.cpf_funcionario IS 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';
COMMENT ON COLUMN elmasri.dependente.nome_dependente IS 'Nome do dependente. Faz parte da PK desta tabela.';
COMMENT ON COLUMN elmasri.dependente.sexo IS 'Sexo do dependente.';
COMMENT ON COLUMN elmasri.dependente.data_nascimento IS 'Data de nascimento do dependente.';
COMMENT ON COLUMN elmasri.dependente.parentesco IS 'Descrição do parentesco do dependente com o funcionário.';

/* Criação da tabela departamento,tabela que armazena as informaçoẽs dos departamentos. */
CREATE TABLE elmasri.departamento (
                numero_departamento INTEGER NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio DATE,
                CONSTRAINT departamento_pk PRIMARY KEY (numero_departamento)
);

/* Adicionando comentários na tabela e nas tuplas da tabela departamento */
COMMENT ON TABLE elmasri.departamento IS 'Tabela que armazena as informaçoẽs dos departamentos.';
COMMENT ON COLUMN elmasri.departamento.numero_departamento IS 'Número do departamento. É a PK desta tabela.';
COMMENT ON COLUMN elmasri.departamento.nome_departamento IS 'Nome do departamento. Deve ser único.';
COMMENT ON COLUMN elmasri.departamento.cpf_gerente IS 'CPF do gerente do departamento. É uma FK para a tabela funcionários.';
COMMENT ON COLUMN elmasri.departamento.data_inicio IS 'Data do início do gerente no departamento.';

/* Criando a chave única da tabela departamento */
CREATE UNIQUE INDEX departamento_idx
 ON elmasri.departamento
 ( nome_departamento );

/* Criação da tabela projeto, tabela que armazena as informaçoẽs sobre os projetos dos departamentos. */
CREATE TABLE elmasri.projeto (
                numero_projeto INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT projeto_pk PRIMARY KEY (numero_projeto)
);

/* Adicionando comentários na tabela e nas tuplas da tabela projeto */
COMMENT ON TABLE elmasri.projeto IS 'Tabela que armazena as informações sobre os projetos dos departamentos.';
COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Número do projeto. É a PK desta tabela.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Nome do projeto. Deve ser único.';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Localização do projeto.';

/* Criando as chaves únicas da tabela projeto */
CREATE INDEX projeto_idx
 ON elmasri.projeto
 ( nome_projeto );

CREATE UNIQUE INDEX projeto_idx1
 ON elmasri.projeto
 ( nome_projeto );

/* Criando a tabela trabalha_em, tabela para armazenar quais funcionários trabalham em quais projetos. */
CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1),
                CONSTRAINT trabalha_em_pk PRIMARY KEY (cpf_funcionario, numero_projeto)
);

/* Adicionando comentários na tabela e nas tuplas da tabela trabalha_em */
COMMENT ON TABLE elmasri.trabalha_em IS 'Tabela para armazenar quais funcionários trabalham em quais projetos.';
COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario IS 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';
COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto IS 'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.';
COMMENT ON COLUMN elmasri.trabalha_em.horas IS 'Horas trabalhadas pelo funcionário neste projeto.';

/* Criação da tabela localizacoes_departamento, tabela que armazena as possíveis localizações dos departamentos. */
CREATE TABLE elmasri.localizacoes_departamento (
                numero_departamento INTEGER NOT NULL,
                local VARCHAR(15) NOT NULL,
                CONSTRAINT localizacoes_departamento_pk PRIMARY KEY (numero_departamento, local)
);

/* Adicionando comentários na tabela e nas tuplas da tabela localizacoes_departamento */
COMMENT ON TABLE elmasri.localizacoes_departamento IS 'Tabela que armazena as possíveis localizações dos departamentos.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento IS 'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.local IS 'Localização do departamento. Faz parte da PK desta tabela.';


/* Inserindo os dados da tabela departamento */
INSERT INTO elmasri.departamento(
	numero_departamento, nome_departamento, cpf_gerente, data_inicio)
	VALUES (5, 'Pesquisa', 33344555587, '22-05-1988');
INSERT INTO elmasri.departamento(
	numero_departamento, nome_departamento, cpf_gerente, data_inicio)
	VALUES (4, 'Administração', 98765432168 ,'01-01-1995');
INSERT INTO elmasri.departamento(
	numero_departamento, nome_departamento, cpf_gerente, data_inicio)
	VALUES (1, 'Matriz', 88866555576, '19-06-1981');	
	

/* Inserindo os dados da tabela dependente */
INSERT INTO elmasri.dependente(
	cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES (33344555587, 'Alicia', 'F', '05-04-1986', 'Filha');
INSERT INTO elmasri.dependente(
	cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES (33344555587, 'Tiago', 'M', '25-10-1983', 'Filho');
INSERT INTO elmasri.dependente(
	cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES (33344555587, 'Janaína', 'F', '03-05-1958' , 'Esposa');
INSERT INTO elmasri.dependente(
	cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES (98765432168, 'Antonio', 'M', '28-02-1942' , 'Marido');
INSERT INTO elmasri.dependente(
	cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES (12345678966, 'Michael', 'M', '04-01-1988' , 'Filho');
INSERT INTO elmasri.dependente(
	cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES (12345678966, 'Alicia', 'F', '30-12-1988' , 'Filha');
INSERT INTO elmasri.dependente(
	cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
	VALUES (12345678966, 'Elizabeth', 'F', '05-05-1967' , 'Esposa');
	

/* Inserindo os dados da tabela projeto */
INSERT INTO elmasri.projeto(
	numero_projeto, nome_projeto, local_projeto, numero_departamento)
	VALUES (1, 'ProdutoX', 'SantoAndré', 5 );
INSERT INTO elmasri.projeto(
	numero_projeto, nome_projeto, local_projeto, numero_departamento)
	VALUES (2, 'ProdutoY', 'Itu', 5 );
INSERT INTO elmasri.projeto(
	numero_projeto, nome_projeto, local_projeto, numero_departamento)
	VALUES (3, 'ProdutoZ', 'São_Paulo', 5 );
INSERT INTO elmasri.projeto(
	numero_projeto, nome_projeto, local_projeto, numero_departamento)
	VALUES (10, 'Informatização', 'Mauá', 4 );
INSERT INTO elmasri.projeto(
	numero_projeto, nome_projeto, local_projeto, numero_departamento)
	VALUES (20, 'Reorganização','São_Paulo', 1 );
INSERT INTO elmasri.projeto(
	numero_projeto, nome_projeto, local_projeto, numero_departamento)
	VALUES (30, 'Novosbeneficios', 'Mauá', 4 );	

/* Inserindo os dados da tabela localizacoes_departamento */
INSERT INTO elmasri.localizacoes_departamento(
	numero_departamento, local)
	VALUES (1, 'São Paulo');
INSERT INTO elmasri.localizacoes_departamento(
	numero_departamento, local)
	VALUES (4, 'Mauá');
INSERT INTO elmasri.localizacoes_departamento(
	numero_departamento, local)
	VALUES (5 , 'SantoAndré');
INSERT INTO elmasri.localizacoes_departamento(
	numero_departamento, local)
	VALUES (5, 'Itu');
INSERT INTO elmasri.localizacoes_departamento(
	numero_departamento, local)
	VALUES (5, 'São Paulo');
	
/* Inserindo os dados da tabela funcionario */
INSERT INTO elmasri.funcionario(
	cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
	VALUES (88866555576, 'Jorge' , 'E' , 'Brito' , ' 10-11-1937' ,'R.do Horto,35,São Paulo,SP','M',55000.00, NULL, 1);		
INSERT INTO elmasri.funcionario(
	cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
	VALUES (33344555587, 'Fernando' , 'T' , 'Wong' , '08-12-1955' ,'R. da Lapa,34,São Paulo,SP','M', 40000.00, 88866555576, 5);
INSERT INTO elmasri.funcionario(
	cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
	VALUES (66688444476, 'Ronaldo' , 'K' , 'Lima' , '15-09-1962' ,'Rua Rebouças,65,Piracicaba, SP','M',38000.00, 33344555587, 5);
INSERT INTO elmasri.funcionario(
	cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
	VALUES (98765432168, 'Jennifer' , 'S' , 'Souza' , '20-06-1941' ,'Av.Art.deLima,54,SantoAndré,SP','F',43000.00, 88866555576, 4);
INSERT INTO elmasri.funcionario(
	cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
	VALUES (12345678966, 'joão' , 'B' , 'Silva' , '09-01-1965' ,'R. das Flores,751.São Paulo,SP','M', 30000.00, 33344555587, 5);
INSERT INTO elmasri.funcionario(
	cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
	VALUES (99988777767, 'Alice' , 'J' , 'Zelaya' , '19-01-1968' ,'R. Souza Lima,35,Curitiba,PR','F',25000.00, 98765432168, 4);
INSERT INTO elmasri.funcionario(
	cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
	VALUES (45345345376, 'Joice' , 'A' , 'Leite' , '31-07-1972' ,'Av. Lucas Obes,74,São Paulo,SP','F',25000.00, 33344555587, 5);
INSERT INTO elmasri.funcionario(
	cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
	VALUES (98798798733, 'André' , 'V' , 'Pereira' , '29-03-1969' ,'RuaTimbira,35,São Paulo,SP','M',25000.00, 98765432168, 4);	

/* Inserindo os dados da tabela trabalha_em */
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (12345678966, 1, 32.5 );
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (12345678966, 2, 7.5);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (66688444476 , 3, 40.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (45345345376, 1, 20.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (45345345376, 2, 20.00);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (33344555587, 2, 10.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (33344555587, 3, 10.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (33344555587, 10, 10.0);	
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (33344555587, 20, 10.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (99988777767, 30, 30.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (99988777767, 10, 10.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (98798798733, 10, 35.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (98798798733, 30, 5.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (98765432168, 30, 20.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (98765432168, 20, 15.0);
INSERT INTO elmasri.trabalha_em(
	cpf_funcionario, numero_projeto, horas)
	VALUES (88866555576, 10, null);	

/* Criando uma chave estrangeira da tabela departamento, em que a tupla cpf_gerente está referenciando a tupla cpf da tabela funcionario */
ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Criando uma chave estrangeira da tabela dependente, em que a tupla cpf_funcionario está referenciando a tupla cpf da tabela funcionario */
ALTER TABLE elmasri.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Criando uma chave estrangeira da tabela trabalha_em, em que a tupla cpf_funcionario está referenciando a tupla cpf da tabela funcionario */
ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Criando uma chave estrangeira da tabela funcionario, em que a tupla cpf_supervisor está referenciando a tupla cpf da tabela funcionario */
ALTER TABLE elmasri.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Criando uma chave estrangeira da tabela localizacoes_departamento, em que a tupla numero_departamento está referenciando a tupla numero_departamento da tabela departamento */
ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Criando uma chave estrangeira da tabela projeto, em que a tupla numero_departamento está referenciando a tupla numero_departamento da tabela departamento */
ALTER TABLE elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Criando uma chave estrangeira da tabela funcionario, em que a tupla numero_departamento está referenciando a tupla numero_departamento da tabela departamento */
ALTER TABLE elmasri.funcionario ADD CONSTRAINT departamento_funcionario_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Criando uma chave estrangeira da tabela trabalha_em, em que a tupla numero_projeto está referenciando a tupla numero_projeto da tabela projeto */
ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;