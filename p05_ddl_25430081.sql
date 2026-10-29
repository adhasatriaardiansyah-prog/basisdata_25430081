-- =====================================================================
-- Nama      : Muhamad Adha Satria Ardiansyah
-- NPM       : 25430081
-- Kelas     : C
-- Modul     : Modul 5 (DDL dan Constraint)
-- Berkas    : p05_ddl_25430081.sql
-- Basis Data: akad_081
-- =====================================================================

CREATE DATABASE IF NOT EXISTS akad_081;
USE akad_081;

-- 1. PENGHAPUSAN TABEL DENGAN URUTAN TERBALIK (ANAK KE INDUK)
DROP TABLE IF EXISTS detail_krs;
DROP TABLE IF EXISTS krs;
DROP TABLE IF EXISTS kelas;
DROP TABLE IF EXISTS mata_kuliah;
DROP TABLE IF EXISTS mahasiswa;
DROP TABLE IF EXISTS dosen;

-- 2. PEMBUATAN TABEL MASTER (INDUK)

-- Tabel Master: Dosen
CREATE TABLE dosen (
    id_dosen INT NOT NULL AUTO_INCREMENT,
    nip_dosen VARCHAR(18) NOT NULL,
    nama_dosen VARCHAR(100) NOT NULL,
    email_dosen VARCHAR(100) NOT NULL,
    no_hp_dosen VARCHAR(15) NULL,
    PRIMARY KEY (id_dosen),
    CONSTRAINT uq_dosen_nip UNIQUE (nip_dosen),
    CONSTRAINT uq_dosen_email UNIQUE (email_dosen)
) ENGINE=InnoDB;

-- Tabel Master: Mahasiswa
CREATE TABLE mahasiswa (
    id_mhs INT NOT NULL AUTO_INCREMENT,
    npm_mahasiswa CHAR(10) NOT NULL,
    nama_mahasiswa VARCHAR(100) NOT NULL,
    prodi_mahasiswa VARCHAR(60) NOT NULL,
    angkatan_mahasiswa YEAR NOT NULL,
    status_aktif_mahasiswa ENUM('Aktif', 'Cuti', 'Lulus') NOT NULL DEFAULT 'Aktif',
    email_pribadi_mahasiswa VARCHAR(100) NOT NULL,
    no_hp_mahasiswa VARCHAR(15) NULL,
    id_dosen_pa INT NULL,
    PRIMARY KEY (id_mhs),
    CONSTRAINT uq_mhs_npm UNIQUE (npm_mahasiswa),
    CONSTRAINT uq_mhs_email UNIQUE (email_pribadi_mahasiswa),
    CONSTRAINT fk_mhs_dosen_pa FOREIGN KEY (id_dosen_pa) 
        REFERENCES dosen (id_dosen) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Tabel Master: Mata Kuliah
CREATE TABLE mata_kuliah (
    id_mk INT NOT NULL AUTO_INCREMENT,
    kode_mk VARCHAR(10) NOT NULL,
    nama_mk VARCHAR(100) NOT NULL,
    sks_mk TINYINT NOT NULL,
    semester_penawaran_mk TINYINT NOT NULL,
    PRIMARY KEY (id_mk),
    CONSTRAINT uq_mk_kode UNIQUE (kode_mk),
    CONSTRAINT ck_mk_sks CHECK (sks_mk > 0 AND sks_mk <= 6),
    CONSTRAINT ck_mk_semester CHECK (semester_penawaran_mk >= 1 AND semester_penawaran_mk <= 8)
) ENGINE=InnoDB;

-- 3. PEMBUATAN TABEL TRANSAKSI KEPALA & DETAIL (ANAK)

-- Tabel Transaksi: Kelas
CREATE TABLE kelas (
    id_kelas INT NOT NULL AUTO_INCREMENT,
    kode_kelas VARCHAR(15) NOT NULL,
    id_mk INT NOT NULL,
    id_dosen_pengampu INT NOT NULL,
    ruangan_kelas VARCHAR(20) NOT NULL,
    kuota_kelas SMALLINT NOT NULL DEFAULT 40,
    hari_kelas ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu') NOT NULL,
    jam_kelas VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_kelas),
    CONSTRAINT uq_kelas_kode UNIQUE (kode_kelas),
    CONSTRAINT fk_kelas_mk FOREIGN KEY (id_mk) 
        REFERENCES mata_kuliah (id_mk),
    CONSTRAINT fk_kelas_dosen FOREIGN KEY (id_dosen_pengampu) 
        REFERENCES dosen (id_dosen),
    CONSTRAINT ck_kelas_kuota CHECK (kuota_kelas > 0)
) ENGINE=InnoDB;

-- Tabel Transaksi Utama: KRS (Kepala Nota KRS)
CREATE TABLE krs (
    id_krs INT NOT NULL AUTO_INCREMENT,
    no_krs VARCHAR(20) NOT NULL,
    id_mhs INT NOT NULL,
    tahun_ajaran_krs VARCHAR(9) NOT NULL,
    semester_krs ENUM('Ganjil', 'Genap') NOT NULL,
    tgl_pengajuan_krs DATE NOT NULL,
    status_persetujuan_krs ENUM('Diproses', 'Disetujui', 'Ditolak') NOT NULL DEFAULT 'Diproses',
    PRIMARY KEY (id_krs),
    CONSTRAINT uq_krs_no UNIQUE (no_krs),
    CONSTRAINT fk_krs_mhs FOREIGN KEY (id_mhs) 
        REFERENCES mahasiswa (id_mhs) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Tabel Transaksi Detail: Detail KRS
CREATE TABLE detail_krs (
    id_krs INT NOT NULL,
    id_kelas INT NOT NULL,
    nilai_angka_detail_krs DECIMAL(5,2) NULL,
    nilai_huruf_detail_krs ENUM('A', 'B', 'C', 'D', 'E') NULL,
    PRIMARY KEY (id_krs, id_kelas),
    CONSTRAINT fk_detail_krs_head FOREIGN KEY (id_krs) 
        REFERENCES krs (id_krs) ON DELETE CASCADE,
    CONSTRAINT fk_detail_krs_kelas FOREIGN KEY (id_kelas) 
        REFERENCES kelas (id_kelas),
    CONSTRAINT ck_detail_krs_nilai CHECK (nilai_angka_detail_krs IS NULL OR (nilai_angka_detail_krs >= 0.00 AND nilai_angka_detail_krs <= 100.00))
) ENGINE=InnoDB;