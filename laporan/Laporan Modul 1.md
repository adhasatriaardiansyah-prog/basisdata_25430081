Laporan Praktikum Basis Data

Nama: Muhamad Adha Satria Ardiansyah
NPM: 25430081
Kelas: C
Tanggal: 05 Oktober 2026

1. Tujuan Praktikum

Mempersiapkan dan mengonfigurasi server MariaDB menggunakan paket XAMPP, meningkatkan keamanan pada akun root, membangun basis data beserta akun pengguna khusus untuk keperluan proyek, serta melakukan inisialisasi dan sinkronisasi repositori lokal Git dengan GitHub.

2. Ringkasan Dasar Teori

MariaDB beroperasi mengacu pada skema arsitektur klien-server menggunakan port standar TCP 3306. Pengelolaan layanan server basis data dipermudah melalui antarmuka Control Panel XAMPP, sedangkan penelusuran versi serta rekam jejak berkas dikelola secara berkala oleh Git menggunakan mekanisme commit.

3. Hasil Langkah Percobaan

Bagian ini menampilkan dokumentasi eksekusi perintah terminal beserta tangkapan layar (screenshot) yang meliputi:
- Pengecekan versi MariaDB serta identitas pengguna aktif via `SELECT VERSION(), CURRENT_USER();`.
- Verifikasi mode operasional server SQL menggunakan kueri `SELECT @@sql_mode;`.
- Inspeksi hak akses basis data `SHOW DATABASES;` dari tiga tingkatan pengguna berbeda.
- Pengujian simulasi pesan kesalahan/galat sistem (ERROR 1044, ERROR 1045, dan ERROR 1142).
- Tangkapan layar antarmuka login phpMyAdmin berbasis otentikasi mode cookie.
- Bukti eksekusi pengunggahan awal repositori ke GitHub melalui perintah `git push`.

4. Jawaban Titik Analisis

- Titik Analisis 1: Meskipun antarmuka XAMPP menggunakan label "MySQL", engine yang sesungguhnya beroperasi adalah MariaDB. Panduan MySQL masih dapat digunakan untuk sintaks SQL umum, tetapi dokumentasi MariaDB wajib dirujuk untuk fungsionalitas khusus server, penanganan error, serta jenis mesin penyimpanan.
- Titik Analisis 2: Upaya akses masuk ulang tanpa argumen `-p` memicu ERROR 1045 dengan pesan `using password: NO`. Hal ini membuktikan bahwa klien gagal menyertakan kata sandi yang telah diwajibkan oleh konfigurasi keamanan server.
- Titik Analisis 3: Basis data `information_schema` tetap dapat diakses karena fungsinya sebagai penyedia informasi sistem secara umum. Sebaliknya, upaya mengakses basis data `mysql` menghasilkan ERROR 1044 akibat keterbatasan privilege (hak akses) pada akun kerja yang sedang digunakan.
- Titik Analisis 4: Implementasi mode cookie memberikan tingkat keamanan yang lebih tinggi karena mewajibkan input kata sandi pada setiap sesi login. Hal ini jauh lebih aman dibandingkan mode config yang rentan karena menyimpan password secara terbuka di dalam berkas konfigurasi.

5. Hasil Latihan dan Modifikasi

- Membuat akun `tamu_123`yang hanya diberi izin SELECT pada `kopma_123`, dan memvalidasinya lewat percobaan perintah CREATE TABLE yang ditolak sistem dengan pesan ERROR 1142.
- Menambahkan sintaks IF NOT EXISTS pada skrip kueri agar aman dari pesan error saat dijalankan secara berulang.

6. Tugas Mandiri: Milestone Proyek 1

- Penyiapan database proyek `akad_081` dengan mengimplementasikan pengodean karakter utf8mb4.
- Penciptaan akun pengembang `dev_081` yang memiliki hak kendali penuh atas database proyek tersebut.
- Penyertaan profil proyek ke dalam dokumen `README.md` dan inisiasi berkas `.gitignore` .

7. Pembahasan dan Kendala

Kendala saya yaitu gagal melakukan `commit` karena identitas (`user.name` dan `user.email`) belum terkonfirmasi dan ketika proses `git push` saya sempat gagal karena saya tidak mempunyai koneksi internet.

8. Kesimpulan

Praktikum ini berhasil menyiapkan lingkungan basis data MariaDB dan repositori Git secara terintegrasi, sekaligus mengimplementasikan keamanan akun berdasarkan prinsip least privilege.

9. Pernyataan Penggunaan AI

Saya menggunakan AI untuk membantu saya mengerjakan error pada terminal git, dan membantu saya untuk struktur laporannya.

10. Bukti Git

- Tautan Repositori: [https://github.com/adhasatriaardiansyah-prog/basisdata_25430081]
- Hash Commit: `666fcc1`

Checklist

- [x] Berkas skrip SQL `p01_lingkungan_25430081.sql` ada di repositori.

- [x] Berkas `README.md` dan `.gitignore` sudah dibuat.

- [x] Tangkapan layar langkah percobaan lengkap di folder laporan/img/.

- [x] Jawaban Titik Analisis 1-4 lengkap.

