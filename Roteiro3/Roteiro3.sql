CREATE TYPE estados AS ENUM ('maranhão', 'piauí', 'ceará', 'rio grande do norte', 'paraíba', 'pernambuco', 'alagoas', 'sergipe', 'bahia');

CREATE TABLE funcionario(
    nome TEXT NOT NULL,
    cpf CHAR(11) PRIMARY KEY NOT NULL,
    isGerente BOOLEAN NOT NULL,
    funcao TEXT NOT NULL,
    CONSTRAINT funcaoValida CHECK (funcao = 'farmacêutico' OR funcao = 'vendedor' OR funcao = 'entregador' OR funcao = 'caixa' OR funcao = 'administrador'),
    CONSTRAINT ehGerente CHECK ((isGerente = TRUE AND (funcao = 'administrador' OR funcao = 'farmacêutico') OR isGerente = FALSE))
);

CREATE TABLE farmacias(
    id INTEGER PRIMARY KEY NOT NULL,
    nome TEXT NOT NULL,
    isSede VARCHAR(6) NOT NULL,
    gerente CHAR(11) NOT NULL,
    bairro TEXT NOT NULL,
    estado estados NOT NULL,
    cidade TEXT NOT NULL,
    ehGerent BOOLEAN NOT NULL,
    UNIQUE (gerente),
    UNIQUE (bairro),
    CONSTRAINT sedeOrFilial CHECK (isSede = 'filial' OR isSede = 'sede'),
    CONSTRAINT unicaSede EXCLUDE USING gist (nome WITH =) WHERE (isSede = 'sede'),
    CONSTRAINT gerenteFkey FOREIGN KEY (gerente) REFERENCES funcionario(cpf),
    CONSTRAINT funcionarioGerente CHECk (ehGerent = TRUE)
);

CREATE TABLE clientes(
    nomeCliente TEXT NOT NULL,
    cpfCliente CHAR(11) PRIMARY KEY NOT NULL,
    endereco TEXT NOT NULL,
    idade DATE NOT NULL,
    CONSTRAINT enderecoValid CHECK (endereco = 'residência' OR endereco = 'trabalho' OR endereco = 'outro'),
    CONSTRAINT idadeValida CHECK (idade < '2002-09-19')
);

CREATE TABLE medicamentos(
    idMedicamento INTEGER PRIMARY KEY NOT NULL,
    vendaComReceita BOOLEAN NOT NULL,
    nomeMed TEXT NOT NULL
);

CREATE TABLE entregas(
    idEntrega INTEGER PRIMARY KEY NOT NULL,
    cpfEntregador CHAR(11) NOT NULL,
    enderecoEntrega TEXT,
    cpfClienteEntrega CHAR(11) NOT NULL,
    funcaoFun TEXT NOT NULL,
    CONSTRAINT entregadorFkey FOREIGN KEY (cpfEntregador) REFERENCES funcionario(cpf),
    CONSTRAINT funcionarioEntregador CHECk (funcaoFun = 'entregador'),
    CONSTRAINT clienteEntregaFkey FOREIGN KEY (cpfClienteEntrega) REFERENCES clientes(cpfCliente),
    CONSTRAINT enderecoValidEntrega CHECK (enderecoEntrega = 'residência' OR enderecoEntrega = 'trabalho' OR enderecoEntrega = 'outro')
);

CREATE TABLE vendas(
    idVenda INTEGER PRIMARY KEY NOT NULL,
    cpfVendedor CHAR(11) NOT NULL,
    medicamentoId INTEGER NOT NULL,
    clienteCadastrado BOOLEAN NOT NULL,
    receita BOOLEAN NOT NULL,
    isVendedor BOOLEAN NOT NULL,
    CONSTRAINT vendedorFkey FOREIGN KEY (cpfVendedor) REFERENCES funcionario(cpf),
    CONSTRAINT funcionarioVendedor CHECK (isVendedor = TRUE),
    CONSTRAINT medicamentoFkey FOREIGN KEY (medicamentoId) REFERENCES medicamentos(idMedicamento),
    CONSTRAINT vendaMedicamentoReceita CHECK ((receita = FALSE) OR (receita = TRUE AND clienteCadastrado = TRUE))
);

-- Inserts válidos
INSERT INTO funcionario VALUES('felipe', '12345678910', TRUE, 'farmacêutico');
INSERT INTO funcionario VALUES('fernando', '12345678911', TRUE, 'administrador');
INSERT INTO funcionario VALUES('miguel', '12345678912', FALSE, 'entregador');
INSERT INTO funcionario VALUES('amanda', '12345678913', FALSE, 'vendedor');
INSERT INTO funcionario VALUES('erik', '12345678914', FALSE, 'entregador');
INSERT INTO farmacias VALUES (10, 'franfarma', 'sede', '12345678910', 'medici', 'paraíba', 'campina grande', TRUE);
INSERT into farmacias VALUES(11, 'franfarma', 'filial', '12345678911', 'malvinas', 'paraíba', 'campina grande', TRUE);
INSERT INTO medicamentos VALUES(143, TRUE, 'xarelto');
INSERT INTO medicamentos VALUES(145, FALSE, 'dorflex');
INSERT INTO clientes VALUES('ramon', '10987654321', 'residência', '1998-10-12');
INSERT INTO clientes VALUES('celia', '11987654321', 'trabalho', '1998-10-08');
INSERT INTO clientes VALUES('celia', '21987654321', 'trabalho', '1998-10-12');
INSERT INTO entregas VALUES(131,'12345678912', 'residência', '10987654321', 'entregador');
INSERT INTO vendas VALUES(2,'12345678913', 145, FALSE, FALSE, TRUE);
INSERT INTO vendas VALUES(3,'12345678913', 145, TRUE, TRUE, TRUE);
INSERT INTO funcionario VALUES('cristina', '12345678919', TRUE, 'administrador');

-- INSERTS INVÁLIDOS
INSERT INTO funcionario VALUES('felipe', '12345678922', FALSE, 'enfermeiro');
INSERT INTO funcionario VALUES('fernando', '12345678923', TRUE, 'entregador');
INSERT INTO farmacias VALUES (15, 'franfarma', 'sede', '12345678919', 'medici', 'paraíba', 'campina grande', TRUE);
INSERT INTO farmacias VALUES (18, 'franfarma', 'filial', '12345678919', 'medici', 'paraíba', 'campina grande', TRUE);
INSERT into farmacias VALUES(16, 'franfarma', 'filial', '12345678913', 'malvinas', 'paraíba', 'campina grande', FALSE);
INSERT into farmacias VALUES(17, 'franfarma', 'filial', '12345678919', 'malvinas', 'sp', 'sp', TRUE);
INSERT INTO clientes VALUES('ramon', '20987654321', 'malvinas', '1998-10-12');
INSERT INTO clientes VALUES('ramon', '22987654321', 'outro', '2003-12-12');
INSERT INTO entregas VALUES(133,'12345678913', 'residência', '10987654321', 'vendedor');
INSERT INTO entregas VALUES(134,'12345678912', 'residência', NULL, 'entregador');
INSERT INTO entregas VALUES(135,'12345678912', 'malvinas', '10987654321', 'entregador');
INSERT INTO vendas VALUES(4,'12345678912', 145, FALSE, FALSE, FALSE);
INSERT INTO vendas VALUES(5,'12345678913', 143, FALSE, TRUE, TRUE);



