-- ============================================================
-- Modul 10: Menghubungkan Tabel dengan JOIN
-- Nama : Muhamad Adha Satria Ardiansyah
-- NPM  : 25430081
-- Kelas: C
-- File : p10_join_kopma_25430081.sql
-- ============================================================

USE kopma_081;

-- ------------------------------------------------------------
-- D.1 INNER JOIN: Barang Terlaris (KI-02)
-- Jalur ERD: barang -> detail_penjualan -> penjualan
-- ------------------------------------------------------------
SELECT 
    b.kode_barang, 
    b.nama_barang, 
    SUM(d.qty_detail_penjualan) AS terjual
FROM detail_penjualan d
JOIN barang b ON b.id_barang = d.id_barang
JOIN penjualan p ON p.id_penjualan = d.id_penjualan
WHERE p.tgl_penjualan >= '2026-10-01' AND p.tgl_penjualan < '2026-11-01'
GROUP BY b.id_barang, b.kode_barang, b.nama_barang
ORDER BY terjual DESC
LIMIT 5;


-- ------------------------------------------------------------
-- D.2 JOIN Tiga Tabel: Anggota Belanja Terbesar (KI-04)
-- Jalur ERD: anggota -> penjualan -> detail_penjualan
-- ------------------------------------------------------------
SELECT 
    a.no_anggota, 
    a.nama_anggota,
    COUNT(DISTINCT p.id_penjualan) AS nota,
    SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS belanja
FROM anggota a
JOIN penjualan p ON p.id_anggota = a.id_anggota
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
GROUP BY a.id_anggota, a.no_anggota, a.nama_anggota
ORDER BY belanja DESC
LIMIT 5;


-- ------------------------------------------------------------
-- D.3 LEFT JOIN: Barang Belum Terjual
-- Jalur ERD: barang -> detail_penjualan
-- ------------------------------------------------------------
SELECT 
    b.kode_barang, 
    b.nama_barang, 
    COUNT(d.id_barang) AS baris_terjual
FROM barang b
LEFT JOIN detail_penjualan d ON d.id_barang = b.id_barang
GROUP BY b.id_barang, b.kode_barang, b.nama_barang
HAVING COUNT(d.id_barang) = 0;


-- ------------------------------------------------------------
-- D.4 Membuktikan Perkalian Kartesius
-- ------------------------------------------------------------
-- Tanpa syarat penggabungan (Perkalian Kartesius = 10.950 baris)
SELECT COUNT(*) FROM penjualan, detail_penjualan;

-- Dengan syarat penggabungan (Hasil yang benar = 146 baris)
SELECT COUNT(*) 
FROM penjualan p 
JOIN detail_penjualan d ON p.id_penjualan = d.id_penjualan;


-- ------------------------------------------------------------
-- E.1 Latihan: Nota Oktober beserta Kasir dan Anggota (Termasuk "Umum")
-- Jalur ERD: kasir -> penjualan <- anggota
-- ------------------------------------------------------------
SELECT 
    p.no_nota,
    p.tgl_penjualan,
    k.nama_kasir,
    IFNULL(a.nama_anggota, 'Umum') AS nama_anggota
FROM penjualan p
JOIN kasir k ON k.id_kasir = p.id_kasir
LEFT JOIN anggota a ON a.id_anggota = p.id_anggota
WHERE p.tgl_penjualan >= '2026-10-01' AND p.tgl_penjualan < '2026-11-01'
ORDER BY p.tgl_penjualan ASC;


-- ------------------------------------------------------------
-- E.2 Latihan: Bukti Perubahan Harga Pulpen Gel 0.5 (AB-04)
-- Jalur ERD: barang -> detail_penjualan -> penjualan
-- ------------------------------------------------------------
SELECT 
    p.no_nota,
    p.tgl_penjualan,
    b.nama_barang,
    d.harga_satuan_detail_penjualan AS harga_transaksi,
    b.harga_jual_barang AS harga_master_saat_ini
FROM detail_penjualan d
JOIN barang b ON b.id_barang = d.id_barang
JOIN penjualan p ON p.id_penjualan = d.id_penjualan
WHERE b.nama_barang LIKE '%Pulpen Gel 0.5%'
ORDER BY p.tgl_penjualan ASC;