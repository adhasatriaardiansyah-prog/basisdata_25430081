-- =================================================================
-- Nama        : Muhamad Adha Satria Ardiansyah
-- NPM         : 25430081
-- Kelas       : C
-- Matakuliah  : Praktikum Basis Data (Modul 11)
-- Berkas      : p11_subquery_kopma_25430081.sql
-- =================================================================

USE kopma_081;

-- -----------------------------------------------------------------
-- D. LANGKAH PERCOBAAN
-- -----------------------------------------------------------------

-- D.1 Subquery Skalar
-- 1. Tampilkan barang yang harganya di atas rata-rata semua barang.
SELECT kode_barang, nama_barang, harga_jual_barang
FROM barang
WHERE harga_jual_barang > (SELECT AVG(harga_jual_barang) FROM barang)
ORDER BY harga_jual_barang DESC;


-- D.2 NOT IN dibandingkan NOT EXISTS
-- 2. Cari anggota yang tidak pernah berbelanja dengan dua cara.

-- Cara 1: NOT IN (Hasil: 0 baris karena jebakan NULL)
SELECT no_anggota, nama_anggota 
FROM anggota
WHERE id_anggota NOT IN (SELECT id_anggota FROM penjualan);

-- Cara 2: NOT EXISTS (Hasil: A-0459 dan A-0466)
SELECT a.no_anggota, a.nama_anggota, a.status_anggota 
FROM anggota a
WHERE NOT EXISTS (
    SELECT 1 
    FROM penjualan p 
    WHERE p.id_anggota = a.id_anggota
);

-- Perbaikan Cara 1 (Titik Analisis 1: Menghindari jebakan NULL tanpa mengganti NOT IN)
SELECT no_anggota, nama_anggota 
FROM anggota
WHERE id_anggota NOT IN (
    SELECT id_anggota 
    FROM penjualan 
    WHERE id_anggota IS NOT NULL
);


-- D.3 Tabel Turunan (Derived Table)
-- 3. Hitung rata-rata total per nota.
SELECT ROUND(AVG(t.total), 0) AS rata_nota
FROM (
    SELECT d.id_penjualan, SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS total
    FROM detail_penjualan d 
    GROUP BY d.id_penjualan
) AS t;


-- D.4 Operasi Himpunan
-- 4a. Barang yang pernah dibeli dari pemasok dan pernah terjual (INTERSECT)
SELECT id_barang FROM detail_pembelian
INTERSECT
SELECT id_barang FROM detail_penjualan;

-- 4b. Barang yang dibeli tetapi belum pernah terjual (EXCEPT) -> Hasil: id_barang 12
SELECT id_barang FROM detail_pembelian
EXCEPT
SELECT id_barang FROM detail_penjualan;


-- -----------------------------------------------------------------
-- E. LATIHAN DAN MODIFIKASI
-- -----------------------------------------------------------------

-- E.1 Tulis ulang kueri INTERSECT memakai IN dan EXISTS
-- Versi IN:
SELECT DISTINCT id_barang 
FROM detail_pembelian
WHERE id_barang IN (
    SELECT id_barang 
    FROM detail_penjualan
);

-- Versi EXISTS:
SELECT DISTINCT dp.id_barang 
FROM detail_pembelian dp
WHERE EXISTS (
    SELECT 1 
    FROM detail_penjualan pj 
    WHERE pj.id_barang = dp.id_barang
);

-- E.2 Daftar kontak gabungan anggota dan pemasok dengan UNION ALL (diurutkan berdasarkan nama)
SELECT nama_anggota AS nama, telepon_anggota AS telepon, 'Anggota' AS jenis
FROM anggota
UNION ALL
SELECT nama_pemasok AS nama, telepon_pemasok AS telepon, 'Pemasok' AS jenis
FROM pemasok
ORDER BY nama;