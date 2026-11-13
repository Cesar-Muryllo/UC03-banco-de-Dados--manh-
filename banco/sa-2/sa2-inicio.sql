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

-- ETAPA 4: privilégios dos perfis e SHOW GRANTS
