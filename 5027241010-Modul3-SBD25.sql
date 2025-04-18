-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 18, 2025 at 07:17 AM
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
-- Database: `frd-010`
--

-- --------------------------------------------------------

--
-- Table structure for table `akun`
--

CREATE TABLE `akun` (
  `ID_AKUN` int(11) NOT NULL,
  `NAMA_AKUN` varchar(50) NOT NULL,
  `NO_TELEPON` varchar(15) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `PASSWORD` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `driver`
--

CREATE TABLE `driver` (
  `ID_DRIVER` int(11) NOT NULL,
  `NAMA_DRIVER` varchar(50) NOT NULL,
  `PLAT_KENDARAAN` varchar(10) NOT NULL,
  `RATING_DRIVER` decimal(3,2) DEFAULT NULL CHECK (`RATING_DRIVER` between 1.00 and 5.00)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `merchant`
--

CREATE TABLE `merchant` (
  `ID_MERCHANT` int(11) NOT NULL,
  `NAMA_MERCHANT` varchar(50) NOT NULL,
  `RATING_MERCHANT` decimal(3,2) DEFAULT NULL CHECK (`RATING_MERCHANT` between 1.00 and 5.00),
  `LOKASI_MERCHANT` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `ID_PEMBAYARAN` int(11) NOT NULL,
  `ID_PESANAN` int(11) NOT NULL,
  `METODE_PEMBAYARAN` enum('Cash','IT Pay') NOT NULL,
  `TOTAL` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `ID_PESANAN` int(11) NOT NULL,
  `ID_AKUN` int(11) NOT NULL,
  `ID_MERCHANT` int(11) NOT NULL,
  `ID_DRIVER` int(11) NOT NULL,
  `TANGGAL_PEMESANAN` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `akun`
--
ALTER TABLE `akun`
  ADD PRIMARY KEY (`ID_AKUN`),
  ADD UNIQUE KEY `PASSWORD` (`PASSWORD`);

--
-- Indexes for table `driver`
--
ALTER TABLE `driver`
  ADD PRIMARY KEY (`ID_DRIVER`);

--
-- Indexes for table `merchant`
--
ALTER TABLE `merchant`
  ADD PRIMARY KEY (`ID_MERCHANT`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`ID_PEMBAYARAN`),
  ADD KEY `ID_PESANAN` (`ID_PESANAN`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`ID_PESANAN`),
  ADD KEY `ID_AKUN` (`ID_AKUN`),
  ADD KEY `ID_MERCHANT` (`ID_MERCHANT`),
  ADD KEY `ID_DRIVER` (`ID_DRIVER`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `akun`
--
ALTER TABLE `akun`
  MODIFY `ID_AKUN` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `driver`
--
ALTER TABLE `driver`
  MODIFY `ID_DRIVER` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `merchant`
--
ALTER TABLE `merchant`
  MODIFY `ID_MERCHANT` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `ID_PEMBAYARAN` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `ID_PESANAN` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`ID_PESANAN`) REFERENCES `pesanan` (`ID_PESANAN`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`ID_AKUN`) REFERENCES `akun` (`ID_AKUN`),
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`ID_MERCHANT`) REFERENCES `merchant` (`ID_MERCHANT`),
  ADD CONSTRAINT `pesanan_ibfk_3` FOREIGN KEY (`ID_DRIVER`) REFERENCES `driver` (`ID_DRIVER`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
