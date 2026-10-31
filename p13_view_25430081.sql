-- ==========================================================
-- Berkas: p13_view_25430081.sql
-- Nama : Muhamad Adha Satria Ardiansyah
-- NPM  : 25430081
-- Kelas : C
-- Modul: 13 - View dan Perancangan Kueri per Peran (Akademik)
-- ==========================================================

USE akad_081;

-- 1. View Dosen: v_dosen_mahasiswa (menyembunyikan no_hp_mahasiswa & email_pribadi_mahasiswa)
CREATE OR REPLACE VIEW v_dosen_mahasiswa AS
SELECT id_mhs, npm_mahasiswa, nama_mahasiswa, prodi_mahasiswa, angkatan_mahasiswa, status_aktif_mahasiswa 
FROM mahasiswa;

-- 2. View Mahasiswa: v_khs_mahasiswa (menampilkan rekap KRS/mata kuliah mahasiswa via tabel kelas)
CREATE OR REPLACE VIEW v_khs_mahasiswa AS
SELECT m.npm_mahasiswa, m.nama_mahasiswa, mk.kode_mk, mk.nama_mk, mk.sks_mk
FROM mahasiswa m
JOIN krs k ON m.id_mhs = k.id_mhs
JOIN detail_krs dk ON k.id_krs = dk.id_krs
JOIN kelas k_ls ON dk.id_kelas = k_ls.id_kelas
JOIN mata_kuliah mk ON k_ls.id_mk = mk.id_mk;

-- 3. View Admin Akademik: v_mahasiswa_bermasalah (dengan WITH CHECK OPTION)
CREATE OR REPLACE VIEW v_mahasiswa_bermasalah AS
SELECT id_mhs, npm_mahasiswa, nama_mahasiswa, prodi_mahasiswa, status_aktif_mahasiswa
FROM mahasiswa
WHERE status_aktif_mahasiswa = 'Cuti' OR status_aktif_mahasiswa = 'Non-Aktif'
WITH CHECK OPTION;

-- 4. View Kaprodi: v_rekap_prodi (rekap jumlah mahasiswa per program studi)
CREATE OR REPLACE VIEW v_rekap_prodi AS
SELECT 
    prodi_mahasiswa,
    angkatan_mahasiswa,
    COUNT(id_mhs) AS jumlah_mahasiswa
FROM mahasiswa
GROUP BY prodi_mahasiswa, angkatan_mahasiswa;