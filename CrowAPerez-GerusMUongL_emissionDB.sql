-- MySQL dump 10.13  Distrib 8.0.33, for macos13 (arm64)
--
-- Host: 127.0.0.1    Database: emissiondb
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Table structure for table `climate`
--

DROP TABLE IF EXISTS `climate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `climate` (
  `climateID` int NOT NULL AUTO_INCREMENT,
  `country` enum('Canada','Mexico','United States') DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `avgRain_cm` double DEFAULT NULL,
  `avgTemp_c` double DEFAULT NULL,
  PRIMARY KEY (`climateID`),
  KEY `country` (`country`),
  CONSTRAINT `climate_ibfk_1` FOREIGN KEY (`country`) REFERENCES `country` (`countryName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `climate`
--

LOCK TABLES `climate` WRITE;
/*!40000 ALTER TABLE `climate` DISABLE KEYS */;
INSERT INTO `climate` VALUES (1,'United States','temperate',76.73,11.5),(2,'Canada','temperate',101.6,20),(3,'Mexico','temperate',101.6,20.6);
/*!40000 ALTER TABLE `climate` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `only_one_climate` BEFORE INSERT ON `climate` FOR EACH ROW BEGIN

	DECLARE clim_count INT;
    
    SET clim_count = (SELECT COUNT(*) FROM climate WHERE country=NEW.country);
    IF clim_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only one climate per country.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `companyName` varchar(50) NOT NULL,
  `industrySector` varchar(50) DEFAULT NULL,
  `country` enum('Canada','Mexico','United States') DEFAULT NULL,
  `emissionType` int DEFAULT NULL,
  `emissionAmount_mmt` double DEFAULT NULL,
  PRIMARY KEY (`companyName`),
  KEY `country` (`country`),
  KEY `emissionType` (`emissionType`),
  CONSTRAINT `company_ibfk_1` FOREIGN KEY (`country`) REFERENCES `country` (`countryName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `company_ibfk_2` FOREIGN KEY (`emissionType`) REFERENCES `emission` (`emissionID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES ('American Electric Power','electricity','United States',1,130),('New Gold Inc.','mining','Canada',2,96),('Pemex','oil','Mexico',1,60.1),('Skyline Landfill','waste','United States',4,20.515),('Syncrude Canada LTD','oil','Canada',3,12.25);
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complianceAction`
--

DROP TABLE IF EXISTS `complianceAction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complianceAction` (
  `actionID` int NOT NULL AUTO_INCREMENT,
  `companyName` varchar(50) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`actionID`),
  KEY `companyName` (`companyName`),
  CONSTRAINT `complianceaction_ibfk_1` FOREIGN KEY (`companyName`) REFERENCES `company` (`companyName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complianceAction`
--

LOCK TABLES `complianceAction` WRITE;
/*!40000 ALTER TABLE `complianceAction` DISABLE KEYS */;
INSERT INTO `complianceAction` VALUES (1,'American Electric Power','Renewable energy investments. They have committed to reducing their carbon dioxide emissions by 80% by the year 2050, based on 2000 emission levels'),(2,'Skyline Landfill','At Skyline, sustainability encompasses three principal areas: environmental stewardship, social responsibility, and ethical governance. We ensure our decisions, policies, and procedures align with our P.R.I.D.E. values and reflect an inclusive culture.'),(3,'New Gold Inc.','Environmental Stewardship. Biodiversity Conservation'),(4,'Pemex','Pemex said Saturday that it would work with the U.S. Environmental Protection Agency (EPA) to reduce greenhouse gas emissions - especially methane - to meet ambitious international commitments.');
/*!40000 ALTER TABLE `complianceAction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `countryName` enum('Canada','Mexico','United States') NOT NULL,
  `latitude` varchar(20) DEFAULT NULL,
  `longitude` varchar(20) DEFAULT NULL,
  `populationDensity_sqm` double DEFAULT NULL,
  `count_disasters` int DEFAULT NULL,
  PRIMARY KEY (`countryName`),
  UNIQUE KEY `latitude` (`latitude`,`longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES ('Canada','56.1304° N','106.3468° W',4,8),('Mexico','23.6345° N','102.5528° W',66,4),('United States','37.0902° N','95.7129° W',94,10);
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emission`
--

DROP TABLE IF EXISTS `emission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emission` (
  `emissionID` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  `source` int DEFAULT NULL,
  `country` enum('Canada','Mexico','United States') DEFAULT NULL,
  PRIMARY KEY (`emissionID`),
  KEY `source` (`source`),
  KEY `country` (`country`),
  CONSTRAINT `emission_ibfk_1` FOREIGN KEY (`source`) REFERENCES `emissionSource` (`sourceID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `emission_ibfk_2` FOREIGN KEY (`country`) REFERENCES `country` (`countryName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emission`
--

LOCK TABLES `emission` WRITE;
/*!40000 ALTER TABLE `emission` DISABLE KEYS */;
INSERT INTO `emission` VALUES (1,'carbon dioxide',444,'United States'),(2,'carbon dioxide',445,'United States'),(3,'carbon dioxide',446,'United States'),(4,'carbon dioxide',448,'United States'),(5,'carbon dioxide',444,'United States'),(6,'carbon dioxide',445,'United States'),(7,'carbon dioxide',446,'United States'),(8,'carbon dioxide',448,'United States'),(9,'methane',444,'United States'),(10,'methane',446,'United States'),(11,'methane',448,'United States'),(12,'methane',447,'United States'),(13,'methane',445,'United States'),(14,'methane',444,'United States'),(15,'methane',446,'United States'),(16,'methane',447,'United States'),(17,'methane',448,'United States'),(18,'methane',445,'United States'),(19,'nitrous oxide',446,'United States'),(20,'nitrous oxide',444,'United States'),(21,'nitrous oxide',448,'United States'),(22,'nitrous oxide',445,'United States'),(23,'nitrous oxide',447,'United States'),(24,'nitrous oxide',446,'United States'),(25,'nitrous oxide',444,'United States'),(26,'nitrous oxide',448,'United States'),(27,'nitrous oxide',445,'United States'),(28,'nitrous oxide',447,'United States'),(29,'carbon dioxide',444,'Canada'),(30,'carbon dioxide',445,'Canada'),(31,'carbon dioxide',446,'Canada'),(32,'carbon dioxide',448,'Canada'),(33,'carbon dioxide',444,'Canada'),(34,'carbon dioxide',445,'Canada'),(35,'carbon dioxide',446,'Canada'),(36,'carbon dioxide',448,'Canada'),(37,'methane',444,'Canada'),(38,'methane',446,'Canada'),(39,'methane',448,'Canada'),(40,'methane',447,'Canada'),(41,'methane',445,'Canada'),(42,'methane',444,'Canada'),(43,'methane',446,'Canada'),(44,'methane',447,'Canada'),(45,'methane',448,'Canada'),(46,'methane',445,'Canada'),(47,'nitrous oxide',446,'Canada'),(48,'nitrous oxide',444,'Canada'),(49,'nitrous oxide',448,'Canada'),(50,'nitrous oxide',445,'Canada'),(51,'nitrous oxide',447,'Canada'),(52,'nitrous oxide',446,'Canada'),(53,'nitrous oxide',444,'Canada'),(54,'nitrous oxide',448,'Canada'),(55,'nitrous oxide',445,'Canada'),(56,'nitrous oxide',447,'Canada'),(57,'carbon dioxide',444,'Mexico'),(58,'carbon dioxide',445,'Mexico'),(59,'carbon dioxide',446,'Mexico'),(60,'carbon dioxide',448,'Mexico'),(61,'carbon dioxide',444,'Mexico'),(62,'carbon dioxide',445,'Mexico'),(63,'carbon dioxide',446,'Mexico'),(64,'carbon dioxide',448,'Mexico'),(65,'methane',444,'Mexico'),(66,'methane',446,'Mexico'),(67,'methane',448,'Mexico'),(68,'methane',447,'Mexico'),(69,'methane',445,'Mexico'),(70,'methane',444,'Mexico'),(71,'methane',446,'Mexico'),(72,'methane',447,'Mexico'),(73,'methane',448,'Mexico'),(74,'methane',445,'Mexico'),(75,'nitrous oxide',446,'Mexico'),(76,'nitrous oxide',444,'Mexico'),(77,'nitrous oxide',448,'Mexico'),(78,'nitrous oxide',445,'Mexico'),(79,'nitrous oxide',447,'Mexico'),(80,'nitrous oxide',446,'Mexico'),(81,'nitrous oxide',444,'Mexico'),(82,'nitrous oxide',448,'Mexico'),(83,'nitrous oxide',445,'Mexico'),(84,'nitrous oxide',447,'Mexico'),(85,'coal',449,'United States'),(86,'chemical',450,'Canada');
/*!40000 ALTER TABLE `emission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emissionMeasurement`
--

DROP TABLE IF EXISTS `emissionMeasurement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emissionMeasurement` (
  `emID` int NOT NULL,
  `emissionID` int DEFAULT NULL,
  `measurementValue_mt` double DEFAULT NULL,
  `measurementDate` date DEFAULT NULL,
  `waterBody` int DEFAULT NULL,
  PRIMARY KEY (`emID`),
  KEY `emissionID` (`emissionID`),
  KEY `waterBody` (`waterBody`),
  CONSTRAINT `emissionmeasurement_ibfk_1` FOREIGN KEY (`emissionID`) REFERENCES `emission` (`emissionID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `emissionmeasurement_ibfk_2` FOREIGN KEY (`waterBody`) REFERENCES `waterBody` (`waterID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emissionMeasurement`
--

LOCK TABLES `emissionMeasurement` WRITE;
/*!40000 ALTER TABLE `emissionMeasurement` DISABLE KEYS */;
INSERT INTO `emissionMeasurement` VALUES (1,1,5361.21,'2021-05-04',NULL),(2,2,176.936,'2021-05-04',NULL),(3,3,7.97,'2021-05-04',2),(4,4,-853.78,'2021-05-04',3),(5,1,6666.556,'2021-06-01',NULL),(6,2,189.665,'2021-06-01',NULL),(7,3,10.252,'2021-06-01',4),(8,4,-866.45,'2021-06-01',5),(9,10,364.785,'2021-05-04',NULL),(10,10,264.86,'2021-05-04',2),(11,15,153.873,'2021-05-04',3),(12,12,55.672,'2021-05-04',NULL),(13,13,0.087,'2021-05-04',NULL),(14,17,351.26,'2021-06-01',NULL),(15,15,264.291,'2021-06-01',4),(16,9,155.626,'2021-06-01',NULL),(17,17,56.959,'2021-06-01',5),(18,9,0.108,'2021-06-01',NULL),(19,19,309.539,'2021-05-04',2),(20,20,57.736,'2021-05-04',NULL),(21,28,20.254,'2021-05-04',3),(22,22,24.734,'2021-05-04',NULL),(23,19,6.814,'2021-05-04',NULL),(24,24,207.958,'2021-05-04',4),(25,27,53.428,'2021-06-01',NULL),(26,20,20.939,'2021-06-01',5),(27,20,19.996,'2021-06-01',NULL),(28,28,6.832,'2021-06-01',NULL),(29,29,649.056,'2021-05-04',NULL),(30,30,21.207,'2021-05-04',NULL),(31,31,0.96,'2021-05-04',10),(32,32,-103.36,'2021-05-04',10),(33,33,624.628,'2021-06-01',NULL),(34,34,21.1136,'2021-06-01',NULL),(35,35,1.2736,'2021-06-01',8),(36,36,-102.83,'2021-06-01',8),(37,37,44.06,'2021-05-04',NULL),(38,38,31.32,'2021-05-04',10),(39,39,18.53,'2021-05-04',10),(40,40,6.74,'2021-05-04',NULL),(41,41,0.01,'2021-05-04',NULL),(42,42,42.49,'2021-06-01',10),(43,43,31.961,'2021-06-01',10),(44,44,18.765,'2021-06-01',NULL),(45,45,6.779,'2021-06-01',NULL),(46,46,0.012,'2021-06-01',NULL),(47,47,50.665,'2021-05-04',7),(48,48,10.665,'2021-05-04',NULL),(49,49,3.456,'2021-05-04',7),(50,50,5.67,'2021-05-04',NULL),(51,51,0.324,'2021-05-04',NULL),(52,52,37.889,'2021-06-01',NULL),(53,53,6.468,'2021-06-01',NULL),(54,54,2.534,'2021-06-01',7),(55,55,2.42,'2021-06-01',NULL),(56,56,0.827,'2021-06-01',NULL),(57,57,682.06,'2021-05-04',NULL),(58,58,22.39,'2021-05-04',NULL),(59,59,1.01,'2021-05-04',1),(60,60,-108.534,'2021-05-04',1),(61,61,848.091,'2021-06-01',NULL),(62,62,24.045,'2021-06-01',1),(63,63,1.272,'2021-06-01',1),(64,64,-110.178,'2021-06-01',NULL),(65,65,46.31,'2021-05-04',NULL),(66,66,33.587,'2021-05-04',9),(67,67,19.576,'2021-05-04',9),(68,68,69.557,'2021-05-04',NULL),(69,69,0.011,'2021-05-04',NULL),(70,70,44.656,'2021-06-01',NULL),(71,71,33.587,'2021-06-01',8),(72,72,19.72,'2021-06-01',8),(73,73,7.124,'2021-06-01',NULL),(74,74,0.037,'2021-06-01',NULL),(75,75,39.312,'2021-05-04',9),(76,76,7.251,'2021-05-04',NULL),(77,77,2.544,'2021-05-04',9),(78,78,3.053,'2021-05-04',NULL),(79,79,0.866,'2021-05-04',NULL),(80,80,26.335,'2021-06-01',1),(81,81,6.767,'2021-06-01',NULL),(82,82,2.67,'2021-06-01',1),(83,83,2.529,'2021-06-01',NULL),(84,84,0.763,'2021-06-01',NULL);
/*!40000 ALTER TABLE `emissionMeasurement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emissionSource`
--

DROP TABLE IF EXISTS `emissionSource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emissionSource` (
  `sourceID` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`sourceID`)
) ENGINE=InnoDB AUTO_INCREMENT=451 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emissionSource`
--

LOCK TABLES `emissionSource` WRITE;
/*!40000 ALTER TABLE `emissionSource` DISABLE KEYS */;
INSERT INTO `emissionSource` VALUES (444,'energy'),(445,'industrial processes'),(446,'agriculture'),(447,'land use'),(448,'waste'),(449,'mining'),(450,'fishing');
/*!40000 ALTER TABLE `emissionSource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GDPperCapita`
--

DROP TABLE IF EXISTS `GDPperCapita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GDPperCapita` (
  `countryName` enum('Canada','Mexico','United States') NOT NULL,
  `GDPcapita_USD` double NOT NULL,
  `year` year NOT NULL,
  PRIMARY KEY (`countryName`,`GDPcapita_USD`,`year`),
  CONSTRAINT `gdppercapita_ibfk_1` FOREIGN KEY (`countryName`) REFERENCES `country` (`countryName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GDPperCapita`
--

LOCK TABLES `GDPperCapita` WRITE;
/*!40000 ALTER TABLE `GDPperCapita` DISABLE KEYS */;
INSERT INTO `GDPperCapita` VALUES ('Canada',42315.6,2016),('Canada',43258.3,2020),('Canada',43596.1,2015),('Canada',45129.4,2017),('Canada',46328.7,2019),('Canada',46548.6,2018),('Canada',50956,2014),('Canada',51987.9,2021),('Canada',52223.7,2011),('Canada',52635.2,2013),('Canada',52669.1,2012),('Mexico',8655,2020),('Mexico',8875.1,2016),('Mexico',9434.4,2017),('Mexico',9753.4,2015),('Mexico',9857,2018),('Mexico',10145.2,2019),('Mexico',10341.5,2011),('Mexico',10376.1,2012),('Mexico',10865.7,2013),('Mexico',11076.1,2014),('United States',50066,2011),('United States',51784.4,2012),('United States',53291.1,2013),('United States',55123.8,2014),('United States',56762.7,2015),('United States',57866.7,2016),('United States',59907.8,2017),('United States',62823.3,2018),('United States',63530.6,2020),('United States',65120.4,2019),('United States',70248.6,2021);
/*!40000 ALTER TABLE `GDPperCapita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `naturalDisaster`
--

DROP TABLE IF EXISTS `naturalDisaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `naturalDisaster` (
  `ndID` int NOT NULL AUTO_INCREMENT,
  `country` enum('Canada','Mexico','United States') DEFAULT NULL,
  `type` enum('tornado','flood','winter storm','earthquake','hurricane','wildfire','heat wave') DEFAULT NULL,
  `ndDate` date DEFAULT NULL,
  `economicLoss_bil` decimal(18,2) DEFAULT NULL,
  `deathCount` int DEFAULT NULL,
  PRIMARY KEY (`ndID`),
  KEY `country` (`country`),
  CONSTRAINT `naturaldisaster_ibfk_1` FOREIGN KEY (`country`) REFERENCES `country` (`countryName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `naturalDisaster`
--

LOCK TABLES `naturalDisaster` WRITE;
/*!40000 ALTER TABLE `naturalDisaster` DISABLE KEYS */;
INSERT INTO `naturalDisaster` VALUES (1,'United States','flood','2021-01-01',2.50,20),(2,'United States','tornado','2021-02-06',11.00,346),(3,'United States','hurricane','2021-08-26',75.00,147),(4,'United States','wildfire','2021-06-02',8.00,3),(5,'United States','hurricane','2021-07-04',15.09,49),(6,'United States','hurricane','2021-09-15',91.62,3059),(7,'United States','wildfire','2021-08-11',16.50,85),(8,'United States','earthquake','2021-08-01',5.30,1),(9,'United States','heat wave','2021-05-07',8.90,229),(10,'United States','flood','2021-09-08',7.50,5),(11,'Canada','tornado','2021-04-21',1.20,1),(12,'Canada','flood','2021-08-08',5.00,5),(13,'Canada','wildfire','2021-07-06',0.70,10),(14,'Canada','wildfire','2021-04-04',9.90,3),(15,'Canada','flood','2021-03-22',0.30,2),(16,'Canada','heat wave','2021-06-06',0.10,NULL),(17,'Canada','tornado','2021-09-09',0.30,31),(18,'Canada','heat wave','2021-06-20',NULL,685),(19,'Mexico','earthquake','2021-05-04',8.20,NULL),(20,'Mexico','earthquake','2021-05-05',3.70,12),(21,'Mexico','wildfire','2021-10-10',2.20,10),(22,'Mexico','earthquake','2021-11-11',9.20,50);
/*!40000 ALTER TABLE `naturalDisaster` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `disaster_insert` AFTER INSERT ON `naturaldisaster` FOR EACH ROW BEGIN
	UPDATE country
    SET count_disasters = count_disasters + 1
    WHERE country.countryName = New.country;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `disaster_delete` AFTER DELETE ON `naturaldisaster` FOR EACH ROW BEGIN
	UPDATE country
    SET count_disasters = count_disasters - 1
    WHERE country.countryName = Old.country;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `preventionMethod`
--

DROP TABLE IF EXISTS `preventionMethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preventionMethod` (
  `methodName` varchar(50) NOT NULL,
  `naturalDisaster` int NOT NULL,
  PRIMARY KEY (`methodName`,`naturalDisaster`),
  KEY `naturalDisaster` (`naturalDisaster`),
  CONSTRAINT `preventionmethod_ibfk_1` FOREIGN KEY (`naturalDisaster`) REFERENCES `naturalDisaster` (`ndID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preventionMethod`
--

LOCK TABLES `preventionMethod` WRITE;
/*!40000 ALTER TABLE `preventionMethod` DISABLE KEYS */;
INSERT INTO `preventionMethod` VALUES ('diversion and storage',1),('prescribed burning',7),('diversion and storage',10),('diversion and storage',12),('prescribed burning',14);
/*!40000 ALTER TABLE `preventionMethod` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waterBody`
--

DROP TABLE IF EXISTS `waterBody`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waterBody` (
  `waterID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `bordersUS` tinyint(1) DEFAULT NULL,
  `bordersCA` tinyint(1) DEFAULT NULL,
  `bordersMX` tinyint(1) DEFAULT NULL,
  `pollutionType` int DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`waterID`),
  KEY `pollutionType` (`pollutionType`),
  CONSTRAINT `waterbody_ibfk_1` FOREIGN KEY (`pollutionType`) REFERENCES `emission` (`emissionID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waterBody`
--

LOCK TABLES `waterBody` WRITE;
/*!40000 ALTER TABLE `waterBody` DISABLE KEYS */;
INSERT INTO `waterBody` VALUES (1,'Atlantic Ocean','ocean',1,1,1,NULL,NULL),(2,'Mississippi River','river',1,0,0,NULL,NULL),(3,'Lake Michigan','lake',1,0,0,NULL,NULL),(4,'Lake Superior','lake',1,1,0,NULL,NULL),(5,'Lake Huron','lake',1,1,0,NULL,NULL),(6,'Lake Erie','lake',1,1,0,NULL,NULL),(7,'Lake Ontario','lake',1,1,0,NULL,NULL),(8,'Pacific Ocean','ocean',1,1,1,NULL,NULL),(9,'Gulf of Mexico','ocean',1,0,1,NULL,NULL),(10,'Arctic Ocean','ocean',0,1,0,NULL,NULL);
/*!40000 ALTER TABLE `waterBody` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'emissiondb'
--

--
-- Dumping routines for database 'emissiondb'
--
/*!50003 DROP FUNCTION IF EXISTS `biggerGDP` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `biggerGDP`(country1 ENUM('Canada', 'Mexico', 'United States'), 
							country2 ENUM('Canada', 'Mexico', 'United States'), year_chosen YEAR) RETURNS int
    DETERMINISTIC
BEGIN
			DECLARE gdp_1 INT;
            DECLARE gdp_2 INT;
            
            SELECT GDPcapita_USD INTO gdp_1 
            FROM GDPperCapita 
			WHERE countryName = country1 AND year = year_chosen;

			SELECT GDPcapita_USD INTO gdp_2
            FROM GDPperCapita 
			WHERE countryName = country2 AND year = year_chosen;
            
		IF gdp_1  > gdp_2 THEN
			RETURN 1;
        
		ELSEIF gdp_1  = gdp_2 THEN
			RETURN 0;
		
        ELSE
			RETURN -1;
        
        END IF;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `countryWithMostEmission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `countryWithMostEmission`() RETURNS varchar(50) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE maxTotal DOUBLE;
    DECLARE maxCountry VARCHAR(50);

    SELECT MAX(total) INTO maxTotal
    FROM (
        SELECT countryName, SUM(em.measurementValue_mt) AS total
        FROM emissionMeasurement AS em
        INNER JOIN emission AS e ON em.emissionID = e.emissionID
        INNER JOIN country AS c ON e.country = c.countryName
        GROUP BY countryName
    ) AS subquery;

    SELECT countryName INTO maxCountry
    FROM (
        SELECT countryName, SUM(em.measurementValue_mt) AS total
        FROM emissionMeasurement AS em
        INNER JOIN emission e ON em.emissionID = e.emissionID
        INNER JOIN country c ON e.country = c.countryName
        GROUP BY countryName
    ) AS subquery
    WHERE total = maxTotal;

    RETURN maxCountry;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `highestEmissionSource` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `highestEmissionSource`(source1 INT, source2 INT) RETURNS varchar(50) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE emissionTotal1 DOUBLE;
    DECLARE emisionTotal2 DOUBLE;
    DECLARE result VARCHAR(50);

    SELECT SUM(em.measurementValue_mt) INTO emissionTotal1
    FROM emissionMeasurement AS em
    INNER JOIN emission AS e ON em.emissionID = e.emissionID
    WHERE e.source = source1;

    SELECT SUM(em.measurementValue_mt) INTO emisionTotal2
    FROM emissionMeasurement AS em
    INNER JOIN emission AS e ON em.emissionID = e.emissionID
    WHERE e.source = source2;

    IF emissionTotal1 > emisionTotal2 THEN
        SET result = (SELECT type FROM emissionSource WHERE sourceID = source1);
    ELSEIF total2 > total1 THEN
        SET result = (SELECT type FROM emissionSource WHERE sourceID = source2);
    ELSE
        SET result = 'Both sources generated the same amount of emission.';
    END IF;

    RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `numClimate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `numClimate`(climate_type VARCHAR(50)) RETURNS int
    DETERMINISTIC
BEGIN 
		DECLARE ret_int INT;
		SELECT COUNT(*) INTO ret_int
		FROM climate
		WHERE type = climate_type;
		RETURN (ret_int);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `pollutedWater` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `pollutedWater`(water_body_p VARCHAR(64)) RETURNS int
    DETERMINISTIC
BEGIN
		DECLARE polluted_count INT;

		SELECT COUNT(*) INTO polluted_count
		FROM emissionMeasurement em
        JOIN waterBody wb ON  wb.waterID = em.waterBody
        WHERE wb.name = water_body_p;
        
        RETURN polluted_count;
        
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createEmissionSource` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createEmissionSource`(IN s_type VARCHAR(50), IN e_type VARCHAR(50), IN c_name 
	ENUM('Canada', 'Mexico', 'United States'), IN c_lat VARCHAR(20), IN c_long VARCHAR(20), IN c_pd DOUBLE)
BEGIN
	DECLARE s_count INT;
	DECLARE e_count INT;
	DECLARE c_count INT;
    
    DECLARE new_sid INT;
    
    SELECT COUNT(*) INTO s_count 
            FROM emissionSource
            WHERE type = s_type;
            
	  SELECT COUNT(*) INTO e_count 
            FROM emission
            WHERE type = e_type;
            
	  SELECT COUNT(*) INTO c_count 
            FROM country
            WHERE countryName = c_name ;
    
		IF s_count = 0 THEN -- No source in the table 
			INSERT INTO emissionSource(type) 
            VALUES (s_type); 
            END IF;
            
            SELECT sourceID INTO new_sid FROM emissionSource 
            WHERE type = s_type LIMIT 1; 
            
            IF e_count = 0 THEN -- emission not in table already
            INSERT INTO emission(type, source, country) 
            VALUES (e_type, new_sid, c_name);
            END IF;
            
            IF c_count = 0 THEN
            INSERT INTO country(countryName, latitude, longitude, populationDensity_sqm) 
            VALUES (c_name, c_lat, c_long, c_pd);
            END IF; 
            
            
            END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `emissionsSector` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `emissionsSector`(IN sector_p VARCHAR(64))
BEGIN
    SELECT SUM(measurementValue_mt) total_emissions, e.country
		FROM emissionMeasurement em
		JOIN emission e ON e.emissionID = em.emissionID
		JOIN emissionSource es ON es.sourceID = e.source
		WHERE es.type = sector_p 
		GROUP BY e.country;
        
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `every_country` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `every_country`()
BEGIN
	DECLARE disasters INT;
	DECLARE no_row BOOL;
	DECLARE country_cur CURSOR FOR SELECT countryName FROM country;
    DECLARE EXIT HANDLER FOR NOT FOUND
		SET no_row = TRUE;
    
    SET no_row = FALSE;
    
    OPEN country_cur;
    
    WHILE no_row = FALSE DO
		FETCH country_cur INTO disasters;
        CALL intialize_num_disasters(disasters);
        END WHILE;
    
    CLOSE country_cur;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `intialize_num_disasters` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `intialize_num_disasters`(IN country_name ENUM('Canada', 'Mexico', 'United States'))
BEGIN
    DECLARE count_d INT;
    
    SELECT COUNT(*) INTO count_d
    FROM naturalDisaster
    WHERE country = country_name;
    
    UPDATE country
    SET count_disasters = count_d 
    WHERE countryName = country_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `naturalDisasterCasualties` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `naturalDisasterCasualties`()
BEGIN
    SELECT type, SUM(deathCount) AS totalCasualties
    FROM naturalDisaster
    GROUP BY type;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `totalEmissions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `totalEmissions`()
BEGIN
    SELECT country, SUM(measurementValue_mt) AS total_emissions 
			FROM emission e 
			JOIN emissionMeasurement em ON
            e.emissionID = em.emissionID
            GROUP BY country
            ORDER BY total_emissions DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-21 21:52:37
