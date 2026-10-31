-- ==========================================================
-- Berkas: p13_role_25430081.sql
-- Nama : Muhammad Adha Satria Ardiansyah
-- NPM  : 25430081 / Kelas C
-- Modul: 13 - Role, Akun, dan Hak Akses Per Peran (Kopma)
-- ==========================================================

-- A. Role dan Akun Kasir
CREATE ROLE IF NOT EXISTS r_kasir_081;
GRANT SELECT ON kopma_081.v_kasir_anggota TO r_kasir_081;
GRANT SELECT ON kopma_081.v_kasir_barang TO r_kasir_081;

CREATE USER IF NOT EXISTS 'kasir_081'@'localhost' IDENTIFIED BY '<password_aman>';
GRANT r_kasir_081 TO 'kasir_081'@'localhost';
SET DEFAULT ROLE r_kasir_081 FOR 'kasir_081'@'localhost';

-- B. Role dan Akun Gudang
CREATE ROLE IF NOT EXISTS r_gudang_081;
GRANT SELECT, UPDATE ON kopma_081.v_barang_menipis TO r_gudang_081;
GRANT SELECT ON kopma_081.v_kasir_barang TO r_gudang_081;

CREATE USER IF NOT EXISTS 'gudang_081'@'localhost' IDENTIFIED BY '<password_aman>';
GRANT r_gudang_081 TO 'gudang_081'@'localhost';
SET DEFAULT ROLE r_gudang_081 FOR 'gudang_081'@'localhost';

-- C. Role dan Akun Ketua
CREATE ROLE IF NOT EXISTS r_ketua_081;
GRANT SELECT ON kopma_081.v_omzet_harian TO r_ketua_081;
GRANT SELECT ON kopma_081.v_barang_menipis TO r_ketua_081;
GRANT SELECT ON kopma_081.v_kasir_anggota TO r_ketua_081;

CREATE USER IF NOT EXISTS 'ketua_081'@'localhost' IDENTIFIED BY '<password_aman>';
GRANT r_ketua_081 TO 'ketua_081'@'localhost';
SET DEFAULT ROLE r_ketua_081 FOR 'ketua_081'@'localhost';