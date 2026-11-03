/* Lanchonete – arquivo base da prática 12
   Execute este arquivo inteiro (raio, sem nada selecionado).
   Ele APAGA o banco lanchonete e cria de novo, com:
   as tabelas da prática 11 e os dados prontos da prática 12.
   Não edite este arquivo: o seu trabalho vai no pratica-12.sql. */
DROP DATABASE IF EXISTS lanchonete;
CREATE DATABASE lanchonete;
USE lanchonete;

-- unidades da rede (Ponta Verde, Pajuçara, Jatiúca)
CREATE TABLE unidade (
  codigo   INT AUTO_INCREMENT PRIMARY KEY,
  nome     VARCHAR(60) NOT NULL,
  endereco VARCHAR(150) NULL
) COMMENT = 'Unidades da lanchonete';

-- clientes: o telefone não se repete
CREATE TABLE cliente (
  codigo   INT AUTO_INCREMENT PRIMARY KEY,
  nome     VARCHAR(80) NOT NULL,
  telefone VARCHAR(15) UNIQUE
);

-- cardápio: o preço de tabela é maior que zero
CREATE TABLE produto (
  codigo       INT AUTO_INCREMENT PRIMARY KEY,
  nome         VARCHAR(60) NOT NULL UNIQUE,
  preco_tabela DECIMAL(6,2) NOT NULL CHECK (preco_tabela > 0)
);

-- entregadores
CREATE TABLE entregador (
  codigo INT AUTO_INCREMENT PRIMARY KEY,
  nome   VARCHAR(60) NOT NULL
);

-- pedido: depois de cliente, unidade e entregador (FK para as três)
CREATE TABLE pedido (
  numero            INT AUTO_INCREMENT PRIMARY KEY,
  data_hora         DATETIME NOT NULL,
  cliente_codigo    INT NOT NULL,
  unidade_codigo    INT NOT NULL,
  entregador_codigo INT NULL,
  FOREIGN KEY (cliente_codigo)    REFERENCES cliente (codigo),
  FOREIGN KEY (unidade_codigo)    REFERENCES unidade (codigo),
  FOREIGN KEY (entregador_codigo) REFERENCES entregador (codigo)
);

-- item do pedido: a chave tem duas colunas (pedido + produto)
CREATE TABLE item_pedido (
  pedido_numero  INT NOT NULL,
  produto_codigo INT NOT NULL,
  quantidade     INT NOT NULL CHECK (quantidade > 0),
  preco_cobrado  DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (pedido_numero, produto_codigo),
  FOREIGN KEY (pedido_numero)  REFERENCES pedido (numero),
  FOREIGN KEY (produto_codigo) REFERENCES produto (codigo)
);

-- desafio extra (sem nota): estoque de cada produto em cada unidade
CREATE TABLE estoque (
  unidade_codigo INT NOT NULL,
  produto_codigo INT NOT NULL,
  quantidade     INT NOT NULL CHECK (quantidade >= 0),
  PRIMARY KEY (unidade_codigo, produto_codigo),
  FOREIGN KEY (unidade_codigo) REFERENCES unidade (codigo),
  FOREIGN KEY (produto_codigo) REFERENCES produto (codigo)
);

-- ALTER: o cardápio passa a mostrar se o produto está disponível
ALTER TABLE produto ADD COLUMN disponivel BOOLEAN NOT NULL DEFAULT TRUE;


-- dados prontos da prática 12
INSERT INTO unidade (nome, endereco) VALUES
  ('Ponta Verde', 'Av. A, 1000'), ('Pajuçara', 'Rua B, 20'), ('Jatiúca', 'Rua C, 300');
INSERT INTO cliente (nome, telefone) VALUES
  ('Cliente 1', '99000-0001'), ('Cliente 2', '99000-0002'), ('Cliente 3', '99000-0003');
INSERT INTO produto (nome, preco_tabela) VALUES
  ('Açaí 300 ml', 12.00), ('Açaí 500 ml', 18.00), ('Tapioca de queijo', 13.00), ('Teste', 1.00);
INSERT INTO entregador (nome) VALUES ('Entregador 1'), ('Entregador 2');