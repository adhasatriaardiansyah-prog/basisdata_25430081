-- ============================================================
-- Modul 10: JOIN Lintas Tabel (Akademik)
-- Nama : Muhamad Adha Satria Ardiansyah
-- NPM  : 25430081
-- Kelas: C
-- File : p10_join_25430081.sql
-- Database: akad_081
-- ============================================================

USE akad_081;

-- ------------------------------------------------------------
-- 1. Kueri Multi-Tabel (4 Tabel) dengan Agregasi: Total SKS yang Diambil Mahasiswa
-- Kebutuhan Informasi: Mengetahui total SKS dan jumlah kelas yang diambil setiap mahasiswa
-- Jalur ERD: mahasiswa -> krs -> detail_krs -> kelas -> mata_kuliah
-- ------------------------------------------------------------
SELECT 
    m.npm_mahasiswa,
    m.nama_mahasiswa,
    m.prodi_mahasiswa,
    COUNT(dk.id_kelas) AS total_kelas_diambil,
    SUM(mk.sks_mk) AS total_sks
FROM mahasiswa m
JOIN krs k ON k.id_mhs = m.id_mhs
JOIN detail_krs dk ON dk.id_krs = k.id_krs
JOIN kelas kl ON kl.id_kelas = dk.id_kelas
JOIN mata_kuliah mk ON mk.id_mk = kl.id_mk
GROUP BY m.id_mhs, m.npm_mahasiswa, m.nama_mahasiswa, m.prodi_mahasiswa
ORDER BY total_sks DESC;


-- ------------------------------------------------------------
-- 2. LEFT JOIN Data Tanpa Pasangan: Dosen yang Belum Mengampu Kelas Perkuliahan
-- Kebutuhan Informasi: Mencari dosen yang belum dijadwalkan mengampu kelas
-- Jalur ERD: dosen -> kelas
-- ------------------------------------------------------------
SELECT 
    d.nip_dosen,
    d.nama_dosen,
    COUNT(kl.id_kelas) AS jumlah_kelas_diampu
FROM dosen d
LEFT JOIN kelas kl ON kl.id_dosen_pengampu = d.id_dosen
GROUP BY d.id_dosen, d.nip_dosen, d.nama_dosen
HAVING jumlah_kelas_diampu = 0;


-- ------------------------------------------------------------
-- 3. LEFT JOIN dengan Agregasi: Mahasiswa yang Belum Mengisi KRS
-- Kebutuhan Informasi: Mengidentifikasi mahasiswa yang belum memiliki riwayat pengisian KRS
-- Jalur ERD: mahasiswa -> krs
-- ------------------------------------------------------------
SELECT 
    m.npm_mahasiswa,
    m.nama_mahasiswa,
    m.prodi_mahasiswa,
    COUNT(k.id_krs) AS total_krs
FROM mahasiswa m
LEFT JOIN krs k ON k.id_mhs = m.id_mhs
GROUP BY m.id_mhs, m.npm_mahasiswa, m.nama_mahasiswa, m.prodi_mahasiswa
HAVING total_krs = 0;


-- ------------------------------------------------------------
-- 4. Self JOIN: Pasangan Mahasiswa Bimbingan dari Dosen Pembimbing Akademik (PA) yang Sama
-- Kebutuhan Informasi: Memasangkan mahasiswa yang berada di bawah pengampuan Dosen PA yang sama
-- Jalur ERD: mahasiswa JOIN mahasiswa (berdasarkan id_dosen_pa)
-- ------------------------------------------------------------
SELECT 
    d.nama_dosen AS dosen_pa,
    m1.nama_mahasiswa AS mahasiswa_1,
    m2.nama_mahasiswa AS mahasiswa_2,
    m1.prodi_mahasiswa AS prodi
FROM mahasiswa m1
JOIN mahasiswa m2 ON m1.id_dosen_pa = m2.id_dosen_pa AND m1.id_mhs < m2.id_mhs
JOIN dosen d ON d.id_dosen = m1.id_dosen_pa
ORDER BY d.nama_dosen, m1.nama_mahasiswa;


-- ------------------------------------------------------------
-- 5. JOIN Multi-Tabel Lanjutan (5 Tabel): Jadwal Perkuliahan Lengkap Mahasiswa
-- Kebutuhan Informasi: Menampilkan rincian jadwal perkuliahan, mata kuliah, dosen pengampu, dan ruangan
-- Jalur ERD: mahasiswa -> krs -> detail_krs -> kelas -> mata_kuliah & dosen (pengampu)
-- ------------------------------------------------------------
SELECT 
    m.npm_mahasiswa,
    m.nama_mahasiswa,
    mk.kode_mk,
    mk.nama_mk,
    mk.sks_mk,
    kl.kode_kelas,
    d.nama_dosen AS dosen_pengampu,
    kl.ruangan_kelas,
    kl.hari_kelas,
    kl.jam_kelas
FROM mahasiswa m
JOIN krs k ON k.id_mhs = m.id_mhs
JOIN detail_krs dk ON dk.id_krs = k.id_krs
JOIN kelas kl ON kl.id_kelas = dk.id_kelas
JOIN mata_kuliah mk ON mk.id_mk = kl.id_mk
JOIN dosen d ON d.id_dosen = kl.id_dosen_pengampu
ORDER BY m.npm_mahasiswa, kl.hari_kelas, kl.jam_kelas;