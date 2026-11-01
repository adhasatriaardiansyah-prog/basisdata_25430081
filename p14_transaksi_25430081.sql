-- =====================================================================
-- Nama File  : p14_transaksi_25430081.sql
-- Deskripsi  : Skrip Transaksi dan Integritas Data Proyek Akademik (Milestone 14)
-- NPM        : 25430081
-- Nama       : Muhamad Adha Satria Ardiansyah
-- =====================================================================

USE akad_081;

-- ---------------------------------------------------------------------
-- SKENARIO 1: COMMIT (Transaksi Pengisian KRS Berhasil)
-- Kondisi: Mahasiswa melakukan pengajuan KRS dan kuota kelas masih mencukupi.
-- ---------------------------------------------------------------------
START TRANSACTION;

-- 1. Sisipkan data pengajuan KRS ke tabel `krs`
INSERT INTO krs (no_krs, id_mhs, tahun_ajaran_krs, semester_krs, tgl_pengajuan_krs, status_persetujuan_krs)
VALUES ('KRS-2026-081', 1, '2026/2027', 'Ganjil', '2026-11-01', 'Diproses');

SET @id_krs_baru := LAST_INSERT_ID();

-- 2. Kurangi/cek kapasitas kuota di tabel `kelas` (misal id_kelas = 1)
-- Syarat: kuota saat ini masih di bawah batas maksimal (misal kuota_kelas < 40)
UPDATE kelas 
SET kuota_kelas = kuota_kelas - 1 
WHERE id_kelas = 1 AND kuota_kelas > 0;

-- 3. Periksa keberhasilan update menggunakan ROW_COUNT()
-- Jika bernilai 1, baris berhasil diubah (kuota tersedia)
SELECT ROW_COUNT() AS status_kuota;

-- 4. Karena berhasil, simpan permanen perubahan dengan COMMIT
COMMIT;
SELECT 'Skenario 1 BERHASIL: Transaksi di-COMMIT.' AS keterangan;


-- ---------------------------------------------------------------------
-- SKENARIO 2: ROLLBACK (Transaksi Dibatalkan karena Kuota Kelas Penuh)
-- Kondisi: Melanggar aturan bisnis (kuota kelas sudah habis / 0).
-- ---------------------------------------------------------------------
START TRANSACTION;

-- 1. Upaya insert pengajuan KRS baru
INSERT INTO krs (no_krs, id_mhs, tahun_ajaran_krs, semester_krs, tgl_pengajuan_krs, status_persetujuan_krs)
VALUES ('KRS-2026-082', 2, '2026/2027', 'Ganjil', '2026-11-01', 'Diproses');

SET @id_krs_gagal := LAST_INSERT_ID();

-- 2. Upaya mengurangi kuota pada kelas yang sudah penuh (misal id_kelas = 2 di mana kuota = 0)
UPDATE kelas 
SET kuota_kelas = kuota_kelas - 1 
WHERE id_kelas = 2 AND kuota_kelas > 0;

-- 3. Periksa ROW_COUNT() -> akan bernilai 0 karena syarat kuota > 0 tidak terpenuhi
SELECT ROW_COUNT() AS status_kuota_gagal;

-- 4. Karena melanggar aturan bisnis (gagal update stok/kuota), batalkan seluruh transaksi
ROLLBACK;
SELECT 'Skenario 2 DIBATALKAN: Transaksi di-ROLLBACK karena kuota kelas penuh.' AS keterangan;