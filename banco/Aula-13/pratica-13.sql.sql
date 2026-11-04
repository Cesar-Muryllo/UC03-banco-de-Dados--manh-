/* Prática 13 – Lanchonete – perguntas ao banco
   Salve este arquivo como pratica-13.sql antes de começar. */
USE lanchonete;

-- pergunta 1:
SELECT nome, preco_tabela AS preco_rs 
FROM produto;

-- pergunta 2:
SELECT DISTINCT unidade_codigo 
FROM pedido;

-- pergunta 3:
SELECT *
FROM produto 
WHERE preco_tabela BETWEEN 12.00 AND 15.00;

-- pergunta 4:
SELECT *
FROM produto 
WHERE nome LIKE 'Açaí%';

-- pergunta 5:
SELECT *
FROM pedido 
WHERE entregador_codigo IS NULL;

-- pergunta 6:
SELECT *
FROM pedido 
WHERE unidade_codigo IN (1, 3);

-- pergunta 7:
SELECT *
FROM produto 
WHERE disponivel = TRUE 
ORDER BY preco_tabela DESC 
LIMIT 3;

-- pergunta 8:.
SELECT *
FROM pedido 
ORDER BY data_hora DESC;

-- Extra
SELECT *
FROM item_pedido 
WHERE quantidade >= 2 
ORDER BY preco_cobrado DESC;