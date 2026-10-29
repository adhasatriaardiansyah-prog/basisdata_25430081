 Dokumen Normalisasi dan Skema Relasional - Sistem Informasi Akademik (Akademi Akad)

Nama: Muhamad Adha Satria Ardiansyah  
NPM: 25430081  
Kelas: C 
Pertemuan: 4 (Modul 4: Normalisasi dan Skema Relasional)  
Tanggal: 13 Oktober 2026  



 1. Titik Awal: Bentuk Tidak Normal (UNF)

 Dokumen sumber yang dianalisis adalah Kartu Rencana Studi (KRS) dan Kartu Hasil Studi (KHS):

 $$\text{KHS\_UNF } (\text{npm}, \text{nama\_mahasiswa}, \text{prodi}, \text{angkatan}, \text{nip\_pa}, \text{nama\_dosen\_pa}, \text{tahun\_ajaran}, \{ \text{kode\_kelas}, \text{kode\_mk}, \text{nama\_mk}, \text{sks}, \text{hari}, \text{jam}, \text{ruangan}, \text{nip\_pengampu}, \text{nama\_dosen\_pengampu}, \text{nilai\_angka}, \text{nilai\_huruf} \}, \text{total\_sks}, \text{ips})$$



 2. Dependensi Fungsional (FD) Berdasarkan Aturan Bisnis

 Ketergantungan fungsional diturunkan langsung dari aturan bisnis (AB-01 s.d. AB-08):

 $\text{FD1: } \text{npm} \rightarrow \text{nama\_mahasiswa, prodi, angkatan, status\_aktif, email\_pribadi, no\_hp, nip\_pa}$ *(AB-01: NIM/NPM unik)*
 $\text{FD2: } \text{nip} \rightarrow \text{nama\_dosen, email\_dosen, no\_hp\_dosen}$ *(Data master dosen pengajar/PA)*
 $\text{FD3: } \text{kode\_mk} \rightarrow \text{nama\_mk, sks, semester\_penawaran}$ *(Katalog kurikulum)*
 $\text{FD4: } \text{kode\_kelas} \rightarrow \text{kode\_mk, ruangan, kuota, hari, jam, nip\_pengampu}$ *(AB-04, AB-05, AB-07)*
 $\text{FD5: } \text{id\_krs} \rightarrow \text{npm, tahun\_ajaran, semester, tgl\_pengajuan, status\_persetujuan}$ *(AB-03, AB-08)*
 $\text{FD6: } \text{id\_krs, kode\_kelas} \rightarrow \text{nilai\_angka, nilai\_huruf}$ *(AB-06: Lembar nilai per kelas)*
 $\text{FD7: } \text{id\_krs} \rightarrow \text{total\_sks, ips} \quad \text{(Nilai turunan: dihitung dinamis, tidak disimpan)}$



 3. Tahapan Normalisasi

 A. Bentuk Normal Pertama (1NF)
 Menghilangkan grup berulang dengan membuat satu baris atomik untuk setiap pengambilan kelas dalam lembar KRS. Kunci primer menjadi komposit $(\text{id\_krs}, \text{kode\_kelas})$.

 $$\text{KHS\_1NF } (\underline{\text{id\_krs}}, \underline{\text{kode\_kelas}}, \text{npm}, \text{nama\_mahasiswa}, \text{prodi}, \text{angkatan}, \text{nip\_pa}, \text{nama\_dosen\_pa}, \text{tahun\_ajaran}, \text{kode\_mk}, \text{nama\_mk}, \text{sks}, \text{hari}, \text{jam}, \text{ruangan}, \text{nip\_pengampu}, \text{nama\_dosen\_pengampu}, \text{nilai\_angka}, \text{nilai\_huruf})$$

 B. Bentuk Normal Kedua (2NF)
 Menghilangkan ketergantungan parsial pada kunci komposit. Atribut yang hanya bergantung pada $\text{id\_krs}$, $\text{kode\_kelas}$, atau $\text{kode\_mk}$ dipisah ke tabel tersendiri:

 $\text{MAHASISWA\_2NF } (\underline{\text{npm}}, \text{nama\_mahasiswa}, \text{prodi}, \text{angkatan}, \text{status\_aktif}, \text{email\_pribadi}, \text{no\_hp}, \text{nip\_pa}, \text{nama\_dosen\_pa})$
 $\text{MATA\_KULIAH\_2NF } (\underline{\text{kode\_mk}}, \text{nama\_mk}, \text{sks}, \text{semester\_penawaran})$
 $\text{KELAS\_2NF } (\underline{\text{kode\_kelas}}, \text{kode\_mk*}, \text{ruangan}, \text{kuota}, \text{hari}, \text{jam}, \text{nip\_pengampu}, \text{nama\_dosen\_pengampu})$
 $\text{KRS\_2NF } (\underline{\text{id\_krs}}, \text{npm*}, \text{tahun\_ajaran}, \text{semester}, \text{tgl\_pengajuan}, \text{status\_persetujuan})$
 $\text{DETAIL\_KRS\_2NF } (\underline{\text{id\_krs*}}, \underline{\text{kode\_kelas*}}, \text{nilai\_angka}, \text{nilai\_huruf})$

 C. Bentuk Normal Ketiga (3NF)
 Menghilangkan ketergantungan transitif $(\text{npm} \rightarrow \text{nip\_pa} \rightarrow \text{nama\_dosen\_pa})$ dan $(\text{kode\_kelas} \rightarrow \text{nip\_pengampu} \rightarrow \text{nama\_dosen\_pengampu})$. Informasi dosen dipisahkan ke dalam tabel master `dosen`:

 $\text{DOSEN } (\underline{\text{id\_dosen}}, \text{nip}, \text{nama\_dosen}, \text{email\_dosen}, \text{no\_hp\_dosen})$
 $\text{MAHASISWA } (\underline{\text{id\_mhs}}, \text{npm}, \text{nama\_mahasiswa}, \text{prodi}, \text{angkatan}, \text{status\_aktif}, \text{email\_pribadi}, \text{no\_hp}, \text{id\_dosen\_pa*})$
 $\text{MATA\_KULIAH } (\underline{\text{id\_mk}}, \text{kode\_mk}, \text{nama\_mk}, \text{sks}, \text{semester\_penawaran})$
 $\text{KELAS } (\underline{\text{id\_kelas}}, \text{kode\_kelas}, \text{id\_mk*}, \text{id\_dosen\_pengampu*}, \text{ruangan}, \text{kuota}, \text{hari}, \text{jam})$
 $\text{KRS } (\underline{\text{id\_krs}}, \text{no\_krs}, \text{id\_mhs*}, \text{tahun\_ajaran}, \text{semester}, \text{tgl\_pengajuan}, \text{status\_persetujuan})$
 $\text{DETAIL\_KRS } (\underline{\text{id\_krs*}}, \underline{\text{id\_kelas*}}, \text{nilai\_angka}, \text{nilai\_huruf})$



 4. Hasil Pemeriksaan BCNF (Boyce-Codd Normal Form)

 Setiap penentu (*determinant*) pada seluruh relasi 3NF di atas merupakan kunci kandidat (*candidate key*). Oleh karena itu, skema relasional ini sudah memenuhi **BCNF**.



 5. Keputusan Penyimpanan Nilai Turunan

 | Nilai Turunan | Rumus / Cara Hitung | Keputusan | Alasan |
 |---|---|---|---|
 | `total_sks` | $\sum \text{sks}$ dari `detail_krs` yang diambil | **TIDAK DISIMPAN** | Dihitung secara dinamis dari `detail_krs` $\times$ `mata_kuliah` saat kueri untuk mencegah anomali ubah jika ada revisi KRS. |
 | `ips` / `ipk` | $\frac{\sum (\text{sks} \times \text{bobot\_nilai})}{\sum \text{sks}}$ | **TIDAK DISIMPAN** | Dihitung otomatis melalui kueri laporan KHS/transkrip nilai. |
 | `status_persetujuan` | Pilihan approval Dosen PA | **DISIMPAN** | Merupakan data status transaksi asli, bukan hasil perhitungan matematis. |



 6. Skema Relasional Akhir (`akad_81`)

 Mengikuti standar penamaan berkas dan objek basis data (surrogate key `id_*` sebagai Primary Key, kode alami sebagai Unique Key, serta akhiran nama tabel pada setiap kolom):

```text
dosen (
    id_dosen INT [PK, AI],
    nip_dosen VARCHAR(18) [UNIQUE, NOT NULL],
    nama_dosen VARCHAR(100) [NOT NULL],
    email_dosen VARCHAR(100) [NOT NULL],
    no_hp_dosen VARCHAR(15) [NULL]
)

mahasiswa (
    id_mhs INT [PK, AI],
    npm_mahasiswa CHAR(10) [UNIQUE, NOT NULL],
    nama_mahasiswa VARCHAR(100) [NOT NULL],
    prodi_mahasiswa VARCHAR(60) [NOT NULL],
    angkatan_mahasiswa YEAR [NOT NULL],
    status_aktif_mahasiswa ENUM('Aktif','Cuti','Lulus') [DEFAULT 'Aktif'],
    email_pribadi_mahasiswa VARCHAR(100) [pribadi, NOT NULL],
    no_hp_mahasiswa VARCHAR(15) [pribadi, NULL],
    id_dosen_pa INT [FK -> dosen.id_dosen]
)

mata_kuliah (
    id_mk INT [PK, AI],
    kode_mk VARCHAR(10) [UNIQUE, NOT NULL],
    nama_mk VARCHAR(100) [NOT NULL],
    sks_mk TINYINT [NOT NULL],
    semester_penawaran_mk TINYINT [NOT NULL]
)

kelas (
    id_kelas INT [PK, AI],
    kode_kelas VARCHAR(15) [UNIQUE, NOT NULL],
    id_mk INT [FK -> mata_kuliah.id_mk],
    id_dosen_pengampu INT [FK -> dosen.id_dosen],
    ruangan_kelas VARCHAR(20) [NOT NULL],
    kuota_kelas SMALLINT [NOT NULL, CHECK > 0],
    hari_kelas ENUM('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu') [NOT NULL],
    jam_kelas VARCHAR(20) [NOT NULL]
)

krs (
    id_krs INT [PK, AI],
    no_krs VARCHAR(20) [UNIQUE, NOT NULL],
    id_mhs INT [FK -> mahasiswa.id_mhs],
    tahun_ajaran_krs VARCHAR(9) [NOT NULL],
    semester_krs ENUM('Ganjil','Genap') [NOT NULL],
    tgl_pengajuan_krs DATE [NOT NULL],
    status_persetujuan_krs ENUM('Diproses','Disetujui','Ditolak') [DEFAULT 'Diproses']
)

detail_krs (
    id_krs INT [PK, FK -> krs.id_krs],
    id_kelas INT [PK, FK -> kelas.id_kelas],
    nilai_angka_detail_krs DECIMAL(5,2) [NULL, CHECK 0.00 - 100.00],
    nilai_huruf_detail_krs ENUM('A','B','C','D','E') [NULL]
)