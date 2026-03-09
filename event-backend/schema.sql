-- SQL schema for the event management application.
-- Run this against your MySQL server to create the required database tables.

CREATE DATABASE IF NOT EXISTS event_management;
USE event_management;

-- Users table: stores both admins and normal users.
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Events table: stores basic event information.
CREATE TABLE IF NOT EXISTS events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  date DATETIME NOT NULL,
  location VARCHAR(255) NOT NULL,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Registrations table: stores which user registered to which event.
CREATE TABLE IF NOT EXISTS registrations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  event_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

-- Enquiries table: stores enquiries submitted via the public enquiry form.
CREATE TABLE IF NOT EXISTS enquiries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  contact_number VARCHAR(50) NOT NULL,
  email VARCHAR(255) NOT NULL,
  comment VARCHAR(300) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed an initial admin user.
-- IMPORTANT: Replace the password hash below with one generated for your desired admin password.
-- The current hash corresponds to password "password123".
INSERT INTO users (name, email, password_hash, role)
VALUES (
  'Default Admin',
  'admin@example.com',
  '$2a$10$/C7nZqBpCn/zfWd2p9rV4OHFDJbb0k7NY9Bz7SnQkomR1Cn9IjHKC',
  'admin'
)
ON DUPLICATE KEY UPDATE email = email;

