-- ========================================================================
-- ===               DATABASE QUẢN LÝ THƯ VIỆN                          ===
-- ===          ĐỒ ÁN LÝ THUYẾT - CƠ SỞ DỮ LIỆU NÂNG CAO                ===
-- ========================================================================

-- Nhóm 12:
-- 18120534 - Hoàng Công Sơn
-- 18120553 - Nguyễn Lê Ngọc Tần
-- 18120614 - Nguyễn Văn Trị




--                      KHỞI TẠO DATABSE
-- ================================================================================================
-- Tạo database Quản lý thư viện
CREATE DATABASE QuanLyThuVien
GO

USE QuanLyThuVien
GO

-- Nhà xuất bản
CREATE TABLE NhaXuatBan
(
	MaNXB CHAR(10) PRIMARY KEY,
	TenNXB NVARCHAR(50),
	DiaChi_NXB NVARCHAR(50),
	SDT_NXB CHAR(10),
	Email_NXB VARCHAR(50)
)
GO

-- Nhóm sách
CREATE TABLE NhomSach
(
	MaNhom CHAR(10) PRIMARY KEY,
	TenNhom NVARCHAR(50)
)
GO

-- Loại sách
CREATE TABLE LoaiSach
(
	MaLoai CHAR(10) PRIMARY KEY,
	TenLoai NVARCHAR(50),
	NhomSach CHAR(10)
)
GO

-- Nhà thanh lý
CREATE TABLE NhaThanhLy
(
	MaNTL CHAR(10) PRIMARY KEY,
	TenNTL NVARCHAR(50),
	DiaChi_NTL NVARCHAR(50),
	SDT_NTL CHAR(10),
	Email_NTL VARCHAR(50)
)
GO

-- Phiếu thanh lý sách
CREATE TABLE PhieuThanhLy
(
	MaPTL CHAR(10) PRIMARY KEY,
	NgayLapPTL DATETIME DEFAULT GETDATE(),
	NhaThanhLy CHAR(10)
)
GO

-- Sách
CREATE TABLE Sach 
(
	MaSach CHAR(10) PRIMARY KEY,
	TenSach NVARCHAR(50),
	TacGia NVARCHAR(50),
	GiaSach MONEY,
	TapThu SMALLINT,
	CuonThu SMALLINT,
	SoLuongLuuTru INT DEFAULT 1,
	DaMuon INT DEFAULT 0,
	LoaiSach CHAR(10)
)
GO


-- Xuất bản sách
CREATE TABLE XuatBanSach
(
	MaNXB CHAR(10),
	MaSach CHAR(10),
	NgayXB DATETIME DEFAULT GETDATE(),
	SoLuong INT DEFAULT 1

	PRIMARY KEY (MaNXB, MaSach)
)
GO

-- Danh sách sách thanh lý
CREATE TABLE DS_SachThanhLy
(
	MaPTL CHAR(10),
	MaSach CHAR(10),
	ThoiGianCho DATETIME,
	KTSaoLuu BIT DEFAULT 1, -- 0: chưa kiểm tra, 1: đã kiểm tra

	PRIMARY KEY (MaPTL, MaSach)
)
GO

-- Khoa
CREATE TABLE Khoa
(
	MaKhoa CHAR(10) PRIMARY KEY,
	TenKhoa NVARCHAR(50),
	SDT_Khoa CHAR(10),
	Email_Khoa VARCHAR(50)
)
GO

-- Phiếu đề nghị mua sách
CREATE TABLE PhieuDeNghiMuaSach
(
	MaPhieu CHAR(10) PRIMARY KEY,
	NgayLapPDN DATETIME DEFAULT GETDATE(),
	Khoa CHAR(10)
)
GO

-- Sách muốn mua trong phiếu đề nghị mua
CREATE TABLE SachMuonMua
(
	MaPhieu CHAR(10),
	MaSach CHAR(10),
	SoLuong INT DEFAULT 1
)
GO

-- Nhân viên
CREATE TABLE NhanVien
(
	MaNV CHAR(10) PRIMARY KEY,
	TenNV NVARCHAR(50),
	NgaySinh_NV DATETIME,
	GioiTinh_NV NVARCHAR(3),
	SDT_NV CHAR(10),
	Email_NV VARCHAR(50),
	CongViec NVARCHAR(50),
	Luong MONEY
)
GO

-- Phiếu mua sách
CREATE TABLE PhieuMuaSach
(
	MaPhieuMua CHAR(10) PRIMARY KEY,
	NgayLapPMS DATETIME DEFAULT GETDATE(),
	NhanVien CHAR(10)
)
GO

-- Đọc giả
CREATE TABLE DocGia
(
	MaDG CHAR(10) PRIMARY KEY,
	TenDG NVARCHAR(50),
	SDT_DG CHAR(10),
	Email_DG VARCHAR(50),
	TrangThaiDG BIT DEFAULT 1, -- 0: Bị tước quyền đọc giả, 1: bình thường
)
GO

-- Thẻ thư viện
CREATE TABLE TheThuVien
(
	MaThe CHAR(10) PRIMARY KEY,
	NgayCap DATETIME DEFAULT GETDATE(),
	HSD DATETIME DEFAULT MONTH(GETDATE()) + '/' + DAY(GETDATE()) + '/' + YEAR(GETDATE()) + 4,
	DocGia CHAR(10)
)
GO

-- Sinh Viên
CREATE TABLE SinhVien
(
	MaDG CHAR(10) PRIMARY KEY,
	MSSV CHAR(10) UNIQUE
)
GO

-- Cán bộ
CREATE TABLE CanBo
(
	MaDG CHAR(10) PRIMARY KEY,
	MSCB CHAR(10) UNIQUE,
	HinhThucDaoTao NVARCHAR(50),
	Truong NVARCHAR(50) DEFAULT NULL -- NULL = cán bộ trong trường
)
GO

-- Khoá học hướng dẫn sử dụng thư viện
CREATE TABLE KhoaHDSD
(	
	NgayHoc DATETIME PRIMARY KEY,
	SoDocGia INT DEFAULT 30
)
GO

-- Đăng ký học hướng dẫn sử dụng thự viện
CREATE TABLE DK_HDSD
(
	NgayHoc DATETIME,
	MaDG CHAR(10), 
	DaThamGia BIT DEFAULT 0, -- 0: chưa học, 1: đã học

	PRIMARY KEY (NgayHoc, MaDG)
)
GO

-- Ý kiến đọc giả về sách mới xuất bản
CREATE TABLE Y_KienDocGia
(
	MaDG CHAR(10),
	MaSach  CHAR(10),
	NhanXet NVARCHAR(50),
	DanhGia BIT DEFAULT 1, -- 0: không nên mua, 1: nên mua

	PRIMARY KEY (MaDG, MaSach)
)
GO

-- Lịch sử mượn sách
CREATE TABLE LS_MuonSach
(
	MaDG CHAR(10),
	MaSach CHAR(10),
	ThoiGianMuon DATETIME DEFAULT GETDATE(),
	HanMuon DATETIME DEFAULT GETDATE() + 14,
	ThoiGianTra DATETIME DEFAULT NULL, -- NULL = Đang mượn, chưa trả sách lại thư viện
	TienPhat MONEY DEFAULT 0,
	TinhTrangMuon NVARCHAR(50) DEFAULT N'Bình thường',
	TinhTrangTra NVARCHAR(50) DEFAULT NULL,
	TienBoiThuong MONEY DEFAULT 0

	PRIMARY KEY (MaDG, MaSach, ThoiGianMuon)
)
GO






--     THIẾT ĐẶT CÁC KHÓA NGOẠI THAM CHIẾU
-- ============================================================================================

ALTER TABLE XuatBanSach ADD
	CONSTRAINT FK_XuatBanSach_NhaXuatBan FOREIGN KEY (MaNXB) REFERENCES NhaXuatBan(MaNXB) 

ALTER TABLE XuatBanSach ADD
	CONSTRAINT FK_XuatBanSach_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)

ALTER TABLE LoaiSach ADD
	CONSTRAINT FK_LoaiSach_NhomSach FOREIGN KEY (NhomSach) REFERENCES NhomSach(MaNhom)
	
ALTER TABLE PhieuThanhLy ADD
	CONSTRAINT FK_PhieuThanhLy_NhaThanhLy FOREIGN KEY (NhaThanhLy) REFERENCES NhaThanhLy(MaNTL)

ALTER TABLE Sach ADD
	CONSTRAINT FK_Sach_LoaiSach FOREIGN KEY (LoaiSach) REFERENCES LoaiSach(MaLoai)
 
ALTER TABLE PhieuDeNghiMuaSach ADD
	CONSTRAINT FK_PhieuDeNghiMuaSach_Khoa FOREIGN KEY (Khoa) REFERENCES Khoa(MaKhoa)
	
ALTER TABLE SachMuonMua ADD
	CONSTRAINT FK_SachMuonMua_PhieuDeNghiMuaSach FOREIGN KEY (MaPhieu) REFERENCES PhieuDeNghiMuaSach(MaPhieu)

ALTER TABLE SachMuonMua ADD
	CONSTRAINT FK_SachMuonMua_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)

ALTER TABLE PhieuMuaSach ADD
	CONSTRAINT FK_PhieuMuaSach_NhanVien FOREIGN KEY (NhanVien) REFERENCES NhanVien(MaNV)

ALTER TABLE TheThuVien ADD
	CONSTRAINT FK_TheThuVien_DocGia FOREIGN KEY (DocGia) REFERENCES DocGia(MaDG)

ALTER TABLE SinhVien ADD
	CONSTRAINT FK_SinhVien_DocGia FOREIGN KEY (MaDG) REFERENCES DocGia(MaDG)

ALTER TABLE CanBo ADD
	CONSTRAINT FK_CanBo_DocGia FOREIGN KEY (MaDG) REFERENCES DocGia(MaDG)

ALTER TABLE DK_HDSD ADD
	CONSTRAINT FK_DK_HDSD_DocGia FOREIGN KEY (MaDG) REFERENCES DocGia(MaDG)

ALTER TABLE DK_HDSD ADD
	CONSTRAINT FK_DK_HDSD_KhoaHDSD FOREIGN KEY (NgayHoc) REFERENCES KhoaHDSD(NgayHoc)

ALTER TABLE Y_KienDocGia ADD
	CONSTRAINT FK_Y_KienDocGia_DocGia FOREIGN KEY (MaDG) REFERENCES DocGia(MaDG)

ALTER TABLE Y_KienDocGia ADD
	CONSTRAINT FK_Y_KienDocGia_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)

ALTER TABLE LS_MuonSach ADD
	CONSTRAINT FK_LS_MuonSach_DocGia FOREIGN KEY (MaDG) REFERENCES DocGia(MaDG)

ALTER TABLE LS_MuonSach ADD
	CONSTRAINT FK_LS_MuonSach_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)




--     THIẾT ĐẶT CÁC RÀNG BUỘC TOÀN VẸN
-- ============================================================================================

-- Giới tính là Nam hoặc Nữ
ALTER TABLE NhanVien ADD
	CONSTRAINT CHECK_GENDER CHECK (GioiTinh_NV like N'Nam' OR GioiTinh_NV like N'Nữ')

-- Số đọc giả tham gia khóa học HDSD phải từ 30
ALTER TABLE KhoaHDSD ADD
	CONSTRAINT CHECK_SoDG CHECK (SoDocGia >= 30)

-- Tuổi của nhân viên phải từ 18 - 60
CREATE TRIGGER CHECK_AGE
ON NhanVien 
FOR INSERT
AS
BEGIN
	DECLARE @AGE INT = DATEDIFF(D, (SELECT NgaySinh_NV FROM Inserted), GETDATE())
	IF (@AGE < 18 OR @AGE > 60)
		ROLLBACK;
END
GO

-- Khi sách được mượn sẽ cập nhật lại số sách đã mượn
CREATE TRIGGER CapNhat_Muon
ON LS_MuonSach
FOR INSERT
AS
BEGIN
	DECLARE @I INT = 0
	SELECT @I = COUNT(*) FROM LS_MuonSach LS
				WHERE MaDG = LS.MaDG
				AND LS.ThoiGianTra IS NULL

	IF (@I >= 2)
		ROLLBACK;
	ELSE 
		BEGIN
			DECLARE @MaSach CHAR(10)
			SELECT @MaSach = S.MaSach FROM Sach S
			WHERE S.MaSach = MaSach

			IF ((SELECT S1.SoLuongLuuTru - S1.DaMuon FROM Sach S1 WHERE S1.MaSach = @MaSach) < 1)
				ROLLBACK;
			ELSE
				UPDATE Sach SET DaMuon = DaMuon + 1 WHERE MaSach = @MaSach
		END
END
GO

-- Khi trả sách cập nhật lại số sách đã mượn
CREATE TRIGGER CapNhat_Tra
ON LS_MuonSach
FOR INSERT
AS
BEGIN
	DECLARE @MaSach CHAR(10)
	SELECT @MaSach = S.MaSach FROM Sach S
	WHERE S.MaSach = MaSach
	UPDATE Sach SET DaMuon = DaMuon - 1 WHERE MaSach = @MaSach
END
GO




--==========================================================================================
-- CÁC HÀM XỬ LÝ

-- Tính tiền phạt
CREATE FUNCTION TinhTienPhat (@MaDocGia CHAR(10), @MaSach CHAR(10), @ThoiGianMuon DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @Tien MONEY = 0
	DECLARE @SoNgayTre INT = DATEDIFF(D, @ThoiGianMuon, (SELECT ThoiGianTra FROM LS_MuonSach WHERE MaDG = @MaDocGia AND MaSach = @MaSach AND ThoiGianMuon = @ThoiGianMuon))
	DECLARE @TienBoiThuong MONEY = (SELECT TienBoiThuong FROM LS_MuonSach WHERE MaDG = @MaDocGia AND MaSach = @MaSach AND ThoiGianMuon = @ThoiGianMuon)
	IF (@SoNgayTre <= 30)
		BEGIN
			SET @Tien = @SoNgayTre * 1000 + @TienBoiThuong
		END
	ELSE
		BEGIN
			SET @Tien = @SoNgayTre * 2000 + @TienBoiThuong
		END

	RETURN @Tien
END
GO

