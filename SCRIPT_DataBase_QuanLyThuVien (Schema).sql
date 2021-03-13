-- ========================================================================
-- ===               DATABASE QUẢN LÝ THƯ VIỆN                          ===
-- ===          ĐỒ ÁN LÝ THUYẾT - CƠ SỞ DỮ LIỆU NÂNG CAO                ===
-- ========================================================================




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
	MaNXB VARCHAR(6) PRIMARY KEY,
	TenNXB NVARCHAR(50) NOT NULL,
	DiaChi_NXB NVARCHAR(50) NOT NULL,
	SDT_NXB CHAR(10) NOT NULL,
	Email_NXB VARCHAR(50) NOT NULL
)
GO

-- Sách được giới thiệu
CREATE TABLE SachGioiThieu
(
	MaSGT VARCHAR(10) PRIMARY KEY,
	TenSGT NVARCHAR(50) NOT NULL,
	GiaBan MONEY NOT NULL,
	TacGia NVARCHAR(50) NOT NULL,
	NhaXB VARCHAR(6) NOT NULL
)
GO

-- Sách do nhà xuất bản nào xuất bản
CREATE TABLE Sach_NXB
(
	MaNXB VARCHAR(6),
	MaSGT VARCHAR(10),
	NgayXB DATETIME NOT NULL DEFAULT GETDATE(),
	SoLuong INT DEFAULT 1

	PRIMARY KEY (MaNXB, MaSGT)
)
GO

-- Nhóm sách
CREATE TABLE NhomSach
(
	MaNhom VARCHAR(4) PRIMARY KEY,
	TenNhom NVARCHAR(40) NOT NULL
)
GO

-- Loại sách
CREATE TABLE LoaiSach
(
	MaLoai VARCHAR(5) PRIMARY KEY,
	TenLoai NVARCHAR(40) NOT NULL,
	NhomSach VARCHAR(4) NOT NULL
)
GO

-- Nhà thanh lý
CREATE TABLE NhaThanhLy
(
	MaNTL VARCHAR(6) PRIMARY KEY,
	TenNTL NVARCHAR(40) NOT NULL,
	DiaChi_NTL NVARCHAR(50) NOT NULL,
	SDT_NTL CHAR(10) NOT NULL,
	Email_NTL VARCHAR(50) NOT NULL
)
GO

-- Phiếu thanh lý sách
CREATE TABLE PhieuThanhLy
(
	MaPTL VARCHAR(10) PRIMARY KEY,
	NgayLapPTL DATETIME NOT NULL DEFAULT GETDATE(),
	NhaThanhLy VARCHAR(6) NOT NULL
)
GO

-- Sách
CREATE TABLE Sach 
(
	MaSach VARCHAR(10) PRIMARY KEY,
	TenSach NVARCHAR(50) NOT NULL,
	TacGia NVARCHAR(50) NOT NULL,
	GiaSach MONEY NOT NULL,
	TapThu TINYINT NOT NULL,
	CuonThu TINYINT NOT NULL,
	SoLuongLuuTru INT DEFAULT 1,
	DaMuon INT DEFAULT 0,
	LoaiSach VARCHAR(5) NOT NULL,
	NXB VARCHAR(6) NOT NULL
)
GO

-- Danh sách sách thanh lý
CREATE TABLE DS_SachThanhLy
(
	MaPTL VARCHAR(10),
	MaSach VARCHAR(10),
	ThoiGianCho DATETIME NOT NULL,
	KTSaoLuu BIT NOT NULL DEFAULT 1, -- 0: chưa kiểm tra, 1: đã kiểm tra

	PRIMARY KEY (MaPTL, MaSach)
)
GO

-- Khoa
CREATE TABLE Khoa
(
	MaKhoa VARCHAR(5) PRIMARY KEY,
	TenKhoa NVARCHAR(30) NOT NULL,
	SDT_Khoa CHAR(10) NOT NULL,
	Email_Khoa VARCHAR(50) NOT NULL
)
GO

-- Phiếu đề nghị mua sách
CREATE TABLE PhieuDeNghiMuaSach
(
	MaPhieu VARCHAR(10) PRIMARY KEY,
	NgayLapPDN DATETIME NOT NULL DEFAULT GETDATE(),
	Khoa VARCHAR(5)
)
GO

-- Sách muốn mua trong phiếu đề nghị mua
CREATE TABLE SachMuonMua
(
	MaPhieu VARCHAR(10),
	MaSGT VARCHAR(10),
	SoLuong INT NOT NULL DEFAULT 1

	PRIMARY KEY (MaPhieu, MaSGT)
)
GO

-- Nhân viên
CREATE TABLE NhanVien
(
	MaNV VARCHAR(4) PRIMARY KEY,
	TenNV NVARCHAR(50) NOT NULL,
	NgaySinh_NV DATETIME,
	GioiTinh_NV NVARCHAR(3) NOT NULL,
	SDT_NV CHAR(10) NOT NULL,
	Email_NV VARCHAR(50) NOT NULL,
	CongViec NVARCHAR(50) NOT NULL,
	Luong MONEY NOT NULL
)
GO

-- Phiếu mua sách
CREATE TABLE PhieuMuaSach
(
	MaPhieuMua VARCHAR(10) PRIMARY KEY,
	NgayLapPMS DATETIME NOT NULL DEFAULT GETDATE(),
	NhanVien VARCHAR(4) NOT NULL
)
GO

-- Chi tiết phiếu mua sách
CREATE TABLE ChiTietPhieuMua
(
	MaPMS VARCHAR(10),
	MaSGT VARCHAR(10),
	SoLuong INT NOT NULL DEFAULT 1

	PRIMARY KEY (MaPMS, MaSGT)
)
GO

-- Đọc giả
CREATE TABLE DocGia
(
	MaDG VARCHAR(10) PRIMARY KEY,
	TenDG NVARCHAR(50) NOT NULL,
	SDT_DG CHAR(10) NOT NULL,
	Email_DG VARCHAR(50) NOT NULL,
	TrangThaiDG BIT NOT NULL DEFAULT 1, -- 0: Bị tước quyền đọc giả, 1: bình thường
)
GO

-- Thẻ thư viện
CREATE TABLE TheThuVien
(
	MaThe VARCHAR(10) PRIMARY KEY,
	NgayCap DATETIME NOT NULL DEFAULT GETDATE(),
	HSD DATETIME DEFAULT MONTH(GETDATE()) + '/' + DAY(GETDATE()) + '/' + YEAR(GETDATE()) + 4,
	DocGia VARCHAR(10) NOT NULL
)
GO

-- Sinh Viên
CREATE TABLE SinhVien
(
	MaDG VARCHAR(10) PRIMARY KEY,
	MSSV VARCHAR(10) UNIQUE
)
GO

-- Cán bộ
CREATE TABLE CanBo
(
	MaDG VARCHAR(10) PRIMARY KEY,
	MSCB VARCHAR(10) UNIQUE,
	HinhThucDaoTao NVARCHAR(50),
	Truong NVARCHAR(50) DEFAULT NULL -- NULL = cán bộ trong trường
)
GO

-- Khoá học hướng dẫn sử dụng thư viện
CREATE TABLE KhoaHDSD
(	
	NgayHoc DATETIME PRIMARY KEY,
	SoDocGia INT NOT NULL DEFAULT 30
)
GO

-- Đăng ký học hướng dẫn sử dụng thự viện
CREATE TABLE DK_HDSD
(
	NgayHoc DATETIME,
	MaDG VARCHAR(10), 
	DaThamGia BIT DEFAULT 0, -- 0: chưa học, 1: đã học

	PRIMARY KEY (NgayHoc, MaDG)
)
GO

-- Ý kiến đọc giả về sách mới xuất bản
CREATE TABLE Y_KienDocGia
(
	MaDG VARCHAR(10),
	MaSGT  VARCHAR(10),
	NhanXet NVARCHAR(50),
	DanhGia BIT NOT NULL DEFAULT 1, -- 0: không nên mua, 1: nên mua

	PRIMARY KEY (MaDG, MaSGT)
)
GO

-- Lịch sử mượn sách
CREATE TABLE LS_MuonSach
(
	MaDG VARCHAR(10),
	MaSach VARCHAR(10),
	ThoiGianMuon DATETIME DEFAULT GETDATE(),
	HanMuon DATETIME DEFAULT GETDATE() + 14,
	ThoiGianTra DATETIME DEFAULT NULL, -- NULL = Đang mượn, chưa trả sách lại thư viện
	TienPhat MONEY DEFAULT 0,
	TinhTrangMuon NVARCHAR(50) NOT NULL DEFAULT N'Bình thường',
	TinhTrangTra NVARCHAR(50) DEFAULT NULL,
	TienBoiThuong MONEY DEFAULT 0

	PRIMARY KEY (MaDG, MaSach, ThoiGianMuon)
)
GO






--     THIẾT ĐẶT CÁC KHÓA NGOẠI THAM CHIẾU
-- ============================================================================================

ALTER TABLE SachGioiThieu ADD
	CONSTRAINT FK_SachGioiThieu_NhaXuatBan FOREIGN KEY (NhaXB) REFERENCES NhaXuatBan(MaNXB)

ALTER TABLE Sach_NXB ADD
	CONSTRAINT FK_Sach_NXB_NhaXuatBan FOREIGN KEY (MaNXB) REFERENCES NhaXuatBan(MaNXB) 

ALTER TABLE Sach_NXB ADD
	CONSTRAINT FK_Sach_NXB_SachGioiThieu FOREIGN KEY (MaSGT) REFERENCES SachGioiThieu(MaSGT)

ALTER TABLE LoaiSach ADD
	CONSTRAINT FK_LoaiSach_NhomSach FOREIGN KEY (NhomSach) REFERENCES NhomSach(MaNhom)
	
ALTER TABLE PhieuThanhLy ADD
	CONSTRAINT FK_PhieuThanhLy_NhaThanhLy FOREIGN KEY (NhaThanhLy) REFERENCES NhaThanhLy(MaNTL)

ALTER TABLE Sach ADD
	CONSTRAINT FK_Sach_LoaiSach FOREIGN KEY (LoaiSach) REFERENCES LoaiSach(MaLoai)

ALTER TABLE Sach ADD
	CONSTRAINT FK_Sach_NhaXuatBan FOREIGN KEY (NXB) REFERENCES NhaXuatBan(MaNXB)

ALTER TABLE DS_SachThanhLy ADD
	CONSTRAINT FK_DS_SachThanhLy_PhieuThanhLy FOREIGN KEY (MaPTL) REFERENCES PhieuThanhLy(MaPTL)

ALTER TABLE DS_SachThanhLy ADD
	CONSTRAINT FK_DS_SachThanhLy_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)

ALTER TABLE PhieuDeNghiMuaSach ADD
	CONSTRAINT FK_PhieuDeNghiMuaSach_Khoa FOREIGN KEY (Khoa) REFERENCES Khoa(MaKhoa)
	
ALTER TABLE SachMuonMua ADD
	CONSTRAINT FK_SachMuonMua_PhieuDeNghiMuaSach FOREIGN KEY (MaPhieu) REFERENCES PhieuDeNghiMuaSach(MaPhieu)

ALTER TABLE SachMuonMua ADD
	CONSTRAINT FK_SachMuonMua_SachGioiThieu FOREIGN KEY (MaSGT) REFERENCES SachGioiThieu(MaSGT)

ALTER TABLE PhieuMuaSach ADD
	CONSTRAINT FK_PhieuMuaSach_NhanVien FOREIGN KEY (NhanVien) REFERENCES NhanVien(MaNV)

ALTER TABLE ChiTietPhieuMua ADD
	CONSTRAINT FK_PhieuMuaSach_PhieuMuaSach FOREIGN KEY (MaPMS) REFERENCES PhieuMuaSach(MaPhieuMua)

ALTER TABLE ChiTietPhieuMua ADD
	CONSTRAINT FK_PhieuMuaSach_SachGioiThieu FOREIGN KEY (MaSGT) REFERENCES SachGioiThieu(MaSGT)

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
	CONSTRAINT FK_Y_KienDocGia_SachGioiThieu FOREIGN KEY (MaSGT) REFERENCES SachGioiThieu(MaSGT)

ALTER TABLE LS_MuonSach ADD
	CONSTRAINT FK_LS_MuonSach_DocGia FOREIGN KEY (MaDG) REFERENCES DocGia(MaDG)

ALTER TABLE LS_MuonSach ADD
	CONSTRAINT FK_LS_MuonSach_Sach FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)




--     THIẾT ĐẶT CÁC RÀNG BUỘC TOÀN VẸN
-- ============================================================================================

-- 1. Giới tính là Nam hoặc Nữ
ALTER TABLE NhanVien ADD
	CONSTRAINT CHECK_GENDER CHECK (GioiTinh_NV like N'Nam' OR GioiTinh_NV like N'Nữ')

-- 2. Số đọc giả tham gia khóa học HDSD phải từ 30
ALTER TABLE KhoaHDSD ADD
	CONSTRAINT CHECK_SoDG CHECK (SoDocGia >= 30)

-- 3. Tuổi của nhân viên phải từ 18 - 60
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

-- 4. Khi sách được mượn sẽ cập nhật lại số sách đã mượn
CREATE TRIGGER CapNhat_Muon
ON LS_MuonSach
FOR INSERT
AS
BEGIN
	DECLARE @I INT = 0
	SELECT @I = COUNT(*) FROM LS_MuonSach LS, inserted I
				WHERE I.MaDG = LS.MaDG
				AND LS.ThoiGianTra IS NULL

	IF (@I >= 2)
	BEGIN
		PRINT N'Chỉ mượn tối đa 2 quyển sách'
		ROLLBACK;
	END
	ELSE 
		BEGIN
			DECLARE @MaSach VARCHAR(10)
			SELECT @MaSach = S.MaSach FROM Sach S, inserted I
			WHERE S.MaSach = I.MaSach

			IF ((SELECT S1.SoLuongLuuTru - S1.DaMuon FROM Sach S1 WHERE S1.MaSach = @MaSach) < 1)
			BEGIN
				PRINT N'Không còn sách để mượn'
				ROLLBACK;
			END
			ELSE
				UPDATE Sach SET DaMuon = DaMuon + 1 WHERE MaSach = @MaSach
		END
END
GO

-- 5. Thuộc tính DaMuon được cập nhật tự động, không nhập từ bàn phím khi thêm mới sách
CREATE TRIGGER tr_DaMuon
ON Sach
FOR INSERT
AS
BEGIN
	IF ((SELECT DaMuon FROM inserted) IS NOT NULL)
	BEGIN
		PRINT N'Không nhập thuộc tính DaMuon khi nhập mới sách'
		ROLLBACK;
	END
END
GO

-- 6. Khi trả sách cập nhật lại số sách đã mượn
CREATE TRIGGER CapNhat_Tra
ON LS_MuonSach
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaSach VARCHAR(10)

	IF ((SELECT ThoiGianTra FROM inserted) IS NOT NULL)
	BEGIN
		SELECT @MaSach = S.MaSach FROM Sach S, inserted I
		WHERE S.MaSach = I.MaSach
		UPDATE Sach SET DaMuon = DaMuon - 1 WHERE MaSach = @MaSach
	END
END
GO


-- 7. Số lượng sách >= 1
ALTER TABLE Sach_NXB ADD
	CONSTRAINT CHECK_Sach_NXB_SoLuong CHECK (SoLuong >= 1)

ALTER TABLE SachMuonMua ADD
	CONSTRAINT CHECK_SachMuonMua_SoLuong CHECK (SoLuong >= 1)

ALTER TABLE Sach ADD
	CONSTRAINT CHECK_Sach_SoLuong CHECK (SoLuongLuuTru >= 1)

-- 8. Thời gian chờ của một sách thuộc phiếu thanh lý phải sau ngày lập phiếu thanh lý
CREATE TRIGGER tr_ThoiGianCho
ON DS_SachThanhLy
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @ThoiGianCho DATETIME = (SELECT ThoiGianCho FROM inserted)
	DECLARE @NgayLapPTL DATETIME = (SELECT PTL.NgayLapPTL 
										FROM PhieuThanhLy PTL, Inserted I
										WHERE PTL.MaPTL = I.MaPTL)
	IF (@ThoiGianCho < @NgayLapPTL)
	BEGIN
		PRINT N'Sai thời gian chờ'
		ROLLBACK;
	END
END
GO

-- 9. Công việc chỉ có thể là thủ thư hoặc nhân viên thư viện
ALTER TABLE NhanVien ADD
	CONSTRAINT CHECK_NhanVien_CongViec CHECK (CongViec LIKE N'Thủ thư' OR CongViec LIKE N'Nhân viên thư viện')

-- 10. Nếu đã tham gia khóa học HDSD thì không đăng kí học nữa
CREATE TRIGGER tr_DK_HDSD
ON DK_HDSD
FOR INSERT, UPDATE
AS
BEGIN
	IF (EXISTS(SELECT * FROM inserted I, DK_HDSD DK
					WHERE I.MaDG = DK.MaDG
					AND DK.DaThamGia = 1))
	BEGIN
		PRINT N'Đã tham gia khóa học. Không được tham gia nữa'
		ROLLBACK;
	END
END
GO

-- 11. Ngày cấp thẻ thư viện phải sau ngày mà đọc giả hoàn thành khóa học HDSD
CREATE TRIGGER tr_NgayCapThe
ON TheThuVien
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaDG CHAR(10) = (SELECT DocGia FROM inserted)

	IF (EXISTS (SELECT * FROM DK_HDSD
					WHERE MaDG = @MaDG
					AND DaThamGia = 1))
	BEGIN
		DECLARE @NgayHoc DATETIME = (SELECT NgayHoc FROM DK_HDSD
									WHERE MaDG = @MaDG
									AND DaThamGia = 1)
		IF ((SELECT NgayCap FROM inserted) < @NgayHoc)
		BEGIN
			PRINT N'Ngày cấp phải sau ngày học HDSD'
			ROLLBACK;
		END
	END
END
GO

-- 12. Hạn mượn, thời gian trả sách phải từ thời gian mượn về sau	
ALTER TABLE LS_MuonSach ADD
	CONSTRAINT FK_LS_MuonSach_Check CHECK (HanMuon >= ThoiGianMuon AND ThoiGianTra >= ThoiGianMuon)

-- 13. Thuộc tính HSD được hệ thống tự động INSERT sau khi thêm một thẻ thư viện, không cần nhập vào tử bàn phím
CREATE TRIGGER tr_HSD
ON TheThuVien
FOR INSERT
AS
BEGIN
	IF ((SELECT HSD FROM inserted) IS NOT NULL)
	BEGIN
		PRINT N'Không nhập HSD cho thẻ thư viện, hệ thống sẽ tự tính'
		ROLLBACK;
	END
END
GO


-- 14. Sau khi cập nhật ngày trả sách, hệ thống tự động cập nhật lại tiền phạt
--  Tính tiền phạt
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
			SET @Tien = 30000 + (@SoNgayTre - 30) * 2000 + @TienBoiThuong
		END

	RETURN @Tien
END
GO

CREATE TRIGGER TienPhat
ON LS_MuonSach
AFTER UPDATE
AS
BEGIN
	IF ((SELECT ThoiGianTra FROM inserted) IS NOT NULL)
	BEGIN
		DECLARE @MaDG CHAR(10) = (SELECT MaDG FROM inserted)
		DECLARE @MaSach CHAR(10) = (SELECT MaSach FROM inserted)
		DECLARE @ThoiGianMuon CHAR(10) = (SELECT ThoiGianMuon FROM inserted)

		UPDATE LS_MuonSach SET TienPhat = dbo.TinhTienPhat(@MaDG, @MaSach, @ThoiGianMuon)
		WHERE MaDG = @MaDG AND MaSach = @MaSach AND ThoiGianMuon = @ThoiGianMuon
	END	
END
GO

-- 15. Thuộc tính TienPhat không được Insert từ bàn phím, hệ thống sẽ tự cập nhật
CREATE TRIGGER tr_UpdateLS_MuonSach
ON LS_MuonSach
FOR INSERT
AS
BEGIN
	IF ((SELECT TienPhat FROM inserted) != 0)
	BEGIN
		PRINT N'Không nhập TienPhat từ bàn phím'
		ROLLBACK;
	END
END
GO
