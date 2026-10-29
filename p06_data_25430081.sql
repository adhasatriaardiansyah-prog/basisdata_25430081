-- =====================================================================
-- Nama        : Muhamad Adha Satria Ardiansyah
-- NPM         : 25430081
-- Kelas       : C
-- Universitas : Universitas Muhammadiyah Metro
-- Mata Kuliah : Basis Data
-- Tema Proyek : Akademik
-- Berkas      : p06_data_25430081.md
-- Parameter P : 8 (10 x P = 80 Baris Transaksi Utama KRS)
-- =====================================================================

USE akad_081;

-- Mengaktifkan mode aman sesuai kebijakan praktikum
SET SESSION sql_safe_updates = 1;

-- =====================================================================
-- 1. PENGISIAN DATA INDUK (MASTER TABLES) - Minimal 5 Baris per Tabel
-- =====================================================================

-- A. Data Dosen (5 Baris)
INSERT INTO dosen (nip_dosen, nama_dosen, email_dosen, no_hp_dosen) VALUES
('198005152005', 'Dr. Agus Setiawan, M.T.', 'agus.setiawan@umpetro.ac.id', '081234567801'),
('198510202008', 'Siti Rahma, M.Kom.', 'siti.rahma@umpetro.ac.id', '081234567802'),
('198804222012', 'Budi Hermawan, S.Kom., M.Cs.', 'budi.hermawan@umpetro.ac.id', '081234567803'),
('197911052003', 'Dwi Cahyono, M.T.', 'dwi.cahyono@umpetro.ac.id', '081234567804'),
('198209112006', 'Eka Fitriani, M.Kom.', 'eka.fitriani@umpetro.ac.id', '081234567805');

-- B. Data Mahasiswa (5 Baris, Termasuk Nonaktif/Cuti/Lulus sesuai Enum)
INSERT INTO mahasiswa (npm_mahasiswa, nama_mahasiswa, prodi_mahasiswa, angkatan_mahasiswa, status_aktif_mahasiswa, email_pribadi_mahasiswa, no_hp_mahasiswa, id_dosen_pa) VALUES
('25430081', 'Muhamad Adha Satria Ardiansyah', 'Ilmu Komputer', 2025, 'Aktif', 'adha.satria@gmail.com', '081111222333', 1),
('25430082', 'Ahmad Fauzi', 'Ilmu Komputer', 2025, 'Aktif', 'ahmad.fauzi@gmail.com', '082222333444', 1),
('25430083', 'Rina Melati', 'Ilmu Komputer', 2024, 'Cuti', 'rina.melati@gmail.com', '083333444555', 2),
('25430084', 'Doni Pratama', 'Ilmu Komputer', 2025, 'Aktif', 'doni.pratama@gmail.com', '084444555666', 2),
('25430085', 'Sari Wulandari', 'Ilmu Komputer', 2025, 'Aktif', 'sari.wulandari@gmail.com', '085555666777', 3);

-- C. Data Mata Kuliah (5 Baris)
INSERT INTO mata_kuliah (kode_mk, nama_mk, sks_mk, semester_penawaran_mk) VALUES
('INF101', 'Basis Data', 3, 3),
('INF102', 'Pemrograman Web', 3, 3),
('INF103', 'Algoritma & Struktur Data', 4, 2),
('INF104', 'Jaringan Komputer', 3, 4),
('INF105', 'Sistem Operasi', 3, 3);

-- D. Data Kelas / Jadwal Perkuliahan (5 Baris)
INSERT INTO kelas (kode_kelas, id_mk, id_dosen_pengampu, ruangan_kelas, kuota_kelas, hari_kelas, jam_kelas) VALUES
('K-INF101-C', 1, 1, 'Lab Komputer 1', 40, 'Senin', '08:00 - 10:30'),
('K-INF102-C', 2, 2, 'Lab Komputer 2', 40, 'Selasa', '10:00 - 12:30'),
('K-INF103-C', 3, 3, 'Ruang R.201', 40, 'Rabu', '08:00 - 11:15'),
('K-INF104-C', 4, 4, 'Lab Jaringan', 40, 'Kamis', '13:00 - 15:30'),
('K-INF105-C', 5, 5, 'Ruang R.202', 40, 'Jumat', '09:00 - 11:30');


-- =====================================================================
-- 2. PENGISIAN DATA TRANSAKSI UTAMA (KRS - KEPALA TRANSAKSI)
-- Minimal 80 Baris Transaksi Tersebar pada Minimal 3 Tanggal/Periode Berbeda
-- =====================================================================

INSERT INTO krs (no_krs, id_mhs, tahun_ajaran_krs, semester_krs, tgl_pengajuan_krs, status_persetujuan_krs) VALUES
('KRS-20251-001', 1, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-002', 2, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-003', 3, '2025/2026', 'Ganjil', '2025-09-01', 'Diproses'),
('KRS-20251-004', 4, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-005', 5, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-006', 1, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-007', 2, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-008', 3, '2025/2026', 'Ganjil', '2025-09-01', 'Diproses'),
('KRS-20251-009', 4, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-010', 5, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-011', 1, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-012', 2, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-013', 3, '2025/2026', 'Ganjil', '2025-09-01', 'Diproses'),
('KRS-20251-014', 4, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-015', 5, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-016', 1, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-017', 2, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-018', 3, '2025/2026', 'Ganjil', '2025-09-01', 'Diproses'),
('KRS-20251-019', 4, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-020', 5, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-021', 1, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-022', 2, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-023', 3, '2025/2026', 'Ganjil', '2025-09-01', 'Diproses'),
('KRS-20251-024', 4, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-025', 5, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-026', 1, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-027', 2, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-028', 3, '2025/2026', 'Ganjil', '2025-09-01', 'Diproses'),
('KRS-20251-029', 4, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20251-030', 5, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui'),
('KRS-20252-031', 1, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-032', 2, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-033', 3, '2025/2026', 'Genap', '2026-02-02', 'Diproses'),
('KRS-20252-034', 4, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-035', 5, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-036', 1, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-037', 2, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-038', 3, '2025/2026', 'Genap', '2026-02-02', 'Diproses'),
('KRS-20252-039', 4, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-040', 5, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-041', 1, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-042', 2, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-043', 3, '2025/2026', 'Genap', '2026-02-02', 'Diproses'),
('KRS-20252-044', 4, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-045', 5, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-046', 1, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-047', 2, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-048', 3, '2025/2026', 'Genap', '2026-02-02', 'Diproses'),
('KRS-20252-049', 4, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-050', 5, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-051', 1, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-052', 2, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-053', 3, '2025/2026', 'Genap', '2026-02-02', 'Diproses'),
('KRS-20252-054', 4, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20252-055', 5, '2025/2026', 'Genap', '2026-02-02', 'Disetujui'),
('KRS-20261-056', 1, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-057', 2, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-058', 3, '2026/2027', 'Ganjil', '2026-09-07', 'Diproses'),
('KRS-20261-059', 4, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-060', 5, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-061', 1, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-062', 2, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-063', 3, '2026/2027', 'Ganjil', '2026-09-07', 'Diproses'),
('KRS-20261-064', 4, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-065', 5, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-066', 1, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-067', 2, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-068', 3, '2026/2027', 'Ganjil', '2026-09-07', 'Diproses'),
('KRS-20261-069', 4, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-070', 5, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-071', 1, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-072', 2, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-073', 3, '2026/2027', 'Ganjil', '2026-09-07', 'Diproses'),
('KRS-20261-074', 4, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-075', 5, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-076', 1, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-077', 2, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-078', 3, '2026/2027', 'Ganjil', '2026-09-07', 'Diproses'),
('KRS-20261-079', 4, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui'),
('KRS-20261-080', 5, '2026/2027', 'Ganjil', '2026-09-07', 'Disetujui');

-- =====================================================================
-- 3. PENGISIAN DETAIL TRANSAKSI (DETAIL KRS)
-- Menggunakan INSERT SELECT Aman dari Tabel Master
-- =====================================================================

-- Mengisi 80 baris detail_krs yang terikat pada 80 KRS di atas
INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka_detail_krs, nilai_huruf_detail_krs)
SELECT k.id_krs, kl.id_kelas, 85.00, 'A'
FROM krs k
JOIN kelas kl ON kl.kode_kelas = 'K-INF101-C'
WHERE k.id_krs BETWEEN 1 AND 80;