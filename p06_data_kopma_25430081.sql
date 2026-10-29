-- =====================================================================
-- Nama      : Muhamad Adha Satria Ardiansyah
-- NPM       : 25430081
-- Kelas     : C
-- Universitas : Universitas Muhammadiyah Metro
-- Mata Kuliah : Basis Data 
-- Berkas    : p06_data_25430081.sql
-- =====================================================================

USE kopma_081;

-- Pastikan mode aman aktif untuk latihan pengujian DML
SET SESSION sql_safe_updates = 1;

-- =====================================================================
-- 1. PENGISIAN DATA INDUK (MASTER TABLES) - Minimal 5 Baris per Tabel
-- =====================================================================

-- A. Data Petugas
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
('K01', 'Muhammad Adha', 'kasir'),
('K02', 'Siti Aminah', 'kasir'),
('K03', 'Budi Santoso', 'kasir'),
('G01', 'Joko Susilo', 'gudang'),
('P01', 'Dewi Lestari', 'ketua');

-- B. Data Anggota (Termasuk anggota nonaktif yang mendaftar sebelum 2025)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, status_anggota, tgl_daftar_anggota, no_hp_anggota) VALUES
('AGT-001', '25430081', 'Muhamad Adha Satria', 'Ilmu Komputer', 'aktif', '2024-08-15', '081234567801'),
('AGT-002', '25430082', 'Ahmad Fauzi', 'Ilmu Komputer', 'aktif', '2024-09-01', '081234567802'),
('AGT-003', '25430083', 'Rina Melati', 'Manajemen', 'nonaktif', '2023-02-10', '081234567803'),
('AGT-004', '25430084', 'Doni Pratama', 'Akuntansi', 'aktif', '2025-01-12', '081234567804'),
('AGT-005', '25430085', 'Sari Wulandari', 'Ilmu Komputer', 'aktif', '2025-02-20', '081234567805');

-- C. Data Pemasok
INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
('CV. Berkah Jaya', '081111222333', 'Jl. Jenderal Sudirman No. 10, Metro Pusat'),
('PT. Maju Mandiri', '082222333444', 'Jl. AH. Nasution No. 45, Bandar Lampung'),
('UD. Sumber Pangan', '083333444555', 'Jl. Ki Hajar Dewantara No. 12, Metro Timur'),
('Toko Grosir Kita', '084444555666', 'Jl. Comal No. 8, Metro Selatan'),
('Distributor ATK Pelajar', '085555666777', 'Jl. Flores No. 22, Metro Barat');

-- D. Data Barang
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 150, 20),
('ATK-002', 'Buku Tulis 58 Lembar', 'ATK', 6500, 100, 20),
('MNM-001', 'Air Mineral 600ml', 'minuman', 4000, 120, 24),
('MKN-001', 'Roti Cokelat Keju', 'makanan', 5000, 80, 15),
('ATK-003', 'Pensil 2B Faber', 'ATK', 3000, 90, 15);


-- =====================================================================
-- 2. PENGISIAN DATA PEMBELIAN (STOK MASUK DARI PEMASOK)
-- =====================================================================

INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, id_petugas, status_pembelian) VALUES
('FK-2610-001', '2026-09-20', 1, 4, 'diterima'),
('FK-2610-002', '2026-09-22', 2, 4, 'diterima');

INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian) VALUES
(1, 1, 100, 3200),
(1, 2, 80, 5200),
(2, 3, 100, 3000),
(2, 4, 60, 3800);


-- =====================================================================
-- 3. PENGISIAN DATA PENJUALAN (TRANSAKSI KASIR - 80 BARIS SESUAI P=8)
-- Tersebar pada 3 Tanggal Berbeda: 2026-10-01, 2026-10-02, 2026-10-03
-- =====================================================================

-- --- TANGGAL 1: 2026-10-01 (Nota 1 s.d. 30) ---
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
('PJ-2610-001', '2026-10-01 08:15:00', 1, 1, 20000),
('PJ-2610-002', '2026-10-01 08:30:00', 1, 2, 15000),
('PJ-2610-003', '2026-10-01 08:45:00', 2, 3, 10000),
('PJ-2610-004', '2026-10-01 09:00:00', 2, 4, 25000),
('PJ-2610-005', '2026-10-01 09:12:00', 1, 5, 12000),
('PJ-2610-006', '2026-10-01 09:30:00', 3, NULL, 8000),
('PJ-2610-007', '2026-10-01 09:45:00', 1, 1, 30000),
('PJ-2610-008', '2026-10-01 10:00:00', 2, 2, 14000),
('PJ-2610-009', '2026-10-01 10:15:00', 3, 3, 22000),
('PJ-2610-010', '2026-10-01 10:30:00', 1, 4, 18000),
('PJ-2610-011', '2026-10-01 10:45:00', 2, 5, 16000),
('PJ-2610-012', '2026-10-01 11:00:00', 3, NULL, 20000),
('PJ-2610-013', '2026-10-01 11:15:00', 1, 1, 25000),
('PJ-2610-014', '2026-10-01 11:30:00', 2, 2, 15000),
('PJ-2610-015', '2026-10-01 11:45:00', 3, 3, 12000),
('PJ-2610-016', '2026-10-01 13:00:00', 1, 4, 30000),
('PJ-2610-017', '2026-10-01 13:15:00', 2, 5, 10000),
('PJ-2610-018', '2026-10-01 13:30:00', 3, NULL, 15000),
('PJ-2610-019', '2026-10-01 13:45:00', 1, 1, 20000),
('PJ-2610-020', '2026-10-01 14:00:00', 2, 2, 18000),
('PJ-2610-021', '2026-10-01 14:15:00', 3, 3, 22000),
('PJ-2610-022', '2026-10-01 14:30:00', 1, 4, 16000),
('PJ-2610-023', '2026-10-01 14:45:00', 2, 5, 25000),
('PJ-2610-024', '2026-10-01 15:00:00', 3, NULL, 12000),
('PJ-2610-025', '2026-10-01 15:15:00', 1, 1, 14000),
('PJ-2610-026', '2026-10-01 15:30:00', 2, 2, 20000),
('PJ-2610-027', '2026-10-01 15:45:00', 3, 3, 30000),
('PJ-2610-028', '2026-10-01 16:00:00', 1, 4, 15000),
('PJ-2610-029', '2026-10-01 16:15:00', 2, 5, 18000),
('PJ-2610-030', '2026-10-01 16:30:00', 3, NULL, 24000);

-- --- TANGGAL 2: 2026-10-02 (Nota 31 s.d. 55) ---
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
('PJ-2610-031', '2026-10-02 08:30:00', 1, 1, 20000),
('PJ-2610-032', '2026-10-02 08:45:00', 2, 2, 15000),
('PJ-2610-033', '2026-10-02 09:00:00', 3, 3, 25000),
('PJ-2610-034', '2026-10-02 09:15:00', 1, 4, 12000),
('PJ-2610-035', '2026-10-02 09:30:00', 2, 5, 18000),
('PJ-2610-036', '2026-10-02 09:45:00', 3, NULL, 10000),
('PJ-2610-037', '2026-10-02 10:00:00', 1, 1, 30000),
('PJ-2610-038', '2026-10-02 10:15:00', 2, 2, 14000),
('PJ-2610-039', '2026-10-02 10:30:00', 3, 3, 22000),
('PJ-2610-040', '2026-10-02 10:45:00', 1, 4, 16000),
('PJ-2610-041', '2026-10-02 11:00:00', 2, 5, 20000),
('PJ-2610-042', '2026-10-02 11:15:00', 3, NULL, 25000),
('PJ-2610-043', '2026-10-02 11:30:00', 1, 1, 15000),
('PJ-2610-044', '2026-10-02 11:45:00', 2, 2, 18000),
('PJ-2610-045', '2026-10-02 13:00:00', 3, 3, 12000),
('PJ-2610-046', '2026-10-02 13:15:00', 1, 4, 22000),
('PJ-2610-047', '2026-10-02 13:30:00', 2, 5, 30000),
('PJ-2610-048', '2026-10-02 13:45:00', 3, NULL, 10000),
('PJ-2610-049', '2026-10-02 14:00:00', 1, 1, 14000),
('PJ-2610-050', '2026-10-02 14:15:00', 2, 2, 20000),
('PJ-2610-051', '2026-10-02 14:30:00', 3, 3, 18000),
('PJ-2610-052', '2026-10-02 14:45:00', 1, 4, 25000),
('PJ-2610-053', '2026-10-02 15:00:00', 2, 5, 12000),
('PJ-2610-054', '2026-10-02 15:15:00', 3, NULL, 16000),
('PJ-2610-055', '2026-10-02 15:30:00', 1, 1, 20000);

-- --- TANGGAL 3: 2026-10-03 (Nota 56 s.d. 80) ---
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
('PJ-2610-056', '2026-10-03 08:30:00', 1, 1, 15000),
('PJ-2610-057', '2026-10-03 08:45:00', 2, 2, 20000),
('PJ-2610-058', '2026-10-03 09:00:00', 3, 3, 12000),
('PJ-2610-059', '2026-10-03 09:15:00', 1, 4, 30000),
('PJ-2610-060', '2026-10-03 09:30:00', 2, 5, 22000),
('PJ-2610-061', '2026-10-03 09:45:00', 3, NULL, 10000),
('PJ-2610-062', '2026-10-03 10:00:00', 1, 1, 18000),
('PJ-2610-063', '2026-10-03 10:15:00', 2, 2, 25000),
('PJ-2610-064', '2026-10-03 10:30:00', 3, 3, 14000),
('PJ-2610-065', '2026-10-03 10:45:00', 1, 4, 20000),
('PJ-2610-066', '2026-10-03 11:00:00', 2, 5, 16000),
('PJ-2610-067', '2026-10-03 11:15:00', 3, NULL, 12000),
('PJ-2610-068', '2026-10-03 11:30:00', 1, 1, 30000),
('PJ-2610-069', '2026-10-03 11:45:00', 2, 2, 22000),
('PJ-2610-070', '2026-10-03 13:00:00', 3, 3, 15000),
('PJ-2610-071', '2026-10-03 13:15:00', 1, 4, 18000),
('PJ-2610-072', '2026-10-03 13:30:00', 2, 5, 20000),
('PJ-2610-073', '2026-10-03 13:45:00', 3, NULL, 25000),
('PJ-2610-074', '2026-10-03 14:00:00', 1, 1, 12000),
('PJ-2610-075', '2026-10-03 14:15:00', 2, 2, 16000),
('PJ-2610-076', '2026-10-03 14:30:00', 3, 3, 20000),
('PJ-2610-077', '2026-10-03 14:45:00', 1, 4, 30000),
('PJ-2610-078', '2026-10-03 15:00:00', 2, 5, 14000),
('PJ-2610-079', '2026-10-03 15:15:00', 3, NULL, 22000),
('PJ-2610-080', '2026-10-03 15:30:00', 1, 1, 25000);


-- =====================================================================
-- 4. PENGISIAN DETAIL PENJUALAN (MENGGUNAKAN INSERT SELECT SECARA AMAN)
-- =====================================================================

-- Mengisi detail penjualan secara massal menggunakan INSERT SELECT dari tabel master barang
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan p
JOIN barang b ON b.kode_barang = 'ATK-001'
WHERE p.id_penjualan BETWEEN 1 AND 80;