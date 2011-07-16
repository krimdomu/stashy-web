-- MySQL dump 10.13  Distrib 5.1.57, for apple-darwin10.7.0 (i386)
--
-- Host: localhost    Database: stashy
-- ------------------------------------------------------
-- Server version	5.1.57

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
-- Table structure for table `baseboard`
--

DROP TABLE IF EXISTS `baseboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `baseboard` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `systems_id` int(10) unsigned NOT NULL,
  `serialnumber` varchar(100) DEFAULT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `systems_id` (`systems_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baseboard`
--

LOCK TABLES `baseboard` WRITE;
/*!40000 ALTER TABLE `baseboard` DISABLE KEYS */;
/*!40000 ALTER TABLE `baseboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cpus`
--

DROP TABLE IF EXISTS `cpus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cpus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `systems_id` int(10) unsigned DEFAULT NULL,
  `family` varchar(100) DEFAULT NULL,
  `speed` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `systems_id` (`systems_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cpus`
--

LOCK TABLES `cpus` WRITE;
/*!40000 ALTER TABLE `cpus` DISABLE KEYS */;
/*!40000 ALTER TABLE `cpus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dimms`
--

DROP TABLE IF EXISTS `dimms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dimms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `systems_id` int(10) unsigned DEFAULT NULL,
  `serial_number` varchar(50) DEFAULT NULL,
  `locator` varchar(50) DEFAULT NULL,
  `size` int(10) unsigned DEFAULT NULL,
  `part_number` varchar(100) DEFAULT NULL,
  `speed` int(10) unsigned DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `form_factor` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `systems_id` (`systems_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimms`
--

LOCK TABLES `dimms` WRITE;
/*!40000 ALTER TABLE `dimms` DISABLE KEYS */;
/*!40000 ALTER TABLE `dimms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `network_device_configuration`
--

DROP TABLE IF EXISTS `network_device_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `network_device_configuration` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eth_id` int(10) unsigned DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `netmask` varchar(50) DEFAULT NULL,
  `broadcast` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eth_id` (`eth_id`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `network_device_configuration`
--

LOCK TABLES `network_device_configuration` WRITE;
/*!40000 ALTER TABLE `network_device_configuration` DISABLE KEYS */;
/*!40000 ALTER TABLE `network_device_configuration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `network_devices`
--

DROP TABLE IF EXISTS `network_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `network_devices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `systems_id` int(10) unsigned DEFAULT NULL,
  `dev` varchar(25) DEFAULT NULL,
  `product` varchar(100) DEFAULT NULL,
  `mac` varchar(17) DEFAULT NULL,
  `vendor` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `systems_id` (`systems_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `network_devices`
--

LOCK TABLES `network_devices` WRITE;
/*!40000 ALTER TABLE `network_devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `network_devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `systems`
--

DROP TABLE IF EXISTS `systems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `systems` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hostname` varchar(100) DEFAULT NULL,
  `domainname` varchar(200) DEFAULT NULL,
  `added` datetime DEFAULT NULL,
  `os` varchar(150) DEFAULT NULL,
  `osrelease` varchar(20) DEFAULT NULL,
  `product_name` varchar(150) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `hostname` (`hostname`),
  KEY `added` (`added`),
  KEY `hostname_domainname` (`hostname`,`domainname`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `systems`
--

LOCK TABLES `systems` WRITE;
/*!40000 ALTER TABLE `systems` DISABLE KEYS */;
/*!40000 ALTER TABLE `systems` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-07-16 20:52:31
