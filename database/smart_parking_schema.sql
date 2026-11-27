-- =====================================================================
-- Smart Parking Management System with RFID
-- MySQL 5.7+ / MariaDB 10.3+  (InnoDB, utf8mb4)
-- Admin-side only: no customer accounts; vehicle owners are plain data.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS smart_parking
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_parking;

-- ---------------------------------------------------------------------
-- 1. users : CMS logins (admin / parking personnel)
-- ---------------------------------------------------------------------
CREATE TABLE users (
  user_id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name      VARCHAR(100) NOT NULL,
  username       VARCHAR(50)  NOT NULL UNIQUE,
  email          VARCHAR(100) UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,              -- use PHP password_hash()
  role           ENUM('admin','staff') NOT NULL DEFAULT 'staff',
  status         ENUM('active','inactive') NOT NULL DEFAULT 'active',
  last_login_at  DATETIME NULL,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. vehicles : registered vehicles (the "who is allowed" list)
-- ---------------------------------------------------------------------
CREATE TABLE vehicles (
  vehicle_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  plate_number   VARCHAR(20)  NOT NULL UNIQUE,
  vehicle_type   ENUM('car','motorcycle','suv','van','truck','other') NOT NULL DEFAULT 'car',
  brand          VARCHAR(50)  NULL,
  model          VARCHAR(50)  NULL,
  color          VARCHAR(30)  NULL,
  owner_name     VARCHAR(100) NOT NULL,
  owner_contact  VARCHAR(30)  NULL,
  status         ENUM('active','suspended','blocked') NOT NULL DEFAULT 'active',
  registered_by  INT UNSIGNED NULL,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_vehicles_user FOREIGN KEY (registered_by)
    REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. rfid_cards : one card <-> one vehicle
--    UNIQUE(vehicle_id) enforces "a vehicle has at most one card".
--    UNIQUE(card_uid)   enforces "a card belongs to at most one vehicle".
--    vehicle_id is NULL for a card that is in stock but not yet assigned.
-- ---------------------------------------------------------------------
CREATE TABLE rfid_cards (
  card_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  card_uid     VARCHAR(20) NOT NULL UNIQUE,          -- UID read by RC522, e.g. 'A3F29C1B'
  vehicle_id   INT UNSIGNED NULL UNIQUE,
  status       ENUM('active','inactive','lost','blocked') NOT NULL DEFAULT 'active',
  issued_at    DATETIME NULL,
  expires_at   DATETIME NULL,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_cards_vehicle FOREIGN KEY (vehicle_id)
    REFERENCES vehicles(vehicle_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. device_management : inventory of the Arduino/ESP hardware
--    (created before parking_slots because each slot has a sensor)
-- ---------------------------------------------------------------------
CREATE TABLE device_management (
  device_id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  device_name      VARCHAR(60) NOT NULL UNIQUE,      -- e.g. 'Entry RFID Reader'
  device_type      ENUM('controller','rfid_reader','barrier_servo',
                        'ir_sensor','ultrasonic_sensor','lcd','buzzer','led') NOT NULL,
  location         VARCHAR(60) NULL,                 -- 'Entrance', 'Exit', 'Slot 3'
  api_key          VARCHAR(64) NULL UNIQUE,          -- token the ESP sends with each HTTP request
  ip_address       VARCHAR(45) NULL,
  firmware_version VARCHAR(20) NULL,
  status           ENUM('online','offline','faulty','maintenance') NOT NULL DEFAULT 'offline',
  last_seen_at     DATETIME NULL,                    -- heartbeat; drives online/offline
  installed_at     DATE NULL,
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. parking_slots : physical slots (minimum 6)
-- ---------------------------------------------------------------------
CREATE TABLE parking_slots (
  slot_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slot_number   VARCHAR(10) NOT NULL UNIQUE,         -- 'S1' ... 'S6'
  sensor_id     INT UNSIGNED NULL UNIQUE,            -- the ultrasonic sensor watching this slot
  status        ENUM('available','occupied','reserved','maintenance') NOT NULL DEFAULT 'available',
  status_updated_at DATETIME NULL,                   -- last time the sensor changed it
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_slots_sensor FOREIGN KEY (sensor_id)
    REFERENCES device_management(device_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. parking_records : one row per parking SESSION (entry -> exit)
--    This is the "transaction history" module.
-- ---------------------------------------------------------------------
CREATE TABLE parking_records (
  record_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  vehicle_id     INT UNSIGNED NOT NULL,
  card_id        INT UNSIGNED NULL,
  slot_id        INT UNSIGNED NULL,                  -- filled once a slot sensor detects the car
  time_in        DATETIME NOT NULL,
  time_out       DATETIME NULL,                      -- NULL while still parked
  duration_min   INT UNSIGNED NULL,                  -- computed on exit
  status         ENUM('active','completed','cancelled') NOT NULL DEFAULT 'active',
  remarks        VARCHAR(255) NULL,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Guarantees a vehicle can't have two open sessions at once.
  active_vehicle_id INT UNSIGNED
    GENERATED ALWAYS AS (IF(status = 'active', vehicle_id, NULL)) STORED,
  UNIQUE KEY uq_one_active_session (active_vehicle_id),

  KEY idx_records_time_in (time_in),
  KEY idx_records_status (status),
  CONSTRAINT fk_records_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
  CONSTRAINT fk_records_card    FOREIGN KEY (card_id)    REFERENCES rfid_cards(card_id) ON DELETE SET NULL,
  CONSTRAINT fk_records_slot    FOREIGN KEY (slot_id)    REFERENCES parking_slots(slot_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 7. entry_exit_logs : raw gate event log, EVERY RFID scan (granted or denied)
--    card_uid_scanned is stored as text because unknown/unregistered
--    cards do not exist in rfid_cards, but you still need to log them.
-- ---------------------------------------------------------------------
CREATE TABLE entry_exit_logs (
  log_id            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  card_uid_scanned  VARCHAR(20) NOT NULL,
  card_id           INT UNSIGNED NULL,               -- NULL if the card is unregistered
  vehicle_id        INT UNSIGNED NULL,
  record_id         INT UNSIGNED NULL,               -- links to the parking session (granted only)
  device_id         INT UNSIGNED NULL,               -- which reader produced the scan
  event_type        ENUM('entry','exit') NOT NULL,
  access_result     ENUM('granted','denied') NOT NULL,
  denial_reason     ENUM('unregistered_card','card_inactive','card_lost',
                         'vehicle_blocked','already_inside','not_inside',
                         'lot_full') NULL,
  logged_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_logs_logged_at (logged_at),
  KEY idx_logs_result (access_result),
  CONSTRAINT fk_logs_card    FOREIGN KEY (card_id)    REFERENCES rfid_cards(card_id)          ON DELETE SET NULL,
  CONSTRAINT fk_logs_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)         ON DELETE SET NULL,
  CONSTRAINT fk_logs_record  FOREIGN KEY (record_id)  REFERENCES parking_records(record_id)   ON DELETE SET NULL,
  CONSTRAINT fk_logs_device  FOREIGN KEY (device_id)  REFERENCES device_management(device_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 8. notifications : alerts shown to admin/staff in the CMS
--    user_id NULL = visible to every CMS user (broadcast)
-- ---------------------------------------------------------------------
CREATE TABLE notifications (
  notification_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id         INT UNSIGNED NULL,
  type            ENUM('unauthorized_access','lot_full','device_offline',
                       'device_fault','lost_card_used','system') NOT NULL,
  severity        ENUM('info','warning','critical') NOT NULL DEFAULT 'info',
  title           VARCHAR(100) NOT NULL,
  message         VARCHAR(255) NOT NULL,
  log_id          BIGINT UNSIGNED NULL,              -- the scan that triggered it
  device_id       INT UNSIGNED NULL,                 -- or the device concerned
  is_read         TINYINT(1) NOT NULL DEFAULT 0,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at         DATETIME NULL,
  KEY idx_notif_unread (is_read, created_at),
  CONSTRAINT fk_notif_user   FOREIGN KEY (user_id)   REFERENCES users(user_id)               ON DELETE CASCADE,
  CONSTRAINT fk_notif_log    FOREIGN KEY (log_id)    REFERENCES entry_exit_logs(log_id)      ON DELETE SET NULL,
  CONSTRAINT fk_notif_device FOREIGN KEY (device_id) REFERENCES device_management(device_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =====================================================================
-- Starter data (minimum 6 slots + hardware per the project spec)
-- =====================================================================
INSERT INTO device_management (device_name, device_type, location) VALUES
  ('Main Controller',      'controller',        'Control box'),
  ('Entry RFID Reader',    'rfid_reader',       'Entrance'),
  ('Exit RFID Reader',     'rfid_reader',       'Exit'),
  ('Entry Barrier',        'barrier_servo',     'Entrance'),
  ('Exit Barrier',         'barrier_servo',     'Exit'),
  ('Entry IR Sensor',      'ir_sensor',         'Entrance'),
  ('Exit IR Sensor',       'ir_sensor',         'Exit'),
  ('Slot 1 Ultrasonic',    'ultrasonic_sensor', 'Slot 1'),
  ('Slot 2 Ultrasonic',    'ultrasonic_sensor', 'Slot 2'),
  ('Slot 3 Ultrasonic',    'ultrasonic_sensor', 'Slot 3'),
  ('Slot 4 Ultrasonic',    'ultrasonic_sensor', 'Slot 4'),
  ('Slot 5 Ultrasonic',    'ultrasonic_sensor', 'Slot 5'),
  ('Slot 6 Ultrasonic',    'ultrasonic_sensor', 'Slot 6');

INSERT INTO parking_slots (slot_number, sensor_id)
SELECT CONCAT('S', n), d.device_id
FROM (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) nums
JOIN device_management d ON d.device_name = CONCAT('Slot ', nums.n, ' Ultrasonic');

-- Create your first admin from PHP so the password is hashed properly:
--   INSERT INTO users (full_name, username, password_hash, role)
--   VALUES ('System Admin', 'admin', '<password_hash() output>', 'admin');