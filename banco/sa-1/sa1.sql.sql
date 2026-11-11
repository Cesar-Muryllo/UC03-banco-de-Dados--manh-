DROP DATABASE IF EXISTS embalagens;
CREATE DATABASE embalagens;
USE embalagens;

CREATE TABLE resina (
    id_resina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
) COMMENT='Armazena os tipos de resina plástica utilizados';

CREATE TABLE unidade (
    id_unidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    telefone VARCHAR(13) NOT NULL
) COMMENT='Armazena os dados das três unidades fabris da indústria';

CREATE TABLE cliente (
	cnpj VARCHAR(14) NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    telefone VARCHAR(13) NULL
) COMMENT='Armazena os clientes, telefone é opcional';

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    preco_tabela DECIMAL(10, 2) NOT NULL CHECK (preco_tabela > 0),
    id_resina INT NOT NULL,
    FOREIGN KEY (id_resina) REFERENCES resina(id_resina)
) COMMENT='Catálogo único de produtos para unidades';

CREATE TABLE unidade_resina (
    id_unidade INT NOT NULL,
    id_resina INT NOT NULL,
    qtd_kg DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_unidade, id_resina),
    FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
    FOREIGN KEY (id_resina) REFERENCES resina(id_resina)
) COMMENT='Controla a quantidade de quilos de cada resina existem em cada unidade';

CREATE TABLE ordem_producao (
	numero INT PRIMARY KEY,
    data DATE NOT NULL,
    qtd_planejada INT NOT NULL,
    qtd_boa INT NOT NULL,
    qtd_refugo INT NOT NULL,
    id_unidade INT NOT NULL,
    id_produto INT NOT NULL,FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
) COMMENT='Registra as ordens de prdução de cada unidade das fabris';

CREATE TABLE expedicao (
	numero INT PRIMARY KEY,
    data DATE NOT NULL,
    id_unidade INT NOT NULL,
    cnpj_cliente VARCHAR(14) NOT NULL,
    FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
    FOREIGN KEY (cnpj_cliente) REFERENCES cliente (cnpj)
) COMMENT='Registra as saidas dos produtos da fábrica ao cliente';

CREATE TABLE expedicao_produto (
    numero_expedicao INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_cobrado DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (numero_expedicao, id_produto),
    FOREIGN KEY (numero_expedicao) REFERENCES expedicao(numero),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
) COMMENT='Itens da expedição. O preço cobrado aqui pode ser diferente do preço da tabela do produto';
