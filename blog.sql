CREATE DATABASE  IF NOT EXISTS `blog` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `blog`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: blog
-- ------------------------------------------------------
-- Server version	8.0.37

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
-- Table structure for table `article_stat_daily`
--

DROP TABLE IF EXISTS `article_stat_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_stat_daily` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `article_id` bigint DEFAULT NULL,
  `date` date DEFAULT NULL,
  `likes_inc` int DEFAULT '0',
  `views_inc` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_article_date` (`article_id`,`date`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_stat_daily`
--

LOCK TABLES `article_stat_daily` WRITE;
/*!40000 ALTER TABLE `article_stat_daily` DISABLE KEYS */;
INSERT INTO `article_stat_daily` VALUES (1,292,'2026-03-19',50,500),(2,292,'2026-03-17',70,700),(3,292,'2026-03-09',280,2800),(4,296,'2026-03-19',30,1000),(5,296,'2026-03-17',60,2000),(6,296,'2026-03-09',260,3000),(7,297,'2026-03-19',80,100),(8,297,'2026-03-17',120,200),(9,297,'2026-03-09',300,300),(10,292,'2026-04-24',0,0),(16,292,'2026-05-13',0,1),(17,300,'2026-05-14',0,2);
/*!40000 ALTER TABLE `article_stat_daily` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_detail`
--

DROP TABLE IF EXISTS `file_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_detail` (
  `id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '文件id',
  `url` varchar(512) NOT NULL COMMENT '文件访问地址',
  `size` bigint DEFAULT NULL COMMENT '文件大小，单位字节',
  `filename` varchar(256) DEFAULT NULL COMMENT '文件名称',
  `original_filename` varchar(256) DEFAULT NULL COMMENT '原始文件名',
  `base_path` varchar(256) DEFAULT NULL COMMENT '基础存储路径',
  `path` varchar(256) DEFAULT NULL COMMENT '存储路径',
  `ext` varchar(32) DEFAULT NULL COMMENT '文件扩展名',
  `content_type` varchar(128) DEFAULT NULL COMMENT 'MIME类型',
  `platform` varchar(32) DEFAULT NULL COMMENT '存储平台',
  `th_url` varchar(512) DEFAULT NULL COMMENT '缩略图访问路径',
  `th_filename` varchar(256) DEFAULT NULL COMMENT '缩略图名称',
  `th_size` bigint DEFAULT NULL COMMENT '缩略图大小，单位字节',
  `th_content_type` varchar(128) DEFAULT NULL COMMENT '缩略图MIME类型',
  `object_id` varchar(32) DEFAULT NULL COMMENT '文件所属对象id',
  `object_type` varchar(32) DEFAULT NULL COMMENT '文件所属对象类型，例如用户头像，评价图片',
  `metadata` text COMMENT '文件元数据',
  `user_metadata` text COMMENT '文件用户元数据',
  `th_metadata` text COMMENT '缩略图元数据',
  `th_user_metadata` text COMMENT '缩略图用户元数据',
  `attr` text COMMENT '附加属性',
  `file_acl` varchar(32) DEFAULT NULL COMMENT '文件ACL',
  `th_file_acl` varchar(32) DEFAULT NULL COMMENT '缩略图文件ACL',
  `hash_info` text COMMENT '哈希信息',
  `upload_id` varchar(128) DEFAULT NULL COMMENT '上传ID，仅在手动分片上传时使用',
  `upload_status` int DEFAULT NULL COMMENT '上传状态，仅在手动分片上传时使用，1：初始化完成，2：上传完成',
  `source` varchar(25) DEFAULT NULL COMMENT '图片来源',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='文件记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_detail`
--

LOCK TABLES `file_detail` WRITE;
/*!40000 ALTER TABLE `file_detail` DISABLE KEYS */;
INSERT INTO `file_detail` VALUES ('158634af3c41912cdc2afa209b62238e','http://127.0.0.1:8800/localFile/local-plus/20260425/avatar/67_avatar.jpg',89068,'67_avatar.jpg','avatar.jpg','local-plus/','20260425/avatar/','jpg','image/jpg','local',NULL,NULL,NULL,NULL,NULL,NULL,'{}','{}','{}','{}','{\"source\":\"avatar\"}',NULL,NULL,'{}',NULL,NULL,'avatar','2026-04-25 10:53:15'),('1ca25ee2f380020afadeb5ca72f2c982','http://127.0.0.1:8800/localFile/local-plus/20260511/article-cover/40_ScreenShot_2026-04-25_105414_373.png',17508,'40_ScreenShot_2026-04-25_105414_373.png','ScreenShot_2026-04-25_105414_373.png','local-plus/','20260511/article-cover/','png','image/png','local',NULL,NULL,NULL,NULL,NULL,NULL,'{}','{}','{}','{}','{\"source\":\"article-cover\"}',NULL,NULL,'{}',NULL,NULL,'article-cover','2026-05-11 18:57:36'),('413df52fae964842468b517a29a2e63e','http://127.0.0.1:8800/localFile/local-plus/20260511/article-cover/05_ScreenShot_2026-04-25_105414_373.png',17508,'05_ScreenShot_2026-04-25_105414_373.png','ScreenShot_2026-04-25_105414_373.png','local-plus/','20260511/article-cover/','png','image/png','local',NULL,NULL,NULL,NULL,NULL,NULL,'{}','{}','{}','{}','{\"source\":\"article-cover\"}',NULL,NULL,'{}',NULL,NULL,'article-cover','2026-05-11 19:30:08'),('a0ac11abca78faa0cc423f78d290ff7a','http://127.0.0.1:8800/localFile/local-plus/20260425/avatar/83_avatar.jpg',38315,'83_avatar.jpg','avatar.jpg','local-plus/','20260425/avatar/','jpg','image/jpg','local',NULL,NULL,NULL,NULL,NULL,NULL,'{}','{}','{}','{}','{\"source\":\"avatar\"}',NULL,NULL,'{}',NULL,NULL,'avatar','2026-04-25 10:54:30'),('ba7f8ca7a1bb0ed179919241ebede4fe','http://127.0.0.1:8800/localFile/local-plus/20260512/moment/94_v2-2068949461853f29e6c9becba3cbe4f7_1440w.jpg',29469,'94_v2-2068949461853f29e6c9becba3cbe4f7_1440w.jpg','v2-2068949461853f29e6c9becba3cbe4f7_1440w.jpg','local-plus/','20260512/moment/','jpg','image/jpeg','local',NULL,NULL,NULL,NULL,NULL,NULL,'{}','{}','{}','{}','{\"source\":\"moment\"}',NULL,NULL,'{}',NULL,NULL,'moment','2026-05-12 22:01:28'),('e6b83c9d2dfbdad45053002cd8946646','http://127.0.0.1:8800/localFile/local-plus/20260511/article-cover/32_v2-2068949461853f29e6c9becba3cbe4f7_1440w.jpg',29469,'32_v2-2068949461853f29e6c9becba3cbe4f7_1440w.jpg','v2-2068949461853f29e6c9becba3cbe4f7_1440w.jpg','local-plus/','20260511/article-cover/','jpg','image/jpeg','local',NULL,NULL,NULL,NULL,NULL,NULL,'{}','{}','{}','{}','{\"source\":\"article-cover\"}',NULL,NULL,'{}',NULL,NULL,'article-cover','2026-05-11 18:51:49');
/*!40000 ALTER TABLE `file_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_part_detail`
--

DROP TABLE IF EXISTS `file_part_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_part_detail` (
  `id` varchar(32) NOT NULL COMMENT '分片id',
  `platform` varchar(32) DEFAULT NULL COMMENT '存储平台',
  `upload_id` varchar(128) DEFAULT NULL COMMENT '上传ID，仅在手动分片上传时使用',
  `e_tag` varchar(255) DEFAULT NULL COMMENT '分片 ETag',
  `part_number` int DEFAULT NULL COMMENT '分片号。每一个上传的分片都有一个分片号，一般情况下取值范围是1~10000',
  `part_size` bigint DEFAULT NULL COMMENT '文件大小，单位字节',
  `hash_info` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '哈希信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='文件分片信息表，仅在手动分片上传时使用';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_part_detail`
--

LOCK TABLES `file_part_detail` WRITE;
/*!40000 ALTER TABLE `file_part_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_part_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
INSERT INTO `gen_table` VALUES (16,'sys_tag','标签表','2024-12-22 10:38:49',NULL),(17,'sys_web_config','网站配置表','2024-12-22 11:55:59',NULL),(18,'sys_article','文章标签关联表','2024-12-22 12:20:29','2024-12-25 14:32:51'),(19,'sys_category','分类表','2024-12-22 13:22:38',NULL),(20,'sys_friend','友情链接','2024-12-22 13:57:02',NULL);
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NOT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=263 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
INSERT INTO `gen_table_column` VALUES (178,16,'id','主键','int','Integer','id','1','1','1','1','1','1','EQ','input',1),(179,16,'name','名称','varchar','String','name','0','0','1','1','1','1','EQ','input',2),(180,16,'sort','排序','int','Integer','sort','0','0','1','1','1','1','EQ','input',3),(181,16,'create_time','创建时间','datetime','Date','createTime','0','0','1','1','1','1','EQ','input',4),(182,16,'update_time','更新时间','datetime','Date','updateTime','0','0','1','1','1','1','EQ','input',5),(183,17,'id','主键','bigint','Long','id','1','1','1','1','1','1','EQ','input',1),(184,17,'logo','logo(文件UID)','varchar','String','logo','0','0','1','1','1','1','EQ','input',2),(185,17,'name','网站名称','varchar','String','name','0','0','1','1','1','1','EQ','input',3),(186,17,'summary','介绍','varchar','String','summary','0','0','1','1','1','1','EQ','input',4),(187,17,'record_num','备案号','varchar','String','recordNum','0','0','1','1','1','1','EQ','input',5),(188,17,'web_url','网站地址','varchar','String','webUrl','0','0','1','1','1','1','EQ','input',6),(189,17,'author','作者','varchar','String','author','0','0','1','1','1','1','EQ','input',7),(190,17,'author_info','个性签名','varchar','String','authorInfo','0','0','1','1','1','1','EQ','input',8),(191,17,'author_avatar','作者头像','varchar','String','authorAvatar','0','0','1','1','1','1','EQ','input',9),(192,17,'ali_pay','支付宝收款码','varchar','String','aliPay','0','0','1','1','1','1','EQ','input',10),(193,17,'weixin_pay','微信收款码','varchar','String','weixinPay','0','0','1','1','1','1','EQ','input',11),(194,17,'github','github地址','varchar','String','github','0','0','1','1','1','1','EQ','input',12),(195,17,'gitee','gitee地址','varchar','String','gitee','0','0','1','1','1','1','EQ','input',13),(196,17,'qq_number','QQ号','varchar','String','qqNumber','0','0','1','1','1','1','EQ','input',14),(197,17,'qq_group','QQ群','varchar','String','qqGroup','0','0','1','1','1','1','EQ','input',15),(198,17,'email','邮箱','varchar','String','email','0','0','1','1','1','1','EQ','input',16),(199,17,'wechat','微信','varchar','String','wechat','0','0','1','1','1','1','EQ','input',17),(200,17,'show_list','显示的列表（用于控制邮箱、QQ、QQ群、Github、Gitee、微信是否显示在前端）','varchar','String','showList','0','0','1','1','1','1','EQ','input',18),(201,17,'login_type_list','登录方式列表（用于控制前端登录方式，如账号密码,码云,Github,QQ,微信）','varchar','String','loginTypeList','0','0','1','1','1','1','EQ','input',19),(202,17,'open_comment','是否开启评论(0:否 1:是)','tinyint','Integer','openComment','0','0','1','1','1','1','EQ','input',20),(203,17,'open_admiration','是否开启赞赏(0:否， 1:是)','tinyint','Integer','openAdmiration','0','0','1','1','1','1','EQ','input',21),(204,17,'tourist_avatar','游客头像','varchar','String','touristAvatar','0','0','1','1','1','1','EQ','input',22),(205,17,'bulletin','公告','varchar','String','bulletin','0','0','1','1','1','1','EQ','input',23),(206,17,'about_me','关于我','mediumtext','String','aboutMe','0','0','1','1','1','1','EQ','input',24),(207,17,'create_time','创建时间','datetime','Date','createTime','0','0','1','1','1','1','EQ','input',25),(208,17,'update_time','更新时间','datetime','Date','updateTime','0','0','1','1','1','1','EQ','input',26),(209,18,'id','主键id','bigint','Long','id',NULL,'1','1','1','1','1','EQ','input',1),(210,18,'user_id','用户id','int','Integer','userId',NULL,'1','1','1','1','1','EQ','input',2),(211,18,'category_id','分类id','bigint','Long','categoryId',NULL,'0','1','1','1','1','EQ','input',3),(212,18,'title','文章标题','varchar','String','title',NULL,'1','1','1','1','1','EQ','input',4),(213,18,'cover','文章封面地址','varchar','String','cover',NULL,'0','1','1','1','1','EQ','input',5),(214,18,'summary','文章简介','varchar','String','summary',NULL,'1','1','1','1','1','EQ','input',6),(215,18,'content','文章内容','mediumtext','String','content',NULL,'0','1','1','1','1','EQ','input',7),(216,18,'content_md','文章内容md格式','mediumtext','String','contentMd',NULL,'0','1','1','1','1','EQ','input',8),(217,18,'read_type','阅读方式 0无需验证 1：评论阅读 2：点赞阅读 3：扫码阅读','int','Integer','readType',NULL,'0','1','1','1','1','EQ','input',9),(218,18,'is_stick','是否置顶 0否 1是','int','Integer','isStick',NULL,'0','1','1','1','1','EQ','input',10),(219,18,'is_publish','是否发布 0：下架 1：发布','int','Integer','isPublish',NULL,'0','1','1','1','1','EQ','input',11),(220,18,'is_original','是否原创  0：转载 1:原创','int','Integer','isOriginal',NULL,'0','1','1','1','1','EQ','input',12),(221,18,'is_carousel','是否首页轮播','int','Integer','isCarousel',NULL,'0','1','1','1','1','EQ','input',13),(222,18,'is_recommend','是否推荐','int','Integer','isRecommend',NULL,'0','1','1','1','1','EQ','input',14),(223,18,'original_url','转载地址','varchar','String','originalUrl',NULL,'0','1','1','1','1','EQ','input',15),(224,18,'quantity','文章阅读量','bigint','Long','quantity',NULL,'0','1','1','1','1','EQ','input',16),(225,18,'keywords','关键词','varchar','String','keywords',NULL,'0','1','1','1','1','EQ','input',17),(226,18,'create_time','创建时间','datetime','Date','createTime',NULL,'0','1','1','1','1','EQ','input',18),(227,18,'update_time','修改时间','datetime','Date','updateTime',NULL,'0','1','1','1','1','EQ','input',19),(228,19,'id','主键','int','Integer','id','1','1','1','1','1','1','EQ','input',1),(229,19,'name','名称','varchar','String','name','0','0','1','1','1','1','EQ','input',2),(230,19,'sort','排序','int','Integer','sort','0','0','1','1','1','1','EQ','input',3),(231,19,'create_time','创建时间','datetime','Date','createTime','0','0','1','1','1','1','EQ','input',4),(232,19,'update_time','更新时间','datetime','Date','updateTime','0','0','1','1','1','1','EQ','input',5),(233,20,'id','主键ID','int','Integer','id','1','1','1','1','1','1','EQ','input',1),(234,20,'name','网站名称','varchar','String','name','0','0','1','1','1','1','EQ','input',2),(235,20,'url','网站地址','varchar','String','url','0','0','1','1','1','1','EQ','input',3),(236,20,'avatar','网站头像地址','varchar','String','avatar','0','0','1','1','1','1','EQ','input',4),(237,20,'info','网站描述','varchar','String','info','0','0','1','1','1','1','EQ','input',5),(238,20,'email','邮箱','varchar','String','email','0','0','1','1','1','1','EQ','input',6),(239,20,'sort','排序','int','Integer','sort','0','0','1','1','1','1','EQ','input',7),(240,20,'reason','下架原因','varchar','String','reason','0','0','1','1','1','1','EQ','input',8),(241,20,'status','ENUM-状态:\"0,下架;1,申请;2:上架\"','int','Integer','status','0','0','1','1','1','1','EQ','input',9),(242,20,'create_time','创建时间','datetime','Date','createTime','0','0','1','1','1','1','EQ','input',10),(243,20,'update_time','修改时间','datetime','Date','updateTime','0','0','1','1','1','1','EQ','input',11);
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_album`
--

DROP TABLE IF EXISTS `sys_album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_album` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) DEFAULT NULL COMMENT '相册名',
  `description` varchar(64) DEFAULT NULL COMMENT '相册描述',
  `cover` varchar(255) DEFAULT NULL COMMENT '封面URL',
  `is_lock` int DEFAULT '0' COMMENT '是否加密 0：否 1：是',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='相册';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_album`
--

LOCK TABLES `sys_album` WRITE;
/*!40000 ALTER TABLE `sys_album` DISABLE KEYS */;
INSERT INTO `sys_album` VALUES (6,'测试相册','本地图库测试','http://127.0.0.1:8800/localFile/test-image-1.jpg',0,NULL,NULL,'2026-04-11 18:38:18'),(7,'测试相册','本地图库测试','http://127.0.0.1:8800/localFile/test-image-1.jpg',0,NULL,NULL,'2026-03-01 20:49:08');
/*!40000 ALTER TABLE `sys_album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_article`
--

DROP TABLE IF EXISTS `sys_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_article` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` int NOT NULL COMMENT '用户id',
  `category_id` bigint DEFAULT NULL COMMENT '分类id',
  `title` varchar(150) NOT NULL DEFAULT '' COMMENT '文章标题',
  `cover` varchar(200) DEFAULT NULL COMMENT '文章封面地址',
  `summary` varchar(255) NOT NULL DEFAULT '' COMMENT '文章简介',
  `content` mediumtext COMMENT '文章内容',
  `content_md` mediumtext COMMENT '文章内容md格式',
  `read_type` int DEFAULT '0' COMMENT '阅读方式 0无需验证 1：评论阅读 2：点赞阅读 3：扫码阅读',
  `status` varchar(20) DEFAULT 'review' COMMENT '状态 review：审核 publish：上架 offline：下架 draft：草稿',
  `is_carousel` int DEFAULT '0' COMMENT '是否首页轮播',
  `is_recommend` int DEFAULT '0' COMMENT '是否推荐',
  `quantity` bigint DEFAULT '0' COMMENT '文章阅读量',
  `keywords` varchar(200) DEFAULT NULL COMMENT '关键词',
  `ai_describe` mediumtext COMMENT 'Ai生成的简短描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `heat_score` double DEFAULT '0',
  `first_accessed_time` datetime DEFAULT NULL,
  `last_accessed_time` datetime DEFAULT NULL,
  `favorite_num` int DEFAULT '0' COMMENT '收藏数量',
  `is_archived` tinyint(1) DEFAULT '0' COMMENT '是否归档 0:否 1:是',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `idx_heat_score` (`heat_score`),
  FULLTEXT KEY `title` (`title`) /*!50100 WITH PARSER `ngram` */ 
) ENGINE=InnoDB AUTO_INCREMENT=309 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='博客文章表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_article`
--

LOCK TABLES `sys_article` WRITE;
/*!40000 ALTER TABLE `sys_article` DISABLE KEYS */;
INSERT INTO `sys_article` VALUES (292,1,20,'个人开发的管理系统  Neat-Admin','','基于vue3+typescript+elmentui-plus开发的一款后台管理系统，功能跟若依差不多，主要不同的是样式美化，要比若依更漂亮','<h4><a id=\"_0\"></a>前言</h4>\r\n<p>本后台管理系统基于当下前沿的技术栈 vue3、typescript 以及 elementui-plus 进行精心构建。在功能维度上，其与若依系统具备相当的完整性与丰富度，涵盖了诸如用户管理、权限控制、数据统计分析、业务流程处理等一系列核心后台管理功能模块，能够高效地支撑各类企业级业务运营需求。然而，本系统在视觉呈现方面展现出独特的优势，通过对样式的深度美化与精心雕琢，采用了更为先进的 UI 设计理念与精细化的布局策略，运用精致的色彩搭配、优雅的字体选择以及灵动的交互元素设计，使其整体视觉效果相较于若依更为美观、精致且专业，能够为用户带来更舒适、高效且具品质感的操作体验，极大地提升了后台管理工作的愉悦度与便捷性，彰显出卓越的专业性与高端品质形象。</p>\r\n<h4><a id=\"_4\"></a>视频预览</h4>\r\n<p><video height=\"100%\" width=\"100%\" src=\"http://127.0.0.1:8800/localFile/local-plus/upload/20241120_230652.mp4\" controls autoplay></video></p>\r\n<h4><a id=\"_8\"></a>仓库地址</h4>\r\n<p><a href=\"https://gitee.com/quequnlong/vue-neat-admin\" target=\"_blank\">Neat-Admin</a></p>\r\n','#### 前言\r\n\r\n  本后台管理系统基于当下前沿的技术栈 vue3、typescript 以及 elementui-plus 进行精心构建。在功能维度上，其与若依系统具备相当的完整性与丰富度，涵盖了诸如用户管理、权限控制、数据统计分析、业务流程处理等一系列核心后台管理功能模块，能够高效地支撑各类企业级业务运营需求。然而，本系统在视觉呈现方面展现出独特的优势，通过对样式的深度美化与精心雕琢，采用了更为先进的 UI 设计理念与精细化的布局策略，运用精致的色彩搭配、优雅的字体选择以及灵动的交互元素设计，使其整体视觉效果相较于若依更为美观、精致且专业，能够为用户带来更舒适、高效且具品质感的操作体验，极大地提升了后台管理工作的愉悦度与便捷性，彰显出卓越的专业性与高端品质形象。\r\n  \r\n  #### 视频预览\r\n    <video height=100% width=100% src=\"http://127.0.0.1:8800/localFile/local-plus/upload/20241120_230652.mp4\" controls autoplay></video>\r\n  \r\n  \r\n  #### 仓库地址\r\n  [Neat-Admin](https://gitee.com/quequnlong/vue-neat-admin)',1,'publish',1,0,896,NULL,NULL,'2026-03-02 04:02:57','2026-03-02 19:22:19',26.3,'2026-03-27 13:38:20','2026-05-13 21:47:45',39,0),(296,1,17,'深入理解 Java 内存模型 (JMM)','','Java内存模型(Java Memory Model)是Java虚拟机规范中定义的一种内存模型，用于屏蔽掉各种硬件和操作系统的内存访问差异...','# Java 内存模型\n\nJava内存模型(Java Memory Model)是Java虚拟机规范中定义的一种内存模型...','# Java 内存模型\n\nJava内存模型(Java Memory Model)是Java虚拟机规范中定义的一种内存模型...',0,'publish',1,0,330,NULL,NULL,'2026-03-09 05:22:30','2026-03-09 23:35:03',99999,'2026-03-19 17:44:25','2026-03-19 18:12:58',12,0),(297,1,17,'Spring Boot 自动配置原理详解','','Spring Boot的自动配置机制是其核心特性之一，本文将带你深入源码，剖析@EnableAutoConfiguration的工作原理...','# Spring Boot 自动配置\n\nSpring Boot的自动配置机制是其核心特性之一...','# Spring Boot 自动配置\n\nSpring Boot的自动配置机制是其核心特性之一...',0,'publish',1,0,852,NULL,NULL,'2026-03-24 17:41:00','2026-03-25 09:45:03',0,NULL,NULL,58,0),(298,1,17,'Java 8 Stream API 实战指南','','Java 8引入的Stream API极大地简化了集合操作，本文通过大量示例讲解Stream的常用方法...','# Java 8 Stream API\n\nJava 8引入的Stream API极大地简化了集合操作...','# Java 8 Stream API\n\nJava 8引入的Stream API极大地简化了集合操作...',0,'publish',0,0,269,NULL,NULL,'2026-03-11 23:36:35','2026-03-12 21:00:49',0,NULL,NULL,13,0),(299,1,31,'Vue 3.0 组合式 API (Composition API) 上手教程','','Vue 3.0带来的组合式API解决了Vue 2.x中逻辑复用困难的问题，本文带你快速上手...','# Vue 3.0 Composition API\n\nVue 3.0带来的组合式API解决了Vue 2.x中逻辑复用困难的问题...','# Vue 3.0 Composition API\n\nVue 3.0带来的组合式API解决了Vue 2.x中逻辑复用困难的问题...',0,'publish',0,0,107,NULL,NULL,'2026-04-26 01:26:14','2026-04-26 23:30:23',0,'2026-05-13 17:53:53','2026-05-13 20:05:15',5,0),(300,1,31,'Vue Router 4.x 路由守卫详解','','在Vue项目开发中，路由守卫是控制页面访问权限的重要手段，本文详细介绍Vue Router 4.x的各种守卫...','# Vue Router 4.x 路由守卫\n\n在Vue项目开发中，路由守卫是控制页面访问权限的重要手段...','# Vue Router 4.x 路由守卫\n\n在Vue项目开发中，路由守卫是控制页面访问权限的重要手段...',0,'publish',0,0,2576,NULL,NULL,'2026-04-21 06:49:25','2026-04-21 17:30:10',0,'2026-05-11 18:15:28','2026-05-14 22:18:29',59,0),(301,1,28,'MySQL 索引失效的十大场景','','索引是提升MySQL查询性能的关键，但很多时候我们建立的索引并没有生效，本文总结了索引失效的常见场景...','# MySQL 索引失效\n\n索引是提升MySQL查询性能的关键...','# MySQL 索引失效\n\n索引是提升MySQL查询性能的关键...',0,'publish',0,0,562,NULL,NULL,'2026-04-12 20:43:14','2026-04-13 01:00:14',0,NULL,NULL,16,0),(302,1,28,'MySQL 事务隔离级别与锁机制','','深入理解MySQL的事务隔离级别（Read Uncommitted, Read Committed, Repeatable Read, Serializable）以及锁机制...','# MySQL 事务与锁\n\n深入理解MySQL的事务隔离级别...','# MySQL 事务与锁\n\n深入理解MySQL的事务隔离级别...',0,'publish',0,0,894,NULL,NULL,'2026-04-17 20:16:45','2026-04-18 05:33:00',0,'2026-05-11 20:18:25','2026-05-11 20:26:57',28,0),(303,1,28,'Redis 持久化机制 RDB 与 AOF 对比','','Redis提供了RDB和AOF两种持久化机制，它们各有优缺点，本文将对比它们的原理和适用场景...','# Redis 持久化\n\nRedis提供了RDB和AOF两种持久化机制...','# Redis 持久化\n\nRedis提供了RDB和AOF两种持久化机制...',0,'publish',0,0,1101,NULL,NULL,'2026-04-05 06:49:19','2026-04-06 00:25:13',0,NULL,NULL,75,0),(304,1,28,'Redis 缓存穿透、缓存击穿与缓存雪崩解决方案','','在高并发场景下，Redis缓存可能会遇到穿透、击穿、雪崩等问题，本文提供详细的解决方案...','# Redis 缓存问题\n\n在高并发场景下，Redis缓存可能会遇到穿透、击穿、雪崩等问题...','# Redis 缓存问题\n\n在高并发场景下，Redis缓存可能会遇到穿透、击穿、雪崩等问题...',0,'publish',0,0,892,NULL,NULL,'2026-04-26 19:06:32','2026-04-27 06:02:35',0,'2026-05-13 20:09:28','2026-05-15 00:18:12',34,0),(305,1,16,'Docker 容器化部署 Spring Boot + Vue 项目','','本文详细介绍如何使用Docker和Docker Compose部署前后端分离的Spring Boot + Vue项目...','# Docker 部署\n\n本文详细介绍如何使用Docker和Docker Compose部署...','# Docker 部署\n\n本文详细介绍如何使用Docker和Docker Compose部署...',0,'publish',0,0,238,NULL,NULL,'2026-03-30 13:40:31','2026-03-30 15:02:31',0,'2026-05-11 20:27:01','2026-05-11 20:34:56',7,0),(306,1,16,'Linux 常用命令速查手册','','整理了Linux运维中常用的命令，包括文件操作、系统监控、网络配置等...','# Linux 常用命令\n\n整理了Linux运维中常用的命令...','# Linux 常用命令\n\n整理了Linux运维中常用的命令...',0,'publish',0,0,1916,NULL,NULL,'2026-04-20 15:51:12','2026-04-21 15:24:46',0,NULL,NULL,69,0),(307,1,13,'测试文章',NULL,'测试','<p>11111111111111111111111111111</p>\n','11111111111111111111111111111',1,'publish',0,0,0,'',NULL,'2026-03-26 10:08:27','2026-03-26 13:28:24',0,'2026-05-11 20:18:10','2026-05-12 13:22:22',0,0),(308,1,17,'【测试文章】该文章用于毕业设计论文的测试！','http://127.0.0.1:8800/localFile/local-plus/20260511/article-cover/05_ScreenShot_2026-04-25_105414_373.png','10086','<p>测试测试文章2131313131231</p>\n','测试测试文章2131313131231',1,'publish',0,0,0,NULL,NULL,'2026-03-28 01:59:41','2026-03-28 21:16:31',0,NULL,NULL,0,0);
/*!40000 ALTER TABLE `sys_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_article_collect`
--

DROP TABLE IF EXISTS `sys_article_collect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_article_collect` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '涓婚敭',
  `user_id` int NOT NULL COMMENT '鐢ㄦ埛id',
  `article_id` bigint NOT NULL COMMENT '鏂囩珷id',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '鏀惰棌鐘舵?:1宸叉敹钘?0宸插彇娑',
  `operation_count` int NOT NULL DEFAULT '1' COMMENT '鎿嶄綔绱??娆℃暟',
  `last_collect_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '鏈?繎鏀惰棌鏃堕棿',
  `last_uncollect_time` datetime DEFAULT NULL COMMENT '鏈?繎鍙栨秷鏀惰棌鏃堕棿',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_article` (`user_id`,`article_id`) USING BTREE,
  KEY `idx_user_status_update` (`user_id`,`status`,`update_time`),
  KEY `idx_article_status` (`article_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='鏂囩珷鏀惰棌琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_article_collect`
--

LOCK TABLES `sys_article_collect` WRITE;
/*!40000 ALTER TABLE `sys_article_collect` DISABLE KEYS */;
INSERT INTO `sys_article_collect` VALUES (2,1817,292,1,1,'2026-04-24 20:17:15',NULL,'2026-04-24 20:17:15','2026-04-24 20:17:15');
/*!40000 ALTER TABLE `sys_article_collect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_article_collect_log`
--

DROP TABLE IF EXISTS `sys_article_collect_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_article_collect_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '涓婚敭',
  `user_id` int NOT NULL COMMENT '鐢ㄦ埛id',
  `article_id` bigint NOT NULL COMMENT '鏂囩珷id',
  `action_type` varchar(20) NOT NULL COMMENT '鍔ㄤ綔绫诲瀷:COLLECT/UN_COLLECT',
  `result_code` int NOT NULL DEFAULT '200' COMMENT '鎺ュ彛杩斿洖鐮',
  `rate_limit_count` int DEFAULT NULL COMMENT '褰撳墠绐楀彛璁℃暟',
  `rate_limit_threshold` int DEFAULT NULL COMMENT '绐楀彛闃堝?',
  `request_uri` varchar(255) DEFAULT NULL COMMENT '璇锋眰URI',
  `client_ip` varchar(64) DEFAULT NULL COMMENT '瀹㈡埛绔疘P',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '璁板綍鏃堕棿',
  PRIMARY KEY (`id`),
  KEY `idx_user_article_time` (`user_id`,`article_id`,`create_time`),
  KEY `idx_action_time` (`action_type`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鏂囩珷鏀惰棌琛屼负鏃ュ織';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_article_collect_log`
--

LOCK TABLES `sys_article_collect_log` WRITE;
/*!40000 ALTER TABLE `sys_article_collect_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_article_collect_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_article_history`
--

DROP TABLE IF EXISTS `sys_article_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_article_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `article_id` bigint NOT NULL COMMENT '文章ID',
  `title` varchar(100) DEFAULT NULL COMMENT '文章标题',
  `content` longtext COMMENT '文章内容',
  `content_md` longtext COMMENT 'Markdown内容',
  `summary` varchar(255) DEFAULT NULL COMMENT '修改摘要',
  `version` int NOT NULL DEFAULT '1' COMMENT '版本号',
  `create_by` varchar(64) DEFAULT '' COMMENT '修改人',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_article_id` (`article_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文章版本历史记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_article_history`
--

LOCK TABLES `sys_article_history` WRITE;
/*!40000 ALTER TABLE `sys_article_history` DISABLE KEYS */;
INSERT INTO `sys_article_history` VALUES (1,292,NULL,'<h4><a id=\"_0\"></a>前言</h4>\r\n<p>本后台管理系统基于当下前沿的技术栈 vue3、typescript 以及 elementui-plus 进行精心构建。在功能维度上，其与若依系统具备相当的完整性与丰富度，涵盖了诸如用户管理、权限控制、数据统计分析、业务流程处理等一系列核心后台管理功能模块，能够高效地支撑各类企业级业务运营需求。然而，本系统在视觉呈现方面展现出独特的优势，通过对样式的深度美化与精心雕琢，采用了更为先进的 UI 设计理念与精细化的布局策略，运用精致的色彩搭配、优雅的字体选择以及灵动的交互元素设计，使其整体视觉效果相较于若依更为美观、精致且专业，能够为用户带来更舒适、高效且具品质感的操作体验，极大地提升了后台管理工作的愉悦度与便捷性，彰显出卓越的专业性与高端品质形象。</p>\r\n<h4><a id=\"_4\"></a>视频预览</h4>\r\n<p><video height=\"100%\" width=\"100%\" src=\"http://127.0.0.1:8800/localFile/local-plus/upload/20241120_230652.mp4\" controls autoplay></video></p>\r\n<h4><a id=\"_8\"></a>仓库地址</h4>\r\n<p><a href=\"https://gitee.com/quequnlong/vue-neat-admin\" target=\"_blank\">Neat-Admin</a></p>\r\n','#### 前言\r\n\r\n  本后台管理系统基于当下前沿的技术栈 vue3、typescript 以及 elementui-plus 进行精心构建。在功能维度上，其与若依系统具备相当的完整性与丰富度，涵盖了诸如用户管理、权限控制、数据统计分析、业务流程处理等一系列核心后台管理功能模块，能够高效地支撑各类企业级业务运营需求。然而，本系统在视觉呈现方面展现出独特的优势，通过对样式的深度美化与精心雕琢，采用了更为先进的 UI 设计理念与精细化的布局策略，运用精致的色彩搭配、优雅的字体选择以及灵动的交互元素设计，使其整体视觉效果相较于若依更为美观、精致且专业，能够为用户带来更舒适、高效且具品质感的操作体验，极大地提升了后台管理工作的愉悦度与便捷性，彰显出卓越的专业性与高端品质形象。\r\n  \r\n  #### 视频预览\r\n    <video height=100% width=100% src=\"http://127.0.0.1:8800/localFile/local-plus/upload/20241120_230652.mp4\" controls autoplay></video>\r\n  \r\n  \r\n  #### 仓库地址\r\n  [Neat-Admin](https://gitee.com/quequnlong/vue-neat-admin)','初始版本',1,'admin','2026-02-04 15:09:03'),(2,296,NULL,'# Java 内存模型\n\nJava内存模型(Java Memory Model)是Java虚拟机规范中定义的一种内存模型...','# Java 内存模型\n\nJava内存模型(Java Memory Model)是Java虚拟机规范中定义的一种内存模型...','初始版本',1,'admin','2025-05-30 02:03:08'),(3,297,NULL,'# Spring Boot 自动配置\n\nSpring Boot的自动配置机制是其核心特性之一...','# Spring Boot 自动配置\n\nSpring Boot的自动配置机制是其核心特性之一...','初始版本',1,'admin','2025-08-10 21:02:57'),(4,298,NULL,'# Java 8 Stream API\n\nJava 8引入的Stream API极大地简化了集合操作...','# Java 8 Stream API\n\nJava 8引入的Stream API极大地简化了集合操作...','初始版本',1,'admin','2025-12-21 18:16:53'),(5,299,NULL,'# Vue 3.0 Composition API\n\nVue 3.0带来的组合式API解决了Vue 2.x中逻辑复用困难的问题...','# Vue 3.0 Composition API\n\nVue 3.0带来的组合式API解决了Vue 2.x中逻辑复用困难的问题...','初始版本',1,'admin','2025-10-08 05:10:15'),(6,300,NULL,'# Vue Router 4.x 路由守卫\n\n在Vue项目开发中，路由守卫是控制页面访问权限的重要手段...','# Vue Router 4.x 路由守卫\n\n在Vue项目开发中，路由守卫是控制页面访问权限的重要手段...','初始版本',1,'admin','2025-04-05 08:11:16'),(7,301,NULL,'# MySQL 索引失效\n\n索引是提升MySQL查询性能的关键...','# MySQL 索引失效\n\n索引是提升MySQL查询性能的关键...','初始版本',1,'admin','2025-07-31 06:27:21'),(8,302,NULL,'# MySQL 事务与锁\n\n深入理解MySQL的事务隔离级别...','# MySQL 事务与锁\n\n深入理解MySQL的事务隔离级别...','初始版本',1,'admin','2025-10-08 15:18:31'),(9,303,NULL,'# Redis 持久化\n\nRedis提供了RDB和AOF两种持久化机制...','# Redis 持久化\n\nRedis提供了RDB和AOF两种持久化机制...','初始版本',1,'admin','2025-11-22 11:00:31'),(10,304,NULL,'# Redis 缓存问题\n\n在高并发场景下，Redis缓存可能会遇到穿透、击穿、雪崩等问题...','# Redis 缓存问题\n\n在高并发场景下，Redis缓存可能会遇到穿透、击穿、雪崩等问题...','初始版本',1,'admin','2025-08-28 12:26:17'),(11,305,NULL,'# Docker 部署\n\n本文详细介绍如何使用Docker和Docker Compose部署...','# Docker 部署\n\n本文详细介绍如何使用Docker和Docker Compose部署...','初始版本',1,'admin','2025-06-01 06:53:31'),(12,306,NULL,'# Linux 常用命令\n\n整理了Linux运维中常用的命令...','# Linux 常用命令\n\n整理了Linux运维中常用的命令...','初始版本',1,'admin','2025-05-11 11:38:39'),(16,292,'个人开发的管理系统  Neat-Admin','<p>这是 个人开发的管理系统  Neat-Admin 的早期历史版本内容。</p>','这是 个人开发的管理系统  Neat-Admin 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(17,296,'深入理解 Java 内存模型 (JMM)','<p>这是 深入理解 Java 内存模型 (JMM) 的早期历史版本内容。</p>','这是 深入理解 Java 内存模型 (JMM) 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(18,297,'Spring Boot 自动配置原理详解','<p>这是 Spring Boot 自动配置原理详解 的早期历史版本内容。</p>','这是 Spring Boot 自动配置原理详解 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(19,298,'Java 8 Stream API 实战指南','<p>这是 Java 8 Stream API 实战指南 的早期历史版本内容。</p>','这是 Java 8 Stream API 实战指南 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(20,299,'Vue 3.0 组合式 API (Composition API) 上手教程','<p>这是 Vue 3.0 组合式 API (Composition API) 上手教程 的早期历史版本内容。</p>','这是 Vue 3.0 组合式 API (Composition API) 上手教程 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(21,300,'Vue Router 4.x 路由守卫详解','<p>这是 Vue Router 4.x 路由守卫详解 的早期历史版本内容。</p>','这是 Vue Router 4.x 路由守卫详解 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(22,301,'MySQL 索引失效的十大场景','<p>这是 MySQL 索引失效的十大场景 的早期历史版本内容。</p>','这是 MySQL 索引失效的十大场景 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(23,302,'MySQL 事务隔离级别与锁机制','<p>这是 MySQL 事务隔离级别与锁机制 的早期历史版本内容。</p>','这是 MySQL 事务隔离级别与锁机制 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(24,303,'Redis 持久化机制 RDB 与 AOF 对比','<p>这是 Redis 持久化机制 RDB 与 AOF 对比 的早期历史版本内容。</p>','这是 Redis 持久化机制 RDB 与 AOF 对比 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(25,304,'Redis 缓存穿透、缓存击穿与缓存雪崩解决方案','<p>这是 Redis 缓存穿透、缓存击穿与缓存雪崩解决方案 的早期历史版本内容。</p>','这是 Redis 缓存穿透、缓存击穿与缓存雪崩解决方案 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(26,305,'Docker 容器化部署 Spring Boot + Vue 项目','<p>这是 Docker 容器化部署 Spring Boot + Vue 项目 的早期历史版本内容。</p>','这是 Docker 容器化部署 Spring Boot + Vue 项目 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(27,306,'Linux 常用命令速查手册','<p>这是 Linux 常用命令速查手册 的早期历史版本内容。</p>','这是 Linux 常用命令速查手册 的早期历史版本内容。','历史版本摘要',1,'admin','2026-03-29 13:39:57'),(28,307,'测试文章','<p>11111111111111111111111111111</p>\n','11111111111111111111111111111','创建文章',1,'1','2026-04-25 15:52:30'),(29,308,'【测试文章】该文章用于毕业设计论文的测试！','<p>测试测试文章</p>\n','测试测试文章','创建文章',1,'1','2026-05-11 19:30:56'),(30,308,'【测试文章】该文章用于毕业设计论文的测试！','<p>测试测试文章</p>\n','测试测试文章','更新文章',2,'1','2026-05-11 19:31:13'),(31,308,'【测试文章】该文章用于毕业设计论文的测试！','<p>测试测试文章2131313131231</p>\n','测试测试文章2131313131231','更新文章',3,'1','2026-05-12 19:52:55');
/*!40000 ALTER TABLE `sys_article_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_article_like`
--

DROP TABLE IF EXISTS `sys_article_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_article_like` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int NOT NULL COMMENT '用户id',
  `article_id` bigint NOT NULL COMMENT '文章id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_article_like_article` (`article_id`),
  CONSTRAINT `fk_article_like_article` FOREIGN KEY (`article_id`) REFERENCES `sys_article` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1058 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文章点赞表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_article_like`
--

LOCK TABLES `sys_article_like` WRITE;
/*!40000 ALTER TABLE `sys_article_like` DISABLE KEYS */;
INSERT INTO `sys_article_like` VALUES (4,4,292),(5,72,292),(6,39,292),(7,86,292),(8,52,292),(9,82,292),(10,8,292),(11,33,292),(12,39,292),(13,70,292),(14,71,292),(15,16,292),(16,63,292),(17,97,292),(18,112,292),(19,43,292),(20,78,292),(21,101,292),(22,68,292),(23,106,292),(24,72,292),(25,32,292),(26,69,292),(27,32,292),(28,39,292),(29,63,292),(30,69,292),(31,99,292),(32,91,292),(33,63,292),(34,79,292),(35,70,292),(36,108,292),(37,63,292),(38,106,292),(39,113,292),(40,71,292),(41,74,292),(42,45,292),(43,39,292),(44,6,292),(45,94,292),(46,59,292),(47,71,292),(48,21,292),(49,31,292),(50,55,292),(51,85,292),(52,53,292),(53,55,292),(54,79,292),(55,93,292),(56,84,292),(57,94,292),(58,113,292),(59,56,292),(60,53,292),(61,84,292),(62,103,292),(63,100,292),(64,99,292),(65,39,292),(66,7,292),(67,84,292),(68,18,292),(69,78,292),(70,31,292),(71,39,292),(72,12,292),(73,80,292),(74,39,292),(75,105,292),(76,45,292),(77,113,292),(78,68,292),(79,102,292),(80,71,292),(81,80,292),(82,83,292),(83,25,292),(84,69,292),(85,90,292),(86,30,292),(87,19,292),(88,45,292),(89,78,292),(90,21,292),(91,48,292),(92,15,292),(93,65,292),(94,38,292),(95,97,292),(96,53,292),(97,19,292),(98,38,292),(99,54,292),(100,37,292),(101,44,292),(102,88,292),(103,117,292),(104,35,292),(105,39,292),(106,27,292),(107,46,292),(108,33,292),(109,99,292),(110,89,292),(111,80,292),(112,81,292),(113,69,292),(114,35,292),(115,82,292),(116,84,292),(117,82,292),(118,69,296),(119,60,296),(120,40,296),(121,76,296),(122,60,296),(123,85,296),(124,34,296),(125,21,296),(126,96,296),(127,71,296),(128,29,296),(129,37,296),(130,92,296),(131,87,296),(132,24,296),(133,57,296),(134,109,296),(135,62,296),(136,44,296),(137,97,296),(138,68,296),(139,62,296),(140,50,296),(141,12,296),(142,101,296),(143,9,296),(144,72,296),(145,25,296),(146,19,297),(147,56,297),(148,57,297),(149,7,297),(150,52,297),(151,88,297),(152,14,297),(153,33,297),(154,82,297),(155,105,297),(156,48,297),(157,36,297),(158,19,297),(159,94,297),(160,63,297),(161,96,297),(162,24,297),(163,77,297),(164,53,297),(165,80,297),(166,36,297),(167,27,297),(168,4,297),(169,61,297),(170,78,297),(171,10,297),(172,39,297),(173,57,297),(174,56,297),(175,35,297),(176,88,297),(177,57,297),(178,92,297),(179,16,297),(180,41,297),(181,58,297),(182,69,297),(183,107,297),(184,42,297),(185,40,297),(186,90,297),(187,63,297),(188,84,297),(189,92,297),(190,53,297),(191,75,297),(192,76,297),(193,28,297),(194,38,297),(195,101,297),(196,76,297),(197,34,297),(198,62,297),(199,41,297),(200,22,297),(201,49,297),(202,64,297),(203,92,297),(204,81,297),(205,55,297),(206,67,297),(207,74,297),(208,40,297),(209,25,297),(210,19,297),(211,85,297),(212,32,297),(213,107,297),(214,87,297),(215,52,297),(216,14,297),(217,25,297),(218,96,297),(219,50,297),(220,35,297),(221,79,297),(222,36,297),(223,43,297),(224,60,297),(225,66,297),(226,26,297),(227,39,297),(228,83,297),(229,87,297),(230,80,297),(231,99,297),(232,93,297),(233,38,297),(234,44,297),(235,19,297),(236,24,297),(237,45,297),(238,86,297),(239,52,297),(240,70,297),(241,40,297),(242,74,297),(243,50,297),(244,56,297),(245,112,297),(246,64,297),(247,50,297),(248,40,297),(249,70,297),(250,29,297),(251,18,297),(252,22,297),(253,33,297),(254,23,297),(255,81,297),(256,20,297),(257,101,297),(258,102,297),(259,84,297),(260,108,297),(261,97,297),(262,101,297),(263,3,298),(264,31,298),(265,43,298),(266,49,298),(267,68,298),(268,101,298),(269,11,298),(270,99,298),(271,19,298),(272,60,298),(273,50,298),(274,27,298),(275,55,298),(276,73,298),(277,35,298),(278,84,298),(279,24,298),(280,93,298),(281,70,298),(282,99,298),(283,69,298),(284,40,298),(285,52,298),(286,59,298),(287,47,298),(288,23,298),(289,50,298),(290,107,298),(291,55,298),(292,31,298),(293,38,298),(294,74,298),(295,37,298),(296,51,298),(297,95,298),(298,77,298),(299,17,299),(300,10,299),(301,39,299),(302,85,299),(303,70,299),(304,84,299),(305,46,299),(306,11,299),(307,44,299),(308,82,299),(309,45,300),(310,72,300),(311,73,300),(312,51,300),(313,7,300),(314,16,300),(315,104,300),(316,74,300),(317,54,300),(318,65,300),(319,31,300),(320,24,300),(321,28,300),(322,51,300),(323,90,300),(324,102,300),(325,105,300),(326,99,300),(327,106,300),(328,102,300),(329,66,300),(330,90,300),(331,89,300),(332,53,300),(333,36,300),(334,42,300),(335,103,300),(336,81,300),(337,81,300),(338,94,300),(339,20,300),(340,76,300),(341,30,300),(342,22,300),(343,64,300),(344,77,300),(345,112,300),(346,83,300),(347,106,300),(348,101,300),(349,6,300),(350,57,300),(351,35,300),(352,90,300),(353,9,300),(354,16,300),(355,86,300),(356,45,300),(357,15,300),(358,50,300),(359,32,300),(360,99,300),(361,65,300),(362,31,300),(363,28,300),(364,45,300),(365,31,300),(366,32,300),(367,86,300),(368,105,300),(369,31,300),(370,16,300),(371,33,300),(372,48,300),(373,45,300),(374,38,300),(375,14,300),(376,54,300),(377,73,300),(378,82,300),(379,74,300),(380,107,300),(381,87,300),(382,52,300),(383,39,300),(384,44,300),(385,67,300),(386,115,300),(387,92,300),(388,55,300),(389,43,300),(390,54,300),(391,86,300),(392,96,300),(393,87,300),(394,70,300),(395,13,300),(396,66,300),(397,16,300),(398,34,300),(399,13,300),(400,43,300),(401,25,300),(402,74,300),(403,66,300),(404,32,300),(405,110,300),(406,39,300),(407,82,300),(408,92,300),(409,73,300),(410,22,300),(411,32,300),(412,4,300),(413,86,300),(414,99,300),(415,9,300),(416,20,300),(417,78,300),(418,12,300),(419,26,300),(420,36,300),(421,46,300),(422,86,300),(423,40,300),(424,75,300),(425,97,300),(426,47,300),(427,101,300),(428,112,300),(429,94,300),(430,58,300),(431,55,300),(432,7,300),(433,92,300),(434,78,300),(435,86,300),(436,103,300),(437,107,300),(438,81,300),(439,49,300),(440,74,300),(441,76,300),(442,63,300),(443,111,300),(444,104,300),(445,17,300),(446,71,300),(447,73,300),(448,57,300),(449,94,300),(450,5,300),(451,84,300),(452,101,300),(453,70,300),(454,31,300),(455,33,300),(456,104,300),(457,69,300),(458,97,300),(459,18,300),(460,87,300),(461,72,300),(462,27,300),(463,52,300),(464,115,300),(465,96,300),(466,110,300),(467,83,300),(468,49,300),(469,72,300),(470,72,300),(471,55,300),(472,51,300),(473,73,300),(474,72,300),(475,36,300),(476,44,300),(477,70,300),(478,20,300),(479,88,300),(480,75,300),(481,65,300),(482,112,300),(483,34,300),(484,37,300),(485,63,300),(486,50,300),(487,117,300),(488,104,300),(489,72,300),(490,56,300),(491,91,300),(492,64,300),(493,10,300),(494,64,300),(495,10,300),(496,53,301),(497,5,301),(498,53,301),(499,24,301),(500,33,301),(501,10,301),(502,54,301),(503,56,301),(504,107,301),(505,58,301),(506,15,301),(507,109,301),(508,74,301),(509,90,301),(510,94,301),(511,97,301),(512,112,301),(513,22,301),(514,90,301),(515,29,301),(516,78,301),(517,38,301),(518,64,301),(519,61,301),(520,72,301),(521,73,301),(522,39,301),(523,90,301),(524,95,301),(525,65,301),(526,31,301),(527,23,301),(528,93,301),(529,23,301),(530,108,301),(531,49,301),(532,22,301),(533,88,301),(534,117,301),(535,57,302),(536,44,302),(537,64,302),(538,88,302),(539,65,302),(540,44,302),(541,47,302),(542,45,302),(543,97,302),(544,85,302),(545,93,302),(546,100,302),(547,88,302),(548,46,302),(549,112,302),(550,41,302),(551,101,302),(552,57,302),(553,93,302),(554,36,302),(555,94,302),(556,25,302),(557,62,302),(558,16,302),(559,28,302),(560,87,302),(561,90,302),(562,72,302),(563,82,302),(564,73,302),(565,94,302),(566,29,302),(567,84,302),(568,33,302),(569,113,302),(570,70,302),(571,27,302),(572,34,302),(573,89,302),(574,95,302),(575,36,302),(576,60,302),(577,73,302),(578,66,302),(579,94,302),(580,14,302),(581,56,302),(582,88,302),(583,35,302),(584,82,302),(585,53,302),(586,27,302),(587,99,302),(588,39,302),(589,17,302),(590,105,302),(591,65,302),(592,115,302),(593,81,302),(594,39,302),(595,35,302),(596,11,302),(597,71,302),(598,5,302),(599,96,302),(600,71,302),(601,15,302),(602,53,302),(603,75,302),(604,18,302),(605,76,302),(606,73,302),(607,35,302),(608,82,302),(609,29,302),(610,29,302),(611,26,302),(612,70,302),(613,118,302),(614,83,302),(615,12,302),(616,94,302),(617,20,302),(618,54,302),(619,7,302),(620,44,302),(621,79,302),(622,83,302),(623,20,302),(624,12,303),(625,7,303),(626,53,303),(627,30,303),(628,103,303),(629,37,303),(630,62,303),(631,79,303),(632,49,303),(633,64,303),(634,82,303),(635,94,303),(636,35,303),(637,22,303),(638,89,303),(639,91,303),(640,37,303),(641,89,303),(642,84,303),(643,97,303),(644,59,303),(645,6,303),(646,37,303),(647,88,303),(648,93,303),(649,12,303),(650,37,303),(651,54,303),(652,89,303),(653,50,303),(654,21,303),(655,39,303),(656,106,303),(657,26,303),(658,29,303),(659,108,303),(660,104,303),(661,60,303),(662,60,303),(663,51,303),(664,93,303),(665,93,303),(666,88,303),(667,72,303),(668,68,303),(669,23,303),(670,55,303),(671,105,303),(672,13,303),(673,65,303),(674,59,303),(675,76,303),(676,95,303),(677,63,303),(678,88,303),(679,27,303),(680,51,303),(681,56,303),(682,64,303),(683,44,303),(684,58,303),(685,61,303),(686,57,303),(687,57,303),(688,98,303),(689,69,303),(690,49,303),(691,86,303),(692,47,303),(693,45,303),(694,53,303),(695,33,303),(696,43,303),(697,48,303),(698,75,303),(699,49,303),(700,29,303),(701,57,303),(702,27,303),(703,51,303),(704,26,303),(705,65,303),(706,63,303),(707,92,303),(708,72,303),(709,40,303),(710,17,303),(711,22,303),(712,78,303),(713,32,303),(714,58,303),(715,98,303),(716,74,303),(717,59,303),(718,37,303),(719,114,303),(720,71,303),(721,76,303),(722,84,303),(723,54,303),(724,61,303),(725,34,303),(726,60,303),(727,103,303),(728,104,303),(729,6,303),(730,93,303),(731,20,303),(732,17,303),(733,30,303),(734,52,303),(735,103,303),(736,33,303),(737,60,303),(738,23,303),(739,32,303),(740,97,303),(741,109,303),(742,38,303),(743,68,303),(744,74,303),(745,50,303),(746,48,303),(747,75,303),(748,72,303),(749,38,303),(750,22,303),(751,57,303),(752,14,303),(753,28,303),(754,29,303),(755,93,303),(756,20,303),(757,88,303),(758,57,303),(759,41,303),(760,52,303),(761,45,303),(762,104,303),(763,76,303),(764,31,303),(765,98,303),(766,45,303),(767,103,303),(768,57,303),(769,28,303),(770,27,303),(771,11,303),(772,67,303),(773,48,303),(774,13,303),(775,89,303),(776,98,303),(777,97,303),(778,39,303),(779,73,303),(780,44,303),(781,56,303),(782,54,303),(783,74,303),(784,58,303),(785,39,303),(786,61,303),(787,49,303),(788,82,303),(789,52,303),(790,62,303),(791,47,303),(792,30,303),(793,26,303),(794,79,304),(795,33,304),(796,44,304),(797,63,304),(798,96,304),(799,16,304),(800,36,304),(801,57,304),(802,55,304),(803,104,304),(804,93,304),(805,101,304),(806,46,304),(807,45,304),(808,36,304),(809,52,304),(810,66,304),(811,111,304),(812,66,304),(813,22,304),(814,99,304),(815,73,304),(816,37,304),(817,81,304),(818,67,304),(819,85,304),(820,16,304),(821,8,304),(822,73,304),(823,36,304),(824,62,304),(825,33,304),(826,43,304),(827,107,304),(828,65,304),(829,45,304),(830,100,304),(831,73,304),(832,95,304),(833,29,304),(834,75,304),(835,93,304),(836,84,304),(837,12,304),(838,36,304),(839,85,304),(840,105,304),(841,62,304),(842,85,304),(843,30,304),(844,18,304),(845,36,304),(846,66,304),(847,78,304),(848,71,304),(849,55,304),(850,71,304),(851,66,304),(852,54,304),(853,41,304),(854,86,304),(855,53,304),(856,88,304),(857,12,304),(858,48,304),(859,33,304),(860,75,304),(861,71,304),(862,108,304),(863,49,304),(864,52,304),(865,100,304),(866,69,304),(867,113,304),(868,100,304),(869,101,304),(870,22,304),(871,54,304),(872,55,305),(873,77,305),(874,87,305),(875,40,305),(876,19,305),(877,52,305),(878,81,305),(879,57,305),(880,22,305),(881,72,305),(882,27,305),(883,71,305),(884,40,305),(885,52,305),(886,16,305),(887,34,305),(888,8,306),(889,89,306),(890,14,306),(891,103,306),(892,78,306),(893,75,306),(894,99,306),(895,93,306),(896,106,306),(897,103,306),(898,69,306),(899,68,306),(900,112,306),(901,39,306),(902,17,306),(903,49,306),(904,17,306),(905,34,306),(906,69,306),(907,30,306),(908,87,306),(909,83,306),(910,8,306),(911,64,306),(912,103,306),(913,72,306),(914,94,306),(915,58,306),(916,42,306),(917,11,306),(918,23,306),(919,54,306),(920,86,306),(921,40,306),(922,36,306),(923,98,306),(924,86,306),(925,65,306),(926,109,306),(927,29,306),(928,21,306),(929,43,306),(930,60,306),(931,89,306),(932,18,306),(933,79,306),(934,7,306),(935,100,306),(936,68,306),(937,74,306),(938,80,306),(939,89,306),(940,90,306),(941,44,306),(942,50,306),(943,45,306),(944,109,306),(945,39,306),(946,22,306),(947,59,306),(948,75,306),(949,16,306),(950,57,306),(951,22,306),(952,71,306),(953,59,306),(954,48,306),(955,13,306),(956,19,306),(957,97,306),(958,58,306),(959,28,306),(960,112,306),(961,84,306),(962,76,306),(963,96,306),(964,102,306),(965,64,306),(966,113,306),(967,35,306),(968,60,306),(969,31,306),(970,100,306),(971,32,306),(972,48,306),(973,26,306),(974,21,306),(975,98,306),(976,54,306),(977,79,306),(978,91,306),(979,89,306),(980,47,306),(981,82,306),(982,61,306),(983,81,306),(984,88,306),(985,53,306),(986,115,306),(987,35,306),(988,81,306),(989,86,306),(990,101,306),(991,42,306),(992,86,306),(993,38,306),(994,84,306),(995,11,306),(996,24,306),(997,59,306),(998,74,306),(999,78,306),(1000,18,306),(1001,42,306),(1002,39,306),(1003,109,306),(1004,32,306),(1005,60,306),(1006,38,306),(1007,31,306),(1008,61,306),(1009,73,306),(1010,85,306),(1011,51,306),(1012,46,306),(1013,57,306),(1014,76,306),(1015,106,306),(1016,82,306),(1017,100,306),(1018,69,306),(1019,89,306),(1020,37,306),(1021,78,306),(1022,24,306),(1023,51,306),(1024,42,306),(1025,111,306),(1026,52,306),(1027,67,306),(1028,5,306),(1029,19,306),(1030,45,306),(1031,13,306),(1032,38,306),(1033,93,306),(1034,62,306),(1035,18,306),(1036,53,306),(1037,61,306),(1038,66,306),(1039,56,306),(1040,68,306),(1041,25,306),(1042,45,306),(1043,28,306),(1044,76,306),(1045,74,306),(1046,50,306),(1047,31,306),(1048,47,306),(1049,74,306),(1050,7,306),(1051,11,306),(1052,8,306),(1053,55,306),(1054,11,306);
/*!40000 ALTER TABLE `sys_article_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_article_tag`
--

DROP TABLE IF EXISTS `sys_article_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_article_tag` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `article_id` int NOT NULL COMMENT '文章id',
  `tag_id` int NOT NULL COMMENT '标签id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1404 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='文章标签关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_article_tag`
--

LOCK TABLES `sys_article_tag` WRITE;
/*!40000 ALTER TABLE `sys_article_tag` DISABLE KEYS */;
INSERT INTO `sys_article_tag` VALUES (1379,292,1),(1380,292,12),(1386,296,66),(1387,297,66),(1388,297,1),(1389,298,66),(1390,299,100),(1391,300,100),(1392,301,31),(1393,302,31),(1394,303,17),(1395,304,17),(1396,305,101),(1397,305,1),(1398,305,100),(1399,306,18),(1400,307,89),(1403,308,1);
/*!40000 ALTER TABLE `sys_article_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_author`
--

DROP TABLE IF EXISTS `sys_author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_author` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '作者名称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '作者头像',
  `description` varchar(255) DEFAULT NULL COMMENT '个人简介',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='作者信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_author`
--

LOCK TABLES `sys_author` WRITE;
/*!40000 ALTER TABLE `sys_author` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_cache`
--

DROP TABLE IF EXISTS `sys_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_cache` (
  `cache_key` varchar(191) NOT NULL COMMENT '???',
  `cache_value` longtext COMMENT '???',
  `expire_time` bigint DEFAULT '-1' COMMENT '????(??TS)',
  PRIMARY KEY (`cache_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='?????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_cache`
--

LOCK TABLES `sys_cache` WRITE;
/*!40000 ALTER TABLE `sys_cache` DISABLE KEYS */;
INSERT INTO `sys_cache` VALUES ('article_quantity','{\"@type\":\"java.util.HashMap\",\"299\":[\"26.125.17.30\"],\"300\":[\"26.125.17.30\",\"127.0.0.1\"],\"302\":[\"26.125.17.30\"],\"304\":[\"26.125.17.30\",\"127.0.0.1\"],\"305\":[\"26.125.17.30\"],\"307\":[\"26.125.17.30\"],\"292\":[\"127.0.0.1\",\"26.125.17.30\"]}',-1),('Authorization:login:session:1','{\"@type\":\"cn.dev33.satoken.session.SaSession\",\"createTime\":1778770066125,\"dataMap\":{\"@type\":\"java.util.HashMap\",\"current_user\":{\"@type\":\"com.mojian.dto.user.LoginUserInfo\",\"avatar\":\"/avatar/blogger.jpg\",\"id\":1,\"nickname\":\"管理员\",\"token\":\"76887150-596d-41a3-a2a2-3e17f6998f44\",\"username\":\"admin\"}},\"id\":\"Authorization:login:session:1\",\"loginId\":1,\"loginType\":\"login\",\"timeout\":592602,\"tokenSignList\":[{\"device\":\"default-device\",\"value\":\"76887150-596d-41a3-a2a2-3e17f6998f44\"}],\"type\":\"Account-Session\"}',1779380296042),('Authorization:login:token:1a7cdcc9-5aba-4466-91ad-6edb80eb9724','\"-4\"',1779376680242),('Authorization:login:token:76887150-596d-41a3-a2a2-3e17f6998f44','\"1\"',1778794894025),('Authorization:login:token:bc539716-de07-4ef6-a9b9-2a0d0f767e08','\"-4\"',1779380304254),('Authorization:login:token:d8879a13-c133-45d9-8f6f-1cfb3fdf1839','\"-4\"',1779374865226),('Authorization:login:token:f2946664-bc4a-485f-8b16-3f56b41fe542','\"-4\"',1778794889014),('blog_views_count','340L',-1),('login:token:1ee618a9-0e6b-4b51-9ee5-253e1973cbef','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"169.254.186.38\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-28 14:30:20\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"1ee618a9-0e6b-4b51-9ee5-253e1973cbef\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775284220217),('login:token:1f7dd15a-bb75-466f-86a4-3a8ce9cc52b0','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 00:51:54\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"1f7dd15a-bb75-466f-86a4-3a8ce9cc52b0\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779209514404),('login:token:2772b93b-27ec-4b64-b700-8d7b86ad7433','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-29 12:46:03\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"2772b93b-27ec-4b64-b700-8d7b86ad7433\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775364363452),('login:token:2b193abc-b18d-4ad8-b92b-5edb8624575e','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 14:23:01\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"2b193abc-b18d-4ad8-b92b-5edb8624575e\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779258181748),('login:token:4089f932-eaf4-42e8-bedf-a75e34cf3e2c','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 02:27:44\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"4089f932-eaf4-42e8-bedf-a75e34cf3e2c\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779215264499),('login:token:58d688e4-e59f-4685-94fb-61eeed3e8170','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-29 13:22:42\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"58d688e4-e59f-4685-94fb-61eeed3e8170\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775366562674),('login:token:635bc298-9999-447b-9f8d-07ed089b45cf','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 10:33:22\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"635bc298-9999-447b-9f8d-07ed089b45cf\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779244402236),('login:token:6b69c34b-eefa-40b3-bb49-1118e81d0dc0','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 13:02:04\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"6b69c34b-eefa-40b3-bb49-1118e81d0dc0\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779253324079),('login:token:73f8bc08-8ca4-4992-87c3-2e5d4b619219','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 10:34:04\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"73f8bc08-8ca4-4992-87c3-2e5d4b619219\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779244444692),('login:token:746995ec-2638-424f-8d1c-6d0c633a4cbe','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-04-25 11:39:04\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"746995ec-2638-424f-8d1c-6d0c633a4cbe\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1777693144351),('login:token:86c5a1e1-bf3a-49ae-a707-c4e609e3fdfa','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"169.254.186.38\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-28 14:27:57\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"86c5a1e1-bf3a-49ae-a707-c4e609e3fdfa\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775284077349),('login:token:8a6cfeaf-f1b2-48a8-bc7b-c3fe4ad16e8a','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"169.254.186.38\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-27 21:41:29\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"8a6cfeaf-f1b2-48a8-bc7b-c3fe4ad16e8a\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775223689591),('login:token:93317bec-0d1d-4bf7-a67c-490b7390ea84','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 10:47:34\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"93317bec-0d1d-4bf7-a67c-490b7390ea84\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779245254062),('login:token:9863e85f-0914-4d0c-b154-21328a4b5249','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 01:13:18\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"9863e85f-0914-4d0c-b154-21328a4b5249\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779210798942),('login:token:9f911440-2626-4acf-98d1-2328e3c7e63b','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-04-25 14:55:49\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"9f911440-2626-4acf-98d1-2328e3c7e63b\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1777704949455),('login:token:a423fb50-e42f-4361-a0d5-9b2673f982c8','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 17:18:24\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"a423fb50-e42f-4361-a0d5-9b2673f982c8\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779268704207),('login:token:a724a36b-6fde-4b7b-88ad-1faf035387bd','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"169.254.186.38\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-28 14:30:32\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"a724a36b-6fde-4b7b-88ad-1faf035387bd\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775284232201),('login:token:b7250a55-1ec6-4f96-8315-055c33efc752','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-29 20:51:22\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"b7250a55-1ec6-4f96-8315-055c33efc752\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775393482945),('login:token:b98d0add-ed76-4c4f-950e-cf012e0bafcb','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-29 12:19:34\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"b98d0add-ed76-4c4f-950e-cf012e0bafcb\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775362774627),('login:token:c0082c54-71f0-4bfa-8dd0-ebdc5bd2f36f','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-29 12:21:37\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"c0082c54-71f0-4bfa-8dd0-ebdc5bd2f36f\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775362897304),('login:token:c78e575c-8bae-4b72-9805-69cb8ef5ca37','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 00:51:54\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"c78e575c-8bae-4b72-9805-69cb8ef5ca37\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779209514733),('login:token:d65bae48-0501-4807-a646-8b3a9ed88aef','\"{\\\"avatar\\\":\\\"/avatar/blogger.jpg\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2026-04-21 20:47:21\\\",\\\"id\\\":1,\\\"ip\\\":\\\"127.0.0.1\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-05-13 09:58:52\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"管理员\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"status\\\":1,\\\"tokenValue\\\":\\\"d65bae48-0501-4807-a646-8b3a9ed88aef\\\",\\\"updateTime\\\":\\\"2026-04-22 12:00:23\\\",\\\"username\\\":\\\"admin\\\"}\"',1779242332017),('login:token:e1dfaef8-32a4-454d-b175-862aa2de8c2d','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"169.254.186.38\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-27 21:34:09\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"e1dfaef8-32a4-454d-b175-862aa2de8c2d\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775223249367),('login:token:e5556a6b-70d8-486e-a139-e79efe054836','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"169.254.186.38\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-27 17:15:07\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"e5556a6b-70d8-486e-a139-e79efe054836\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775207707076),('login:token:f1b1bf84-1fdc-4ac0-8ebc-71c4fc47130a','\"{\\\"avatar\\\":\\\"https://img2.baidu.com/it/u=3029837478,1144772205&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1731862800&t=a82c956c5d1b9ded3bcd9ffe204802f5\\\",\\\"browser\\\":\\\"Chrome\\\",\\\"createTime\\\":\\\"2024-12-27 14:16:17\\\",\\\"id\\\":1,\\\"ip\\\":\\\"169.254.186.38\\\",\\\"ipLocation\\\":\\\"内网IP|内网IP\\\",\\\"lastLoginTime\\\":\\\"2026-03-27 19:25:49\\\",\\\"loginType\\\":\\\"email\\\",\\\"mobile\\\":\\\"\\\",\\\"nickname\\\":\\\"墨笺\\\",\\\"os\\\":\\\"Windows\\\",\\\"password\\\":\\\"\\\",\\\"sex\\\":1,\\\"status\\\":1,\\\"tokenValue\\\":\\\"f1b1bf84-1fdc-4ac0-8ebc-71c4fc47130a\\\",\\\"updateTime\\\":\\\"2024-12-30 13:43:25\\\",\\\"username\\\":\\\"admin\\\"}\"',1775215549070),('rate_limit:127.0.0.1/api/message/list','\"1\"',1778775558002),('rate_limit:169.254.186.38/api/message/list','\"1\"',1774679316493),('rate_limit:26.125.17.30/api/article/collect/292','\"1\"',1777033040575),('rate_limit:26.125.17.30/api/article/like/292','\"1\"',1777034659189),('slider_captcha_code:ddefc02cc1614106aa6e3d935f150deb','\"124\"',1774679435261),('sys_webconfig','\"{\\\"aboutMe\\\":\\\"<p>西伯利亚系统气不气</p>\\\",\\\"author\\\":\\\"习习中\\\",\\\"authorAvatar\\\":\\\"\\\",\\\"authorInfo\\\":\\\"彻底疯狂\\\",\\\"bulletin\\\":\\\"有没有在长沙内推的小伙伴，卑微博主在线求职了，有的话<span style=\\\\\\\"color:red\\\\\\\">VX：1248954763</span> 联系博主\\\",\\\"createTime\\\":\\\"2024-12-22 11:55:25\\\",\\\"email\\\":\\\"1248954763@qq.com\\\",\\\"gitee\\\":\\\"https://gitee.com/quequnlong\\\",\\\"github\\\":\\\"https://github.com/quequnlong\\\",\\\"id\\\":1,\\\"loginTypeList\\\":\\\"[\\\\\\\"gitee\\\\\\\",\\\\\\\"qq\\\\\\\",\\\\\\\"wechat\\\\\\\"]\\\",\\\"logo\\\":\\\"/avatar/blogger.jpg\\\",\\\"name\\\":\\\"习习中博客\\\",\\\"openAdmiration\\\":1,\\\"openComment\\\":1,\\\"openLantern\\\":0,\\\"qqGroup\\\":\\\"779881756\\\",\\\"qqNumber\\\":\\\"1248954763\\\",\\\"showList\\\":\\\"[\\\\\\\"qq\\\\\\\",\\\\\\\"wechat\\\\\\\",\\\\\\\"gitee\\\\\\\",\\\\\\\"qqGroup\\\\\\\",\\\\\\\"github\\\\\\\",\\\\\\\"email\\\\\\\"]\\\",\\\"summary\\\":\\\"一个专注于技术分享的博客平台\\\",\\\"touristAvatar\\\":\\\"\\\",\\\"updateTime\\\":\\\"2024-12-22 11:55:25\\\",\\\"webUrl\\\":\\\"null\\\",\\\"wechat\\\":\\\"1248954763\\\"}\"',-1),('unique_visitor','Set[\"43f51fca43b49a137810d60bf6bf0501\",\"dead612ca98b47aeccc36222c14137d8\",\"1fc5d450cd6519957bfe9b7c25c2c4e7\",\"5657ae44642764fbf8be97f598a500db\"]',-1),('unique_visitor_count','4L',-1),('wx_login_user_statue:DL1088','\"NOT-LOGIN\"',1776415277765);
/*!40000 ALTER TABLE `sys_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_captcha`
--

DROP TABLE IF EXISTS `sys_captcha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_captcha` (
  `uuid` varchar(64) NOT NULL COMMENT '????',
  `code` varchar(10) NOT NULL COMMENT '???',
  `expire_time` datetime NOT NULL COMMENT '????',
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='??????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_captcha`
--

LOCK TABLES `sys_captcha` WRITE;
/*!40000 ALTER TABLE `sys_captcha` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_captcha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_category`
--

DROP TABLE IF EXISTS `sys_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_category` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_category`
--

LOCK TABLES `sys_category` WRITE;
/*!40000 ALTER TABLE `sys_category` DISABLE KEYS */;
INSERT INTO `sys_category` VALUES (13,'生活随笔','2026-03-02 00:10:44',NULL),(16,'运维部署','2026-03-03 10:26:16',NULL),(17,'后端开发','2026-03-10 03:39:10',NULL),(19,'网络爬虫','2026-04-08 10:57:01',NULL),(20,'资源软件','2026-04-12 19:47:38',NULL),(28,'数据库','2026-04-07 18:07:08',NULL),(31,'前端开发','2026-04-30 07:12:49',NULL),(32,'博客文档','2026-03-06 05:42:43',NULL);
/*!40000 ALTER TABLE `sys_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_comment`
--

DROP TABLE IF EXISTS `sys_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_comment` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评论主键ID，自增唯一标识',
  `article_id` bigint NOT NULL,
  `user_id` int NOT NULL COMMENT '发表评论的用户ID',
  `reply_user_id` int DEFAULT NULL COMMENT '回复人id',
  `parent_id` int DEFAULT NULL COMMENT '父评论ID，用于实现回复评论的层级结构，若为顶级评论则为NULL',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论内容，使用utf8mb4字符集以支持更多字符类型',
  `like_count` int DEFAULT '0' COMMENT '点赞数，记录该评论获得的点赞数量',
  `is_stick` int DEFAULT '0' COMMENT '是否置顶',
  `ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ip',
  `browser` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '浏览器',
  `system` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '系统',
  `ip_source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ip来源',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_article_id` (`article_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE,
  CONSTRAINT `fk_comment_article` FOREIGN KEY (`article_id`) REFERENCES `sys_article` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='评论';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_comment`
--

LOCK TABLES `sys_comment` WRITE;
/*!40000 ALTER TABLE `sys_comment` DISABLE KEYS */;
INSERT INTO `sys_comment` VALUES (32,292,5,NULL,NULL,'Mock comment 1 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-03-29 06:55:08'),(33,292,7,NULL,NULL,'Mock comment 2 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-03-04 17:27:31'),(34,292,6,NULL,NULL,'Mock comment 3 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-04-25 18:32:10'),(35,292,8,NULL,NULL,'Mock comment 4 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-03-24 16:18:20'),(36,292,8,NULL,NULL,'Mock comment 5 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-03-13 01:55:11'),(37,292,18,NULL,NULL,'Mock comment 6 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-04-20 08:40:56'),(38,292,18,NULL,NULL,'Mock comment 7 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-04-02 13:39:08'),(39,292,19,NULL,NULL,'Mock comment 8 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-03-12 18:12:54'),(40,292,20,NULL,NULL,'Mock comment 9 for article 292',0,0,NULL,NULL,NULL,NULL,'2026-03-23 02:07:04'),(41,296,20,NULL,NULL,'Mock comment 1 for article 296',0,0,NULL,NULL,NULL,NULL,'2026-03-15 03:56:40'),(42,296,16,NULL,NULL,'Mock comment 2 for article 296',0,0,NULL,NULL,NULL,NULL,'2026-03-05 13:22:09'),(43,296,17,NULL,NULL,'Mock comment 3 for article 296',0,0,NULL,NULL,NULL,NULL,'2026-04-11 07:00:45'),(44,296,5,NULL,NULL,'Mock comment 4 for article 296',0,0,NULL,NULL,NULL,NULL,'2026-03-10 18:57:23'),(45,296,6,NULL,NULL,'Mock comment 5 for article 296',0,0,NULL,NULL,NULL,NULL,'2026-04-17 01:44:39'),(46,296,14,NULL,NULL,'Mock comment 6 for article 296',0,0,NULL,NULL,NULL,NULL,'2026-03-23 23:51:11'),(47,296,13,NULL,NULL,'Mock comment 7 for article 296',0,0,NULL,NULL,NULL,NULL,'2026-04-04 18:01:55'),(48,296,2,NULL,NULL,'Mock comment 8 for article 296',0,0,NULL,NULL,NULL,NULL,'2026-04-13 18:36:05'),(49,297,14,NULL,NULL,'Mock comment 1 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-04-23 14:54:41'),(50,297,20,NULL,NULL,'Mock comment 2 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-03-15 18:45:11'),(51,297,18,NULL,NULL,'Mock comment 3 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-04-05 01:01:53'),(52,297,16,NULL,NULL,'Mock comment 4 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-03-09 20:53:54'),(53,297,5,NULL,NULL,'Mock comment 5 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-03-01 05:23:50'),(54,297,9,NULL,NULL,'Mock comment 6 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-04-05 12:17:29'),(55,297,13,NULL,NULL,'Mock comment 7 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-04-24 21:15:56'),(56,297,17,NULL,NULL,'Mock comment 8 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-04-15 21:27:15'),(57,297,13,NULL,NULL,'Mock comment 9 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-03-04 19:28:30'),(58,297,16,NULL,NULL,'Mock comment 10 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-03-04 09:00:43'),(59,297,2,NULL,NULL,'Mock comment 11 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-03-06 10:38:04'),(60,297,18,NULL,NULL,'Mock comment 12 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-03-18 02:08:13'),(61,297,19,NULL,NULL,'Mock comment 13 for article 297',0,0,NULL,NULL,NULL,NULL,'2026-03-09 02:46:54'),(62,298,18,NULL,NULL,'Mock comment 1 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-04-20 07:29:50'),(63,298,20,NULL,NULL,'Mock comment 2 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-04-14 05:08:33'),(64,298,14,NULL,NULL,'Mock comment 3 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-03-10 03:13:16'),(65,298,4,NULL,NULL,'Mock comment 4 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-04-05 00:40:40'),(66,298,15,NULL,NULL,'Mock comment 5 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-03-26 17:43:35'),(67,298,5,NULL,NULL,'Mock comment 6 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-03-24 14:35:55'),(68,298,7,NULL,NULL,'Mock comment 7 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-04-10 19:48:49'),(69,298,5,NULL,NULL,'Mock comment 8 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-03-12 07:16:25'),(70,298,5,NULL,NULL,'Mock comment 9 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-04-26 00:55:36'),(71,298,2,NULL,NULL,'Mock comment 10 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-03-03 06:48:51'),(72,298,2,NULL,NULL,'Mock comment 11 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-03-27 07:17:25'),(73,298,11,NULL,NULL,'Mock comment 12 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-03-03 16:00:33'),(74,298,20,NULL,NULL,'Mock comment 13 for article 298',0,0,NULL,NULL,NULL,NULL,'2026-04-26 10:10:28'),(75,299,17,NULL,NULL,'Mock comment 1 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-03-31 02:50:49'),(76,299,6,NULL,NULL,'Mock comment 2 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-04-12 07:42:37'),(77,299,20,NULL,NULL,'Mock comment 3 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-04-30 06:00:42'),(78,299,3,NULL,NULL,'Mock comment 4 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-04-22 06:55:42'),(79,299,6,NULL,NULL,'Mock comment 5 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-03-20 16:36:24'),(80,299,16,NULL,NULL,'Mock comment 6 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-03-03 14:14:54'),(81,299,1,NULL,NULL,'Mock comment 7 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-03-15 21:25:20'),(82,299,19,NULL,NULL,'Mock comment 8 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-03-06 16:21:56'),(83,299,9,NULL,NULL,'Mock comment 9 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-04-14 17:33:42'),(84,299,14,NULL,NULL,'Mock comment 10 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-03-24 14:42:44'),(85,299,13,NULL,NULL,'Mock comment 11 for article 299',0,0,NULL,NULL,NULL,NULL,'2026-04-14 20:52:33'),(86,300,15,NULL,NULL,'Mock comment 1 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-04-01 12:14:38'),(87,300,7,NULL,NULL,'Mock comment 2 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-03-23 22:35:30'),(88,300,18,NULL,NULL,'Mock comment 3 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-03-21 04:13:36'),(89,300,12,NULL,NULL,'Mock comment 4 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-04-02 01:21:32'),(90,300,14,NULL,NULL,'Mock comment 5 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-04-08 18:06:53'),(91,300,19,NULL,NULL,'Mock comment 6 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-04-06 14:29:50'),(92,300,2,NULL,NULL,'Mock comment 7 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-03-06 18:08:35'),(93,300,19,NULL,NULL,'Mock comment 8 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-04-10 23:13:23'),(94,300,11,NULL,NULL,'Mock comment 9 for article 300',0,0,NULL,NULL,NULL,NULL,'2026-03-05 13:41:12'),(95,301,12,NULL,NULL,'Mock comment 1 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-03-22 22:45:50'),(96,301,7,NULL,NULL,'Mock comment 2 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-04-05 00:45:36'),(97,301,14,NULL,NULL,'Mock comment 3 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-04-18 07:30:30'),(98,301,7,NULL,NULL,'Mock comment 4 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-03-15 11:15:47'),(99,301,14,NULL,NULL,'Mock comment 5 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-04-19 09:47:21'),(100,301,11,NULL,NULL,'Mock comment 6 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-03-21 15:09:28'),(101,301,8,NULL,NULL,'Mock comment 7 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-03-16 22:25:19'),(102,301,15,NULL,NULL,'Mock comment 8 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-03-18 18:38:11'),(103,301,14,NULL,NULL,'Mock comment 9 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-04-11 01:54:58'),(104,301,7,NULL,NULL,'Mock comment 10 for article 301',0,0,NULL,NULL,NULL,NULL,'2026-03-31 01:40:20'),(105,302,1,NULL,NULL,'Mock comment 1 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-03-28 02:36:45'),(106,302,3,NULL,NULL,'Mock comment 2 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-04-15 08:02:49'),(107,302,6,NULL,NULL,'Mock comment 3 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-03-24 08:23:50'),(108,302,12,NULL,NULL,'Mock comment 4 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-04-11 17:50:44'),(109,302,20,NULL,NULL,'Mock comment 5 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-03-17 16:02:12'),(110,302,2,NULL,NULL,'Mock comment 6 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-03-20 02:38:47'),(111,302,14,NULL,NULL,'Mock comment 7 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-04-15 13:07:21'),(112,302,5,NULL,NULL,'Mock comment 8 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-04-18 09:40:27'),(113,302,7,NULL,NULL,'Mock comment 9 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-04-14 09:00:13'),(114,302,5,NULL,NULL,'Mock comment 10 for article 302',0,0,NULL,NULL,NULL,NULL,'2026-03-16 15:59:45'),(115,303,5,NULL,NULL,'Mock comment 1 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-03-07 04:58:07'),(116,303,13,NULL,NULL,'Mock comment 2 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-15 00:51:18'),(117,303,12,NULL,NULL,'Mock comment 3 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-03-24 13:22:15'),(118,303,16,NULL,NULL,'Mock comment 4 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-13 16:17:19'),(119,303,4,NULL,NULL,'Mock comment 5 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-03-26 17:19:53'),(120,303,9,NULL,NULL,'Mock comment 6 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-28 13:47:26'),(121,303,8,NULL,NULL,'Mock comment 7 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-02 16:57:38'),(122,303,20,NULL,NULL,'Mock comment 8 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-18 19:25:50'),(123,303,13,NULL,NULL,'Mock comment 9 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-03-24 22:16:17'),(124,303,3,NULL,NULL,'Mock comment 10 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-04 05:03:55'),(125,303,6,NULL,NULL,'Mock comment 11 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-08 06:30:47'),(126,303,8,NULL,NULL,'Mock comment 12 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-03-28 17:22:12'),(127,303,18,NULL,NULL,'Mock comment 13 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-03-24 19:18:38'),(128,303,14,NULL,NULL,'Mock comment 14 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-05 20:26:34'),(129,303,9,NULL,NULL,'Mock comment 15 for article 303',0,0,NULL,NULL,NULL,NULL,'2026-04-16 20:16:58'),(130,304,16,NULL,NULL,'Mock comment 1 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-03-05 16:05:13'),(131,304,6,NULL,NULL,'Mock comment 2 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-03-05 19:35:08'),(132,304,16,NULL,NULL,'Mock comment 3 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-03-11 01:40:03'),(133,304,11,NULL,NULL,'Mock comment 4 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-04-05 21:34:51'),(134,304,9,NULL,NULL,'Mock comment 5 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-03-28 06:54:08'),(135,304,4,NULL,NULL,'Mock comment 6 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-03-29 17:46:09'),(136,304,4,NULL,NULL,'Mock comment 7 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-03-01 20:08:22'),(137,304,13,NULL,NULL,'Mock comment 8 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-04-09 23:23:24'),(138,304,17,NULL,NULL,'Mock comment 9 for article 304',0,0,NULL,NULL,NULL,NULL,'2026-03-15 08:31:54'),(139,305,7,NULL,NULL,'Mock comment 1 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-13 20:29:21'),(140,305,2,NULL,NULL,'Mock comment 2 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-22 04:51:00'),(141,305,16,NULL,NULL,'Mock comment 3 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-07 10:47:02'),(142,305,14,NULL,NULL,'Mock comment 4 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-30 15:22:07'),(143,305,20,NULL,NULL,'Mock comment 5 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-07 20:29:32'),(144,305,7,NULL,NULL,'Mock comment 6 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-07 08:21:21'),(145,305,1,NULL,NULL,'Mock comment 7 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-12 04:18:09'),(146,305,2,NULL,NULL,'Mock comment 8 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-04-06 20:26:40'),(147,305,3,NULL,NULL,'Mock comment 9 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-29 17:18:58'),(148,305,7,NULL,NULL,'Mock comment 10 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-04-03 01:14:48'),(149,305,9,NULL,NULL,'Mock comment 11 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-19 02:17:10'),(150,305,9,NULL,NULL,'Mock comment 12 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-04-22 07:41:24'),(151,305,1,NULL,NULL,'Mock comment 13 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-25 07:35:37'),(152,305,7,NULL,NULL,'Mock comment 14 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-03-26 14:53:49'),(153,305,17,NULL,NULL,'Mock comment 15 for article 305',0,0,NULL,NULL,NULL,NULL,'2026-04-25 03:42:15'),(154,306,5,NULL,NULL,'Mock comment 1 for article 306',0,0,NULL,NULL,NULL,NULL,'2026-03-16 21:49:53'),(155,306,9,NULL,NULL,'Mock comment 2 for article 306',0,0,NULL,NULL,NULL,NULL,'2026-04-06 02:02:39'),(156,306,12,NULL,NULL,'Mock comment 3 for article 306',0,0,NULL,NULL,NULL,NULL,'2026-03-11 16:43:36'),(157,306,9,NULL,NULL,'Mock comment 4 for article 306',0,0,NULL,NULL,NULL,NULL,'2026-03-07 05:30:05'),(158,306,7,NULL,NULL,'Mock comment 5 for article 306',0,0,NULL,NULL,NULL,NULL,'2026-04-30 01:19:36'),(159,306,8,NULL,NULL,'Mock comment 6 for article 306',0,0,NULL,NULL,NULL,NULL,'2026-04-07 14:07:50'),(160,306,13,NULL,NULL,'Mock comment 7 for article 306',0,0,NULL,NULL,NULL,NULL,'2026-03-08 18:40:22'),(161,306,14,NULL,NULL,'Mock comment 8 for article 306',0,0,NULL,NULL,NULL,NULL,'2026-04-18 02:58:17'),(163,296,2,NULL,NULL,'期待博主更新更多干货。',5,0,NULL,NULL,NULL,'上海','2026-04-04 06:50:25'),(165,292,1817,20,40,'213123',0,0,'26.125.17.30',NULL,NULL,'伊利诺伊','2026-03-28 01:17:16'),(166,292,1817,NULL,NULL,'哈哈哈哈哈哈哈哈哈哈哈',1,0,'26.125.17.30',NULL,NULL,'伊利诺伊','2026-04-02 09:55:04'),(167,292,1817,1817,166,'牛牛牛牛牛牛牛牛你你你你你',1,0,'26.125.17.30',NULL,NULL,'伊利诺伊','2026-03-20 21:43:35'),(168,292,1820,1817,166,'无语了无语了，毕设过过过',2,0,NULL,NULL,NULL,NULL,'2026-03-03 06:52:43');
/*!40000 ALTER TABLE `sys_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_feedback`
--

DROP TABLE IF EXISTS `sys_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '反馈人id',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '2' COMMENT '反馈类型',
  `content` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '反馈内容',
  `email` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系邮箱',
  `reply_content` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '回复内容',
  `status` int DEFAULT '0' COMMENT '状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `feedback_type` varchar(32) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'function_suggestion' COMMENT '反馈类型',
  PRIMARY KEY (`id`),
  KEY `idx_feedback_type` (`feedback_type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='反馈';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_feedback`
--

LOCK TABLES `sys_feedback` WRITE;
/*!40000 ALTER TABLE `sys_feedback` DISABLE KEYS */;
INSERT INTO `sys_feedback` VALUES (2,1817,'2','1111','111@qq.com',NULL,0,'2026-03-13 17:12:51','function_suggestion'),(3,1820,'2','毕设过了吧，改项目改炸了。改论文要爆炸了','8848@qq.com',NULL,0,'2026-04-26 17:26:06','bug_report');
/*!40000 ALTER TABLE `sys_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_file_oss`
--

DROP TABLE IF EXISTS `sys_file_oss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_file_oss` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '访问域名',
  `access_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'access-key',
  `secret_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'secret-key',
  `bucket` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '空间名',
  `base_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '存储基础路径',
  `platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '存储类型',
  `is_enable` int DEFAULT NULL COMMENT '是否启用存储',
  `storage_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '本地存储路径',
  `enable_access` int DEFAULT NULL COMMENT '本地启用访问',
  `path_patterns` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '本地访问路径',
  `region` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '仓库所在地域',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='存储平台';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_file_oss`
--

LOCK TABLES `sys_file_oss` WRITE;
/*!40000 ALTER TABLE `sys_file_oss` DISABLE KEYS */;
INSERT INTO `sys_file_oss` VALUES (1,'http://127.0.0.1:8800/localFile/','','','','local-plus/','local',1,'E:/桌面/shiyi-blog-master/uploads/',1,'localFile/**',NULL,'2025-02-14 10:52:33');
/*!40000 ALTER TABLE `sys_file_oss` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '上级资源ID',
  `path` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路由路径',
  `component` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组件路径',
  `title` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '菜单名称',
  `sort` int DEFAULT '0' COMMENT '排序',
  `icon` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '资源图标',
  `type` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类型 menu、button',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `redirect` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '重定向地址',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '跳转地址',
  `hidden` int DEFAULT NULL COMMENT '是否隐藏',
  `perm` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '权限标识',
  `is_external` int DEFAULT '0' COMMENT '是否外链 0:否  1:是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='权限资源表 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'0','/system','Layout','系统管理',4,'Setting','CATALOG','2019-03-28 18:51:08','2021-12-17 15:26:06','/system/user','',0,NULL,0),(2,'1','role','/system/role/index','角色管理',2,'Avatar','MENU','2019-03-30 14:00:03','2021-11-16 15:40:42','','',0,NULL,0),(3,'2',NULL,NULL,'角色列表',1,'','BUTTON',NULL,'2024-11-18 17:56:16','',NULL,1,'system:role',0),(8,'2','','','新增角色',1,'','BUTTON',NULL,'2024-11-21 22:16:56',NULL,'',1,'sys:role:add',0),(14,'1','user','/system/user/index','用户管理',1,'User','MENU','2024-11-18 01:10:52','2024-11-18 01:11:13',NULL,'',0,'',0),(27,'14','','','新增用户',2,'','BUTTON','2024-11-18 09:18:14','2024-11-21 22:15:30',NULL,'',1,'sys:user:add',0),(28,'14','','','编辑用户',2,'','BUTTON','2024-11-18 09:18:38','2024-11-21 14:38:56',NULL,'',1,'sys:user:update',0),(29,'14','','','删除用户',3,'','BUTTON','2024-11-18 09:18:53','2024-11-21 22:15:43',NULL,'',1,'sys:user:delete',0),(30,'0','/tool','Layout','系统工具',6,'Suitcase','CATALOG','2024-11-18 09:21:10','2024-11-18 12:23:55','/tool/gen','',0,'',0),(31,'30','gen','/tool/gen/index','代码生成',1,'Compass','MENU','2024-11-18 09:21:52',NULL,NULL,'',0,'',0),(33,'1','operation','/system/log/operation/index','操作日志',1,'CircleCheckFilled','MENU','2024-11-18 10:53:10','2024-11-18 11:05:22',NULL,'',0,'',0),(34,'0','http://localhost:3001/','Layout','回到主页',99,'HomeFilled','CATALOG','2024-11-18 11:25:10','2024-11-18 11:43:25',NULL,'',0,'',1),(39,'14','','','用户列表',1,'','BUTTON','2024-11-18 17:54:15','2024-11-21 22:07:33','','',0,'sys:user',0),(40,'2','','','修改角色',2,'','BUTTON','2024-11-18 17:56:10','2024-11-21 22:04:52','','',1,'sys:role:update',0),(41,'2','','','删除角色',3,'','BUTTON','2024-11-18 17:56:34','2024-11-21 22:17:17','',NULL,1,'sys:role:delete',0),(43,'2','','','分配权限',5,'','BUTTON','2024-11-18 17:57:28',NULL,'',NULL,1,'sys:role:menus',0),(52,'14','','','重置密码',5,'','BUTTON','2024-11-21 22:00:30',NULL,'','',1,'sys:user:reset',0),(54,'1','profile','/system/user/profile/index','个人中心',99,'Avatar','MENU','2024-11-21 22:12:18','2024-11-21 22:12:46','','',1,'',0),(55,'33','','','操作日志列表',1,'','BUTTON','2024-11-18 10:53:10','2024-11-18 11:05:22','','',1,'sys:operateLog',0),(56,'33','','','删除操作日志',2,'','BUTTON','2024-11-18 10:53:10','2024-11-18 11:05:22','','',1,'sys:operateLog:delete',0),(68,'0','/article','Layout','文章管理',1,'Document','CATALOG','2024-12-22 10:49:22','2024-12-22 10:49:37','/article/index','',0,'',0),(69,'68','tag','/article/tag/index','标签管理',2,'PriceTag','MENU','2024-12-22 10:49:22','2024-12-22 10:49:37','','',0,'',0),(70,'68','category','/article/category/index','分类管理',2,'Dessert','MENU','2024-12-22 10:49:22','2024-12-22 10:49:37','','',0,'',0),(71,'68','index','/article/article/index','文章管理',1,'DocumentRemove','MENU','2024-12-25 13:47:27',NULL,'','',0,'',0),(72,'0','/site','Layout','站点管理',2,'DeleteLocation','CATALOG','2024-12-25 16:13:03','2024-12-25 16:13:33','/site/config','',0,'',0),(74,'72','config','/site/config/index','网站配置',1,'AddLocation','MENU','2024-12-25 16:35:39',NULL,'','',0,'',0),(75,'71','','','文章列表',1,'','BUTTON','2024-12-28 22:02:24',NULL,'','',1,'sys:article:list',0),(76,'71','','','新增文章',2,'','BUTTON','2024-12-28 22:02:24',NULL,'','',1,'sys:article:add',0),(77,'71','','','修改文章',3,'','BUTTON','2024-12-28 22:02:24',NULL,'','',1,'sys:article:update',0),(78,'71','','','修改状态',4,'','BUTTON','2024-12-28 22:02:24',NULL,'','',1,'sys:article:updateStatus',0),(79,'71','','','删除文章',2,'','BUTTON','2024-12-28 22:02:24',NULL,'','',1,'sys:article:delete',0),(80,'69','','','标签列表',1,'','BUTTON','2024-12-28 22:05:25',NULL,'','',1,'sys:tag:list',0),(81,'69','','','新增标签',2,'','BUTTON','2024-12-28 22:05:59',NULL,'','',1,'sys:tag:add',0),(82,'69','','','修改标签',3,'','BUTTON','2024-12-28 22:06:26',NULL,'','',1,'sys:tag:update',0),(83,'69','','','删除标签',4,'','BUTTON','2024-12-28 22:06:40',NULL,'','',1,'sys:tag:delete',0),(84,'70','','','分类列表',1,'','BUTTON','2024-12-28 22:07:27',NULL,'','',1,'sys:category:list',0),(85,'70','','','新增分类',2,'','BUTTON','2024-12-28 22:07:40',NULL,'','',1,'sys:category:add',0),(86,'70','','','修改分类',3,'','BUTTON','2024-12-28 22:07:58',NULL,'','',1,'sys:category:update',0),(87,'70','','','删除分类',4,'','BUTTON','2024-12-28 22:08:11',NULL,'','',1,'sys:category:delete',0),(88,'74','','','网站列表',1,'','BUTTON','2024-12-28 22:09:06',NULL,'','',1,'sys:web:config',0),(89,'74','','','修改配置',2,'','BUTTON','2024-12-28 22:09:21',NULL,'','',1,'sys:web:update',0),(96,'0','/message','Layout','消息管理',3,'ChatDotSquare','CATALOG','2025-01-02 09:49:06',NULL,'','',0,'',0),(97,'96','comment','/message/comment/index','评论管理',1,'ChatDotRound','MENU','2024-12-22 10:49:22','2024-12-22 10:49:37','','',0,'',0),(98,'97','','','评论列表',1,'','BUTTON','2025-01-02 09:58:33',NULL,'','',1,'sys:comment:list',0),(99,'97','','','删除评论',2,'','BUTTON','2025-01-02 09:58:50',NULL,'','',1,'sys:comment:delete',0),(100,'96','message','/message/message/index','留言管理',2,'ChatLineSquare','MENU','2025-01-02 10:07:04',NULL,'','',0,'',0),(101,'100','','','留言列表',1,'','BUTTON','2025-01-02 10:12:14',NULL,'','',1,'sys:message:list',0),(102,'100','','','删除留言',2,'','BUTTON','2025-01-02 10:22:06',NULL,'','',1,'sys:message:delete',0),(106,'96','feedback','/message/feedback/index','反馈管理',3,'Checked','MENU','2025-01-12 11:23:23',NULL,'','',0,'',0),(107,'106','','','列表',1,'','BUTTON','2025-01-12 12:30:48','2025-01-12 12:31:51','','',1,'sys:feedback:list',0),(108,'106','','','修改',2,'','BUTTON','2025-01-12 12:31:00','2025-01-12 12:31:55','','',1,'sys:feedback:update',0),(109,'106','','','删除',3,'','BUTTON','2025-01-12 12:31:14','2025-01-12 12:31:19','','',1,'sys:feedback:delete',0),(110,'68','/moments','/article/moment/index','说说管理',4,'ChatDotRound','MENU','2025-02-06 10:22:22',NULL,'','',0,'',0),(111,'110','','','新增',1,'','BUTTON','2025-02-06 10:32:06',NULL,'','',1,'sys:moment:add',0),(112,'110','','','修改',2,'','BUTTON','2025-02-06 10:32:20',NULL,'','',1,'sys:moment:update',0),(113,'110','','','删除',3,'','BUTTON','2025-02-06 10:32:37',NULL,'','',1,'sys:moment:delete',0),(114,'72','/gallery','/site/gallery/index','图库管理',1,'CreditCard','MENU','2025-02-07 10:49:51','2025-02-07 10:50:23','','',0,'',0),(115,'114','','','列表',1,'','BUTTON','2025-02-07 15:08:50',NULL,'','',1,'sys:album:list',0),(116,'114','','','新增',2,'','BUTTON','2025-02-07 15:09:03',NULL,'','',1,'sys:album:add',0),(117,'114','','','修改',3,'','BUTTON','2025-02-07 15:09:30',NULL,'','',1,'sys:album:update',0),(118,'114','','','删除',4,'','BUTTON','2025-02-07 15:09:53',NULL,'','',1,'sys:album:delete',0),(119,'114','','','新增照片',5,'','BUTTON','2025-02-07 15:10:39',NULL,'','',1,'sys:photo:add',0),(120,'114','','','修改照片',6,'','BUTTON','2025-02-07 15:10:55',NULL,'','',1,'sys:photo:update',0),(121,'114','','','删除照片',7,'','BUTTON','2025-02-07 15:11:18',NULL,'','',1,'sys:photo:delete',0),(122,'114','','','移动照片',8,'','BUTTON','2025-02-07 15:11:38',NULL,'','',1,'sys:photo:move',0),(123,'72','/notice','/site/notice/index','公告管理',4,'AlarmClock','MENU','2024-12-25 16:13:03','2024-12-25 16:13:33','','',0,'',0),(124,'123','','','列表',1,'','BUTTON','2025-02-11 16:32:27',NULL,'','',1,'sys:notice:list',0),(125,'123','','','新增',2,'','BUTTON','2025-02-11 16:32:37',NULL,'','',1,'sys:notice:add',0),(126,'123','','','修改',3,'','BUTTON','2025-02-11 16:32:49',NULL,'','',0,'sys:notice:update',0),(127,'123','','','删除',4,'','BUTTON','2025-02-11 16:33:01',NULL,'','',1,'sys:notice:delete',0),(141,'72','/author','/site/author/index','作者信息管理',3,'UserFilled','MENU','2026-03-18 16:46:48',NULL,NULL,NULL,0,'',0),(142,'141','','','列表',1,'','BUTTON','2026-03-18 16:47:04',NULL,NULL,NULL,1,'sys:author:list',0),(143,'141','','','添加',2,'','BUTTON','2026-03-18 16:47:15',NULL,NULL,NULL,1,'sys:author:add',0),(144,'141','','','修改',3,'','BUTTON','2026-03-18 16:47:27',NULL,NULL,NULL,1,'sys:author:update',0),(145,'141','','','删除',4,'','BUTTON','2026-03-18 16:51:08',NULL,NULL,NULL,1,'sys:author:delete',0),(147,'33','','','导出操作日志',0,NULL,'BUTTON','2026-05-12 17:19:01','2026-05-12 17:19:01',NULL,NULL,NULL,'sys:operateLog:export',0),(148,'100','','','发送留言',0,NULL,'BUTTON','2026-05-12 17:19:01','2026-05-12 17:19:01',NULL,NULL,NULL,'sys:message:send',0),(149,'72','resource','site/resource/index','资源管理',0,'Folder','MENU','2026-05-12 17:19:14','2026-05-12 17:19:14',NULL,NULL,NULL,NULL,0),(150,'149',NULL,NULL,'列表',0,NULL,'BUTTON','2026-05-12 17:19:34','2026-05-12 17:19:34',NULL,NULL,NULL,'sys:resource:list',0),(151,'149',NULL,NULL,'新增',0,NULL,'BUTTON','2026-05-12 17:19:34','2026-05-12 17:19:34',NULL,NULL,NULL,'sys:resource:add',0),(152,'149',NULL,NULL,'修改',0,NULL,'BUTTON','2026-05-12 17:19:34','2026-05-12 17:19:34',NULL,NULL,NULL,'sys:resource:update',0),(153,'149',NULL,NULL,'删除',0,NULL,'BUTTON','2026-05-12 17:19:34','2026-05-12 17:19:34',NULL,NULL,NULL,'sys:resource:delete',0);
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_message`
--

DROP TABLE IF EXISTS `sys_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_message` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `nickname` varchar(255) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `content` varchar(255) DEFAULT NULL COMMENT '内容',
  `ip` varchar(255) DEFAULT NULL COMMENT 'IP地址',
  `source` varchar(255) DEFAULT NULL COMMENT 'IP来源',
  `browser` varchar(50) DEFAULT NULL COMMENT '浏览器',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `like_count` int DEFAULT '0' COMMENT '点赞数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1424 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='留言';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_message`
--

LOCK TABLES `sys_message` WRITE;
/*!40000 ALTER TABLE `sys_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_moment`
--

DROP TABLE IF EXISTS `sys_moment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_moment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint DEFAULT NULL COMMENT '用户id',
  `content` mediumtext COMMENT '文章内容',
  `images` mediumtext COMMENT '图片',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `like_count` int DEFAULT '0' COMMENT '点赞数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='说说';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_moment`
--

LOCK TABLES `sys_moment` WRITE;
/*!40000 ALTER TABLE `sys_moment` DISABLE KEYS */;
INSERT INTO `sys_moment` VALUES (2,1,'<p>这是一条测试说说?</p>','http://127.0.0.1:8800/localFile/local-plus/20260512/moment/94_v2-2068949461853f29e6c9becba3cbe4f7_1440w.jpg','2026-03-21 05:21:46',2);
/*!40000 ALTER TABLE `sys_moment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content` mediumtext COMMENT '公告内容',
  `is_show` int DEFAULT NULL COMMENT '是否展示',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `title` varchar(255) DEFAULT NULL COMMENT '公告标题',
  `url` varchar(255) DEFAULT NULL COMMENT '跳转链接',
  `sort` int DEFAULT '0' COMMENT '排序优先级',
  `duration` bigint DEFAULT NULL COMMENT '显示时长(毫秒)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='公告';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (2,'【系统公告】公告功能链路测试中：该文本将用于前台滚动展示。',0,'2026-04-05 16:12:48','系统测试公告','',0,8000),(3,'这条公告也用来测试公告是否启正常',0,'2026-04-26 16:58:44','这条公告也用来测试公告是否启正常','',0,5000),(4,'无',1,'2026-04-24 12:15:19','【测试公告】这台公告用于测试公告是否正常！！','https://www.deepseek.com/',0,5000);
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notifications`
--

DROP TABLE IF EXISTS `sys_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notifications` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知的唯一标识，自增主键',
  `user_id` bigint DEFAULT NULL COMMENT '推送用户id',
  `from_user_id` bigint DEFAULT NULL COMMENT '来自用户id,如评论就存评论的用户id',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知的类型，如 system、comment、like 等',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知的标题',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知的具体内容',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '标记通知是否已读，0 表示未读，1 表示已读',
  `article_id` bigint DEFAULT NULL COMMENT '文章id',
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跳转链接',
  `create_time` datetime NOT NULL COMMENT '通知的创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='消息通知表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notifications`
--

LOCK TABLES `sys_notifications` WRITE;
/*!40000 ALTER TABLE `sys_notifications` DISABLE KEYS */;
INSERT INTO `sys_notifications` VALUES (1,20,1817,'comment','评论回复通知','213123',0,292,NULL,'2026-04-24 22:09:27'),(2,1,1817,'comment','新评论通知','哈哈哈哈哈哈哈哈哈哈哈',0,292,NULL,'2026-04-24 22:14:06'),(3,1817,1817,'comment','评论回复通知','牛牛牛牛牛牛牛牛你你你你你',0,292,NULL,'2026-04-24 22:14:19'),(4,1,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',0,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(5,1811,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',0,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(6,1812,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',0,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(7,1813,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',0,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(8,1814,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',1,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(9,1815,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',0,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(10,1816,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',0,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(11,1817,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',0,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(12,1818,1,'system','系统功能测试通知','这是一条用于测试已读/未读功能的系统消息，请在消息中心将其标记为已读进行验证。',0,NULL,'/notifications?type=system','2026-04-25 11:18:39'),(19,1814,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',1,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(20,1815,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',0,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(21,1816,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',0,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(22,1,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',0,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(23,1817,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',0,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(24,1818,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',0,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(25,1811,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',0,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(26,1812,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',0,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(27,1813,1,'system','系统功能测试通知（全量）','这是一条给全部账号的系统测试消息：请在消息中心验证未读->已读。',0,NULL,'/notifications?type=system','2026-04-25 11:19:30'),(28,1817,1820,'comment','评论回复通知','无语了无语了，毕设过过过',0,292,NULL,'2026-05-11 18:10:32'),(29,1820,1,'like','点赞','有人点赞了您的文章！',1,NULL,NULL,'2026-05-13 00:06:45'),(30,1820,1,'reply','回复','有人回复了您的评论！',1,NULL,NULL,'2026-05-12 23:06:45'),(31,1820,1,'feedback','反馈','您的反馈已经处理，感谢您的反馈。',1,NULL,NULL,'2026-05-12 22:06:45'),(32,1820,1,'update','更新','您收藏的《测试文章》更新了，快去查看吧',1,NULL,NULL,'2026-05-12 21:06:45'),(34,1820,1,'article','新文章','网站发布了新的文章《测试文章》，快去看看吧',1,NULL,NULL,'2026-05-12 19:06:45'),(36,1820,1,'like','点赞','有人点赞了您的文章！',1,NULL,NULL,'2026-05-13 00:08:46'),(37,1820,2,'reply','回复','有人回复了您的评论！',1,NULL,NULL,'2026-05-13 00:08:46'),(38,1820,1,'feedback','反馈','您的反馈已经处理，感谢您的反馈。',1,NULL,NULL,'2026-05-13 00:08:46'),(39,1820,3,'update','更新','您收藏的《测试文章》更新了，快去查看吧',1,NULL,NULL,'2026-05-13 00:08:46'),(41,1820,4,'article','新文章','网站发布了新的文章《测试文章》，快去看看吧',1,NULL,NULL,'2026-05-13 00:08:46');
/*!40000 ALTER TABLE `sys_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_operate_log`
--

DROP TABLE IF EXISTS `sys_operate_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_operate_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作用户',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求接口',
  `ua` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'User-Agent',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求方式',
  `operation_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作名称',
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ip',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ip来源',
  `spend_time` bigint DEFAULT NULL COMMENT '请求接口耗时',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `params_json` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求参数',
  `class_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类地址',
  `method_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '方法名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2256 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_operate_log`
--

LOCK TABLES `sys_operate_log` WRITE;
/*!40000 ALTER TABLE `sys_operate_log` DISABLE KEYS */;
INSERT INTO `sys_operate_log` VALUES (2249,'admin','/sys/user/delete/1812,1813','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0','DELETE','批量删除用户','127.0.0.1','内网IP|内网IP',54,'2026-05-11 17:53:14','{\"ids\":[1812,1813]}','com.mojian.controller.system.SysUserController','delete'),(2250,'admin','/sys/user/delete/1819','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0','DELETE','批量删除用户','127.0.0.1','内网IP|内网IP',6,'2026-05-11 17:53:32','{\"ids\":[1819]}','com.mojian.controller.system.SysUserController','delete'),(2251,'admin','/sys/user/delete/1811','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0','DELETE','批量删除用户','127.0.0.1','内网IP|内网IP',10,'2026-05-11 17:53:37','{\"ids\":[1811]}','com.mojian.controller.system.SysUserController','delete'),(2252,'admin','/sys/user/delete/1815,1816','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0','DELETE','批量删除用户','127.0.0.1','内网IP|内网IP',10,'2026-05-11 17:53:42','{\"ids\":[1815,1816]}','com.mojian.controller.system.SysUserController','delete'),(2253,'admin','/sys/user/delete/1818','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0','DELETE','批量删除用户','127.0.0.1','内网IP|内网IP',11,'2026-05-11 17:57:36','{\"ids\":[1818]}','com.mojian.controller.system.SysUserController','delete'),(2254,'admin','/sys/role/menus/15','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0','PUT','修改角色权限','127.0.0.1','内网IP|内网IP',5,'2026-05-11 18:33:46','{\"id\":15,\"menuIds\":[]}','com.mojian.controller.system.SysRoleController','updateRoleMenus'),(2255,'admin','/sys/menu/','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0','PUT','修改菜单','127.0.0.1','内网IP|内网IP',88,'2026-05-12 17:03:54','{\"menu\":{\"id\":39,\"parentId\":14,\"path\":\"\",\"component\":\"\",\"title\":\"用户列表\",\"sort\":1,\"icon\":\"\",\"type\":\"BUTTON\",\"redirect\":\"\",\"name\":\"\",\"hidden\":0,\"isExternal\":0,\"perm\":\"sys:user\",\"createTime\":1731923655000,\"updateTime\":1732198053000}}','com.mojian.controller.system.SysMenuController','updateMenu');
/*!40000 ALTER TABLE `sys_operate_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_photo`
--

DROP TABLE IF EXISTS `sys_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_photo` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `album_id` bigint NOT NULL COMMENT '相册id',
  `description` varchar(64) DEFAULT NULL COMMENT '图片描述',
  `url` varchar(255) DEFAULT NULL COMMENT '图片地址',
  `record_time` date DEFAULT NULL COMMENT '记录时间',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='照片';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_photo`
--

LOCK TABLES `sys_photo` WRITE;
/*!40000 ALTER TABLE `sys_photo` DISABLE KEYS */;
INSERT INTO `sys_photo` VALUES (2,1,'test-image-1.jpg','http://127.0.0.1:8800/localFile/test-image-1.jpg',NULL,NULL,'2026-04-11 10:20:25');
/*!40000 ALTER TABLE `sys_photo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_resource`
--

DROP TABLE IF EXISTS `sys_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_resource` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '资源名',
  `category` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类',
  `downloads` int DEFAULT NULL COMMENT '下载量',
  `is_free` int DEFAULT NULL COMMENT '是否免费',
  `pay_type` int DEFAULT NULL COMMENT '付费方式',
  `pan_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网盘地址',
  `pan_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '网盘验证码',
  `status` int DEFAULT NULL COMMENT '状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='资源表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_resource`
--

LOCK TABLES `sys_resource` WRITE;
/*!40000 ALTER TABLE `sys_resource` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '角色名称',
  `remarks` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '角色描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='角色表 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','拥有一切权限\n','2024-11-16 12:29:00','2024-11-16 12:29:00'),(14,'演示账号','仅提供演示用，所有按钮权限可看到但不能操作','2024-11-21 22:59:30','2024-11-21 22:59:29'),(15,'用户','门户注册的用户','2024-12-28 13:32:09','2024-12-28 13:32:08');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int DEFAULT NULL COMMENT '角色ID',
  `menu_id` int DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `role_id` (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=486 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='角色-权限资源关联表 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (400,1,1),(401,1,2),(402,1,3),(403,1,8),(404,1,13),(405,1,14),(406,1,27),(407,1,28),(408,1,29),(409,1,30),(410,1,31),(411,1,33),(412,1,34),(413,1,39),(414,1,40),(415,1,41),(416,1,43),(417,1,48),(418,1,49),(419,1,50),(420,1,51),(421,1,52),(422,1,54),(423,1,55),(424,1,56),(425,1,68),(426,1,69),(427,1,70),(428,1,71),(429,1,72),(430,1,74),(431,1,75),(432,1,76),(433,1,77),(434,1,78),(435,1,79),(436,1,80),(437,1,81),(438,1,82),(439,1,83),(440,1,84),(441,1,85),(442,1,86),(443,1,87),(444,1,88),(445,1,89),(446,1,96),(447,1,97),(448,1,98),(449,1,99),(450,1,100),(451,1,101),(452,1,102),(453,1,106),(454,1,107),(455,1,108),(456,1,109),(457,1,110),(458,1,111),(459,1,112),(460,1,113),(461,1,114),(462,1,115),(463,1,116),(464,1,117),(465,1,118),(466,1,119),(467,1,120),(468,1,121),(469,1,122),(470,1,123),(471,1,124),(472,1,125),(473,1,126),(474,1,127),(475,1,128),(476,1,129),(477,1,130),(478,1,131),(394,1,141),(395,1,142),(396,1,143),(397,1,144),(398,1,145),(399,1,146),(479,1,147),(480,1,148),(481,1,149),(482,1,150),(483,1,151),(484,1,152),(485,1,153),(28,2,1),(29,2,2),(26,2,6),(30,2,8),(370,14,1),(373,14,2),(374,14,3),(380,14,13),(371,14,14),(377,14,32),(378,14,33),(393,14,34),(372,14,39),(381,14,51),(382,14,54),(379,14,55),(353,14,68),(358,14,69),(356,14,70),(354,14,71),(360,14,72),(361,14,74),(355,14,75),(359,14,80),(357,14,84),(362,14,88),(365,14,96),(366,14,97),(367,14,98),(368,14,100),(369,14,101);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_slide`
--

DROP TABLE IF EXISTS `sys_slide`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_slide` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image_url` varchar(255) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `position` int DEFAULT '0',
  `status` tinyint DEFAULT '1' COMMENT '1:online, 0:offline',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_slide`
--

LOCK TABLES `sys_slide` WRITE;
/*!40000 ALTER TABLE `sys_slide` DISABLE KEYS */;
INSERT INTO `sys_slide` VALUES (1,'https://picsum.photos/1080/400?random=1','Welcome to Blog','/',1,1,'2026-04-13 14:56:06','2026-05-12 21:55:24'),(2,'https://picsum.photos/1080/400?random=2','Beautiful Scenery','/',2,1,'2026-04-02 19:39:20','2026-05-12 21:55:24'),(3,'https://picsum.photos/1080/400?random=3','Technology and Life','/',3,1,'2026-04-03 05:28:21','2026-05-12 21:55:24');
/*!40000 ALTER TABLE `sys_slide` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_tag`
--

DROP TABLE IF EXISTS `sys_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tag` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(200) DEFAULT NULL COMMENT '名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='标签表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_tag`
--

LOCK TABLES `sys_tag` WRITE;
/*!40000 ALTER TABLE `sys_tag` DISABLE KEYS */;
INSERT INTO `sys_tag` VALUES (1,'Spring Boot','2026-03-07 16:23:46','2023-06-05 03:00:00'),(2,'Elasticsearch','2026-04-25 17:33:47','2023-06-05 03:00:00'),(10,'博客','2026-03-15 14:37:42','2023-06-05 03:00:00'),(12,'Vue','2026-03-28 20:27:06','2023-06-05 03:00:00'),(13,'Spring Cloud','2026-04-04 10:22:26','2023-06-05 03:00:00'),(17,'Redis','2026-03-28 14:30:53','2023-06-05 03:00:00'),(18,'Linux','2026-04-04 17:27:08','2023-06-05 03:00:00'),(31,'Mysql','2026-03-30 19:43:03','2023-06-05 03:00:00'),(32,'Nginx','2026-04-14 22:13:52','2023-06-05 03:00:00'),(51,'异步','2026-03-14 04:00:14','2023-06-05 03:00:00'),(57,'Java Script','2026-04-23 01:19:32','2023-06-27 08:02:32'),(59,'Dcoker','2026-04-12 18:37:03','2023-07-13 07:51:12'),(60,'Aspect','2026-04-24 17:06:37','2023-07-25 09:07:18'),(62,'oauth2','2026-03-24 05:42:00','2023-08-15 01:30:11'),(63,'服务器','2026-03-14 01:10:08','2023-09-05 09:28:07'),(65,'Css','2026-04-26 12:44:38','2023-09-25 03:18:59'),(66,'Java','2026-04-30 12:12:51','2023-10-07 01:28:50'),(67,'Juc','2026-03-11 22:50:25','2023-10-07 01:28:54'),(69,'高并发','2026-04-26 05:33:30','2023-10-07 01:29:11'),(70,'资源','2026-03-05 07:16:21','2023-10-12 02:46:34'),(71,'websoket','2026-04-05 19:41:10','2023-12-14 09:17:58'),(72,'uniapp','2026-04-14 04:36:48','2023-12-26 03:28:20'),(73,'宝塔','2026-04-22 12:00:35','2024-02-19 08:17:29'),(89,'vite','2026-03-08 22:12:34','2024-04-12 11:49:22'),(90,'electron','2026-03-05 03:01:01','2024-04-17 16:08:46'),(100,'Vue.js','2026-04-27 20:27:22','2026-03-12 15:08:50'),(101,'Docker','2026-04-02 21:13:54','2026-03-12 15:08:50');
/*!40000 ALTER TABLE `sys_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '账号',
  `password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '登录密码',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` int DEFAULT '1' COMMENT '状态 0:禁用 1:正常',
  `ip` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ip地址',
  `ip_location` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ip来源',
  `os` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '登录系统',
  `last_login_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '最后登录时间',
  `browser` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '浏览器',
  `nickname` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '头像',
  `mobile` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '手机号',
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `security_code` varchar(16) DEFAULT NULL COMMENT '安全码',
  `signature` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '个性签名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1821 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'admin','$2a$10$GSHv.XwqBkizplz5j2pcmu73IRY2rgtxCYQwAvSXMvu9SryzydLpe','2026-04-21 20:47:21','2026-04-22 12:00:23',1,'127.0.0.1','内网IP|内网IP','Windows','2026-05-13 17:18:24','Chrome','管理员','/avatar/blogger.jpg','',NULL,NULL,NULL),(1814,'1111@qq.com','$2a$10$o7ZZr0WXSpemm6JLchBDFO/x6W1FzwKCsTegSvXTAbw0zs9/wHUYW','2026-04-07 18:53:37','2026-04-07 23:34:38',1,'26.125.17.30','美国|伊利诺伊','Windows','2026-04-25 14:56:21','Chrome','test','https://api.dicebear.com/6.x/pixel-art/svg?seed=Kitty',NULL,'1111@qq.com','0000','测试呢'),(1817,'admin@qq.com','$2a$10$MGaT3gD6.Pn2IXDpASviwORDE1LvrEtzmuGuKCJZDfpZUL90EuP8.','2026-03-08 03:52:48','2026-03-08 03:55:01',1,'26.125.17.30','美国|伊利诺伊','Windows','2026-04-24 16:32:17','Chrome','西伯利亚测试','http://127.0.0.1:8800/localFile/local-plus/20260425/avatar/83_avatar.jpg',NULL,'admin@qq.com',NULL,NULL),(1820,'10086@qq.com','$2a$10$DORmuiikAI/dh3SlrA23U.HVrXh7EQaHfb8CL0WPTMy.ajALdl1bO','2026-04-09 23:40:37','2026-04-10 06:13:39',1,'26.125.17.30','美国|伊利诺伊','Windows','2026-05-12 19:31:31','Chrome','这还是一个测试用户','https://api.dicebear.com/6.x/pixel-art/svg?seed=Puppy',NULL,'10086@qq.com','1111',NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_article_history`
--

DROP TABLE IF EXISTS `sys_user_article_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_article_history` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '涓婚敭',
  `user_id` int NOT NULL COMMENT '鐢ㄦ埛id',
  `article_id` int NOT NULL COMMENT '鏂囩珷id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '鏇存柊鏃堕棿',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_article` (`user_id`,`article_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='鐢ㄦ埛娴忚?鍘嗗彶琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_article_history`
--

LOCK TABLES `sys_user_article_history` WRITE;
/*!40000 ALTER TABLE `sys_user_article_history` DISABLE KEYS */;
INSERT INTO `sys_user_article_history` VALUES (1,1,292,'2026-03-29 20:45:59','2026-03-29 20:49:58'),(13,1814,292,'2026-04-24 16:12:17','2026-04-24 16:19:26'),(17,1817,292,'2026-04-24 17:13:26','2026-04-25 11:26:18'),(91,1820,292,'2026-05-11 18:06:05','2026-05-11 18:46:38'),(94,1820,300,'2026-05-11 18:15:27','2026-05-11 18:15:28'),(106,1,307,'2026-05-12 13:22:21','2026-05-12 13:22:21'),(109,1,304,'2026-05-15 00:18:12','2026-05-15 00:18:12');
/*!40000 ALTER TABLE `sys_user_article_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int DEFAULT NULL COMMENT '角色ID',
  `user_id` int DEFAULT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC COMMENT='系统管理 - 用户角色关联表 ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1,1),(42,14,9),(44,14,1810),(46,15,1814),(49,15,1817),(52,15,1820);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_sign`
--

DROP TABLE IF EXISTS `sys_user_sign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_sign` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '??',
  `user_id` varchar(64) NOT NULL COMMENT '??ID',
  `sign_date` date NOT NULL COMMENT '????',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_date` (`user_id`,`sign_date`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='???????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_sign`
--

LOCK TABLES `sys_user_sign` WRITE;
/*!40000 ALTER TABLE `sys_user_sign` DISABLE KEYS */;
INSERT INTO `sys_user_sign` VALUES (1,'1814','2026-04-17','2026-04-17 17:38:15'),(2,'1814','2026-04-24','2026-04-24 16:12:58'),(3,'1817','2026-04-24','2026-04-24 19:26:09'),(7,'1814','2026-04-25','2026-04-25 15:04:39'),(8,'1820','2026-05-13','2026-05-13 15:37:54');
/*!40000 ALTER TABLE `sys_user_sign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_web_config`
--

DROP TABLE IF EXISTS `sys_web_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_web_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `logo` varchar(255) NOT NULL COMMENT 'logo(文件UID)',
  `name` varchar(100) NOT NULL COMMENT '网站名称',
  `summary` varchar(255) NOT NULL COMMENT '介绍',
  `web_url` varchar(255) DEFAULT NULL COMMENT '网站地址',
  `author` varchar(100) NOT NULL COMMENT '作者',
  `author_info` varchar(100) DEFAULT NULL COMMENT '个性签名',
  `author_avatar` varchar(255) DEFAULT NULL COMMENT '作者头像',
  `github` varchar(255) DEFAULT NULL COMMENT 'github地址',
  `gitee` varchar(255) DEFAULT NULL COMMENT 'gitee地址',
  `qq_number` varchar(20) DEFAULT NULL COMMENT 'QQ号',
  `qq_group` varchar(50) DEFAULT NULL COMMENT 'QQ群',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `wechat` varchar(100) DEFAULT NULL COMMENT '微信',
  `show_list` varchar(255) DEFAULT NULL COMMENT '显示的列表（用于控制邮箱、QQ、QQ群、Github、Gitee、微信是否显示在前端）',
  `login_type_list` varchar(255) DEFAULT NULL COMMENT '登录方式列表（用于控制前端登录方式，如账号密码,码云,Github,QQ,微信）',
  `open_comment` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否开启评论(0:否 1:是)',
  `open_admiration` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否开启赞赏(0:否， 1:是)',
  `tourist_avatar` varchar(255) DEFAULT NULL COMMENT '游客头像',
  `bulletin` varchar(255) DEFAULT NULL COMMENT '公告',
  `about_me` mediumtext COMMENT '关于我',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `open_lantern` int DEFAULT NULL COMMENT '开启灯笼',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='网站配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_web_config`
--

LOCK TABLES `sys_web_config` WRITE;
/*!40000 ALTER TABLE `sys_web_config` DISABLE KEYS */;
INSERT INTO `sys_web_config` VALUES (1,'/avatar/blogger.jpg','习习中博客','一个专注于技术分享的博客平台','null','习习中','彻底疯狂','','https://github.com/quequnlong','https://gitee.com/quequnlong','1248954763','779881756','1248954763@qq.com','1248954763','[\"qq\",\"wechat\",\"gitee\",\"qqGroup\",\"github\",\"email\"]','[\"gitee\",\"qq\",\"wechat\"]',1,1,'','有没有在长沙内推的小伙伴，卑微博主在线求职了，有的话<span style=\"color:red\">VX：1248954763</span> 联系博主','<p>西伯利亚系统气不气</p>','2024-12-22 11:55:25','2024-12-22 11:55:25',0);
/*!40000 ALTER TABLE `sys_web_config` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-15  3:42:55
