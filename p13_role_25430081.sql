-- ==========================================================
-- Berkas: p13_role_25430081.sql
-- Nama  : Muhamad Adha Satria Ardiansyah
-- NPM   : 25430081
-- Kelas : C
-- Modul : 13 - Role, Akun, dan Hak Akses Per Peran (Akademik)
-- ==========================================================

USE akad_081;

-- A. Role dan Akun Dosen
CREATE ROLE IF NOT EXISTS r_dosen_081;
GRANT SELECT ON akad_081.v_dosen_mahasiswa TO r_dosen_081;

CREATE USER IF NOT EXISTS 'dosen_081'@'localhost' IDENTIFIED BY '<password_aman>';
GRANT r_dosen_081 TO 'dosen_081'@'localhost';
SET DEFAULT ROLE r_dosen_081 FOR 'dosen_081'@'localhost';

-- B. Role dan Akun Mahasiswa
CREATE ROLE IF NOT EXISTS r_mahasiswa_081;
GRANT SELECT ON akad_081.v_khs_mahasiswa TO r_mahasiswa_081;

CREATE USER IF NOT EXISTS 'mahasiswa_081'@'localhost' IDENTIFIED BY '<password_aman>';
GRANT r_mahasiswa_081 TO 'mahasiswa_081'@'localhost';
SET DEFAULT ROLE r_mahasiswa_081 FOR 'mahasiswa_081'@'localhost';

-- C. Role dan Akun Admin Akademik
CREATE ROLE IF NOT EXISTS r_admin_081;
GRANT SELECT, UPDATE ON akad_081.v_mahasiswa_bermasalah TO r_admin_081;
GRANT SELECT ON akad_081.v_dosen_mahasiswa TO r_admin_081;

CREATE USER IF NOT EXISTS 'admin_081'@'localhost' IDENTIFIED BY '<password_aman>';
GRANT r_admin_081 TO 'admin_081'@'localhost';
SET DEFAULT ROLE r_admin_081 FOR 'admin_081'@'localhost';

-- D. Role dan Akun Kaprodi (menggunakan v_rekap_prodi sesuai file view)
CREATE ROLE IF NOT EXISTS r_kaprodi_081;
GRANT SELECT ON akad_081.v_rekap_prodi TO r_kaprodi_081;
GRANT SELECT ON akad_081.v_mahasiswa_bermasalah TO r_kaprodi_081;

CREATE USER IF NOT EXISTS 'kaprodi_081'@'localhost' IDENTIFIED BY '<password_aman>';
GRANT r_kaprodi_081 TO 'kaprodi_081'@'localhost';
SET DEFAULT ROLE r_kaprodi_081 FOR 'kaprodi_081'@'localhost';