USE kopma_081_uji; 
DROP TABLE IF EXISTS mahasiswa; 
CREATE TABLE mahasiswa (npm_mahasiswa VARCHAR(20) PRIMARY KEY, nama_mahasiswa VARCHAR(100) NOT NULL, prodi_mahasiswa VARCHAR(50) NOT NULL, angkatan_mahasiswa INT NOT NULL, email_pribadi_mahasiswa VARCHAR(100), no_hp_mahasiswa VARCHAR(20), status_aktif_mahasiswa VARCHAR(20) NOT NULL); 
INSERT INTO mahasiswa VALUES ('25430081', 'Muhamad Adha Satria Ardiansyah', 'Ilmu Komputer', 2025, 'adhasatria@gmail.com', '081234567890', 'Aktif'); 
