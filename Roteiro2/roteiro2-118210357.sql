CREATE TABLE tarefas(
    contador_tarefa BIGINT,
    tarefa TEXT,
    cpf CHAR(11),
    algoQueNSei SMALLINT,
    naoSeiAinda CHAR(1),
    CONSTRAINT status_valid_chk CHECK (naoSeiAinda = 'F' OR naoSeiAinda = 'A' OR naoSeiAinda = 'R')
);

-- 1
INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F');
INSERT INTO tarefas VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');
INSERT INTO tarefas VALUES (null, null, null, null, null);
INSERT INTO tarefas VALUES (2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');
INSERT INTO tarefas VALUES (2147483643, 'limpar chão do corredor superior', '98765432111', 0, 'FF');
-- 2
INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');
-- 3
INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal', '32322525199', 32768, 'A');
INSERT INTO tarefas VALUES (2147483650, 'limpar janelas da entrada principal', '32333233288', 32769, 'A');
INSERT INTO tarefas VALUES (2147483651, 'limpar portas 1o andar', '32323232911', 32767, 'A');
INSERT INTO tarefas VALUES (2147483652, 'limpar portas 2o andar', '32323232911', 32766, 'A');
-- 4
ALTER TABLE tarefas ALTER COLUMN contador_tarefa SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN tarefa SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN algoQueNSei SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN naoSeiAinda SET NOT NULL;
-- renomeando
ALTER TABLE tarefas RENAME COLUMN contador_tarefa TO id;
ALTER TABLE tarefas RENAME COLUMN tarefa TO descricao;
ALTER TABLE tarefas RENAME COLUMN cpf TO func_resp_cpf;
ALTER TABLE tarefas RENAME COLUMN algoQueNSei TO prioridade;
ALTER TABLE tarefas RENAME COLUMN naoSeiAinda TO status;
-- excluindo o null
DELETE FROM tarefas WHERE id IS NULL;
-- setando pra not null
ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;
-- 5
ALTER TABLE tarefas ADD PRIMARY KEY (id, func_resp_cpf);
INSERT INTO tarefas VALUES (2147483653, 'limpar portas 1o andar', '32323232911', 2, 'A');
INSERT INTO tarefas VALUES (2147483653, 'aparar grama da área frontal', '32323232911', 3, 'A');
-- 6a) Ja fiz isso na definição da tabela.
-- 6b)
ALTER TABLE tarefas DROP CONSTRAINT status_valid_chk;
UPDATE tarefas SET status = 'P' WHERE status = 'A';
UPDATE tarefas SET status = 'E' WHERE status = 'R';
UPDATE tarefas SET status = 'C' WHERE status = 'F';
ALTER TABLE tarefas ADD CONSTRAINT status_valid_chk CHECK (status = 'P' OR status = 'E' OR status = 'C');
-- 7
UPDATE tarefas SET prioridade = 5 WHERE prioridade >= 5;
ALTER TABLE tarefas ADD CONSTRAINT prioridade_valid_chk CHECK (prioridade >= 0 AND prioridade <= 5);
-- 8
CREATE TABLE funcionario (
    cpf CHAR(11) PRIMARY KEY NOT NULL,
    data_nasc CHAR(10) NOT NULL,
    nome TEXT NOT NULL,
    funcao VARCHAR(11) NOT NULL,
    nivel CHAR(1) NOT NULL,
    superior_cpf CHAR(11),
    CONSTRAINT seguro_superiorCpf_fkey FOREIGN KEY (superior_cpf) REFERENCES funcionario(cpf),
    CONSTRAINT nivel_valid_chk CHECK (nivel = 'J' OR nivel = 'P' OR nivel = 'S'),
    CONSTRAINT funcValid_chk CHECK (funcao = 'LIMPEZA' OR funcao = 'SUB-LIMPEZA'),
    CONSTRAINT nivel_func_chk CHECK ((nivel != 'S' AND superior_cpf IS NOT NULL) OR (nivel = 'S' AND superior_cpf IS null))
);

INSERT INTO funcionario VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUB-LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO funcionario VALUES ('12345678913', '1980-04-09', 'joao da Silva', 'LIMPEZA', 'J', null);
-- 9
-- casos que devem funcionar
INSERT INTO funcionario VALUES ('12345678914', '1980-05-05', 'Carlos', 'SUB-LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678915', '1980-05-07', 'Amon', 'LIMPEZA', 'J', '12345678914');
INSERT INTO funcionario VALUES ('12345678916', '1980-12-03', 'Felipe', 'SUB-LIMPEZA', 'P', '12345678914');
INSERT INTO funcionario VALUES ('12345678917', '1987-05-15', 'Thiago', 'LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678918', '1981-05-07', 'Esdras', 'SUB-LIMPEZA', 'J', '12345678917');
INSERT INTO funcionario VALUES ('12345678919', '1981-05-07', 'Davi', 'LIMPEZA', 'P', '12345678917');
INSERT INTO funcionario VALUES ('12345678920', '1989-03-15', 'Teles', 'LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678921', '1991-05-07', 'Esmael', 'LIMPEZA', 'J', '12345678920');
INSERT INTO funcionario VALUES ('12345678922', '1981-02-07', 'Danilo', 'SUB-LIMPEZA', 'P', '12345678920');
INSERT INTO funcionario VALUES ('12345678923', '1989-03-15', 'Teles', 'LIMPEZA', 'S', null);
-- casos que nao devem funcionar
INSERT INTO funcionario VALUES ('12345678924', '1980-05-05', 'Carlos', 'SUB-LIMPEZA', 'P', null);
INSERT INTO funcionario VALUES ('12345678926', '1980-12-03', 'Felipe', 'SUB-LIMPEZA', 'L', '12345678914');
INSERT INTO funcionario VALUES ('12345678927', '1987-05-15', 'Thiago', 'LIMPEZA', 'S', '12345678914');
INSERT INTO funcionario VALUES ('12345678928', '1980-05-05', 'Levi', 'SUB-LIMPEZAsdf', 'S', null);
INSERT INTO funcionario VALUES ('12345678929', '1980-12-03', 'Felipe', 'SUB-LIMPEZAsd', 'L', '12345678914');
INSERT INTO funcionario VALUES ('12345678930', '1987-05-15', 'Thiago', 'LIMPEZAds', 'S', '12345678914');
INSERT INTO funcionario VALUES ('12345678931', '1987-05-15', 'Thiago', 'LIMPEZA', 'K', null);
INSERT INTO funcionario VALUES ('12345678932', '1980-05-05', 'Levi', 'SUB-LIMPEZAsdf', 'P', null);
INSERT INTO funcionario VALUES ('12345678933', '1980-12-03', 'Felipe', 'SUB-LIMPEZAsd', 'L', '12345678914');
INSERT INTO funcionario VALUES ('12345678934', '1987-05-15', 'Thiago', 'LIMPEZAds', 'J', null);