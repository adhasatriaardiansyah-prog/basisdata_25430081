-- =====================================================================
-- Nama        : Muhamad Adha Satria Ardiansyah
-- NPM         : 25430081
-- Kelas       : C
-- Mata Kuliah : Praktikum Basis Data (Modul 12)
-- Berkas      : p12_cte_window_25430081.sql
-- Deskripsi   : 4 Kueri CTE dan Window Function untuk Proyek Akademik akad_081
-- =====================================================================

USE akad_081;

-- =====================================================================
-- 1. Peringkat Mahasiswa Berdasarkan Jumlah Item KRS per Prodi (ROW_NUMBER)
-- =====================================================================
WITH total_krs_mhs AS (
    SELECT 
        m.prodi_mahasiswa,
        m.npm_mahasiswa,
        m.nama_mahasiswa,
        COUNT(dk.id_krs) AS total_item_krs
    FROM mahasiswa m
    LEFT JOIN krs k ON m.id_mhs = k.id_mhs
    LEFT JOIN detail_krs dk ON k.id_krs = dk.id_krs
    GROUP BY m.prodi_mahasiswa, m.npm_mahasiswa, m.nama_mahasiswa
),
peringkat_prodi AS (
    SELECT 
        prodi_mahasiswa,
        npm_mahasiswa,
        nama_mahasiswa,
        total_item_krs,
        ROW_NUMBER() OVER (PARTITION BY prodi_mahasiswa ORDER BY total_item_krs DESC, npm_mahasiswa ASC) AS peringkat
    FROM total_krs_mhs
)
SELECT * FROM peringkat_prodi
ORDER BY prodi_mahasiswa, peringkat;


-- =====================================================================
-- 2. Total Berjalan (Running Total) Pengajuan KRS Berdasarkan Tanggal
-- =====================================================================
WITH pengajuan_harian AS (
    SELECT 
        tgl_pengajuan_krs AS tanggal,
        COUNT(id_krs) AS total_krs
    FROM krs
    GROUP BY tgl_pengajuan_krs
)
SELECT 
    tanggal,
    total_krs,
    SUM(total_krs) OVER (ORDER BY tanggal) AS kumulatif_pengajuan
FROM pengajuan_harian
ORDER BY tanggal;


-- =====================================================================
-- 3. Perubahan Jumlah Pengajuan KRS Antarhari dengan LAG()
-- =====================================================================
WITH pengajuan_harian AS (
    SELECT 
        tgl_pengajuan_krs AS tanggal,
        COUNT(id_krs) AS total_krs
    FROM krs
    GROUP BY tgl_pengajuan_krs
)
SELECT 
    tanggal,
    total_krs,
    LAG(total_krs, 1) OVER (ORDER BY tanggal) AS krs_hari_sebelumnya,
    total_krs - LAG(total_krs, 1) OVER (ORDER BY tanggal) AS selisih_perubahan
FROM pengajuan_harian
ORDER BY tanggal;


-- =====================================================================
-- 4. Peringkat Transaksi KRS Berdasarkan Jumlah Mata Kuliah (DENSE_RANK)
-- =====================================================================
WITH krs_per_semester AS (
    SELECT 
        k.semester_krs,
        k.id_krs,
        k.no_krs,
        COUNT(dk.id_krs) AS jumlah_matkul
    FROM krs k
    LEFT JOIN detail_krs dk ON k.id_krs = dk.id_krs
    GROUP BY k.semester_krs, k.id_krs, k.no_krs
)
SELECT 
    semester_krs,
    no_krs,
    jumlah_matkul,
    DENSE_RANK() OVER (PARTITION BY semester_krs ORDER BY jumlah_matkul DESC) AS peringkat_krs
FROM krs_per_semester
ORDER BY semester_krs, peringkat_krs;