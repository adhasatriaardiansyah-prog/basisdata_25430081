# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera

## 1. Latar Belakang dan Aktivitas Organisasi
Koperasi Mahasiswa (Kopma) Sejahtera mengelola penjualan alat tulis, makanan ringan, dan minuman di lingkungan kampus. Saat ini pengelolaan data masih sering mengalami kendala seperti harga barang naik yang membingungkan pencatatan nota lama, stok di buku catatan minus, serta anggota yang sering lupa membawa kartu anggota saat bertransaksi. Dokumen ini disusun untuk mendefinisikan kebutuhan pengelolaan data sebelum perancangan basis data dilakukan.

---

## 2. Aktor dan Proses Bisnis

### Tabel PB-xx: Daftar Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
| :--- | :--- | :--- | :--- |
| **PB-01** | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| **PB-02** | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| **PB-03** | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| **PB-04** | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| **PB-05** | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| **PB-06** | Mengelola data pemasok | Petugas gudang / Ketua | Ada pendaftaran pemasok baru |

---

## 3. Dokumen Sumber yang Dianalisis
Dokumen sumber utama yang dianalisis adalah **Nota Penjualan Kopma**:
* **Identitas Transaksi:** No Nota, Tanggal/Jam.
* **Relasi Aktor:** Kode Kasir, No Anggota/NIM.
* **Detail Barang:** Kode/Nama Barang, Qty, Harga saat transaksi.
* **Nilai Turunan (Dihitung):** Subtotal, Diskon Anggota (8%), Total, Bayar, Kembali.
* **Data Pembayaran:** Metode/Data pembayaran tunai.

---

## 4. Entitas Kandidat dan Elemen Data

| Entitas Kandidat | Elemen Data Utama | Sumber |
| :--- | :--- | :--- |
| **Anggota** | `no_anggota`, `nim_anggota`, `nama`, `prodi`, `no_hp`, `status_aktif`, `poin_loyalitas` | Formulir pendaftaran |
| **Barang** | `kode_barang`, `nama_barang`, `kategori`, `harga_jual`, `stok`, `batas_minimum_stok` | Daftar barang, faktur |
| **Penjualan** | `no_nota`, `tanggal_jam`, `kode_kasir`, `no_anggota`, `total_bayar` | Nota penjualan |
| **Detail Penjualan** | `no_nota`, `kode_barang`, `qty`, `harga_satuan_detail` | Nota penjualan |
| **Petugas** | `kode_petugas`, `nama_petugas`, `peran` | Wawancara |
| **Pemasok** | `kode_pemasok`, `nama_pemasok`, `telepon`, `alamat` | Faktur pemasok |
| **Pembelian** | `no_faktur`, `tanggal`, `kode_pemasok`, `kode_barang`, `qty`, `harga_beli` | Faktur pemasok |

---

## 5. Aturan Bisnis

### Tabel AB-xx: Daftar Aturan Bisnis
| Kode | Aturan Bisnis |
| :--- | :--- |
| **AB-01** | Setiap nota memiliki nomor unik dan minimal berisi satu baris barang, dengan batas maksimal **10 item per transaksi**. |
| **AB-02** | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon **8%**. |
| **AB-03** | Stok barang tidak boleh negatif; penjualan ditolak bila `qty` melebihi stok yang tersedia. |
| **AB-04** | Harga jual yang dipakai pada nota disimpan per baris detail transaksi dan tidak berubah meskipun harga barang induk naik. |
| **AB-05** | NIM anggota bersifat unik; pencarian anggota dapat dilakukan melalui nomor anggota atau NIM. |
| **AB-06** | Pesanan pembelian dibuat otomatis/manual bila stok barang kurang dari batas minimum. |
| **AB-07** | Setiap kelipatan Rp10.000 belanja anggota bernilai 1 poin; 50 poin dapat ditukar potongan Rp5.000. |
| **AB-08** | Pendaftaran pemasok baru harus dicatat sebelum transaksi pembelian dari pemasok tersebut dapat dilakukan. |

---

## 6. Kebutuhan Informasi

### Tabel KI-xx: Daftar Kebutuhan Informasi
| Kode | Kebutuhan Informasi | Data yang Diperlukan |
| :--- | :--- | :--- |
| **KI-01** | Omzet dan jumlah nota per hari dan per bulan | Penjualan, Detail Penjualan |
| **KI-02** | Lima barang terlaris per bulan berdasarkan total `qty` terjual | Detail Penjualan, Barang |
| **KI-03** | Daftar barang dengan stok di bawah batas minimum | Barang |
| **KI-04** | Sepuluh anggota dengan total belanja terbesar per bulan | Penjualan, Detail Penjualan, Anggota |
| **KI-05** | Laporan rekapitulasi poin loyalitas anggota aktif | Anggota, Penjualan |

---

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **PB-01** Mendaftarkan anggota | C | | | | | |
| **PB-02** Mencatat penjualan | R | R, U | C | C | | |
| **PB-03** Memesan barang ke pemasok | | R | | | R | C |
| **PB-04** Menerima barang dari pemasok | | U | | | R | U |
| **PB-05** Menyusun laporan bulanan | R | R | R | R | | R |
| **PB-06** Mengelola data pemasok | | | | | C, U | |

---

## 8. Kamus Data Awal

| Elemen Data | Arti | Contoh Nilai | Aturan Validasi | Penanggung Jawab |
| :--- | :--- | :--- | :--- | :--- |
| `no_anggota` | Nomor unik anggota | A-0457 | Unik, format A-4 digit | Ketua |
| `nim_anggota` | NIM mahasiswa | 2301010179 | Unik, 10 digit | Ketua |
| `no_hp` | Nomor HP anggota | 08123456789 | Data pribadi, terproteksi | Ketua |
| `no_nota_penjualan` | Nomor nota transaksi | PJ-2609-0142 | Unik per nota | Kasir |
| `harga_satuan_detail` | Harga jual saat transaksi | 4000 | Bilangan bulat $\ge 0$ | Kasir |
| `stok_barang` | Jumlah barang tersedia | 35 | Bilangan bulat $\ge 0$ (AB-03) | Petugas Gudang |
| `poin_loyalitas` | Total poin anggota | 15 | Bilangan bulat $\ge 0$ | Ketua |

---

## 9. Kebutuhan Non-Fungsional
1. **Perhitungan Parameter Personal ($P$):**
   * NIM: **xx.xx.xxxx79** $\rightarrow$ 2 digit terakhir $= 79$[cite: 10]
   * $P = (79 \pmod 9) + 1 = 7 + 1 = \mathbf{8}$[cite: 10]
   * Batas Maksimal Item/Transaksi $= 8 + 2 = \mathbf{10\text{ item}}$[cite: 10]
   * Diskon Anggota $= \mathbf{8\%}$[cite: 10]
   * Perkiraan Volume Transaksi $= 40 + (5 \times 8) = \mathbf{80\text{ nota/hari}}$[cite: 10]
2. **Volume & Retensi:** Menampung perkiraan 80 nota per hari. Data transaksi disimpan minimal **5 tahun**.
3. **Privasi & Keamanan:** Nomor HP dan data pribadi anggota bersifat rahasia dan aksesnya dibatasi khusus untuk Ketua Koperasi sesuai UU Pelindungan Data Pribadi.

---

## 10. Isu Kualitas Data yang Diantisipasi
* **Perubahan Harga Barang:** Diantisipasi dengan menyimpan `harga_satuan_detail` secara historis pada entitas *Detail Penjualan* (AB-04).
* **Pencegahan Stok Minus:** Diantisipasi dengan pengecekan ketersediaan stok secara *real-time* sebelum transaksi disimpan (AB-03).
* **Pencarian Anggota:** Pencarian dapat dilakukan menggunakan `nim_anggota` jika kartu fisik hilang/lupa dibawa (AB-05).