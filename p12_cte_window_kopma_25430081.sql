-- =====================================================================
-- Nama        : Muhamad Adha Satria Ardiansyah
-- NPM         : 25430081
-- Kelas       : C
-- Mata Kuliah : Praktikum Basis Data (Modul 12)
-- Berkas      : p12_cte_window_25430081.sql
-- Deskripsi   : CTE dan Window Function untuk Peringkat dan Tren Kopma
-- =====================================================================

USE kopma_081;

-- =====================================================================
-- 1. Peringkat Omzet Barang per Kategori
-- =====================================================================
-- Menggunakan RANK() untuk memberikan peringkat omzet tertinggi per kategori.
-- Jika terdapat omzet yang bernilai sama, RANK() memberikan peringkat yang sama
-- dengan melompati nomor urut berikutnya.
WITH omzet_barang AS (
    SELECT 
        b.kategori_barang, 
        b.nama_barang, 
        SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
    FROM detail_penjualan d 
    JOIN barang b ON b.id_barang = d.id_barang
    GROUP BY b.id_barang, b.kategori_barang, b.nama_barang
),
peringkat_kategori AS (
    SELECT 
        kategori_barang, 
        nama_barang, 
        omzet,
        RANK() OVER (PARTITION BY kategori_barang ORDER BY omzet DESC) AS peringkat
    FROM omzet_barang
)
SELECT 
    kategori_barang, 
    nama_barang, 
    omzet, 
    peringkat
FROM peringkat_kategori
ORDER BY kategori_barang, peringkat;


-- =====================================================================
-- 2. Hari Tanpa Penjualan (CTE Rekursif)
-- =====================================================================
-- Membangkitkan deret tanggal 1-14 Oktober 2026 secara rekursif untuk 
-- mengidentifikasi hari di mana Kopma tidak mencatat transaksi penjualan.
WITH RECURSIVE kalender AS (
    SELECT DATE('2026-10-01') AS tgl_kalender
    UNION ALL
    SELECT tgl_kalender + INTERVAL 1 DAY 
    FROM kalender 
    WHERE tgl_kalender < '2026-10-14'
)
SELECT 
    k.tgl_kalender, 
    COUNT(p.id_penjualan) AS nota,
    CASE 
        WHEN DAYOFWEEK(k.tgl_kalender) = 1 THEN 'Toko Tutup (Minggu)'
        ELSE 'Buka Tanpa Penjualan'
    END AS status_hari
FROM kalender k
LEFT JOIN penjualan p ON DATE(p.tgl_penjualan) = k.tgl_kalender
GROUP BY k.tgl_kalender
HAVING nota = 0
ORDER BY k.tgl_kalender;


-- =====================================================================
-- 3. Total Berjalan (Running Total) dan Perubahan Harian
-- =====================================================================
-- Menghitung omzet harian 1-10 Oktober 2026, akumulasi omzet kumulatif 
-- (SUM OVER), dan perubahan/selisih terhadap hari penjualan sebelumnya (LAG).
WITH harian AS (
    SELECT 
        DATE(p.tgl_penjualan) AS tanggal,
        SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
    FROM penjualan p 
    JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
    WHERE p.tgl_penjualan >= '2026-10-01' AND p.tgl_penjualan < '2026-10-11'
    GROUP BY DATE(p.tgl_penjualan)
)
SELECT 
    tanggal, 
    omzet,
    SUM(omzet) OVER (ORDER BY tanggal) AS kumulatif,
    LAG(omzet, 1) OVER (ORDER BY tanggal) AS omzet_sebelumnya,
    omzet - LAG(omzet, 1) OVER (ORDER BY tanggal) AS selisih
FROM harian
ORDER BY tanggal;


-- =====================================================================
-- 4. Nota Belanja Terbesar per Anggota (ROW_NUMBER)
-- =====================================================================
-- Menggunakan ROW_NUMBER() untuk memilih tepat satu transaksi (nota) dengan
-- nilai belanja terbesar untuk setiap anggota Kopma.
WITH ranked_nota AS (
    SELECT 
        id_anggota, 
        id_penjualan, 
        tgl_penjualan, 
        total_penjualan,
        ROW_NUMBER() OVER (PARTITION BY id_anggota ORDER BY total_penjualan DESC, id_penjualan ASC) AS rn
    FROM penjualan
)
SELECT 
    id_anggota, 
    id_penjualan, 
    tgl_penjualan, 
    total_penjualan
FROM ranked_nota
WHERE rn = 1
ORDER BY id_anggota;


-- =====================================================================
-- 5. Pangsa Omzet Kategori Terhadap Total Bulanan (%)
-- =====================================================================
-- Menghitung persentase kontribusi omzet tiap kategori barang terhadap total 
-- omzet bulanan menggunakan SUM() OVER (PARTITION BY bulan).
WITH omzet_kategori_bulanan AS (
    SELECT 
        DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
        b.kategori_barang,
        SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet_kategori
    FROM penjualan p
    JOIN detail_penjualan d ON p.id_penjualan = d.id_penjualan
    JOIN barang b ON d.id_barang = b.id_barang
    GROUP BY bulan, b.kategori_barang
)
SELECT 
    bulan, 
    kategori_barang, 
    omzet_kategori,
    SUM(omzet_kategori) OVER (PARTITION BY bulan) AS total_omzet_bulan,
    ROUND((omzet_kategori / SUM(omzet_kategori) OVER (PARTITION BY bulan)) * 100, 2) AS pangsa_persen
FROM omzet_kategori_bulanan
ORDER BY bulan, omzet_kategori DESC;