-- MariaDB dump 10.17  Distrib 10.4.10-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: bank
-- ------------------------------------------------------
-- Server version	10.4.10-MariaDB
CREATE DATABASE /*!32312 IF NOT EXISTS*/`bank` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `bank`;
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `account_number` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `branch_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `balance` float DEFAULT NULL,
  PRIMARY KEY (`account_number`),
  KEY `branch_name` (`branch_name`),
  CONSTRAINT `account_ibfk_1` FOREIGN KEY (`branch_name`) REFERENCES `branch` (`branch_name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES ('1','SUT',150),('3','Mall',200);
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrower`
--

DROP TABLE IF EXISTS `borrower`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `borrower` (
  `loan_number` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `customer_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`loan_number`,`customer_name`),
  KEY `customer_name` (`customer_name`),
  CONSTRAINT `borrower_ibfk_1` FOREIGN KEY (`loan_number`) REFERENCES `loan` (`loan_number`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `borrower_ibfk_2` FOREIGN KEY (`customer_name`) REFERENCES `customer` (`customer_name`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrower`
--

LOCK TABLES `borrower` WRITE;
/*!40000 ALTER TABLE `borrower` DISABLE KEYS */;
INSERT INTO `borrower` VALUES ('101','Dang'),('103','Dang');
/*!40000 ALTER TABLE `borrower` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branch` (
  `branch_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `branch_city` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assets` int(11) DEFAULT NULL,
  PRIMARY KEY (`branch_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES ('Mall','Korat',1000000),('SUT','Korat',2000000);
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `customer_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `customer_street` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `customer_city` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`customer_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('Dang','Univ','Korat'),('Som','Mitr-Pab','Korat');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `depositor`
--

DROP TABLE IF EXISTS `depositor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `depositor` (
  `account_number` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `customer_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`account_number`,`customer_name`),
  KEY `customer_name` (`customer_name`),
  CONSTRAINT `depositor_ibfk_1` FOREIGN KEY (`account_number`) REFERENCES `account` (`account_number`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `depositor_ibfk_2` FOREIGN KEY (`customer_name`) REFERENCES `customer` (`customer_name`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `depositor`
--

LOCK TABLES `depositor` WRITE;
/*!40000 ALTER TABLE `depositor` DISABLE KEYS */;
/*!40000 ALTER TABLE `depositor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan`
--

DROP TABLE IF EXISTS `loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loan` (
  `loan_number` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `branch_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `amount` float DEFAULT NULL,
  PRIMARY KEY (`loan_number`),
  KEY `branch_name` (`branch_name`),
  CONSTRAINT `loan_ibfk_1` FOREIGN KEY (`branch_name`) REFERENCES `branch` (`branch_name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan`
--

LOCK TABLES `loan` WRITE;
/*!40000 ALTER TABLE `loan` DISABLE KEYS */;
INSERT INTO `loan` VALUES ('101','SUT',2000),('103','Mall',5000);
/*!40000 ALTER TABLE `loan` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-02-24 18:08:52
