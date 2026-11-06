/* Prática 14 – Lanchonete – o relatório do gerente
   Salve este arquivo como pratica-14.sql antes de começar. */
USE lanchonete;

-- pergunta 1:
SELECT COUNT(*) AS total_pedidos 
FROM pedido;

-- pergunta 2:
SELECT SUM(quantidade) AS total_unidades 
FROM item_pedido;

-- pergunta 3:
SELECT ROUND(AVG(preco_cobrado), 2) AS preco_medio, MAX(preco_cobrado) AS maior_preco 
FROM item_pedido;

-- pergunta 4:
SELECT unidade_codigo, COUNT(*) AS total_pedidos 
FROM pedido 
GROUP BY unidade_codigo 
ORDER BY total_pedidos DESC;

-- pergunta 5:
SELECT produto_codigo, SUM(quantidade) AS total_vendido 
FROM item_pedido 
GROUP BY produto_codigo 
ORDER BY total_vendido DESC;

-- pergunta 6:
SELECT produto_codigo, SUM(quantidade) AS total_vendido 
FROM item_pedido 
GROUP BY produto_codigo 
HAVING total_vendido >= 3 
ORDER BY total_vendido DESC;

-- pergunta 7:
SELECT DATE_FORMAT(data_hora, '%d/%m') AS dia, COUNT(*) AS total_pedidos 
FROM pedido 
GROUP BY dia 
ORDER BY MIN(data_hora);

-- pergunta 8:
SELECT CONCAT(UPPER(nome), ' – R$ ', preco_tabela) AS etiqueta_cardapio 
FROM produto 
WHERE disponivel = TRUE;