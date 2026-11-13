/* SA2 - Banco da indústria de embalagens: modelo de referência do docente com os cadastros.
   Recria o banco do zero. Depois da SA1, a gerência pediu a coluna consumo_kg na ordem de produção. */
DROP DATABASE IF EXISTS embalagens;
CREATE DATABASE embalagens;
USE embalagens;

-- unidades fabris
CREATE TABLE unidade (
  codigo   INT AUTO_INCREMENT PRIMARY KEY,
  nome     VARCHAR(60) NOT NULL,
  cidade   VARCHAR(60) NOT NULL,
  telefone VARCHAR(15) NOT NULL
) COMMENT = 'Unidades fabris';

-- tipos de resina
CREATE TABLE resina (
  codigo INT AUTO_INCREMENT PRIMARY KEY,
  nome   VARCHAR(40) NOT NULL UNIQUE
) COMMENT = 'Tipos de resina';

-- catálogo único: cada produto usa uma resina
CREATE TABLE produto (
  codigo        INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(60) NOT NULL UNIQUE,
  preco_tabela  DECIMAL(8,2) NOT NULL CHECK (preco_tabela > 0),
  resina_codigo INT NOT NULL,
  FOREIGN KEY (resina_codigo) REFERENCES resina (codigo)
) COMMENT = 'Catálogo de produtos';

-- N:N unidade x resina, com a quantidade em quilos
CREATE TABLE estoque_resina (
  unidade_codigo INT NOT NULL,
  resina_codigo  INT NOT NULL,
  quantidade_kg  DECIMAL(10,2) NOT NULL CHECK (quantidade_kg >= 0),
  PRIMARY KEY (unidade_codigo, resina_codigo),
  FOREIGN KEY (unidade_codigo) REFERENCES unidade (codigo),
  FOREIGN KEY (resina_codigo)  REFERENCES resina (codigo)
) COMMENT = 'Estoque de resina por unidade';

-- clientes: telefone opcional
CREATE TABLE cliente (
  cnpj         CHAR(18) PRIMARY KEY,
  razao_social VARCHAR(100) NOT NULL,
  cidade       VARCHAR(60) NOT NULL,
  telefone     VARCHAR(15) NULL
) COMMENT = 'Clientes';

-- ordem de produção: uma unidade e um produto
CREATE TABLE ordem_producao (
  numero         INT AUTO_INCREMENT PRIMARY KEY,
  data_ordem     DATE NOT NULL,
  qtd_planejada  INT NOT NULL CHECK (qtd_planejada > 0),
  qtd_boa        INT NOT NULL CHECK (qtd_boa >= 0),
  qtd_refugo     INT NOT NULL CHECK (qtd_refugo >= 0),
  consumo_kg     DECIMAL(8,2) NOT NULL CHECK (consumo_kg > 0),
  unidade_codigo INT NOT NULL,
  produto_codigo INT NOT NULL,
  FOREIGN KEY (unidade_codigo) REFERENCES unidade (codigo),
  FOREIGN KEY (produto_codigo) REFERENCES produto (codigo)
) COMMENT = 'Ordens de produção';

-- expedição: uma unidade e um cliente
CREATE TABLE expedicao (
  numero         INT AUTO_INCREMENT PRIMARY KEY,
  data_saida     DATE NOT NULL,
  unidade_codigo INT NOT NULL,
  cliente_cnpj   CHAR(18) NOT NULL,
  FOREIGN KEY (unidade_codigo) REFERENCES unidade (codigo),
  FOREIGN KEY (cliente_cnpj)   REFERENCES cliente (cnpj)
) COMMENT = 'Expedições';

-- N:N expedição x produto, com quantidade e preço cobrado
CREATE TABLE item_expedicao (
  expedicao_numero INT NOT NULL,
  produto_codigo   INT NOT NULL,
  quantidade       INT NOT NULL CHECK (quantidade > 0),
  preco_cobrado    DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (expedicao_numero, produto_codigo),
  FOREIGN KEY (expedicao_numero) REFERENCES expedicao (numero),
  FOREIGN KEY (produto_codigo)   REFERENCES produto (codigo)
) COMMENT = 'Produtos de cada expedição';

-- cadastros prontos (dados fictícios)
INSERT INTO unidade (nome, cidade, telefone) VALUES
  ('Tabuleiro', 'Maceió', '82 3000-0001'),
  ('Agreste', 'Arapiraca', '82 3000-0002'),
  ('Litoral', 'Marechal Deodoro', '82 3000-0003');

INSERT INTO resina (nome) VALUES ('PEAD'), ('PP'), ('PET'), ('PVC');

INSERT INTO produto (nome, preco_tabela, resina_codigo) VALUES
  ('Pote 500 ml', 0.45, 2),
  ('Tampa 80 mm', 0.12, 2),
  ('Garrafa 1 L', 0.60, 3),
  ('Tampa 28 mm', 0.08, 1),
  ('Balde 5 L', 3.20, 1);

INSERT INTO estoque_resina (unidade_codigo, resina_codigo, quantidade_kg) VALUES
  (1, 1, 800), (1, 2, 1200), (1, 3, 600),
  (2, 1, 500), (2, 3, 900),
  (3, 2, 400);

INSERT INTO cliente (cnpj, razao_social, cidade, telefone) VALUES
  ('11.111.111/0001-11', 'Laticínio Alfa', 'Maceió', '82 3000-1111'),
  ('22.222.222/0001-22', 'Água Beta', 'Arapiraca', NULL),
  ('33.333.333/0001-33', 'Doces Gama', 'Penedo', NULL);
