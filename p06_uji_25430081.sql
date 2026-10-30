# Dokumen Skenario Uji Basis Data Akademik (Modul 6)

**Nama** : Muhammad Adha Satria Ardiansyah  
**NPM** : 25430081  
**Kelas** : C  
**Mata Kuliah** : Basis Data  
**Berkas** : p06_uji_25430081.sql  
**Basis Data** : `akad_081`  

---

## A. Ringkasan Pengujian
Dokumen ini berisi daftar skenario uji positif dan negatif untuk membuktikan integritas basis data `akad_081`[cite: 2]. Pengujian mencakup validasi aturan bisnis akademik, batasan *constraint* DDL (PRIMARY KEY, UNIQUE, FOREIGN KEY, CHECK), serta kebijakan mode aman laboratorium (*sql_safe_updates*)[cite: 2].

---

## B. Tabel Skenario Uji

| Kode | Masukan / Perintah SQL | Harapan | Hasil Nyata dari Layar | Aturan / Constraint | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **UJ-01** | `INSERT INTO krs (no_krs, id_mhs, tahun_ajaran_krs, semester_krs, tgl_pengajuan_krs, status_persetujuan_krs) VALUES ('KRS-20251-099', 1, '2025/2026', 'Ganjil', '2025-09-01', 'Disetujui');` | Diterima | `Query OK, 1 row affected (0.002 sec)` | Validasi Pengisian KRS Mahasiswa | **LULUS** |
| **UJ-02** | `INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka_detail_krs, nilai_huruf_detail_krs) VALUES (1, 1, 90.00, 'A');` | Diterima | `Query OK, 1 row affected (0.001 sec)` | Pengambilan Kelas Valid | **LULUS** |
| **UJ-03** | `UPDATE mata_kuliah SET sks_mk = -2 WHERE id_mk = 1;` | Ditolak server dengan galat | `ERROR 4025 (23000): CONSTRAINT 'ck_mk_sks' failed for 'akad_081'.'mata_kuliah'` | Batasan SKS (> 0) / `ck_mk_sks`[cite: 2] | **LULUS** |
| **UJ-04** | `INSERT INTO mahasiswa (npm_mahasiswa, nama_mahasiswa, prodi_mahasiswa, angkatan_mahasiswa, email_pribadi_mahasiswa) VALUES ('25430081', 'M. Adha Dup', 'Ilmu Komputer', 2025, 'duplikat@gmail.com');` | Ditolak server dengan galat | `ERROR 1062 (23000): Duplicate entry '25430081' for key 'uq_mahasiswa_nim'` | Unik NIM Mahasiswa (`npm_mahasiswa`) | **LULUS** |
| **UJ-05** | `INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka_detail_krs) VALUES (1, 1, 150.00);` | Ditolak server dengan galat | `ERROR 4025 (23000): CONSTRAINT 'ck_detail_nilai' failed for 'akad_081'.'detail_krs'` | Batasan Nilai (0 - 100) / `ck_detail_nilai`[cite: 2] | **LULUS** |
| **UJ-06** | `INSERT INTO dosen (nip_dosen, nama_dosen, email_dosen) VALUES ('198005152005', 'Dosen Kembar', 'dosenkembar@umpetro.ac.id');` | Ditolak server dengan galat | `ERROR 1062 (23000): Duplicate entry '198005152005' for key 'uq_dosen_nip'` | Unik NIP Dosen (`nip_dosen`) | **LULUS** |
| **UJ-07** | `INSERT INTO krs (no_krs, id_mhs, tahun_ajaran_krs, semester_krs, tgl_pengajuan_krs) VALUES ('KRS-20251-100', 99, '2025/2026', 'Ganjil', '2025-09-01');` | Ditolak server dengan galat | `ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails ('akad_081'.'krs', CONSTRAINT 'fk_krs_mhs' FOREIGN KEY ('id_mhs') REFERENCES 'mahasiswa' ('id_mhs'))` | Validasi `Foreign Key` Mahasiswa (`fk_krs_mhs`) | **LULUS** |
| **UJ-08** | `UPDATE mata_kuliah SET sks_mk = sks_mk + 1;` `(pada mode aman `sql_safe_updates = 1`)` | Ditolak server dengan galat | `ERROR 1175 (HY000): You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column` | Kebijakan Lab / Safe Update Mode[cite: 2] | **LULUS** |
| **UJ-09** | `DELETE FROM mahasiswa WHERE id_mhs = 1;` | Ditolak server demi integritas data | `ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails ('akad_081'.'krs', CONSTRAINT 'fk_krs_mhs' FOREIGN KEY ('id_mhs') REFERENCES 'mahasiswa' ('id_mhs'))` | Integritas Referensial (*Foreign Key*)[cite: 2] | **LULUS** |
| **UJ-10** | `INSERT INTO detail_krs (id_krs, id_kelas, nilai_angka_detail_krs) VALUES (1, 1, 85.00);` *(Mahasiswa mengambil mata kuliah yang sama dua kali)* | Harusnya ditolak oleh aturan bisnis perkuliahan | `Query OK, 1 row affected (0.002 sec)` *(Berhasil masuk)* | Aturan Bentrok Jadwal / Duplikasi Kelas (Utang Desain Modul 14)[cite: 2] | **GAGAL (Expected)** |

---

## C. Catatan & Analisis Hasil Pengujian

1. **Uji Positif (UJ-01 & UJ-02):** Berhasil menambahkan data KRS dan entri detail pengambilannya untuk mahasiswa.
2. **Uji Negatif (UJ-03 s.d. UJ-09):** Server berhasil menolak input SKS/nilai tidak valid, NIM (*npm_mahasiswa*) / NIP duplikat, pelanggaran *foreign key* (`fk_krs_mhs`), serta mencegah perintah `UPDATE` tanpa klausa `WHERE` pada kolom kunci saat mode aman aktif[cite: 2].
3. **Uji Gagal Terencana (UJ-10 - Utang Desain Modul 14):** Uji UJ-10 berstatus **GAGAL** karena server database belum memiliki pemicu (*Trigger*) untuk mencegah pengambilan kelas yang bentrok jadwal atau duplikasi secara otomatis. Fitur ini dicatat sebagai utang desain yang akan diselesaikan pada Modul 14.