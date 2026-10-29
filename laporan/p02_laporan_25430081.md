Laporan Praktikum Basis Data

Nama: Muhammad Adha Satria Ardiansyah
NPM: 25430081
Kelas: C
Tanggal: 07 Oktober 2026

1. Tujuan Praktikum

Mempraktikkan pembuatan struktur basis data fisik menggunakan Data Definition Language (DDL) pada MariaDB, mencakup pembuatan tabel master dan tabel relasional dengan implementasi Primary Key dan Foreign Key, serta melakukan ekspor basis data (`mysqldump`) untuk diintegrasikan ke dalam repositori Git/GitHub.

2. Ringkasan Dasar Teori

Data Definition Language (DDL) adalah kelompok perintah SQL yang digunakan untuk mendefinisikan dan memodifikasi struktur objek dalam basis data (seperti `CREATE TABLE` dan `DROP TABLE`). Integritas referensial (Referential Integrity) dicapai dengan menggunakan Foreign Key untuk menghubungkan Primary Key dari tabel induk (master) ke tabel anak (relasional), guna menjaga konsistensi data dan mencegah penghapusan data induk yang sedang dirujuk. Pencadangan struktur basis data fisik dapat dilakukan menggunakan utilitas `mysqldump`.

3. Hasil Langkah Percobaan

Bagian ini menampilkan dokumentasi eksekusi perintah terminal beserta tangkapan layar (screenshot) yang meliputi:

- Pembuatan tabel master: `mahasiswa`, `dosen`, dan `mata_kuliah`.
- Pembuatan tabel relasional: `kelas` dan `krs` beserta pengaturan `FOREIGN KEY`.
- Pengecekan daftar tabel yang berhasil dibuat melalui kueri `SHOW TABLES;`.
- Pengujian simulasi pesan kesalahan pada struktur tabel dan relasi (ERROR 1050 dan ERROR 1451).
- Eksekusi perintah `mysqldump` untuk menghasilkan berkas `akad_081.sql`.
- Bukti eksekusi Git (`git add`, `git commit`, `git push`) untuk mengunggah file laporan dan SQL ke GitHub.

4. Jawaban Titik Analisis

- Titik Analisis 1: Penerapan `FOREIGN KEY` mewajibkan tipe data dan panjang karakter pada kolom referensi di tabel anak harus sama persis dengan tipe data `PRIMARY KEY` di tabel induk. Jika berbeda, MariaDB akan menolak pembuatan tabel tersebut.
- Titik Analisis 2: Penggunaan tipe data `VARCHAR(15)` untuk NPM dan NIDN lebih disarankan dibandingkan tipe data numerik seperti `INT`, karena identitas akademik seringkali diawali dengan angka nol atau tidak difungsikan untuk operasi matematis murni.
- Titik Analisis 3: Atribut `AUTO_INCREMENT` pada `id_krs` di tabel `krs` memungkinkan sistem basis data secara otomatis menghasilkan nilai urut dan unik setiap kali ada baris data baru yang dimasukkan, sehingga mempermudah proses pendataan dan menghindari duplikasi kunci utama.
- Titik Analisis 4: Kesalahan `ERROR 1451: Cannot delete or update a parent row` merupakan bentuk perlindungan sistem (referential integrity constraints) yang mencegah terhapusnya tabel induk (seperti tabel `kelas`) jika struktur datanya masih digunakan sebagai referensi oleh tabel anak (`krs`).

5. Hasil Latihan dan Modifikasi

- Membuat tabel `kelas` (tabel penjadwalan) yang menghubungkan entitas pada tabel `mata_kuliah` melalui kolom `kode_mk` dan entitas pada tabel `dosen` melalui kolom `nidn`.
- Membuat tabel `krs` yang menghubungkan entitas `mahasiswa` (npm) dan entitas `kelas` (id_kelas) sekaligus menyiapkan atribut pencatatan akademik tambahan yaitu `semester` dan `nilai_huruf`.
- Melakukan modifikasi skenario perombakan tabel dengan melakukan eksekusi perintah `DROP TABLE` secara berurutan, dimulai dari menghapus tabel anak (tabel transaksi) terlebih dahulu, baru kemudian menghapus tabel induk (tabel master).

6. Tugas Mandiri: Milestone Proyek 2

- Mengeksekusi rancangan struktur tabel menjadi 5 tabel fisik secara utuh untuk basis data `akad_081`.
- Memastikan keterhubungan dan kelengkapan tabel menggunakan perintah `SHOW TABLES;`.
- Mengekspor seluruh basis data fisik `akad_081` menjadi berkas `akad_081.sql` menggunakan `mysqldump`.
- Mengunggah berkas rancangan `p02_kebutuhan_data_25430081.md` dan berkas dump SQL ke repositori lokal dan menyinkronkannya dengan repositori GitHub.

7. Pembahasan dan Kendala

Ada beberapa kendala yang saya alami yaitu yang pertama adanya pesan error 1050 pada saat saya mencoba membuat tabel dibasis data dan yang kedua adalah adanya pesan error 1451 pada saat saya mencoba menghapus tabel kelas.

8. Kesimpulan

Praktikum Modul 2 ini berhasil mengimplementasikan rancangan struktur fisik basis data secara utuh di MariaDB. Pemahaman mengenai urutan pembuatan tabel yang wajib mendahulukan pembuatan tabel `master` sebelum tabel `relasional` serta kemampuan mengatasi kendala integritas relasi (`foreign key constraint`) menjadi kunci sukses dalam perancangan DDL basis data. Seluruh hasil rancangan tabel berhasil dicadangkan ke format SQL dan diamankan menggunakan sistem version control Git.

9. Pernyataan Penggunaan AI

Saya menggunakan AI karena untuk membantu saya bagaimana caranya menghubungkan relasi antartabel menggunakan Foreign Key, serta untuk menjelaskan penyebab adanya pesan error sql seperti error 1050 dan 1451. 

10. Bukti Git

* Tautan Repositori: [https://github.com/adhasatriaardiansyah-prog/basisdata_25430081]
* Hash Commit: `863f38b`

Checklist

* [x] Berkas hasil ekspor SQL `akad_081.sql` ada di repositori.
* [x] Berkas laporan tugas `p02_kebutuhan_data_25430081.md` berhasil diunggah (di-commit).
* [x] Tangkapan layar langkah pembentukan tabel master dan relasional lengkap.
* [x] Tangkapan layar penanganan error integritas (troubleshooting) tersedia.
* [x] Jawaban Titik Analisis 1-4 lengkap.