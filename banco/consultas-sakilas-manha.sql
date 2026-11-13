USE sakila;

DESCRIBE film;
SELECT
	title 'título',
    description 'descrição',
    release_year AS ano_lancamento
FROM
	film;
    
/*
	Operadores Aritméticos:
    (+) = Soma
    (-) = Subtração
    (*) = Multiplicação
    (/) = Divisão
    (%) = Resto da divisão
    
    Operadores Relacionais:
    (>) = Maior
    (<) = Menor
    (>=) = Maior ou igual
    (<=) = Menor ou igual
    (=) = Igualdade
    (<>) = Diferente
    
    Operadores Lógicos:
    E do portugol passa a ser AND no SQL
    OU do portugol passa a ser OR no SQL
    NÃO do portugol passa a ser o NOT no SQL
    
    Condicionais:
    SE do portugol passa a ser IF no SQL
	SE/SENAO do portugol passa ser CASE WHEN THEN no SQL
    
    Laços de Repetição:
    ENQUANTO do portugol passar a ser o WHILE no SQL
    FAÇA-ENQUANTO passa a ser o REPEAT no SQL
    PARA do portugol passa a ser FOR no SQL 
		(no Mysql não tem FOR, no lugar ele tem o LOOP)
*/

DESCRIBE actor;
SELECT
	actor_id AS codigo, -- CORRIGIDO: era acotor_id
    first_name AS nome, -- CORRIGIDO: era frist_name
    last_name AS sobrenme
FROM actor
WHERE actor_id <= 5;

SELECT
	title AS filme,
    length AS minutos,
    length / 60 AS horas
FROM film WHERE film_id <= 5; -- CORRIGIDO: a tabela é 'film', não 'filme'

SELECT DISTINCT rental_duration AS dias_de_locacao -- CORRIGIDO: era rentel_duratin
FROM film
ORDER BY dias_de_locacao DESC;

SELECT
	title,
    rental_rate, -- CORRIGIDO: Faltava uma vírgula aqui
	length
FROM film
WHERE rental_rate = 4.99
	AND length < 50
ORDER BY length;

DESCRIBE film;

SELECT * FROM film;

SELECT
	title,
    rating,
    length
FROM film
WHERE rating = 'PG-13' -- CORRIGIDO: era ratng
	AND length BETWEEN 90 AND 100
ORDER BY length, title;

DESCRIBE rental;
SELECT
	rental_id, -- CORRIGIDO: era renal_id
    rental_date
FROM rental
WHERE rental_date -- CORRIGIDO: a coluna de data é 'rental_date', não 'rental_rate'
	BETWEEN '2005-05-24 00:00:00' AND '2005-05-24 23:59:59';

SELECT * FROM rental;

DESCRIBE country;
SELECT
	country_id,
    country
FROM country -- CORRIGIDO: era coubtry
WHERE 
	country IN
		('Brazil', 'Argentina', 'Mexico', 'Chile', 'Uruguay');
        
SELECT * FROM rental ORDER BY rental_id DESC LIMIT 5;

SELECT
	title
FROM film
WHERE title LIKE '%LOVE%';
-- --------------------------- Funções de agregação -------------------------
USE sakila;
DESCRIBE sakila.rental;
SELECT
	COUNT(*)		AS total_alugueis,
    COUNT(return_date)		AS devolvidos
FROM rental;

-- CORRIGIDO: Adicionado o DESCRIBE payment pois a tabela é usada abaixo
DESCRIBE payment; 
SELECT 
	COUNT(*)		AS pagamentos,
    COUNT(DISTINCT customer_id)		AS clientes_que_pagaram
FROM payment;

DESCRIBE film;
SELECT
	MIN(length)		AS mais_curto,
    MAX(length)		AS mais_longo,
    AVG(length)		AS media,
    ROUND(AVG(length), 1)	AS media_arrendondada
FROM film;

DESCRIBE payment;
SELECT
	SUM(amount)		AS faturamento,
    COUNT(*)		AS pagamentos,
    ROUND(AVG(amount), 2)			AS ticket_medio
FROM payment
WHERE payment_date 
	BETWEEN '2005-07-01 00:00:00' AND '2005-07-31 23:59:59';
    
-- ----------------- Agrupadores -----------------
SELECT
	staff_id		AS funcionario,
    COUNT(*)		AS pagamentos,
    SUM(amount)		AS total_recebido
FROM payment
GROUP BY staff_id;

DESCRIBE film;
SELECT
	rental_duration		AS dias, -- CORRIGIDO: era rental_duratin
    COUNT(*)			AS filmes,
    ROUND(AVG(rental_rate), 2)		AS preco_medio
FROM film
GROUP BY rental_duration
ORDER BY dias ASC;

SELECT
	store_id		AS loja,
    active			AS ativo,
    COUNT(*)		AS clientes
FROM customer -- CORRIGIDO: era custumer
GROUP BY store_id, active -- CORRIGIDO: era acitve
ORDER BY loja, ativo;

SELECT
	customer_id 	AS cliente, -- CORRIGIDO: era custumer_id
    COUNT(*)		AS alugueis_julho
FROM rental
WHERE rental_date
	BETWEEN '2005-07-01 00:00:00' AND '2005-07-31 23:59:59'
GROUP BY customer_id -- CORRIGIDO: era custumer_id
HAVING COUNT(*) >= 19
ORDER BY alugueis_julho DESC, cliente;

-- ------------------ Funções de texto e data ------------------
SELECT
	CONCAT(first_name, ' ', last_name) AS nome_completo,
    email
FROM customer
LIMIT 5;

SELECT
	CONCAT('UPDATE customer SET first_name = ',
	'teste',
    'WHERE customer_id = ', customer_id, ';') AS query
FROM customer
LIMIT 5;

SELECT
	address,
    district,
    LOWER(distric)		AS distrito_etiqueta
FROM address
LIMIT 5;

SELECT
	rental_id,
    rental_rate,
    DATE_FORMAT(rental_rate, '%d/%m/%Y %H:%i') AS data_br
FROM rental
LIMIT 5;

SELECT
	YEAR(payment_date)		AS ano,
    MONTH(payment_date)		AS mes,
    CONCAT('Funcionário', staff_id) AS funcionario,
	SUM(amount) 			AS total
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date), staff_id
ORDER BY ano, mes, staff_id;

-- -------------- JUNÇÔES --------------
USE sakila;
SELECT * FROM sakila.city;
DESCRIBE city;

SELECT
	c.city_id,
    c.city,
    co.country
FROM city c
INNER JOIN country co ON co.country_id = c.country_id;

DESCRIBE payment;
SELECT
	CONCAT(s.first_name, ' ', s.last_name) 	AS funcionario,
    COUNT(*)							 	AS pagamentos,
    SUM(p.amount)							AS total_recebido
FROM payment p
INNER JOIN staff s ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    c.email                                AS 'e-mail',
    SUM(p.amount)                          AS total_gasto
FROM payment p
INNER JOIN customer c ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_gasto DESC, cliente;

DESCRIBE csutomer;
DESCRIBE address;
DESCRIBE city;

SELECT
CONCAT(c.first_name, ' ', c.last_name)	AS cliente,
a.address_id							AS endereco,
ci.city_id								AS cidade,
co.country								AS pais
FROM customer c
INNER JOIN address a ON a.address_id = c.address_id
INNER JOIN city ci ON ci.city_id = a.city_id
INNER JOIN country co ON co.country_id = ci.city_id
LIMIT 5;

SELECT
	l.name	AS idioma,
    COUNT(f.film_id)	AS filmes
FROM  language l
LEFT JOIN film f ON l.language_id = f.language_id
GROUP BY l.language_id, l.name;

SELECT
	l.name	AS idioma,
    COUNT(f.film_id)	AS filmes
FROM  film f
RIGHT JOIN language l ON f.language_id = l.language_id
GROUP BY l.language_id, l.name;

-- ----------------- SUB CONSULTAS -----------------
SELECT
title,
replacement_cost
FROM film
WHERE replacement_cost = (SELECT MAX(replacement_cost) FROM film)
ORDER BY title;

SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (
	SELECT r.custmer_id FROM rental r
    INNER JOIN inventory i ON i.inventor_id = r.inventory_id
    INNER JOIN film f ON f.film_id = i.film_id
    WHERE f.title = 'ACADEMY DINOSAUR'
)
ORDER BY last_name;

SELECT
	(SELECT COUNT(*) FROM film)	AS total_filmes,
	COUNT(*)	AS filmes_nunca_alugados
FROM film
WHERE film_id NOT IN (
	SELECT i.film_id FROM inventory i 
    INNER JOIN rental r ON r.inventory_id = i.inventory_id
);

-- ahh coisaxxx? --

CREATE VIEW vw_refugo_produto AS
SELECT p.nome, SUM(o.qtd_refugo) AS total_refugo
FROM ordem_producao o
JOIN produto p ON o.produto_codigo = p.codigo
GROUP BY p.nome
ORDER BY total_refugo DESC;

-- Procedure para registrar item de expedição com preço de tabela automático
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

-- Teste da procedure (item na expedição 2, produto 4, quant. 5000)
CALL sp_registrar_item(2, 4, 5000);


-- Trigger que debita o consumo_kg da ordem de produção no estoque de resina
DELIMITER //
CREATE TRIGGER tg_ordem_baixa_resina
AFTER INSERT ON ordem_producao
FOR EACH ROW
BEGIN
    DECLARE v_resina_codigo INT;
    
    -- Encontra o código da resina pertencente ao produto da nova ordem
    SELECT resina_codigo INTO v_resina_codigo 
    FROM produto 
    WHERE codigo = NEW.produto_codigo;
    
    -- Subtrai o consumo_kg da tabela de estoque
    UPDATE estoque_resina
    SET quantidade_kg = quantidade_kg - NEW.consumo_kg
    WHERE unidade_codigo = NEW.unidade_codigo 
      AND resina_codigo = v_resina_codigo;
END //
DELIMITER ;

-- Teste da trigger
INSERT INTO ordem_producao (data_ordem, qtd_planejada, qtd_boa, qtd_refugo, consumo_kg, unidade_codigo, produto_codigo) 
VALUES ('2026-11-09', 1000, 950, 50, 20, 2, 3);

