-- =================================================================
-- Nama  : Muhamad Adha Satria Ardiansyah
-- NPM   : 25430081
-- Kelas : C
-- Mata kuliah : Praktikum Basis Data (Modul 11)
-- Berkas : p11_subquery_25430081.sql (Proyek Akademik / AKAD)
-- =================================================================

USE akad_081;

-- 1. Subquery Skalar: 
-- Menampilkan mata kuliah yang jumlah SKS-nya di atas rata-rata SKS seluruh mata kuliah
SELECT kode_mk, nama_mk, sks_mk
FROM mata_kuliah
WHERE sks_mk > (SELECT AVG(sks_mk) FROM mata_kuliah);


-- 2. Subquery Berkorelasi (NOT EXISTS): 
-- Menampilkan mahasiswa yang belum pernah mengajukan KRS sama sekali
SELECT m.npm_mahasiswa, m.nama_mahasiswa
FROM mahasiswa m
WHERE NOT EXISTS (
    SELECT 1 
    FROM krs k 
    WHERE k.id_mhs = m.id_mhs
);


-- 3. Tabel Turunan (Derived Table): 
-- Menghitung rata-rata total SKS yang diambil per mahasiswa melalui krs, detail_krs, kelas, dan mata_kuliah
SELECT ROUND(AVG(t.total_sks), 2) AS rata_rata_sks_diambil
FROM (
    SELECT k.id_mhs, SUM(mk.sks_mk) AS total_sks
    FROM krs k
    JOIN detail_krs dk ON k.id_krs = dk.id_krs
    JOIN kelas kls ON dk.id_kelas = kls.id_kelas
    JOIN mata_kuliah mk ON kls.id_mk = mk.id_mk
    GROUP BY k.id_mhs
) AS t;


-- 4. Operasi Himpunan 1 (INTERSECT): 
-- ID mahasiswa yang aktif ('Aktif') dan juga pernah melakukan pengajuan KRS
SELECT id_mhs FROM mahasiswa WHERE status_aktif_mahasiswa = 'Aktif'
INTERSECT
SELECT id_mhs FROM krs;


-- 5. Operasi Himpunan 2 (EXCEPT): 
-- ID mahasiswa yang terdaftar di tabel mahasiswa tetapi belum pernah mengajukan KRS sama sekali
SELECT id_mhs FROM mahasiswa
EXCEPT
SELECT id_mhs FROM krs;


-- =================================================================
-- UJI KASUS JEBAKAN NOT IN PADA PROYEK AKADEMIK
-- =================================================================
-- Pengujian perbandingan NOT IN vs NOT EXISTS pada tabel krs
SELECT npm_mahasiswa, nama_mahasiswa 
FROM mahasiswa
WHERE id_mhs NOT IN (
    SELECT id_mhs 
    FROM krs 
    WHERE id_mhs IS NOT NULL
);