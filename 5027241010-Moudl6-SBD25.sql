-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 19, 2025 at 04:29 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `c010_frd`
--

-- --------------------------------------------------------

--
-- Table structure for table `blogcategories`
--

CREATE TABLE `blogcategories` (
  `CATEGORY_ID` int(11) NOT NULL,
  `CATEGORY_NAME` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blogcategories`
--

INSERT INTO `blogcategories` (`CATEGORY_ID`, `CATEGORY_NAME`) VALUES
(102, 'Lifestyle'),
(103, 'Sports'),
(101, 'Technology'),
(104, 'Tutorial');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `COMMENT_ID` int(11) NOT NULL,
  `POST_ID` int(11) DEFAULT NULL,
  `USER_ID` int(11) DEFAULT NULL,
  `KONTEN_COMMENT` varchar(50) DEFAULT NULL,
  `COMMENT_DATE` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`COMMENT_ID`, `POST_ID`, `USER_ID`, `KONTEN_COMMENT`, `COMMENT_DATE`) VALUES
(10001, 1001, 2, 'Reviewnya kerenn!', '2025-04-27 08:12:31'),
(10002, 1002, 1, 'MasyaAllah sangat bermanfaat, materi full daging!', '2025-04-25 11:12:13'),
(10003, 1001, 3, 'Wah ini mah.....', '2025-04-25 21:41:00'),
(10004, 1004, 1, 'Mbah Ance lah sopo maneh bos! iku board sisan!', '2025-04-26 14:01:21'),
(10005, 1001, 2, 'Sorry, Aku Apple dari umur 15', '2025-05-13 08:12:31'),
(10006, 1002, 1, 'Konten kok plagiat peng peng peng! wluwluwlu', '2025-05-12 11:12:13'),
(10007, 1004, 1, 'MU donkk UNBEATEN, ini baru King Eropa Bos', '2025-05-12 21:41:00'),
(10008, 1003, 3, 'Mending rakit PC dewe ae, sak karep', '2025-05-11 14:01:21');

--
-- Triggers `comments`
--
DELIMITER $$
CREATE TRIGGER `INCREMENT_COMMENT_COUNT` AFTER INSERT ON `comments` FOR EACH ROW BEGIN 
UPDATE posts
SET COMMENT_COUNT = COMMENT_COUNT + 1
WHERE POST_ID = NEW.POST_ID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UPDATE_LAST_LOGIN_ON_COMMENT` AFTER INSERT ON `comments` FOR EACH ROW BEGIN
UPDATE users
SET LAST_LOGIN = NOW()
WHERE USER_ID + NEW.USER_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `POST_ID` int(11) NOT NULL,
  `USER_ID` int(11) DEFAULT NULL,
  `POST_TITLE` varchar(50) DEFAULT NULL,
  `KONTEN_POST` varchar(50) DEFAULT NULL,
  `TANGGAL_PUBLIKASI` date DEFAULT NULL,
  `STATUS_POST` enum('DRAFT','PUBLISHED','ARCHIEVED') DEFAULT NULL,
  `COMMENT_COUNT` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`POST_ID`, `USER_ID`, `POST_TITLE`, `KONTEN_POST`, `TANGGAL_PUBLIKASI`, `STATUS_POST`, `COMMENT_COUNT`) VALUES
(1001, 1, 'Review Gadget Terbaru', 'RTX is a jokes? apakah AMD sedang memasak...', '2025-03-02', 'PUBLISHED', 1),
(1002, 2, 'Tips Menjaga Pola Hidup Sehat', 'Panduan singkat untuk pola makan sehat...', '2025-03-12', 'PUBLISHED', 1),
(1003, 1, 'PC Gaming Low Budget FPS RATA KANAN!!!', 'Langkah-langkah merakit PC gaming tepat sasaran...', '2025-04-22', 'PUBLISHED', 1),
(1004, 3, 'REMONTADA IS REAL??', 'Real Madrid bapuk, siapa yang harus disalahkan...', '2025-04-11', 'PUBLISHED', 1);

-- --------------------------------------------------------

--
-- Table structure for table `post_categories`
--

CREATE TABLE `post_categories` (
  `POST_ID` int(11) DEFAULT NULL,
  `CATEGORY_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `post_categories`
--

INSERT INTO `post_categories` (`POST_ID`, `CATEGORY_ID`) VALUES
(1001, 101),
(1002, 102),
(1003, 101),
(1003, 104),
(1004, 103);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `USER_ID` int(11) NOT NULL,
  `USERNAME` varchar(50) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `REGISTRATION_DATE` date DEFAULT NULL,
  `LAST_LOGIN` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`USER_ID`, `USERNAME`, `EMAIL`, `REGISTRATION_DATE`, `LAST_LOGIN`) VALUES
(1, 'connorkenway', 'ckenway@ac.com', '2024-09-05', '2025-04-30 03:45:24'),
(2, 'ezioautditore', 'brotherhoodmaster@ac.com', '2024-10-30', '2025-04-29 09:25:07'),
(3, 'altairlaahad', 'goldeneagle@ac.com', '2024-07-28', '2025-04-30 10:00:33');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_all_comments`
-- (See below for the actual view)
--
CREATE TABLE `vw_all_comments` (
`COMMENT_ID` int(11)
,`KONTEN_COMMENT` varchar(50)
,`USERNAME` varchar(50)
,`POST_TITLE` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_monthly_posts`
-- (See below for the actual view)
--
CREATE TABLE `vw_monthly_posts` (
`DATE_FORMAT(TANGGAL_PUBLIKASI, '%Y-%M')` varchar(69)
,`COUNT(*)` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_post_summary`
-- (See below for the actual view)
--
CREATE TABLE `vw_post_summary` (
`POST_ID` int(11)
,`POST_TITLE` varchar(50)
,`AUTHOR_NAME` varchar(50)
,`CATEGORY_NAME` varchar(50)
,`TOTAL_COMMENTS` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_simple_posts`
-- (See below for the actual view)
--
CREATE TABLE `vw_simple_posts` (
`POST_ID` int(11)
,`POST_TITLE` varchar(50)
,`USERNAME` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_all_comments`
--
DROP TABLE IF EXISTS `vw_all_comments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_all_comments`  AS SELECT `comments`.`COMMENT_ID` AS `COMMENT_ID`, `comments`.`KONTEN_COMMENT` AS `KONTEN_COMMENT`, `users`.`USERNAME` AS `USERNAME`, `posts`.`POST_TITLE` AS `POST_TITLE` FROM ((`comments` join `users` on(`comments`.`USER_ID` = `users`.`USER_ID`)) join `posts` on(`comments`.`POST_ID` = `posts`.`POST_ID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_monthly_posts`
--
DROP TABLE IF EXISTS `vw_monthly_posts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_monthly_posts`  AS SELECT date_format(`posts`.`TANGGAL_PUBLIKASI`,'%Y-%M') AS `DATE_FORMAT(TANGGAL_PUBLIKASI, '%Y-%M')`, count(0) AS `COUNT(*)` FROM `posts` GROUP BY date_format(`posts`.`TANGGAL_PUBLIKASI`,'%Y-%M') ORDER BY `posts`.`TANGGAL_PUBLIKASI` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `vw_post_summary`
--
DROP TABLE IF EXISTS `vw_post_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_post_summary`  AS SELECT `posts`.`POST_ID` AS `POST_ID`, `posts`.`POST_TITLE` AS `POST_TITLE`, `users`.`USERNAME` AS `AUTHOR_NAME`, `blogcategories`.`CATEGORY_NAME` AS `CATEGORY_NAME`, count(`comments`.`COMMENT_ID`) AS `TOTAL_COMMENTS` FROM ((((`posts` join `users` on(`posts`.`USER_ID` = `users`.`USER_ID`)) join `post_categories` on(`posts`.`POST_ID` = `post_categories`.`POST_ID`)) join `blogcategories` on(`post_categories`.`CATEGORY_ID` = `blogcategories`.`CATEGORY_ID`)) left join `comments` on(`posts`.`POST_ID` = `comments`.`POST_ID`)) GROUP BY `posts`.`POST_ID`, `posts`.`POST_TITLE`, `users`.`USERNAME`, `blogcategories`.`CATEGORY_NAME` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_simple_posts`
--
DROP TABLE IF EXISTS `vw_simple_posts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_simple_posts`  AS SELECT `posts`.`POST_ID` AS `POST_ID`, `posts`.`POST_TITLE` AS `POST_TITLE`, `users`.`USERNAME` AS `USERNAME` FROM (`posts` join `users` on(`posts`.`USER_ID` = `users`.`USER_ID`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blogcategories`
--
ALTER TABLE `blogcategories`
  ADD PRIMARY KEY (`CATEGORY_ID`),
  ADD UNIQUE KEY `CATEGORY_NAME` (`CATEGORY_NAME`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`COMMENT_ID`),
  ADD KEY `POST_ID` (`POST_ID`),
  ADD KEY `USER_ID` (`USER_ID`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`POST_ID`),
  ADD KEY `USER_ID` (`USER_ID`);

--
-- Indexes for table `post_categories`
--
ALTER TABLE `post_categories`
  ADD KEY `POST_ID` (`POST_ID`),
  ADD KEY `CATEGORY_ID` (`CATEGORY_ID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`USER_ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`POST_ID`) REFERENCES `posts` (`POST_ID`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`USER_ID`) REFERENCES `users` (`USER_ID`);

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `users` (`USER_ID`);

--
-- Constraints for table `post_categories`
--
ALTER TABLE `post_categories`
  ADD CONSTRAINT `post_categories_ibfk_1` FOREIGN KEY (`POST_ID`) REFERENCES `posts` (`POST_ID`),
  ADD CONSTRAINT `post_categories_ibfk_2` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `blogcategories` (`CATEGORY_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
