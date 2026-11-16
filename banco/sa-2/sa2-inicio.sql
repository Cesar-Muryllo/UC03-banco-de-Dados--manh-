/* SA2 - Implementação e manipulação do banco de embalagens
   Aluno(a): César Muryllo
   Antes: execute o embalagens-base-sa2.sql. */
USE embalagens;
DESCRIBE 
-- ETAPA 1: dados de teste (INSERT e UPDATE)
INSERT INTO ordem_producao (data_ordem, qtd_planejada, qtd_boa, qtd_refugo, consumo_kg, unidade_codigo, produto_codigo) VALUES
('2026-11-03', 5000, 4800, 200, 60, 1, 1),
('2026-11-03', 5000, 4950, 50, 25, 1, 2),
('2026-11-04', 8000, 7650, 350, 160, 2, 3),
('2026-11-05', 3000, 2880, 120, 18, 3, 2),
('2026-11-05', 4000, 3900, 100, 48, 1, 1);

INSERT INTO expedicao (data_saida, unidade_codigo, cliente_cnpj) VALUES
('2026-11-06', 1, '11.111.111/0001-11'),
('2026-11-06', 2, '22.222.222/0001-22');

INSERT INTO item_expedicao (expedicao_numero, produto_codigo, quantidade, preco_cobrado) VALUES
(1, 1, 2000, 0.45),
(1, 2, 2000, 0.12),
(2, 3, 5000, 0.65);

UPDATE produto SET preco_tabela = 0.48 WHERE codigo = 1;

-- ETAPA 2: consultas 1 a 5

-- Consulta 1:
SELECT * FROM ordem_producao
WHERE qtd_refugo > 100
ORDER BY qtd_refugo DESC;

-- Consulta 2:
SELECT p.nome, SUM(o.qtd_refugo) AS total_refugo
FROM ordem_producao o
JOIN produto p ON o.produto_codigo = p.codigo
GROUP BY p.nome
ORDER BY total_refugo DESC;

-- Consulta 3:
SELECT u.nome, SUM(o.qtd_boa) AS total_boas
FROM ordem_producao o
JOIN unidade u ON o.unidade_codigo = u.codigo
GROUP BY u.nome
HAVING total_boas > 5000;

-- Consulta 4: 
SELECT c.razao_social AS cliente, u.nome AS unidade, p.nome AS produto, 
       ie.quantidade, (ie.quantidade * ie.preco_cobrado) AS valor_total
FROM item_expedicao ie
JOIN expedicao e ON ie.expedicao_numero = e.numero
JOIN cliente c ON e.cliente_cnpj = c.cnpj
JOIN unidade u ON e.unidade_codigo = u.codigo
JOIN produto p ON ie.produto_codigo = p.codigo;

-- Consulta 5
SELECT c.razao_social
FROM cliente c
LEFT JOIN expedicao e ON c.cnpj = e.cliente_cnpj
WHERE e.numero IS NULL;

-- ETAPA 3: view, procedure e trigger
CREATE VIEW vw_refugo_produto AS
SELECT p.nome, SUM(o.qtd_refugo) AS total_refugo
FROM ordem_producao o
JOIN produto p ON o.produto_codigo = p.codigo
GROUP BY p.nome
ORDER BY total_refugo DESC;

DELIMITER //
CREATE PROCEDURE sp_registrar_item(
    IN p_expedicao_numero INT, 
    IN p_produto_codigo INT, 
    IN p_quantidade INT
)
BEGIN
    DECLARE v_preco_tabela DECIMAL(8,2);
    
    -- Busca o preço atual do produto
    SELECT preco_tabela INTO v_preco_tabela 
    FROM produto 
    WHERE codigo = p_produto_codigo;
    
    -- Grava o item usando a variável com o preço consultado
    INSERT INTO item_expedicao (expedicao_numero, produto_codigo, quantidade, preco_cobrado)
    VALUES (p_expedicao_numero, p_produto_codigo, p_quantidade, v_preco_tabela);
END //
DELIMITER ;

CALL sp_registrar_item(2, 4, 5000);

DELIMITER //
CREATE TRIGGER tg_ordem_baixa_resina
AFTER INSERT ON ordem_producao
FOR EACH ROW
BEGIN
    DECLARE v_resina_codigo INT;

    SELECT resina_codigo INTO v_resina_codigo 
    FROM produto 
    WHERE codigo = NEW.produto_codigo;

    UPDATE estoque_resina
    SET quantidade_kg = quantidade_kg - NEW.consumo_kg
    WHERE unidade_codigo = NEW.unidade_codigo 
      AND resina_codigo = v_resina_codigo;
END //
DELIMITER ;

INSERT INTO ordem_producao (data_ordem, qtd_planejada, qtd_boa, qtd_refugo, consumo_kg, unidade_codigo, produto_codigo) 
VALUES ('2026-11-09', 1000, 950, 50, 20, 2, 3);

-- ETAPA 4: privilégios dos perfis e SHOW GRANTS
-- Privilégios do Operador
GRANT INSERT, SELECT ON embalagens.ordem_producao TO 'emb_operador'@'localhost';
GRANT SELECT ON embalagens.produto TO 'emb_operador'@'localhost';

-- Privilégios do Gerente
GRANT SELECT ON embalagens.* TO 'emb_gerente'@'localhost';
GRANT ALL PRIVILEGES ON embalagens.produto TO 'emb_gerente'@'localhost';

-- Conferência dos privilégios
SHOW GRANTS FOR 'emb_operador'@'localhost';
SHOW GRANTS FOR 'emb_gerente'@'localhost';