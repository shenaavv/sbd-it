-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 01, 2025 at 08:11 AM
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
-- Database: `010_frd_anomaliuniverse`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetStatistikEntitasPalingPopuler` (OUT `p_nama_entitas_populer` VARCHAR(150), OUT `p_total_views_entitas` BIGINT, OUT `p_jumlah_konten_terkait` INT)   BEGIN
    DECLARE v_id_entitas INT;

    SELECT id_entitas, SUM(views) AS total_views, COUNT(*) AS jumlah_konten
    INTO v_id_entitas, p_total_views_entitas, p_jumlah_konten_terkait
    FROM KontenAnomali
    GROUP BY id_entitas
    ORDER BY total_views DESC
    LIMIT 1;

    IF v_id_entitas IS NULL THEN
        SET p_nama_entitas_populer = 'Tidak ada data konten';
        SET p_total_views_entitas = 0;
        SET p_jumlah_konten_terkait = 0;
    ELSE
        SELECT nama_entitas INTO p_nama_entitas_populer
        FROM EntitasAnomali
        WHERE id_entitas = v_id_entitas;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_LaporkanKontenBrainrotTeratasBulanan` (IN `p_bulan` INT, IN `p_tahun` INT)   BEGIN
    SELECT
        judul_konten,
        fn_HitungSkorViralitasKonten(id_konten) AS skor_viralitas,
        tanggal_unggah
    FROM KontenAnomali
    WHERE MONTH(tanggal_unggah) = p_bulan AND YEAR(tanggal_unggah) = p_tahun
    ORDER BY skor_viralitas DESC
    LIMIT 5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_RegistrasiEntitasBaru` (IN `p_nama_entitas` VARCHAR(150), IN `p_tipe_entitas` ENUM('Makhluk Hidup','Benda Mati','Fenomena Abstrak','Sound - Viral'), IN `p_tingkat_absurditas` INT, IN `p_tanggal_terdeteksi` DATE, IN `p_sumber_origin` TEXT, OUT `p_status_registrasi` VARCHAR(255))   BEGIN
    DECLARE v_exists INT;

    SELECT COUNT(*) INTO v_exists
    FROM EntitasAnomali
    WHERE nama_entitas = p_nama_entitas;

    IF v_exists > 0 THEN
        SET p_status_registrasi = CONCAT('GAGAL! Entitas ''', p_nama_entitas, ''' sudah terdaftar.');
    ELSE
        INSERT INTO EntitasAnomali (nama_entitas, tipe_entitas, tingkat_absurditas, tanggal_terdeteksi, sumber_origin)
        VALUES (p_nama_entitas, p_tipe_entitas, p_tingkat_absurditas, p_tanggal_terdeteksi, p_sumber_origin);
        SET p_status_registrasi = CONCAT('SUKSES! Entitas ''', p_nama_entitas, ''' telah ditambahkan.');
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_HitungSkorViralitasKonten` (`p_id_konten` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE v_views BIGINT DEFAULT 0;
    DECLARE v_likes INT DEFAULT 0;
    DECLARE v_shares INT DEFAULT 0;
    DECLARE v_potensi ENUM('Rendah', 'Sedang', 'Tinggi', 'CROCODILO!');
    DECLARE v_bonus INT DEFAULT 0;
    DECLARE v_skor DECIMAL(10,2) DEFAULT 0;

    SELECT views, likes, shares, potensi_tripping
    INTO v_views, v_likes, v_shares, v_potensi
    FROM KontenAnomali
    WHERE id_konten = p_id_konten;

    IF v_potensi = 'CROCODILO!' THEN
        SET v_bonus = 100;
    ELSEIF v_potensi = 'Tinggi' THEN
        SET v_bonus = 50;
    ELSEIF v_potensi = 'Sedang' THEN
        SET v_bonus = 20;
    END IF;

    SET v_skor = (v_views / 10000) + (v_likes * 0.5) + (v_shares * 1) + v_bonus;

    RETURN v_skor;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_KlasifikasiAnomaliOtomatis` (`p_id_konten` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE v_trippi INT DEFAULT 0;
    DECLARE v_npc INT DEFAULT 0;
    DECLARE v_jumlah_tag INT DEFAULT 0;
    DECLARE v_klasifikasi VARCHAR(50);

    SELECT COUNT(*) INTO v_trippi
    FROM KontenTag kt
    JOIN TagAnomali ta ON kt.id_tag = ta.id_tag
    WHERE kt.id_konten = p_id_konten AND ta.nama_tag = 'TrippiTroppa';

    SELECT COUNT(*) INTO v_npc
    FROM KontenTag kt
    JOIN TagAnomali ta ON kt.id_tag = ta.id_tag
    WHERE kt.id_konten = p_id_konten AND ta.nama_tag = 'NPCVibes';

    SELECT COUNT(*) INTO v_jumlah_tag
    FROM KontenTag
    WHERE id_konten = p_id_konten;

    IF v_trippi > 0 AND v_npc > 0 THEN
        SET v_klasifikasi = 'Kombinasi Trippi NPC';
    ELSEIF v_trippi > 0 THEN
        SET v_klasifikasi = 'Dominan TrippiTroppa';
    ELSEIF v_npc > 0 THEN
        SET v_klasifikasi = 'Dominan NPCVibes';
    ELSEIF v_jumlah_tag > 2 THEN
        SET v_klasifikasi = 'Campuran Beragam Anomali';
    ELSEIF v_jumlah_tag > 0 THEN
        SET v_klasifikasi = 'Anomali Standar';
    ELSE
        SET v_klasifikasi = 'Konten Tidak Ditemukan';
    END IF;

    RETURN v_klasifikasi;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `entitasanomali`
--

CREATE TABLE `entitasanomali` (
  `id_entitas` int(11) NOT NULL,
  `nama_entitas` varchar(150) NOT NULL,
  `tipe_entitas` enum('Makhluk Hidup','Benda Mati','Fenomena Abstrak','Sound - Viral') DEFAULT 'Fenomena Abstrak',
  `tingkat_absurditas` int(11) DEFAULT 5,
  `tanggal_terdeteksi` date DEFAULT NULL,
  `sumber_origin` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `entitasanomali`
--

INSERT INTO `entitasanomali` (`id_entitas`, `nama_entitas`, `tipe_entitas`, `tingkat_absurditas`, `tanggal_terdeteksi`, `sumber_origin`) VALUES
(1, 'Trippi Troppa Dancer', 'Makhluk Hidup', 8, '2023-11-01', 'Video TikTok India'),
(2, 'Bombardini Crocodilo Sound', '', 9, '2024-01-15', 'Sound effect tak dikenal'),
(3, 'Tralalelo Tralala Song', '', 7, '2023-09-10', 'Lagu anak-anak yang di-remix jadi aneh'),
(4, 'Capybara Hydrochaeris', 'Makhluk Hidup', 6, '2022-05-20', 'Berbagai meme capybara masbro'),
(5, 'Filter Wajah Menangis Parah', 'Fenomena Abstrak', 7, '2023-06-01', 'Filter Instagram/TikTok'),
(6, 'NPC Live Streamer', 'Makhluk Hidup', 9, '2023-08-15', 'Tren live streaming TikTok bertingkah seperti NPC');

-- --------------------------------------------------------

--
-- Table structure for table `kontenanomali`
--

CREATE TABLE `kontenanomali` (
  `id_konten` int(11) NOT NULL,
  `id_entitas` int(11) DEFAULT NULL,
  `id_kreator` int(11) DEFAULT NULL,
  `judul_konten` varchar(255) NOT NULL,
  `deskripsi_konten` text DEFAULT NULL,
  `url_konten` varchar(512) DEFAULT NULL,
  `tipe_media` enum('Video','Audio','Gambar','Teks') DEFAULT 'Video',
  `durasi_detik` int(11) DEFAULT NULL,
  `tanggal_unggah` datetime DEFAULT current_timestamp(),
  `views` bigint(20) DEFAULT 0,
  `likes` int(11) DEFAULT 0,
  `shares` int(11) DEFAULT 0,
  `potensi_tripping` enum('Rendah','Sedang','Tinggi','CROCODILO!') DEFAULT 'Sedang'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kontenanomali`
--

INSERT INTO `kontenanomali` (`id_konten`, `id_entitas`, `id_kreator`, `judul_konten`, `deskripsi_konten`, `url_konten`, `tipe_media`, `durasi_detik`, `tanggal_unggah`, `views`, `likes`, `shares`, `potensi_tripping`) VALUES
(1, NULL, 1, 'Trippi Troppa Challenge GONE WILD!', NULL, 'tiktok.com/trippi001', 'Video', 30, '2025-05-26 17:30:42', 5000000, 300000, 150000, 'Tinggi'),
(2, NULL, 2, 'BOMBARDINI CROCODILOOO! (10 Hour Loop)', NULL, 'youtube.com/bombardini001', 'Audio', 36000, '2025-05-26 17:30:42', 10000000, 500000, 200000, 'CROCODILO!'),
(3, NULL, 3, 'Tralalelo Tralala Remix Full Bass Jedag Jedug', NULL, 'tiktok.com/tralala001', 'Audio', 60, '2025-05-26 17:30:42', 2000000, 150000, 70000, 'Sedang'),
(4, NULL, 4, 'Capybara chilling with orange', NULL, 'instagram.com/capy001', 'Gambar', NULL, '2025-05-26 17:30:42', 1000000, 100000, 40000, 'Rendah'),
(5, NULL, 5, 'NPC Reacts to Gifts - ICE CREAM SO GOOD', NULL, 'tiktok.com/npc001', 'Video', 180, '2025-05-26 17:30:42', 15000000, 800000, 300000, 'CROCODILO!');

-- --------------------------------------------------------

--
-- Table structure for table `kontentag`
--

CREATE TABLE `kontentag` (
  `id_konten` int(11) NOT NULL,
  `id_tag` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kontentag`
--

INSERT INTO `kontentag` (`id_konten`, `id_tag`) VALUES
(1, 1),
(1, 6),
(1, 7),
(2, 2),
(2, 6),
(2, 7),
(2, 8),
(3, 3),
(3, 6),
(4, 4),
(4, 6),
(5, 5),
(5, 6),
(5, 7);

-- --------------------------------------------------------

--
-- Table structure for table `kreatorkontenanomali`
--

CREATE TABLE `kreatorkontenanomali` (
  `id_kreator` int(11) NOT NULL,
  `username_kreator` varchar(100) NOT NULL,
  `platform_utama` enum('TikTok','YouTube','Instagram','X','Lainnya') DEFAULT 'TikTok',
  `jumlah_followers` bigint(20) DEFAULT 0,
  `reputasi_brainrot` enum('Pemula','Menengah','Ahli','Legenda Anomali') DEFAULT 'Pemula'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kreatorkontenanomali`
--

INSERT INTO `kreatorkontenanomali` (`id_kreator`, `username_kreator`, `platform_utama`, `jumlah_followers`, `reputasi_brainrot`) VALUES
(1, 'RajaTrippi69', 'TikTok', 1200000, 'Ahli'),
(2, 'DJBombardiniOfficial', 'YouTube', 500000, 'Menengah'),
(3, 'TralalaQueen', 'TikTok', 75000, 'Menengah'),
(4, 'CapybaraEnjoyer_007', 'Instagram', 250000, 'Pemula'),
(5, 'LiveNPCMaster', 'TikTok', 2000000, 'Legenda Anomali');

-- --------------------------------------------------------

--
-- Table structure for table `loginteraksibrainrot`
--

CREATE TABLE `loginteraksibrainrot` (
  `id_log` int(11) NOT NULL,
  `id_konten` int(11) DEFAULT NULL,
  `username_penonton` varchar(100) DEFAULT NULL,
  `durasi_nonton_detik` int(11) DEFAULT NULL,
  `efek_dirasakan` text DEFAULT NULL,
  `waktu_interaksi` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `loginteraksibrainrot`
--

INSERT INTO `loginteraksibrainrot` (`id_log`, `id_konten`, `username_penonton`, `durasi_nonton_detik`, `efek_dirasakan`, `waktu_interaksi`) VALUES
(1, 1, 'User123', 25, 'Ikut bergoyang tanpa sadar, merasa sedikit trippy.', '2025-05-26 17:34:43'),
(2, 2, 'User456', 600, 'Telinga berdenging suara CROCODILO, mulai mempertanyakan realita.', '2025-05-26 17:34:43'),
(3, 5, 'User789', 170, 'Merasa perlu mengirim gift virtual dan mengulang kata-kata aneh.', '2025-05-26 17:34:43');

-- --------------------------------------------------------

--
-- Table structure for table `taganomali`
--

CREATE TABLE `taganomali` (
  `id_tag` int(11) NOT NULL,
  `nama_tag` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `taganomali`
--

INSERT INTO `taganomali` (`id_tag`, `nama_tag`) VALUES
(6, 'Absurd'),
(2, 'Bombardini'),
(7, 'BrainrotLevelMax'),
(4, 'CapybaraCore'),
(8, 'HumorGelap'),
(5, 'NPCVibes'),
(3, 'Tralalelo'),
(1, 'TrippiTroppa');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `entitasanomali`
--
ALTER TABLE `entitasanomali`
  ADD PRIMARY KEY (`id_entitas`),
  ADD UNIQUE KEY `nama_entitas` (`nama_entitas`);

--
-- Indexes for table `kontenanomali`
--
ALTER TABLE `kontenanomali`
  ADD PRIMARY KEY (`id_konten`),
  ADD UNIQUE KEY `url_konten` (`url_konten`),
  ADD KEY `id_entitas` (`id_entitas`),
  ADD KEY `id_kreator` (`id_kreator`);

--
-- Indexes for table `kontentag`
--
ALTER TABLE `kontentag`
  ADD PRIMARY KEY (`id_konten`,`id_tag`),
  ADD KEY `id_tag` (`id_tag`);

--
-- Indexes for table `kreatorkontenanomali`
--
ALTER TABLE `kreatorkontenanomali`
  ADD PRIMARY KEY (`id_kreator`),
  ADD UNIQUE KEY `username_kreator` (`username_kreator`);

--
-- Indexes for table `loginteraksibrainrot`
--
ALTER TABLE `loginteraksibrainrot`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_konten` (`id_konten`);

--
-- Indexes for table `taganomali`
--
ALTER TABLE `taganomali`
  ADD PRIMARY KEY (`id_tag`),
  ADD UNIQUE KEY `nama_tag` (`nama_tag`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `entitasanomali`
--
ALTER TABLE `entitasanomali`
  MODIFY `id_entitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `kontenanomali`
--
ALTER TABLE `kontenanomali`
  MODIFY `id_konten` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `kreatorkontenanomali`
--
ALTER TABLE `kreatorkontenanomali`
  MODIFY `id_kreator` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loginteraksibrainrot`
--
ALTER TABLE `loginteraksibrainrot`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `taganomali`
--
ALTER TABLE `taganomali`
  MODIFY `id_tag` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kontenanomali`
--
ALTER TABLE `kontenanomali`
  ADD CONSTRAINT `kontenanomali_ibfk_1` FOREIGN KEY (`id_entitas`) REFERENCES `entitasanomali` (`id_entitas`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `kontenanomali_ibfk_2` FOREIGN KEY (`id_kreator`) REFERENCES `kreatorkontenanomali` (`id_kreator`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `kontentag`
--
ALTER TABLE `kontentag`
  ADD CONSTRAINT `kontentag_ibfk_1` FOREIGN KEY (`id_konten`) REFERENCES `kontenanomali` (`id_konten`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `kontentag_ibfk_2` FOREIGN KEY (`id_tag`) REFERENCES `taganomali` (`id_tag`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `loginteraksibrainrot`
--
ALTER TABLE `loginteraksibrainrot`
  ADD CONSTRAINT `loginteraksibrainrot_ibfk_1` FOREIGN KEY (`id_konten`) REFERENCES `kontenanomali` (`id_konten`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
