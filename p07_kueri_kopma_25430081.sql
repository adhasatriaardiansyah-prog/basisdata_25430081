-- =================================================================
-- File   : p07_kueri_25430081.sql
-- Nama   : Muhammad Adha Satria Ardiansyah
-- NPM    : 25430081
-- Kelas  : C
-- Modul  : 07 - Menjawab Pertanyaan dengan SELECT dan Fungsi Skalar
-- Basis Data : kopma_081
-- =================================================================

USE kopma_081;

-- -----------------------------------------------------------------
-- KI-01: Pencarian profil anggota berinisial huruf 'a'
-- Pertanyaan: Siapa saja anggota yang namanya mengandung huruf 'a' dan tampilkan nama dalam huruf kapital?
-- Harapan Hasil: Baris data anggota yang memuat huruf 'a' pada nama_anggota, dengan kolom nama berhuruf besar.
-- -----------------------------------------------------------------
SELECT 
    no_anggota, 
    UPPER(nama_anggota) AS nama_kapital, 
    email_anggota
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY nama_anggota ASC;

-- -----------------------------------------------------------------
-- KI-02: Menyaring barang pada rentang harga terjangkau
-- Pertanyaan: Barang apa saja yang harga jualnya berada di rentang Rp2.000 hingga Rp10.000?
-- Harapan Hasil: Daftar barang dengan harga jual di antara 2000 dan 10000 diurutkan dari yang termurah.
-- -----------------------------------------------------------------
SELECT 
    kode_barang, 
    nama_barang, 
    harga_jual_barang
FROM barang
WHERE harga_jual_barang BETWEEN 2000 AND 10000
ORDER BY harga_jual_barang ASC;

-- -----------------------------------------------------------------
-- KI-03: Menyaring barang berdasarkan kelompok kategori pilihan
-- Pertanyaan: Produk apa saja yang termasuk dalam kategori 'Makanan', 'Minuman', atau 'ATK'?
-- Harapan Hasil: Daftar barang yang nilai kategorinya cocok dengan salah satu dari pilihan IN.
-- -----------------------------------------------------------------
SELECT 
    kode_barang, 
    nama_barang, 
    kategori_barang
FROM barang
WHERE kategori_barang IN ('Makanan', 'Minuman', 'ATK')
ORDER BY kategori_barang ASC;

-- -----------------------------------------------------------------
-- KI-04: Mendeteksi kelengkapan kontak anggota
-- Pertanyaan: Siapa saja anggota yang belum memasukkan nomor HP pada sistem?
-- Harapan Hasil: Data anggota yang kolom no_hp_anggota bernilai NULL.
-- -----------------------------------------------------------------
SELECT 
    no_anggota, 
    nama_anggota, 
    alamat_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- -----------------------------------------------------------------
-- KI-05: Pengkategorian tingkat ketersediaan stok barang
-- Pertanyaan: Bagaimana status persediaan barang saat ini jika dikelompokkan secara deskriptif?
-- Harapan Hasil: Tampilan kolom baru 'status_persediaan' berisi label 'Kritis', 'Waspada', atau 'Aman'.
-- -----------------------------------------------------------------
SELECT 
    kode_barang, 
    nama_barang, 
    stok_barang,
    CASE 
        WHEN stok_barang <= 5 THEN 'Kritis'
        WHEN stok_barang <= 15 THEN 'Waspada'
        ELSE 'Aman'
    END AS status_persediaan
FROM barang
ORDER BY stok_barang ASC;

-- -----------------------------------------------------------------
-- KI-06: Menghitung lama masa bergabung anggota
-- Pertanyaan: Berapa hari masa keanggotaan setiap anggota terhitung sejak pendaftaran hingga hari ini?
-- Harapan Hasil: Selisih hari antara tanggal saat ini dan tgl_daftar_anggota menggunakan DATEDIFF.
-- -----------------------------------------------------------------
SELECT 
    no_anggota, 
    nama_anggota, 
    tgl_daftar_anggota,
    DATEDIFF(CURDATE(), tgl_daftar_anggota) AS lama_bergabung_hari
FROM anggota
ORDER BY lama_bergabung_hari DESC;

-- -----------------------------------------------------------------
-- KI-07: Format tanggal pendaftaran anggota versi Indonesia
-- Pertanyaan: Tampilkan tanggal daftar anggota dengan format baku Indonesia (DD-MM-YYYY).
-- Harapan Hasil: Tanggal pendaftaran terformat rapi seperti '25-09-2026'.
-- -----------------------------------------------------------------
SELECT 
    no_anggota, 
    nama_anggota,
    DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y') AS tgl_daftar_formatted
FROM anggota;

-- -----------------------------------------------------------------
-- KI-08: Format penggabungan identitas dan penanganan nilai kosong
-- Pertanyaan: Tampilkan identitas anggota dalam bentuk 'Nama (No)' dan berikan tanda '-' bila nomor HP kosong.
-- Harapan Hasil: Kolom identitas tergabung dan kolom nomor HP tidak menampilkan teks NULL.
-- -----------------------------------------------------------------
SELECT 
    CONCAT(nama_anggota, ' (', no_anggota, ')') AS identitas_anggota,
    IFNULL(no_hp_anggota, '-') AS nomor_telepon
FROM anggota;

-- -----------------------------------------------------------------
-- KI-09: Menyaring nota transaksi nilai tinggi
-- Pertanyaan: Transaksi mana saja yang total belanjaannya lebih dari Rp50.000?
-- Harapan Hasil: Daftar transaksi penjualan di atas Rp50.000 diurutkan dari nominal terbesar.
-- -----------------------------------------------------------------
SELECT 
    no_nota_penjualan, 
    tgl_penjualan, 
    total_penjualan
FROM penjualan
WHERE total_penjualan > 50000
ORDER BY total_penjualan DESC;

-- -----------------------------------------------------------------
-- KI-10: Menhitung estimasi margin keuntungan per unit barang
-- Pertanyaan: Berapa nilai keuntungan (margin) per unit untuk setiap barang?
-- Harapan Hasil: Selisih antara harga jual dan harga beli per barang diurutkan dari margin tertinggi.
-- -----------------------------------------------------------------
SELECT 
    kode_barang, 
    nama_barang, 
    harga_beli_barang, 
    harga_jual_barang,
    (harga_jual_barang - harga_beli_barang) AS margin_keuntungan
FROM barang
ORDER BY margin_keuntungan DESC;

-- =================================================================
-- CATATAN KEBUTUHAN INFORMASI (KI) YANG BELUM DAPAT DIJAWAB 1 TABEL:
-- 1. KI-11: Menampilkan nama barang apa saja yang dibeli pada nomor nota tertentu.
--    Alasan: Membutuhkan penggabungan tabel (JOIN) antara `penjualan`, `detail_penjualan`, dan `barang`.
-- 2. KI-12: Menghitung rekap total pendapatan bulanan berdasarkan kategori barang.
--    Alasan: Membutuhkan JOIN multi-tabel serta pemrosesan pengelompokan agregat (`GROUP BY`).
-- =================================================================