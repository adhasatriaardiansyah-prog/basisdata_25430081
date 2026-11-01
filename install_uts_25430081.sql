-- =====================================================================
-- Skrip Master Instalasi UTS Basis Data
-- Nama  : Muhamad Adha Satria Ardiansyah
-- NPM   : 25430081
-- Kelas : C
-- Tema  : Akademik / akad_081
-- =====================================================================

-- 1. Pembuatan Basis Data Bersih untuk Pengujian (Clean Installation)
DROP DATABASE IF EXISTS akad_081_uji;
CREATE DATABASE akad_081_uji;
USE akad_081_uji;

-- 2. Eksekusi Skrip DDL (Struktur Tabel & Constraint)
SOURCE D:/basis_data_25430081/p05_ddl_25430081.sql;

-- 3. Eksekusi Skrip DML (Pengisian Data Awal Berbasis Parameter P)
SOURCE D:/basis_data_25430081/p06_data_25430081.sql;