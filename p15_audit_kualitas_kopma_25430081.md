Laporan Audit Kualitas Data: Proyek Koperasi Mahasiswa (kopma_081)
Nama Mahasiswa: Muhamad Adha Satria Ardiansyah
NPM: 25430081
Mata Kuliah: Praktikum Basis Data (Modul 15)

1. Kerangka Kerja Kualitas Data (Data Quality Framework - Kopma)
   Merujuk pada kerangka kerja Total Data Quality Management (TDQM), dimensi kualitas data yang dievaluasi pada sistem Koperasi Mahasiswa (kopma_081) mencakup:

* Kelengkapan (Completeness): Atribut utama anggota seperti `nama_anggota`, `no_anggota`, dan `jenis_anggota` tidak boleh bernilai NULL atau kosong.

* Validitas (Validity): Format Nomor Anggota Kopma harus mematuhi standar institusi (`KOP-YYYYXXXX`), nomor HP wajib berawalan `08`, nominal simpanan pokok harus berupa nilai numerik valid (`DECIMAL`), dan tanggal pendaftaran merupakan tanggal kalender riil.

* Keunikan (Uniqueness): Satu Nomor Anggota hanya boleh dikaitkan dengan satu entitas anggota koperasi untuk mencegah penggandaan akun pembagian SHU (Sisa Hasil Usaha).

* Konsistensi (Consistency): Pengelompokan jenis keanggotaan terstandardisasi penuh (misalnya "biasa", "anggota biasa" diseragamkan menjadi "Anggota Biasa").

2. Profil Masalah Awal (Data Profiling Kopma)
   Berdasarkan hasil eksekusi kueri *data profiling* terhadap 10 baris data impor kotor pada `anggota_kopma_impor`, teridentifikasi rincian kesalahan berikut:

* Nomor HP Tidak Baku / Format Salah: 5 kasus (penggunaan kode negara +62, spasi, atau jumlah digit tidak baku)

* Format Nomor Anggota Salah: 1 kasus (terdapat karakter tambahan `-x`)

* Nama Anggota Kosong: 1 kasus

* Nomor Anggota Ganda di Berkas: 1 kasus (`KOP-25430001`)

* Tanggal Pendaftaran Tidak Valid: 1 kasus (tanggal 31 September)

* Simpanan Pokok Non-Numerik: 1 kasus (berisi string "ABC")

* Nomor Anggota Sudah Terdaftar di Sistem Utama: 1 kasus (`KOP-25430002`)

3. Matriks Prioritas Risiko dan Tindakan Penanganan

Jenis Masalah | Dimensi Kualitas | Dampak Bisnis Kopma | Tindakan / Penanganan
No Anggota Sudah Terdaftar | Keunikan | Sangat Tinggi (Pencatatan saldo simpanan & transaksi ganda) | Ditolak oleh filter NOT EXISTS
No Anggota Ganda di Berkas | Keunikan | Tinggi (Kekacauan pembagian SHU anggota) | Disaring dengan fungsi `ROW_NUMBER() OVER (PARTITION BY ...)`
Tanggal Tidak Valid (31 Sept) | Validitas | Tinggi (Kegagalan fungsi kalkulasi pembukuan bulanan) | Konversi tanggal gagal diubah menjadi NULL, baris ditolak
Nama Anggota Kosong | Kelengkapan | Sedang (Identitas pemilik simpanan anonim) | Baris ditolak saat migrasi ke tabel utama
Simpanan Pokok Non-Numerik | Validitas | Sedang (Kesalahan perhitungan keuangan/laporan kas) | Konversi otomatis ke `0.00` atau ditolak
Format No HP Tidak Baku | Validitas | Rendah (Kendala notifikasi pengumuman RAT/SHU) | Normalisasi otomatis via `REGEXP_REPLACE` dan `CASE WHEN`
Variasi Penulisan Jenis Anggota | Konsistensi | Rendah (Ketidakrapian data master) | Standardisasi otomatis menggunakan `CASE WHEN`

4. Hasil Pengolahan Data dan Baris Ditolak

* Baris Lolos Migrasi ke Tabel Utama `anggota`: 6 baris data bersih berhasil dimasukkan secara valid.

* Daftar Baris yang Ditolak (Dikembalikan ke Pengurus Koperasi):

  1. Baris No. 2: Format Nomor Anggota cacat (`KOP-25430082-x`) dan tanggal 31 September tidak valid.

  2. Baris No. 3: Nama anggota pendaftar tidak diisi (kosong).

  3. Baris No. 4: Duplikasi Nomor Anggota (`KOP-25430001`) di dalam berkas impor.

  4. Baris No. 8: Nomor Anggota (`KOP-25430002`) telah terdaftar secara sah di sistem utama Kopma.

