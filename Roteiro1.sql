-- Criando as tabelas com suas devidas chaves, referencias e constraints
-- Assumi que o eram esses os atributos do automovel e que sera identificado pelo atributo placa
CREATE TABLE automovel (
    placa CHAR(8) PRIMARY KEY NOT NULL,
    modelo VARCHAR(30) NOT NULL,
    marca VARCHAR(20) NOT NULL,
    chassi VARCHAR(10) NOT NULL,
    ano INTEGER NOT NULL
);
-- Assumi que o segurado sera identificado por seu cpf e pela placa do automovel
-- (possibilitando assim uma pessoa ter dois automoveis cadastrados no banco de dados sem ocasionar repeticoes)
CREATE TABLE segurado (
    nome TEXT NOT NULL,
    cpf CHAR(11) NOT NULL,
    placa_automovel CHAR(8) REFERENCES automovel(placa) NOT NULL,
    PRIMARY KEY (cpf, placa_automovel) 
);

-- A oficina sera identificada por se cnpj, abstrai o caso de rede de oficina
CREATE TABLE oficina (
    cnpj CHAR(14) PRIMARY KEY NOT NULL,
    nome TEXT
);

-- O perito tera um nome e cpf e sera identificado por seu cpf
CREATE TABLE perito (
    nome TEXT NOT NULL,
    cpf CHAR(11) PRIMARY KEY NOT NULL
);

-- O seguro tera uma referencia de chave estrangeira para o perito e o segurado e sera identificado por seu protocolo
CREATE TABLE seguro (
    cpf_perito CHAR(11) NOT NULL,
    cpf_segurado CHAR(11) NOT NULL,
    protocolo INTEGER PRIMARY KEY NOT NULL,
    mensalidade INTEGER,
    CONSTRAINT seguro_cpfPerito_fkey FOREIGN KEY (cpf_perito) REFERENCES perito(cpf),
    CONSTRAINT seguro_cpfSegurado_fkey FOREIGN KEY (cpf_segurado) REFERENCES segurado(cpf)
);

-- O sinistro sera identificado por um id e tera uma referencia de chave estrangeira para o protocolo do seguro
CREATE TABLE sinistro (
    id_ocorrencia INTEGER PRIMARY KEY NOT NULL,
    protocolo_seguro INTEGER NOT NULL,
    data_ocorrencia DATE NOT NULL,
    ocorrencia TEXT NOT NULL,
    CONSTRAINT sinistro_protocoloSeguro_fkey FOREIGN KEY (protocolo_seguro) REFERENCES seguro(protocolo)
);

-- A pericia sera identificada por seu id e tera uma referencia de chave estrangeira para o id do sinistro
CREATE TABLE pericia (
    id_pericia INTEGER PRIMARY KEY NOT NULL,
    perda_total BOOLEAN NOT NULL,
    id_sinistro INTEGER NOT NULL,
    CONSTRAINT pericia_idSinistro_fkey FOREIGN KEY (id_sinistro) REFERENCES sinistro(id_ocorrencia)
);

-- O reparo sera identificado por seu id e uma referencia de chave estrangeira para o cnpj da oficina e o id da pericia
CREATE TABLE reparo (
    id_reparo INTEGER PRIMARY KEY NOT NULL,
    cnpj_oficina CHAR(14) NOT NULL,
    valor_reparo INTEGER,
    id_pericia INTEGER NOT NULL,
    CONSTRAINT reparo_cnpjOficina_fkey FOREIGN KEY (cnpj_oficina) REFERENCES oficina(cnpj),
    CONSTRAINT reparo_idPericia_fkey FOREIGN KEY (id_pericia) REFERENCES pericia(id_pericia)
);