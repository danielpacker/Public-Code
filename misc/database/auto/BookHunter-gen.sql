-- MySQL dump 10.13  Distrib 5.1.61, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: BookHunter
-- ------------------------------------------------------
-- Server version	5.1.61-0ubuntu0.11.10.1

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
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `author` (
  `author_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,51),(2,52),(3,53),(4,54),(5,55),(6,56),(7,57),(8,58),(9,59),(10,60),(11,61),(12,62),(13,63),(14,64),(15,65),(16,66),(17,67),(18,68),(19,69),(20,70),(21,71),(22,72),(23,73),(24,74),(25,75);
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `book` (
  `book_id` int(11) NOT NULL,
  `internal_product_id` int(11) NOT NULL,
  `isbn` decimal(13,0) DEFAULT NULL,
  `name` varchar(45) NOT NULL,
  `author_id` varchar(45) NOT NULL,
  `publisher_id` varchar(45) NOT NULL,
  `website_url` varchar(45) DEFAULT NULL,
  `date_published` date NOT NULL,
  `book_type` enum('paperback','hardcover') NOT NULL DEFAULT 'paperback',
  `length` int(11) NOT NULL DEFAULT '0',
  `genre_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`book_id`),
  UNIQUE KEY `internal_product_id_UNIQUE` (`internal_product_id`),
  UNIQUE KEY `isbn_UNIQUE` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,3267,'1234567890124','Cyberspace Hands','1','1','http://www.yahoo.com','1920-07-21','hardcover',792,1),(2,3268,'1234567890125','Sex','2','2','http://www.netdot.net','1997-11-03','hardcover',183,2),(3,3269,'1234567890126','Dances Bird Education','3','3','http://www.loser.com','1962-11-12','hardcover',735,3),(4,3270,'1234567890127','Underworld','4','4','http://www.cutekitties.org','1903-03-17','paperback',320,4),(5,3271,'1234567890128','World Fire','5','5','http://www.mac.com','1944-04-02','hardcover',726,5),(6,3272,'1234567890129','Underworld Sword Cyberspace','6','6','http://www.candyapples.com','1991-03-02','paperback',873,6),(7,3273,'1234567890130','Turtle','7','7','http://www.bigfoot.com','1925-09-06','paperback',845,7),(8,3274,'1234567890131','Wizard Cyberspace Love','8','8','http://www.loser.com','1959-04-26','paperback',598,8),(9,3275,'1234567890132','Games Political Sword','9','9','http://www.nicefoundation.org','1904-06-21','hardcover',152,9),(10,3276,'1234567890133','Steel Wizard','10','10','http://www.yahoo.com','1959-08-01','paperback',371,10),(11,3277,'1234567890134','Healing Steel Games','11','11','http://www.cutekitties.org','1903-05-12','hardcover',855,11),(12,3278,'1234567890135','Missing Healing Wizard','12','12','http://www.wazoo.com','1958-05-03','hardcover',256,12),(13,3279,'1234567890136','World','13','13','http://www.evilempire.net','1916-08-04','paperback',146,13),(14,3280,'1234567890137','Political Education','14','14','http://www.netdot.net','1997-04-11','paperback',607,14),(15,3281,'1234567890138','Hands Cyberspace','15','15','http://www.hotmail.com','1993-02-26','hardcover',303,15),(16,3282,'1234567890139','Sword','16','16','http://www.gmail.com','1988-10-17','hardcover',633,16),(17,3283,'1234567890140','Programming','17','17','http://www.cutekitties.org','2012-09-02','paperback',230,17),(18,3284,'1234567890141','Political Steel','18','18','http://www.gmail.com','1911-10-19','paperback',249,18),(19,3285,'1234567890142','Programming Steel Bird','19','19','http://www.wazoo.com','1928-09-08','paperback',339,19),(20,3286,'1234567890143','Programming Wizard Time','20','20','http://www.netdot.net','1953-12-20','paperback',434,20),(21,3287,'1234567890144','Healing Missing Sun','21','21','http://www.netdot.net','1921-05-03','paperback',535,21),(22,3288,'1234567890145','Knife Knife Play','22','22','http://www.gmail.com','1998-01-09','paperback',712,22),(23,3289,'1234567890146','Wizard Sex Foul','23','23','http://www.loser.com','1996-01-06','paperback',837,23),(24,3290,'1234567890147','Time','24','24','http://www.loser.com','1997-05-24','hardcover',240,24),(25,3291,'1234567890148','Steel Lost','25','25','http://www.bigfoot.com','1950-02-02','hardcover',683,25);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact`
--

DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact` (
  `contact_id` int(11) NOT NULL AUTO_INCREMENT,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `phone1` decimal(10,0) DEFAULT NULL,
  `phone2` decimal(10,0) DEFAULT NULL,
  `website_url` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `notes` text,
  `fname` varchar(45) NOT NULL,
  `lname` varchar(45) NOT NULL,
  PRIMARY KEY (`contact_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2193 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact`
--

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
INSERT INTO `contact` VALUES (1,'917 Happy Town St.',NULL,'Port Jervis','NE','42297','1639956548','1477541488','http://www.wazoo.com','HannaEinstein@wazoo.com',NULL,'Hanna','Einstein'),(2,'867 1st Avenue',NULL,'Jamestown','CT','54155','1689009089','1829447380','http://www.evilempire.net','ArnoldRamanujan@hotmail.com',NULL,'Arnold','Ramanujan'),(3,'333 Electric Ave',NULL,'Salamanca','ND','48520','1685840181','1537988895','http://www.yahoo.com','Aster648@bigfoot.com',NULL,'Ali','Foster'),(4,'524 Elm St.',NULL,'Watervliet','LA','63080','1346557896','1280693133','http://www.wazoo.com','Hrringer638@nicefoundation.org',NULL,'Harry','Berringer'),(5,'421 123rd St.',NULL,'Little Falls','SD','50503','1492953530','1289508534','http://www.bigfoot.com','BarbieReynolds@bigfoot.com',NULL,'Barbie','Reynolds'),(6,'455 123rd St.',NULL,'Syracuse','TX','16523','1660600747','1577253332','http://www.mac.com','WendyEdison@corporate.com',NULL,'Wendy','Edison'),(7,'262 123rd St.',NULL,'Cohoes','OH','73321','1387041756','1976419472','http://www.wazoo.com','ArnoldBohr@bigfoot.com',NULL,'Arnold','Bohr'),(8,'616 Long Long Way',NULL,'Salamanca','CT','64314','1892431754','1263640341','http://www.mac.com','HarryBohr@cutekitties.org',NULL,'Harry','Bohr'),(9,'951 1st Street',NULL,'Niagara Falls','CT','60227','1399049186','1595301383','http://www.evilempire.net','MelanieEinstein@wazoo.com',NULL,'Melanie','Einstein'),(10,'729 1st Avenue',NULL,'Fulton','TN','85488','1736956512','1696420872','http://www.corporate.com','Janck630@wazoo.com',NULL,'Joe-joe','Planck'),(11,'743 1st Avenue',NULL,'Ithaca','TX','13039','1714775968','1327196323','http://www.corporate.com','FrancesJoplin@candyapples.com',NULL,'Frances','Joplin'),(12,'965 1st Street',NULL,'Gloversville','DC','94626','1260209516','1597441862','http://www.loser.com','MarkoGoodall@gmail.com',NULL,'Marko','Goodall'),(13,'53 1st Avenue',NULL,'Elmira','SD','15851','1709334800','1418624054','http://www.wazoo.com','HarryEinstein@bigfoot.com',NULL,'Harry','Einstein'),(14,'760 Winners Circle',NULL,'New Rochelle','HI','78122','1335146762','1358905975','http://www.gmail.com','LouisFoster@evilempire.net',NULL,'Louis','Foster'),(15,'454 1st Avenue',NULL,'Dunkirk','LA','47792','1470136335','1254552179','http://www.corporate.com','Bnstein139@corporate.com',NULL,'Barack','Einstein'),(16,'119 Happy Town St.',NULL,'Mount Vernon','VT','31726','1284801567','1999437840','http://www.cutekitties.org','Mwton329@nicefoundation.org',NULL,'Mary','Newton'),(17,'789 123rd St.',NULL,'Gloversville','NM','27988','1387658824','1857917413','http://www.cutekitties.org','BobbyFoster@gmail.com',NULL,'Bobby','Foster'),(18,'978 Sesame St.',NULL,'Glen Cove','NM','39706','1583833460','1631390810','http://www.cutekitties.org','Wodall162@mac.com',NULL,'Wendy','Goodall'),(19,'824 ABC Ave.',NULL,'Norwich','ND','57931','1311876158','1549874953','http://www.loser.com','Janck725@netdot.net',NULL,'Joe','Planck'),(20,'687 123rd St.',NULL,'Fulton','NM','52051','1930241328','1242786169','http://www.corporate.com','Jrker713@evilempire.net',NULL,'Jerry','Parker'),(21,'535 Long Long Way',NULL,'Schenectady','AL','45371','1816170310','1438838405','http://www.cutekitties.org','FabioTuring@bigfoot.com',NULL,'Fabio','Turing'),(22,'126 1st Street',NULL,'Mechanicville','TN','30777','1735989042','1253809038','http://www.cutekitties.org','Hrringer750@mac.com',NULL,'Hanna','Berringer'),(23,'300 Infinite Loop',NULL,'Long Beach','HI','48282','1757137415','1482605845','http://www.yahoo.com','LouisFranklin@cutekitties.org',NULL,'Louis','Franklin'),(24,'143 Infinite Loop',NULL,'Mechanicville','MT','13424','1273958867','1261884029','http://www.gmail.com','MarkoParker@loser.com',NULL,'Marko','Parker'),(25,'566 1st Street',NULL,'Niagara Falls','DC','30388','1367788515','1684629016','http://www.cutekitties.org','Spata465@gmail.com',NULL,'Sam','Zapata'),(26,'659 Winners Circle',NULL,'Lockport','LA','90441','1243068559','1911611918','http://www.bigfoot.com','Nndis710@cutekitties.org',NULL,'Nick','Landis'),(27,'301 1st Street',NULL,'Oneida','NJ','55141','1749338360','1663482795','http://www.gmail.com','LouisLandis@candyapples.com',NULL,'Louis','Landis'),(28,'965 2nd Street',NULL,'Rome','MO','53363','1525848314','1301564673','http://www.gmail.com','Hynolds756@cutekitties.org',NULL,'Harry','Reynolds'),(29,'63 Electric Ave',NULL,'Syracuse','MS','51243','1570611848','1915370592','http://www.mac.com','Grtinez352@gmail.com',NULL,'Geraldine','Martinez'),(30,'192 3rd Avenue',NULL,'Cohoes','OR','96610','1916705890','1700845706','http://www.gmail.com','Grringer169@mac.com',NULL,'Geraldine','Berringer'),(31,'975 1st Street',NULL,'Lockport','MO','43988','1591789279','1865858716','http://www.corporate.com','Mwton569@evilempire.net',NULL,'Marko','Newton'),(32,'647 3rd Street',NULL,'Little Falls','NJ','28376','1399230720','1985660328','http://www.evilempire.net','BarbieJoplin@candyapples.com',NULL,'Barbie','Joplin'),(33,'390 1st Street',NULL,'Plattsburgh','MS','15472','1721992580','1770680201','http://www.candyapples.com','Swton891@hotmail.com',NULL,'Sam','Newton'),(34,'162 ABC Ave.',NULL,'Port Jervis','KY','83250','1650640833','1543644839','http://www.candyapples.com','Fplin971@yahoo.com',NULL,'Fabio','Joplin'),(35,'778 1st Avenue',NULL,'Plattsburgh','VA','79377','1705150901','1806968126','http://www.corporate.com','DirkBerringer@hotmail.com',NULL,'Dirk','Berringer'),(36,'9 Memory Lane',NULL,'Rochester','HI','49212','1379311246','1340649445','http://www.wazoo.com','OliverBerringer@cutekitties.org',NULL,'Oliver','Berringer'),(37,'475 Memory Lane',NULL,'Ogdensburg','MS','61740','1323953228','1266854412','http://www.wazoo.com','Mndrix597@hotmail.com',NULL,'Marko','Hendrix'),(38,'49 Infinite Loop',NULL,'Watertown','MI','33639','1694479572','1878040736','http://www.bigfoot.com','TrishXiu@cutekitties.org',NULL,'Trish','Xiu'),(39,'968 123rd St.',NULL,'Schenectady','WA','24597','1632298660','1480022636','http://www.bigfoot.com','Joe-joeGoodall@netdot.net',NULL,'Joe-joe','Goodall'),(40,'976 2nd Avenue',NULL,'Buffalo','MN','36140','1262376695','1874075569','http://www.loser.com','GeraldineNewton@nicefoundation.org',NULL,'Geraldine','Newton'),(41,'322 Electric Ave',NULL,'Fulton','MA','45042','1374414639','1351213078','http://www.loser.com','TomEinstein@corporate.com',NULL,'Tom','Einstein'),(42,'46 2nd Street',NULL,'Peekskill','AR','22425','1754162149','1315813224','http://www.loser.com','JerryFranklin@bigfoot.com',NULL,'Jerry','Franklin'),(43,'123 Sesame St.',NULL,'Auburn','TN','83233','1565429619','1857356306','http://www.mac.com','Sanck930@corporate.com',NULL,'Sam','Planck'),(44,'237 Elm St.',NULL,'Yonkers','TN','71128','1878779119','1521777629','http://www.evilempire.net','Mplin124@mac.com',NULL,'Marko','Joplin'),(45,'586 Memory Lane',NULL,'Corning','WY','23773','1923180433','1569581022','http://www.netdot.net','Arker542@corporate.com',NULL,'Ali','Parker'),(46,'223 3rd Street',NULL,'Hudson','KS','17325','1852031246','1389863649','http://www.gmail.com','MaryPlanck@gmail.com',NULL,'Mary','Planck'),(47,'668 Elm St.',NULL,'Lackawanna','HI','65454','1691727638','1593108163','http://www.wazoo.com','Nison567@nicefoundation.org',NULL,'Nick','Edison'),(48,'946 3rd Street',NULL,'Plattsburgh','NH','50768','1323220308','1712935623','http://www.wazoo.com','Joe-joeXiu@hotmail.com',NULL,'Joe-joe','Xiu'),(49,'311 3rd Street',NULL,'Hudson','MO','53987','1820235915','1837017432','http://www.bigfoot.com','Tndrix913@netdot.net',NULL,'Trish','Hendrix'),(50,'842 2nd Avenue',NULL,'Ogdensburg','WA','49032','1376101216','1436436742','http://www.candyapples.com','SamMartinez@corporate.com',NULL,'Sam','Martinez'),(51,'326 1st Avenue',NULL,'White Plains','WV','68276','1434281387','1391425918','http://www.corporate.com','MaryTuring@candyapples.com',NULL,'Mary','Turing'),(52,'11 3rd Street',NULL,'Geneva','AR','84216','1239862132','1906734486','http://www.loser.com','Dpler659@yahoo.com',NULL,'Dirk','Kepler'),(53,'810 Sesame St.',NULL,'Cortland','NE','38447','1839781208','1542457425','http://www.nicefoundation.org','Trker208@mac.com',NULL,'Trish','Parker'),(54,'905 Long Long Way',NULL,'Johnstown','CO','23301','1604273896','1333583444','http://www.gmail.com','LouisNewton@loser.com',NULL,'Louis','Newton'),(55,'579 Long Long Way',NULL,'Mount Vernon','DC','12088','1248778770','1667427931','http://www.corporate.com','JerryBerringer@evilempire.net',NULL,'Jerry','Berringer'),(56,'613 ABC Ave.',NULL,'Port Jervis','AL','69279','1560796395','1350939470','http://www.nicefoundation.org','Awton601@hotmail.com',NULL,'Ali','Newton'),(57,'569 Sesame St.',NULL,'Elmira','NM','12587','1692535809','1804105527','http://www.loser.com','Gplin838@yahoo.com',NULL,'Geraldine','Joplin'),(58,'587 3rd Avenue',NULL,'Amsterdam','AR','73036','1550258803','1780636366','http://www.yahoo.com','LouisHendrix@hotmail.com',NULL,'Louis','Hendrix'),(59,'543 Elm St.',NULL,'Elmira','MI','77877','1656690343','1945743427','http://www.evilempire.net','BarackFreud@loser.com',NULL,'Barack','Freud'),(60,'199 1st Avenue',NULL,'Troy','ME','85965','1269285791','1451693484','http://www.nicefoundation.org','Andis569@nicefoundation.org',NULL,'Arnold','Landis'),(61,'880 1st Avenue',NULL,'Gloversville','NM','50297','1284443436','1908868504','http://www.evilempire.net','Grker194@gmail.com',NULL,'Geraldine','Parker'),(62,'57 3rd Street',NULL,'Lackawanna','TX','29408','1654598209','1639821067','http://www.candyapples.com','HarryTesla@bigfoot.com',NULL,'Harry','Tesla'),(63,'458 1st Street',NULL,'Rochester','ND','43967','1653516006','1771715820','http://www.candyapples.com','MaryFranklin@mac.com',NULL,'Mary','Franklin'),(64,'602 Memory Lane',NULL,'Cohoes','NM','10354','1750100051','1726885483','http://www.netdot.net','Andis260@gmail.com',NULL,'Arnold','Landis'),(65,'84 Infinite Loop',NULL,'Hornell','SC','60017','1594738463','1644193816','http://www.loser.com','HarryParker@hotmail.com',NULL,'Harry','Parker'),(66,'564 123rd St.',NULL,'Cohoes','VT','81126','1592083160','1688731925','http://www.hotmail.com','Cpler106@nicefoundation.org',NULL,'Cicero','Kepler'),(67,'967 2nd Street',NULL,'Peekskill','NV','27088','1352299161','1620869626','http://www.wazoo.com','MelanieHendrix@hotmail.com',NULL,'Melanie','Hendrix'),(68,'404 1st Street',NULL,'Buffalo','UT','66234','1911295372','1473533252','http://www.netdot.net','Jmanujan322@wazoo.com',NULL,'Jerry','Ramanujan'),(69,'75 1st Avenue',NULL,'Buffalo','VT','17057','1298991876','1668714998','http://www.nicefoundation.org','Dndis151@evilempire.net',NULL,'Derrick','Landis'),(70,'251 2nd Avenue',NULL,'Elmira','WI','26858','1696770136','1721259069','http://www.loser.com','Tnstein981@gmail.com',NULL,'Tom','Einstein'),(71,'422 Memory Lane',NULL,'Port Jervis','MI','15757','1715543745','1817295163','http://www.candyapples.com','MelanieJoplin@cutekitties.org',NULL,'Melanie','Joplin'),(72,'631 3rd Street',NULL,'Salamanca','AK','86441','1889655090','1933469399','http://www.loser.com','Bring792@corporate.com',NULL,'Bobby','Turing'),(73,'14 Infinite Loop',NULL,'Gloversville','VA','18312','1896557441','1877967968','http://www.loser.com','AliTurner@evilempire.net',NULL,'Ali','Turner'),(74,'792 Elm St.',NULL,'Mount Vernon','IA','12909','1276072638','1884802047','http://www.nicefoundation.org','Hwton263@cutekitties.org',NULL,'Harry','Newton'),(75,'360 Sesame St.',NULL,'Rome','HI','71222','1347826630','1906508335','http://www.gmail.com','Mison297@corporate.com',NULL,'Marko','Edison'),(2118,'100 123rd St.',NULL,'Norwich','MI','10324','1820511385','1365184289','http://www.candyapples.com','Hanklin588@bigfoot.com',NULL,'Hanna','Franklin'),(2119,'552 2nd Street',NULL,'Plattsburgh','NV','34761','1528320481','1438448305','http://www.hotmail.com','JoeGoodall@evilempire.net',NULL,'Joe','Goodall'),(2120,'380 Happy Town St.',NULL,'Tonawanda','KS','28355','1354363770','1496542331','http://www.loser.com','Drner606@yahoo.com',NULL,'Derrick','Turner'),(2121,'732 2nd Street',NULL,'Jamestown','TX','43282','1908479770','1558351361','http://www.bigfoot.com','Joe-joeBerringer@hotmail.com',NULL,'Joe-joe','Berringer'),(2122,'293 3rd Avenue',NULL,'Schenectady','NC','68313','1816529220','1914970720','http://www.mac.com','Hmanujan267@candyapples.com',NULL,'Harry','Ramanujan'),(2123,'952 Long Long Way',NULL,'Corning','WY','60112','1332425691','1700595897','http://www.netdot.net','Joe-joeReynolds@bigfoot.com',NULL,'Joe-joe','Reynolds'),(2124,'834 Happy Town St.',NULL,'Schenectady','NH','21713','1259329206','1255509174','http://www.mac.com','Mwton100@evilempire.net',NULL,'Melanie','Newton'),(2125,'967 Elm St.',NULL,'Long Beach','MD','21275','1425148426','1845453272','http://www.yahoo.com','Ltson578@yahoo.com',NULL,'Lonnie','Ottson'),(2126,'21 Winners Circle',NULL,'Niagara Falls','WI','99533','1595522641','1518849628','http://www.loser.com','Jpata509@nicefoundation.org',NULL,'Jerry','Zapata'),(2127,'981 2nd Street',NULL,'Watertown','IL','46084','1798605479','1946281098','http://www.mac.com','Bpata172@corporate.com',NULL,'Barbie','Zapata'),(2128,'815 Memory Lane',NULL,'Ogdensburg','LA','93445','1965451613','1401662695','http://www.yahoo.com','HannaHendrix@cutekitties.org',NULL,'Hanna','Hendrix'),(2129,'364 Sesame St.',NULL,'Oneonta','IA','12847','1252242334','1550986754','http://www.evilempire.net','JulesFoster@nicefoundation.org',NULL,'Jules','Foster'),(2130,'210 3rd Avenue',NULL,'Elmira','AL','76364','1799163020','1327390752','http://www.nicefoundation.org','JerryZapata@yahoo.com',NULL,'Jerry','Zapata'),(2131,'666 Memory Lane',NULL,'Canandaigua','LA','70665','1556164751','1909086263','http://www.hotmail.com','Cring808@netdot.net',NULL,'Cicero','Turing'),(2132,'336 3rd Street',NULL,'Canandaigua','NY','30082','1671660017','1930855839','http://www.evilempire.net','BarackEdison@bigfoot.com',NULL,'Barack','Edison'),(2133,'106 Infinite Loop',NULL,'Cohoes','IL','51573','1471220943','1721084342','http://www.loser.com','BobbyRamanujan@nicefoundation.org',NULL,'Bobby','Ramanujan'),(2134,'379 ABC Ave.',NULL,'Schenectady','NH','41577','1582331030','1932231517','http://www.hotmail.com','BarackGoodall@nicefoundation.org',NULL,'Barack','Goodall'),(2135,'433 1st Avenue',NULL,'Saratoga Springs','NC','55094','1853834098','1993590659','http://www.netdot.net','GeraldineOttson@mac.com',NULL,'Geraldine','Ottson'),(2136,'30 Winners Circle',NULL,'Binghamton','VT','69318','1505746572','1517618644','http://www.yahoo.com','Dsla223@yahoo.com',NULL,'Derrick','Tesla'),(2137,'93 1st Avenue',NULL,'New York','KS','64551','1876296317','1576770262','http://www.netdot.net','Tsla730@loser.com',NULL,'Trish','Tesla'),(2138,'970 3rd Avenue',NULL,'Geneva','ME','13421','1371996270','1887857742','http://www.gmail.com','Dmanujan715@netdot.net',NULL,'Derrick','Ramanujan'),(2139,'678 1st Street',NULL,'Oneonta','IL','34572','1909063370','1987353236','http://www.hotmail.com','Nrringer353@hotmail.com',NULL,'Nick','Berringer'),(2140,'257 Long Long Way',NULL,'Fulton','VA','69180','1464160241','1485509787','http://www.loser.com','Whr946@candyapples.com',NULL,'Wendy','Bohr'),(2141,'893 Electric Ave',NULL,'Ogdensburg','CT','29771','1471402463','1246480900','http://www.gmail.com','Nster501@hotmail.com',NULL,'Nick','Foster'),(2142,'370 1st Street',NULL,'Long Beach','NC','25574','1278655637','1891731914','http://www.netdot.net','Jllen229@netdot.net',NULL,'Joe','Kollen'),(2143,'590 Happy Town St.',NULL,'Binghamton','VT','90573','1236783345','1564777026','http://www.candyapples.com','Bwton971@netdot.net',NULL,'Bobby','Newton'),(2144,'992 Foobar Rd.',NULL,'Rochester','WI','14076','1851803005','1591898554','http://www.mac.com','WendyKepler@candyapples.com',NULL,'Wendy','Kepler'),(2145,'82 ABC Ave.',NULL,'Newburgh','DC','20249','1933622619','1662394142','http://www.bigfoot.com','DirkOttson@gmail.com',NULL,'Dirk','Ottson'),(2146,'115 2nd Street',NULL,'Tonawanda','NC','11603','1693560650','1788786634','http://www.candyapples.com','HarryOttson@bigfoot.com',NULL,'Harry','Ottson'),(2147,'678 Foobar Rd.',NULL,'Jamestown','OH','38477','1339790100','1925483348','http://www.gmail.com','LouisOttson@hotmail.com',NULL,'Louis','Ottson'),(2148,'246 Foobar Rd.',NULL,'Niagara Falls','PA','59711','1725101188','1995428552','http://www.yahoo.com','Au573@wazoo.com',NULL,'Ali','Xiu'),(2149,'462 Foobar Rd.',NULL,'Amsterdam','ND','66987','1697130962','1649188542','http://www.gmail.com','Mrker330@yahoo.com',NULL,'Melanie','Parker'),(2150,'49 2nd Street',NULL,'New Rochelle','WA','10377','1735388933','1966440913','http://www.evilempire.net','Nster869@netdot.net',NULL,'Nick','Foster'),(2151,'616 Long Long Way',NULL,'Niagara Falls','CO','45618','1350368002','1919469745','http://www.mac.com','Jndrix486@bigfoot.com',NULL,'Joe-joe','Hendrix'),(2152,'714 Elm St.',NULL,'Corning','AL','70119','1360182604','1791628621','http://www.nicefoundation.org','Jndis315@mac.com',NULL,'Jules','Landis'),(2153,'443 1st Street',NULL,'Johnstown','MA','12412','1946049787','1947063367','http://www.corporate.com','LouisLandis@mac.com',NULL,'Louis','Landis'),(2154,'538 3rd Avenue',NULL,'Poughkeepsie','KY','74712','1967923743','1638873582','http://www.candyapples.com','JoeOttson@hotmail.com',NULL,'Joe','Ottson'),(2155,'985 Memory Lane',NULL,'New Rochelle','IL','73371','1926442144','1415876798','http://www.wazoo.com','Jplin262@candyapples.com',NULL,'Jules','Joplin'),(2156,'284 Electric Ave',NULL,'Hornell','IL','13807','1673361431','1323092972','http://www.corporate.com','TomBohr@evilempire.net',NULL,'Tom','Bohr'),(2157,'614 Winners Circle',NULL,'Long Beach','MO','81141','1295881161','1890320252','http://www.hotmail.com','BarackPlanck@yahoo.com',NULL,'Barack','Planck'),(2158,'604 Happy Town St.',NULL,'Batavia','ND','62142','1883109290','1374663165','http://www.gmail.com','JerryFreud@wazoo.com',NULL,'Jerry','Freud'),(2159,'571 1st Street',NULL,'Ogdensburg','UT','90827','1942843518','1746995384','http://www.evilempire.net','SamFoster@evilempire.net',NULL,'Sam','Foster'),(2160,'788 Foobar Rd.',NULL,'Lockport','SD','11195','1420394812','1727781231','http://www.hotmail.com','BarbieNewton@loser.com',NULL,'Barbie','Newton'),(2161,'537 Infinite Loop',NULL,'Norwich','FL','20879','1363781629','1881984740','http://www.nicefoundation.org','Hnstein194@gmail.com',NULL,'Harry','Einstein'),(2162,'924 3rd Street',NULL,'Oneonta','IA','65738','1685615316','1700214613','http://www.bigfoot.com','DerrickTuring@yahoo.com',NULL,'Derrick','Turing'),(2163,'86 3rd Street',NULL,'Middletown','MD','88774','1751974708','1260711177','http://www.cutekitties.org','TrishRamanujan@bigfoot.com',NULL,'Trish','Ramanujan'),(2164,'749 Infinite Loop',NULL,'North Tonawanda','NY','62504','1390508435','1936616113','http://www.loser.com','BobbyParker@candyapples.com',NULL,'Bobby','Parker'),(2165,'899 3rd Street',NULL,'Amsterdam','AK','52281','1304279054','1683430628','http://www.gmail.com','CiceroKepler@netdot.net',NULL,'Cicero','Kepler'),(2166,'829 Happy Town St.',NULL,'Auburn','KS','62726','1896888345','1892791101','http://www.cutekitties.org','Dsla834@yahoo.com',NULL,'Dick','Tesla'),(2167,'600 Winners Circle',NULL,'Buffalo','MI','90772','1626045753','1534604773','http://www.cutekitties.org','WendyFoster@evilempire.net',NULL,'Wendy','Foster'),(2168,'251 1st Avenue',NULL,'Cohoes','MI','76679','1862180883','1910012355','http://www.evilempire.net','Tanklin988@evilempire.net',NULL,'Trish','Franklin'),(2169,'17 1st Avenue',NULL,'Auburn','NE','34039','1604643111','1431916617','http://www.yahoo.com','Mddard10@hotmail.com',NULL,'Melanie','Goddard'),(2170,'149 1st Avenue',NULL,'Corning','CA','86993','1611582165','1586474065','http://www.mac.com','JoeZapata@candyapples.com',NULL,'Joe','Zapata'),(2171,'434 1st Street',NULL,'Schenectady','IL','82036','1617705910','1725074690','http://www.nicefoundation.org','Andis269@wazoo.com',NULL,'Arnold','Landis'),(2172,'899 ABC Ave.',NULL,'Schenectady','MA','39035','1571561355','1351487445','http://www.corporate.com','Brker999@mac.com',NULL,'Barbie','Parker'),(2173,'268 123rd St.',NULL,'Auburn','AL','24193','1569300976','1394439501','http://www.bigfoot.com','Andis125@evilempire.net',NULL,'Ali','Landis'),(2174,'36 Memory Lane',NULL,'Oneonta','DE','16040','1967732185','1879098746','http://www.evilempire.net','Hpler988@hotmail.com',NULL,'Hanna','Kepler'),(2175,'548 Electric Ave',NULL,'Mount Vernon','NC','10028','1386779247','1369457652','http://www.mac.com','TomJoplin@hotmail.com',NULL,'Tom','Joplin'),(2176,'45 Sesame St.',NULL,'Rye','AR','50643','1492208470','1452388081','http://www.nicefoundation.org','AliGoodall@corporate.com',NULL,'Ali','Goodall'),(2177,'45 Happy Town St.',NULL,'Kingston','AK','42788','1262441051','1512150349','http://www.corporate.com','Gster35@netdot.net',NULL,'Geraldine','Foster'),(2178,'336 ABC Ave.',NULL,'Troy','CT','35399','1466947824','1931616111','http://www.netdot.net','FrancesEinstein@candyapples.com',NULL,'Frances','Einstein'),(2179,'427 Sesame St.',NULL,'Binghamton','AL','51643','1551950300','1238140181','http://www.cutekitties.org','Jison846@candyapples.com',NULL,'Joe','Edison'),(2180,'242 ABC Ave.',NULL,'Dunkirk','HI','18381','1268066916','1572758763','http://www.corporate.com','Btson458@gmail.com',NULL,'Barbie','Ottson'),(2181,'786 123rd St.',NULL,'New Rochelle','IN','73950','1870854143','1607520300','http://www.candyapples.com','MaryEinstein@cutekitties.org',NULL,'Mary','Einstein'),(2182,'165 Infinite Loop',NULL,'Buffalo','NC','74769','1878303711','1982377667','http://www.nicefoundation.org','Lllen785@nicefoundation.org',NULL,'Lonnie','Kollen'),(2183,'384 ABC Ave.',NULL,'Port Jervis','VT','60388','1570716755','1592181888','http://www.wazoo.com','CiceroRamanujan@yahoo.com',NULL,'Cicero','Ramanujan'),(2184,'232 1st Avenue',NULL,'Dunkirk','NC','33074','1694681246','1261540161','http://www.loser.com','MelanieTesla@evilempire.net',NULL,'Melanie','Tesla'),(2185,'291 Memory Lane',NULL,'Jamestown','NY','14754','1295077673','1934515459','http://www.yahoo.com','WendyLandis@hotmail.com',NULL,'Wendy','Landis'),(2186,'428 2nd Avenue',NULL,'Troy','CO','91680','1533556568','1992519523','http://www.yahoo.com','LouisGoodall@mac.com',NULL,'Louis','Goodall'),(2187,'325 Electric Ave',NULL,'Beacon','WI','52135','1733373582','1934811003','http://www.loser.com','FrancesEdison@loser.com',NULL,'Frances','Edison'),(2188,'496 Sesame St.',NULL,'Troy','NE','55373','1444832025','1986640826','http://www.yahoo.com','Mnstein704@evilempire.net',NULL,'Mary','Einstein'),(2189,'493 Happy Town St.',NULL,'Troy','MI','80258','1751357720','1324171321','http://www.evilempire.net','BobbyFreud@candyapples.com',NULL,'Bobby','Freud'),(2190,'757 ABC Ave.',NULL,'Lockport','RI','24748','1759162033','1451522932','http://www.corporate.com','Hshlachev941@corporate.com',NULL,'Hanna','Bashlachev'),(2191,'14 123rd St.',NULL,'Johnstown','DE','35738','1522229325','1365210924','http://www.evilempire.net','BarackFranklin@netdot.net',NULL,'Barack','Franklin'),(2192,'809 1st Avenue',NULL,'Auburn','IL','68500','1603004991','1855091380','http://www.gmail.com','Hpler919@loser.com',NULL,'Harry','Kepler');
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL,
  `customer_since` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `person_id_UNIQUE` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=355 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,26,'2012-04-20 09:00:39'),(2,27,'2012-04-20 09:00:39'),(3,28,'2012-04-20 09:00:39'),(4,29,'2012-04-20 09:00:39'),(5,30,'2012-04-20 09:00:39'),(6,31,'2012-04-20 09:00:39'),(7,32,'2012-04-20 09:00:39'),(8,33,'2012-04-20 09:00:39'),(9,34,'2012-04-20 09:00:39'),(10,35,'2012-04-20 09:00:39'),(11,36,'2012-04-20 09:00:39'),(12,37,'2012-04-20 09:00:39'),(13,38,'2012-04-20 09:00:39'),(14,39,'2012-04-20 09:00:39'),(15,40,'2012-04-20 09:00:39'),(16,41,'2012-04-20 09:00:39'),(17,42,'2012-04-20 09:00:39'),(18,43,'2012-04-20 09:00:39'),(19,44,'2012-04-20 09:00:39'),(20,45,'2012-04-20 09:00:39'),(21,46,'2012-04-20 09:00:39'),(22,47,'2012-04-20 09:00:39'),(23,48,'2012-04-20 09:00:39'),(24,49,'2012-04-20 09:00:39'),(25,50,'2012-04-20 09:00:39');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `days_off`
--

DROP TABLE IF EXISTS `days_off`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `days_off` (
  `employee_id` int(11) NOT NULL,
  `request_submitted_on` date NOT NULL,
  `reason` varchar(255) NOT NULL,
  `approved_on` date DEFAULT NULL,
  `date_taken_off` date NOT NULL,
  PRIMARY KEY (`employee_id`,`date_taken_off`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `days_off`
--

LOCK TABLES `days_off` WRITE;
/*!40000 ALTER TABLE `days_off` DISABLE KEYS */;
INSERT INTO `days_off` VALUES (1,'2002-07-08','Same old reason.','2007-10-13','2002-07-08'),(2,'2002-08-15','Same old reason.','2012-01-19','2002-08-15'),(3,'2006-08-07','Same old reason.','2001-02-15','2006-08-07'),(4,'2012-06-19','Same old reason.','2007-10-27','2012-06-19'),(5,'2009-03-10','Same old reason.','2004-06-20','2009-03-10'),(6,'2009-12-03','Same old reason.','2009-05-17','2009-12-03'),(7,'2007-10-05','Same old reason.','2001-01-04','2007-10-05'),(8,'2003-11-06','Same old reason.','2010-12-20','2003-11-06'),(9,'2009-05-17','Same old reason.','2012-09-02','2009-05-17'),(10,'2005-07-11','Same old reason.','2002-08-24','2005-07-11'),(11,'2002-03-23','Same old reason.','2011-12-28','2002-03-23'),(12,'2010-03-21','Same old reason.','2010-05-13','2010-03-21'),(13,'2007-02-28','Same old reason.','2006-06-07','2007-02-28'),(14,'2003-11-16','Same old reason.','2001-05-02','2003-11-16'),(15,'2010-06-28','Same old reason.','2000-09-14','2010-06-28'),(16,'2005-06-01','Same old reason.','2008-12-05','2005-06-01'),(17,'2003-06-20','Same old reason.','2006-07-06','2003-06-20'),(18,'2000-11-11','Same old reason.','2002-05-19','2000-11-11'),(19,'2012-02-18','Same old reason.','2011-12-09','2012-02-18'),(20,'2003-09-01','Same old reason.','2001-05-28','2003-09-01'),(21,'2005-02-26','Same old reason.','2002-07-13','2005-02-26'),(22,'2006-11-21','Same old reason.','2012-08-19','2006-11-21'),(23,'2003-05-22','Same old reason.','2011-12-28','2003-05-22'),(24,'2006-04-05','Same old reason.','2003-04-20','2006-04-05'),(25,'2006-11-22','Same old reason.','2005-12-23','2006-11-22');
/*!40000 ALTER TABLE `days_off` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergency_contact`
--

DROP TABLE IF EXISTS `emergency_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emergency_contact` (
  `contact_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `relationship` varchar(255) NOT NULL,
  PRIMARY KEY (`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_contact`
--

LOCK TABLES `emergency_contact` WRITE;
/*!40000 ALTER TABLE `emergency_contact` DISABLE KEYS */;
INSERT INTO `emergency_contact` VALUES (2118,1,'grandfather'),(2119,2,'sister'),(2120,3,'father'),(2121,4,'sibling'),(2122,5,'father'),(2123,6,'brother'),(2124,7,'brother'),(2125,8,'grandmother'),(2126,9,'sister'),(2127,10,'friend'),(2128,11,'friend'),(2129,12,'grandmother'),(2130,13,'father'),(2131,14,'friend'),(2132,15,'sibling'),(2133,16,'mother'),(2134,17,'grandfather'),(2135,18,'partner'),(2136,19,'sibling'),(2137,20,'brother'),(2138,21,'brother'),(2139,22,'significant other'),(2140,23,'uncle'),(2141,24,'sister'),(2142,25,'sister');
/*!40000 ALTER TABLE `emergency_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee` (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL,
  `store_number` int(11) NOT NULL,
  `pay_grade_id` int(11) NOT NULL,
  `position_id` int(11) NOT NULL,
  `ssn` decimal(9,0) NOT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `person_id_UNIQUE` (`person_id`),
  UNIQUE KEY `ssn_UNIQUE` (`ssn`)
) ENGINE=InnoDB AUTO_INCREMENT=482 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,1,1,19,14,'111111111'),(2,2,2,20,13,'111111112'),(3,3,3,9,4,'111111113'),(4,4,4,23,2,'111111114'),(5,5,5,2,20,'111111115'),(6,6,6,15,25,'111111116'),(7,7,7,13,8,'111111117'),(8,8,8,9,11,'111111118'),(9,9,9,8,13,'111111119'),(10,10,10,23,12,'111111120'),(11,11,11,19,18,'111111121'),(12,12,12,22,12,'111111122'),(13,13,13,23,9,'111111123'),(14,14,14,24,2,'111111124'),(15,15,15,9,23,'111111125'),(16,16,16,14,6,'111111126'),(17,17,17,17,23,'111111127'),(18,18,18,2,20,'111111128'),(19,19,19,20,15,'111111129'),(20,20,20,15,13,'111111130'),(21,21,21,22,4,'111111131'),(22,22,22,23,8,'111111132'),(23,23,23,13,12,'111111133'),(24,24,24,8,23,'111111134'),(25,25,25,4,2,'111111135');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_shifts`
--

DROP TABLE IF EXISTS `employee_shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee_shifts` (
  `shift_id` int(11) NOT NULL,
  `employee_id` varchar(45) NOT NULL,
  `shift_start_day` enum('Mon','Tue','Wed','Thu','Fri','Sat','Sun') NOT NULL DEFAULT 'Mon',
  `shift_start_time` time NOT NULL,
  `shift_end_day` enum('Mon','Tue','Wed','Thu','Fri','Sat','Sun') NOT NULL DEFAULT 'Mon',
  `shift_end_time` time NOT NULL,
  PRIMARY KEY (`shift_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_shifts`
--

LOCK TABLES `employee_shifts` WRITE;
/*!40000 ALTER TABLE `employee_shifts` DISABLE KEYS */;
INSERT INTO `employee_shifts` VALUES (1,'1','Fri','00:00:00','Wed','12:30:00'),(2,'2','Tue','12:00:00','Sat','12:30:00'),(3,'3','Sat','00:00:00','Wed','05:45:00'),(4,'4','Tue','00:00:00','Wed','06:15:00'),(5,'5','Sat','01:00:00','Mon','04:15:00'),(6,'6','Tue','09:30:00','Mon','09:00:00'),(7,'7','Sat','00:00:00','Fri','00:00:00'),(8,'8','Mon','03:45:00','Wed','07:00:00'),(9,'9','Sun','00:00:00','Thu','07:45:00'),(10,'10','Fri','03:15:00','Sun','08:15:00'),(11,'11','Wed','12:15:00','Sat','02:45:00'),(12,'12','Sun','01:00:00','Thu','04:45:00'),(13,'13','Fri','05:15:00','Sat','10:15:00'),(14,'14','Sun','02:15:00','Tue','00:00:00'),(15,'15','Thu','08:00:00','Tue','00:00:00'),(16,'16','Thu','07:45:00','Tue','02:15:00'),(17,'17','Sat','05:30:00','Sun','04:15:00'),(18,'18','Thu','06:45:00','Sun','00:00:00'),(19,'19','Wed','03:00:00','Thu','09:15:00'),(20,'20','Sun','09:45:00','Thu','00:00:00'),(21,'21','Sat','06:45:00','Sat','08:30:00'),(22,'22','Sat','12:00:00','Wed','00:00:00'),(23,'23','Wed','02:00:00','Sat','01:00:00'),(24,'24','Thu','02:45:00','Tue','05:15:00'),(25,'25','Wed','11:45:00','Mon','06:30:00');
/*!40000 ALTER TABLE `employee_shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genre` (
  `genre_id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Action & Adventure'),(2,'Biography & Memoirs'),(3,'Business & Finance'),(4,'Celebrity & Pop Culture'),(5,'Cookbooks'),(6,'Crime'),(7,'Current Affairs & Politics'),(8,'Fantasy'),(9,'Food & Lifestyle'),(10,'History & Military'),(11,'Horror'),(12,'Humor'),(13,'Journalism'),(14,'Multicultural'),(15,'Music, Film & Entertainment'),(16,'Mystery'),(17,'Mythology'),(18,'Nature & Ecology'),(19,'Parenting'),(20,'Pets'),(21,'Psychology'),(22,'Science Fiction'),(23,'Sports'),(24,'Travel'),(25,'Young Adult');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hire`
--

DROP TABLE IF EXISTS `hire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hire` (
  `employee_id` int(11) NOT NULL,
  `store_number` int(11) NOT NULL,
  `date_hired` date NOT NULL,
  `date_left` date DEFAULT NULL,
  `notes` text,
  `pay_grade_id` varchar(45) NOT NULL,
  PRIMARY KEY (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hire`
--

LOCK TABLES `hire` WRITE;
/*!40000 ALTER TABLE `hire` DISABLE KEYS */;
INSERT INTO `hire` VALUES (1,1,'2009-09-04',NULL,NULL,'1'),(2,2,'2008-10-06',NULL,NULL,'2'),(3,3,'2005-01-10',NULL,NULL,'3'),(4,4,'2011-04-20',NULL,NULL,'4'),(5,5,'2002-10-15',NULL,NULL,'5'),(6,6,'2009-09-11',NULL,NULL,'6'),(7,7,'2011-12-27',NULL,NULL,'7'),(8,8,'2002-08-05',NULL,NULL,'8'),(9,9,'2004-11-05',NULL,NULL,'9'),(10,10,'2001-08-08',NULL,NULL,'10'),(11,11,'2010-07-03',NULL,NULL,'11'),(12,12,'2008-03-11',NULL,NULL,'12'),(13,13,'2009-09-06',NULL,NULL,'13'),(14,14,'2010-07-14',NULL,NULL,'14'),(15,15,'2005-02-09',NULL,NULL,'15'),(16,16,'2005-11-28',NULL,NULL,'16'),(17,17,'2008-09-19',NULL,NULL,'17'),(18,18,'2012-10-17',NULL,NULL,'18'),(19,19,'2004-10-01',NULL,NULL,'19'),(20,20,'2004-11-03',NULL,NULL,'20'),(21,21,'2002-10-02',NULL,NULL,'21'),(22,22,'2008-11-16',NULL,NULL,'22'),(23,23,'2005-05-19',NULL,NULL,'23'),(24,24,'2003-07-11',NULL,NULL,'24'),(25,25,'2012-09-05',NULL,NULL,'25');
/*!40000 ALTER TABLE `hire` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `magazine`
--

DROP TABLE IF EXISTS `magazine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `magazine` (
  `magazine_id` int(11) NOT NULL,
  `internal_product_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `publisher_id` int(11) NOT NULL,
  `website_url` varchar(255) DEFAULT NULL,
  `issn` decimal(8,0) DEFAULT NULL,
  `genre_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`magazine_id`),
  UNIQUE KEY `internal_product_id_UNIQUE` (`internal_product_id`),
  UNIQUE KEY `magazine_id_UNIQUE` (`magazine_id`),
  UNIQUE KEY `issn_UNIQUE` (`issn`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `magazine`
--

LOCK TABLES `magazine` WRITE;
/*!40000 ALTER TABLE `magazine` DISABLE KEYS */;
INSERT INTO `magazine` VALUES (1,3292,'Games Magazine',1,'http://www.evilempire.net','12345679','1'),(2,3293,'Sword Enthusiast',2,'http://www.loser.com','12345680','2'),(3,3294,'World Monthly',3,'http://www.nicefoundation.org','12345681','3'),(4,3295,'Sex Magazine',4,'http://www.nicefoundation.org','12345682','4'),(5,3296,'Steel Journal',5,'http://www.corporate.com','12345683','5'),(6,3297,'Dances Enthusiast',6,'http://www.evilempire.net','12345684','6'),(7,3298,'Charming Monthly',7,'http://www.mac.com','12345685','7'),(8,3299,'Dances Enthusiast',8,'http://www.wazoo.com','12345686','8'),(9,3300,'Charming Enthusiast',9,'http://www.gmail.com','12345687','9'),(10,3301,'Sex Quarterly',10,'http://www.mac.com','12345688','10'),(11,3302,'Earth Enthusiast',11,'http://www.yahoo.com','12345689','11'),(12,3303,'Cyberspace Enthusiast',12,'http://www.mac.com','12345690','12'),(13,3304,'Sword Monthly',13,'http://www.hotmail.com','12345691','13'),(14,3305,'Political Journal',14,'http://www.hotmail.com','12345692','14'),(15,3306,'Lost Magazine',15,'http://www.nicefoundation.org','12345693','15'),(16,3307,'Fire Journal',16,'http://www.wazoo.com','12345694','16'),(17,3308,'Play Magazine',17,'http://www.mac.com','12345695','17'),(18,3309,'Cyberspace Monthly',18,'http://www.cutekitties.org','12345696','18'),(19,3310,'Hunger Enthusiast',19,'http://www.loser.com','12345697','19'),(20,3311,'Fire Enthusiast',20,'http://www.gmail.com','12345698','20'),(21,3312,'Time Journal',21,'http://www.netdot.net','12345699','21'),(22,3313,'Education Monthly',22,'http://www.corporate.com','12345700','22'),(23,3314,'Charming Monthly',23,'http://www.cutekitties.org','12345701','23'),(24,3315,'Turtle Monthly',24,'http://www.gmail.com','12345702','24'),(25,3316,'Sun Magazine',25,'http://www.candyapples.com','12345703','25');
/*!40000 ALTER TABLE `magazine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `internal_product_id` varchar(45) NOT NULL,
  `order_date` date NOT NULL,
  `quantity` int(11) NOT NULL,
  `order_total` decimal(9,2) NOT NULL,
  `price_per_unit` decimal(6,2) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `type` enum('first','reorder') DEFAULT 'first',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1776 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1701,'3267','2010-07-28',3445,'364506.00','11.00',1,'first'),(1702,'3268','2007-11-07',6498,'697002.00','15.00',2,'first'),(1703,'3269','2012-12-07',8549,'797376.00','3.00',3,'first'),(1704,'3270','2005-09-19',9655,'308127.00','11.00',4,'first'),(1705,'3271','2007-02-11',768,'22501.00','6.00',5,'first'),(1706,'3272','2000-02-19',8249,'834592.00','10.00',6,'first'),(1707,'3273','2009-12-11',8455,'719854.00','1.00',7,'first'),(1708,'3274','2003-11-08',3426,'697344.00','9.00',8,'first'),(1709,'3275','2012-01-08',6068,'424081.00','2.00',9,'first'),(1710,'3276','2010-09-26',3935,'698650.00','14.00',10,'first'),(1711,'3277','2011-12-17',5524,'866810.00','12.00',11,'first'),(1712,'3278','2008-11-01',3013,'664005.00','12.00',12,'first'),(1713,'3279','2006-01-17',3603,'373935.00','1.00',13,'first'),(1714,'3280','2002-01-08',8263,'523551.00','13.00',14,'first'),(1715,'3281','2009-12-18',6053,'488309.00','15.00',15,'first'),(1716,'3282','2000-12-19',1490,'407423.00','15.00',16,'first'),(1717,'3283','2002-12-27',9047,'881422.00','8.00',17,'first'),(1718,'3284','2003-08-22',7562,'94130.00','11.00',18,'first'),(1719,'3285','2008-02-20',9999,'194142.00','5.00',19,'first'),(1720,'3286','2008-02-10',6170,'950106.00','6.00',20,'first'),(1721,'3287','2003-06-19',2924,'21041.00','10.00',21,'first'),(1722,'3288','2006-09-24',6203,'923313.00','12.00',22,'first'),(1723,'3289','2006-11-06',9574,'189878.00','13.00',23,'first'),(1724,'3290','2003-05-27',6086,'49939.00','9.00',24,'first'),(1725,'3291','2005-01-15',8996,'131102.00','13.00',25,'first'),(1726,'3292','2000-08-19',6873,'536059.00','12.00',1,'first'),(1727,'3293','2001-08-21',1531,'787071.00','15.00',2,'first'),(1728,'3294','2011-02-11',1490,'292109.00','4.00',3,'first'),(1729,'3295','2008-02-24',3286,'940648.00','14.00',4,'first'),(1730,'3296','2008-10-25',7633,'203781.00','1.00',5,'first'),(1731,'3297','2006-05-23',4634,'126387.00','9.00',6,'first'),(1732,'3298','2000-06-24',1330,'750675.00','11.00',7,'first'),(1733,'3299','2007-12-07',1216,'13273.00','1.00',8,'first'),(1734,'3300','2000-07-21',1081,'936340.00','8.00',9,'first'),(1735,'3301','2005-08-23',7149,'599121.00','2.00',10,'first'),(1736,'3302','2011-08-08',7852,'571764.00','12.00',11,'first'),(1737,'3303','2012-05-08',4203,'729860.00','13.00',12,'first'),(1738,'3304','2006-05-13',4151,'338930.00','10.00',13,'first'),(1739,'3305','2010-07-04',4628,'472723.00','15.00',14,'first'),(1740,'3306','2001-07-18',1251,'536000.00','8.00',15,'first'),(1741,'3307','2000-12-11',4019,'524510.00','15.00',16,'first'),(1742,'3308','2010-04-27',2965,'476379.00','14.00',17,'first'),(1743,'3309','2012-07-20',923,'266451.00','4.00',18,'first'),(1744,'3310','2010-05-14',1704,'388979.00','7.00',19,'first'),(1745,'3311','2008-02-14',114,'781448.00','2.00',20,'first'),(1746,'3312','2004-06-14',8918,'419428.00','7.00',21,'first'),(1747,'3313','2007-12-27',7697,'836161.00','5.00',22,'first'),(1748,'3314','2005-12-13',8381,'215902.00','14.00',23,'first'),(1749,'3315','2003-12-27',6525,'635858.00','12.00',24,'first'),(1750,'3316','2002-04-16',8062,'992700.00','10.00',25,'first'),(1751,'3317','2001-01-01',6253,'485539.00','4.00',1,'first'),(1752,'3318','2001-06-28',7541,'65902.00','6.00',2,'first'),(1753,'3319','2009-05-16',9162,'171940.00','8.00',3,'first'),(1754,'3320','2012-11-14',2043,'21802.00','5.00',4,'first'),(1755,'3321','2011-03-07',1470,'417759.00','5.00',5,'first'),(1756,'3322','2001-02-03',4987,'213384.00','9.00',6,'first'),(1757,'3323','2006-11-28',2132,'893118.00','11.00',7,'first'),(1758,'3324','2004-02-26',6648,'231638.00','11.00',8,'first'),(1759,'3325','2006-01-15',1828,'285744.00','2.00',9,'first'),(1760,'3326','2011-06-11',193,'775369.00','15.00',10,'first'),(1761,'3327','2009-01-07',6367,'940906.00','13.00',11,'first'),(1762,'3328','2006-04-06',8731,'921256.00','7.00',12,'first'),(1763,'3329','2009-12-19',5625,'701992.00','14.00',13,'first'),(1764,'3330','2010-04-02',8761,'345698.00','6.00',14,'first'),(1765,'3331','2002-07-05',5453,'102230.00','2.00',15,'first'),(1766,'3332','2011-07-02',4577,'960290.00','11.00',16,'first'),(1767,'3333','2002-05-28',2725,'320453.00','6.00',17,'first'),(1768,'3334','2012-12-22',4462,'128337.00','3.00',18,'first'),(1769,'3335','2010-10-09',1665,'111287.00','7.00',19,'first'),(1770,'3336','2002-04-10',5408,'955696.00','15.00',20,'first'),(1771,'3337','2007-07-07',1366,'780858.00','6.00',21,'first'),(1772,'3338','2001-06-20',7232,'745986.00','1.00',22,'first'),(1773,'3339','2001-01-17',3976,'509113.00','6.00',23,'first'),(1774,'3340','2008-11-16',609,'360731.00','10.00',24,'first'),(1775,'3341','2002-01-15',8997,'76156.00','1.00',25,'first');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `other_item`
--

DROP TABLE IF EXISTS `other_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `other_item` (
  `item_id` int(11) NOT NULL,
  `internal_product_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `manufacturer` varchar(255) NOT NULL,
  `website_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `internal_product_id_UNIQUE` (`internal_product_id`),
  UNIQUE KEY `magazine_id_UNIQUE` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `other_item`
--

LOCK TABLES `other_item` WRITE;
/*!40000 ALTER TABLE `other_item` DISABLE KEYS */;
INSERT INTO `other_item` VALUES (1,3317,'Healing Book Cover','Knife Industries','http://www.bigfoot.com'),(2,3318,'Games E-Reader','Play Ltd.','http://www.yahoo.com'),(3,3319,'Foul Desk Calendar','Daredevil Holdings','http://www.evilempire.net'),(4,3320,'Charming Reading Light','Bird Holdings','http://www.evilempire.net'),(5,3321,'Sword Fridge Magnets','World Co.','http://www.netdot.net'),(6,3322,'Jewelry Book Cover','Avenger Ltd.','http://www.corporate.com'),(7,3323,'Play E-Reader','Dances Inc.','http://www.bigfoot.com'),(8,3324,'Knife Booklight','Knife Co.','http://www.hotmail.com'),(9,3325,'Hunger Calendar','Underworld Enterprises','http://www.corporate.com'),(10,3326,'Political Booklight','Bird Ltd.','http://www.hotmail.com'),(11,3327,'Lion Calendar','Blood Inc.','http://www.yahoo.com'),(12,3328,'Blood Desk Calendar','Knife Holdings','http://www.loser.com'),(13,3329,'Knife Fridge Magnets','Sex Industries','http://www.corporate.com'),(14,3330,'Education Bookmark','Blood Holdings','http://www.evilempire.net'),(15,3331,'Earth Reading Light','Steel Industries','http://www.wazoo.com'),(16,3332,'Games E-Reader','Education Corporation','http://www.yahoo.com'),(17,3333,'Time Booklight','Love Holdings','http://www.hotmail.com'),(18,3334,'Play Bookmark','Love Industries','http://www.wazoo.com'),(19,3335,'Earth Wall Calendar','Sun Holdings','http://www.yahoo.com'),(20,3336,'Hunger E-Reader','Fire Inc.','http://www.gmail.com'),(21,3337,'Diamond Booklight','Love Inc.','http://www.nicefoundation.org'),(22,3338,'Sword Fridge Magnets','Jewelry Inc.','http://www.nicefoundation.org'),(23,3339,'Cyberspace Desk Calendar','Avenger Ltd.','http://www.hotmail.com'),(24,3340,'Avenger Book Cover','Political Industries','http://www.cutekitties.org'),(25,3341,'Lost Fridge Magnets','Wizard Enterprises','http://www.wazoo.com');
/*!40000 ALTER TABLE `other_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pay_grade`
--

DROP TABLE IF EXISTS `pay_grade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pay_grade` (
  `pay_grade_id` int(11) NOT NULL AUTO_INCREMENT,
  `annual_salary` decimal(9,2) NOT NULL DEFAULT '0.00',
  `days_vacation` int(11) NOT NULL DEFAULT '0',
  `days_sick_leave` int(11) NOT NULL DEFAULT '0',
  `benefit_dental` enum('no','yes') NOT NULL DEFAULT 'no',
  `benefit_health` enum('no','yes') NOT NULL DEFAULT 'no',
  `benefit_vision` enum('no','yes') NOT NULL DEFAULT 'no',
  PRIMARY KEY (`pay_grade_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pay_grade`
--

LOCK TABLES `pay_grade` WRITE;
/*!40000 ALTER TABLE `pay_grade` DISABLE KEYS */;
INSERT INTO `pay_grade` VALUES (1,'0.00',10,7,'no','no','no'),(2,'10000.00',11,8,'no','no','no'),(3,'20000.00',12,9,'no','no','no'),(4,'30000.00',13,10,'no','no','no'),(5,'40000.00',14,11,'no','no','no'),(6,'50000.00',15,12,'no','no','no'),(7,'60000.00',16,13,'no','no','no'),(8,'70000.00',17,14,'no','no','no'),(9,'80000.00',18,15,'no','no','no'),(10,'90000.00',19,16,'no','no','no'),(11,'100000.00',20,17,'no','no','no'),(12,'110000.00',21,18,'no','yes','no'),(13,'120000.00',22,19,'no','yes','no'),(14,'130000.00',23,20,'no','yes','no'),(15,'140000.00',24,21,'no','yes','no'),(16,'150000.00',25,22,'no','yes','no'),(17,'160000.00',26,23,'yes','yes','no'),(18,'170000.00',27,24,'yes','yes','no'),(19,'180000.00',28,25,'yes','yes','no'),(20,'190000.00',29,26,'yes','yes','no'),(21,'200000.00',30,27,'yes','yes','no'),(22,'210000.00',31,28,'yes','yes','yes'),(23,'220000.00',32,29,'yes','yes','yes'),(24,'230000.00',33,30,'yes','yes','yes'),(25,'240000.00',34,31,'yes','yes','yes');
/*!40000 ALTER TABLE `pay_grade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_review`
--

DROP TABLE IF EXISTS `performance_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `performance_review` (
  `review_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `mgr_employee_id` int(11) NOT NULL,
  `notes` text NOT NULL,
  `review_date` date NOT NULL,
  `review_grade` decimal(3,0) NOT NULL,
  PRIMARY KEY (`review_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_review`
--

LOCK TABLES `performance_review` WRITE;
/*!40000 ALTER TABLE `performance_review` DISABLE KEYS */;
INSERT INTO `performance_review` VALUES (1,1,2,'Some notes go here.','2009-01-26','89'),(2,2,3,'Some notes go here.','2008-06-25','41'),(3,3,2,'Some notes go here.','2005-04-19','55'),(4,4,3,'Some notes go here.','2011-04-20','22'),(5,5,4,'Some notes go here.','2002-04-01','32'),(6,6,5,'Some notes go here.','2009-05-05','18'),(7,7,6,'Some notes go here.','2011-06-23','64'),(8,8,7,'Some notes go here.','2002-09-17','83'),(9,9,8,'Some notes go here.','2004-07-15','38'),(10,10,9,'Some notes go here.','2001-07-28','10'),(11,11,10,'Some notes go here.','2010-03-14','59'),(12,12,11,'Some notes go here.','2008-04-17','61'),(13,13,12,'Some notes go here.','2009-07-01','35'),(14,14,13,'Some notes go here.','2010-12-26','92'),(15,15,14,'Some notes go here.','2005-08-18','48'),(16,16,15,'Some notes go here.','2005-03-18','10'),(17,17,16,'Some notes go here.','2008-03-15','66'),(18,18,17,'Some notes go here.','2012-08-22','92'),(19,19,18,'Some notes go here.','2004-05-13','6'),(20,20,19,'Some notes go here.','2004-05-18','95'),(21,21,20,'Some notes go here.','2002-07-04','85'),(22,22,21,'Some notes go here.','2008-07-15','15'),(23,23,22,'Some notes go here.','2005-09-18','68'),(24,24,23,'Some notes go here.','2003-05-22','26'),(25,25,24,'Some notes go here.','2012-01-14','99');
/*!40000 ALTER TABLE `performance_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `person` (
  `date_born` date NOT NULL,
  `type` enum('employee','customer') NOT NULL DEFAULT 'customer',
  `person_id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) NOT NULL,
  `date_deceased` date DEFAULT NULL,
  PRIMARY KEY (`person_id`),
  UNIQUE KEY `contact_id_UNIQUE` (`contact_id`)
) ENGINE=InnoDB AUTO_INCREMENT=658 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES ('2012-12-25','employee',1,1,NULL),('2000-04-24','employee',2,2,NULL),('2005-07-18','employee',3,3,NULL),('2012-01-13','employee',4,4,NULL),('1998-11-03','employee',5,5,NULL),('1997-07-08','employee',6,6,NULL),('2010-11-23','employee',7,7,NULL),('2009-02-26','employee',8,8,NULL),('2012-11-07','employee',9,9,NULL),('2001-08-23','employee',10,10,NULL),('2010-04-19','employee',11,11,NULL),('2000-07-27','employee',12,12,NULL),('1997-01-12','employee',13,13,NULL),('2009-06-25','employee',14,14,NULL),('2000-05-21','employee',15,15,NULL),('2000-08-27','employee',16,16,NULL),('2000-06-04','employee',17,17,NULL),('1999-02-10','employee',18,18,NULL),('2006-01-25','employee',19,19,NULL),('2011-08-05','employee',20,20,NULL),('1997-02-16','employee',21,21,NULL),('1999-08-18','employee',22,22,NULL),('2003-01-07','employee',23,23,NULL),('2005-01-03','employee',24,24,NULL),('1997-06-08','employee',25,25,NULL),('2012-12-09','employee',26,26,NULL),('2012-10-12','employee',27,27,NULL),('2005-11-24','employee',28,28,NULL),('2007-08-11','employee',29,29,NULL),('2011-05-16','employee',30,30,NULL),('2012-04-19','employee',31,31,NULL),('2004-08-27','employee',32,32,NULL),('2009-02-14','employee',33,33,NULL),('2004-04-13','employee',34,34,NULL),('2010-01-10','employee',35,35,NULL),('1998-09-04','employee',36,36,NULL),('2012-05-20','employee',37,37,NULL),('1999-06-21','employee',38,38,NULL),('2012-10-06','employee',39,39,NULL),('1995-06-26','employee',40,40,NULL),('2004-05-07','employee',41,41,NULL),('2006-06-19','employee',42,42,NULL),('2008-09-14','employee',43,43,NULL),('2011-08-18','employee',44,44,NULL),('1996-10-04','employee',45,45,NULL),('2008-08-17','employee',46,46,NULL),('2006-05-05','employee',47,47,NULL),('2012-01-16','employee',48,48,NULL),('2008-11-22','employee',49,49,NULL),('2008-04-17','employee',50,50,NULL),('2001-12-22','employee',51,51,NULL),('2012-12-14','employee',52,52,NULL),('2002-12-28','employee',53,53,NULL),('2011-06-24','employee',54,54,NULL),('2003-10-01','employee',55,55,NULL),('1998-10-01','employee',56,56,NULL),('2005-11-18','employee',57,57,NULL),('2001-12-03','employee',58,58,NULL),('1997-11-27','employee',59,59,NULL),('2005-02-14','employee',60,60,NULL),('1999-05-07','employee',61,61,NULL),('2004-01-27','employee',62,62,NULL),('1998-06-28','employee',63,63,NULL),('2004-04-18','employee',64,64,NULL),('1995-01-21','employee',65,65,NULL),('1996-01-12','employee',66,66,NULL),('2012-11-14','employee',67,67,NULL),('2011-11-25','employee',68,68,NULL),('2005-06-20','employee',69,69,NULL),('1995-04-16','employee',70,70,NULL),('2000-11-17','employee',71,71,NULL),('2010-12-10','employee',72,72,NULL),('2012-04-01','employee',73,73,NULL),('1995-11-02','employee',74,74,NULL),('2000-10-09','employee',75,75,NULL);
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `position`
--

DROP TABLE IF EXISTS `position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `position` (
  `position_id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`position_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `position`
--

LOCK TABLES `position` WRITE;
/*!40000 ALTER TABLE `position` DISABLE KEYS */;
INSERT INTO `position` VALUES (1,'chief executive officer'),(2,'supervisor'),(3,'distribution specialist'),(4,'clerk'),(5,'manager'),(6,'assistant manager'),(7,'coordinator'),(8,'sales representative'),(9,'customer service'),(10,'janitor'),(11,'executive vice president'),(12,'senior vice president'),(13,'general manager'),(14,'senior manager'),(15,'analyst'),(16,'it specialist'),(17,'director'),(18,'assistant director'),(19,'accountant'),(20,'human resources'),(21,'marketing specialist'),(22,'senior clerk'),(23,'assistant vice president'),(24,'senior coordinator'),(25,'receptionist');
/*!40000 ALTER TABLE `position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `internal_product_id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory` int(11) NOT NULL DEFAULT '0',
  `full_price` decimal(6,2) NOT NULL DEFAULT '0.00',
  `discount_percentage` varchar(45) DEFAULT NULL,
  `reorder_at` int(11) DEFAULT '0',
  PRIMARY KEY (`internal_product_id`,`inventory`)
) ENGINE=InnoDB AUTO_INCREMENT=3342 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (3267,8002,'11.00',NULL,NULL),(3268,807,'14.00',NULL,NULL),(3269,2537,'13.00',NULL,NULL),(3270,5456,'16.00',NULL,NULL),(3271,4518,'5.00',NULL,NULL),(3272,3071,'5.00',NULL,NULL),(3273,4874,'16.00',NULL,NULL),(3274,3016,'7.00',NULL,NULL),(3275,1308,'16.00',NULL,NULL),(3276,5526,'15.00',NULL,NULL),(3277,8652,'12.00',NULL,NULL),(3278,8376,'13.00',NULL,NULL),(3279,4970,'13.00',NULL,NULL),(3280,8591,'10.00',NULL,NULL),(3281,1460,'10.00',NULL,NULL),(3282,4917,'13.00',NULL,NULL),(3283,2008,'6.00',NULL,NULL),(3284,3800,'20.00',NULL,NULL),(3285,1214,'6.00',NULL,NULL),(3286,8900,'10.00',NULL,NULL),(3287,3450,'10.00',NULL,NULL),(3288,5819,'7.00',NULL,NULL),(3289,1871,'7.00',NULL,NULL),(3290,732,'6.00',NULL,NULL),(3291,1583,'17.00',NULL,NULL),(3292,3948,'19.00',NULL,NULL),(3293,8332,'17.00',NULL,NULL),(3294,8724,'10.00',NULL,NULL),(3295,4857,'5.00',NULL,NULL),(3296,1300,'11.00',NULL,NULL),(3297,432,'5.00',NULL,NULL),(3298,2223,'16.00',NULL,NULL),(3299,6865,'8.00',NULL,NULL),(3300,7607,'16.00',NULL,NULL),(3301,3219,'14.00',NULL,NULL),(3302,8590,'11.00',NULL,NULL),(3303,6711,'16.00',NULL,NULL),(3304,8855,'7.00',NULL,NULL),(3305,414,'5.00',NULL,NULL),(3306,2040,'15.00',NULL,NULL),(3307,7686,'19.00',NULL,NULL),(3308,7851,'12.00',NULL,NULL),(3309,9433,'10.00',NULL,NULL),(3310,6763,'15.00',NULL,NULL),(3311,9322,'5.00',NULL,NULL),(3312,2478,'6.00',NULL,NULL),(3313,2013,'5.00',NULL,NULL),(3314,5748,'17.00',NULL,NULL),(3315,5966,'8.00',NULL,NULL),(3316,8137,'10.00',NULL,NULL),(3317,6467,'6.00',NULL,NULL),(3318,4599,'15.00',NULL,NULL),(3319,4436,'6.00',NULL,NULL),(3320,660,'15.00',NULL,NULL),(3321,2332,'12.00',NULL,NULL),(3322,190,'19.00',NULL,NULL),(3323,6870,'11.00',NULL,NULL),(3324,1449,'11.00',NULL,NULL),(3325,9940,'13.00',NULL,NULL),(3326,1216,'5.00',NULL,NULL),(3327,6707,'13.00',NULL,NULL),(3328,6485,'16.00',NULL,NULL),(3329,8569,'7.00',NULL,NULL),(3330,5999,'16.00',NULL,NULL),(3331,2576,'13.00',NULL,NULL),(3332,7337,'19.00',NULL,NULL),(3333,228,'5.00',NULL,NULL),(3334,9922,'12.00',NULL,NULL),(3335,2624,'19.00',NULL,NULL),(3336,5658,'15.00',NULL,NULL),(3337,4124,'7.00',NULL,NULL),(3338,6612,'11.00',NULL,NULL),(3339,6541,'8.00',NULL,NULL),(3340,2256,'7.00',NULL,NULL),(3341,7696,'19.00',NULL,NULL);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publisher` (
  `publisher_id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `contact_id` varchar(45) NOT NULL,
  PRIMARY KEY (`publisher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (1,'Political Press','2143'),(2,'Diamond Press','2144'),(3,'Education Books','2145'),(4,'Daredevil Publishing Co.','2146'),(5,'World Titles','2147'),(6,'Blood Publishing Co.','2148'),(7,'Time House Books','2149'),(8,'Blood Publishers','2150'),(9,'World Publishing Co.','2151'),(10,'Bird Publishing Co.','2152'),(11,'Avenger Books','2153'),(12,'Steel House Books','2154'),(13,'Wizard Books','2155'),(14,'Earth Publishing Co.','2156'),(15,'Tropical Publishing Co.','2157'),(16,'Play Titles','2158'),(17,'Lion Publishing Co.','2159'),(18,'Sword Publishing Co.','2160'),(19,'Healing Books','2161'),(20,'Tropical House Books','2162'),(21,'Lion Publishing Co.','2163'),(22,'Foul Books','2164'),(23,'Sex House Books','2165'),(24,'Games Publishers','2166'),(25,'Circle Press','2167');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `store` (
  `store_number` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  `max_capacity` int(11) NOT NULL,
  `mgr_employee_id` int(11) NOT NULL,
  PRIMARY KEY (`store_number`),
  UNIQUE KEY `address_id_UNIQUE` (`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (1,1,140,1),(2,2,396,2),(3,3,365,3),(4,4,487,4),(5,5,465,5),(6,6,379,6),(7,7,430,7),(8,8,342,8),(9,9,379,9),(10,10,292,10),(11,11,94,11),(12,12,131,12),(13,13,432,13),(14,14,215,14),(15,15,385,15),(16,16,406,16),(17,17,315,17),(18,18,169,18),(19,19,160,19),(20,20,91,20),(21,21,442,21),(22,22,262,22),(23,23,468,23),(24,24,297,24),(25,25,111,25);
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_dept`
--

DROP TABLE IF EXISTS `store_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `store_dept` (
  `dept_number` int(11) NOT NULL,
  `store_number` int(11) NOT NULL,
  `mgr_employee_id` int(11) NOT NULL,
  `office_number` varchar(10) DEFAULT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`dept_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_dept`
--

LOCK TABLES `store_dept` WRITE;
/*!40000 ALTER TABLE `store_dept` DISABLE KEYS */;
INSERT INTO `store_dept` VALUES (1,1,1,'100','Accounting'),(2,2,2,'101','Purchasing'),(3,3,3,'102','Information Technology'),(4,4,4,'100','Purchasing'),(5,5,5,'103','Accounting'),(6,6,6,'104','Purchasing'),(7,7,7,'100','Marketing'),(8,8,8,'101','Purchasing'),(9,9,9,'107','Accounting'),(10,10,10,'105','Accounting'),(11,11,11,'102','Management'),(12,12,12,'101','Accounting'),(13,13,13,'112','Purchasing'),(14,14,14,'105','Management'),(15,15,15,'112','Purchasing'),(16,16,16,'101','Management'),(17,17,17,'107','New Business'),(18,18,18,'111','Management'),(19,19,19,'117','Accounting'),(20,20,20,'118','Marketing'),(21,21,21,'102','Information Technology'),(22,22,22,'115','Management'),(23,23,23,'100','Management'),(24,24,24,'113','Information Technology'),(25,25,25,'121','Accounting');
/*!40000 ALTER TABLE `store_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store_product`
--

DROP TABLE IF EXISTS `store_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `store_product` (
  `store_id` int(11) NOT NULL,
  `internal_product_id` varchar(45) NOT NULL,
  `inventory` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`store_id`,`internal_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store_product`
--

LOCK TABLES `store_product` WRITE;
/*!40000 ALTER TABLE `store_product` DISABLE KEYS */;
INSERT INTO `store_product` VALUES (1,'1',636),(2,'2',8776),(3,'3',1981),(4,'4',6839),(5,'5',548),(6,'6',6033),(7,'7',6135),(8,'8',1270),(9,'9',9896),(10,'10',3678),(11,'11',7807),(12,'12',9010),(13,'13',7138),(14,'14',9166),(15,'15',9545),(16,'16',8063),(17,'17',241),(18,'18',5238),(19,'19',5959),(20,'20',1375),(21,'21',6045),(22,'22',6877),(23,'23',6577),(24,'24',9841),(25,'25',5046);
/*!40000 ALTER TABLE `store_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier` (
  `supplier_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'Play Ltd.',2168),(2,'Programming Enterprises',2169),(3,'Dances Co.',2170),(4,'Charming Holdings',2171),(5,'Foul Inc.',2172),(6,'Play Co.',2173),(7,'Underworld Enterprises',2174),(8,'Sword Industries',2175),(9,'Play Holdings',2176),(10,'Healing Industries',2177),(11,'Knife Co.',2178),(12,'Healing Corporation',2179),(13,'Lost Enterprises',2180),(14,'Turtle Ltd.',2181),(15,'Turtle Co.',2182),(16,'Fire Inc.',2183),(17,'Jewelry Co.',2184),(18,'Circle Corporation',2185),(19,'Time Co.',2186),(20,'Love Ltd.',2187),(21,'Foul Corporation',2188),(22,'Avenger Holdings',2189),(23,'Steel Holdings',2190),(24,'Knife Co.',2191),(25,'Education Inc.',2192);
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction` (
  `transaction_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(45) NOT NULL,
  `customer_id` varchar(45) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `internal_product_id` varchar(45) NOT NULL,
  `amount` decimal(6,2) NOT NULL,
  `method_of_payment` enum('cash','debit','credit') NOT NULL,
  `store_number` int(11) NOT NULL,
  `type` enum('purchase','return') NOT NULL DEFAULT 'purchase',
  PRIMARY KEY (`transaction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
INSERT INTO `transaction` VALUES (1,'1','1','2012-04-20 09:00:39','3267','11.00','credit',1,'return'),(2,'2','2','2012-04-20 09:00:39','3268','14.00','cash',2,'purchase'),(3,'3','3','2012-04-20 09:00:39','3269','13.00','credit',3,'purchase'),(4,'4','4','2012-04-20 09:00:39','3270','16.00','cash',4,'return'),(5,'5','5','2012-04-20 09:00:39','3271','5.00','debit',5,'purchase'),(6,'6','6','2012-04-20 09:00:39','3272','5.00','credit',6,'return'),(7,'7','7','2012-04-20 09:00:39','3273','16.00','cash',7,'purchase'),(8,'8','8','2012-04-20 09:00:39','3274','7.00','debit',8,'return'),(9,'9','9','2012-04-20 09:00:39','3275','16.00','credit',9,'return'),(10,'10','10','2012-04-20 09:00:39','3276','15.00','cash',10,'purchase'),(11,'11','11','2012-04-20 09:00:39','3277','12.00','cash',11,'purchase'),(12,'12','12','2012-04-20 09:00:39','3278','13.00','credit',12,'return'),(13,'13','13','2012-04-20 09:00:39','3279','13.00','cash',13,'purchase'),(14,'14','14','2012-04-20 09:00:39','3280','10.00','credit',14,'purchase'),(15,'15','15','2012-04-20 09:00:39','3281','10.00','cash',15,'return'),(16,'16','16','2012-04-20 09:00:39','3282','13.00','debit',16,'return'),(17,'17','17','2012-04-20 09:00:39','3283','6.00','cash',17,'purchase'),(18,'18','18','2012-04-20 09:00:39','3284','20.00','cash',18,'return'),(19,'19','19','2012-04-20 09:00:39','3285','6.00','cash',19,'return'),(20,'20','20','2012-04-20 09:00:39','3286','10.00','cash',20,'purchase'),(21,'21','21','2012-04-20 09:00:39','3287','10.00','cash',21,'purchase'),(22,'22','22','2012-04-20 09:00:39','3288','7.00','credit',22,'return'),(23,'23','23','2012-04-20 09:00:39','3289','7.00','credit',23,'purchase'),(24,'24','24','2012-04-20 09:00:39','3290','6.00','credit',24,'return'),(25,'25','25','2012-04-20 09:00:39','3291','17.00','credit',25,'purchase'),(26,'1','1','2012-04-20 09:00:39','3292','19.00','credit',1,'purchase'),(27,'2','2','2012-04-20 09:00:39','3293','17.00','cash',2,'purchase'),(28,'3','3','2012-04-20 09:00:39','3294','10.00','cash',3,'return'),(29,'4','4','2012-04-20 09:00:39','3295','5.00','credit',4,'purchase'),(30,'5','5','2012-04-20 09:00:39','3296','11.00','credit',5,'return'),(31,'6','6','2012-04-20 09:00:39','3297','5.00','debit',6,'return'),(32,'7','7','2012-04-20 09:00:39','3298','16.00','debit',7,'purchase'),(33,'8','8','2012-04-20 09:00:39','3299','8.00','cash',8,'return'),(34,'9','9','2012-04-20 09:00:39','3300','16.00','cash',9,'purchase'),(35,'10','10','2012-04-20 09:00:39','3301','14.00','debit',10,'purchase'),(36,'11','11','2012-04-20 09:00:39','3302','11.00','debit',11,'return'),(37,'12','12','2012-04-20 09:00:39','3303','16.00','debit',12,'purchase'),(38,'13','13','2012-04-20 09:00:39','3304','7.00','credit',13,'return'),(39,'14','14','2012-04-20 09:00:39','3305','5.00','cash',14,'purchase'),(40,'15','15','2012-04-20 09:00:39','3306','15.00','debit',15,'return'),(41,'16','16','2012-04-20 09:00:39','3307','19.00','credit',16,'return'),(42,'17','17','2012-04-20 09:00:39','3308','12.00','debit',17,'return'),(43,'18','18','2012-04-20 09:00:39','3309','10.00','credit',18,'purchase'),(44,'19','19','2012-04-20 09:00:39','3310','15.00','credit',19,'purchase'),(45,'20','20','2012-04-20 09:00:39','3311','5.00','cash',20,'return'),(46,'21','21','2012-04-20 09:00:39','3312','6.00','credit',21,'purchase'),(47,'22','22','2012-04-20 09:00:39','3313','5.00','cash',22,'return'),(48,'23','23','2012-04-20 09:00:39','3314','17.00','debit',23,'purchase'),(49,'24','24','2012-04-20 09:00:39','3315','8.00','cash',24,'return'),(50,'25','25','2012-04-20 09:00:39','3316','10.00','debit',25,'purchase'),(51,'1','1','2012-04-20 09:00:39','3317','6.00','cash',1,'return'),(52,'2','2','2012-04-20 09:00:39','3318','15.00','credit',2,'return'),(53,'3','3','2012-04-20 09:00:39','3319','6.00','debit',3,'purchase'),(54,'4','4','2012-04-20 09:00:39','3320','15.00','credit',4,'return'),(55,'5','5','2012-04-20 09:00:39','3321','12.00','credit',5,'purchase'),(56,'6','6','2012-04-20 09:00:39','3322','19.00','debit',6,'return'),(57,'7','7','2012-04-20 09:00:39','3323','11.00','cash',7,'purchase'),(58,'8','8','2012-04-20 09:00:39','3324','11.00','credit',8,'purchase'),(59,'9','9','2012-04-20 09:00:39','3325','13.00','debit',9,'return'),(60,'10','10','2012-04-20 09:00:39','3326','5.00','cash',10,'return'),(61,'11','11','2012-04-20 09:00:39','3327','13.00','cash',11,'purchase'),(62,'12','12','2012-04-20 09:00:39','3328','16.00','debit',12,'return'),(63,'13','13','2012-04-20 09:00:39','3329','7.00','debit',13,'return'),(64,'14','14','2012-04-20 09:00:39','3330','16.00','credit',14,'return'),(65,'15','15','2012-04-20 09:00:39','3331','13.00','cash',15,'purchase'),(66,'16','16','2012-04-20 09:00:39','3332','19.00','debit',16,'return'),(67,'17','17','2012-04-20 09:00:39','3333','5.00','credit',17,'purchase'),(68,'18','18','2012-04-20 09:00:39','3334','12.00','debit',18,'return'),(69,'19','19','2012-04-20 09:00:39','3335','19.00','debit',19,'purchase'),(70,'20','20','2012-04-20 09:00:39','3336','15.00','cash',20,'return'),(71,'21','21','2012-04-20 09:00:39','3337','7.00','credit',21,'purchase'),(72,'22','22','2012-04-20 09:00:39','3338','11.00','credit',22,'purchase'),(73,'23','23','2012-04-20 09:00:39','3339','8.00','credit',23,'purchase'),(74,'24','24','2012-04-20 09:00:39','3340','7.00','debit',24,'purchase'),(75,'25','25','2012-04-20 09:00:39','3341','19.00','credit',25,'return');
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-04-20  5:09:48
