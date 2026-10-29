-- =================================================================
-- File   : p07_kueri_25430081.sql
-- Nama   : Muhamad Adha Satria Ardiansyah
-- NPM    : 25430081
-- Kelas  : C
-- Modul  : 07 - Menjawab Pertanyaan dengan SELECT dan Fungsi Skalar
-- Proyek : Sistem Informasi Akademik
-- Basis Data : akad_081
-- =================================================================

USE akad_081;

-- KI-01: Pencarian data mahasiswa berdasarkan pola nama & kapitalisasi
-- Pertanyaan: Siapa saja mahasiswa yang namanya mengandung huruf 'a' dan tampilkan namanya dalam huruf besar (kapital)?
-- Harapan Hasil: Daftar NPM, nama mahasiswa berhuruf besar, dan program studi yang memenuhi filter LIKE '%a%'.

SELECT
npm_mahasiswa,
UPPER(nama_mahasiswa) AS nama_kapital,
prodi_mahasiswa
FROM mahasiswa
WHERE nama_mahasiswa LIKE '%a%'
ORDER BY nama_mahasiswa ASC;

-- KI-02: Menyaring mata kuliah dengan rentang bobot SKS tertentu
-- Pertanyaan: Mata kuliah apa saja yang memiliki bobot kredit antara 2 hingga 4 SKS?
-- Harapan Hasil: Baris data mata kuliah yang nilai sks_mk berada pada rentang 2 sampai 4.

SELECT
kode_mk,
nama_mk,
sks_mk
FROM mata_kuliah
WHERE sks_mk BETWEEN 2 AND 4
ORDER BY sks_mk DESC, nama_mk ASC;

-- KI-03: Menampilkan daftar seluruh dosen pengampu
-- Pertanyaan: Siapa saja daftar dosen yang terdaftar di sistem akademik?
-- Harapan Hasil: Daftar NIDN dan nama dosen pengampu.

SELECT
id_dosen,
nama_dosen
FROM dosen
ORDER BY nama_dosen ASC;

-- KI-04: Format penggabungan identitas dan penanganan kontak kosong
-- Pertanyaan: Tampilkan identitas mahasiswa dalam format 'Nama (NPM)' serta gantikan nomor HP kosong dengan '-'.
-- Harapan Hasil: Kolom identitas tergabung rapi dan kolom nomor HP tidak menampilkan nilai NULL.

SELECT
CONCAT(nama_mahasiswa, ' (', npm_mahasiswa, ')') AS identitas_mahasiswa,
IFNULL(no_hp_mahasiswa, '-') AS nomor_telepon
FROM mahasiswa;

-- KI-05: Pengkategorian tingkat/kategori mahasiswa berdasarkan angkatan
-- Pertanyaan: Bagaimana kategori tingkatan mahasiswa berdasarkan tahun angkatannya?
-- Harapan Hasil: Kolom tambahan 'kategori_mahasiswa' berisi label 'Senior' atau 'Reguler / Baru'.

SELECT
npm_mahasiswa,
nama_mahasiswa,
angkatan_mahasiswa,
CASE
WHEN angkatan_mahasiswa <= 2024 THEN 'Senior'
ELSE 'Reguler / Baru'
END AS kategori_mahasiswa
FROM mahasiswa
ORDER BY angkatan_mahasiswa ASC, nama_mahasiswa ASC;

-- KI-06: Analisis panjang karakter nama mahasiswa
-- Pertanyaan: Berapa panjang karakter dari masing-masing nama mahasiswa di basis data?
-- Harapan Hasil: Menampilkan nama mahasiswa beserta jumlah karakter menggunakan fungsi CHAR_LENGTH.

SELECT
npm_mahasiswa,
nama_mahasiswa,
CHAR_LENGTH(nama_mahasiswa) AS panjang_nama
FROM mahasiswa
ORDER BY panjang_nama DESC;

-- KI-07: Pencarian domain email pribadi mahasiswa
-- Pertanyaan: Siapa saja mahasiswa yang menggunakan layanan email Gmail sebagai email pribadi?
-- Harapan Hasil: Daftar mahasiswa yang email_pribadi_mahasiswa mengandung domain '@gmail.com'.

SELECT
npm_mahasiswa,
nama_mahasiswa,
email_pribadi_mahasiswa
FROM mahasiswa
WHERE email_pribadi_mahasiswa LIKE '%@gmail.com'
ORDER BY nama_mahasiswa ASC;

-- KI-08: Format string email menjadi huruf kecil (LOWER)
-- Pertanyaan: Tampilkan daftar email pribadi mahasiswa seluruhnya dalam format huruf kecil.
-- Harapan Hasil: Kolom email_pribadi_mahasiswa ditampilkan seragam dengan huruf kecil.

SELECT
npm_mahasiswa,
nama_mahasiswa,
LOWER(email_pribadi_mahasiswa) AS email_format_kecil
FROM mahasiswa;

-- KI-09: Penandaan status keaktifan mahasiswa
-- Pertanyaan: Tampilkan ringkasan status akademik mahasiswa dengan status aktif/non-aktif.
-- Harapan Hasil: Kolom penanda status aktif mahasiswa.

SELECT
npm_mahasiswa,
nama_mahasiswa,
status_aktif_mahasiswa,
CASE
WHEN status_aktif_mahasiswa = 'Aktif' THEN 'Dapat Mengambil KRS'
ELSE 'Perlu Pengurusan Status'
END AS ket_krs
FROM mahasiswa;

-- KI-10: Informasi waktu eksekusi Laporan / Log Kueri
-- Pertanyaan: Tampilkan daftar mahasiswa beserta stempel waktu (timestamp) pengambilan data.
-- Harapan Hasil: Kolom waktu_akses menampilkan tanggal dan jam sistem saat ini menggunakan NOW().

SELECT
npm_mahasiswa,
nama_mahasiswa,
NOW() AS waktu_akses
FROM mahasiswa;

-- =================================================================
-- CATATAN KEBUTUHAN INFORMASI (KI) YANG BELUM DAPAT DIJAWAB 1 TABEL:
-- 1. KI-11: Menampilkan daftar mata kuliah beserta nama dosen pengampunya pada semester aktif.
--    Alasan: Membutuhkan penggabungan tabel (JOIN) antara mata_kuliah, kelas, dan dosen.
-- 2. KI-12: Menhitung total SKS yang diambil per mahasiswa pada semester berjalan.
--    Alasan: Membutuhkan penggabungan tabel (JOIN) serta perhitungan fungsi agregat (SUM dan GROUP BY).
-- =================================================================