-- =====================================================================
-- Nama      : Muhamad Adha Satria Ardiansyah
-- NPM       : 25430081
-- Modul     : 15 - Mengelola Kualitas Data: Validasi dan Pembersihan
-- Proyek    : akad_081 (Sistem Akademik)
-- =====================================================================

-- 1. Membuat tabel penampung (staging) yang longgar (semua tipe data teks)
DROP TABLE IF EXISTS mahasiswa_impor;
CREATE TABLE mahasiswa_impor (
    baris INT,
    npm VARCHAR(50),
    nama VARCHAR(100),
    prodi VARCHAR(50),
    no_hp VARCHAR(50),
    tgl_daftar VARCHAR(50)
);

-- Menyisipkan 10 baris data sampel kotor (simulasi pendaftaran bermasalah)
INSERT INTO mahasiswa_impor VALUES
(1, '25430001', 'ahmad fauzi', 'ilkom', '08123456789', '12/08/2026'),
(2, '25430082-x', 'RINA MELATI', 'SI', '+628139876543', '31/09/2026'), -- Tanggal tidak valid & HP +62
(3, '25430003', '', 'Teknik Informatika', '81211122233', '14/08/2026'),    -- Nama kosong
(4, '25430001', 'Ahmad Fauzi', 'Ilmu Komputer', '08123456789', '12/08/2026'), -- NPM ganda di berkas
(5, '25430084', 'doni pratama', 'IK', '085678901234', '15/08/2026'),
(6, '25430085', 'sari wulandari', 'Pendidikan Matematika', 'NULL', '16/08/2026'),
(7, '25430086', 'budi santoso', 'ilkom', '0877889900', '17/08/2026'),
(8, '25430002', 'dewi lestari', 'Sistem Informasi', '08199988877', '18/08/2026'), -- NPM sudah terdaftar di tabel utama
(9, '25430088', 'eko prasetyo', 'TI', '0812345', '19/08/2026'),
(10, '25430089', 'siti nurhaliza', 'ilkom', '+62857123456', '20/08/2026');

-- 2. Kueri Profil Masalah Awal
SELECT 'nama kosong' AS masalah, COUNT(*) AS jumlah FROM mahasiswa_impor WHERE TRIM(nama) = '' OR nama IS NULL
UNION ALL 
SELECT 'NPM bukan 10 digit', COUNT(*) FROM mahasiswa_impor WHERE npm NOT REGEXP '^[0-9]{10}$'
UNION ALL 
SELECT 'HP tidak baku', COUNT(*) FROM mahasiswa_impor WHERE no_hp IS NULL OR no_hp NOT REGEXP '^08[0-9]{8,11}$';

-- 3. Membuat tabel bersih dari tabel penampung dengan validasi ketat
DROP TABLE IF EXISTS mahasiswa_bersih;
CREATE TABLE mahasiswa_bersih AS
SELECT 
    baris,
    REGEXP_REPLACE(npm, '[^0-9]', '') AS npm_mhs,
    CONCAT(UPPER(LEFT(TRIM(nama), 1)), LOWER(SUBSTRING(TRIM(nama), 2))) AS nama_mhs,
    CASE 
        WHEN UPPER(REGEXP_REPLACE(prodi, '[^A-Za-z]', '')) IN ('ILMUKOMPUTER', 'ILKOM', 'IK') THEN 'Ilmu Komputer'
        WHEN UPPER(REGEXP_REPLACE(prodi, '[^A-Za-z]', '')) IN ('SISTEMINFORMASI', 'SI') THEN 'Sistem Informasi'
        WHEN UPPER(REGEXP_REPLACE(prodi, '[^A-Za-z]', '')) IN ('TEKNIKINFORMATIKA', 'TI') THEN 'Teknik Informatika'
        WHEN UPPER(REGEXP_REPLACE(prodi, '[^A-Za-z]', '')) IN ('PENDIDIKANMATEMATIKA') THEN 'Pendidikan Matematika'
    END AS prodi_mhs,
    CASE 
        WHEN REGEXP_REPLACE(no_hp, '[^0-9]','') REGEXP '^628' THEN CONCAT('0', SUBSTRING(REGEXP_REPLACE(no_hp, '[^0-9]',''), 3))
        WHEN REGEXP_REPLACE(no_hp, '[^0-9]','') REGEXP '^8' THEN CONCAT('0', REGEXP_REPLACE(no_hp,'[^0-9]',''))
        WHEN REGEXP_REPLACE(no_hp, '[^0-9]','') REGEXP '^08' THEN REGEXP_REPLACE(no_hp, '[^0-9]','')
        ELSE NULL
    END AS no_hp_mhs,
    CASE 
        WHEN tgl_daftar REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
             AND CAST(LEFT(tgl_daftar, 2) AS UNSIGNED) BETWEEN 1 AND DAY(LAST_DAY(STR_TO_DATE(CONCAT('01', SUBSTRING(tgl_daftar, 3)), '%d/%m/%Y')))
        THEN STR_TO_DATE(tgl_daftar, '%d/%m/%Y')
        ELSE NULL
    END AS tgl_daftar_mhs
FROM mahasiswa_impor;