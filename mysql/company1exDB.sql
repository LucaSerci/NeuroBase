CREATE DATABASE  IF NOT EXISTS `company1exdb` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `company1exdb`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: company1exdb
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `CustomerID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` text,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Customer 1','customer.1@example.com','+1-452-735-2289','598 Main St, City 1'),(2,'Customer 2','customer.2@example.com','+1-893-374-5643','555 Main St, City 2'),(3,'Customer 3','customer.3@example.com','+1-632-625-2815','946 Main St, City 3'),(4,'Customer 4','customer.4@example.com','+1-962-262-3368','344 Main St, City 4'),(5,'John Doe','customer.5@example.com','+1 123-123-7894','875 Main St, City 5'),(6,'Customer 6','customer.6@example.com','+1-745-934-5891','947 Main St, City 6'),(7,'Customer 7','customer.7@example.com','+1-592-903-2592','159 Main St, City 7'),(8,'Customer 8','customer.8@example.com','+1-883-475-2935','648 Main St, City 8'),(9,'Customer 9','customer.9@example.com','+1-446-523-8890','877 Main St, City 9'),(10,'Customer 10','customer.10@example.com','+1-228-629-4332','733 Main St, City 10'),(11,'Customer 11','customer.11@example.com','+1-228-629-9999','733 Not-Main St, City 11'),(32,'Minecraft Steve','steve@mojang.com','+1 123 123 1234','Overworld');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `EmployeeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Role` enum('Manager','Sales','Production','Delivery','Technician') DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `HireDate` date DEFAULT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Employee 1','Sales','employee.1@example.com','+1-983-647-7199','2022-06-21'),(2,'Employee 2','Delivery','employee.2@example.com','+1-609-323-6748','2019-07-14'),(3,'Employee 3','Technician','employee.3@example.com','+1-296-233-2194','2018-07-07'),(4,'Employee 4','Sales','employee.4@example.com','+1-310-634-8859','2021-12-10'),(5,'Employee 5','Delivery','employee.5@example.com','+1-530-376-7554','2022-11-24'),(6,'Employee 6','Manager','employee.6@example.com','+1-891-870-2554','2019-11-19'),(7,'Employee 7','Production','employee.7@example.com','+1-204-522-8311','2020-01-06'),(8,'Employee 8','Manager','employee.8@example.com','+1-624-393-5324','2021-03-10'),(9,'Employee 9','Manager','employee.9@example.com','+1-575-637-8188','2020-11-25'),(10,'Employee 10','Delivery','employee.10@example.com','+1-330-591-7163','2022-03-05');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `MaterialID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `MaterialType` enum('Glass','Frame','Hardware','Sealant') DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Unit` varchar(50) DEFAULT NULL,
  `SupplierID` int NOT NULL,
  PRIMARY KEY (`MaterialID`),
  KEY `SupplierID` (`SupplierID`),
  CONSTRAINT `SupplierIDtoInventory` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,'Handle','Hardware',255,'pcs',3),(2,'Hinge','Hardware',134,'pcs',3),(3,'Gasket','Hardware',236,'pcs',3),(4,'Lock','Hardware',221,'pcs',3),(5,'Latch','Hardware',382,'pcs',3),(6,'Knob','Hardware',224,'pcs',3),(7,'Strike Plate','Hardware',266,'pcs',3),(8,'Roller','Hardware',219,'pcs',3),(9,'Track','Hardware',129,'pcs',3),(10,'Weather Strip','Hardware',378,'pcs',3),(11,'Screw Set','Hardware',421,'pcs',3),(12,'Mounting Bracket','Hardware',225,'pcs',3),(13,'Latch Bolt','Hardware',307,'pcs',3),(14,'Flush Bolt','Hardware',83,'pcs',3),(15,'Slide Bolt','Hardware',330,'pcs',3),(16,'Sealing Strip','Hardware',373,'pcs',3),(17,'Arm Closer','Hardware',300,'pcs',3),(18,'Window Crank','Hardware',415,'pcs',3),(19,'Adjuster','Hardware',467,'pcs',3),(20,'Support Bar','Hardware',160,'pcs',3),(21,'Extrusion for Non-Insulated Door','Frame',114,'bars',2),(22,'Extrusion for Insulated Door','Frame',240,'bars',2),(23,'Extrusion for Non-Insulated Patio Door','Frame',254,'bars',2),(24,'Extrusion for Insulated Patio Door','Frame',119,'bars',2),(25,'Extrusion for Non-Insulated Sliding Window','Frame',234,'bars',2),(26,'Extrusion for Insulated Sliding Window','Frame',239,'bars',2),(27,'Extrusion for Non-Insulated Swinging Window','Frame',294,'bars',2),(28,'Extrusion for Insulated Swinging Window','Frame',169,'bars',2);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderdetails`
--

DROP TABLE IF EXISTS `orderdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderdetails` (
  `OrderDetailID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `ProductID` int NOT NULL,
  `Quantity` int DEFAULT NULL,
  `Subtotal` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`OrderDetailID`),
  KEY `OrderID` (`OrderID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `OrderIDtoDetails` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`),
  CONSTRAINT `ProductIDtoDetails` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderdetails`
--

LOCK TABLES `orderdetails` WRITE;
/*!40000 ALTER TABLE `orderdetails` DISABLE KEYS */;
INSERT INTO `orderdetails` VALUES (1,1,1,13,4099.03),(2,1,4,15,5486.85),(3,1,6,11,4314.86),(4,1,7,13,5300.36),(5,2,5,5,1497.35),(6,3,5,7,2096.29),(7,3,3,5,2144.90),(8,3,8,10,4497.70),(9,4,5,15,4492.05),(10,5,8,14,6296.78),(11,5,3,8,3431.84),(12,6,7,11,4484.92),(13,6,5,13,3893.11),(14,6,6,8,3138.08),(15,7,2,10,4172.00),(16,8,4,12,4389.48),(17,9,3,10,4289.80),(18,9,6,7,2745.82),(19,10,1,6,1891.86),(20,10,7,14,5708.08),(21,10,5,12,3593.64),(22,11,3,15,6434.70),(23,11,2,11,4589.20),(24,12,8,12,5397.24),(25,12,7,9,3669.48),(26,12,5,10,2994.70),(27,13,4,15,5486.85),(28,13,1,5,1576.55),(29,14,4,7,2560.53),(30,14,8,12,5397.24),(31,14,7,7,2854.04),(32,15,6,5,1961.30),(33,15,1,9,2837.79),(34,15,4,5,1828.95),(35,16,5,9,2695.23),(36,17,6,11,4314.86),(37,18,8,6,2698.62),(38,18,2,10,4172.00),(39,18,4,15,5486.85),(40,19,7,14,5708.08),(41,20,3,13,5576.74),(42,21,2,14,5840.80),(43,21,7,13,5300.36),(44,21,6,6,2353.56),(45,22,5,11,3294.17),(46,23,3,6,2573.88),(47,23,5,7,2096.29),(48,23,7,15,6115.80),(49,24,2,10,4172.00),(50,24,8,5,2248.85),(51,24,5,14,4192.58),(52,25,5,7,2096.29),(53,25,4,14,5121.06),(54,25,1,11,3468.41),(55,26,8,15,6746.55),(56,26,1,6,1891.86),(57,26,6,7,2745.82),(58,26,4,9,3292.11),(59,27,7,13,5300.36),(60,27,1,14,4414.34),(61,28,6,6,2353.56),(62,28,2,11,4589.20),(63,28,3,11,4718.78),(64,29,7,11,4484.92),(65,29,8,6,2698.62),(66,30,5,14,4192.58),(67,31,5,6,1796.82),(68,31,3,11,4718.78),(69,31,6,7,2745.82),(70,31,8,8,3598.16),(71,32,8,11,4947.47),(72,32,1,9,2837.79),(73,32,2,10,4172.00),(74,32,6,15,5883.90),(75,33,7,6,2446.32);
/*!40000 ALTER TABLE `orderdetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `CustomerID` int NOT NULL,
  `OrderDate` date DEFAULT NULL,
  `Status` enum('Pending','In Production','Shipped','Completed','Canceled') DEFAULT NULL,
  `TotalPrice` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `CustomerID` (`CustomerID`),
  CONSTRAINT `` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'2024-02-27','Completed',19201.10),(2,1,'2024-05-27','Pending',1497.35),(3,1,'2024-04-17','Completed',8738.89),(4,1,'2024-02-05','Completed',4492.05),(5,2,'2024-01-12','Pending',9728.62),(6,2,'2024-02-12','In Production',11516.11),(7,2,'2024-01-02','Completed',4172.00),(8,3,'2024-03-01','Shipped',4389.48),(9,3,'2024-04-12','In Production',7035.62),(10,3,'2024-04-11','Completed',11193.58),(11,3,'2024-04-05','Shipped',11023.90),(12,4,'2024-05-31','Pending',12061.42),(13,4,'2024-04-29','In Production',7063.40),(14,4,'2024-05-04','Completed',10811.81),(15,4,'2024-04-06','In Production',6628.04),(16,5,'2024-05-02','Shipped',2695.23),(17,5,'2024-04-03','Shipped',4314.86),(18,5,'2024-05-27','Pending',12357.47),(19,6,'2024-02-01','Pending',5708.08),(20,6,'2024-05-10','Shipped',5576.74),(21,6,'2024-02-07','Shipped',13494.72),(22,7,'2024-03-03','Pending',3294.17),(23,7,'2024-04-07','In Production',10785.97),(24,7,'2024-02-23','Shipped',10613.43),(25,8,'2024-03-23','Completed',10685.76),(26,8,'2024-02-07','Pending',14676.34),(27,8,'2024-05-14','Pending',9714.70),(28,9,'2024-03-12','In Production',11661.54),(29,9,'2024-02-21','In Production',7183.54),(30,9,'2024-05-23','In Production',4192.58),(31,10,'2024-03-14','Pending',12859.58),(32,10,'2024-05-11','In Production',17841.16),(33,10,'2024-04-10','Pending',2446.32);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productionschedule`
--

DROP TABLE IF EXISTS `productionschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productionschedule` (
  `ScheduleID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Status` enum('In Production','Completed','Delayed','Quoting') DEFAULT NULL,
  `AssignedEmployeeID` int DEFAULT NULL,
  PRIMARY KEY (`ScheduleID`),
  KEY `OrderID` (`OrderID`),
  KEY `AssignedEmployeeID` (`AssignedEmployeeID`),
  CONSTRAINT `EmployeeIDtoProduction` FOREIGN KEY (`AssignedEmployeeID`) REFERENCES `employees` (`EmployeeID`),
  CONSTRAINT `OrderIDtoProduction` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productionschedule`
--

LOCK TABLES `productionschedule` WRITE;
/*!40000 ALTER TABLE `productionschedule` DISABLE KEYS */;
INSERT INTO `productionschedule` VALUES (1,1,'2024-03-05','2024-03-17','Completed',5),(2,2,NULL,NULL,'Quoting',6),(3,3,'2024-04-24','2024-05-03','Completed',7),(4,4,NULL,NULL,'Quoting',5),(5,5,NULL,NULL,'Quoting',9),(6,6,NULL,NULL,'Quoting',5),(7,7,'2024-01-09','2024-01-12','In Production',7),(8,8,'2024-03-08','2024-03-11','In Production',2),(9,9,NULL,NULL,'Quoting',8),(10,10,NULL,NULL,'Quoting',2),(11,11,NULL,NULL,'Quoting',10),(12,12,NULL,NULL,'Quoting',4),(13,13,'2024-05-06','2024-05-12','Completed',10),(14,14,NULL,NULL,'Quoting',5),(15,15,'2024-04-13','2024-04-22','In Production',10),(16,16,NULL,NULL,'Quoting',8),(17,17,'2024-04-10','2024-04-13','Completed',1),(18,18,'2024-06-03','2024-06-12','In Production',6),(19,19,'2024-02-08','2024-02-11','Completed',4),(20,20,'2024-05-17','2024-05-20','In Production',9),(21,21,'2024-02-14','2024-02-23','Completed',3),(22,22,'2024-03-10','2024-03-13','In Production',5),(23,23,NULL,NULL,'Quoting',8),(24,24,NULL,NULL,'Quoting',9),(25,25,'2024-03-30','2024-04-08','In Production',9),(26,26,NULL,NULL,'Quoting',10),(27,27,NULL,NULL,'Quoting',9),(28,28,NULL,NULL,'Quoting',3),(29,29,'2024-02-28','2024-03-05','Completed',1),(30,30,NULL,NULL,'Quoting',5),(31,31,'2024-03-21','2024-04-02','Completed',6),(32,32,'2024-05-18','2024-05-30','In Production',1),(33,33,'2024-04-17','2024-04-20','Completed',5);
/*!40000 ALTER TABLE `productionschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `ProductID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `Type` enum('Sliding','Casement','Fixed','Bay','Awning') DEFAULT NULL,
  `FrameMaterial` enum('Aluminum','Vinyl','Wood','Fiberglass') DEFAULT NULL,
  `GlassType` enum('Single Pane','Double Pane','Triple Pane','Tempered','Low-E') DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  `StockQuantity` int DEFAULT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Non-Insulated Door','Fixed','Aluminum','Single Pane',315.31,124),(2,'Insulated Door','Fixed','Aluminum','Double Pane',417.20,178),(3,'Non-Insulated Sliding Patio Door','Sliding','Aluminum','Single Pane',428.98,87),(4,'Insulated Sliding Patio Door','Sliding','Aluminum','Double Pane',365.79,129),(5,'Non-Insulated Sliding Window','Sliding','Aluminum','Single Pane',299.47,65),(6,'Insulated Sliding Window','Sliding','Aluminum','Double Pane',392.26,102),(7,'Non-Insulated Swinging Window','Casement','Aluminum','Single Pane',407.72,142),(8,'Insulated Swinging Window','Casement','Aluminum','Double Pane',449.77,131),(9,'Non-Insulated Door','Fixed','Aluminum','Double Pane',615.31,104),(10,'Insulated Door','Fixed','Aluminum','Single Pane',217.20,158),(11,'Non-Insulated Sliding Patio Door','Sliding','Aluminum','Double Pane',828.98,47),(12,'Insulated Sliding Patio Door','Sliding','Aluminum','Single Pane',265.79,120),(13,'Non-Insulated Sliding Window','Sliding','Aluminum','Double Pane',499.47,25),(14,'Insulated Sliding Window','Sliding','Aluminum','Single Pane',192.26,152),(15,'Non-Insulated Swinging Window','Casement','Aluminum','Double Pane',807.72,42),(16,'Insulated Swinging Window','Casement','Aluminum','Single Pane',249.77,53);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `SupplierID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `ContactPerson` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` text,
  PRIMARY KEY (`SupplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'ClearView Glass Co.','Alice Smith','alice@clearview.com','+1-834-737-1274','123 Glass Ave'),(2,'AluPro Extrusions','Bob Johnson','bob@alupro.com','+1-437-336-5184','456 Metal Rd'),(3,'Ace Hardware Supplies','Carol Davis','carol@acehardware.com','+1-777-553-4218','789 Accessories Blvd');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-23 10:03:17
