CREATE DATABASE  IF NOT EXISTS `embalagens` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `embalagens`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: embalagens
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `cnpj` char(18) NOT NULL,
  `razao_social` varchar(100) NOT NULL,
  `cidade` varchar(60) NOT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`cnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Clientes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES ('11.111.111/0001-11','Laticínio Alfa','Maceió','82 3000-1111'),('22.222.222/0001-22','Água Beta','Arapiraca',NULL),('33.333.333/0001-33','Doces Gama','Penedo',NULL);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_resina`
--

DROP TABLE IF EXISTS `estoque_resina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estoque_resina` (
  `unidade_codigo` int NOT NULL,
  `resina_codigo` int NOT NULL,
  `quantidade_kg` decimal(10,2) NOT NULL,
  PRIMARY KEY (`unidade_codigo`,`resina_codigo`),
  KEY `resina_codigo` (`resina_codigo`),
  CONSTRAINT `estoque_resina_ibfk_1` FOREIGN KEY (`unidade_codigo`) REFERENCES `unidade` (`codigo`),
  CONSTRAINT `estoque_resina_ibfk_2` FOREIGN KEY (`resina_codigo`) REFERENCES `resina` (`codigo`),
  CONSTRAINT `estoque_resina_chk_1` CHECK ((`quantidade_kg` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Estoque de resina por unidade';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque_resina`
--

LOCK TABLES `estoque_resina` WRITE;
/*!40000 ALTER TABLE `estoque_resina` DISABLE KEYS */;
INSERT INTO `estoque_resina` VALUES (1,1,800.00),(1,2,1200.00),(1,3,600.00),(2,1,500.00),(2,3,900.00),(3,2,400.00);
/*!40000 ALTER TABLE `estoque_resina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expedicao`
--

DROP TABLE IF EXISTS `expedicao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expedicao` (
  `numero` int NOT NULL AUTO_INCREMENT,
  `data_saida` date NOT NULL,
  `unidade_codigo` int NOT NULL,
  `cliente_cnpj` char(18) NOT NULL,
  PRIMARY KEY (`numero`),
  KEY `unidade_codigo` (`unidade_codigo`),
  KEY `cliente_cnpj` (`cliente_cnpj`),
  CONSTRAINT `expedicao_ibfk_1` FOREIGN KEY (`unidade_codigo`) REFERENCES `unidade` (`codigo`),
  CONSTRAINT `expedicao_ibfk_2` FOREIGN KEY (`cliente_cnpj`) REFERENCES `cliente` (`cnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Expedições';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expedicao`
--

LOCK TABLES `expedicao` WRITE;
/*!40000 ALTER TABLE `expedicao` DISABLE KEYS */;
/*!40000 ALTER TABLE `expedicao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_expedicao`
--

DROP TABLE IF EXISTS `item_expedicao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_expedicao` (
  `expedicao_numero` int NOT NULL,
  `produto_codigo` int NOT NULL,
  `quantidade` int NOT NULL,
  `preco_cobrado` decimal(8,2) NOT NULL,
  PRIMARY KEY (`expedicao_numero`,`produto_codigo`),
  KEY `produto_codigo` (`produto_codigo`),
  CONSTRAINT `item_expedicao_ibfk_1` FOREIGN KEY (`expedicao_numero`) REFERENCES `expedicao` (`numero`),
  CONSTRAINT `item_expedicao_ibfk_2` FOREIGN KEY (`produto_codigo`) REFERENCES `produto` (`codigo`),
  CONSTRAINT `item_expedicao_chk_1` CHECK ((`quantidade` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Produtos de cada expedição';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_expedicao`
--

LOCK TABLES `item_expedicao` WRITE;
/*!40000 ALTER TABLE `item_expedicao` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_expedicao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordem_producao`
--

DROP TABLE IF EXISTS `ordem_producao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_producao` (
  `numero` int NOT NULL AUTO_INCREMENT,
  `data_ordem` date NOT NULL,
  `qtd_planejada` int NOT NULL,
  `qtd_boa` int NOT NULL,
  `qtd_refugo` int NOT NULL,
  `consumo_kg` decimal(8,2) NOT NULL,
  `unidade_codigo` int NOT NULL,
  `produto_codigo` int NOT NULL,
  PRIMARY KEY (`numero`),
  KEY `unidade_codigo` (`unidade_codigo`),
  KEY `produto_codigo` (`produto_codigo`),
  CONSTRAINT `ordem_producao_ibfk_1` FOREIGN KEY (`unidade_codigo`) REFERENCES `unidade` (`codigo`),
  CONSTRAINT `ordem_producao_ibfk_2` FOREIGN KEY (`produto_codigo`) REFERENCES `produto` (`codigo`),
  CONSTRAINT `ordem_producao_chk_1` CHECK ((`qtd_planejada` > 0)),
  CONSTRAINT `ordem_producao_chk_2` CHECK ((`qtd_boa` >= 0)),
  CONSTRAINT `ordem_producao_chk_3` CHECK ((`qtd_refugo` >= 0)),
  CONSTRAINT `ordem_producao_chk_4` CHECK ((`consumo_kg` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Ordens de produção';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordem_producao`
--

LOCK TABLES `ordem_producao` WRITE;
/*!40000 ALTER TABLE `ordem_producao` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_producao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `preco_tabela` decimal(8,2) NOT NULL,
  `resina_codigo` int NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE KEY `nome` (`nome`),
  KEY `resina_codigo` (`resina_codigo`),
  CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`resina_codigo`) REFERENCES `resina` (`codigo`),
  CONSTRAINT `produto_chk_1` CHECK ((`preco_tabela` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Catálogo de produtos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

LOCK TABLES `produto` WRITE;
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` VALUES (1,'Pote 500 ml',0.45,2),(2,'Tampa 80 mm',0.12,2),(3,'Garrafa 1 L',0.60,3),(4,'Tampa 28 mm',0.08,1),(5,'Balde 5 L',3.20,1);
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resina`
--

DROP TABLE IF EXISTS `resina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resina` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tipos de resina';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resina`
--

LOCK TABLES `resina` WRITE;
/*!40000 ALTER TABLE `resina` DISABLE KEYS */;
INSERT INTO `resina` VALUES (1,'PEAD'),(3,'PET'),(2,'PP'),(4,'PVC');
/*!40000 ALTER TABLE `resina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unidade`
--

DROP TABLE IF EXISTS `unidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unidade` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `cidade` varchar(60) NOT NULL,
  `telefone` varchar(15) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Unidades fabris';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unidade`
--

LOCK TABLES `unidade` WRITE;
/*!40000 ALTER TABLE `unidade` DISABLE KEYS */;
INSERT INTO `unidade` VALUES (1,'Tabuleiro','Maceió','82 3000-0001'),(2,'Agreste','Arapiraca','82 3000-0002'),(3,'Litoral','Marechal Deodoro','82 3000-0003');
/*!40000 ALTER TABLE `unidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'embalagens'
--

--
-- Dumping routines for database 'embalagens'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-16  8:29:41
