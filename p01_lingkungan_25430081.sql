-- ===================================================
-- Modul 01: Penyiapan Lingkungan Basis Data
-- Nama  : Muhamad Adha Satria Ardiansyah
-- NPM   : 25430081
-- Kelas : C
-- ===================================================

-- 1. Membuat Database Praktikum
CREATE DATABASE kopma_123 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Membuat Akun Pengguna Kerja (Non-Root)
-- Catatan: Password disamarkan untuk keamanan repositori
CREATE USER 'mhs_123'@'localhost' IDENTIFIED BY '*****';

-- 3. Memberikan Hak Akses Penuh ke Database Kopma saja
GRANT ALL PRIVILEGES ON kopma_123.* TO 'mhs_123'@'localhost';

-- 4. Memperbarui Password Pengguna (jika diperlukan)
ALTER USER 'mhs_123'@'localhost' IDENTIFIED BY '*****';

-- 5. Menampilkan Hak Akses yang Dimiliki Pengguna
SHOW GRANTS FOR 'mhs_123'@'localhost';

-- 6. Menampilkan Daftar Database yang Tersedia
SHOW DATABASES;

-- 7. Memilih dan Menggunakan Database Kerja
USE kopma_123;