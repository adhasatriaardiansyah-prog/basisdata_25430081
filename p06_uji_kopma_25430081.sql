# Dokumen Skenario Uji Basis Data Kopma (Modul 6)

**Nama** : Muhammad Adha Satria Ardiansyah  
**NPM** : 25430081  
**Kelas** : C  
**Mata Kuliah** : Basis Data  
**Berkas** : p06_uji_kopma_25430081.sql  
**Basis Data** : `kopma_081`  

---

## A. Ringkasan Pengujian
Dokumen ini berisi daftar skenario uji positif dan negatif untuk membuktikan integritas basis data `kopma_081`[cite: 2]. Pengujian mencakup validasi aturan bisnis (AB-xx), batasan *constraint* DDL (PRIMARY KEY, UNIQUE, FOREIGN KEY, CHECK), serta kebijakan mode aman laboratorium (*sql_safe_updates*)[cite: 2, 4].

---

## B. Tabel Skenario Uji

| Kode | Masukan / Perintah SQL | Harapan | Hasil Nyata dari Layar | Aturan / Constraint | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **UJ-01** | `INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES ('PJ-2610-099', '2026-10-01 10:00:00', 1, 1, 20000);` | Diterima | `Query OK, 1 row affected (0.002 sec)` | AB-02 (Nota dengan anggota aktif) | **LULUS** |
| **UJ-02** | `INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES ('PJ-2610-100', '2026-10-01 10:15:00', 1, NULL, 15000);` | Diterima, `id_anggota` bernilai NULL | `Query OK, 1 row affected (0.001 sec)` | AB-02 (Nota pelanggan umum) | **LULUS** |
| **UJ-03** | `UPDATE barang SET stok_barang = -5 WHERE id_barang = 1;` | Ditolak server dengan galat | `ERROR 4025 (23000): CONSTRAINT 'ck_barang_stok' failed for 'kopma_081'.'barang'` | AB-03 / `ck_barang_stok` | **LULUS** |
| **UJ-04** | `INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES ('PJ-2610-001', '2026-10-01 08:15:00', 1, 1, 20000);` | Ditolak server dengan galat | `ERROR 1062 (23000): Duplicate entry 'PJ-2610-001' for key 'uq_penjualan_nota'` | AB-01 / `uq_penjualan_nota` | **LULUS** |
| **UJ-05** | `INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan) VALUES (1, 2, 0, 6500);` | Ditolak server dengan galat | `ERROR 4025 (23000): CONSTRAINT 'ck_detail_qty' failed for 'kopma_081'.'detail_penjualan'` | `ck_detail_qty` | **LULUS** |
| **UJ-06** | `INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, status_anggota, tgl_daftar_anggota) VALUES ('AGT-999', '25430081', 'Budi Baru', 'Ilmu Komputer', 'aktif', '2026-10-01');` | Ditolak server dengan galat | `ERROR 1062 (23000): Duplicate entry '25430081' for key 'uq_anggota_nim'` | AB-05 / `uq_anggota_nim` | **LULUS** |
| **UJ-07** | `INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES ('PJ-2610-101', '2026-10-01 11:00:00', 99, 1, 20000);` | Ditolak server dengan galat | `ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails ('kopma_081'.'penjualan', CONSTRAINT 'fk_penjualan_petugas' FOREIGN KEY ('id_petugas') REFERENCES 'petugas' ('id_petugas'))` | `fk_penjualan_petugas` | **LULUS** |
| **UJ-08** | `UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1;` *(pada mode aman `sql_safe_updates = 1`)* | Ditolak server dengan galat | `ERROR 1175 (HY000): You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column` | Kebijakan Lab / Safe Update Mode | **LULUS** |
| **UJ-09** | `DELETE FROM petugas WHERE id_petugas = 1;` | Ditolak server demi integritas data | `ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails ('kopma_081'.'penjualan', CONSTRAINT 'fk_penjualan_petugas' FOREIGN KEY ('id_petugas') REFERENCES 'petugas' ('id_petugas'))` | `fk_penjualan_petugas` | **LULUS** |
| **UJ-10** | `INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan) VALUES (1, 1, 999, 4000);` *(Gudang hanya punya stok 150)* | Harusnya ditolak oleh aturan bisnis (AB-03) | `Query OK, 1 row affected (0.002 sec)` *(Berhasil masuk, stok belum berkurang secara otomatis)* | AB-03 (Utang Desain Modul 14) | **GAGAL (Expected)** |

---

## C. Catatan & Analisis Hasil Pengujian

1. **Uji Positif (UJ-01 & UJ-02):** Berhasil menambahkan data nota baru baik yang terikat dengan anggota aktif maupun pelanggan umum (`id_anggota = NULL`)[cite: 4].
2. **Uji Negatif (UJ-03 s.d. UJ-09):** Berhasil menolak input data yang tidak valid, duplikasi kunci unik, pelanggaran *foreign key*, serta mencegah perintah `UPDATE` masal tanpa kunci `WHERE` saat mode aman aktif[cite: 2, 4].
3. **Uji Gagal Terencana (UJ-10 - Utang Desain Modul 14):** Uji UJ-10 menunjukkan status **GAGAL** karena *constraint* `CHECK` pada tabel `barang` hanya memvalidasi nilai lokal di tabel `barang` itu sendiri[cite: 4]. Server belum dapat mencegah transaksi penjualan yang melebihi batas stok gudang secara otomatis sebelum fitur *Trigger* dipasang pada Modul 14[cite: 4].