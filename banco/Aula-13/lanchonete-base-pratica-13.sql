/* Lanchonete – arquivo base da prática 13
   Execute este arquivo inteiro (raio, sem nada selecionado).
   Ele APAGA o banco lanchonete e cria de novo, com:
   as tabelas da prática 11, os dados da prática 12 e os dados prontos da 13.
   Não edite este arquivo: o seu trabalho vai no pratica-13.sql. */
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

-- prática 12: o pedido 1 da planilha e os dois itens dele
INSERT INTO pedido (data_hora, cliente_codigo, unidade_codigo, entregador_codigo)
VALUES ('2026-10-03 19:10', 1, 1, 1);
INSERT INTO item_pedido (pedido_numero, produto_codigo, quantidade, preco_cobrado)
VALUES (1, 2, 1, 18.00), (1, 3, 1, 12.00);

-- prática 12: o endereço da Ponta Verde estava errado
UPDATE unidade SET endereco = 'Av. A, 100' WHERE codigo = 1;

-- prática 12: o produto Teste foi cadastrado por engano
DELETE FROM produto WHERE codigo = 4;

-- dados prontos da prática 13
INSERT INTO unidade (nome, endereco)
VALUES ('Farol', NULL);
INSERT INTO cliente (nome, telefone) VALUES
  ('Cliente 4', NULL),
  ('Cliente 5', '99000-0005');
INSERT INTO produto (nome, preco_tabela, disponivel)
VALUES
  ('Tapioca de frango', 15.00, TRUE),
  ('Suco de laranja', 8.00, TRUE),
  ('Cuscuz recheado', 14.00, FALSE);
INSERT INTO pedido (data_hora, cliente_codigo,
  unidade_codigo, entregador_codigo) VALUES
  ('2026-10-03 19:25', 2, 2, NULL),
  ('2026-10-04 18:40', 1, 1, 2),
  ('2026-10-04 20:05', 3, 3, 1),
  ('2026-10-05 17:50', 1, 1, NULL);
INSERT INTO item_pedido (pedido_numero, produto_codigo,
  quantidade, preco_cobrado) VALUES
  (2, 2, 1, 18.00), (3, 3, 1, 13.00),
  (4, 1, 2, 12.00), (4, 2, 1, 18.00),
  (5, 1, 1, 12.00);
