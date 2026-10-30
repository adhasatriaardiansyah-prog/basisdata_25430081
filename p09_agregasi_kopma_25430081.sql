-- =====================================================================
-- Nama      : Muhammad Adha Satria Ardiansyah
-- NIM       : 25430081
-- Kelas     : C (Ilmu Komputer - Universitas Muhammadiyah Metro)
-- File      : p09_agregasi_kopma_25430081.sql
-- Deskripsi : Skrip Praktikum Modul 9 - Meringkas Data dengan Fungsi Agregat dan GROUP BY
-- =====================================================================

-- ---------------------------------------------------------------------
-- D.1 Menyiapkan Mode dan Data
-- ---------------------------------------------------------------------
-- Mengaktifkan mode ketat ONLY_FULL_GROUP_BY untuk sesi ini
SET SESSION sql_mode = CONCAT(@@sql_mode, ', ONLY_FULL_GROUP_BY');

-- Verifikasi jumlah nota dan rentang tanggal penjualan
SELECT COUNT(*) AS nota, MIN(tgl_penjualan) AS awal, MAX(tgl_penjualan) AS akhir 
FROM penjualan;
-- Hasil yang diharapkan: 75 nota, awal '2026-09-02', akhir '2026-10-31'


-- ---------------------------------------------------------------------
-- D.2 Total Satu Nota
-- ---------------------------------------------------------------------
SELECT p.no_nota_penjualan, SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS jumlah
FROM penjualan p 
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.no_nota_penjualan = 'PJ-2609-0001'
GROUP BY p.id_penjualan, p.no_nota_penjualan;

/*
TITIK ANALISIS 1:
Jika p.no_nota_penjualan dihapus dari GROUP BY (hanya menyisakan p.id_penjualan):
ERROR 1055 (42000): 'kopma.p.no_nota_penjualan' isn't in GROUP BY ...
Penjelasan: Meskipun secara logika 1 id_penjualan pasti bernilai 1 no_nota_penjualan, 
mode ONLY_FULL_GROUP_BY menuntut agar setiap kolom non-agregat di SELECT wajib masuk ke GROUP BY. 
Hal ini mencegah ambiguitas data jika ada skenario kolom non-agregat memiliki nilai yang bervariasi.
*/


-- ---------------------------------------------------------------------
-- D.3 Laporan Omzet Harian dan Bulanan (KI-01)
-- ---------------------------------------------------------------------
-- 4. Omzet harian minggu pertama September dengan WITH ROLLUP
SELECT DATE(p.tgl_penjualan) AS tanggal,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01' AND p.tgl_penjualan < '2026-09-08'
GROUP BY DATE(p.tgl_penjualan) WITH ROLLUP;

/*
TITIK ANALISIS 2:
Mengapa memakai COUNT(DISTINCT p.id_penjualan) bukannya COUNT(*)?
- COUNT(*) menghitung jumlah BARIS dari hasil JOIN penjualan dan detail_penjualan.
- Karena 1 nota bisa berisi banyak detail barang (relasi 1-to-N), COUNT(*) akan menghitung 
  jumlah detail item yang terjual, BUKAN jumlah nota.
- COUNT(DISTINCT p.id_penjualan) memastikan bahwa id_penjualan yang sama hanya dihitung 1 kali.
*/

-- 5. Ubah pengelompokan menjadi per bulan
SELECT DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
GROUP BY DATE_FORMAT(p.tgl_penjualan, '%Y-%m');
-- Hasil yang diharapkan: 
-- September 2026: 39 nota, Rp691.000,00
-- Oktober 2026: 36 nota, Rp507.500,00


-- ---------------------------------------------------------------------
-- D.4 Menyaring Kelompok dengan HAVING
-- ---------------------------------------------------------------------
-- 6. Tampilkan kasir yang melayani lebih dari 20 nota
SELECT pt.kode_petugas, pt.nama_petugas, COUNT(*) AS nota
FROM penjualan p 
JOIN petugas pt ON pt.id_petugas = p.id_petugas
GROUP BY pt.id_petugas, pt.kode_petugas, pt.nama_petugas
HAVING COUNT(*) > 20;

/*
TITIK ANALISIS 3:
Syarat "anggota saja" untuk menghitung rata-rata belanja per nota harus ditulis di WHERE atau HAVING?
Jawab: Harus ditulis di WHERE.
Penjelasan Evaluasi SQL:
1. FROM / JOIN (menggabungkan tabel)
2. WHERE (menyaring baris sebelum dikelompokkan -> membuang nota non-anggota/p.id_anggota IS NOT NULL)
3. GROUP BY (mengelompokkan data anggota)
4. HAVING (menyaring hasil kelompok setelah diagregasi)
Menyaring anggota di WHERE jauh lebih efisien karena mengeliminasi baris sebelum agregasi diproses.
*/

-- Kueri Rata-rata Belanja Per Nota untuk Anggota saja:
SELECT p.id_anggota,
       COUNT(DISTINCT p.id_penjualan) AS total_nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) / COUNT(DISTINCT p.id_penjualan) AS avg_belanja_per_nota
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.id_anggota IS NOT NULL
GROUP BY p.id_anggota;


-- ---------------------------------------------------------------------
-- E. Latihan dan Modifikasi
-- ---------------------------------------------------------------------
-- E.1 Total nota lengkap dengan diskon 5% untuk anggota aktif (misal anggota dengan ID tertentu/seluruh anggota)
-- Membandingkan total setelah diskon dengan bayar_penjualan, lalu menampilkan kembalian > 4000.
SELECT p.no_nota_penjualan,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS total_kotor,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) * 0.95 AS total_bersih_diskon,
       p.bayar_penjualan,
       (p.bayar_penjualan - (SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) * 0.95)) AS kembalian
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.id_anggota IS NOT NULL
GROUP BY p.id_penjualan, p.no_nota_penjualan, p.bayar_penjualan
HAVING kembalian > 4000;

-- E.2 Omzet per kategori barang per bulan dengan WITH ROLLUP
SELECT DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
       b.kategori_barang,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
JOIN barang b ON b.id_barang = d.id_barang
GROUP BY DATE_FORMAT(p.tgl_penjualan, '%Y-%m'), b.kategori_barang WITH ROLLUP;

/*
Penjelasan Nilai NULL pada ROLLUP:
- Kolom kategori_barang = NULL (dengan bulan terisi): Menunjukkan Subtotal Omzet untuk bulan tersebut secara keseluruhan.
- Kolom bulan = NULL dan kategori_barang = NULL: Menunjukkan Grand Total Omzet untuk seluruh bulan dan kategori.
*/