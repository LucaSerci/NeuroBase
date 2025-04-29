CREATE DATABASE  IF NOT EXISTS `neurodb` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `neurodb`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: neurodb
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
-- Table structure for table `queryhistory`
--

DROP TABLE IF EXISTS `queryhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `queryhistory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `query` longtext NOT NULL,
  `response` longtext NOT NULL,
  `executionDate` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `userid_idx` (`userId`),
  CONSTRAINT `userid` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queryhistory`
--

LOCK TABLES `queryhistory` WRITE;
/*!40000 ALTER TABLE `queryhistory` DISABLE KEYS */;
INSERT INTO `queryhistory` VALUES (71,1,'Select created by the chatBot','To see what customer 2 has ordered, we would have to go through their orders in the Orders table. This process includes fetching the details of the orders and then fetching the products associated with those orders from the Products table through the OrderDetails table.  --SQL-- SELECT Orders.OrderID, Products.Name, OrderDetails.Quantity FROM Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID JOIN Products ON Products.ProductID = OrderDetails.ProductID WHERE Orders.CustomerID = 2;','2025-04-22 09:40:29'),(72,1,'Select created by the chatBot','The total amount spent by the customer can be found by summing up the `TotalPrice` column in the `Orders` table for the specific `CustomerID`.  --SQL-- SELECT SUM(TotalPrice) FROM Orders WHERE CustomerID=2;','2025-04-22 09:40:57'),(73,1,'Select created by the chatBot','Sure, I can list out all the customers from the Customers table for you.  --SQL-- SELECT * FROM Customers;','2025-04-23 08:46:36'),(74,1,'Query confirmed by user','INSERT INTO Customers(Name, Email, Phone, Address) VALUES (\'Minecraft Steve\', \'steve@mojang.com\', \'+1 123 123 1234\', \'Overworld\');','2025-04-23 08:56:54'),(75,1,'Select created by the chatBot','Sure, I can retrieve the list of customers for you from the database.  --SQL-- SELECT * FROM Customers','2025-04-23 09:36:39'),(76,1,'Select created by the chatBot','I can help you find the total spending for each customer by summing up the TotalPrice from their orders in our database.  --SQL-- SELECT Customers.Name, SUM(Orders.TotalPrice) AS TotalSpending FROM Customers LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID GROUP BY Customers.CustomerID, Customers.Name','2025-04-23 09:36:58'),(77,1,'Select created by the chatBot','Sure, I can retrieve the list of products for you from the database.  --SQL-- SELECT * FROM Products','2025-04-23 09:41:23'),(78,3,'Select created by the chatBot','Sure, here is the SQL statement which will fetch the list of all customers.  --SQL-- SELECT * FROM Customers','2025-04-23 09:47:05'),(79,3,'Query confirmed by user','UPDATE Customers SET Phone = \'+1 123-123-7894\' WHERE CustomerID = 5','2025-04-23 09:47:40'),(80,3,'Query confirmed by user','UPDATE Customers SET Name=\'John Doe\' WHERE CustomerID=5','2025-04-23 09:48:07');
/*!40000 ALTER TABLE `queryhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password_hash` varchar(250) NOT NULL,
  `role` varchar(45) NOT NULL,
  `persmissions` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'BigMan Admin','$2b$12$PUDLsxhpcoV2mNxcTAAqdezo7GCoHMYsWHiDbwnJXtlt7L2OMOSC2','admin',NULL),(2,'Luca','$2b$12$fQu8YSp7nfW8pHnLDaECPeQ6J0xoU2M7xDbKWo4Un1uR5f/AXayza','user',NULL),(3,'manager','$2b$12$OehE3gsfSShlOsgiro1Fs.eXB4wy0cK9ebEV8sjh3/rSgvZCVqj4m','manager',NULL),(5,'Mango','$2b$12$/H9W2T6EB5BBDfNXr2QfdOHg3EwLW4f.QdptKAf7crJjaHbVitXwS','user',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-23 10:02:40
