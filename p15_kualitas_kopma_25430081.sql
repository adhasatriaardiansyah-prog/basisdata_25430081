-- =====================================================================
-- Nama      : Muhamad Adha Satria Ardiansyah
-- NPM       : 25430081
-- Modul     : 15 - Mengelola Kualitas Data: Validasi dan Pembersihan
-- Proyek    : kopma_081 (Sistem Informasi Koperasi Mahasiswa)
-- =====================================================================

USE kopma_081;

-- 1. Membuat tabel penampung sementara (staging) dengan tipe data teks longgar
DROP TABLE IF EXISTS anggota_kopma_impor;
CREATE TABLE anggota_kopma_impor (
    baris INT,
    no_anggota VARCHAR(50),
    nama_lengkap VARCHAR(100),
    jenis_keanggotaan VARCHAR(50),
    no_hp VARCHAR(50),
    simpanan_pokok VARCHAR(50),
    tgl_gabung VARCHAR(50)
);

-- Menyisipkan 10 baris data kotor pendaftaran anggota Koperasi Mahasiswa
INSERT INTO anggota_kopma_impor VALUES
(1, 'KOP-25430001', 'ahmad fauzi', 'biasa', '08123456789', '50000', '12/08/2026'),
(2, 'KOP-25430082-x', 'RINA MELATI', 'pengurus', '+628139876543', '50000', '31/09/2026'), -- Tanggal tidak valid & HP +62
(3, 'KOP-25430003', '', 'Biasa', '81211122233', '50000', '14/08/2026'),                   -- Nama kosong
(4, 'KOP-25430001', 'Ahmad Fauzi', 'anggota biasa', '08123456789', '50000', '12/08/2026'),  -- No Anggota ganda di berkas
(5, 'KOP-25430084', 'doni pratama', 'pengawas', '085678901234', '50000', '15/08/2026'),
(6, 'KOP-25430085', 'sari wulandari', 'biasa', 'NULL', 'ABC', '16/08/2026'),                -- Simpanan bukan angka
(7, 'KOP-25430086', 'budi santoso', 'PENGURUS', '0877889900', '50000', '17/08/2026'),
(8, 'KOP-25430002', 'dewi lestari', 'biasa', '08199988877', '50000', '18/08/2026'),          -- No Anggota sudah terdaftar di sistem utama Kopma
(9, 'KOP-25430088', 'eko prasetyo', 'biasa', '0812345', '50000', '19/08/2026'),
(10, 'KOP-25430089', 'siti nurhaliza', 'pengurus', '+62857123456', '50000', '20/08/2026');

-- 2. Kueri Pemindaian Masalah Awal (Data Profiling Kopma)
SELECT 'nama anggota kosong' AS masalah, COUNT(*) AS jumlah FROM anggota_kopma_impor WHERE TRIM(nama_lengkap) = '' OR nama_lengkap IS NULL
UNION ALL 
SELECT 'Nomor Anggota tidak baku', COUNT(*) FROM anggota_kopma_impor WHERE no_anggota NOT REGEXP '^KOP-[0-9]{8}$'
UNION ALL 
SELECT 'Nomor HP tidak baku', COUNT(*) FROM anggota_kopma_impor WHERE no_hp IS NULL OR no_hp NOT REGEXP '^08[0-9]{8,11}$'
UNION ALL
SELECT 'Simpanan pokok non-numerik', COUNT(*) FROM anggota_kopma_impor WHERE simpanan_pokok NOT REGEXP '^[0-9]+$';

-- 3. Pembersihan dan Normalisasi Data ke Tabel Staging Bersih (anggota_kopma_bersih)
DROP TABLE IF EXISTS anggota_kopma_bersih;
CREATE TABLE anggota_kopma_bersih AS
SELECT 
    baris,
    REGEXP_REPLACE(no_anggota, '[^A-Za-z0-9-]', '') AS no_anggota_clean,
    CONCAT(UPPER(LEFT(TRIM(nama_lengkap), 1)), LOWER(SUBSTRING(TRIM(nama_lengkap), 2))) AS nama_anggota_clean,
    CASE 
        WHEN UPPER(REGEXP_REPLACE(jenis_keanggotaan, '[^A-Za-z]', '')) IN ('BIASA', 'ANGGOTABIASA') THEN 'Anggota Biasa'
        WHEN UPPER(REGEXP_REPLACE(jenis_keanggotaan, '[^A-Za-z]', '')) IN ('PENGURUS') THEN 'Pengurus'
        WHEN UPPER(REGEXP_REPLACE(jenis_keanggotaan, '[^A-Za-z]', '')) IN ('PENGAWAS') THEN 'Pengawas'
        ELSE 'Anggota Biasa'
    END AS jenis_keanggotaan_clean,
    CASE 
        WHEN REGEXP_REPLACE(no_hp, '[^0-9]','') REGEXP '^628' THEN CONCAT('0', SUBSTRING(REGEXP_REPLACE(no_hp, '[^0-9]',''), 3))
        WHEN REGEXP_REPLACE(no_hp, '[^0-9]','') REGEXP '^8' THEN CONCAT('0', REGEXP_REPLACE(no_hp,'[^0-9]',''))
        WHEN REGEXP_REPLACE(no_hp, '[^0-9]','') REGEXP '^08' THEN REGEXP_REPLACE(no_hp, '[^0-9]','')
        ELSE NULL
    END AS no_hp_clean,
    CASE 
        WHEN simpanan_pokok REGEXP '^[0-9]+$' THEN CAST(simpanan_pokok AS DECIMAL(10,2))
        ELSE 0.00
    END AS simpanan_pokok_clean,
    CASE 
        WHEN tgl_gabung REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
             AND CAST(LEFT(tgl_gabung, 2) AS UNSIGNED) BETWEEN 1 AND DAY(LAST_DAY(STR_TO_DATE(CONCAT('01', SUBSTRING(tgl_gabung, 3)), '%d/%m/%Y')))
        THEN STR_TO_DATE(tgl_gabung, '%d/%m/%Y')
        ELSE NULL
    END AS tgl_gabung_clean
FROM anggota_kopma_impor;

-- 4. Kueri Migrasi Data Bersih ke Tabel Utama Kopma (Deduplikasi via ROW_NUMBER & NOT EXISTS)
INSERT INTO anggota (no_anggota, nama_anggota, jenis_anggota, no_hp, simpanan_pokok, tgl_gabung)
SELECT 
    k.no_anggota_clean, 
    k.nama_anggota_clean, 
    k.jenis_keanggotaan_clean, 
    k.no_hp_clean, 
    k.simpanan_pokok_clean,
    k.tgl_gabung_clean
FROM (
    SELECT b.*, ROW_NUMBER() OVER (PARTITION BY b.no_anggota_clean ORDER BY b.baris) AS urut
    FROM anggota_kopma_bersih b
    WHERE b.nama_anggota_clean IS NOT NULL AND b.nama_anggota_clean != ''
      AND b.tgl_gabung_clean IS NOT NULL
      AND b.no_anggota_clean REGEXP '^KOP-[0-9]{8}$'
      AND NOT EXISTS (SELECT 1 FROM anggota a WHERE a.no_anggota = b.no_anggota_clean)
) AS k
WHERE k.urut = 1;