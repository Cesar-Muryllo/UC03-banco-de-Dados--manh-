CREATE DATABASE IF NOT EXISTS lanchonete_manha CHARACTER SET utf8mb4;
USE lanchonete_manha;

CREATE TABLE IF NOT EXISTS bairro (
id_bairro INT AUTO_INCREMENT PRIMARY KEY,
nome_bairro VARCHAR(150) NOT NULL,
taxa_entrega DECIMAL(6,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS endereco (
id			INT AUTO_INCREMENT PRIMARY KEY,
logradouro  VARCHAR(150) NOT NULL,
numero		CHAR(10),
complemento	VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS produto (
codigo		 INT AUTO_INCREMENT PRIMARY KEY,
nome_produto VARCHAR(60) NOT NULL,
preco		 DECIMAL(6,2) CHECK(preco > 0) NOT NULL
);

CREATE TABLE IF NOT EXISTS cliente (
id		INT AUTO_INCREMENT PRIMARY KEY,
nome	VARCHAR(100) NOT NULL,
endereco_id INT NOT NULL,
id_bairro INT NOT NULL,
cpf CHAR(11) UNIQUE NOT NULL,
CONSTRAINT fk_endereco_cliente FOREIGN KEY (endereco_id)
    REFERENCES endereco (id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
CONSTRAINT fk_bairro_cliente FOREIGN KEY (id_bairro)
    REFERENCES bairro(id_bairro)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS telefone_cliente (
id				INT AUTO_INCREMENT PRIMARY KEY,
cliente_id		INT NOT NULL,
telefone CHAR(11) UNIQUE NOT NULL,
FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS pedido (
codigo 			INT AUTO_INCREMENT PRIMARY KEY,
data			DATE NOT NULL,
cliente_id		INT NOT NULL,
total_pedido	DECIMAL(6,2) NOT NULL,
forma_pagamento VARCHAR(30) NOT NULL,
FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS item_pedido (
codigo_pedido		INT NOT NULL,
codigo_produto		INT NOT NULL,
quantidade			INT NOT NULL,
FOREIGN KEY (codigo_pedido) REFERENCES pedido(codigo),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
);
/*
comentario quebra de linha
*/
-- Adicionado o ponto e vírgula (;) no final desta linha:
ALTER TABLE item_pedido COMMENT = 'Tabela dos itens pedido';
-- EXPLAIN item_pedido;

-- ALTER TABLE cliente DROP FOREIGN KEY cliente_id;

-- DROP TABLE bairro;

-- DROP DATABASE lanchonete_manha

DESCRIBE bairro;
INSERT INTO bairro (nome_, taxa_entrega)
VALUES
	('Pajuçara', 7.00),
	('Jatiúca', 8.00),
	('Benedito Bentes', 15.00),
	('Tabuleiro', 10.00),
	('Jacintinho', 5.00);
    
SELECT nome_bairro, taxa_entrega FROM bairro;

DESCRIBE endereco;
INSERT INTO endereco (logradouro, numero, complemento)
VALUES
	('Rua A', '1A','Perto da avenida'),
	('Rua B', '1B','Perto da avenida'),
	('Rua C', '1C','Perto da avenida'),
	('Rua D', '1D','Perto da avenida'),
	('Rua E', '1E','Perto da avenida');
    
SELECT * FROM endereco;
DESCRIBE roduto;
INSERT INTO produto (nome_produto, preco)
VALUES
	('X Tudo',45.00),
    ('Passaporte',25.00),
    ('Misto',35.00),
    ('Pizza Tradicional',55.00),
    ('Açai',14.00);
    
SELECT * FROM produto;
DESCRIBE cliente;
INSERT INTO cliente (nome, endereco_id, id_bairro, cpf)
VALUES
	('Carlos', 1, 1, '60255412051'),
    ('Ana', 2, 2, '60255412052'),
    ('Valdez', 3, 3, '60255412053'),
    ('Marta', 4, 4, '60255412054'),
    ('Vinicius', 5, 5, '60255412055');

SELECT * FROM cliente;

SET SQL_SAFE_UPDATE = 0;
SELECT * FROM bairro;
UPDATE bairro SET taxa_entrega = 35.00 WHERE id_bairro = 1;
DELETE FROM bairro WHERE id_bairro = 6;

START TRANSACTION;
	UPDATE  bairro SET taxa_entrega = 30.00 WHERE id_bairro = 10;
    SELECT * FROM bairro;
ROLLBACK;
COMMIT;
