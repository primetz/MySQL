-- MariaDB dump 10.17  Distrib 10.4.15-MariaDB, for Linux (x86_64)
--
-- Host: mysql.hostinger.ro    Database: u574849695_25
-- ------------------------------------------------------
-- Server version	10.4.15-MariaDB-cll-lve

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `communities`
--

DROP TABLE IF EXISTS `communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin_user_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `idx_communities_name` (`name`),
  KEY `admin_user_id` (`admin_user_id`),
  CONSTRAINT `communities_ibfk_1` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communities`
--

LOCK TABLES `communities` WRITE;
/*!40000 ALTER TABLE `communities` DISABLE KEYS */;
INSERT INTO `communities` VALUES (1,'quia',26),(2,'aut',27),(3,'sunt',28),(4,'pariatur',29),(5,'est',30),(6,'eius',31),(7,'amet',32),(8,'velit',33),(9,'quia',34),(10,'doloribus',36),(11,'et',37),(12,'ex',38),(13,'fugiat',39),(14,'incidunt',40),(15,'velit',45),(16,'provident',46),(17,'ex',48),(18,'velit',49),(19,'voluptas',50),(20,'sed',26);
/*!40000 ALTER TABLE `communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend_requests`
--

DROP TABLE IF EXISTS `friend_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friend_requests` (
  `initiator_user_id` bigint(20) unsigned NOT NULL,
  `target_user_id` bigint(20) unsigned NOT NULL,
  `status` enum('requested','approved','declined','unfriended') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`initiator_user_id`,`target_user_id`),
  KEY `target_user_id` (`target_user_id`),
  CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`initiator_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friend_requests`
--

LOCK TABLES `friend_requests` WRITE;
/*!40000 ALTER TABLE `friend_requests` DISABLE KEYS */;
INSERT INTO `friend_requests` VALUES (26,26,'declined','1997-10-31 20:51:23','2006-07-28 06:47:15'),(27,27,'requested','1972-08-01 19:14:49','1971-11-17 15:12:47'),(28,28,'requested','1989-11-27 09:45:15','1973-12-24 16:11:38'),(29,29,'declined','2006-11-19 07:30:47','1991-12-06 09:42:25'),(30,30,'approved','2001-03-20 08:30:11','2016-05-30 02:00:42'),(31,31,'unfriended','1977-02-18 00:12:08','1994-05-06 12:27:39'),(32,32,'declined','2011-04-03 03:59:18','2007-12-25 10:22:26'),(33,33,'declined','1975-07-10 09:23:29','2000-11-01 16:06:20'),(34,34,'approved','1976-02-06 19:28:27','1984-03-01 12:46:16'),(36,36,'unfriended','1989-08-20 22:13:04','1973-06-09 20:56:01'),(37,37,'approved','1996-01-26 11:16:39','1995-11-04 01:40:08'),(38,38,'approved','2005-07-25 07:58:57','1978-05-17 14:05:26'),(39,39,'requested','1972-07-14 19:08:23','1986-04-26 23:59:25'),(40,40,'approved','1983-11-08 11:25:03','1987-10-23 23:31:39'),(45,45,'requested','1982-03-05 19:12:25','1977-06-07 19:27:05'),(46,46,'approved','1996-09-09 05:24:26','2006-04-20 20:03:16'),(48,48,'unfriended','1992-12-11 05:52:25','1979-07-17 02:54:53'),(49,49,'unfriended','1997-12-30 00:14:10','1993-07-26 21:29:04'),(50,50,'unfriended','1988-08-21 05:44:51','2004-09-23 18:29:25');
/*!40000 ALTER TABLE `friend_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES (1,26,1),(2,27,2),(3,28,3),(4,29,4),(5,30,5),(6,31,6),(7,32,7),(8,33,8),(9,34,9),(10,36,10),(11,37,11),(12,38,12),(13,39,13),(14,40,14),(15,45,15),(16,46,16),(17,48,17),(18,49,18),(19,50,19),(20,26,20);
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `media_type_id` bigint(20) unsigned NOT NULL,
  `body` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  KEY `media_type_id` (`media_type_id`),
  CONSTRAINT `media_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `media_ibfk_2` FOREIGN KEY (`media_type_id`) REFERENCES `media_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (1,26,1,'Et ut provident libero. Doloremque qui debitis nihil sunt incidunt autem. Ut aut quas aspernatur reprehenderit rerum voluptas aut perspiciatis. Soluta cupiditate quod quasi est blanditiis earum.','cupiditate',NULL,'1997-06-02 15:21:32','1981-07-01 01:01:47'),(2,27,2,'Quis eaque illo sunt dolores et. Qui id et distinctio et. Architecto quis illum sit. Dolore cupiditate voluptas rerum in officia eum eos eius.','non',NULL,'2019-12-22 23:37:00','2013-03-20 23:03:08'),(3,28,3,'Ut eos vero eum exercitationem eaque voluptatem nesciunt. Provident quia sint ex qui est. Eius ut qui necessitatibus aut ut incidunt voluptas.','quis',NULL,'2000-06-30 23:51:45','2011-08-20 13:22:30'),(4,29,4,'Qui omnis enim repudiandae minima quia sed quam. Illum qui eveniet rem veritatis consectetur. Blanditiis explicabo occaecati quia veniam ad velit.','labore',NULL,'2014-12-01 06:09:55','2005-06-05 11:10:34'),(5,30,1,'Reiciendis sunt dolore quibusdam sequi. Error consequatur non nihil inventore. Quis molestiae dicta quidem aut dolores labore.','qui',NULL,'2012-09-15 12:31:51','1979-09-04 21:55:35'),(6,31,2,'Et aut earum molestiae est. Deleniti voluptas odio ut voluptates eaque eum. Vitae consequatur laborum quia possimus sunt.','nesciunt',NULL,'2001-12-09 13:57:51','2020-10-25 07:45:31'),(7,32,3,'Velit consequatur expedita aut. Voluptatem repudiandae vitae praesentium et. Id dicta voluptate sint et quibusdam deleniti aut. Recusandae voluptatum fugit repudiandae pariatur necessitatibus fugiat.','sed',NULL,'1989-05-30 14:00:18','2020-10-01 17:33:48'),(8,33,4,'In sint sed consequuntur cupiditate. Ea esse id quae aut consequatur eveniet et. Voluptatibus totam in reprehenderit deleniti et optio rerum quibusdam.','molestiae',NULL,'2007-04-08 22:23:49','1976-06-04 19:41:48'),(9,34,1,'Quisquam recusandae et ab est qui delectus ut necessitatibus. Neque est qui quia soluta quasi. Atque autem libero ut qui molestiae qui.','necessitatibus',NULL,'2006-07-04 03:54:49','1971-10-17 06:12:40'),(10,36,2,'Voluptatibus quibusdam dolorem a labore quasi dolor eum ipsa. Vel consectetur aperiam maxime ad laudantium. Est aliquam nostrum voluptate esse.','ipsum',NULL,'1981-02-16 06:43:10','2016-02-29 10:06:11'),(11,37,3,'Itaque molestiae architecto sed qui perferendis accusantium. Non pariatur distinctio quisquam et. Ab a id voluptas temporibus temporibus. Fugiat saepe similique numquam nam est iure tempora.','architecto',NULL,'2010-05-16 12:52:35','2014-09-16 09:36:00'),(12,38,4,'Sapiente tempora consequatur autem cupiditate. Eveniet a iure voluptatem eveniet perferendis. Cumque et rerum impedit.','odit',NULL,'1982-07-20 07:10:53','2006-02-25 12:59:05'),(13,39,1,'Non tenetur ipsam repellendus ut molestiae qui. Et quam qui mollitia eos animi voluptate. Qui maiores ducimus quas.','qui',NULL,'2017-03-23 13:09:16','1982-01-14 15:55:54'),(14,40,2,'Alias ea dolore labore quasi sint sequi quibusdam. Officiis atque esse quidem est aperiam voluptates. Sit ullam voluptatibus quo eveniet non. Quas architecto quia nemo ut accusamus quo qui.','reiciendis',NULL,'1981-09-18 23:33:24','1970-08-14 10:36:34'),(15,45,3,'Sapiente in voluptatibus eius dolores impedit adipisci. Sapiente facere nam est sed. Repellendus adipisci id architecto ut sit. Rerum sit quos libero reiciendis velit sed.','culpa',NULL,'2003-05-29 21:30:39','1989-10-16 15:34:10'),(16,46,4,'Fuga error voluptatem quasi eaque enim. Culpa ut voluptates dolor sint ut laboriosam. Excepturi qui deleniti cum suscipit. Quaerat mollitia quam occaecati magnam quibusdam consequatur saepe.','quia',NULL,'2000-03-13 02:49:20','2002-04-15 22:50:27'),(17,48,1,'Nihil maxime similique animi repudiandae perferendis quo magnam. Sint omnis nulla sint sunt est laudantium. Odit et quam dolores sint. Fuga voluptate qui consequatur sit voluptatibus sequi impedit.','officia',NULL,'1981-02-23 20:59:32','2002-01-02 22:53:05'),(18,49,2,'Rerum aut illum rerum quia aut nulla voluptatem aliquid. Quasi et nobis ut quo odio non. Amet ut et et et.','illum',NULL,'1998-05-30 08:13:52','2016-04-12 19:32:26'),(19,50,3,'Nisi quisquam minus omnis et hic veniam. Consequatur ex similique iure perspiciatis corporis itaque quo. Enim ad quidem dolores est placeat facilis. Rem facere non repudiandae expedita aspernatur.','ea',NULL,'2007-06-25 18:27:39','2006-11-24 04:31:59'),(20,26,4,'Sit incidunt animi officiis in ex. Odit rem corrupti dolore quibusdam officia. Doloribus tenetur nam saepe eveniet occaecati modi. Non ut molestiae aut et hic quia voluptas.','ut',NULL,'2006-07-14 09:22:13','1985-11-23 21:03:38');
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_types`
--

DROP TABLE IF EXISTS `media_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_types`
--

LOCK TABLES `media_types` WRITE;
/*!40000 ALTER TABLE `media_types` DISABLE KEYS */;
INSERT INTO `media_types` VALUES (1,'image'),(2,'music'),(3,'video'),(4,'text');
/*!40000 ALTER TABLE `media_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` bigint(20) unsigned NOT NULL,
  `to_user_id` bigint(20) unsigned NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  UNIQUE KEY `id` (`id`),
  KEY `from_user_id` (`from_user_id`),
  KEY `to_user_id` (`to_user_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,26,26,'Assumenda voluptatibus consequatur itaque dolor quis facere possimus asperiores. Molestias dignissimos quis dolores necessitatibus. Ipsam a enim aut suscipit ut sit. Aut voluptatibus neque esse tempora ipsa.','1984-03-29 23:22:05'),(2,27,27,'Sequi aut ipsam repellat pariatur. Nam consequatur ad amet rerum doloribus est. Suscipit architecto nesciunt sapiente earum sint.','2004-02-06 20:34:20'),(3,28,28,'Molestiae occaecati consectetur adipisci perferendis. Explicabo sapiente maiores sit tenetur eveniet consequatur ut. Atque ea et sit tempora blanditiis. Pariatur ipsum quod et. Eos tempora voluptate ullam ut non voluptatem eligendi.','1999-02-23 22:18:59'),(4,29,29,'Excepturi voluptas dolore quidem exercitationem libero reprehenderit nemo id. Voluptate esse dolores corporis. Architecto unde voluptatibus ipsam.','2000-11-15 11:36:11'),(5,30,30,'Exercitationem numquam animi numquam eligendi ut neque aut. Odit veniam id et accusantium magnam eveniet. Maxime omnis rem in ut eaque. Omnis dolorem voluptatem non consequatur.','1993-01-24 14:37:02'),(6,31,31,'Nobis tenetur ratione assumenda natus cumque dignissimos quis. Ad hic beatae officiis similique. Autem unde numquam at nulla. Magnam illo ipsum beatae quia consequuntur rem et.','2014-08-19 04:57:45'),(7,32,32,'Voluptate aut temporibus dolores quia ut doloremque. Nobis quod a dolor dicta. Incidunt consequatur molestiae sit id quis minus.','2013-03-15 15:01:31'),(8,33,33,'Omnis dolorem corrupti quia suscipit adipisci nihil. Repudiandae occaecati amet aut eaque doloribus. Eligendi ut et natus dolorum voluptate.','2015-12-24 11:57:16'),(9,34,34,'Nam ex temporibus et. Tenetur voluptas numquam sapiente aut autem similique aut rerum. Quasi fuga ut qui necessitatibus. Corporis nihil et accusantium sequi.','1990-10-28 01:46:48'),(10,36,36,'Autem a aut qui optio reprehenderit reprehenderit. Sit nihil quibusdam sequi deleniti. Recusandae fuga omnis minus libero voluptatem quos alias. Placeat quis odio qui recusandae sunt placeat ratione et.','2019-04-10 13:23:45'),(11,37,37,'Quisquam expedita a reiciendis quod provident. Quidem ea eum quia cumque dolorem. Magnam dolores quia aut eaque. Rerum voluptatibus iste quia asperiores ratione sint nemo.','1978-01-19 14:31:18'),(12,38,38,'Ab aliquid labore tempore ea voluptates sequi et. Aut aspernatur explicabo suscipit repudiandae magni libero blanditiis quia. Mollitia labore beatae ipsam molestias sint in.','2021-08-26 12:37:48'),(13,39,39,'Modi quia consectetur minima blanditiis tempore. Sint ut voluptatem dolor voluptatem. Aliquam minima repellendus doloribus ratione.','1976-08-30 20:27:27'),(14,40,40,'Illum culpa enim voluptas non rerum vel. Aut velit neque saepe molestiae possimus id odio alias. Nam corporis voluptatem nesciunt assumenda et. Ab quam molestias qui ut suscipit qui perspiciatis.','1975-08-08 01:37:50'),(15,45,45,'Ipsa nisi mollitia facilis rerum. Sapiente laborum ad voluptas qui sunt vel tempore. Voluptatum autem dolor doloribus asperiores et. Amet numquam assumenda recusandae.','1981-06-07 06:47:56'),(16,46,46,'Ut illum numquam ea ab quasi molestias eligendi. Facilis distinctio maxime repellendus reiciendis. Voluptatem ullam quis odio. Cum vero ratione quae autem.','1975-07-10 02:15:03'),(17,48,48,'Ducimus dolorem excepturi occaecati commodi. Molestiae non dicta omnis omnis. Quis est id deleniti itaque culpa magni itaque repellendus.','2018-03-13 07:07:16'),(18,49,49,'Ipsam distinctio exercitationem cum qui voluptatem ut eos at. Qui autem sit aliquid. Rerum iure nostrum non atque voluptas provident provident alias. Quos quam et pariatur dolorem officiis.','2008-03-24 19:54:21'),(19,50,50,'Dolorum enim exercitationem omnis. Quis aut excepturi ipsum tempore. Similique ex officia molestias quam in.','1974-05-21 23:37:03'),(20,26,26,'Illum iusto consequatur qui ipsa est. Soluta dicta quae culpa assumenda. Aut rerum laborum nulla neque et recusandae.','2015-08-17 14:55:23'),(21,27,27,'Occaecati fugiat quidem aut quo eum doloremque rem. Repellat et dolores nihil voluptatibus id aspernatur dolorum. Ipsam quas porro corporis esse et.','1976-10-24 22:31:36'),(22,28,28,'Qui cupiditate assumenda natus et et fuga. Provident corporis excepturi eos deserunt. Illum ut deserunt velit voluptas et pariatur neque qui.','1978-05-21 23:35:53'),(23,29,29,'Est nulla ut illo tempore delectus. Magnam dignissimos at et accusamus. Voluptatem harum voluptas ab. Et iusto eos laborum est et consequatur vel tenetur. Magnam et placeat tenetur autem qui mollitia sed.','1996-04-20 18:11:59'),(24,30,30,'Molestias possimus qui excepturi esse magni enim asperiores. Officia quo aut et sit vel. Ullam minus blanditiis aut non quia corporis ducimus.','1988-07-11 08:56:33'),(25,31,31,'Sequi asperiores doloremque rerum eum aut earum. Repellat molestias ut maiores a officiis inventore consequatur. Ea facilis facere quia facilis omnis veritatis. Atque reiciendis voluptas eius ut voluptate.','2006-10-31 12:41:08');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `music`
--

DROP TABLE IF EXISTS `music`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `music` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned DEFAULT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `music_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `music_albums` (`id`),
  CONSTRAINT `music_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `music`
--

LOCK TABLES `music` WRITE;
/*!40000 ALTER TABLE `music` DISABLE KEYS */;
INSERT INTO `music` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(11,11,11),(12,12,12),(13,13,13),(14,14,14),(15,15,15),(16,16,16),(17,17,17),(18,18,18),(19,19,19),(20,20,20);
/*!40000 ALTER TABLE `music` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `music_albums`
--

DROP TABLE IF EXISTS `music_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `music_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `music_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `music_albums`
--

LOCK TABLES `music_albums` WRITE;
/*!40000 ALTER TABLE `music_albums` DISABLE KEYS */;
INSERT INTO `music_albums` VALUES (1,'provident',26),(2,'facere',27),(3,'dolores',28),(4,'dolor',29),(5,'aut',30),(6,'et',31),(7,'aperiam',32),(8,'necessitatibus',33),(9,'ut',34),(10,'omnis',36),(11,'sunt',37),(12,'quia',38),(13,'itaque',39),(14,'qui',40),(15,'doloremque',45),(16,'rerum',46),(17,'amet',48),(18,'laudantium',49),(19,'quam',50),(20,'qui',26);
/*!40000 ALTER TABLE `music_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photo_albums`
--

DROP TABLE IF EXISTS `photo_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photo_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `photo_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photo_albums`
--

LOCK TABLES `photo_albums` WRITE;
/*!40000 ALTER TABLE `photo_albums` DISABLE KEYS */;
INSERT INTO `photo_albums` VALUES (1,'atque',26),(2,'porro',27),(3,'earum',28),(4,'ad',29),(5,'quas',30),(6,'vel',31),(7,'quaerat',32),(8,'dolor',33),(9,'et',34),(10,'rerum',36),(11,'inventore',37),(12,'quibusdam',38),(13,'qui',39),(14,'qui',40),(15,'veniam',45),(16,'voluptatem',46),(17,'qui',48),(18,'dolores',49),(19,'asperiores',50),(20,'quo',26);
/*!40000 ALTER TABLE `photo_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned DEFAULT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `photos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `photo_albums` (`id`),
  CONSTRAINT `photos_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(11,11,11),(12,12,12),(13,13,13),(14,14,14),(15,15,15),(16,16,16),(17,17,17),(18,18,18),(19,19,19),(20,20,20);
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profiles` (
  `user_id` bigint(20) unsigned NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `photo_id` bigint(20) unsigned NOT NULL,
  `hometown` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  KEY `fk_profiles_photo_id` (`photo_id`),
  CONSTRAINT `fk_profiles_photo_id` FOREIGN KEY (`photo_id`) REFERENCES `media` (`id`),
  CONSTRAINT `fk_profiles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (26,'f','1972-03-03',1,'Tatechester','2003-06-30 08:42:14'),(27,'f','1977-11-16',2,'New Margarita','1977-11-23 15:42:19'),(28,'f','1983-02-08',3,'Homenickfurt','2010-05-13 03:54:43'),(29,'f','2006-07-10',4,'Port Zulaside','1998-07-22 03:38:54'),(30,'m','2018-09-26',5,'Waelchiport','1991-04-09 23:33:36'),(31,'f','2009-10-27',6,'Shawnaland','1987-07-31 08:22:04'),(32,'f','2000-08-31',7,'Pacochaville','2003-01-16 08:12:59'),(33,'m','1980-01-27',8,'Lake Germainehaven','1973-07-25 00:40:05'),(34,'f','1997-06-19',9,'Port Dorrisfurt','1982-06-09 09:55:32'),(36,'m','1972-02-16',10,'Kevonland','2016-03-13 17:25:36'),(37,'m','2009-12-05',11,'Klockobury','1994-03-25 20:04:10'),(38,'f','2005-03-18',12,'Abernathymouth','1977-09-02 14:08:23'),(39,'m','1970-06-03',13,'East Queenport','2007-04-08 16:08:03'),(40,'f','1992-06-22',14,'Pacochafort','2001-09-23 21:33:13'),(45,'m','1978-01-19',15,'Lake Zettaview','2012-10-28 01:06:19'),(46,'m','1980-06-20',16,'Port Glen','1981-07-16 08:52:33'),(48,'m','1988-01-20',17,'Port Enolaton','2015-08-09 20:09:17'),(49,'f','2007-06-22',18,'Gregorioport','1971-10-29 13:06:04'),(50,'m','1971-10-26',19,'Lake Lorenzo','2013-12-01 20:59:02');
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Фамилия',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` bigint(20) unsigned DEFAULT NULL,
  `password_hash` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_users_firstname_lastname` (`firstname`,`lastname`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Пользователи';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (26,'Summer','Moen','halvorson.josiane@example.org',3161283883,'546769fbb67b47df3e02135ff4f181608b7dffb7'),(27,'Bill','Lebsack','lewis84@example.net',1,'6294788d8fa25d45cc017fdb06163d1cd1a3f14a'),(28,'Francis','Howe','jerde.violette@example.org',544130,'118d565aded1d96563b5b9a6598d1d08ebd4cedf'),(29,'Wilber','Legros','ursula.hoppe@example.org',996,'0d41aa0fe947038731a520cf7249fd4f26a9a100'),(30,'Lonzo','Cremin','archibald65@example.com',921993,'e4cd5991fd7f7b1335c399a860aab0e76792d96b'),(31,'Dakota','Stroman','oren.altenwerth@example.org',0,'354775a6b8557d241d50fdcaaf6c5cc786933a55'),(32,'Celia','Cartwright','thompson.fidel@example.org',845,'75a52f69c917f02106ed499d8f4bba3776517af2'),(33,'Levi','Greenfelder','estelle49@example.org',14,'6bcbbdfabf3b20a6925e9b868d4123aea2bc9928'),(34,'Ahmed','Koch','yasmine08@example.com',523622,'9aa3ff080d1229dfb91dd21c3e2b2c16a3227632'),(36,'Neal','Jaskolski','lilyan34@example.org',87,'70ce8aee1b6b303d8583e2a7283f775f1833ffc5'),(37,'Marquise','Satterfield','wiza.robyn@example.com',53,'86e37bb4e7259dff639ad2f633e3cf7b97fb4f1d'),(38,'Irwin','Ortiz','yesenia26@example.org',77,'fa72a7e4541f6034739269bade05d17c00b843fb'),(39,'Sandra','Howell','parisian.kip@example.org',7309648377,'e3bc5014cb915e3901e92a64749824a345c67e54'),(40,'Destinee','Jerde','ywisozk@example.com',263587,'5c31e99c36644c8722a1d2d0b1e375dcbe4ec9e1'),(45,'Karianne','Donnelly','ritchie.lily@example.org',1487408918,'1fe4d4dac6d927050fc4860b32c362f22259bedd'),(46,'Madonna','McLaughlin','reanna.rolfson@example.net',30,'e9df7ff471a063653f961ee0cea770cbf1068817'),(48,'Jude','Konopelski','leanna13@example.net',529,'22efa7f01349467f9b40aabf86ab3834fc314ac8'),(49,'Sylvan','Thompson','lamar.witting@example.org',122671,'23761c2a8150d18feae2a20f73509e3710f718dc'),(50,'Floyd','Klein','gaylord.corwin@example.net',484058,'16b72e5084d270dae1d40f48975500d4bd2ef7a9');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_communities`
--

DROP TABLE IF EXISTS `users_communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_communities` (
  `user_id` bigint(20) unsigned NOT NULL,
  `community_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`community_id`),
  KEY `community_id` (`community_id`),
  CONSTRAINT `users_communities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_communities_ibfk_2` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_communities`
--

LOCK TABLES `users_communities` WRITE;
/*!40000 ALTER TABLE `users_communities` DISABLE KEYS */;
INSERT INTO `users_communities` VALUES (26,1),(26,20),(27,2),(28,3),(29,4),(30,5),(31,6),(32,7),(33,8),(34,9),(36,10),(37,11),(38,12),(39,13),(40,14),(45,15),(46,16),(48,17),(49,18),(50,19);
/*!40000 ALTER TABLE `users_communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video_albums`
--

DROP TABLE IF EXISTS `video_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `video_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `video_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video_albums`
--

LOCK TABLES `video_albums` WRITE;
/*!40000 ALTER TABLE `video_albums` DISABLE KEYS */;
INSERT INTO `video_albums` VALUES (1,'et',26),(2,'accusantium',27),(3,'voluptatum',28),(4,'totam',29),(5,'voluptatum',30),(6,'hic',31),(7,'veniam',32),(8,'tenetur',33),(9,'molestias',34),(10,'molestiae',36),(11,'illo',37),(12,'qui',38),(13,'soluta',39),(14,'ipsam',40),(15,'sed',45),(16,'quia',46),(17,'ab',48),(18,'quod',49),(19,'cum',50),(20,'commodi',26);
/*!40000 ALTER TABLE `video_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned DEFAULT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `videos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `video_albums` (`id`),
  CONSTRAINT `videos_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(11,11,11),(12,12,12),(13,13,13),(14,14,14),(15,15,15),(16,16,16),(17,17,17),(18,18,18),(19,19,19),(20,20,20);
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-09-09 23:35:36
