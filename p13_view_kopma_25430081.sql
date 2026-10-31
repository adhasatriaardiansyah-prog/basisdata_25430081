-- ==========================================================
-- Berkas: p13_view_25430081.sql
-- Nama : Muhammad Adha Satria Ardiansyah
-- NPM  : 25430081 / Kelas C
-- Modul: 13 - View dan Perancangan Kueri per Peran (Kopma)
-- ==========================================================

USE kopma_081;

-- 1. View Kasir: v_kasir_anggota (menyembunyikan no_hp_anggota & tgl_daftar_anggota)
CREATE OR REPLACE VIEW v_kasir_anggota AS
SELECT id_anggota, no_anggota, nim_anggota, nama_anggota, status_anggota 
FROM anggota;

-- 2. View Kasir: v_kasir_barang (menyembunyikan stok_min_barang)
CREATE OR REPLACE VIEW v_kasir_barang AS
SELECT kode_barang, nama_barang, harga_jual_barang, stok_barang 
FROM barang;

-- 3. View Gudang: v_barang_menipis (menyembunyikan harga_jual_barang, dengan WITH CHECK OPTION)
CREATE OR REPLACE VIEW v_barang_menipis AS
SELECT kode_barang, nama_barang, stok_barang, stok_min_barang 
FROM barang 
WHERE stok_barang < stok_min_barang 
WITH CHECK OPTION;

-- 4. View Ketua: v_omzet_harian (rekap omzet dan jumlah nota per hari)
CREATE OR REPLACE VIEW v_omzet_harian AS
SELECT 
    DATE(tanggal_nota) AS tanggal,
    COUNT(id_nota) AS jumlah_nota,
    SUM(total_harga) AS total_omzet
FROM nota
GROUP BY DATE(tanggal_nota);