# Dokumen Kebutuhan Data - Sistem Informasi Akademik (Akademi Akad)

## 1. Latar Belakang dan Aktivitas Organisasi
Sistem Informasi Akademik (`akademik_akad`) mengelola seluruh aktivitas administrasi perkuliahan perguruan tinggi, mulai dari pendataan mahasiswa, registrasi mata kuliah melalui Kartu Rencana Studi (KRS), pembagian kelas, hingga rekapitulasi nilai akhir (KHS). Dokumen ini disusun untuk mendefinisikan kebutuhan data sebelum perancangan basis data dilakukan.

---

## 2. Aktor dan Proses Bisnis

### Tabel PB-xx: Daftar Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan Mahasiswa Baru | Bagian Akademik | Penerimaan mahasiswa baru |
| PB-02 | Mengelola Data Mata Kuliah | Bagian Akademik | Perubahan kurikulum |
| PB-03 | Pengisian KRS | Mahasiswa & Dosen PA | Awal semester akademik |
| PB-04 | Menginput Nilai Perkuliahan | Dosen Pengampu | Akhir semester / pasca ujian |
| PB-05 | Mencetak Kartu Hasil Studi (KHS) | Mahasiswa / Akademik | Permintaan rekap nilai semester |
| PB-06 | Mengelola Data Dosen | Bagian Akademik | Penambahan / update data pengajar |

---

## 3. Dokumen Sumber yang Dianalisis
Dokumen sumber utama yang dianalisis adalah **Kartu Rencana Studi (KRS)**:
* **Identitas Mahasiswa:** NIM, Nama Mahasiswa, Program Studi, Dosen Pembimbing Akademik (PA).
* **Identitas Semester:** Tahun Ajaran, Semester (Ganjil/Genap).
* **Detail Pengambilan Matkul:** Kode MK, Nama MK, SKS, Kelas, Jadwal, Nama Dosen Pengampu.
* **Nilai Turunan (Dihitung):** Total SKS Diambil, Maksimal SKS Boleh Diambil.

---

## 4. Entitas Kandidat dan Elemen Data

| Entitas Kandidat | Elemen Data Utama | Sumber |
|---|---|---|
| Mahasiswa | nim, nama_mahasiswa, prodi, angkatan, status_aktif, nip_pa, email_pribadi, no_hp | Formulir Pendaftaran |
| Dosen | nip, nama_dosen, email_dosen, no_hp_dosen, gelar | Data Kepegawaian |
| Mata_Kuliah | kode_mk, nama_mk, sks, semester_penawaran | Kurikulum Akademik |
| Kelas | kode_kelas, kode_mk, nip_dosen, hari, jam, ruangan, kuota | Jadwal Perkuliahan |
| KRS | id_krs, nim, tahun_ajaran, semester, tgl_pengajuan, status_persetujuan | Dokumen KRS |
| Detail_KRS | id_krs, kode_kelas, nilai_angka, nilai_huruf | Lembar Penilaian |

---

## 5. Aturan Bisnis

### Tabel AB-xx: Daftar Aturan Bisnis
| Kode | Aturan Bisnis |
|---|---|
| AB-01 | Setiap mahasiswa memiliki NIM unik yang terdiri dari 10 digit angka. |
| AB-02 | Batas maksimal SKS yang dapat diambil ditentukan berdasarkan IPK semester sebelumnya (maksimal 24 SKS jika IPK $\ge$ 3.00). |
| AB-03 | Pengisian KRS wajib mendapatkan persetujuan (approval) dari Dosen Pembimbing Akademik (PA). |
| AB-04 | Satu kelas perkuliahan memiliki batasan kuota peserta; mahasiswa tidak dapat mengambil kelas yang sudah penuh. |
| AB-05 | Mahasiswa tidak dapat mengambil mata kuliah yang jadwalnya bertabrakan (hari dan jam sama). |
| AB-06 | Nilai akhir perkuliahan terdiri dari gabungan nilai tugas, UTS, dan UAS yang dikonversi menjadi Nilai Huruf (A, B, C, D, E). |
| AB-07 | Dosen hanya dapat menginput nilai untuk kelas yang diampunya. |
| AB-08 | Mahasiswa berstatus non-aktif/cuti tidak diperkenankan mengisi KRS pada semester berjalan. |

---

## 6. Kebutuhan Informasi

### Tabel KI-xx: Daftar Kebutuhan Informasi
| Kode | Kebutuhan Informasi | Data yang Diperlukan |
|---|---|---|
| KI-01 | Daftar mata kuliah dan total SKS yang diambil mahasiswa pada semester aktif | KRS, Detail_KRS, Kelas, Mata_Kuliah |
| KI-02 | Rekapitulasi nilai KHS dan Indeks Prestasi Semester (IPS) mahasiswa | Detail_KRS, Kelas, Mata_Kuliah, Mahasiswa |
| KI-03 | Daftar mahasiswa bimbingan per Dosen Pembimbing Akademik (PA) | Mahasiswa, Dosen |
| KI-04 | Daftar peserta kelas perkuliahan tertentu beserta Dosen Pengampunya | Kelas, Detail_KRS, Mahasiswa, Dosen |
| KI-05 | Laporan sebaran nilai mata kuliah per semester | Detail_KRS, Kelas, Mata_Kuliah |

---

## 7. Matriks CRUD

| Proses | Mahasiswa | Dosen | Mata_Kuliah | Kelas | KRS | Detail_KRS |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| PB-01 Mendaftarkan Mahasiswa Baru | **C** | R | | | | |
| PB-02 Mengelola Data Mata Kuliah | | | **C, U, D** | | | |
| PB-03 Pengisian KRS | R | R | R | R, U | **C, U** | **C, D** |
| PB-04 Menginput Nilai Perkuliahan | R | R | | R | R | **U** |
| PB-05 Mencetak Kartu Hasil Studi (KHS) | R | R | R | R | R | R |
| PB-06 Mengelola Data Dosen | | **C, U** | | | | |

---

## 8. Kamus Data Awal (20 Elemen)

| Elemen Data | Arti | Contoh Nilai | Aturan Validasi | Penanggung Jawab |
|---|---|---|---|---|
| `npm` | Nomor Induk Mahasiswa | 25430081 | Unik, 10 digit angka | Bagian Akademik |
| `nama_mahasiswa` | Nama lengkap mahasiswa | Muhamad Adha Satria Ardiansyah | Teks, maks 100 karakter | Bagian Akademik |
| `prodi` | Program studi mahasiswa | Ilmu Komputer | Teks, pilihan prodi aktif | Bagian Akademik |
| `angkatan` | Tahun masuk mahasiswa | 2023 | 4 digit tahun | Bagian Akademik |
| `status_aktif` | Status akademik mahasiswa | Aktif | Enum: ('Aktif', 'Cuti', 'Lulus') | Bagian Akademik |
| `email_pribadi` | Email pribadi mahasiswa | Satria10@gmail.com | Format email valid, terproteksi | Bagian Akademik |
| `no_hp` | Nomor HP mahasiswa | 089876543215| Digit angka, terproteksi | Bagian Akademik |
| `nip` | Nomor Induk Pegawai Dosen | 19850101201001 | Unik, 18 digit angka | Bagian Kepegawaian |
| `nama_dosen` | Nama lengkap & gelar dosen | Dedi Irawan, S.Kom., M.T.I. | Teks, maks 100 karakter | Bagian Kepegawaian |
| `email_dosen` | Email resmi dosen | mrdedi@kampus.ac.id | Format email valid | Bagian Kepegawaian |
| `kode_mk` | Kode unik mata kuliah | IF2101 | Unik, format huruf & angka | Bagian Kurikulum |
| `nama_mk` | Nama mata kuliah | Basis Data | Teks, maks 100 karakter | Bagian Kurikulum |
| `sks` | Bobot kredit mata kuliah | 3 | Bilangan bulat 1-6 | Bagian Kurikulum |
| `semester_penawaran` | Semester penawaran matkul | 3 | Bilangan bulat 1-8 | Bagian Kurikulum |
| `kode_kelas` | Kode unik kelas perkuliahan | IF2101-A | Unik per semester | Bagian Akademik |
| `ruangan` | Ruang pelaksanaan kuliah | Lab-03 | Teks, maks 20 karakter | Bagian Akademik |
| `kuota` | Kapasitas maksimal kelas | 40 | Bilangan bulat > 0 | Bagian Akademik |
| `tahun_ajaran` | Tahun akademik berjalan | 2026/2027 | Format YYYY/YYYY | Bagian Akademik |
| `nilai_angka` | Nilai akhir berupa angka | 85.50 | Desimal 0.00 - 100.00 | Dosen Pengampu |
| `nilai_huruf` | Konversi nilai huruf | A | Enum: ('A','B','C','D','E') | Dosen Pengampu |

---

## 9. Kebutuhan Non-Fungsional

### Perhitungan Parameter Personal ($P$):
* **NPM:** xx.xx.xxxx79 $\rightarrow$ 2 digit terakhir = 79
* $P = (79 \bmod 9) + 1 = 7 + 1 = \mathbf{8}$
* **Batas Maksimal SKS Tambahan:** $8 + 2 = 10 \text{ SKS}$
* **Perkiraan Volume Mahasiswa Aktif:** $40 + (5 \times 8) = 80 \text{ transaksi KRS/hari}$

* **Volume & Retensi:** Menampung perkiraan 80 pengisian KRS per hari pada masa registrasi. Data historis akademik disimpan permanen (seumur hidup).
* **Privasi & Keamanan Data Pribadi:** Nomor HP (`no_hp`), email pribadi (`email_pribadi`), dan rekapitulasi nilai bersifat rahasia. Data ini hanya boleh diakses oleh Mahasiswa bersangkutan, Dosen PA, dan Kepala Bagian Akademik sesuai UU Pelindungan Data Pribadi.

---

## 10. Dokumen Sumber Fiktif (Kartu Rencana Studi)

```text
======================================================================
                   KARTU RENCANA STUDI (KRS)
                   TAHUN AKADEMIK 2026/2027
======================================================================
NPM           : 25430081             Semester : Ganjil (3)
Nama          : Muhamad Adha Satria Ardiansyah   Dosen PA : Dani Anggoro, M.Kom.
Program Studi : Ilmu Komputer
----------------------------------------------------------------------
No  Kode MK   Nama Mata Kuliah        SKS   Kelas   Hari & Jam
----------------------------------------------------------------------
1   IK-201    Basis Data               3    IK-3A   Senin, 08.00-10.30
2   IK-202    Pemrograman Web          3    IK-3A   Selasa, 10.30-13.00
3   IK-203    Struktur Data            3    IK-3B   Rabu, 08.00-10.30
4   IK-204    Jaringan Komputer        3    IK-3A   Kamis, 13.00-15.30
----------------------------------------------------------------------
TOTAL SKS DIAMBIL : 12 SKS (Maksimal Boleh Diambil: 24 SKS)
----------------------------------------------------------------------
Status Persetujuan : DISETUJUI oleh Dosen PA
======================================================================
```