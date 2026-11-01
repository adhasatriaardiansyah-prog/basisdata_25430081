-- =====================================================================
-- Nama File  : p14_transaksi_kopma_25430081.sql
-- Deskripsi  : Praktikum Modul 14 - Transaksi dan Integritas Data Kopma
-- NPM        : 25430081
-- Nama       : Muhamad Adha Satria Ardiansyah
-- =====================================================================

USE kopma_123;

-- ---------------------------------------------------------------------
-- D.1 Transaksi Penjualan dengan Pemeriksaan Stok
-- ---------------------------------------------------------------------

-- Skenario A: Transaksi Penjualan 10 Roti Cokelat (Stok Tidak Cukup -> ROLLBACK)
START TRANSACTION;

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2611-0900', '2026-11-01 09:00:00', 3, 4, 50000);

SET @id := LAST_INSERT_ID();

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT @id, id_barang, 10, harga_jual_barang 
FROM barang 
WHERE kode_barang = 'MKN-001';

UPDATE barang 
SET stok_barang = stok_barang - 10
WHERE kode_barang = 'MKN-001' AND stok_barang >= 10;

-- Periksa jumlah baris yang terpengaruh (ROW_COUNT() = 0 berarti stok kurang)
SELECT ROW_COUNT() AS baris_stok_berubah;

-- Dibatalkan karena ROW_COUNT() = 0
ROLLBACK;


-- Skenario B: Ulangi Penjualan dengan qty = 2 (Stok Cukup -> COMMIT)
START TRANSACTION;

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2611-0901', '2026-11-01 09:05:00', 3, 4, 15000);

SET @id2 := LAST_INSERT_ID();

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT @id2, id_barang, 2, harga_jual_barang 
FROM barang 
WHERE kode_barang = 'MKN-001';

UPDATE barang 
SET stok_barang = stok_barang - 2
WHERE kode_barang = 'MKN-001' AND stok_barang >= 2;

-- Periksa jumlah baris yang terpengaruh (ROW_COUNT() = 1)
SELECT ROW_COUNT() AS baris_stok_berubah;

-- Disimpan permanen karena stok mencukupi
COMMIT;


-- ---------------------------------------------------------------------
-- D.2 Galat Tidak Menutup Transaksi
-- ---------------------------------------------------------------------
START TRANSACTION;

-- Perintah ini memicu ERROR 4025 jika melanggar CHECK constraint
UPDATE barang 
SET stok_barang = stok_barang - 10 
WHERE kode_barang = 'MKN-001';

-- Memeriksa bahwa transaksi MASIH terbuka (hasil: 1)
SELECT @@in_transaction AS status_transaksi;

-- Menutup transaksi yang mengalami galat dengan ROLLBACK
ROLLBACK;


-- ---------------------------------------------------------------------
-- D.4 Commit Implisit dan Savepoint
-- ---------------------------------------------------------------------

-- Demonstrasi Commit Implisit (Perintah DDL memicu Commit Implisit)
START TRANSACTION;

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2611-TEST', NOW(), 3, 4, 10000);

-- Perintah DDL murni yang memicu commit implisit
CREATE TABLE uji_commit (x INT);

-- ROLLBACK tidak dapat membatalkan INSERT penjualan di atas
ROLLBACK;

-- Pembersihan (Cleanup)
DELETE FROM penjualan WHERE no_nota_penjualan = 'PJ-2611-TEST';
DROP TABLE IF EXISTS uji_commit;


-- Demonstrasi SAVEPOINT
START TRANSACTION;

-- Tambah stok pulpen +1
UPDATE barang 
SET stok_barang = stok_barang + 1 
WHERE kode_barang = 'ATK-001';

-- Buat titik simpan (Savepoint)
SAVEPOINT sp_tambah_satu;

-- Tambah stok pulpen +100
UPDATE barang 
SET stok_barang = stok_barang + 100 
WHERE kode_barang = 'ATK-001';

-- Batalkan perubahan setelah savepoint (tambahan 100 dibatalkan)
ROLLBACK TO SAVEPOINT sp_tambah_satu;

-- Commit perubahan sebelum savepoint (stok akhir hanya bertambah 1)
COMMIT;


-- ---------------------------------------------------------------------
-- E. Latihan dan Modifikasi
-- ---------------------------------------------------------------------

-- E.1 Transaksi Penerimaan Barang dari Pemasok
START TRANSACTION;

-- Ubah status pembelian hanya jika statusnya 'dipesan'
UPDATE pembelian 
SET status_pembelian = 'diterima' 
WHERE id_pembelian = 101 AND status_pembelian = 'dipesan';

-- Ambil jumlah baris yang ter-update
SET @pembelian_valid := ROW_COUNT();

-- Tambahkan stok barang berdasarkan detail jika status berhasil diubah
UPDATE barang b
JOIN detail_pembelian dp ON b.id_barang = dp.id_barang
SET b.stok_barang = b.stok_barang + dp.qty_pembelian
WHERE dp.id_pembelian = 101 AND @pembelian_valid > 0;

-- Keputusan: Lakukan COMMIT jika status valid, sebaliknya ROLLBACK
-- (Sesuai penanganan di aplikasi / prosedur)
COMMIT;


-- E.2 Transaksi Nota Tiga Barang dengan Batas Item P+2 (P=1, Maks 3 Item)
START TRANSACTION;

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2611-0902', NOW(), 3, 4, 30000);

SET @id_nota := LAST_INSERT_ID();

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
VALUES 
(@id_nota, 1, 1, 5000),
(@id_nota, 2, 2, 10000),
(@id_nota, 3, 1, 15000);

-- Hitung jumlah detail item yang baru dimasukkan
SELECT COUNT(*) INTO @total_item 
FROM detail_penjualan 
WHERE id_penjualan = @id_nota;

-- Jika @total_item <= 3 maka COMMIT, jika > 3 maka ROLLBACK
COMMIT;