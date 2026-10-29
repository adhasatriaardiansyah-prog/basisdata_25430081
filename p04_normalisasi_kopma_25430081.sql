# Dokumen Normalisasi dan Skema Relasional - Koperasi Mahasiswa Sejahtera (Kopma)

**Nama:** Muhamad Adha Satria Ardiansyah  
**NPM:** 25430081  
**Kelas:** C
**Pertemuan:** 4 (Modul 4: Normalisasi dan Skema Relasional)  
**Tanggal:** 13 Oktober 2026  

---

## 1. Latar Belakang dan Tujuan Normalisasi
Keluaran dari spreadsheet lama pencatatan Koperasi Mahasiswa (Kopma) Sejahtera memuat berbagai informasi penjualan yang digabung ke dalam satu tabel besar. Hal ini memicu tiga masalah utama (anomali basis data):
* **Anomali Ubah:** Perubahan ejaan nama anggota (misal: "Budi S." menjadi "Budi Santoso") atau perubahan nama pemasok pada satu baris saja menyebabkan inkonsistensi data.
* **Anomali Sisip:** Barang baru atau pemasok baru tidak dapat dicatat ke dalam sistem sebelum ada transaksi penjualan yang melibatkan mereka.
* **Anomali Hapus:** Penghapusan catatan nota penjualan tertentu secara tidak sengaja menghilangkan informasi penting mengenai pemasok atau data master lainnya.

Dokumen ini disusun untuk menerapkan tahapan normalisasi (UNF hingga 3NF) guna menghilangkan anomali tersebut dan menghasilkan **Skema Kanonik Kopma (8 Tabel)** yang andal.

---

## 2. Bentuk Tidak Normal (UNF)
Berdasarkan dokumen sumber spreadsheet lama Kopma, struktur data awal sebelum dinormalisasi adalah sebagai berikut:

$$\text{NOTA\_UNF } (\text{no\_nota\_penjualan}, \text{tgl\_penjualan}, \text{kode\_petugas}, \text{nama\_petugas}, \text{no\_anggota}, \text{nama\_anggota}, \{ \text{kode\_barang}, \text{nama\_barang}, \text{qty\_detail\_penjualan}, \text{harga\_satuan\_detail\_penjualan}, \text{subtotal\_detail\_penjualan} \}, \text{jumlah\_penjualan}, \text{diskon\_penjualan}, \text{total\_penjualan})$$

---

## 3. Dependensi Fungsional (FD) Berdasarkan Aturan Bisnis
Ketergantungan fungsional diturunkan langsung dari aturan bisnis (AB-01 s.d. AB-08) dan dokumen kebutuhan data:

* **FD1:** $\text{no\_nota\_penjualan} \rightarrow \text{tgl\_penjualan, kode\_petugas, no\_anggota, bayar\_penjualan}$ *(Aturan AB-01)*
* **FD2:** $\text{kode\_petugas} \rightarrow \text{nama\_petugas, peran\_petugas}$
* **FD3:** $\text{no\_anggota} \rightarrow \text{nim\_anggota, nama\_anggota, prodi\_anggota, no\_hp\_anggota, status\_anggota}$ *(Aturan AB-05)*
* **FD4:** $\text{kode\_barang} \rightarrow \text{nama\_barang, kategori\_barang, harga\_jual\_barang, stok\_barang}$
* **FD5:** $(\text{no\_nota\_penjualan}, \text{kode\_barang}) \rightarrow \text{qty\_detail\_penjualan, harga\_satuan\_detail\_penjualan}$ *(Aturan AB-04)*
* **FD6:** $\text{qty\_detail\_penjualan} \times \text{harga\_satuan\_detail\_penjualan} \rightarrow \text{subtotal\_detail\_penjualan}$ *(Atribut Nilai Turunan)*

---

## 4. Tahapan Normalisasi (1NF, 2NF, 3NF)

### A. Bentuk Normal Pertama (1NF)
Menghilangkan grup berulang (*repeating group*) pada rincian barang dengan memastikan setiap sel bernilai atomik. Kunci primer diubah menjadi kunci komposit $(\text{no\_nota\_penjualan}, \text{kode\_barang})$.

$$\text{NOTA\_1NF } (\underline{\text{no\_nota\_penjualan}}, \underline{\text{kode\_barang}}, \text{tgl\_penjualan}, \text{kode\_petugas}, \text{nama\_petugas}, \text{no\_anggota}, \text{nama\_anggota}, \text{nama\_barang}, \text{qty\_detail\_penjualan}, \text{harga\_satuan\_detail\_penjualan}, \text{subtotal\_detail\_penjualan}, \text{jumlah\_penjualan}, \text{diskon\_penjualan}, \text{total\_penjualan})$$

### B. Bentuk Normal Kedua (2NF)
Menghilangkan ketergantungan parsial di mana atribut non-kunci hanya bergantung pada sebagian kunci komposit. Relasi dipecah menjadi entitas `penjualan`, `barang`, dan `detail_penjualan`:

* $\text{PENJUALAN\_2NF } (\underline{\text{no\_nota\_penjualan}}, \text{tgl\_penjualan}, \text{kode\_petugas}, \text{nama\_petugas}, \text{no\_anggota}, \text{nama\_anggota}, \text{bayar\_penjualan})$
* $\text{BARANG\_2NF } (\underline{\text{kode\_barang}}, \text{nama\_barang}, \text{kategori\_barang}, \text{harga\_jual\_barang}, \text{stok\_barang})$
* $\text{DETAIL\_PENJUALAN\_2NF } (\underline{\text{no\_nota\_penjualan*}}, \underline{\text{kode\_barang*}}, \text{qty\_detail\_penjualan}, \text{harga\_satuan\_detail\_penjualan})$

### C. Bentuk Normal Ketiga (3NF)
Menghilangkan ketergantungan transitif pada tabel penjualan, di mana atribut non-kunci bergantung pada atribut non-kunci lainnya ($\text{no\_nota} \rightarrow \text{kode\_petugas} \rightarrow \text{nama\_petugas}$ dan $\text{no\_nota} \rightarrow \text{no\_anggota} \rightarrow \text{nama\_anggota}$). Entitas `petugas` dan `anggota` dipisah menjadi tabel master tersendiri.

---

## 5. Pemeriksaan BCNF (Boyce-Codd Normal Form)
Seluruh penentu (`determinant`) pada skema 3NF di atas merupakan kunci kandidat (`candidate key`). Dengan demikian, skema relasional ini telah memenuhi standar **BCNF**.

---

## 6. Keputusan Penyimpanan Nilai Turunan

| Elemen / Atribut | Rumus / Sumber | Keputusan Desain | Alasan Pengambilan Keputusan |
| :--- | :--- | :--- | :--- |
| `subtotal_detail_penjualan` | `qty` $\times$ `harga_satuan_detail` | **TIDAK DISIMPAN** | Dihitung secara dinamis dari tabel detail guna menghindari inkonsistensi data apabila terjadi perubahan atau koreksi transaksi. |
| `jumlah_penjualan` | $\sum \text{subtotal}$ dalam satu nota | **TIDAK DISIMPAN** | Merupakan nilai turunan agregat yang dapat diturunkan langsung saat kueri laporan. |
| `total_penjualan` | $\text{jumlah} - \text{diskon\_anggota}$ | **TIDAK DISIMPAN** | Dihitung secara real-time pada kueri operasional (kecuali pada tabel arsip historis di Buku 2). |
| `harga_satuan_detail_penjualan` | Harga jual saat transaksi terjadi | **DISIMPAN** | Sesuai aturan **AB-04**, harga pada nota harus dikunci secara historis agar kenaikan harga master barang di masa depan tidak mengubah nominal nota lama. |

---

## 7. Skema Kanonik Kopma (8 Tabel Acuan Akhir)

Berdasarkan hasil normalisasi dan integrasi kebutuhan sistem secara menyeluruh, berikut adalah skema kanonik akhir Koperasi Mahasiswa Sejahtera (`kopma_81`) yang terdiri dari 8 tabel:

1. **`petugas`**
   * Primary Key: `id_petugas` (INT, AI)
   * Unique Key: `kode_petugas` (CHAR(3))
   * Atribut Lain: `nama_petugas`, `peran_petugas` (ENUM: 'kasir', 'gudang', 'ketua')

2. **`anggota`**
   * Primary Key: `id_anggota` (INT, AI)
   * Unique Key: `no_anggota` (CHAR(6)), `nim_anggota` (CHAR(10)) `(AB-05)`
   * Atribut Lain: `nama_anggota`, `prodi_anggota`, `no_hp_anggota` (pribadi), `status_anggota`, `tgl_daftar_anggota`

3. **`barang`**
   * Primary Key: `id_barang` (INT, AI)
   * Unique Key: `kode_barang` (VARCHAR(10))
   * Atribut Lain: `nama_barang`, `kategori_barang` (ENUM: 'ATK', 'makanan', 'minuman'), `harga_jual_barang`, `stok_barang` (CHECK $\ge 0$, AB-03), `stok_min_barang`

4. **`pemasok`**
   * Primary Key: `id_pemasok` (INT, AI)
   * Atribut Lain: `nama_pemasok`, `telepon_pemasok`, `alamat_pemasok`

5. **`penjualan`**
   * Primary Key: `id_penjualan` (INT, AI)
   * Unique Key: `no_nota_penjualan` (CHAR(12)) *(AB-01)*
   * Foreign Key: `id_petugas` $\rightarrow$ `petugas(id_petugas)`, `id_anggota` $\rightarrow$ `anggota(id_anggota)` *(NULL = pembeli umum, AB-02)*
   * Atribut Lain: `tgl_penjualan` (DATETIME), `bayar_penjualan`

6. **`detail_penjualan`**
   * Primary Key Komposit: (`id_penjualan`, `id_barang`)
   * Foreign Key: `id_penjualan` $\rightarrow$ `penjualan(id_penjualan)` (ON DELETE CASCADE), `id_barang` $\rightarrow$ `barang(id_barang)`
   * Atribut Lain: `qty_detail_penjualan` (CHECK $> 0$), `harga_satuan_detail_penjualan` *(AB-04)*

7. **`pembelian`**
   * Primary Key: `id_pembelian` (INT, AI)
   * Foreign Key: `id_pemasok` $\rightarrow$ `pemasok(id_pemasok)`
   * Atribut Lain: `no_faktur_pembelian`, `tgl_pembelian`, `status_pembelian` (ENUM: 'dipesan', 'diterima', AB-06)

8. **`detail_pembelian`**
   * Primary Key Komposit: (`id_pembelian`, `id_barang`)
   * Foreign Key: `id_pembelian` $\rightarrow$ `pembelian(id_pembelian)` (ON DELETE CASCADE), `id_barang` $\rightarrow$ `barang(id_barang)`
   * Atribut Lain: `qty_detail_pembelian` (CHECK $> 0$), `harga_beli_detail_pembelian`
