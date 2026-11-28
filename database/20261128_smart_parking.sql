-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2026 at 01:36 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.6.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_parking`
--

-- --------------------------------------------------------

--
-- Table structure for table `device_management`
--

CREATE TABLE `device_management` (
  `device_id` int(10) UNSIGNED NOT NULL,
  `device_name` varchar(60) NOT NULL,
  `device_type` enum('controller','rfid_reader','barrier_servo','ir_sensor','ultrasonic_sensor','lcd','buzzer','led') NOT NULL,
  `location` varchar(60) DEFAULT NULL,
  `api_key` varchar(64) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `firmware_version` varchar(20) DEFAULT NULL,
  `status` enum('online','offline','faulty','maintenance') NOT NULL DEFAULT 'offline',
  `last_seen_at` datetime DEFAULT NULL,
  `installed_at` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archived_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_management`
--

INSERT INTO `device_management` (`device_id`, `device_name`, `device_type`, `location`, `api_key`, `ip_address`, `firmware_version`, `status`, `last_seen_at`, `installed_at`, `created_at`, `updated_at`, `archived_at`) VALUES
(1, 'Main Controller', 'controller', 'Control box', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(2, 'Entry RFID Reader', 'rfid_reader', 'Entrance', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(3, 'Exit RFID Reader', 'rfid_reader', 'Exit', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(4, 'Entry Barrier', 'barrier_servo', 'Entrance', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(5, 'Exit Barrier', 'barrier_servo', 'Exit', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(6, 'Entry IR Sensor', 'ir_sensor', 'Entrance', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(7, 'Exit IR Sensor', 'ir_sensor', 'Exit', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(8, 'Slot 1 Ultrasonic', 'ultrasonic_sensor', 'Slot 1', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(9, 'Slot 2 Ultrasonic', 'ultrasonic_sensor', 'Slot 2', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(10, 'Slot 3 Ultrasonic', 'ultrasonic_sensor', 'Slot 3', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(11, 'Slot 4 Ultrasonic', 'ultrasonic_sensor', 'Slot 4', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(12, 'Slot 5 Ultrasonic', 'ultrasonic_sensor', 'Slot 5', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(13, 'Slot 6 Ultrasonic', 'ultrasonic_sensor', 'Slot 6', NULL, NULL, NULL, 'offline', NULL, NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `entry_exit_logs`
--

CREATE TABLE `entry_exit_logs` (
  `log_id` bigint(20) UNSIGNED NOT NULL,
  `card_uid_scanned` varchar(20) NOT NULL,
  `card_id` int(10) UNSIGNED DEFAULT NULL,
  `vehicle_id` int(10) UNSIGNED DEFAULT NULL,
  `record_id` int(10) UNSIGNED DEFAULT NULL,
  `device_id` int(10) UNSIGNED DEFAULT NULL,
  `event_type` enum('entry','exit') NOT NULL,
  `access_result` enum('granted','denied') NOT NULL,
  `denial_reason` enum('unregistered_card','card_inactive','card_lost','vehicle_blocked','already_inside','not_inside','lot_full') DEFAULT NULL,
  `logged_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `type` enum('unauthorized_access','lot_full','device_offline','device_fault','lost_card_used','system') NOT NULL,
  `severity` enum('info','warning','critical') NOT NULL DEFAULT 'info',
  `title` varchar(100) NOT NULL,
  `message` varchar(255) NOT NULL,
  `log_id` bigint(20) UNSIGNED DEFAULT NULL,
  `device_id` int(10) UNSIGNED DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `read_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parking_records`
--

CREATE TABLE `parking_records` (
  `record_id` int(10) UNSIGNED NOT NULL,
  `vehicle_id` int(10) UNSIGNED NOT NULL,
  `card_id` int(10) UNSIGNED DEFAULT NULL,
  `slot_id` int(10) UNSIGNED DEFAULT NULL,
  `time_in` datetime NOT NULL,
  `time_out` datetime DEFAULT NULL,
  `duration_min` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('active','completed','cancelled') NOT NULL DEFAULT 'active',
  `remarks` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `active_vehicle_id` int(10) UNSIGNED GENERATED ALWAYS AS (if(`status` = 'active',`vehicle_id`,NULL)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parking_slots`
--

CREATE TABLE `parking_slots` (
  `slot_id` int(10) UNSIGNED NOT NULL,
  `slot_number` varchar(10) NOT NULL,
  `sensor_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('available','occupied','reserved','maintenance') NOT NULL DEFAULT 'available',
  `status_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archived_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parking_slots`
--

INSERT INTO `parking_slots` (`slot_id`, `slot_number`, `sensor_id`, `status`, `status_updated_at`, `created_at`, `updated_at`, `archived_at`) VALUES
(1, 'S1', 8, 'available', NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(2, 'S2', 9, 'available', NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(3, 'S3', 10, 'available', NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(4, 'S4', 11, 'available', NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(5, 'S5', 12, 'available', NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL),
(6, 'S6', 13, 'available', NULL, '2026-11-28 09:06:08', '2026-11-28 09:06:08', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `rfid_cards`
--

CREATE TABLE `rfid_cards` (
  `card_id` int(10) UNSIGNED NOT NULL,
  `card_uid` varchar(20) NOT NULL,
  `vehicle_id` int(10) UNSIGNED DEFAULT NULL,
  `status` enum('active','inactive','lost','blocked') NOT NULL DEFAULT 'active',
  `issued_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archived_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','staff') NOT NULL DEFAULT 'staff',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archived_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `vehicle_id` int(10) UNSIGNED NOT NULL,
  `plate_number` varchar(20) NOT NULL,
  `vehicle_type` enum('car','motorcycle','suv','van','truck','other') NOT NULL DEFAULT 'car',
  `brand` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `owner_name` varchar(100) NOT NULL,
  `owner_contact` varchar(30) DEFAULT NULL,
  `status` enum('active','suspended','blocked') NOT NULL DEFAULT 'active',
  `registered_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archived_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `device_management`
--
ALTER TABLE `device_management`
  ADD PRIMARY KEY (`device_id`),
  ADD UNIQUE KEY `device_name` (`device_name`),
  ADD UNIQUE KEY `api_key` (`api_key`);

--
-- Indexes for table `entry_exit_logs`
--
ALTER TABLE `entry_exit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_logs_logged_at` (`logged_at`),
  ADD KEY `idx_logs_result` (`access_result`),
  ADD KEY `fk_logs_card` (`card_id`),
  ADD KEY `fk_logs_vehicle` (`vehicle_id`),
  ADD KEY `fk_logs_record` (`record_id`),
  ADD KEY `fk_logs_device` (`device_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `idx_notif_unread` (`is_read`,`created_at`),
  ADD KEY `fk_notif_user` (`user_id`),
  ADD KEY `fk_notif_log` (`log_id`),
  ADD KEY `fk_notif_device` (`device_id`);

--
-- Indexes for table `parking_records`
--
ALTER TABLE `parking_records`
  ADD PRIMARY KEY (`record_id`),
  ADD UNIQUE KEY `uq_one_active_session` (`active_vehicle_id`),
  ADD KEY `idx_records_time_in` (`time_in`),
  ADD KEY `idx_records_status` (`status`),
  ADD KEY `fk_records_vehicle` (`vehicle_id`),
  ADD KEY `fk_records_card` (`card_id`),
  ADD KEY `fk_records_slot` (`slot_id`);

--
-- Indexes for table `parking_slots`
--
ALTER TABLE `parking_slots`
  ADD PRIMARY KEY (`slot_id`),
  ADD UNIQUE KEY `slot_number` (`slot_number`),
  ADD UNIQUE KEY `sensor_id` (`sensor_id`);

--
-- Indexes for table `rfid_cards`
--
ALTER TABLE `rfid_cards`
  ADD PRIMARY KEY (`card_id`),
  ADD UNIQUE KEY `card_uid` (`card_uid`),
  ADD UNIQUE KEY `vehicle_id` (`vehicle_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehicle_id`),
  ADD UNIQUE KEY `plate_number` (`plate_number`),
  ADD KEY `fk_vehicles_user` (`registered_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `device_management`
--
ALTER TABLE `device_management`
  MODIFY `device_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `entry_exit_logs`
--
ALTER TABLE `entry_exit_logs`
  MODIFY `log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parking_records`
--
ALTER TABLE `parking_records`
  MODIFY `record_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parking_slots`
--
ALTER TABLE `parking_slots`
  MODIFY `slot_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `rfid_cards`
--
ALTER TABLE `rfid_cards`
  MODIFY `card_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehicle_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `entry_exit_logs`
--
ALTER TABLE `entry_exit_logs`
  ADD CONSTRAINT `fk_logs_card` FOREIGN KEY (`card_id`) REFERENCES `rfid_cards` (`card_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_logs_device` FOREIGN KEY (`device_id`) REFERENCES `device_management` (`device_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_logs_record` FOREIGN KEY (`record_id`) REFERENCES `parking_records` (`record_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_logs_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notif_device` FOREIGN KEY (`device_id`) REFERENCES `device_management` (`device_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_notif_log` FOREIGN KEY (`log_id`) REFERENCES `entry_exit_logs` (`log_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `parking_records`
--
ALTER TABLE `parking_records`
  ADD CONSTRAINT `fk_records_card` FOREIGN KEY (`card_id`) REFERENCES `rfid_cards` (`card_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_records_slot` FOREIGN KEY (`slot_id`) REFERENCES `parking_slots` (`slot_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_records_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`);

--
-- Constraints for table `parking_slots`
--
ALTER TABLE `parking_slots`
  ADD CONSTRAINT `fk_slots_sensor` FOREIGN KEY (`sensor_id`) REFERENCES `device_management` (`device_id`) ON DELETE SET NULL;

--
-- Constraints for table `rfid_cards`
--
ALTER TABLE `rfid_cards`
  ADD CONSTRAINT `fk_cards_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`vehicle_id`) ON DELETE SET NULL;

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `fk_vehicles_user` FOREIGN KEY (`registered_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
