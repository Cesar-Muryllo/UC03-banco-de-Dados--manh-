CREATE DATABASE IF NOT EXISTS aula04_ambiente 
    DEFAULT CHARACTER SET utf8mb4 
    DEFAULT COLLATE utf8mb4_general_ci;

SHOW DATABASES LIKE 'aula04_ambiente';

USE aula04_ambiente;
SELECT DATABASE();

SELECT VERSION();
SELECT @@port;

SELECT COUNT(*) AS total_film FROM sakila.film;
SELECT COUNT(*) AS total_customer FROM sakila.customer;
SELECT COUNT(*) AS total_rental FROM sakila.rental;
