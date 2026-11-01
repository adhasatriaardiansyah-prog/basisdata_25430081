Laporan Audit Kualitas Data: Proyek Akademik (akad_081)
Nama Mahasiswa: Muhamad Adha Satria Ardiansyah
NPM: 25430081
Mata Kuliah: Praktikum Basis Data (Modul 15)

1. Kerangka Kerja Kualitas Data (Data Quality Framework)
   Merujuk pada kerangka kerja pengelolaan kualitas data (Total Data Quality Management), dimensi yang dievaluasi pada entitas pendaftaran mahasiswa baru meliputi:
- Kelengkapan (Completeness): Atribut wajib seperti nama_mhs, npm_mhs, dan prodi_mhs tidak boleh kosong (NULL).

- Validitas (Validity): Format NPM harus 10 digit numerik murni, nomor HP berawalan 08 dengan panjang 10-13 digit, dan tanggal pendaftaran merupakan tanggal kalender yang valid secara nyata.

- Keunikan (Uniqueness): Satu NPM hanya merepresentasikan satu entitas mahasiswa unik (bebas dari duplikasi data internal berkas maupun duplikasi dengan data eksisting di tabel utama).

- Konsistensi (Consistency): Penulisan program studi harus terstandardisasi ke dalam kamus data baku institusi (misalnya "ilkom" atau "IK" diseragamkan menjadi "Ilmu Komputer").

2. Profil Masalah Awal (Data Profiling)
   Berdasarkan hasil pemindaian (profiling query) terhadap 10 baris data impor kotor pada tabel penampung mahasiswa_impor, ditemukan rincian masalah sebagai berikut:
- HP Tidak Baku / Format Salah: 5 kasus
- NPM Bukan 10 Digit (mengandung karakter strip): 1 kasus
- Nama Kosong / Null: 1 kasus
- NPM Ganda di Berkas: 1 kasus
- Tanggal Tidak Valid (Contoh: 31 September): 1 kasus
- NPM Sudah Terdaftar di Sistem Utama: 1 kasus

3. Tabel Prioritas dan Tindakan Perbaikan

Jenis Masalah | Dimensi Kualitas | Dampak Bisnis | Tindakan / Penanganan
NPM Sudah Terdaftar | Keunikan | Tinggi (Pelanggaran integritas entitas & duplikasi data) | Tolak dan kembalikan ke panitia
NPM Ganda di Berkas | Keunikan | Tinggi (Risiko duplikasi akun akademik) | Saring menggunakan fungsi ROW_NUMBER() (ambil baris pertama)
Tanggal Tidak Valid (31 Sept) | Validitas | Tinggi (Kegagalan integritas basis data / strict mode error) | Tolak konversi tanggal (ubah menjadi NULL / tolak baris)
Nama Kosong | Kelengkapan | Sedang (Data profil tidak lengkap) | Tolak baris karena melanggar atribut wajib
Nomor HP Tidak Baku (+62 / kurang digit) | Validitas | Sedang (Kendala komunikasi / notifikasi) | Perbaiki otomatis via pembersihan regex (REGEXP_REPLACE)
Variasi Penulisan Prodi ("ilkom", "IK") | Konsistensi | Rendah (Ketidakkonsistenan label teks) | Normalisasi otomatis menggunakan kondisional CASE WHEN
Huruf Kecil pada Nama ("ahmad fauzi") | Konsistensi | Rendah (Estetika data) | Perbaiki otomatis menjadi Kapital di awal kata

4. Hasil Sesudah Perbaikan dan Daftar Baris Ditolak

- Jumlah Baris Masuk ke Tabel Utama: 6 baris data bersih berhasil dimasukkan setelah melewati filter duplikasi dan validasi ketat.

- Daftar Baris yang Ditolak (Dikembalikan ke Panitia):
  1. Baris No. 2 (NPM berformat salah & tanggal 31 September tidak valid).
  2. Baris No. 3 (Nama pendaftar kosong).
  3. Baris No. 4 (Duplikasi NPM di dalam berkas pendaftaran).
  4. Baris No. 8 (NPM sudah terdaftar sebelumnya di dalam sistem utama basis data).

