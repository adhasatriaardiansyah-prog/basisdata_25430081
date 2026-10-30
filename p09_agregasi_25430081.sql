-- =====================================================================
-- Nama      : Muhammad Adha Satria Ardiansyah
-- NIM       : 25430081
-- Kelas     : C (Ilmu Komputer - Universitas Muhammadiyah Metro)
-- File      : p09_agregasi_25430081.sql
-- Tema Proyek: Sistem Informasi Akademik
-- Deskripsi : Milestone Proyek 9 - Laporan Agregasi Akademik
-- =====================================================================

-- 0. Mengaktifkan Mode Ketat Agregasi (Wajib Modul 9)
SET SESSION sql_mode = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION,ONLY_FULL_GROUP_BY';

-- ---------------------------------------------------------------------
-- Laporan 1 (KI-01): Rekapitulasi Jumlah Mahasiswa Berdasarkan Program Studi (WITH ROLLUP)
-- Meringkas total mahasiswa per prodi beserta baris total keseluruhan
-- ---------------------------------------------------------------------
SELECT 
    prodi_mahasiswa,
    COUNT(id_mhs) AS total_mahasiswa
FROM mahasiswa
GROUP BY prodi_mahasiswa WITH ROLLUP;

-- ---------------------------------------------------------------------
-- Laporan 2 (KI-02): Dosen PA dengan Jumlah Mahasiswa Bimbingan Lebih dari 5 Orang (HAVING)
-- Menampilkan kelompok Dosen PA yang membimbing mahasiswa > 5 orang
-- ---------------------------------------------------------------------
SELECT 
    d.nip_dosen,
    d.nama_dosen,
    COUNT(m.id_mhs) AS total_mahasiswa_bimbingan
FROM dosen d
JOIN mahasiswa m ON m.id_dosen_pa = d.id_dosen
GROUP BY d.id_dosen, d.nip_dosen, d.nama_dosen
HAVING COUNT(m.id_mhs) > 5;

-- ---------------------------------------------------------------------
-- Laporan 3 (KI-03): Rekapitulasi Beban SKS Berdasarkan Semester Penawaran Mata Kuliah
-- Meringkas jumlah mata kuliah dan total SKS yang ditawarkan per semester
-- ---------------------------------------------------------------------
SELECT 
    semester_penawaran_mk AS semester,
    COUNT(id_mk) AS jumlah_mata_kuliah,
    SUM(sks_mk) AS total_sks_ditawarkan,
    AVG(sks_mk) AS rata_rata_sks
FROM mata_kuliah
GROUP BY semester_penawaran_mk;

-- ---------------------------------------------------------------------
-- Laporan 4 (KI-04): Analisis Performa Akademik Mahasiswa Aktif per Angkatan (WHERE)
-- Menyaring data dasar mahasiswa berstatus 'Aktif' sebelum dikelompokkan
-- ---------------------------------------------------------------------
SELECT 
    angkatan_mahasiswa,
    COUNT(id_mhs) AS jumlah_mahasiswa_aktif
FROM mahasiswa
WHERE status_aktif_mahasiswa = 'Aktif'
GROUP BY angkatan_mahasiswa;

-- ---------------------------------------------------------------------
-- Laporan 5 (KI-05): Rekapitulasi Pengajuan KRS Berdasarkan Semester dan Status (WITH ROLLUP)
-- Meringkas total dokumen KRS bertingkat dengan ROLLUP
-- ---------------------------------------------------------------------
SELECT 
    semester_krs,
    status_persetujuan_krs,
    COUNT(id_krs) AS total_pengajuan_krs
FROM krs
GROUP BY semester_krs, status_persetujuan_krs WITH ROLLUP;